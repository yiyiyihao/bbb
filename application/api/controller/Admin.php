<?php
namespace app\api\controller;
use app\common\model\Store;
use app\common\model\User;

class Admin extends Index
{
    private $visitIp;
    private $thirdType = 'wechat_h5';
    private $version;
    private $returnLogin = TRUE;
    private $debug = FALSE;
    public function __construct(){
        $origin = isset($_SERVER['HTTP_ORIGIN']) ? $_SERVER['HTTP_ORIGIN'] : '*';
        header('Access-Control-Allow-Origin:'.$origin);
        header('Access-Control-Allow-Methods:POST');
        header('Access-Control-Allow-Headers:x-requested-with,content-type');
        header('Access-Control-Allow-Credentials:true');
        $this->mchKey = '1458745225';
        parent::__construct();
        $this->version = isset($this->postParams['version']) ? trim($this->postParams['version']) : '';
        if (!$this->version) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('调用的接口版本不能为空')]);
        }
        if ($this->version != '1.0'){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('调用的接口版本错误')]);
        }
        if (isset($this->postParams['TEST']) && $this->postParams['TEST']) {
            $this->debug = TRUE;
        }
    }
    protected function logout()
    {
        session('api_user_data', []);
        session('api_admin_user', []);
        session('api_wechat_oauth', []);
        session('udata', []);
        session('api_source', '');
        $this->_returnMsg(['msg' => '登录数据清理成功']);
    }
    //获取当前登录状态
    protected function getLoginInfo()
    {
        $loginUser = session('api_admin_user');
        $sessionWechat = session('api_wechat_oauth');
        if ($loginUser) {
            $status = 1;//已登录
        }else{
            if ($sessionWechat) {
                $status = 2;//已未登录获取微信信息
            }else{
                $status = 0;//未登录
            }
        }
        $this->_returnMsg(['loginStatus' => $status]);
    }
    //上传图片
    protected function uploadImage($verifyUser = FALSE)
    {
        $this->returnLogin = FALSE;
        parent::uploadImage($verifyUser);
    }
    //上传图片
    protected function uploadImageSource($verifyUser = FALSE)
    {
        $this->returnLogin = FALSE;
        parent::uploadImageSource($verifyUser);
    }
    //发送短信验证码
    protected function sendSmsCode()
    {
        $this->returnLogin = FALSE;
        $type   = isset($this->postParams['type']) ? trim($this->postParams['type']) : '';
        if (!$type) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('短信类型不能为空')]);
        }
        if (!in_array($type,['register','change_phone'])){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('短信类型错误')]);
        }
        parent::sendSmsCode();
    }
    //短信验证码验证
    protected function checkSmsCode()
    {
        $this->returnLogin = FALSE;
        $type   = isset($this->postParams['type']) ? trim($this->postParams['type']) : '';
        $code   = isset($this->postParams['code']) ? trim($this->postParams['code']) : '';
        if (!$type) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('验证短信类型不能为空')]);
        }
        if (!in_array($type,['register','change_phone'])){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('短信类型错误')]);
        }
        ## @todo 测试专用
        if ($code == '666666') {
            $this->_returnMsg(['msg' => '验证成功']);
        }
        parent::checkSmsCode();
    }
    //微信授权-第1步
    protected function getWechatScope()
    {
        $wechatApi = new \app\common\api\WechatApi(0, $this->thirdType);
        $state = isset($this->postParams['state']) && trim($this->postParams['state']) ? trim($this->postParams['state']) : 'STATE';
        $appid = isset($wechatApi->config['appid']) ? trim($wechatApi->config['appid']) : '';
        $appsecret = isset($wechatApi->config['appsecret']) ? trim($wechatApi->config['appsecret']) : '';
        if (!$appid || !$appsecret) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'Appid/AppSecret配置不能为空']);
        }
        $url = 'http://h5.smarlife.cn';
        $url = 'http://h5.imliuchang.cn';
        $uri = urlEncode($url);
        $scopeUrl = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' . $appid . '&redirect_uri=' . $uri . '&response_type=code&scope=snsapi_userinfo&state='.$state.'#wechat_redirect';
        session('api_source', $state);
        $this->_returnMsg(['scopeUrl' => $scopeUrl, 'errLogin' => 1]);
    }
    //微信授权-第2步，返回微信Openid
    protected function getWechatOpenid()
    {
        $sessionWechat = session('api_wechat_oauth');
//         session('api_user_data', []);
        session('api_admin_user', []);
        $wechatApi = new \app\common\api\WechatApi(0, $this->thirdType);
        if (!$sessionWechat) {
            $code = isset($this->postParams['code']) ? trim($this->postParams['code']) : '';
            if (!$code) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => 'code不能为空']);
            }
            $result = $wechatApi->getOauthOpenid($code, TRUE);
            if ($result === FALSE) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => $wechatApi->error]);
            }
            session('api_wechat_oauth', $result);
        }else{
            $result = $sessionWechat;
        }
        //#TODO 删除模拟用户数据
        //$result=[
        //    'openid' => 'oU6IZxN9SBJqKDLvoCMYqsOfAwkg',
        //    'appid' => 'wxa57c32c95d2999e5',
        //    'nickname' => 'John',
        //    'sex' => 1,
        //    'language' => 'zh_CN',
        //    'city' => '深圳',
        //    'province' => '广东',
        //    'country' => '中国',
        //    'headimgurl' => 'http://thirdwx.qlogo.cn/mmopen/vi_32/6ntVHaKIrYePQicia4vSnzoCVlnjHDrOg5fwhiciaJmyDC785qC5ibMJdzDq3KF92ZzEaHCrBm2w8QsnPnh2TZbIEkg/132',
        //    'privilege' =>[],
        //];
        $userModel = new \app\common\model\User();
        $params = [
            'user_type'     => 'user',
            'appid'         => $result['appid'],
            'third_openid'  => $result['openid'],
            'nickname'      => isset($result['nickname']) ? trim($result['nickname']) : '',
            'avatar'        => isset($result['headimgurl']) ? trim($result['headimgurl']) : '',
            'gender'        => isset($result['sex']) ? intval($result['sex']) : 0,
            'unionid'       => isset($result['unionid']) ? trim($result['unionid']) : '',
            'third_type'    => $this->thirdType,
        ];
        $oauth = $userModel->authorized($this->factory['store_id'], $params);
        if ($oauth === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }
        //记录登陆信息
        session('api_user_data', $oauth);
        if (!$oauth['user_id']) {
            $this->_returnMsg(['msg' => '授权成功', 'errLogin' => 2]);
        }
        $this->_setLogin($oauth['user_id'], $result['openid']);
    }
    //绑定登录
    protected function login()
    {
        $udata = $this->_getScopeUser();
        $username = isset($this->postParams['username']) ? trim($this->postParams['username']) : '';
        $password = isset($this->postParams['password']) ? trim($this->postParams['password']) : '';
        if (!$username) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户名不能为空']);
        }
        if (!$password) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '密码不能为空']);
        }
        $userModel = new \app\common\model\User();
        //检查登录用户名/密码格式
        $extra = [
            'username' => $username,
            'password' => $password,
        ];
        $result = $userModel->checkFormat($this->factory['store_id'], $extra, FALSE);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }
        //判断登录用户名是否存在
        $where = [
            ['factory_id',  '=', $this->factory['store_id']],
            ['is_del',      '=', 0],
            ['username',    '=', $username],
            ['group_id',    '>', 0],
            ['admin_type',  'IN', [ADMIN_FACTORY, ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_SERVICE]],
            ['is_admin',    '>', 0],
        ];
        $user = $userModel->where($where)->find();
        if (!$user) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('USERNOTEXIST')]);
        }
        if ($userModel->pwdEncryption($password) != $user['password']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('PSW_ERROR')]);
        }
        //执行登录操作
        if(!$user['status']){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('LOGIN_FORBIDDEN')]);
        }
        //微信用户绑定
        $result = db('user_data')->where(['udata_id' => $udata['udata_id']])->update(['user_id' => $user['user_id'], 'update_time' => time()]);
        $this->_setLogin($user['user_id'], $udata['third_openid']);
    }
    //商户入驻-用户注册
    protected function applyStep1()
    {
        $udata = $this->_getScopeUser();
        $phone = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        $password = isset($this->postParams['password']) ? trim($this->postParams['password']) : '';
        $rePwd = isset($this->postParams['re_pwd']) ? trim($this->postParams['re_pwd']) : '';
        $allow = isset($this->postParams['allow']) ? intval($this->postParams['allow']) : 0;
        $source = isset($this->postParams['source']) ? trim($this->postParams['source']) : '';
        if (!$phone) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '手机号码不能为空']);
        }
        if (!$password) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '密码不能为空']);
        }
        if (!$rePwd) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '确认密码不能为空']);
        }
        if ($password != $rePwd) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '两次密码输入不一致']);
        }
        if (!$allow) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请同意用户协议']);
        }
        $userModel = new \app\common\model\User();
        //检查登录用户名/密码格式
        $extra = [
            'phone'     => $phone,
            'password'  => $password,
        ];
        $result = $userModel->checkFormat($this->factory['store_id'], $extra, FALSE);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }
        //判断手机号对应用户是否存在
        $exist = $userModel->where('phone', $phone)->where('is_del', 0)->find();
        if ($exist) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前手机号已注册']);
        }
        $data = [
            'phone'     => $phone,
            'admin_type'=> 0,
            'factory_id'=> $this->factory['store_id'],
            'store_id'  => 0,
            'is_admin'  => 1,
            'password'  => $userModel->pwdEncryption($password),
            'group_id'  => 0,
            'source'    => $source,
        ];
        $userId = $userModel->save($data);
        if ($userId === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('SYSTEM_ERROR')]);
        } else {
            $result = db('user_data')->where(['udata_id' => $udata['udata_id']])->update(['user_id' => $userId, 'update_time' => time()]);
            $udata['phone'] = $phone;
            $udata['user_id'] = $userId;
            $udata['store_id'] = 0;
            session('api_user_data', $udata);
            $this->_returnMsg(['msg' => '注册成功,请填写商家资料', 'errLogin' => 3,'source'=>$source]);
        }
    }
    //商户入驻-完善商户资料
    protected function applyStep2()
    {
        $udata = $this->_getScopeUser();
        $types = [
            STORE_DEALER => [
                'name' => '零售商',
                'admin_type' => ADMIN_DEALER,
                'group_id'   => GROUP_DEALER,
            ],
            STORE_CHANNEL => [
                'name' => '渠道商',
                'admin_type' => ADMIN_CHANNEL,
                'group_id'   => GROUP_CHANNEL,
            ],
            STORE_SERVICE => [
                'name' => '服务商',
                'admin_type' => ADMIN_SERVICE,
                'group_id'   => GROUP_SERVICE,
            ],
        ];
        $storeType = isset($this->postParams['store_type']) ? intval($this->postParams['store_type']) : '';
        if (!$storeType) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('请选择商户类型')]);
        }
        if (!isset($types[$storeType])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('商户类型错误')]);
        }
        $channelNo = isset($this->postParams['channel_no']) ? trim($this->postParams['channel_no']) : '';

        if ($storeType == STORE_DEALER) {
            if (!$channelNo) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('请填写渠道商编号')]);
            }
            $channel = Store::where(['factory_id' => $this->factory['store_id'], 'store_no' => $channelNo, 'store_type' => STORE_CHANNEL, 'is_del' => 0, 'status' => 1])->find();
            if (!$channel) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('渠道商不存在或已删除')]);
            }
        }
        $params = $this->_verifyStoreForm($storeType);
        if (isset($params['sample_amount'])) {
            $amount = floatval($params['sample_amount']);
            $amount = sprintf('%.2f', $amount);
            if (strlen($amount) > 11) {
                $array = explode('.', $amount);
                $amount = substr($array[0], 0, 8);
                $amount = $amount.'.'.$array[1];
                $params['sample_amount'] = $amount;
            }
        }
        if (isset($channel) && $channel) {
            $params['ostore_id'] = $channel['store_id'];
        }
        if (isset($params['security_money'])) {
            $amount = floatval($params['security_money']);
            $amount = sprintf('%.2f', $amount);
            if (strlen($amount) > 11) {
                $array = explode('.', $amount);
                $amount = substr($array[0], 0, 8);
                $amount = $amount.'.'.$array[1];
                $params['security_money'] = $amount;
            }
        }
        $where=['is_del'=>0,'status'=>1];
        $user=User::where($where)->find($udata['user_id']);
        if (empty($user) || empty($user['phone'])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '未绑定手机号，请重新绑定']);
        }
        $storeModel = new \app\common\model\Store();
        $storeId = $user['store_id'];
        if ($storeId) {
            $store = $storeModel->where('store_id', $storeId)->where('is_del', 0)->find();
            if (!$store) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('数据异常')]);
            }
            if ($store['check_status'] === 0) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('商户审核中')]);
            }
            if ($store['check_status'] === 1) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('商户审核已通过')]);
            }
            if ($store['enter_type'] !== 1) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('数据异常')]);
            }
        }
        $params['store_type'] = $storeType;
        $params['factory_id'] = $this->factory['store_id'];
        $params['mobile']     = $user['phone'];
        $params['config_json'] = '';
        $params['check_status'] = 0;
        $params['enter_type'] = 1;
        if (!$storeId) {
            $storeId = $storeModel->save($params);
        }else{
            $result = $storeModel->save($params,['store_id'=>$storeId]);
            if ($result === false) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('SYSTEM_ERROR')]);
            }
        }
        $data = [
            'admin_type'    => $types[$storeType]['admin_type'],
            'group_id'      => $types[$storeType]['group_id'],
            'store_id'      => $storeId,
            'realname'      => trim($params['user_name'])
        ];
        $userModel = new \app\common\model\User();
        $result = $userModel->save($data, ['user_id' => $udata['user_id']]);
        if ($result === false) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('SYSTEM_ERROR')]);
        }
        $source=session('api_source');
        $this->_returnMsg(['msg' => '入驻申请成功,请耐心等待厂商审核', 'errLogin' => 4,'source'=>$source]);
    }

    protected function getStoreApplyInfo()
    {
        $userId=session('api_user_data.user_id');
        if (empty($userId)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请退出重新访问']);
        }
        $user=db('user')->where(['is_del'=>0,'status'=>1])->find($userId);
        if (empty($user)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户不存在或已被删除']);
        }
        if ($user['status']==0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户已被禁用']);
        }
        $storeId = $user['store_id'];
        if ($storeId<=0) {
            $this->_returnMsg(['errCode' => 200, 'errMsg' => '您还未提交商户注册资料']);
        }
        $field='store_id,check_status,store_type,store_no,name,user_name,mobile,security_money,region_id,region_name,address,idcard_font_img,idcard_back_img,signing_contract_img,license_img,group_photo,status';
        $store=db('store')->field($field)->where(['is_del'=>0,'status'=>1])->find($storeId);
        if (empty($store)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户不存在或已被删除']);
        }
        if ($store['status']==0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户已被禁用']);
        }
        $store['sample_amount']=0;
        $store['store_no']='';
        if ($store['store_type']==STORE_DEALER) {
            $channel=db('store_dealer')
                ->alias('p1')
                ->field('p1.sample_amount,p2.store_no')
                ->join('store p2','p1.ostore_id=p2.store_id')
                ->where(['p1.store_id'=>$storeId,'p2.is_del'=>0,'status'=>1])
                ->find();
            $store['sample_amount']=isset($channel['sample_amount'])?$channel['sample_amount']:'';
            $store['store_no']=isset($channel['store_no'])?$channel['store_no']:'';
        }
        unset($store['status'],$store['store_id']);
        $this->_returnMsg(['detail'=>$store]);
    }

    //获取入驻商户审核详情
    protected function getApplyDetail()
    {
        $userId = session('api_user_data.user_id');
        if (empty($userId)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请退出重新访问']);
        }
        $where = [
            ['is_del', '=', 0],
            ['status', '=', 1],
            ['user_id','=', $userId],
        ];
        $user = db('user')->where($where)->find();
        if (empty($user)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户不存在或已被删除']);
        }
        $field = 'store_id, enter_type, address, store_type, store_no, check_status, admin_remark, name, user_name, mobile, security_money, region_name, idcard_font_img, idcard_back_img, signing_contract_img, license_img, group_photo, add_time';
        $detail = $this->getStoreDetail($field, $user['store_id']);
        if ($detail['enter_type'] != 1) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户不存在或已删除']);
        }
        $detail['check_status_txt'] = get_check_status($detail['check_status']);
        $detail['add_time'] = time_to_date($detail['add_time']);
        if ($detail['store_type'] == STORE_DEALER) {
            $detail['region_name'] = $detail['region_name'] . $detail['address'];
        }
        unset($detail['store_id'], $detail['enter_type'], $detail['address'], $detail['ostore_id'], $detail['address']);
        $this->_returnMsg(['detail' => $detail]);
    }
    //修改用户密码
    protected function updatePassword()
    {
        $user = $this->_checkUser();
        $password = isset($this->postParams['password']) && $this->postParams['password'] ? trim($this->postParams['password']) : '';
        $newPwd = isset($this->postParams['new_pwd']) && $this->postParams['new_pwd'] ? trim($this->postParams['new_pwd']) : '';
        $rePwd = isset($this->postParams['re_pwd']) && $this->postParams['re_pwd'] ? trim($this->postParams['re_pwd']) : '';
        if (!$password) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '原始密码不能为空']);
        }
        if (!$newPwd) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '新密码不能为空']);
        }
        if (!$rePwd) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '确认密码不能为空']);
        }
        if ($password == $newPwd) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '新密码不能与原密码一致']);
        }
        if ($newPwd != $rePwd) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '新密码与确认密码不一致']);
        }
        $userModel = new \app\common\model\User();
        $result = $userModel->checkFormat($user['factory_id'], ['password' => $newPwd]);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }
        $user = db('user')->find($user['user_id']);
        //判断原密码是否正确
        if ($user['password'] <> $userModel->pwdEncryption($password)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '原始密码错误']);
        }
        $data = ['password' => $userModel->pwdEncryption($newPwd)];
        $result = $userModel->save($data, ['user_id' => $user['user_id']]);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }else{
            $this->_returnMsg(['msg' => '修改密码成功']);
        }
    }

    //更换手机号
    protected function changePhone()
    {
        $user = $this->_checkUser();
        if (!isset($user['phone']) || !$user['phone']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '您还未绑定手机号，不能更换']);
        }
        $oldPhone = isset($this->postParams['old_phone']) ? trim($this->postParams['old_phone']) : '';
        $phone = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        if (!$oldPhone) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '原手机号不能为空']);
        }
        if (!$phone) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '新手机号不能为空']);
        }
        $userModel = new \app\common\model\User();
        $result = $userModel->changePhone($user, $oldPhone, $phone);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'msg' => $userModel->error]);
        }else{
            $this->_returnMsg(['msg' => '手机号更换成功']);
        }
    }

    //获取分享页面信息【厂商/渠道商】
    protected function getShareDetail()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_FACTORY, ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $url = isset($this->postParams['share_url']) ? $this->postParams['share_url'] : '';
        if (!$url) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'share_url不能为空']);
        }
        //获取厂商分享配置
        $config = get_store_config($user['factory_id'], FALSE, 'invite_share');
        if (!$config) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '厂商未配置分享数据']);
        }
        switch ($user['admin_type']) {
            case ADMIN_FACTORY:
                $config = $config && isset($config['factory']) ? $config['factory'] : [];
            break;
            case ADMIN_CHANNEL:
                $config = $config && isset($config['channel']) ? $config['channel'] : [];
                break;
            case ADMIN_SERVICE:
                $config = $config && isset($config['service']) ? $config['service'] : [];
                break;
            default:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
            break;
        }
        if (!$config) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '厂商未配置'.get_admin_type($user['admin_type']).'分享数据']);
        }
        $wechatApi = new \app\common\api\WechatApi(0, $this->thirdType);
        $appid = $wechatApi ? $wechatApi->config['appid'] : '';
        if (!$appid) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '微信配置错误']);
        }
        $jsapiTicket = $wechatApi->getWechatJsApiTicket();
        if ($jsapiTicket === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $wechatApi->error]);
        }
        $timestamp = time();
        $nonceStr = get_nonce_str(16, 1);
        // 这里参数的顺序要按照 key 值 ASCII 码升序排序
        $rawString = "jsapi_ticket=$jsapiTicket&noncestr=$nonceStr&timestamp=$timestamp&url=$url";
