<?php

namespace app\http\middleware;

use think\Request;
use app\common\model\User;

class OpenMiddleware
{
    private $error = FALSE;
    private $url = '';
    public function handle(Request $request, \Closure $next)
    {
        if ($_SERVER['SERVER_ADDR'] == '127.0.0.1') {
            $this->url = 'http://api.center.com';
        }else{
            $this->url = 'http://openapi.imliuchang.cn';
        }
        $start = microtime(true);
        $addData = [
            'module'         => $request->module(),
            'controller'     => $request->controller(),
            'action'         => $request->action(),
            'request_time'   => microtime(true),
            'request_source' => 'open_api',
            'return_time'    => time(),
            'method'         => $request->method(),
            'request_params' => json_encode($request->param()),
            'return_params'  => '',
            'response_time'  => 0,
            'error'          => 0,
        ];
        $pageSize = $request->param('page_size', '10', 'intval');
        if ($pageSize > 50) {
            $response = json(dataFormat(100100, '单页显示数量不能大于50'));
        } else {
            $user = $this->getUser($request);
            if ($this->error) {
                $response = $user;
            }else{
                $request->user = $user;
                $response = $next($request, $user);
            }
        }
        $end = microtime(true);
        $data = $response->getData();
        $addData['error'] = isset($data['code']) ? $data['code'] : 0;
        $addData['msg'] = isset($data['msg']) ? $data['msg'] : '';
        $addData['response_time'] = $end - $start;
        $addData['return_params'] = json_encode($data);
        db('apilog_app')->insertGetId($addData);
        return $response;
    }
    private function getUser($request)
    {
        $params = $request->param();
        $thirdOpenid = isset($params['openid']) ? trim($params['openid']) : '';
        $developerId = isset($params['developer_id']) ? trim($params['developer_id']) : '';
        if (!$developerId) {
            $this->error = TRUE;
            return json(dataFormat('-2', 'invalid url'));
        }else{
            if (!$thirdOpenid) {
                $this->error = TRUE;
                return json(dataFormat('001001', 'missing openid'));
            }else{
                //验证openid准确性
                $token = $request->header('echodata-token');
                $url = $this->url.'/v1/user/info';
                $post = [
                    'openid' => $thirdOpenid,
                ];
                $header = [
                    'echodata-token:'.$token,
                ];
                $result = curl_post_https($url, $post, $header);
                if ($result['code'] !== 0) {
                    $this->error = TRUE;
                    return json(dataFormat($result['code'], $result['msg']));
                }
                $udata = isset($result['data']) ? $result['data'] : [];
                $appid = $udata && isset($udata['appid']) ? $udata['appid'] : '';
                $udataModel = model('user_data');
                $where = [
                    ['third_openid',    '=', $thirdOpenid],
                    ['is_del',          '=', 0],
                    ['third_type',      '=', 'echodata'],
                    ['user_type',       '=', 'open'],
                ];
                $user = $udataModel->where($where)->find();
                $user = $user ? $user->toArray() : [];
                if (!$user) {
                    $storeId = 0;
                    if ($appid) {
                        //判断appid对应商户是否存在
                        $storeModel = new \app\common\model\Store();
                        $store = $storeModel->alias('S')->join('store_echodata SE', 'SE.store_id = S.store_id', 'INNER')->where(['S.is_del' => 0, 'SE.appid' => $appid])->find();
                        if (!$store) {
                            $data = ['appid' => $appid, 'developer_id' => $developerId, 'store_type' => 5, 'config_json' => ''];
                            $result = $storeModel->save($data);
                            if (!$result) {
                                $this->error = TRUE;
                                return json(dataFormat('-4', 'abnormal parameter'));
                            }
                            $storeId = $storeModel->store_id;
                        }else{
                            $storeId = $store['store_id'];
                        }
                    }
                    $userService = new \app\common\model\User();
                    $openid = $userService->getUserOpenid();
                    $data = [
                        'openid'      => $openid,
                        'factory_id'  => $storeId,
                        'third_type'  => 'echodata',
                        'user_type'   => 'open',
                        'appid'       => $appid,
                        'third_openid'=> $thirdOpenid,
                        'avatar'      => $udata && isset($udata['avatar']) ? $udata['avatar'] : '',
                        'nickname'    => $udata && isset($udata['nickname']) ? $udata['nickname'] : '',
                        'gender'      => $udata && isset($udata['gender']) ? intval($udata['gender']) : '',
                        'phone'       => $udata && isset($udata['phone']) ? intval($udata['phone']) : '',
                        'unionid'     => '',
                    ];
                    $result = $udataModel->save($data);
                    if (!$result) {
                        $this->error = TRUE;
                        return json(dataFormat('001001', 'missing openid'));
                    }
                    $data['udata_id'] = $udataModel->udata_id;
                    $user = $data;
                }else{
                    $udataId = $user['udata_id'];
                }
                return $user;
            }
        }
    }
}