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
                $request->user = $user ? $user : [];
                $response = $next($request);
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
        $developerId = isset($params['developer_id']) ? trim($params['developer_id']) : '';
        if (!$developerId) {
            $this->error = TRUE;
            return json(dataFormat('-2', 'invalid url'));
        }else{
            $uri = $request->pathinfo();
            //不需要验证openid的接口
            $noVerifyRequest = [
                'v10/wechat/authorize_url', 'v10/wechat/userinfo',
            ];
            if (!in_array($uri, $noVerifyRequest)) {
                $echodataOpenid = isset($params['openid']) ? trim($params['openid']) : '';
                $openid = isset($params['openid']) ? trim($params['openid']) : '';
                if (!$openid) {
                    $this->error = TRUE;
                    return json(dataFormat('001001', 'missing openid'));
                }else{
                    $udataModel = model('user_data');
                    
                    $openid = isset($params['openid']) ? trim($params['openid']) : '';
                    $echodataAppid = isset($params['echodata_appid']) ? trim($params['echodata_appid']) : '';
                    $where = [
                        ['echodata_appid',  '=', $echodataAppid],
                        ['openid',          '=', $openid],
                        ['is_del',          '=', 0],
                        ['user_type',       '=', 'echodata'],
                    ];
                    $user = $udataModel->where($where)->find();
                    $user = $user ? $user->toArray() : [];
                    if (!$user) {
                        $this->error = TRUE;
                        return json(dataFormat('001002', 'user not exist'));
                    }
                    return $user;
                    
                    
                    
                    //验证openid准确性
                    $token = $request->header('echodata-token');
                    $url = $this->url.'/v1/user/info';
                    $post = [
                        'openid' => $echodataOpenid,
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
                    $echodataAppid = $udata && isset($udata['appid']) ? $udata['appid'] : '';
                    
                    $where = [
                        ['echodata_appid',  '=', $echodataAppid],
                        ['echodata_openid', '=', $echodataOpenid],
                        ['is_del',          '=', 0],
                        ['third_type',      '=', 'echodata'],
                        ['user_type',       '=', 'open'],
                    ];
                    $user = $udataModel->where($where)->find();
                    $user = $user ? $user->toArray() : [];
                    if (!$user) {
                        $storeId = 0;
//                         if ($echodataAppid) {
//                             //判断appid对应商户是否存在
//                             $storeModel = new \app\common\model\Store();
//                             $store = $storeModel->alias('S')->join('store_echodata SE', 'SE.store_id = S.store_id', 'INNER')->where(['S.is_del' => 0, 'SE.appid' => $echodataAppid])->find();
//                             if (!$store) {
//                                 $data = ['appid' => $echodataAppid, 'developer_id' => $developerId, 'store_type' => 5, 'config_json' => ''];
//                                 $result = $storeModel->save($data);
//                                 if (!$result) {
//                                     $this->error = TRUE;
//                                     return json(dataFormat('-4', 'abnormal parameter'));
//                                 }
//                                 $storeId = $storeModel->store_id;
//                             }else{
//                                 $storeId = $store['store_id'];
//                             }
//                         }
                        $userService = new \app\common\model\User();
                        $openid = $userService->getUserOpenid();
                        $data = [
                            'openid'      => $openid,
                            'factory_id'  => 1,
                            'third_type'  => 'echodata',
                            'user_type'   => 'open',
                            'echodata_appid'    => $echodataAppid,
                            'echodata_openid'   => $echodataOpenid,
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
}