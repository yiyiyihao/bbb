<?php
namespace app\index\controller;

use app\common\controller\Base;

class Merchant extends Base
{
    public $codeType = 'register';
    function __construct(){
        parent::__construct();
    }
    //商家申请入驻
    public function apply()
    {
        $params = $this->request->param();
        $storeNo = isset($params['store_no']) ? $params['store_no'] : '';
        if (!$storeNo) {
            $this->error(lang('param_error'));
        }
        $storeModel = new \app\common\model\Store();
        $factory = $storeModel->where(['store_no' => $storeNo, 'store_type' => STORE_FACTORY, 'is_del' => 0, 'status' => 1])->find();
        if (!$factory) {
            $this->error(lang('param_error'));
        }
        $types = [
            STORE_DEALER => [
                'name' => '零售商',
                'desc' => '适合拥有线下或线上销售渠道的商户',
                'admin_type' => ADMIN_DEALER,
                'group_id'   => GROUP_DEALER,
            ],
            STORE_CHANNEL => [
                'name' => '渠道商',
                'desc' => '拥有一定的市场资源，有能力发展零售商的商户',
                'admin_type' => ADMIN_CHANNEL,
                'group_id'   => GROUP_CHANNEL,
            ],
            STORE_SERVICE => [
                'name' => '服务商',
                'desc' => '拥有售后安装，维修能力或资源，能够提供售后服务的商户',
                'admin_type' => ADMIN_SERVICE,
                'group_id'   => GROUP_SERVICE,
            ],
        ];
        if (IS_POST) {
            $step = isset($params['step']) ? intval($params['step']) : 1;
            $userModel = new \app\common\model\User();
            $factoryId = $factory['store_id'];
            switch ($step) {
                case 2:
                case 3:
                    $type = isset($params['type']) ? intval($params['type']) : 0;
                    $channelNo = isset($params['channel_no']) ? trim($params['channel_no']) : '';
                    $name = $params && isset($params['name']) ? trim($params['name']) : '';
                    $userName = $params && isset($params['user_name']) ? trim($params['user_name']) : '';
                    if (!$name) {
                        $this->error(lang('商户名称不能为空'));
                    }
                    if (!$userName) {
                        $this->error(lang('联系人姓名不能为空'));
                    }
                    $where = ['name' => $name, 'is_del' => 0, 'factory_id' => $factoryId, 'store_type' => $type];
                    $exist = $storeModel->where($where)->find();
                    if($exist){
                        $this->error('当前'.$types[$type]['name'].'名称已存在');
                    }
                    if ($type == STORE_DEALER) {
                        if (!$channelNo) {
                            $this->error(lang('请填写渠道商编号'));
                        }
                        $channel = $storeModel->where(['store_no' => $channelNo, 'store_type' => STORE_CHANNEL, 'is_del' => 0, 'status' => 1])->find();
                        if (!$channel) {
                            $this->error(lang('渠道商不存在或已删除'));
                        }
                        if ($type == STORE_DEALER) {
                            $params['ostore_id'] = $channel['store_id'];
                        }
                    }
                    if ($step == 2) {
                        $this->success();
                        break;
                    }
                case 3:
                    $allow = isset($params['allow']) ? trim($params['allow']) : '';
                    $phone = isset($params['phone']) ? trim($params['phone']) : '';
                    if (!$userName) {
                        $this->error(lang('联系人姓名不能为空'));
                    }
                    if (!$phone) {
                        $this->error(lang('请填写手机号码'));
                    }
                    $result = $userModel->checkPhone($factoryId, $phone, TRUE);
                    if ($result === FALSE) {
                        $this->error($userModel->error);
                    }
                    if ($step == 1) {
                        $code = isset($params['code']) ? trim($params['code']) : '';
                        if (!$code) {
                            $this->error(lang('验证码不能为空'));
                        }
                    }
                    $password = isset($params['password']) ? trim($params['password']) : '';
                    $rePassword = isset($params['repassword']) ? trim($params['repassword']) : '';
                    if ($password != $rePassword) {
                        $this->error(lang('两次输入密码不一致'));
                    }
                    $extra = [
                        'password' => $password,
                    ];
                    $result = $userModel->checkFormat($factoryId, $extra);
                    if ($result === FALSE) {
                        $this->error($userModel->error);
                    }
                    if (!$allow) {
                        $this->error('请先同意用户协议');
                    }
                    break;
                default:
                    $this->error(lang('param_error'));
                break;
            }
            $codeModel = new \app\common\model\LogCode();
            $params['type'] = $this->codeType;
            $result = $codeModel->verifyCode($params);
            if ($result === FALSE) {
                $this->error($codeModel->error);
            }else{
                $params['store_type'] = $type;
                $params['factory_id'] = $factoryId;
                $params['mobile'] = $phone;
                unset($params['store_no']);
                $params['config_json'] = '';
                $storeId = $storeModel->save($params);
                if ($storeId) {
                    //新增账号
                    $params['username'] = $phone;
                    $params['admin_type'] = $types[$type]['admin_type'];
                    $params['store_id'] = $storeId;
                    $params['is_admin'] = 1;
                    $params['password'] = $userModel->pwdEncryption($password);
                    $params['nickname'] = $userName;
                    $params['realname'] = $userName;
                    $params['group_id'] = $types[$type]['group_id'];;
                    $result = $userModel->save($params);
                    if ($result === FALSE) {
                        $this->error('系统异常，请重新提交');
                    }else{
                        $this->success('申请入驻成功，请登录后查看审核进度');
                    }
                }else{
                    $this->error('系统异常，请重新提交');
                }
            }
        }else{
            $this->assign('types', $types);
            $this->assign('store_no', $storeNo);
            return $this->fetch();
        }
    }
    public function sendCode()
    {
        $params = $this->request->param();
        if (IS_POST) {
            $storeNo = isset($params['store_no']) ? $params['store_no'] : '';
            if (!$storeNo) {
                $this->error(lang('param_error'));
            }
            $storeModel = new \app\common\model\Store();
            $factory = $storeModel->where(['store_no' => $storeNo, 'store_type' => STORE_FACTORY, 'is_del' => 0, 'status' => 1])->find();
            if (!$factory) {
                $this->error(lang('param_error'));
            }
            $codeModel = new \app\common\model\LogCode();
            $phone = isset($params['phone']) ? trim($params['phone']) : '';
            $result = $codeModel->sendSmsCode($factory['store_id'], $phone, $this->codeType);
            if (!$result['status']) {
                $this->error($result['result']);
            }else{
                $this->success('验证码发送成功,请注意留意短信');
            }
        }else{
            $this->error(lang('param_error'));
        }
    }
}