//         $urlArray = explode('#', $url);
        $urlArray = explode('?', $url);
        $string = "jsapi_ticket=$jsapiTicket&noncestr=$nonceStr&timestamp=$timestamp&url=".$urlArray[0];
        $signature = sha1($string);

        $config['sign_package'] = array(
            "appId"     => $appid,
            "nonceStr"  => $nonceStr,
            "timestamp" => $timestamp,
            "url"       => $url,
            "signature" => $signature,
            "rawString" => $rawString
        );
        $this->_returnMsg(['detail' => $config]);
    }
    protected function getShareCode()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $info = db('store')->where('store_id',$user['store_id'])->find();
        $codeUrl = '';
        if ($info['wxacode']) {
            $codeArray = json_decode($info['wxacode'], 1);
            $codeUrl = isset($codeArray['installer']) ? trim($codeArray['installer']) : ''; 
        }
        if (!$codeUrl) {
            $wxcodeService = new \app\common\service\Wxcode();
            $codeUrl = $wxcodeService->getStoreAppletCode($info, 'installer');
            if ($codeUrl === FALSE) {
                $this->error($wxcodeService->error);
            }
        }
        $this->_returnMsg(['code' => $codeUrl]);
    }
    //获取首页信息
    protected function getHomeDetail()
    {
        $user = $this->_checkUser();
        $indexController = new \app\common\controller\Index();
        $flag = $user['admin_type'] == ADMIN_FACTORY ? FALSE : TRUE;
        $result = $indexController->getStoreHome($user, $flag,true, $user);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $indexController->error]);
        }
        unset($result['tpl']);
        $this->_returnMsg(['detail' => $result]);
    }
    //获取厂商公告列表(全部/未读)
    protected function getFactoryBulletinList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $where = [
            'is_del' => 0,
            'store_id' => $user['store_id'],
        ];
        $field = 'bulletin_id,name,special_display,store_type,publish_time,is_top,publish_status';
        $order = 'is_top DESC, sort_order ASC, add_time DESC';
        $list = $this->_getModelList(db('bulletin'), $where, $field, $order);
        if ($list) {
            foreach ($list as $key => $value) {
                $list[$key]['store_type_name'] = get_store_type($value['store_type']);
                $list[$key]['publish_time'] = time_to_date($value['publish_time']);
            }
        }
        $this->_returnMsg(['list' => $list]);
    }
    
    //获取用户公告列表(全部/未读)
    protected function getBulletinList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $unread = isset($this->postParams['unread']) ? intval($this->postParams['unread']) : 0;
        $where = [
            'B.publish_status' => 1,
        ];
        $where[] = ['', 'EXP', \think\Db::raw('B.visible_range = 1 OR (visible_range = 0 AND find_in_set('.$user['store_id'].', B.to_store_ids))')];
        $where[] = ['', 'EXP', \think\Db::raw('B.store_type IN(0, '.$user['store_type'].')')];
        if ($unread) {
            $where[] = '(BR.bulletin_id IS NULL OR BR.is_read = 0)';
        }
        $join = [
            ['bulletin_log BR', 'B.bulletin_id = BR.bulletin_id AND BR.user_id = '.$user['user_id'], 'LEFT']
        ];
        $field = 'B.bulletin_id,B.name,B.special_display,B.publish_time,B.is_top,IFNULL(BR.is_read, 0) as is_read';
        $order = 'is_top DESC, publish_time DESC';
        $list = $this->_getModelList(db('bulletin'), $where, $field, $order, 'B', $join);
        if ($list) {
            foreach ($list as $key=>$item) {
                $list[$key]['publish_time']=time_to_date($item['publish_time']);
            }
        }
        $this->_returnMsg(['list' => $list]);
    }
    //获取公告详情
    protected function getBulletinDetail($return = FALSE)
    {
        $bulletinId = isset($this->postParams['bulletin_id']) ? intval($this->postParams['bulletin_id']) : 0;
        if (!$bulletinId){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '公告ID不能为空']);
        }
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_FACTORY, ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        if ($user['admin_type'] != ADMIN_FACTORY) {
            $join = [
                ['bulletin_log BR', 'B.bulletin_id = BR.bulletin_id AND BR.user_id = '.$user['user_id'], 'LEFT']
            ];
            $field = 'B.bulletin_id, B.name, B.special_display, B.content, B.publish_time, B.is_top, IFNULL(BR.is_read, 0) as is_read, IFNULL(BR.is_del, 0) as is_del';
            $where = [
                'B.publish_status' => 1,
                'B.bulletin_id' => $bulletinId,
            ];
            $where[] = ['', 'EXP', \think\Db::raw('B.visible_range = 1 OR (visible_range = 0 AND find_in_set('.$user['store_id'].', B.to_store_ids))')];
            $where[] = ['', 'EXP', \think\Db::raw('B.store_type IN(0, '.$user['store_type'].')')];
            $where[] = ['', 'EXP', \think\Db::raw('(BR.bulletin_id IS NULL OR BR.is_del = 0)')];
            
            $detail = db('bulletin')->alias('B')->join($join)->where($where)->field($field)->find();
            if (!$detail) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '公告不存在或已删除']);
            }
            if ($return) {
                return $detail;
            }
            if (!$detail['is_read']) {
                $detail = $this->setBulletinRead($detail);
            }
        }else{
            $field = 'bulletin_id,name,special_display,content,store_type,publish_time,is_top,publish_status';
            $where = [
                'is_del' => 0,
                'store_id' => $user['store_id'],
                'bulletin_id' => $bulletinId,
            ];
            $detail = db('bulletin')->where($where)->field($field)->find();
            if (!$detail) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '公告不存在或已删除']);
            }
        }
        $detail['publish_time']=date('Y-m-d H:i');
        $this->_returnMsg(['detail' => $detail]);
    }
    //设置公告已读
    protected function setBulletinRead($detail = [])
    {
        $user = $this->_checkUser();
        $detail = $this->getBulletinDetail(TRUE);
        if (!$detail || $detail['is_del']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '公告不存在或已删除']);
        }
        if ($detail['is_read'] > 0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '公告已读,不允许重复操作']);
        }
        $logModel = new \app\common\model\BulletinLog();
        $result = $logModel->read($detail, $user);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $logModel->error]);
        }
        if ($detail) {
            $detail['is_read'] = 1;
            return $detail;
        }
        $this->_returnMsg(['msg' => '已读操作成功']);
    }
    //获取未读公告数量
    protected function getUnreadBulletinCount(){
        $user = $this->_checkUser();
        $unReadCount = 0;
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $unread = isset($this->postParams['unread']) ? intval($this->postParams['unread']) : 0;
        $where = [
            'B.publish_status' => 1,
        ];
        $where[] = ['', 'EXP', \think\Db::raw('B.visible_range = 1 OR (visible_range = 0 AND find_in_set('.$user['store_id'].', B.to_store_ids))')];
        $where[] = ['', 'EXP', \think\Db::raw('(BR.bulletin_id IS NULL OR BR.is_read = 0)')];
        $where[] = ['', 'EXP', \think\Db::raw('B.store_type IN(0, '.$user['store_type'].')')];
        if ($unread) {
            $where[] = '(BR.bulletin_id IS NULL OR BR.is_read = 0)';
        }
        $join = [
            ['bulletin_log BR', 'B.bulletin_id = BR.bulletin_id AND BR.user_id = '.$user['user_id'], 'LEFT']
        ];
        $field = 'B.bulletin_id, B.name, B.special_display, B.content, B.publish_time, B.is_top, IFNULL(BR.is_read, 0) as is_read';
        $order = 'is_top DESC, publish_time DESC';
        $unReadCount    = db('bulletin')->join($join)->field($field)->alias('B')->where($where)->count();
        $this->_returnMsg(['count' => $unReadCount]);
    }
    //获取商户列表
    protected function getStoreList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $sortOrder = isset($this->postParams['sortorder']) ? trim($this->postParams['sortorder']) : '';
        $keyword = isset($this->postParams['keyword']) ? trim($this->postParams['keyword']) : '';
        $where = [
            'S.is_del' => 0,
            'S.status' => 1,
            'S.check_status'=> 1,
            'S.factory_id'  => $user['factory_id'],
        ];
        $isStoreSn=false;
        $isStoreName=false;
        if (!empty($keyword)) {
            if (preg_match('/^\d{9,}$/',$keyword)) {
                $isStoreSn=true;
            } else {
                $isStoreName=true;
            }
        }

        $field = 'S.store_id,S.store_no,S.name,S.store_type,S.region_name,S.address,S.status,S.user_name,S.mobile';
        if ($user['admin_type'] == ADMIN_FACTORY) {
            $storeType = isset($this->postParams['store_type']) ? intval($this->postParams['store_type']) : 0;
            if (!$storeType){
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户类型不能为空']);
            }
            $channelNo = isset($this->postParams['channel_no']) ? trim($this->postParams['channel_no']) : '';
            if ($channelNo){
                $channel = db('store')->where(['store_type' => STORE_CHANNEL, 'is_del' => 0, 'store_no' => $channelNo, 'factory_id' => $user['factory_id']])->find();
                if (!$channel) {
                    $this->_returnMsg(['errCode' => 1, 'errMsg' => '渠道商不存在或已删除']);
                }
            }
            $join = [];
            switch ($storeType){
                case STORE_CHANNEL:
                    $join[] = ['store_channel OS', 'S.store_id = OS.store_id', 'INNER'];
                    $join[] = ['store_finance SF', 'S.store_id = SF.store_id', 'INNER'];
                    $field .= ', total_amount';
                    break;
                case STORE_DEALER:
                    $field .= ', sample_amount';
                    $join[] = ['store_dealer OS', 'S.store_id = OS.store_id', 'INNER'];
                    if ($channelNo && isset($channel) && $channel) {
                        $where['OS.ostore_id'] = $channel['store_id'];
                    }
                    break;
                case STORE_SERVICE:
                    $join[] = ['store_servicer OS', 'S.store_id = OS.store_id', 'INNER'];
                    $join[] = ['store_finance SF', 'S.store_id = SF.store_id', 'INNER'];
                    $field .= ', total_amount';
                    break;
                default:
                    $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户类型错误']);
                    break;
            }
            $where['S.factory_id'] = $user['factory_id'];
        }else{
            $storeType = STORE_DEALER;
            unset($where['S.status']);
            $where['OS.ostore_id'] = $user['store_id'];
            $join[] = ['store_dealer OS', 'S.store_id = OS.store_id', 'INNER'];
            $field .= ', sample_amount, address';
        }
        $order = '';
        if ($sortOrder == 'amount') {
            if (in_array($storeType, [STORE_SERVICE, STORE_CHANNEL])) {
                $order .= 'SF.total_amount DESC, ';
            }else{
                $order .= 'sample_amount DESC, ';
            }
        }
        if ($isStoreName) {
            $where['S.name']=['like','%'.$keyword.'%'];
        }
        if ($isStoreSn) {
            $where['S.store_no']=$keyword;
        }
        $order .= 'S.add_time DESC';
        $list = $this->_getModelList(db('store'), $where, $field, $order, 'S', $join);
        if ($list) {
            foreach ($list as $key => $value) {
                switch ($storeType) {
                    case STORE_DEALER:
                        //计算订单金额 订单数量
                        $order = db('order')->field('count(order_id) as num, sum(real_amount) as amount')->where(['user_store_id' => $value['store_id'], 'pay_status' => 1])->find();
                        $list[$key]['order_num'] = $order ? intval($order['num']) : 0;
                        if ($user['admin_type'] == ADMIN_CHANNEL) {
                            $list[$key]['address'] = $value['region_name'].' '.$value['address'];
                        }
                        break;
                    case STORE_CHANNEL:
                        //所属零售商数量
                        $where = [
                            'S.store_type'  => STORE_DEALER,
                            'S.is_del'      => 0,
                            'S.check_status'=> 1,
                            'SD.ostore_id'  => $value['store_id'],
                        ];
                        $join = [
                            ['store_dealer SD', 'S.store_id = SD.store_id', 'INNER'],
                        ];
                        $list[$key]['dealer_count'] = db('store')->alias('S')->join($join)->where($where)->count();
                        break;
                    case STORE_SERVICE:
                        //服务次数
                        $list[$key]['service_count'] = db('work_order')->where(['store_id' => $value['store_id'], 'sign_time' => ['>', 0]])->count();
                        break;
                    default:
                        ;
                        break;
                }
                $list[$key]['store_type_name'] = get_store_type($value['store_type']);
                unset($list[$key]['store_id'], $list[$key]['store_type']);
            }
        }
        $this->_returnMsg(['list' => $list]);
    }
    //获取商户详情
    protected function getStoreDetail($returnField = '', $storeId = 0)
    {
        if (!$storeId) {
            $user = $this->_checkUser();
            if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_FACTORY])) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
            }
            $storeNo = isset($this->postParams['store_no']) ?trim($this->postParams['store_no']) : '';
            if (!$storeNo) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户编号不能为空']);
            }
        }
        $where = [
            'is_del' => 0,
            'factory_id' => $this->factory['store_id'],
        ];
        if ($storeId) {
            $where['store_id'] = $storeId;
        }else{
            $where['store_no'] = $storeNo;
        }
        $field = $returnField ? $returnField : 'store_id, store_type, store_no, name, user_name, mobile, security_money, region_id, region_name,address, idcard_font_img, idcard_back_img, signing_contract_img, license_img, group_photo, status';
        $info = db('store')->field($field)->where($where)->find();
        if (!$info) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户不存在或已删除']);
        }
        switch ($info['store_type']) {
            case STORE_CHANNEL:
                $model = 'channel';
                break;
            case STORE_DEALER:
                $model = 'dealer';
                break;
            case STORE_SERVICE:
                $model = 'servicer';
                break;
            default:
                return FALSE;
                break;
        }
        $finance = $account = [];
        $detail = model($model)->where(['store_id' => $info['store_id']])->find();
        if ($detail) {
            $info = array_merge($info, $detail->toArray());
        }
        $info['store_type_name'] = get_store_type($info['store_type']);
        if ($returnField) {
            return $info;
        }
        if ($user['admin_type'] == ADMIN_CHANNEL && $user['store_id'] != $detail['ostore_id']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户不存在或已删除']);
        }
        if ($info['store_type'] != STORE_DEALER) {
            $finance = db('store_finance')->field('amount, withdraw_amount, pending_amount, total_amount')->find($info['store_id']);
            $account = db('store_bank')->field('id_card, realname, bank_name, bank_branch, bank_no')->where(['store_id' => $info['store_id'], 'is_del' => 0])->find();
            $account = $account ? $account : [];
        }
        if ($info['store_type'] != STORE_SERVICE) {
            if ($info['store_type'] == STORE_CHANNEL) {
                //获取渠道商下的零售商数量
                $info['dealer_count'] = db('store')->alias('S')->join('store_dealer SD', 'SD.store_id = S.store_id', 'INNER')->where(['is_del' => 0, 'check_status' => 1, 'ostore_id' => $info['store_id']])->count();
            } 
            //计算订单金额 订单数量
            $order = db('order')->field('count(order_id) as num, sum(real_amount) as amount')->where(['user_store_id' => $info['store_id'], 'pay_status' => 1])->find();
            $info['order_num'] = $order ? intval($order['num']) : 0;
            $info['order_amount'] = $order ? floatval($order['amount']) : 0;
            //计算 退款订单数 退款订单金额
            $orderService = db('order_sku_service');
            $where = [
                'store_id' => $detail['store_id'],
                'service_status' => 3,
            ];
            $field = 'count(distinct(order_id)) count,sum(refund_amount) amount';
            $refund = $orderService->field($field)->where($where)->find();
            //累计退款订单数
            $info['refund_count'] = $refund ? intval($refund['count']) : 0;
            //累计退款金额
            $info['refund_amount'] = $refund? floatval($refund['amount']): 0;
        }else{
            //服务工单数
            $info['service_count'] = db('work_order')->where(['store_id' => $info['store_id'], 'sign_time' => ['>', 0]])->count();
        }
        unset($info['store_id'], $info['ostore_id']);
        $this->_returnMsg(['detail' => $info, 'finance' => $finance, 'account' => $account]);
    }
    //新增零售商
    protected function addDealer()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '仅渠道商有零售商新增权限']);
        }
        $params = $this->_verifyStoreForm();
        //判断渠道商操作零售商是否需要厂商审核
        $config = get_store_config($this->factory['store_id'], TRUE, 'default');
        $check = isset($config['channel_operate_check']) ? intval($config['channel_operate_check']) : 0;
        $params['store_type'] = STORE_DEALER;
        $params['factory_id'] = $user['factory_id'];
        $params['ostore_id'] = $user['store_id'];
        $params['config_json'] = '';
        if (!$check) {
            $storeModel = new \app\common\model\Store();
            $params['check_status'] = 1;
            $result = $storeModel->save($params);
            if ($result === FALSE) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => $storeModel->error]);
            }else{
                $this->_returnMsg(['msg' => '新增零售商成功']);
            }
        }else{
            $data = [
                'factory_id'        => $user['factory_id'],
                'action_store_id'   => $user['store_id'],
                'action_user_id'    => $user['user_id'],
                'to_store_id'       => 0,
                'to_store_name'     => isset($this->postParams['name']) ? trim($this->postParams['name']) : '',
                'action_type'       => 'add',
                'before'            => '',
                'after'             => $this->postParams ? json_encode($this->postParams): '',
                'modify'            => $this->postParams ? json_encode($this->postParams): '',
                'check_status'      => 0,
                'add_time'          => time(),
                'update_time'       => time(),
            ];
            $result = db('store_action_record')->insertGetId($data);
            if ($result === FALSE) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '系统错误']);
            }else{
                $this->_returnMsg(['msg' => '新增零售商成功，等待厂商审核']);
            }
        }
    }
    //编辑零售商
    protected function editDealer()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '仅渠道商有零售商编辑权限']);
        }
        $storeNo = isset($this->postParams['store_no']) ? trim($this->postParams['store_no']) : '';
        if (!$storeNo) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '零售商编号不能为空']);
        }
        $storeModel = new \app\common\model\Store();
        $where = [
            'S.store_no' => $storeNo,
            'S.is_del' => 0,
            'S.store_type' => STORE_DEALER,
            'S.factory_id' => $user['factory_id'],
            'SD.ostore_id' => $user['store_id'],
        ];
        $store = db('store')->alias('S')->join('store_dealer SD', 'SD.store_id = S.store_id', 'INNER')->where($where)->find();
        if (!$store) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '零售商不存在或已删除']);
        }
        $data = $this->_verifyStoreForm();
        //判断对象是否存在待处理的申请
        $exist = db('store_action_record')->where(['to_store_id' => $store['store_id'], 'check_status' => 0])->find();
        if ($exist) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前零售商存在待审核的操作记录,请等待审核']);
        }
        //判断渠道商操作零售商是否需要厂商审核
        $config = get_store_config($this->factory['store_id'], TRUE, 'default');
        $check = isset($config['channel_operate_check']) ? intval($config['channel_operate_check']) : 0;
        if (!$check) {
            $result = $storeModel->save($data, ['store_id' => $store['store_id']]);
            if ($result === FALSE) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => $storeModel->error]);
            }else{
                $this->_returnMsg(['msg' => '编辑零售商成功']);
            }
        }else{
            $temp = [];
            foreach ($store as $key => $value) {
                if (isset($data[$key]) && $data[$key] != $value && $key != 'update_time') {
                    $temp[$key] = $data[$key];
                }
            }
            if ($temp) {
                $data = [
                    'factory_id'    => $user['factory_id'],
                    'action_store_id'=> $user['store_id'],
                    'action_user_id'=> $user['user_id'],
                    'to_store_id'   => $store['store_id'],
                    'to_store_name' => isset($store['name']) ? trim($store['name']) : '',
                    'action_type'   => 'edit',
                    'before'         => $store ? json_encode($store): '',
                    'after'         => $data ? json_encode($data): '',
                    'modify'        => $temp ? json_encode($temp): '',
                    'check_status'  => 0,
                    'add_time'      => time(),
                    'update_time'    => time(),
                ];
                $result = db('store_action_record')->insertGetId($data);
                if ($result === FALSE) {
                    $this->_returnMsg(['errCode' => 1, 'errMsg' => '系统错误']);
                }else{
                    $this->_returnMsg(['msg' => '编辑零售商成功，等待厂商审核']);
                }
            }else{
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '未修改零售商信息']);
            }
        }
    }
    //删除零售商
    protected function delDealer()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '仅渠道商有零售商编辑权限']);
        }
        $storeNo = isset($this->postParams['store_no']) ? trim($this->postParams['store_no']) : '';
        if (!$storeNo) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '零售商编号不能为空']);
        }
        $storeModel = new \app\common\model\Store();
        $where = [
            'S.store_no' => $storeNo,
            'S.is_del' => 0,
            'S.store_type' => STORE_DEALER,
            'S.factory_id' => $user['factory_id'],
            'SD.ostore_id' => $user['store_id'],
        ];
        $store = $storeModel->alias('S')->join('store_dealer SD', 'SD.store_id = S.store_id', 'INNER')->where($where)->find();
        if (!$store) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '零售商不存在或已删除']);
        }
        //判断对象是否存在待处理的申请
        $exist = db('store_action_record')->where(['to_store_id' => $store['store_id'], 'check_status' => 0])->find();
        if ($exist) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前零售商存在待审核的操作记录,请等待审核']);
        }
        //判断渠道商操作零售商是否需要厂商审核
        $config = get_store_config($this->factory['store_id'], TRUE, 'default');
        $check = isset($config['channel_operate_check']) ? intval($config['channel_operate_check']) : 0;

        $result = $storeModel->del($store['store_id'], $user, $check);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $storeModel->error]);
        }else{
            $msg = $check ? '删除零售商操作提交，请等待厂商审核' : '删除商户成功';
            $this->_returnMsg(['msg' => $msg]);
        }
    }
    //获取入驻审核列表
    protected function getStoreCheckList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $where = [
            'S.is_del'        => 0,
            'S.enter_type'    => 1,
        ];
        $checkStatus=isset($this->postParams['check_status']) ? $this->postParams['check_status'] : '';
        $keyword=isset($this->postParams['keyword']) ? trim($this->postParams['keyword']) : '';
        if (''!==$checkStatus) {
            $where['S.check_status']=intval($checkStatus);
        }
        if ('' !== $keyword) {
            if (preg_match('/^\d{11}$/', $keyword)) {
                $where['S.mobile']=$keyword;
            } else {
                $where['S.name|S.user_name']=['like',$keyword];
            }
        }
        $field = 'S.store_no, S.name, store_type, security_money, sample_amount, check_status, user_name, mobile, region_name, address, add_time';
        $order = 'S.add_time desc';
        $join[] = ['store_dealer SD', 'SD.store_id = S.store_id', 'LEFT'];
        $list = $this->_getModelList(db('store'), $where, $field, $order, 'S', $join);
        if ($list) {
            foreach ($list as $key => $value) {
                $list[$key]['store_type_name'] = get_store_type($value['store_type']);
                $list[$key]['sample_amount'] = trim($value['sample_amount']);
                $list[$key]['check_status_txt'] = get_check_status($value['check_status']);
                $list[$key]['add_time'] = time_to_date($value['add_time']);
                if ($value['store_type'] == STORE_DEALER) {
                    $list[$key]['region_name'] = $value['region_name'] . $value['address'];
                }
                unset($list[$key]['address']);
            }
        }
        $this->_returnMsg(['list' => $list]);
    }
    //获取入驻商户审核详情
    protected function getStoreCheckDetail()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $field = 'store_id, enter_type, address, store_type, store_no, check_status, admin_remark, name, user_name, mobile, security_money, region_name, idcard_font_img, idcard_back_img, signing_contract_img, license_img, group_photo, add_time';
        $detail = $this->getStoreDetail($field);
        if ($detail['enter_type'] != 1) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户不存在或已删除']);
        }
        $detail['check_status_txt'] = get_check_status($detail['check_status']);
        $detail['add_time'] = time_to_date($detail['add_time']);
        if ($detail['store_type'] == STORE_DEALER) {
            $detail['region_name'] = $detail['region_name'] . $detail['address'];
        }
        unset($detail['store_id'], $detail['store_type'], $detail['enter_type'], $detail['address'], $detail['ostore_id'], $detail['address']);
        $this->_returnMsg(['detail' => $detail]);
    }
    //商户审核操作
    protected function checkStore()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $checkStatus = isset($this->postParams['check_result'])  ? intval($this->postParams['check_result']) : FALSE;
        $remark = isset($this->postParams['remark']) ? trim($this->postParams['remark']) : '';
        if (!$checkStatus || !in_array($checkStatus, [-1, 1])){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '审核结果错误']);
        }
        $field = '*';
        $detail = $this->getStoreDetail($field);
        if ($detail['enter_type'] != 1) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户不存在或已删除']);
        }
        if ($checkStatus == -1 && !$remark) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '拒绝理由不能为空']);
        }
        //判断当前商户是否已经审核通过
        if ($detail['check_status'] != 0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户已审核，不能重复操作']);
        }
        $status = $checkStatus > 0 ? 1: 2;
        $data = [
            'check_status' => $status,
            'admin_remark' => $remark,
        ];
        $storeModel = new \app\common\model\Store();
        $result = $storeModel->save($data, ['store_id' => $detail['store_id']]);
        if ($result !== FALSE) {
            $this->_returnMsg(['msg' => '操作成功']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('SYSTEM_ERROR')]);
        }
    }
    //获取商品列表
    protected function getGoodsList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }

        $salesOrder = isset($this->postParams['sales_order'])  && $this->postParams['sales_order'] ? 'sales DESC' : 'sales ASC';

        $keyword = isset($this->postParams['keyword'])  && trim($this->postParams['keyword']) ? trim($this->postParams['keyword']) : '';

        $where = [
            'is_del' => 0,
            'status' => 1,
            'store_id' => $user['factory_id'],
        ];
        if (!empty($keyword)) {
            $where[] = ['', 'EXP', \think\Db::raw('name like "%'.$keyword.'%" or goods_sn like "%'.$keyword.'%"')];
        }
        $order = $salesOrder.',sort_order ASC, add_time desc';
        $field = 'name,goods_id, goods_sn, thumb, (min_price + install_price) as min_price, (max_price + install_price) as max_price, goods_stock, sales';
        $list = $this->_getModelList(db('goods'), $where, $field, $order);
        $this->_returnMsg(['list' => $list]);
    }
    //获取商品详情
    protected function getGoodsDetail()
    {
        $goodsId = isset($this->postParams['goods_id']) ? intval($this->postParams['goods_id']) : 0;
        if (!$goodsId){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品ID不能为空']);
        }
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $field = 'goods_id, goods_sn, thumb, imgs, (min_price + install_price) as min_price, (max_price + install_price) as max_price, goods_stock, sales, content, specs_json';
        $where = [
            'goods_id'  => $goodsId,
            'is_del'    => 0,
            'status'    => 1,
            'store_id'  => $user['factory_id'],
        ];
        $detail = db('goods')->where($where)->field($field)->find();
        if (!$detail) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品不存在或已删除']);
        }
        $detail['imgs'] = $detail['imgs'] ? json_decode($detail['imgs'], 1) : [];
        $detail['specs_json'] = $detail['specs_json'] ? json_decode($detail['specs_json'], 1) : [];
        $goodsModel = new \app\common\model\Goods();
        $skus = $goodsModel->getGoodsSkus($goodsId);
        $detail['sku_id'] = 0;
        $detail['skus'] = [];
        if ($skus) {
            if (is_array($skus)) {
                foreach ($skus as $key => $value) {
                    $skus[$key]['price'] = bcadd($value['price'],$value['install_price'],2);
                    $skus[$key]['sku_thumb'] = $value['sku_thumb'] ? $value['sku_thumb'] : $detail['thumb'];
                    unset($skus[$key]['install_price']);
                }
                $detail['skus'] = $skus;
            }elseif (is_int($skus)){
                $detail['sku_id'] = $skus;
            }
        }
        $this->_returnMsg(['detail' => $detail]);
    }
    //获取商品规格列表
    protected function getGoodsSkus()
    {
        $goodsId = isset($this->postParams['goods_id']) ? intval($this->postParams['goods_id']) : 0;
        if (!$goodsId){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品ID不能为空']);
        }
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $field = 'goods_id, goods_sn, thumb, imgs, (min_price + install_price) as min_price, (max_price + install_price) as max_price, goods_stock, sales, content, specs_json';
        $where = [
            'goods_id'  => $goodsId,
            'is_del'    => 0,
            'status'    => 1,
            'store_id'  => $user['factory_id'],
        ];
        $detail = db('goods')->where($where)->find();
        if (!$detail) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品不存在或已删除']);
        }
        $specs = $detail['specs_json'] ? json_decode($detail['specs_json'], 1) : [];
        $goodsModel = new \app\common\model\Goods();
        $skus = $goodsModel->getGoodsSkus($goodsId);
        if ($skus && is_array($skus)) {
            foreach ($skus as $key => $value) {
                $skus[$key]['price'] = $value['price'] + $value['install_price'];
                $skus[$key]['sku_thumb'] = $value['sku_thumb'] ? $value['sku_thumb'] : $detail['thumb'];
                unset($skus[$key]['install_price']);
            }
            $detail['skus'] = $skus;
            $this->_returnMsg(['skus' => $skus, 'specs' => $specs]);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品无对应规格信息']);
        }
    }
    protected function getGoodsSpec(){
        $goodsId = isset($this->postParams['goods_id']) ? intval($this->postParams['goods_id']) : 0;
        $specs = isset($this->postParams['specs']) ? trim($this->postParams['specs']) : '';
        if (!$goodsId){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品ID不能为空']);
        }
        if (!$specs){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品规格不能为空']);
        }
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $field = 'goods_id, goods_sn, thumb, imgs, (min_price + install_price) as min_price, (max_price + install_price) as max_price, goods_stock, sales, content, specs_json';
        $where = [
            'goods_id'  => $goodsId,
            'is_del'    => 0,
            'status'    => 1,
            'store_id'  => $user['factory_id'],
        ];
        $detail = db('goods')->where($where)->find();
        if (!$detail) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品不存在或已删除']);
        }
        
        $skuInfo = db('goods_sku')->where("goods_id = {$goodsId} AND spec_json='{$specs}' AND status=1 AND is_del=0")->find();
        if(!$skuInfo){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品对应规格不存在或已删除']);
        }
        $return = array(
            'sku_id'    => $skuInfo['sku_id'],
            'sku_thumb' => ($skuInfo['sku_thumb'] ? $skuInfo['sku_thumb'] : $detail['thumb']),
            'price'     => bcadd($skuInfo['price'],$skuInfo['install_price'],2),
            'sku_stock' => $skuInfo['sku_stock'],
            'sales'     => $skuInfo['sales'],
        );
        $this->_returnMsg(['errCode' => 0, 'data' => $return]);
    }
    
    //创建订单
    protected function createOrder()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $skuId = isset($this->postParams['sku_id']) ? intval($this->postParams['sku_id']) : 0;
        if (!$skuId){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品规格ID不能为空']);
        }
        $num = isset($this->postParams['num']) ? intval($this->postParams['num']) : 0;
        if ($num <= 0){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '购买商品数量必须大于0']);
        }
        $remark = isset($this->postParams['remark']) ? trim($this->postParams['remark']) : '';
        $orderModel = new \app\common\model\Order();
        $submit = isset($this->postParams['submit']) && $this->postParams['submit'] ? TRUE : FALSE;
        $result = $orderModel->createOrder($user, 'goods', $skuId, $num, $submit, [], $remark);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $orderModel->error]);
        }
        if ($submit) {
            $this->_returnMsg(['order_sn' => $result['order_sn']]);
        }else{
            $this->_returnMsg(['datas' => $result]);
        }
    }
    //支付订单
    protected function payOrder()
    {
        $orderSn = isset($this->postParams['order_sn']) ? trim($this->postParams['order_sn']) : '';
        if (!$orderSn) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单编号不能为空']);
        }
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $orderModel = new \app\common\model\Order();
        $order = $orderModel->checkOrder($orderSn, $user);
        if ($order === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $orderModel->error]);
        }
        if (!empty($user['third_openid'])) {
            $order['openid'] = $user['third_openid'];
        }else{
            //$wechatApi = new \app\common\api\WechatApi(0, $this->thirdType);
            //$appid = isset($wechatApi->config['appid']) ? trim($wechatApi->config['appid']) : '';
            ////获取当前用户h5微信openid
            //$where = [
            //    'user_id'       => $user['user_id'],
            //    'factory_id'    => $user['factory_id'],
            //    'third_type'    => $this->thirdType,
            //    'appid'         => $appid,
            //];
            //$order['openid'] = db('user_data')->where($where)->value('third_openid');
            $order['openid'] = session('udata.third_openid');
        }
        if (!$order['openid']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '微信用户openid不能为空']);
        }
        $paymentApi = new \app\common\api\PaymentApi($this->factory['store_id'], 'wechat_js');
        $result = $paymentApi->init($order);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $paymentApi->error]);
        }
        $this->_returnMsg(['data' => $result]);
    }
    //获取订单列表
    protected function getOrderList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $status = isset($this->postParams['status']) ? intval($this->postParams['status']) : 0;
        $keyword = isset($this->postParams['keyword']) ? trim($this->postParams['keyword']) : '';
        $isOrderSn=false;
        $isGoodsName=false;
        if (!empty($keyword)) {
            if (preg_match('/^\d{29}$/',$keyword)) {
                $isOrderSn=true;
            } else {
                $isGoodsName=true;
            }
        }
        $where = [
            'order_type' => 1,
        ];
        if ($status > 0) {
            switch ($status) {
                case 1://待支付
                    $where['order_status'] = 1;
                    $where['pay_status'] = 0;
                break;
                case 2://已完成
                    $where['finish_status'] = 2;
                    $where['order_status'] = 1;
                break;
                case 3://已关闭(取消或已关闭)
                    $where['order_status'] = ['<>', 1];
                break;
                default:
                break;
            }
        }
        if ($user['admin_type'] == ADMIN_FACTORY) {
            $where['store_id'] = $user['store_id'];
            $flag = FALSE;
        }else{
            $where['user_id'] = $user['user_id'];
            $where['user_store_id'] = $user['store_id'];
            $where['user_store_type'] = $user['store_type'];
            $flag = TRUE;
        }
        if ($isOrderSn) {
            $where['order_sn'] = $keyword;
        }

        $order = 'add_time DESC';
        $field = 'order_id, store_id, order_type, order_sn, real_amount, pay_code, order_status, pay_status, delivery_status, finish_status, add_time, close_refund_status';
        $list = $this->_getModelList(db('order'), $where, $field, $order);
        $result=[];
        if ($list) {
            $orderModel = new \app\common\model\Order();
            $list = $orderModel->getOrderList($list, $flag);
            foreach ($list as $key => $value) {
                $whereSku=[];
                $whereSku['order_id']=$value['order_id'];
                if ($isGoodsName) {
                    $whereSku['sku_name']=['like','%'.$keyword.'%'];
                }
                $skus = db('order_sku')->field('sku_name, sku_thumb, sku_spec, num, price ')->where($whereSku)->select();
                $list[$key]['add_time'] = time_to_date($value['add_time']);
                $list[$key]['pay_name'] = isset($value['pay_name']) ? $value['pay_name'] : '';
                $list[$key]['skus'] = $skus;
                unset($list[$key]['order_id'], $list[$key]['pay_code'], $list[$key]['order_status'], $list[$key]['pay_status'], $list[$key]['delivery_status'], $list[$key]['finish_status']);
                unset($list[$key]['close_refund_status'], $list[$key]['store_id'], $list[$key]['order_type']);
                if (!empty($skus)){
                    $result[]=$list[$key];
                }
            }
        }
        $this->_returnMsg(['list' => $result]);
    }
    //获取零售商订单列表[渠道商]
    protected function getDealerOrderList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '仅渠道商有零售商新增权限']);
        }
        $where = [
            'order_type' => 1,
        ];
        $status = isset($this->postParams['status']) ? intval($this->postParams['status']) : 0;
        $keyword = isset($this->postParams['keyword']) ? trim($this->postParams['keyword']) : '';
        $isOrderSn=false;
        $isSkuName=false;
        if (!empty($keyword)) {
            if (preg_match('/^\d{29}$/',$keyword)) {
                $isOrderSn=true;
            } else {
                $isSkuName=true;
            }
        }
        if ($status > 0) {
            switch ($status) {
                case 1://待支付
                    $where['order_status'] = 1;
                    $where['pay_status'] = 0;
                    break;
                case 2://已完成
                    $where['finish_status'] = 2;
                    $where['order_status'] = 1;
                    break;
                case 3://已关闭(取消或已关闭)
                    $where['order_status'] = ['<>', 1];
                    break;
                default:
                    break;
            }
        }
        $where['user_store_type'] = STORE_DEALER;
        $where['AS.ostore_id'] = $user['store_id'];
        $order = 'add_time DESC';
        $field = 'O.order_id, O.store_id, order_type, order_sn, real_amount, pay_code, order_status, pay_status, delivery_status, finish_status, O.add_time, close_refund_status';
        $join = [
            ['store S', 'O.user_store_id = S.store_id', 'LEFT'],
            ['store_dealer AS', 'O.user_store_id = AS.store_id', 'LEFT'],
        ];

        if ($isOrderSn) {
            $where['O.order_sn'] = $keyword;
        }

        $list = $this->_getModelList(db('order'), $where, $field, $order, 'O', $join);
        $result=[];
        if ($list) {
            $orderModel = new \app\common\model\Order();
            $list = $orderModel->getOrderList($list, FALSE);
            foreach ($list as $key => $value) {
                $whereSku=[];
                $whereSku['order_id']=$value['order_id'];
                if ($isSkuName) {
                    $whereSku['sku_name']=['like','%'.$keyword.'%'];
                }
                $skus = db('order_sku')->field('sku_name, sku_thumb, sku_spec, num, price ')->where($whereSku)->select();
                $list[$key]['pay_name'] = isset($value['pay_name']) ? $value['pay_name'] : '';
                
                $list[$key]['skus'] = $skus;
                unset($list[$key]['order_id'], $list[$key]['pay_code'], $list[$key]['order_status'], $list[$key]['pay_status'], $list[$key]['delivery_status'], $list[$key]['finish_status']);
                unset($list[$key]['close_refund_status'], $list[$key]['store_id'], $list[$key]['order_type']);
                unset($list[$key]['_service'], $list[$key]['_apply_status']);
                if (!empty($skus)){
                    $result[]=$list[$key];
                }
            }
        }
        $this->_returnMsg(['list' => $result]);
    }
    //获取订单详情
    protected function getOrderDetail()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $orderSn = isset($this->postParams['order_sn']) ? trim($this->postParams['order_sn']) : '';
        if (!$orderSn){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单编号不能为空']);
        }
        $orderModel = new \app\common\model\Order();
        $orderField = 'order_id,order_type,order_sn,real_amount,order_status,pay_status,delivery_status,finish_status';
        $orderField .= ',pay_code,store_id,pay_time,close_refund_status,add_time,remark, user_store_id, user_id';
        $skuField = 'sku_name,sku_thumb,sku_spec,num,price';
        $result = $orderModel->getOrderDetail($orderSn, $user, FALSE, FALSE, $orderField, $skuField);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $orderModel->error]);
        }
        $detail = json_decode(json_encode($result['order']),true);
        if (isset($detail['_pay_status']['pay_code']) && $detail['_pay_status']['pay_code'] == 'wechat_js') {
            $detail['_pay_status']['name']='微信支付';
        }

        $detail['store_name'] = db('store')->where('store_id', $detail['user_store_id'])->value('name');
        $detail['user_phone'] = db('user')->where('user_id', $detail['user_id'])->value('phone');
        //判断订单申请安装状态
        $applyStatus = 0;
        $orderSkuModel = db('order_sku');
        $worderCount = db('work_order')->where(['order_sn' => $orderSn, 'work_order_status' => ['<>', -1]])->count();
        if ($worderCount > 0) {
            $orderCount = $orderSkuModel->where(['order_id' => $detail['order_id']])->sum('num');
            if ($orderCount > $worderCount) {
                $applyStatus = 1;
            }else{
                $applyStatus = 2;
            }
        }
        $ossubId = 0;
        $detail['_service'] = [
            'ossub_id' => 0,
        ];
        if ($detail['pay_status'] == 1) {
            if ($applyStatus != 2) {
                //获取可申请安装的订单商品
                $where = [
                    'OSSUB.order_id'    => $detail['order_id'],
                ];
                $where[] = ['', 'EXP', \think\Db::raw("service_status = -2 OR service_status is NULL")];
                $where[] = ['', 'EXP', \think\Db::raw("work_order_status = -1 OR work_order_status is NULL")];
                
                $join = [
                    ['order_sku_service OSSE', 'OSSE.ossub_id = OSSUB.ossub_id', 'LEFT'],
                    ['work_order WO', 'WO.ossub_id = OSSUB.ossub_id', 'LEFT'],
                ];
                $ossubId = db('order_sku_sub')->alias('OSSUB')->join($join)->where($where)->value('OSSUB.ossub_id');
            }
            if ($detail['order_status'] == 1 && $detail['close_refund_status'] != 2) {
                $detail['_service'] = [
                    'ossub_id' => $ossubId,
                ];
            }
        }
        $detail['_apply_status'] = [
            'ossub_id' => $ossubId,
            'status' => $applyStatus,
            'status_text' => get_order_apply_status($applyStatus),
            'count' => $worderCount,
        ];

        unset($detail['order_id'], $detail['pay_time'],$detail['pay_type'], $detail['pay_code'], $detail['order_status'], $detail['pay_status'], $detail['delivery_status'], $detail['finish_status']);
        unset($detail['close_refund_status'], $detail['store_id'], $detail['order_type'], $detail['user_store_id'], $detail['user_id']);
        $this->_returnMsg(['detail' => $detail]);
    }
    //取消订单
    protected function cancelOrder()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $orderSn = isset($this->postParams['order_sn']) ? trim($this->postParams['order_sn']) : '';
        if (!$orderSn){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单编号不能为空']);
        }
        $orderModel = new \app\common\model\Order();
        $result = $orderModel->orderCancel($orderSn, $user);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $orderModel->error]);
        }else{
            $this->_returnMsg(['msg' => '取消订单成功']);
        }
    }
    //获取订单商品详情
    protected function getOrderSkuSubDetail()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $orderSn = isset($this->postParams['order_sn']) ? trim($this->postParams['order_sn']) : '';
        if(!$orderSn){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单号不能为空']);
        }
        $ossubId = isset($this->postParams['ossub_id']) ? intval($this->postParams['ossub_id']) : 0;
        if(!$ossubId){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单商品ID不能为空']);
        }
        $orderModel = new \app\common\model\Order();
        $order = $orderModel->checkOrder($orderSn, $user);
        if ($order === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $orderModel->error]);
        }
        $orderSkuModel = new \app\common\model\OrderSku();
        $ossub = $orderSkuModel->getSubDetail($ossubId, 'OS.order_sn, ossub_id, sku_name, sku_spec, sku_thumb');
        if (!$ossub) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单商品不存在']);
        }
        if ($ossub['order_sn'] != $order['order_sn']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单商品不存在']);
        }
        unset($ossub['work_order'], $ossub['service']);
        $this->_returnMsg(['detail' => $ossub]);
    }
    //申请安装
    protected function applyWorkOrder()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $orderSn = isset($this->postParams['order_sn']) ? trim($this->postParams['order_sn']) : '';
        if(!$orderSn){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单号不能为空']);
        }
        $ossubId = isset($this->postParams['ossub_id']) ? intval($this->postParams['ossub_id']) : 0;
        if(!$ossubId){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单商品ID不能为空']);
        }
        $workOrderType = 1;
        $data = [
            'work_order_type' => $workOrderType,
            'factory_id'    => $this->factory['store_id'],
            'post_user_id'  => $user['user_id'],
            'post_store_id' => $user['store_id'],
            'fault_desc'    => '',
            'images'        => '',
        ];
        $userName   = $data['user_name']    = isset($this->postParams['user_name']) ? trim($this->postParams['user_name']) : '';
        $phone      = $data['phone']        = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        $regionId   = $data['region_id']    = isset($this->postParams['region_id']) ? intval($this->postParams['region_id']) : '';
        $regionName = $data['region_name']  = isset($this->postParams['region_name']) ? trim($this->postParams['region_name']) : '';
        $address    = $data['address']      = isset($this->postParams['address']) ? trim($this->postParams['address']) : '';
        $appointment= $data['appointment']  = isset($this->postParams['appointment']) ? trim($this->postParams['appointment']) : '';
        $remark     = $data['fault_desc']   = isset($this->postParams['remark']) ? trim($this->postParams['remark']) : '';
        if(!$userName){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '客户姓名不能为空']);
        }
        if(!$phone){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '客户联系电话不能为空']);
        }
        if(!$regionId || !$regionName){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请选择安装区域']);
        }
        if(!$address){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请填写安装地址']);
        }
        if(!$appointment){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '预约时间不能为空']);
        }
        $orderModel = new \app\common\model\Order();
        $order = $orderModel->checkOrder($orderSn, $user);
        if ($order === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $orderModel->error]);
        }
        $skuModel = new \app\common\model\OrderSku();
        $ossub = $skuModel->getSubDetail($ossubId, FALSE, TRUE);
        if (!$ossub) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单商品不存在']);
        }
        if ($ossub['order_sn'] != $order['order_sn']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单商品不存在']);
        }
        if ($ossub['goods_type'] == 2) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '样品不允许安装']);
        }
        if ($ossub['order_status'] != 1) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单已取消/已关闭，不允许申请安装']);
        }
        if (!$ossub['pay_status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单未支付，不允许申请安装']);
        }
        if($ossub['service'] && ($ossub['service']['service_status'] != -1 && $ossub['service']['service_status'] != -2)){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品存在退款申请,不允许申请安装']);
        }
        $workOrderModel = new \app\common\model\WorkOrder();
        //判断当前商品是否已经申请安装
        $exist = $workOrderModel->where(['ossub_id' => $ossub['ossub_id'], 'work_order_type' => 1, 'work_order_status' => ['<>', -1]])->find();
        if ($exist) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品已申请安装']);
        }
        $storeModel = new \app\common\model\Store();
        //根据安装地址分配服务商
        //原型地址精确到区则根据当前region_id获取父级ID然后获取服务商ID
        $parentId = db('region')->where(['region_id' => $regionId])->value(['parent_id']);
        if (!$parentId) {
            $parentId = 0;
        }
        $storeId = $storeModel->getStoreFromRegion($parentId);
        if(!$storeId){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '该区域暂无服务商']);
        }
        $data['store_id'] = $storeId;
        $data['appointment'] = strtotime($appointment);
        $data['order_sn'] = $ossub['order_sn'];
        $data['osku_id'] = $ossub['osku_id'];
        $data['ossub_id'] = $ossub['ossub_id'];
        $data['goods_id'] = $ossub['goods_id'];
        $data['sku_id'] = $ossub['sku_id'];
        $data['install_price'] = $ossub['install_amount'];
        $result = $workOrderModel->save($data);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('SYSTEM_ERROR')]);
        }
        $this->_returnMsg(['msg' => lang('申请安装成功'), 'worder_sn' => $result]);
    }
    //申请退款
    protected function applyServiceOrder()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $orderSn = isset($this->postParams['order_sn']) ? trim($this->postParams['order_sn']) : '';
        if(!$orderSn){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单号不能为空']);
        }
        $ossubId = isset($this->postParams['ossub_id']) ? intval($this->postParams['ossub_id']) : 0;
        if(!$ossubId){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单商品ID不能为空']);
        }
        $orderModel = new \app\common\model\Order();
        $order = $orderModel->checkOrder($orderSn, $user);
        if ($order === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $orderModel->error]);
        }
        if ($order['close_refund_status'] == 2) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '超时不允许退货退款']);
        }
        $orderSkuModel = new \app\common\model\OrderSku();
        $ossub = $orderSkuModel->getSubDetail($ossubId, FALSE, FALSE, TRUE);
        if (!$ossub) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单商品不存在']);
        }
        if ($ossub['order_sn'] != $order['order_sn']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单商品不存在']);
        }
        if ($ossub['work_order'] && $ossub['work_order'] != -1) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单商品存在安装工单，不允许申请售后']);
        }
        $imgs = isset($this->postParams['imgs']) ? $this->postParams['imgs'] : [];
        if ($imgs) {
            $imgs = explode(',', $imgs);
            $imgs = $imgs ? array_filter($imgs) : [];
            $imgs = $imgs ? array_unique($imgs) : [];
            if (count($imgs) > 3) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '退款凭证不能大于3张']);
            }
        }
        $orderSkuServiceModel = new \app\common\model\OrderService();
        $params = [
            'remarks' => isset($this->postParams['remarks']) ? $this->postParams['remarks'] : '',
            'imgs' => $imgs,
        ];
        $result = $orderSkuServiceModel->createService($order, $ossub, $user, $params);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $orderSkuServiceModel->error]);
        }else{
            $this->_returnMsg(['msg' => '退款申请成功,请耐心等待厂商审核']);
        }
    }
    //获取售后订单列表
    protected function getServiceOrderList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $where = [
            'S.is_del' => 0,
        ];
        $serviceStatus = isset($this->postParams['status']) ? $this->postParams['status'] : '';
        $keyword = isset($this->postParams['keyword']) ? trim($this->postParams['keyword']) : '';

        if (!empty($keyword)) {
            if (preg_match('/^\d{29}$/',$keyword)) {
                $where['S.order_sn'] =$keyword;
            } else if (preg_match('/^\d{18}$/',$keyword)) {
                $where['S.service_sn'] =$keyword;
            }else if (preg_match('/^\d{11}$/',$keyword)) {
                $where['S1.mobile'] =$keyword;
            }else{
                $where['S1.name'] =['like','%'.$keyword.'%'];
            }
        }
        if (''!==$serviceStatus && in_array($serviceStatus,[-2,-1,0,1,2,3])) {
            $where['S.service_status']=$serviceStatus;
        }

        if ($user['admin_type'] == ADMIN_FACTORY) {
            $where['S.store_id'] = $user['store_id'];
        }else{
            $where['S.user_store_id'] = $user['store_id'];
        }
        $field='S.service_sn,S.order_sn,S.service_status,S.refund_amount,S.add_time,S1.name store_name,S1.user_name,S1.mobile';
        $join=[
            ['store S1', 'S1.store_id = S.user_store_id', 'LEFT'],
        ];
        $order='S.update_time DESC';
        $list = $this->_getModelList(db('order_sku_service'), $where, $field, $order,'S',$join);
        if (!empty($list)) {
            $list=array_map(function ($item) {
                $item['add_time']=time_to_date($item['add_time']);
                $item['status_desc']=get_service_status($item['service_status']);
                return $item;
            },$list);
        }
        $this->_returnMsg(compact('list'));

    }
    //获取售后订单详情
    protected function getServiceOrderDetail()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $serviceSn = isset($this->postParams['service_sn']) ? trim($this->postParams['service_sn']) : '';
        if (!$serviceSn){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后单号不能为空']);
        }
        $where = ['S.service_sn' => $serviceSn];
        if ($user && isset($user['store_id']) && $user['store_id'] > 0) {
            if ($user['admin_type'] == ADMIN_FACTORY) {
                $where['S.store_id'] = $user['store_id'];
            }elseif (in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER])){
                $storeIds = [$user['store_id']];
                if ($user['admin_type'] == ADMIN_CHANNEL) {
                    //获取零售商的下级经销商
                    $ids = db('store')->alias('S')->join([['store_dealer SD', 'S.store_id = SD.store_id', 'INNER']])->where(['S.is_del' => 0, 'SD.ostore_id' => $user['store_id']])->column('S.store_id');
                    $storeIds = $ids ? array_merge($ids, $storeIds) : $storeIds;
                }
                $where['S.user_store_id'] = ['IN', $storeIds];
            }
        }
        $field='OS.sku_name,OS.sku_spec,OS.price,S.order_sn,S.num,OS.sku_thumb,O.real_amount,S.imgs,S.remark,S.add_time,S.refund_amount,S.service_status,O.pay_time,U.realname,U.phone, refund_time';
        $join=[
            ['order_sku_sub OSS', 'OSS.ossub_id = S.ossub_id', 'INNER'],
            ['order_sku OS', 'OS.osku_id = OSS.osku_id', 'INNER'],
            ['order O', 'O.order_id = OSS.order_id', 'INNER'],
            ['user U', 'U.user_id = O.user_id', 'LEFT'],
        ];
        $detail = db('order_sku_service')->alias('S')->join($join)->field($field)->where($where)/*->fetchSql(true)*/->find();
        if (!$detail) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后服务单号不正确']);
        }
        $detail['sku_name']=$detail['sku_name']?$detail['sku_name']:$detail['sku_spec'];
        $detail['status_desc']=get_service_status($detail['service_status']);
        $detail['imgs']=json_decode($detail['imgs'],true);
        $detail['add_time']=time_to_date($detail['add_time']);
        $detail['refund_time']=time_to_date($detail['refund_time']);
        $detail['pay_time']=time_to_date($detail['pay_time']);
        unset($detail['sku_spec']);
        $this->_returnMsg(compact('detail'));
    }
    //取消售后订单
    protected function cancelServiceOrder()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $serviceSn = isset($this->postParams['service_sn']) ? trim($this->postParams['service_sn']) : '';
        if (!$serviceSn){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后单号不能为空']);
        }
        $serviceModel = new \app\common\model\OrderService();
        $service=$serviceModel->where(['service_sn'=>$serviceSn,'is_del'=>0])->find();
        if (empty($service)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后信息不存在']);
        }
        $result = $serviceModel->serviceCancel($service, $user);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $serviceModel->error]);
        }else {
            $this->_returnMsg(['msg' => '售后取消成功']);
        }
    }

    //售后订单审核
    protected function serviceOrderCheck()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前管理员无操作权限']);
        }
        $serviceSn = isset($this->postParams['service_sn']) ? trim($this->postParams['service_sn']) : '';
        $remark = isset($this->postParams['remark']) ? trim($this->postParams['remark']) : '';
        $checkStatus = isset($this->postParams['check_status']) && intval($this->postParams['check_status']) ? 1 :0;
        if (empty($serviceSn)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后单号不能为空']);
        }
        if (!$checkStatus && !$remark) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请填写拒绝理由']);
        }
        $serviceModel = new \app\common\model\OrderService();
        $service=$serviceModel->where(['service_sn'=>$serviceSn,'is_del'=>0])->find();
        if (empty($service)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '查无该售后订单']);
        }
        if ($service['service_status'] != 0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '审核已处理，不能重复操作']);
        }
        $result = $serviceModel->serviceCheck($service, $user,['check_status'=>$checkStatus,'admin_remark'=>$remark]);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' =>'审核失败【'. $serviceModel->error].'】');
        }else {
            $this->_returnMsg(['msg' => '审核成功']);
        }
    }
    
    //获取工单列表(厂商/渠道商/零售商/服务商)
    protected function getWorkOrderList()
    {
        $user = $this->_checkUser();
        $where = [
            'WO.is_del' => 0,
            'WO.status' => 1,
        ];
        $workOrderType = isset($this->postParams['type']) ? intval($this->postParams['type']) : '';
        $keyword = isset($this->postParams['keyword']) ? trim($this->postParams['keyword']) : '';
        $workOrderStatus = isset($this->postParams['status']) && is_numeric($this->postParams['status']) ? intval($this->postParams['status']) : FALSE;
        if (''!==$workOrderType && in_array($workOrderType,[1,2])) {
            $where['WO.work_order_type']=$workOrderType;
        }
        //查找工程师的工单
        $jobNo = isset($this->postParams['job_no']) ? trim($this->postParams['job_no']) : '';
        if (!empty($jobNo)) {
            $installerId=db('user_installer')->where('job_no',$jobNo)->value('installer_id');
            if ($installerId) {
                $where['WO.installer_id']=$installerId;
            }
        }
        $isOrderSn=false;
        $isWorkSn=false;
        $isMobile=false;
        $isUserName=false;
        if (!empty($keyword)) {
            if (preg_match('/^\d{29}$/',$keyword)) {
                $isOrderSn=true;
            } else if (preg_match('/^\d{20}$/',$keyword)) {
                $isWorkSn=true;
            }else if (preg_match('/^\d{11}$/',$keyword)) {
                $isMobile=true;
            }else{
                $isUserName=true;
            }
        }

        if ($workOrderStatus !== FALSE &&in_array($workOrderStatus, [-1,0,1,2,3,4])) {
            $where['WO.work_order_status']=$workOrderStatus;
        }
        switch ($user['admin_type']) {
            case ADMIN_FACTORY://厂商
                $where['WO.factory_id']=$user['store_id'];
                break;
            case ADMIN_SERVICE://服务商
                $where['WO.store_id'] = $user['store_id'];
                break;
            case ADMIN_CHANNEL://渠道商
                $where['WO.post_store_id'] = $user['store_id'];
                break;
            case ADMIN_DEALER://零售商
                $where['WO.post_store_id'] = $user['store_id'];
                break;
            default:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
                break;
        }
        if ($isOrderSn) {
            $where['WO.order_sn']=$keyword;
        }
        if ($isWorkSn) {
            $where['WO.worder_sn']=$keyword;
        }
        if ($isMobile) {
            $where['WO.phone']=$keyword;
        }
        if ($isUserName) {
            $where['WO.user_name']=$keyword;
        }
        $order = 'WO.worder_id desc,WO.work_order_status ASC';
        $field = 'WO.worder_sn,WO.order_sn,UI.job_no,WO.work_order_type,WO.work_order_status,WO.region_name,WO.address,WO.phone,WO.user_name,WO.receive_time,WO.add_time';
        $join=[
            ['user_installer UI', 'WO.installer_id=UI.installer_id', 'LEFT'],
        ];
        $list = $this->_getModelList(db('work_order'), $where, $field, $order,'WO',$join);
        if ($list) {
            $list=array_map(function ($item) {
                $item['address']=str_replace(' ','',$item['region_name']).$item['address'];
                $item['work_order_status_desc']=get_work_order_status($item['work_order_status']);
                $item['work_order_type_desc']=get_work_order_type($item['work_order_type']);
                $item['receive_time']=time_to_date($item['receive_time']);
                $item['add_time']=time_to_date($item['add_time']);
                unset($item['region_name']);
                return $item;
            },$list);
        }
        $this->_returnMsg(['list' => $list]);
    }
    //获取工单详情
    protected function getWorkOrderDetail($return=false)
    {
        $user = $this->_checkUser();
        $worderSn = isset($this->postParams['worder_sn']) ? trim($this->postParams['worder_sn']) : '';
        if (empty($worderSn)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单号不能为空']);
        }
        $where = [
            'worder_sn' => $worderSn,
            'is_del' => 0,
            'status' => 1,
        ];
        switch ($user['admin_type']) {
            case ADMIN_FACTORY://厂商
                $where['factory_id'] = $user['store_id'];
                break;
            case ADMIN_SERVICE://服务商
                $where['store_id'] = $user['store_id'];
                break;
            case ADMIN_CHANNEL://渠道商
                $where['post_store_id'] = $user['store_id'];
                break;
            case ADMIN_DEALER://零售商
                $where['post_store_id'] = $user['store_id'];
                break;
            default:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
                break;
        }
        $field='worder_id,goods_id,worder_sn,order_sn,ossub_id,work_order_type,work_order_status,user_name,phone,appointment,finish_time,region_name,address,fault_desc,images,install_price,real_price,store_id,installer_id,dispatch_time,receive_time,sign_time,finish_time';
        $workOrderModel=new \app\common\model\WorkOrder();
        $info = $workOrderModel->field($field)->where($where)->find();
        if (empty($info)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单信息不存在']);
        }
        $info['store_name']=db('store')->where(['store_id'=>$info['store_id']])->value('name');
        $installer=db('user_installer')->field('realname,phone')->where(['installer_id'=>$info['installer_id']])->find();
        $info['installer_name']=isset($installer['realname'])?$installer['realname']:'';
        $info['installer_phone']=isset($installer['phone'])?$installer['phone']:'';
        unset($info['store_id'],$info['installer_id']);

        $dispatchStatus=db('work_order_installer_record')->where(['worder_id'=>$info['worder_id'],'is_del'=>0])->order('log_id desc')->value('action');

        $info['images']= $info['images'] ? explode(',',$info['images']) : [];
        $regionName=str_replace(' ','',$info['region_name']);
        $info['address']=$regionName.$info['address'];
        $log = db('work_order_log')->where(['worder_id' => $info['worder_id']])->order('log_id desc')->find();

        $info['msg']= $log['msg'];
        $info['dispatch_status']=$dispatchStatus;

        $info['log_action']=$log['action'];
        $info['log_msg']=$log['msg'];
        $info['dispatch_time']=time_to_date($info['dispatch_time']);
        $info['receive_time']=time_to_date($info['receive_time']);
        $info['sign_time']=time_to_date($info['sign_time']);
        $info['work_order_status_text']=get_work_order_status($info['work_order_status']);
        $info['work_order_type_text']=get_work_order_type($info['work_order_type']);
        $info['appointment']=time_to_date($info['appointment']);
        $info['finish_time']=time_to_date($info['finish_time']);
        if ($info['ossub_id']) {
            $join = [
                ['order_sku OS', 'OS.osku_id = OSS.osku_id', 'INNER'],
            ];
            $field =  'OS.sku_name, OS.sku_spec';
            $where = [
                'ossub_id' => $info['ossub_id'],
            ];
            $ossub = db('order_sku_sub')->field($field)->alias('OSS')->join($join)->where($where)->find();
            $info['goods_name']=$ossub['sku_name']?$ossub['sku_name']:$ossub['sku_spec'];
        }else{
            $infoSub = db('goods')->find($info['goods_id']);
            $info['goods_name']=$infoSub['name'];
        }
        //获取工单日志
        //$info['logs'] = db('work_order_log')->order('add_time DESC')->where(['worder_id' => $info['worder_id']])->select();
        //获取工单评价记录
        $info['assess_list']=[];
        $assessList = $workOrderModel->getWorderAssess($info,'assess_id,msg,add_time,type');
        //pre($assessList);
        if (!empty($assessList)) {
            $assessList=array_map(function ($item) {
                unset($item['assess_id']);
                $item['add_time']=time_to_date($item['add_time']);
                return $item;
            },$assessList);
            $info['assess_list']=$assessList;
        }
        unset($info['region_name'],$info['worder_id'],$info['goods_id'],$info['ossub_id']);
        $this->_returnMsg(['detail' => $info]);
    }
    //分派工单操作【服务商】
    protected function dispatchWorkOrder()
    {
        list($user,$installer)=$this->_checkInstaller();
        if (!in_array($user['admin_type'], [ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $jobNo = isset($this->postParams['job_no']) ? trim($this->postParams['job_no']) : '';
        if (empty($jobNo)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请选择售后工程师']);
        }
        $worderSn = isset($this->postParams['worder_sn']) ? trim($this->postParams['worder_sn']) : '';
        if (empty($worderSn)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单号不能为空']);
        }
        $model=new \app\common\model\WorkOrder();
        $worder=$model->where(['is_del'=>0,'worder_sn'=>$worderSn,'store_id'=>$user['store_id']])->find();
        if (empty($worder)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单号不存在或已删除']);
        }
        if ($user['store_id']!=$installer['store_id']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '只能派单到您下属工程师']);
        }
        $result = $model->worderDispatch($worder, $user, $installer['installer_id']);
        if ($result !== FALSE) {
            //发送派单通知给工程师
            $push = new \app\common\service\PushBase();
            $sendData = [
                'type'         => 'worker',
                'worder_sn'    => $worder['worder_sn'],
                'worder_id'    => $worder['worder_id'],
            ];
            //发送给服务商在线管理员
            $push->sendToUid(md5($installer['installer_id']), json_encode($sendData));
            $this->_returnMsg(['msg' => '售后工程师指派成功']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '操作失败【'.$model->error.'】']);
        }
    }
    //取消工单操作【服务商，零售商，服务商】
    protected function cancelWorkOrder()
    {
        $user=$this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL,ADMIN_DEALER,ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $worderSn = isset($this->postParams['worder_sn']) ? trim($this->postParams['worder_sn']) : '';
        if (empty($worderSn)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单号不能为空']);
        }
        $model=new \app\common\model\WorkOrder();
        $where['is_del']=0;
        $where['worder_sn']=$worderSn;
        switch ($user['admin_type']) {
            case ADMIN_FACTORY://厂商
                $where['factory_id'] = $user['store_id'];
                break;
            case ADMIN_SERVICE://服务商
                $where['store_id'] = $user['store_id'];
                break;
            case ADMIN_CHANNEL://渠道商
                $where['post_store_id'] = $user['store_id'];
                break;
            case ADMIN_DEALER://零售商
                $where['post_store_id'] = $user['store_id'];
                break;
            default:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
                break;
        }
        $worder=$model->where($where)->find();
        if (empty($worder)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单号不存在或已删除']);
        }

        $result = $model->worderCancel($worder, $user);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '操作失败，'.$model->error.'']);
        }else{
            $this->_returnMsg(['msg' => '取消工单成功']);
        }
    }
    //获取省份列表
    protected function getProvinceRegions()
    {
        $this->returnLogin = FALSE;
        $this->getRegions('region_id, region_name');
    }
    protected function getRegions($field = "")
    {
        $this->returnLogin = FALSE;
        parent::getRegions();
    }
    //根据省份获取服务商列表
    protected function getServiceListByRegion()
    {
        $regionId = isset($this->postParams['region_id']) ? intval($this->postParams['region_id']): 0;
        if (!$regionId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '省份ID不能为空']);
        }
        $region = db('region')->where(['region_id' => $regionId, 'is_del' => 0, 'parent_id' => ['>', 0]])->find();
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $childs = db('region')->where(['parent_id' => $regionId, 'is_del' => 0])->column('region_id');
        if (!$childs) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '参数错误']);
        }
        $where = [
            'is_del' => 0,
            'status' => 1,
            'check_status'=> 1,
            'factory_id'  => $user['factory_id'],
            'store_type' => STORE_SERVICE,
            'region_id' => ['IN', $childs],
        ];
        $field = 'store_no, name';
        $order = 'add_time DESC';
        
        $list = $this->_getModelList(db('store'), $where, $field, $order);
        $this->_returnMsg(['list' => $list]);
    }
    //获取工程师列表
    protected function getInstallerList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_FACTORY, ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $where = [
            'UI.is_del' => 0,
            'UI.check_status' => 1,
        ];
        $where['UI.is_del']=0;
        if ($user['admin_type'] == ADMIN_FACTORY) {
            $where['UI.factory_id']=$user['store_id'];
        } elseif ($user['admin_type'] == ADMIN_SERVICE) {
            $where['UI.store_id']=$user['store_id'];
        }
        $sortorder = isset($this->postParams['sortorder']) ? trim($this->postParams['sortorder']) : '';
        $key = isset($this->postParams['key']) ? trim($this->postParams['key']) : '';
        $storeNo = isset($this->postParams['store_no']) ? trim($this->postParams['store_no']) : '';
        if ($storeNo && $user['admin_type'] == ADMIN_FACTORY) {
            $store=db('store')->where(['store_no'=>$storeNo,'is_del'=>0,'store_type'=>STORE_SERVICE])->find();
            if (empty($store)) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务商不存在或已被删除']);
            }
            if ($store['status']==0) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务商已被禁用']);
            }
            $where['UI.store_id']=$store['store_id'];
        }
        if (!empty($key)) {
            $where['UI.realname|UI.phone']=['like','%'.$key.'%'];
        }
        $order = '';
        if (in_array($sortorder, ['count', 'score'])) {
            if ($sortorder == 'count') {
                $order .= 'UI.service_count DESC, ';
            }else{
                $order .= 'UI.score DESC, ';
            }
        }
        $order .= 'UI.add_time DESC';
        $field = 'UI.realname,UI.phone,UI.status,UI.service_count,UI.score,UI.job_no,S.name store_name,S.store_no';
        $join=[
            ['store S', 'S.store_id = UI.store_id', 'LEFT'],
        ];
        $list = $this->_getModelList(db('user_installer'), $where, $field, $order,'UI',$join);
        $this->_returnMsg(compact('list'));
    }
    //获取工程师审核列表
    protected function getInstallerCheckList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $field='job_no,realname,phone,status,check_status,admin_remark,add_time';
        $keyword = isset($this->postParams['keyword']) ? trim($this->postParams['keyword']) : '';
        $status = isset($this->postParams['status']) ? intval($this->postParams['status']) : 0;

        $isMobile=false;
        $isUserName=false;
        if (!empty($keyword)) {
             if (preg_match('/^\d{11}$/',$keyword)) {
                $isMobile=true;
            }else{
                $isUserName=true;
            }
        }

        $where=['is_del'=>0];
        switch ($status) {
            case 1://待审核
                $where['check_status']=['in',[0,-1,-3]];
                break;
            case 2://已通过
                $where['check_status']=1;
                break;
            case 3://已拒绝
                $where['check_status']=['in',[-2,-4]];
                break;
            default://全部
                break;
        }
        if ($isMobile) {
            $where['phone']=$keyword;
        }
        if ($isUserName) {
            $where['realname']=['like','%'.$keyword.'%'];
        }
        //if (!empty($key)) {
        //    $where['realname|phone']=['like','%'.$key.'%'];
        //}
        if ($user['admin_type'] == ADMIN_FACTORY) {
            $where['factory_id']=$user['store_id'];
        } elseif ($user['admin_type'] == ADMIN_SERVICE) {
            $where['store_id']=$user['store_id'];
        }
        $order='add_time DESC';
        $list = $this->_getModelList(db('user_installer'), $where, $field, $order);
        if (!empty($list)) {
            $list=array_map(function ($item) {
                $item['check_status_desc']=get_installer_status($item['check_status']);
                $item['add_time']=time_to_date($item['add_time']);
                return $item;
            },$list);
        }
        $this->_returnMsg(compact('list'));
    }
    //获取工程师审核详情
    protected function getInstallerCheckDetail()
    {
        $field = 'store_id,job_no,realname,phone,idcard_font_img,idcard_back_img,check_status,security_record_num,add_time,remark,admin_remark,update_time';
        list($user, $info) = $this->_checkInstaller($field);
        if (!in_array($user['admin_type'], [ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        unset($info['store_id']);
        $info['check_status_desc']=get_installer_status($info['check_status']);
        $this->_returnMsg(['detail' => $info]);
    }
    //工程师审核操作
    protected function checkInstaller()
    {
        list($user, $info) = $this->_checkInstaller();
        if (!in_array($user['admin_type'], [ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }

        $checkStatus = $info['check_status'];
        if ($checkStatus == 1) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工程师已经通过审核']);
        }
        if (in_array($checkStatus, [-2, -4])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '该工程师已经被拒绝，请重新发起审核申请']);
        }

        if (!in_array($checkStatus, [-1, -3])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请先操作已审核']);
        }
        //if ($user['admin_type'] == ADMIN_FACTORY && $checkStatus != -1) {
        //    $this->error(lang('NO_OPERATE_PERMISSION'));
        //}
        if ($user['admin_type'] == ADMIN_SERVICE && $checkStatus != -3) {
            $this->_returnMsg(['errCode' => 2, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $remark = isset($this->postParams['remark']) ? trim($this->postParams['remark']) : '';
        $checkResult = isset($this->postParams['check_result']) ? intval($this->postParams['check_result']) : '';
        if (empty($checkResult)) {
            $this->_returnMsg(['errCode' => 3, 'errMsg' => '审核结果不能为空']);
        }
        $checkResult = ($checkResult == 1) ? 1 : -1;
        if ($checkResult == -1 && empty($remark)) {
            $this->_returnMsg(['errCode' => 4, 'errMsg' => '请填写拒绝理由']);
        }
        //状态(0待审核 1审核成功 -1厂商审核中 -2厂商拒绝 -3服务商审核中 -4服务商拒绝)
        $status = '';
        if ($checkResult == 1) {
            if ($user['admin_type'] == ADMIN_FACTORY) {
                $status = 1;
            }else{
                //判断是否需要厂商审核
                $config = get_store_config($user['factory_id'], TRUE, 'default');
                //默认需要厂商审核
                if (!isset($config['installer_check']) || $config['installer_check'] > 0) {
                    $status = -1;
                }else {
                    //服务商和厂商都不审核,直接通过
                    $status = 1;
                }
            }
        } else {
            $status = $user['admin_type'] == ADMIN_FACTORY ? -2: -4;
        }
        $data = [
            'check_status' => $status,
            'admin_remark' => $remark,
        ];
        $toUser=[
            'phone'=>$info['phone'],
            'realname'=>$info['realname'],
            'user_id'=>$info['user_id'],
        ];
        $result = $info->save($data, ['installer_id' => $info['installer_id']]);
        if ($result !== FALSE) {
            //申请审核后通知工程师
            $informModel = new \app\common\model\LogInform();
            if ($status == 1) {
                $informModel->sendInform($user['factory_id'], 'sms', $toUser, 'installer_check_success');
            } else {
                $informModel->sendInform($user['factory_id'], 'sms', $toUser, 'installer_check_fail');
            }
            $this->_returnMsg(['msg' => '操作成功']);
        } else {
            $this->_returnMsg(['errCode' => 5, 'errMsg' => '操作失败']);
        }
    }
    //获取工程师详情
    protected function getInstallerDetail()
    {
        $field = 'store_id, job_no, realname, phone, idcard_font_img, idcard_back_img, status, service_count, score, security_record_num, add_time';
        list($user,$info)=$this->_checkInstaller($field);
        $info['store_name'] = db('store')->where('store_id',$info['store_id'])->value('name');
        unset($info['store_id']);
        $this->_returnMsg(['detail' => $info]);
    }
    //编辑工程师信息
    protected function editInstaller()
    {
        list($user,$info)=$this->_checkInstaller();
        if (!in_array($user['admin_type'], [ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $data['realname'] = isset($this->postParams['realname']) ? trim($this->postParams['realname']) : '';
        $data['phone'] = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        if (empty($data['realname'])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工程师姓名不能为空']);
        }
        if (empty($data['phone'])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工程师手机号不能为空']);
        }
        $user=new \app\common\model\User;
        if ($user->checkPhone(0,$data['phone'])===FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '手机号格式不正确']);
        }

        $data['idcard_font_img'] = isset($this->postParams['idcard_font_img']) ? trim($this->postParams['idcard_font_img']) : '';
        $data['idcard_back_img'] = isset($this->postParams['idcard_back_img']) ? trim($this->postParams['idcard_back_img']) : '';
        $data['security_record_num'] = isset($this->postParams['security_record_num']) ? trim($this->postParams['security_record_num']) : '';
        $data=array_filter($data, function ($item) {
            return !empty($item);
        });
        if (empty($data)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请提交要保存的数据']);
        }
        if (db('user_installer')->where('installer_id',$info['installer_id'])->update($data)) {
            $this->_returnMsg(['msg' => 'ok']);
        }
        $this->_returnMsg(['errCode' => 1, 'errMsg' => '保存失败']);
    }
    //设置工程师状态
    protected function setInstallerStatus()
    {
        list($user,$info)=$this->_checkInstaller();
        if (!in_array($user['admin_type'], [ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $status = isset($this->postParams['status']) ? trim($this->postParams['status']) : '';
        if ('' === $status) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '设置状态不能为空']);
        }
        $status=($status==0)?0:1;
        $desc=$status==0?'禁用':'启用';
        if ($info['status'] == $status) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '该工程师已被'.$desc.'!']);
        }
        if (db('user_installer')->where('installer_id',$info['installer_id'])->update(['status'=>$status])) {
            $this->_returnMsg(['msg' => $desc.'工程师操作成功']);
        }
        $this->_returnMsg(['errCode' => 1, 'errMsg' => $desc.'失败']);
    }
    //删除工程师
    protected function delInstaller()
    {
        list($user,$info)=$this->_checkInstaller();
        if (!in_array($user['admin_type'], [ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        if ($info['check_status']!=1) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $exist = db('work_order')->where(['installer_id' => $info['installer_id']])->find();
        if ($exist) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工程师存在工单记录,不允许删除']);
        }
        $result = db('user_installer')->where('installer_id',$info['installer_id'])->update(['is_del'=>1]);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '删除失败']);
        }
        $this->_returnMsg(['msg' => '工程师删除成功']);
    }
    //获取当前商户的财务数据[渠道商/服务商]
    protected function getFinanceData()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL,ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $result=$this->_withdrawConfig($user);
        $this->_returnMsg(['detail' => $result]);
    }
    //申请提现[渠道商/服务商]
    protected function applyWithdraw()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL,ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $check=$this->_withdrawConfig($user);
        $start=$check['withdraw_start_date'];
        $end=$check['withdraw_end_date'];
        if (!$check['is_withdraw']) {
            $this->_returnMsg(['errCode' => 2, 'errMsg' => '每月提现时间：'.$start.'日-'.$end.'日']);
        }
        //获取当前商户提现信息
        $bankModel = db('store_bank');
        $bankType = 1;//银行卡
        $bank = $bankModel->where(['is_del' => 0, 'bank_type' => $bankType, 'store_id' => $user['store_id']])->find();
        if (!$bank) {
            $this->_returnMsg(['errCode' => 3, 'errMsg' => '请先绑定银行卡号']);
        }
        if ($check['amount'] <= 0) {
            $this->_returnMsg(['errCode' => 4, 'errMsg' => '没有可提现额度']);
        }
        $minAmount = isset($check['withdraw_min_amount']) && $check['withdraw_min_amount']>0 ? $check['withdraw_min_amount'] : 100;

        if ($check['amount'] < $minAmount) {
            $this->_returnMsg(['errCode' => 5, 'errMsg' => '单笔最低提现金额为'.$minAmount.'元，余额不足，暂不允许提现']);
        }
        $amount = isset($this->postParams['amount']) && $this->postParams['amount'] ? floatval($this->postParams['amount']) : 0;
        $msg = isset($this->postParams['remark']) && $this->postParams['remark'] ? trim($this->postParams['remark']) : '';
        if ($amount <= 0) {
            $this->_returnMsg(['errCode' => 6, 'errMsg' => '提现金额有误，请重新输入，确认无误后再提交']);
        }
        if ($amount < $minAmount) {
            $this->_returnMsg(['errCode' => 7, 'errMsg' => '单笔最低提现金额为'.$minAmount.'元']);
        }
        if ($amount>$check['amount']) {
            $this->_returnMsg(['errCode' => 8, 'errMsg' => '最多可提现'.$check['amount'].'元']);
        }

        $storeType=db('store')->where([
            'is_del'=>0,
            'store_id'=>$user['store_id'],
            'status'=>1,
        ])->value('store_type');
        $data = [
            'store_id'  => $this->factory['store_id'],
            'user_id'   => $user['user_id'],
            'amount'    => $amount,
            'add_time'  => time(),

            'bank_id'   => $bank['bank_id'],
            'realname'  => $bank['realname'],
            'bank_name' => $bank['bank_name'],
            'bank_no'   => $bank['bank_no'],
            'bank_detail' => json_encode($bank),
            'apply_msg' => $msg,

            'update_time' => time(),
            'from_store_id'=> $user['store_id'],
            'from_store_type'=> $storeType,
            'withdraw_status'=> 0,
        ];
        $logId = db('store_withdraw')->insertGetId($data);
        if ($logId) {
            //记录成功后减少可提现金额
            $financeModel = new \app\common\model\StoreFinance();
            $result = $financeModel->financeChange($user['store_id'], ['amount' => -$amount], '申请提现', '');
            if (!$result) {
                db('store_withdraw')->where(['log_id' => $logId])->update(['status' => 0, 'is_del' => 1]);
            }
            $this->_returnMsg(['msg' => '提现申请成功,请耐心等待审核']);
        }else{
            $this->_returnMsg(['errCode' => 9, 'errMsg' => '申请提交异常']);
        }
    }
    //获取提现记录[渠道商/服务商]
    protected function getWithdrawList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL,ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $where=[
            'is_del'=>0,
            'from_store_id'=>$user['store_id'],
        ];
        //提现状态(0申请中 1审核通过-提现中 2提现成功 -1 拒绝提现 -2提现失败)
        //$status = isset($this->postParams['status']) ? trim($this->postParams['status']) : '';
        //if ('' !== $status && in_array($status,['-2','-1','0','1','2'])) {
        //    $where['withdraw_status']=intval($status);
        //}
        $field='log_id id,add_time,amount,withdraw_status';
        $order='add_time DESC';
        $list=$this->_getModelList(db('store_withdraw'),$where,$field,$order);
        if ($list) {
            $list=array_map(function ($item){
                $item['add_time']=time_to_date($item['add_time']);
                $item['status_desc']=get_withdraw_status($item['withdraw_status']);
                return $item;
            },$list);
        }
        $this->_returnMsg(['list' => $list]);
    }
    //获取提现详情[渠道商/服务商]
    protected function getWithdrawDetail()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL,ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $id = isset($this->postParams['id']) ? intval($this->postParams['id']) : '';
        if (empty($id)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '提现ID不能为空']);
        }
        $where=[
            'is_del'=>0,
            'from_store_id'=>$user['store_id'],
            'log_id'=>$id,
        ];
        $field='log_id id,amount,withdraw_status,bank_name,bank_no,add_time,remark';
        $detail=db('store_withdraw')->field($field)->where($where)->find();
        if (empty($detail)) {
            $this->_returnMsg(['errCode' =>104, 'errMsg' => '提现记录不存在']);
        }
        $detail['status_desc']=get_withdraw_status($detail['withdraw_status']);
        $detail['add_time']=time_to_date($detail['add_time']);
        $detail['bank_no']=str_encode($detail['bank_no'],0,4);
        $this->_returnMsg(['detail' => $detail]);
    }
    //获取渠道商收益列表
    protected function getChannelIncomeList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $model=db('store_commission');
        $where=[
            'C.is_del'=>0,
            'C.store_id'=>$user['store_id'],
        ];
        $field='C.log_id id,C.income_amount,S.`name` store_name,C.commission_status,C.add_time';
        $join=[
            ['store S', 'S.store_id = C.from_store_id', 'LEFT'],
            //['goods G', 'G.goods_id = C.goods_id', 'LEFT'],
        ];
        $order='C.add_time DESC';
        $list=$this->_getModelList($model,$where,$field,$order,'C',$join);
        if (empty($list)) {
            $this->_returnMsg(['errCode' =>104, 'errMsg' => '暂无数据']);
        }
        $list=array_map(function ($item) {
            $item['add_time']=time_to_date($item['add_time']);
            $item['com_status_desc']=get_commission_status($item['commission_status']);
            return $item;
        },$list);
        $this->_returnMsg(['list' => $list]);
        //pre($list);
    }
    //获取渠道商收益详情
    protected function getChannelIncomeDetail()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $id = isset($this->postParams['id']) ? intval($this->postParams['id']) : '';
        if ($id<=0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '参数错误[ID]']);
        }
        $model=db('store_commission');
        $where=[
            'C.is_del'=>0,
            'C.store_id'=>$user['store_id'],
            'C.log_id'=>$id,
        ];
        $field='C.log_id id,C.order_sn,C.income_amount,C.order_amount,C.commission_status,G.`name` goods_name,S.`name` store_name,C.add_time';
        $join=[
            ['store S', 'S.store_id = C.from_store_id', 'LEFT'],
            ['goods G', 'G.goods_id = C.goods_id', 'LEFT'],
        ];
        $detail=$model->alias('C')->field($field)->where($where)->join($join)/*->fetchSql(true)*/->find();
        if (empty($detail)) {
            $this->_returnMsg(['errCode' =>1, 'errMsg' => '查无该订单的佣金信息']);
        }
        $detail['add_time']=time_to_date($detail['add_time']);
        $detail['com_status_desc']=get_commission_status($detail['commission_status']);
        $this->_returnMsg(['detail' => $detail]);
    }
    //获取服务商收益列表
    protected function getServiceIncomeList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $model=db('store_service_income');
        $where=[
            'SI.is_del'=>0,
            'SI.store_id'=>$user['store_id'],
        ];
        $field='SI.log_id id,SI.worder_sn,SI.income_amount,UI.realname,SI.income_status,SI.add_time';
        $join=[
            ['user_installer UI', 'UI.installer_id = SI.installer_id', 'LEFT'],
        ];
        $order='SI.add_time DESC';
        $list=$this->_getModelList($model,$where,$field,$order,'SI',$join);
        if ($list) {
            $list=array_map(function ($item) {
                $item['add_time']=time_to_date($item['add_time']);
                $item['income_status_desc']=get_commission_status($item['income_status']);
                return $item;
            },$list);
        }
        $this->_returnMsg(['list' => $list]);
    }
    //获取服务商收益详情
    protected function getServiceIncomeDetail()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $id = isset($this->postParams['id']) ? intval($this->postParams['id']) : '';
        if ($id<=0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '参数错误[ID]']);
        }
        $model=db('store_service_income');
        $where=[
            'SI.is_del'=>0,
            'SI.store_id'=>$user['store_id'],
            'SI.log_id'=>$id,
        ];
        $field='SI.log_id id,SI.worder_sn,SI.install_amount,SI.income_amount,SI.income_status,G.`name` goods_name,UI.realname,SI.add_time';
        $join=[
            ['user_installer UI', 'UI.installer_id = SI.installer_id', 'LEFT'],
            ['goods G', 'G.goods_id = SI.goods_id', 'LEFT'],
        ];
        $detail=$model->alias('SI')->field($field)->where($where)->join($join)->find();
        if (empty($detail)) {
            $this->_returnMsg(['errCode' =>1, 'errMsg' => '收益不存在']);
        }
        //dump($model->getLastSql());
        $detail['add_time']=time_to_date($detail['add_time']);
        $detail['income_status_desc']=get_commission_status($detail['income_status']);
        $this->_returnMsg(['detail' => $detail]);
    }
    //获取服务商 、服务商提现配置
    protected function getWithdrawConfig()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL,ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $model = db('store_bank');
        $where=[
            'is_del'=>0,
            'bank_type'=>1,
            'store_id'=>$user['store_id'],
        ];
        $field='bank_id id,bank_no,realname,id_card,bank_name,bank_branch,region_name,region_id';
        $info=$model->field($field)->where($where)->find();
        if (empty($info)) {
            $this->_returnMsg(['errCode' =>104, 'errMsg' => '请先设置提现卡']);
        }
        $info['id_card_encode']=str_encode($info['id_card'],4,4);
        $info['bank_no_encode']=str_encode($info['bank_no'],0,4);
        $info['realname_encdoe']=str_encode($info['realname'],0,1);
        //pre($model->getLastSql(),1);
        $this->_returnMsg(['detail' => $info]);
    }
    //添加提现银行卡
    protected function addWithdrawConfig()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL,ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $model = db('store_bank');
        $where=[
            'is_del'=>0,
            'bank_type'=>1,
            'store_id'=>$user['store_id'],
        ];
        $exist=$model->where($where)->find();
        if (!empty($exist)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前商户已经绑定过提现银行卡']);
        }
        $data=$this->_withdrawCheck();
        $data['bank_type']  = 1;
        $data['store_id']   = $user['store_id'];
        $data['add_time']   = time();
        $data['post_user_id'] = $user['user_id'];
        $result = $model->insertGetId($data);
        if (!$result){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '添加失败']);
        }
        $this->_returnMsg(['msg' => '添加成功']);
    }
    //编辑提现银行卡
    protected function editWithdrawConfig()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL,ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $id = isset($this->postParams['id']) ? intval($this->postParams['id']) : '';
        if ($id<=0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '参数错误[ID]']);
        }
        $model = db('store_bank');
        $where=[
            'is_del'=>0,
            'bank_type'=>1,
            'store_id'=>$user['store_id'],
            'bank_id'=>$id,
        ];
        $bank=$model->where($where)->find();
        if (empty($bank)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '查无该银行卡']);
        }
        $data=$this->_withdrawCheck();
        $result=$model->where('bank_id',$id)->update($data);
        if ($result === false) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '保存失败']);
        }
        $this->_returnMsg(['msg' => '保存成功']);
    }

	//启用、禁用零售商
    protected function setDealerStatus()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $storeNo = isset($this->postParams['store_no']) ? trim($this->postParams['store_no']) : '';
        if (!isset($this->postParams['status'])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '参数错误[STATUS]']);
        }
        $status =intval($this->postParams['status']) ? 1 : 0;
        $status=$status? 1:0;
        if (empty($storeNo)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '参数错误[STORE_NO]']);
        }
        $store=db('store')->where(['is_del'=>0,'store_no'=>$storeNo,'store_type'=>STORE_DEALER])->find();
        if (empty($store)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '编号不正确或该零售商不存在']);
        }
        $result=db('store')->where('store_id',$store['store_id'])->update(['status'=>$status]);
        if ($result === false) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '保存失败']);
        }
        $this->_returnMsg(['msg' => '成功']);
    }

    /**NOTICE:============以下为封装函数信息,不允许第三方接口直接调用================================================================*****************************************************************、
     */
    private function _withdrawConfig($user)
    {
        $model=new \app\common\model\StoreFinance;
        $info=$model->where('store_id', $user['store_id'])->find();
        if (empty($info)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '暂无数据']);
        }
        $info=$info->toArray();
        $config = get_store_config($user['factory_id'], TRUE, 'default');
        $setting['withdraw_start_date']='';
        $setting['withdraw_end_date']='';
        $setting['is_withdraw']=0;
        $setting['withdraw_min_amount']=isset($config['withdraw_min_amount'])?$config['withdraw_min_amount']:100;
        //判断商户是否可提现
        if ($config && isset($config['monthly_withdraw_start_date']) && isset($config['monthly_withdraw_end_date'])) {
            $setting['withdraw_start_date']=$min = intval($config['monthly_withdraw_start_date']);
            $setting['withdraw_end_date']=$max = intval($config['monthly_withdraw_end_date']);
            $day = intval(date('d'));
            if ($day >= $min && $day <= $max) {
                $setting['is_withdraw']=1;
            }
        }
        $return =array_merge($info,$setting);
        unset($return['store_id']);
        return $return;
    }
    private function _withdrawCheck()
    {
        $data['realname'] = isset($this->postParams['realname']) ? trim($this->postParams['realname']) : '';
        $data['id_card'] = isset($this->postParams['id_card']) ? trim($this->postParams['id_card']) : '';
        $data['bank_name'] = isset($this->postParams['bank_name']) ? trim($this->postParams['bank_name']) : '';
        $data['bank_branch'] = isset($this->postParams['bank_branch']) ? trim($this->postParams['bank_branch']) : '';
        $data['bank_no'] = isset($this->postParams['bank_no']) ? trim($this->postParams['bank_no']) : '';
        $data['region_name'] = isset($this->postParams['region_name']) ? trim($this->postParams['region_name']) : '';
        $data['region_id'] = isset($this->postParams['region_id']) ? intval($this->postParams['region_id']) : 0;
        if (!$data['realname']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请填写持卡人姓名']);
        }
        if (!$data['id_card']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请填写持卡人身份证号']);
        }
        if (!$data['bank_name']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请填写银行卡名称']);
        }
        if (!$data['bank_branch']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请填写开户行支行信息']);
        }
        if (!$data['bank_no']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请填写银行卡号']);
        }
        if (!$data['region_name'] || $data['region_id']<=0 ) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请选择开户行所在地']);
        }
        return $data;
    }
    /**
     * 用户提交参数处理
     */
    protected function _checkPostParams()
    {
        if (!isset($_SERVER['HTTP_ORIGIN'])) {
            return parent::_checkPostParams();
        }
        $this->requestTime = time();
        $this->visitMicroTime = $this->_getMillisecond();//会员访问时间(精确到毫秒)
        $this->postParams = $this->request->param();
        if (!$this->postParams) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请求参数异常']);
        }
        if (isset($this->postParams['callback'])) {
            unset($this->postParams['callback']);
            unset($this->postParams['_']);
        }
    }
    /**
     * 处理接口返回信息
     */
    protected function _returnMsg($data, $echo = TRUE){
        if ($this->returnLogin) {
            $data['errLogin'] = isset($data['errLogin']) ? intval($data['errLogin']) : 0;
        }else{
            $data['errLogin'] = FALSE;
        }
        $result = parent::_returnMsg($data);
    }
    /**
     * 验证商户表单信息
     * @param int $storeType
     */
    private function _verifyStoreForm($storeType = STORE_DEALER)
    {
        $data = [];
        $sname      = $data['name'] = isset($this->postParams['name']) ? htmlspecialchars(trim($this->postParams['name'])) : '';
        $userName   = $data['user_name'] = isset($this->postParams['user_name']) ? htmlspecialchars(trim($this->postParams['user_name'])) : '';
        $mobile     = $data['mobile'] = isset($this->postParams['mobile']) ? htmlspecialchars(trim($this->postParams['mobile'])) : '';
        $sampleAmount   = $data['sample_amount'] = isset($this->postParams['sample_amount']) ? intval($this->postParams['sample_amount']) : '';
        $regionId   = $data['region_id'] = isset($this->postParams['region_id']) ? intval($this->postParams['region_id']) : '';
        $regionName = $data['region_name'] = isset($this->postParams['region_name']) ? htmlspecialchars(trim($this->postParams['region_name'])) : '';
        $address    = $data['address'] = isset($this->postParams['address']) ? htmlspecialchars(trim($this->postParams['address'])) : '';
        $idcardFontImg  = $data['idcard_font_img'] = isset($this->postParams['idcard_font_img']) ? trim($this->postParams['idcard_font_img']) : '';
        $idcardBackImg  = $data['idcard_back_img'] = isset($this->postParams['idcard_back_img']) ? trim($this->postParams['idcard_back_img']) : '';
        $signingContractImg = $data['signing_contract_img'] = isset($this->postParams['signing_contract_img']) ? trim($this->postParams['signing_contract_img']) : '';
        $licenseImg     = $data['license_img'] = isset($this->postParams['license_img']) ? trim($this->postParams['license_img']) : '';
        $groupPhoto     = $data['group_photo'] = isset($this->postParams['group_photo']) ? trim($this->postParams['group_photo']) : '';
        $name = get_store_type($storeType);
        if (!$sname){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $name.'名称不能为空']);
        }
        if (!$userName){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $name.'联系人姓名不能为空']);
        }
        //if (!$mobile){
        //    $this->_returnMsg(['errCode' => 1, 'errMsg' => $name.'联系电话不能为空']);
        //}
        if ($storeType == STORE_DEALER && $sampleAmount < 0){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '采购样品金额不能小于0']);
        }
        if ($regionId <= 0 || !$regionName){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请选择'.$name.'区域']);
        }
        if ($storeType == STORE_DEALER && !$address){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $name.'地址详情不能为空']);
        }
        /* if (!$idcardFontImg){
         $this->_returnMsg(['errCode' => 1, 'errMsg' => '请上传公司法人身份证正面']);
         }
         if (!$idcardBackImg){
         $this->_returnMsg(['errCode' => 1, 'errMsg' => '请上传公司法人身份证背面']);
         }
         if (!$signingContractImg){
         $this->_returnMsg(['errCode' => 1, 'errMsg' => '请上传签约合同']);
         } */
        return $data;
    }
    /**
     * 获取工程师信息
     * @return array
     */
    private function _checkInstaller($field = '*')
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_FACTORY, ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        $jobNo = isset($this->postParams['job_no']) ? trim($this->postParams['job_no']) : '';
        if (empty($jobNo)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工程师工号不能为空']);
        }
        $userInstallerModel = new \app\common\model\UserInstaller();
        $info = $userInstallerModel->field($field)->where(['is_del' => 0, 'job_no' => $jobNo, 'factory_id' => $this->factory['store_id']])->find();
        if (empty($info)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工号不正确或该工程师已被删除']);
        }
        if ($user['admin_type'] == ADMIN_SERVICE && $info['store_id'] != $user['store_id']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('NO_OPERATE_PERMISSION')]);
        }
        return [$user,$info];
        
    }
    /**
     * 获取当前用户登录信息
     * @param boolean $checkFlag 是否验证用户对应商户信息
     * @return array
     */
    private function _checkUser($checkFlag = TRUE)
    {
        if (isset($this->postParams['TEST']) && $this->postParams['TEST']) {
             //$userId = 2;//厂商
             $userId =4;//渠道商
             //$userId = 5;//零售商
             //$userId = 6;//服务商
             
             $userId = isset($this->postParams['user_id']) ? intval($this->postParams['user_id']) : $userId;
             $loginUser = db('user')->alias('U')->join('store S', 'S.store_id = U.store_id', 'INNER')->field('user_id, U.factory_id, U.store_id, store_no, store_type, admin_type, is_admin, username, realname, nickname, phone, U.status')->find($userId);
             if (!$loginUser) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员不存在或已删除']);
             }
             return $loginUser ? $loginUser : [];
        }
        $loginUser = session('api_admin_user');
        $sessionUdata = session('api_user_data');
        if ($loginUser) {
            if (!$checkFlag) {
                return $loginUser;
            }
            $store = db('store')->where(['store_id' => $loginUser['store_id'], 'is_del' => 0])->find();
            if (!$store) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户不存在或已删除']);
            }
            $source=session('api_source');
            if (!$store['status']) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户已禁用,请联系厂商启用后登录']);
            }
            if ($store['check_status'] == 0) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户申请审核中', 'errLogin' => 4,'source'=>$source]);
            }
            if ($store['check_status'] == 2) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户申请已拒绝', 'errLogin' => 4,'source'=>$source]);
            }
            return $loginUser;
        }
        if (!$sessionUdata || !isset($sessionUdata['udata_id'])) {
            $this->_returnMsg(['msg' => '前往授权页面', 'errLogin' => 1]);
        }
        $this->_returnMsg(['msg' => '已授权,前往登录页面', 'errLogin' => 2]);//已授权未绑定
    }
    /**
     * 获取微信授权用户信息
     * @return array
     */
    private function _getScopeUser()
    {
        if (session('api_admin_user')) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '您已经登录', 'errLogin' => 0]);
        }
        $sessionUdata = session('api_user_data');
        if (!$sessionUdata || !isset($sessionUdata['udata_id'])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请授权后操作', 'errLogin' => 1]);
        }
        //判断授权微信用户是否已经绑定用户信息
        $udata = db('user_data')->where(['udata_id' => $sessionUdata['udata_id'], 'factory_id' => $this->factory['store_id'], 'third_type' => $this->thirdType])->find();
        if (!$udata) {
            session('api_user_data', []);
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '微信用户不存在,请重新授权', 'errLogin' => 1]);
        }
        if ($udata['user_id'] > 0 && isset($sessionUdata['store_id']) && $sessionUdata['store_id']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '不能重复绑定']);
        }
        return $sessionUdata;
    }
    /**
     * 执行登录
     * @param int $userId
     * @param string $thirdOpenid
     */
    private function _setLogin($userId, $thirdOpenid = '')
    {
        $userModel = new \app\common\model\User();
        $user = $userModel->where(['user_id' => $userId, 'is_del' => 0])->find();
        if (!$user) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户不存在或已删除']);
        }
        if ($user['status'] !== 1) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户已被禁用']);
        }
        $storeId=(int)$user['store_id'];
        $source=$user['source'] ? $user['source']: session('api_source');
        if ($storeId <= 0) {
            $this->_returnMsg(['msg' => '请填写商家资料', 'errLogin' => 3,'source'=>$source]);
        }
        $store = db('store')->where(['store_id' => $storeId, 'is_del' => 0])->find();

        if (empty($store)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '该商户不存在或已被删除']);
        }
        if ($store['status'] != 1) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '该商户已被禁用']);
        }

        if ($store['check_status'] == 0 && $store['name'] && $store['user_name']) {
            $this->_returnMsg(['msg' => '审核中，请耐心等待', 'errLogin' => 4,'source'=>$source]);
        }
        if ($store['check_status']==2) {
            $this->_returnMsg(['msg' => '审核已不通过，请重新提交资料', 'errLogin' => 4,'source'=>$source]);
        }
        $user['third_openid'] = $thirdOpenid;
        $result = $userModel->setLogin($user, $user['user_id'], 'api_admin');
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }else{
            $store = db('store')->where(['store_id' => $user['store_id'], 'is_del' => 0])->field('store_no, name, store_type')->find();
            $udata=db('user_data')->where(['third_openid'=>$thirdOpenid,'is_del'=>0])->find();
            $userinfo = [
                'admin_type'=> $user['admin_type'],
                'username'  => $user['username'],
                'realname'  => $user['realname'],
                'nickname'  => $user['nickname'],
                'phone'     => $user['phone'],
                'status'    => $user['status'],
                'avatar'    => isset($udata['avatar'])?$udata['avatar']:'',
            ];
            session('api_user_data', []);//商户绑定以及审核之前的临时变量，走注册完流程后，删除
            session('udata',$udata);
            $this->_returnMsg(['msg' => '登录成功', 'errLogin' => 0, 'user' => $userinfo, 'store' => $store]);//0无异常 1前往授权 2授权成功,需绑定账号
        }
    }
}