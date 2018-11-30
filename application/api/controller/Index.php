<?php
namespace app\api\controller;
class Index extends BaseApi
{
    var $method;
    var $reduceStock;
    var $page;
    var $pageSize;
    
    var $signKeyList;
    var $signKey;
    var $fromSource;
    public function __construct(){
        parent::__construct();
        $this->_checkPostParams();
        $this->method = trim($this->postParams['method']);
        $this->page = isset($this->postParams['page']) && $this->postParams['page'] ? intval($this->postParams['page']) : 0;
        $this->pageSize = isset($this->postParams['page_size']) && $this->postParams['page_size'] ? intval($this->postParams['page_size']) : 0;
        if ($this->pageSize > 50) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '单页显示数量(page_size)不能大于50']);
        }
        $this->signKey = isset($this->postParams['signkey']) && $this->postParams['signkey'] ? trim($this->postParams['signkey']) : '';
        //客户端签名密钥get_nonce_str(12)
        $this->signKeyList = array(
            'Applets'   => '8c45pve673q1',
            'TEST'      => 'ds7p7auqyjj8',
        );
        $this->verifySignParam($this->postParams);
        //请求参数验证
        foreach($this->signKeyList as $key => $value) {
            if($this->signKey == $value) {
                $this->fromSource = trim($key);
                break;
            }else{
                continue;
            }
        }
    }
    public function index()
    {
        if (!$this->method) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '接口方法(method)缺失']);
        }
        if ($this->method == 'index' || substr($this->method, 0, 1) == '_') {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '接口方法(method)错误']);
        }
        $method = $this->method;
        //判断方法是否存在
        if (!method_exists($this, $method)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '接口方法(method)错误']);
        }
        $this->$method();
    }
    //授权登录
    protected function authorizedLogin()
    {
        $thirdType      = isset($this->postParams['third_type']) ? trim($this->postParams['third_type']) : '';
        $thirdOpenid    = isset($this->postParams['third_openid']) ? trim($this->postParams['third_openid']) : '';
        $nickname       = isset($this->postParams['nickname']) ? trim($this->postParams['nickname']) : '';
        $avatar         = isset($this->postParams['avatar']) ? trim($this->postParams['avatar']) : '';
        $gender         = isset($this->postParams['gender']) ? trim($this->postParams['gender']) : 0;
        $unionid        = isset($this->postParams['unionid']) ? trim($this->postParams['unionid']) : '';
        if (!$thirdType){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '第三方授权登录类型(third_type)缺失']);
        }
        if (!$thirdOpenid){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '第三方账号唯一标识(third_openid)缺失']);
        }
        $thirdTypes = [
            'wechat_applet' => '微信小程序',
        ];
        if (!isset($thirdTypes[$thirdType])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '第三方授权登录类型(third_type)错误']);
        }
        //判断userData表第三方账号是否存在
        $where = [
            'third_openid'  => $thirdOpenid,
            'third_type'    => $thirdType,
            'is_del'        => 0,
        ];
        $userDataModel = model('user_data');
        $exist = $userDataModel->where($where)->find();
        $userId = 0;
        $createFlag = FALSE;
        if (!$exist){
            if ($unionid) {
                $info = $userDataModel->where(['unionid' => $unionid, 'is_del' => 0, 'third_type' => ['<>', $thirdType]])->find();
                if ($info) {
                    $userId = isset($info['user_id']) && $info['user_id'] ? intval($info['user_id']) : 0;
                }
            }
        }else{
            $userId = isset($exist['user_id']) && $exist['user_id'] ? intval($exist['user_id']) : 0;
        }
        $userModel = new \app\common\model\User();
        $openid = $userModel->_getUserOpenid();
        if (!$userId){
            $this->postParams['username'] = $openid;
            $userId = $userModel->save($this->postParams);
            if (!$userId) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
            }
        }else{
            // 更新登录信息
            $result = $userModel->save(['last_login_time' => time()], ['user_id' => $userId]);
        }
        if (!$exist) {
            $this->postParams['openid'] = $openid;
            $this->postParams['user_id'] = $userId;
            $udataId = $userDataModel->save($this->postParams);
            if (!$udataId) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => $userDataModel->error]);
            }
        }else{
            $result = $userDataModel->save($this->postParams, ['udata_id' => $exist['udata_id']]);
            $openid = $exist['openid'];
        }
        $profile = $this->getUserProfile($openid);
        $this->_returnMsg(['errCode' => 0, 'profile' => $profile]);
    }
    //短信验证码发送
    protected function sendSms()
    {
        $phone = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        $type = isset($this->postParams['type']) ? trim($this->postParams['type']) : 'register';
        if (!$phone) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '手机号(phone)缺失']);
        }
        if (!$type) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '验证码(type)缺失']);
        }
        //验证手机号格式
        $userService = new \app\common\service\User();
        $result = $userService->_checkFormat(['phone' => $phone]);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userService->error]);
        }
        $types = [
            'register'  => '注册',
            'bind'      => '手机号绑定',
        ];
        if(!isset($types[$type])){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '短信类型(type)错误']);
        }
        $codeModel = db('log_code');
        //判断短信验证码发送时间间隔
        $exist = $codeModel->where(['phone' => $phone])->order('add_time DESC')->find();
        if ($exist && $exist['add_time'] + 60 >= time()) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '验证码发送太频繁，请稍后再试']);
        }
        $smsApi = new \app\common\api\SmsApi();
        $code = $smsApi->getSmsCode();
        $param = [
            'code' => $code,
        ];
        $data = [
            'code'  => $code,
            'phone' => $phone,
            'type'  => $type,
            'add_time' => time(),
            'status' => 0,
        ];
        $smsId = $codeModel->insertGetId($data);
        if ($smsId === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '验证码发送异常']);
        }
        $result = $smsApi->send($phone, 'send_code', $param);
        $data = [
            'result' => $result ? json_encode($result) : '',
        ];
        if ($result && isset($result['Code']) && $result['Code'] == 'OK' && $result['BizId']) {
            $data['status'] = 1;
            $codeModel->where(['sms_id' => $smsId])->update($data);
            $this->_returnMsg(['errCode' => 0, 'msg' => '验证码发送成功,5分钟内有效']);
        }else{
            $codeModel->where(['sms_id' => $smsId])->update($data);
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '验证码发送失败:'.$result['Message']]);
        }
    }
    //短信验证码验证
    protected function checkSmsCode()
    {
        $phone = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        $code = isset($this->postParams['code']) ? trim($this->postParams['code']) : '';
        $type = isset($this->postParams['type']) ? trim($this->postParams['type']) : 'register';
        if (!$phone) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '手机号(phone)缺失']);
        }
        if (!$code) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '验证码(code)缺失']);
        }
        if (strlen($code) != 6) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '验证码(code)格式错误']);
        }
        if (!$type) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '验证码类型(type)缺失']);
        }
        $types = [
            'register'  => '注册',
            'bind'      => '手机号绑定',
        ];
        if(!isset($types[$type])){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '短信类型(type)错误']);
        }
        if ($type == 'activity') {
            $winModel = db('win_log');
            //判断手机号是否已抽奖
            $data = [
                'type' => 2,
                'phone' => $phone,
            ];
            $exist = $winModel->where($data)->find();
            if ($exist){
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前手机号码已参与过活动']);
            }
        }
        //判断验证码是否存在
        $codeModel = db('log_code');
        //判断短信验证码是否存在
        $exist = $codeModel->where(['phone' => $phone, 'code' => $code, 'type' => $type])->order('add_time DESC')->find();
        if (!$exist) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '验证码错误']);
        }
        $codeModel->where(['phone' => $phone, 'type' => $type])->delete();
        if ($exist['add_time'] + 5*60 < time()) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '验证码已失效']);
        }
        //删除当前手机号已失效的验证码
        $codeModel->where(['phone' => $phone, 'add_time' => ['<', time()-5*60]])->delete();
        $this->_returnMsg(['errCode' => 0, 'msg' => '验证成功']);
    }
    //手机号绑定
    protected function bindPhone()
    {
        $user = $this->_checkOpenid();
        $openid = $user['openid'];
        $phone = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        $fromid = isset($this->postParams['fromid']) ? trim($this->postParams['fromid']) : '';
        if (!$phone) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '手机号(phone)缺失']);
        }
        if ($user['third_type'] == 'wechat_applet' && !$fromid) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '小程序表单提交标志(fromid)缺失']);
        }
        if ($user['phone']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前账户已绑定手机号,不能重复绑定']);
        }
        //判断手机号是否已经绑定其它账号
        $exist = db('user')->where(['phone' => $phone, 'is_del' => 0])->find();
        if ($exist) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '手机号已绑定其他账号，不能再绑定啦~']);
        }
        $data = ['phone' => $phone];
        if ($phone && $openid == $user['username']) {
            $data['username'] = $phone;
        }
        $result = db('user')->where(['user_id' => $user['user_id']])->update($data);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '手机号定失败，请稍后重试']);
        }else{
            #TODO 手机号绑定后续
            $this->_returnMsg(['errCode' => 0, 'msg' => '手机号绑定成功']);
        }
    }
    //更新个人信息
    protected function updateUserProfile()
    {
        $user = $this->_checkOpenid();
        $realname = isset($this->postParams['realname']) ? trim($this->postParams['realname']) : '';
        if (!$realname) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户真实姓名(realname)缺失']);
        }
        $age = isset($this->postParams['age']) ? trim($this->postParams['age']) : '';
        $email = isset($this->postParams['email']) ? trim($this->postParams['email']) : '';
        $userModel= new \app\common\model\User();
        $result = $userModel->save($this->postParams, ['user_id' => $user['user_id']]);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }
        $this->_returnMsg(['errCode' => 0, 'msg' => '个人信息更新成功']);
    }
    //用户个人信息
    protected function getUserProfile($openid = '')
    {
        $user = $this->_checkOpenid($openid, 'openid, U.nickname, U.avatar, U.gender, U.realname, phone, balance');
        $this->_returnMsg(['profile' => $user]);
    }
    //获取区域列表
    protected function getRegions()
    {
        $parentId = isset($this->postParams['parent_id']) && $this->postParams['parent_id'] ? intval($this->postParams['parent_id']) : 0;
        if ($parentId) {
            $where['parent_id'] = $parentId;
        }else{
            $where['parent_id'] = 2;
        }
        $regions = db('region')->where($where)->select();
        $this->_returnMsg(['list' => $regions]);
    }
    //获取用户收货地址列表
    protected function getUserAddressList()
    {
        $user = $this->_checkOpenid();
        $list = db('UserAddress')->field('address_id, name, phone, region_name, address, isdefault, status')->where(['user_id' => $user['user_id'], 'is_del' => 0])->select();
        $this->_returnMsg(['list' => $list]);
    }
    //获取收货地址详情
    protected function getUserAddressDetail()
    {
        $user = $this->_checkOpenid();
        $addressId = isset($this->postParams['address_id']) ? intval($this->postParams['address_id']) : 0;
        if ($addressId <= 0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '收货地址ID(address_id)缺失']);
        }
        $address = $this->_checkAddress($user['user_id'], $addressId, '');
        $this->_returnMsg(['detail' => $address]);
    }
    //更新用户收货地址(新增/编辑)
    protected function updateUserAddress()
    {
        $user = $this->_checkOpenid();
        $addressId = isset($this->postParams['address_id']) ? intval($this->postParams['address_id']) : 0;
        if ($addressId) {
            $address = $this->_checkAddress($user['user_id'], $addressId);
        }
        $name = isset($this->postParams['name']) ? trim($this->postParams['name']) : '';
        $phone = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        $regionId = isset($this->postParams['region_id']) ? intval($this->postParams['region_id']) : '';
        $regionName = isset($this->postParams['region_name']) ? $this->postParams['region_name'] : '';
        $addressDetail = isset($this->postParams['address']) ? trim($this->postParams['address']) : '';
        $isdefault = isset($this->postParams['isdefault']) ? intval($this->postParams['isdefault']) : 0;
        $status = isset($this->postParams['status']) ? intval($this->postParams['status']) : 1;
        
        if (!$name){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '收货人姓名(name)缺失']);
        }
        if (!$phone){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '收货人电话(phone)缺失']);
        }
        if (!$regionId){
            if($regionName){
                $regionMod = db("Region");
                if (is_string($regionName)) {
                    $result = $regionMod->where(['region_name' => $regionName])->find();
                    if ($result) {
                        $regionId = $result['region_id'];
                    }else{
                        $this->_returnMsg(['errCode' => 1, 'errMsg' => '收货人地址ID(region_id)缺失']);
                    }
                }elseif (is_array($regionName)){
                    $length = count($regionName);
                    if ($length != 3) {
                        $this->_returnMsg(['errCode' => 1, 'errMsg' => '收货人地址(region_name)格式错误']);
                    }
                    $list = $regionMod->where(['region_name' => $regionName[$length-1]])->select();
                    if ($list) {
                        foreach ($list as $key => $value) {
                            $parent = $regionMod->where(['region_name' => $regionName[$length-2], 'region_id' => $value['parent_id']])->find();
                            if (!$parent) {
                                unset($list[$key]);
                            }else{
                                $first = $regionMod->where(['region_name' => $regionName[$length-3], 'region_id' => $parent['parent_id']])->find();
                                if (!$first) {
                                    unset($list[$key]);
                                }
                            }
                        }
                    }
                    if (!$list) {
                        $this->_returnMsg(['errCode' => 1, 'errMsg' => '收货人地址(region_name)不存在']);
                    }else{
                        //取条件匹配的第一个数据
                        $last = reset($list);
                        $regionId = $last['region_id'];
                    }
                }
            }else{
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '收货人地址ID(region_id)缺失']);
            }
        }
        if (!$addressDetail){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '收货人详细地址(address)缺失']);
        }
        //根据region_id获取region_name
        $rname = $this->_getParentName($regionId);
        $rname = $rname ? $rname : $regionName;
        $addressModel = db('UserAddress');
        $data = [
            'name'      => $name,
            'phone'     => $phone,
            'region_id' => $regionId,
            'address'   => $addressDetail,
            'isdefault' => $isdefault,
            'status'    => $status,
            'region_name' => trim($rname),
            'update_time' => time(),
        ];
        //验证收货地址是否重复
        if(!$addressId && $addressDetail){
            $where = ['user_id' => $user['user_id'], 'is_del' => 0, 'name' => $name, 'phone' => $phone,'address' => $addressDetail];
            $result = $addressModel->where($where)->find();
            if($result){
                $addressId = $result['address_id'];
            }
        }
        if ($addressId) {
            $msg = '编辑';
            $result = $addressModel->where(['address_id' => $addressId])->update($data);
        }else{
            $msg = '新增';
            $maxNum = 10;
            //限制用户最多添加地址数量
            $count = $addressModel->where(['user_id' => $user['user_id'], 'is_del' => 0])->count();
            if ($count >= $maxNum) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户最大收货地址数量不能超过'.$maxNum.'个']);
            }
            if ($count == 0) {
                //第一个添加的地址为默认地址
                $data['isdefault'] = 1;
            }
            $data['add_time'] = time();
            $data['user_id'] = $user['user_id'];
            $result = $addressId = $addressModel->insertGetId($data);
        }
        if ($result === false) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '收货地址'.$msg.'失败']);
        }
        $data['address_id'] = $addressId;
        if ($isdefault) {
            $addressModel->where(['user_id' => $user['user_id'], 'is_del' => 0, 'address_id' => ['<>', $addressId], 'isdefault' => ['<>', 0]])->update(['isdefault' => 0, 'update_time' => time()]);
        }
        $this->_returnMsg(['msg' => '收货地址'.$msg.'成功', 'address' => $data]);
    }
    //删除用户收货地址
    protected function delUserAddress()
    {
        $user = $this->_checkOpenid();
        $address = $this->_checkAddress($user['user_id']);
        $result = db('UserAddress')->where(['address_id' => $address['address_id']])->update(['update_time' => time(), 'is_del' => 1]);
        if ($result === false) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '收货地址删除失败']);
        }
        $this->_returnMsg(['msg' => '收货地址删除成功']);
    }
    //用户申请售后服务
    protected function applayService()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        #TODO
//         if ($user['installer']) {
//             $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后工程师不允许申请售后服务']);
//         }
        $orderType  = isset($this->postParams['order_type']) ? intval($this->postParams['order_type']): 1;//默认为安装工单
        $regionId   = isset($this->postParams['region_id']) ? intval($this->postParams['region_id']) : 0;
        $regionName = isset($this->postParams['region_name']) ? trim($this->postParams['region_name']) : '';
        $userName   = isset($this->postParams['user_name']) ? trim($this->postParams['user_name']) : '';
        $phone      = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        $address    = isset($this->postParams['address']) ? trim($this->postParams['address']) : '';
        if (!$orderType || !in_array($orderType, [1, 2])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后工单类型(order_type)错误']);
        }
        if (!$userName) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '客户姓名(user_name)缺失']);
        }
        if (!$phone) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '客户电话(phone)缺失']);
        }
        if (!$regionId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务区域(region_id)缺失']);
        }
        if (!$regionName) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务区域(region_name)缺失']);
        }
        if (!$address) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '客户地址(address)缺失']);
        }
        $params = $this->postParams;
        $params['user_id'] = $user['user_id'];
        $workOrderModel = model('work_order');
        #TODO 报修上传故障图片
        $params['images'] = '';//图片
        $params['images'] = $orderType;
        $params['fault_desc'] = isset($this->postParams['fault_desc']) ? trim($this->postParams['fault_desc']) : '';
        $params['order_type'] = $orderType;
        $result = $workOrderModel->save($params);
        if ($result) {
            $this->_returnMsg(['msg' => '申请成功']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '系统错误']);
        }
    }
    
    //申请成为售后工程师
    protected function applyBeInstaller()
    {
        $user = $this->_checkOpenid();
        $store = $this->_checkStore();
        if ($store['store_type'] != STORE_SERVICE){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务商不存在']);
        }
        $realname = isset($this->postParams['realname']) ? trim($this->postParams['realname']) : '';
        $phone = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        $regionId   = isset($this->postParams['region_id']) ? intval($this->postParams['region_id']) : 0;
        $regionName = isset($this->postParams['region_name']) ? trim($this->postParams['region_name']) : '';
        $workTime = isset($this->postParams['work_time']) ? trim($this->postParams['work_time']) : '';
        
        if (!$realname){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后工程师真实姓名(realname)缺失']);
        }
        if (!$phone){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后工程师手机号码(phone)缺失']);
        }
        if (!$regionId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务区域(region_id)缺失']);
        }
        if (!$regionName) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务区域(region_name)缺失']);
        }
        if (!$workTime) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '从业时间(work_time)缺失']);
        }
        #TODO其它信息验证
        
        $installerModel = db('user_installer');
        //判断当前用户是否为售后工程师
        $exist = $installerModel->where(['store_id' => $store['store_id'], 'is_del' => 0, 'user_id'   => $user['user_id']])->find();
        if ($exist){
            //0禁用 1正常 -1厂商审核中 -2厂商拒绝 -3服务商审核中 -4服务商拒绝
            $msg = $exist['status'] <= 0 ? get_installer_status($exist['status']): '已经是售后工程师';
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $msg]);
        }else{
            $status = 1;//默认不需要审核直接通过
            //获取厂商/服务商配置(售后工程师申请是否需要审核)
            $storeConfig = $store['config_json'] ? json_decode($store['config_json'], 1) : [];
            if (isset($storeConfig['installer_check']) && $storeConfig['installer_check']) {
                $status = -1;
            }else{
                //判断是否需要厂商审核
                $factory = db('store')->where(['store_id' => $store['factory_id'], 'is_del' => 0, 'store_type' => STORE_FACTORY])->find();
                if (!$factory) {
                    $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务商对应厂商不存在或已删除']);
                }
                $factoryConfig = $factory['config_json'] ? json_decode($factory['config_json'], 1) : [];
                if (isset($factoryConfig['installer_check']) && $factoryConfig['installer_check']) {
                    $status = -2;
                }
            }
            $data = [
                'factory_id'=> $store['factory_id'],
                'store_id'  => $store['store_id'],
                'user_id'   => $user['user_id'],
                'realname'  => $realname,
                'phone'     => $phone,
                'status'    => $status,
                'add_time'  => time(),
                'update_time'=> time(),
            ];
            $result = $installerModel->insertGetId($data);
            if ($result) {
                $this->_returnMsg(['msg' => '售后工程师申请成功']);
            }else{
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '申请失败']);
            }
        }
    }
    //售后工程师售后工单列表
    protected function workOrderList()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = $user['installer'];
        if (!$installer) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前用户不是售后工程师']);
        }
        $orderType = isset($this->postParams['order_type']) ? intval($this->postParams['order_type']): 1;
        $status = isset($this->postParams['status']) ? intval($this->postParams['status']): 0;
        if (!get_worder_status($status)) {
            $status = 0;
        }
        if (!$orderType || !in_array($orderType, [1, 2])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后工单类型(order_type)错误']);
        }
        $where = [
            'installer_id' => $installer['installer_id'], 
            'is_del' => 0,
        ];
        if ($orderType) {
            $where['order_type'] = $orderType;
        }
        if (isset($this->postParams['status'])) {
            $where['status'] = $status;
        }
        $field = 'worder_id, order_type, user_name, phone, region_name, address, appointment, images, fault_desc, status, add_time, receive_time, finish_time';
        $order = 'add_time ASC';
        $list = $this->_getModelList(db('work_order'), $where, $field, $order);
        if ($list) {
            foreach ($list as $key => $value) {
                $list[$key]['status_txt'] = get_worder_status($value['status']);
                $list[$key]['images'] = $value['images'] ? json_decode($value['images'], 1) : [];
            }
        }
        $this->_returnMsg(['list' => $list]);
    }
    //售后工单详情
    protected function getWorkOrderDetail($return = FALSE)
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = $user['installer'];
        if (!$installer) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前用户不是售后工程师']);
        }
        $worderId = isset($this->postParams['worder_id']) ? intval($this->postParams['worder_id']) : 0;
        if (!$worderId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单ID(worder_id)缺失']);
        }
        $field = 'worder_id, order_type, user_name, phone, region_name, address, appointment, images, fault_desc, status, add_time, receive_time, finish_time';
        $info = db('work_order')->field($field)->where(['worder_id' => $worderId, 'installer_id' => $installer['installer_id'], 'is_del' => 0])->find();
        if (!$info) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单不存在或已删除']);
        }
        if ($return) {
            return $info;
        }
        $this->_returnMsg(['detail' => $info]);
    }
    //售后工程师接单
    protected function receiveWorkOrder()
    {
        $detail = $this->getWorkOrderDetail(TRUE);
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($detail['status']) {
            case -1:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单已取消']);
            break;
            case 0:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单未分派']);
            break;
            case 2:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单已接收']);
            break;
            case 3:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单服务中']);
            break;
            case 4:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务已完成']);
            break;
            default:
                ;
            break;
        }
        $result = db('work_order')->where(['worder_id' => $detail['worder_id']])->update(['update_time' => time(), 'status' => 2, 'receive_time' => time()]);
        if ($result) {
            $this->_returnMsg(['msg' => '接单成功,请联系客户上门服务']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '操作失败']);
        }
    }
    //售后工程师现场签到
    protected function signWorkOrder()
    {
        $detail = $this->getWorkOrderDetail(TRUE);
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($detail['status']) {
            case -1:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单已取消']);
                break;
            case 0:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单未分派']);
                break;
            case 1:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单待接收']);
                break;
            case 3:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单服务中']);
                break;
            case 4:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务已完成']);
                break;
            default:
                ;
                break;
        }
        $result = db('work_order')->where(['worder_id' => $detail['worder_id']])->update(['update_time' => time(), 'status' => 3, 'receive_time' => time()]);
        if ($result) {
            $this->_returnMsg(['msg' => '签到成功,服务开始']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '操作失败']);
        }
    }
    //取消工单
    protected function cacelWorkOrder()
    {
        $detail = $this->getWorkOrderDetail(TRUE);
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($detail['status']) {
            case -1:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单已取消,不能重复取消']);
                break;
            case 4:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务已完成,不能取消工单']);
                break;
            default:
                ;
                break;
        }
        $result = db('work_order')->where(['worder_id' => $detail['worder_id']])->update(['update_time' => time(), 'status' => -1, 'cancel_time' => time()]);
        if ($result) {
            $this->_returnMsg(['msg' => '工单已取消']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '操作失败']);
        }
    }
    //工单完成
    protected function finishWorkOrder()
    {
        $detail = $this->getWorkOrderDetail(TRUE);
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($detail['status']) {
            case -1:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单已取消']);
                break;
            case 0:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单未分派']);
                break;
            case 1:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单待接收']);
                break;
            case 2:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '工程师未抵达']);
                break;
            case 4:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务已完成']);
                break;
            default:
                ;
                break;
        }
        $result = db('work_order')->where(['worder_id' => $detail['worder_id']])->update(['update_time' => time(), 'status' => 4, 'finish_time' => time()]);
        if ($result) {
            $this->_returnMsg(['msg' => '工单已完成']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '操作失败']);
        }
    }
    /****************************************************************====================================================================*************************************************************/
    
    private function _checkInstaller($userId = 0)
    {
        $join = [
            ['store S', 'S.store_id = UI.store_id'],
            ['store F', 'F.store_id = UI.factory_id'],
        ];
        $field = 'UI.installer_id, UI.job_no, UI.realname, UI.phone, UI.status, S.name as store_name, F.name as factory_name';
        $exist = db('user_installer')->alias('UI')->join($join)->field($field)->where(['UI.user_id' => $userId, 'UI.is_del' => 0])->find();
        if ($exist) {
            $exist['status_txt'] = get_installer_status($exist['status']);
        }
        return $exist;
    }
    /**
     * 验证商户信息
     * @param number $storeId
     * @return array
     */
    private function _checkStore($storeId = 0)
    {
        $storeId = $storeId ? $storeId : (isset($this->postParams['store_id']) ? intval($this->postParams['store_id']) : 0);
        if (!$storeId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户ID(store_id)缺失']);
        }
        $store = db('store')->where(['store_id' => $storeId, 'is_del' => 0])->find();
        if (!$store) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户不存在或已删除']);
        }
        if (!$store['status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户已禁用']);
        }
        return $store;
    }
    
    /**
     * 验证openid对应用户信息
     * @return array
     */
    private function _checkOpenid($openid = '', $field = '', $installFlag = FALSE)
    {
        $openid = $openid ? $openid : (isset($this->postParams['openid']) ? trim($this->postParams['openid']) : '');
        if (!$openid) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '登录用户唯一标识(openid)缺失']);
        }
        $field = ($field ? $field : 'UD.*, U.*').', U.status';
        $user = db('user_data')->alias('UD')->join('user U', 'UD.user_id = U.user_id', 'LEFT')->field($field)->where(['openid' => $openid, 'UD.user_id' => ['>', 0]])->find();
        if (!$user) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '登录用户不存在']);
        }
        if (!$user['status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户已禁用不允许登录']);
        }
        if ($installFlag) {
            $installer = $this->_checkInstaller($user['user_id']);
        }
        $user['installer'] = isset($installer) ? $installer : [];
        return $user;
    }
    /**
     * 获取当前区域的区域前缀名称
     * @param int $id
     * @param string $name
     * @return string
     */
    private function _getParentName($id, &$name = '') {
        $region = db('region')->where(['region_id' => $id])->find();
        $name = $name ? $region['region_name'].' '.$name : $region['region_name'];
        if($region && $region['parent_id'] > 0 && $region['parent_id'] > 1) {
            $name = $this->_getParentName($region['parent_id'], $name);
        }
        return $name;
    }
    /**
     * 返回数据列表(可分页)
     * @param object $model
     * @param array $where
     * @param string $field
     * @param string $order
     * @param string $alias
     * @param array $join
     * @param string $group
     * @param string $having
     * @return array
     */
    private function _getModelList($model, $where = [], $field = '*', $order = false, $alias = false, $join = [], $group = false, $having = false)
    {
        if($alias)  $model->alias($alias);
        if($join)   $model->join($join);
        if($where)  $model->where($where);
        if($having) $model->having($having);
        if($order)  $model->order($order);
        if($group)  $model->group($group);
        if ($this->pageSize > 0) {
            $result = $model->field($field)->paginate($this->pageSize, false, ['page' => $this->page]);
            return $result;
        }else{
            return $model->field($field)->select();
        }
    }
    /**
     * 取得用户默认收货地址/或者根据收货地址id取得收货地址
     * @param number $addressId
     */
    private function _getDefaultAddress($user = [],$addressId = 0){
        if (!$user) {
            $user = $this->_checkUser();
        }
        $where = [
            'user_id' => $user['user_id'],
            'is_del' => 0,
        ];
        if($addressId > 0){
            $where['address_id'] = $addressId;
        }else{
            $where['isdefault']  = 1;
        }
        $addressInfo = db('UserAddress')->field('address_id, name, phone, region_name, address, isdefault, status')->where($where)->find();
        return $addressInfo;
    }
    /**
     * 验证收货地址信息
     * @param int $userId
     * @param int $addressId
     * @return array
     */
    private function _checkAddress($userId = 0, $addressId = 0, $field = '*')
    {
        $addressId = $addressId ? $addressId : (isset($this->postParams['address_id']) ? intval($this->postParams['address_id']) : 0);
        if (!$addressId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '收货地址ID(address_id)缺失']);
        }
        $address = db('UserAddress')->field('address_id, name, phone, region_id, region_name, address, isdefault, add_time, update_time')->where(['user_id' => $userId, 'is_del' => 0, 'address_id' => $addressId])->find();
        if (!$address) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '收货地址不存在或已删除']);
        }
        return $address;
    }
    /**
     * 验证用户信息
     * @param int $userId
     * @return array
     */
    private function _checkUser($userId = 0)
    {
        $userId = $userId ? $userId : (isset($this->postParams['user_id']) ? intval($this->postParams['user_id']) : 0);
        if (!$userId) {
            #TODO 20181102user_id改为openid,为兼容H5和线上已发布的小程序使用user_id和openid同时验证的格式，本地版本发布后可批量替换
            return $user = $this->_checkOpenid();
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户ID(user_id)缺失']);
        }
        $user = db('User')->where(['user_id' => $userId, 'is_del' => 0])->find();
        if (!$user) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户不存在或已删除']);
        }
        if (!$user['status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户已禁用']);
        }
        return $user;
    }
    /**
     * 处理接口返回信息
     */
    protected function _returnMsg($data, $echo = TRUE){
        $result = parent::_returnMsg($data);
        $responseTime = $this->_getMillisecond() - $this->visitMicroTime;//响应时间(毫秒)
        $addData = [
            'request_time'  => $this->requestTime,
            'request_source'=> $this->fromSource ? $this->fromSource : '',
            'return_time'   => time(),
            'method'        => $this->method ? $this->method : '',
            'request_params'=> $this->postParams ? json_encode($this->postParams) : '',
            'return_params' => $result,
            'response_time' => $responseTime,
            'error'         => isset($data['errCode']) ? intval($data['errCode']) : 0,
        ];
        $apiLogId = db('apilog_app')->insertGetId($addData);
        exit();
    }
    
    /**
     * 参数签名生成算法
     * @param array $params  key-value形式的参数数组
     * @param string $signkey 参数签名密钥
     * @return string 最终的数据签名
     */
    protected function getSign($params, $signkey)
    {
        //除去待签名参数数组中的空值和签名参数(去掉空值与签名参数后的新签名参数组)
        $para = array();
        while (list ($key, $val) = each ($params)) {
            if($key == 'sign' || $key == 'signkey' || $val === "")continue;
            else	$para [$key] = $params[$key];
        }
        //对待签名参数数组排序
        ksort($para);
        reset($para);
        
        //把数组所有元素，按照“参数=参数值”的模式用“&”字符拼接成字符串
        $prestr  = "";
        while (list ($key, $val) = each ($para)) {
            if (is_array($val)) {
                $prestr.= $key."=".implode(',', $val)."&";
            }else{
                $prestr.= $key."=".$val."&";
            }
        }
        //去掉最后一个&字符
        $prestr = substr($prestr,0,count($prestr)-2);
        
        //字符串末端补充signkey签名密钥
        $prestr = $prestr . $signkey;
        //生成MD5为最终的数据签名
        $mySgin = md5($prestr);
        return $mySgin;
    }
    /**
     * 验证系统级参数
     * @param array $data
     */
    protected function verifySignParam($data = [])
    {
        // 验证必填参数
        if (!$this->postParams) {
            $this->_returnMsg(array('errCode' => 1, 'errMsg' => '请求参数异常'));
        }
        $this->method = isset($this->postParams['method']) ?  trim($this->postParams['method']) : '';
        if (!$this->method) {
            $this->_returnMsg(array('errCode' => 1, 'errMsg' => '接口方法(method)缺失'));
        }
        if (!method_exists($this, $this->method)) {
            $this->_returnMsg(array('errCode' => 1, 'errMsg' => '接口方法(method)错误'));
        }
        /* //验证签名参数
         if($this->postParams['method'] == 'uploadImg') {
         unset($this->postParams['file']);#上传文件接口去掉file字段验证签名
         } */
        $timestamp = isset($this->postParams['timestamp']) ?  trim($this->postParams['timestamp']) : '';
        if(!$timestamp) {
            $this->_returnMsg(array('errCode' => 1,'errMsg' => '请求时间戳(timestamp)参数缺失'));
        }
        $len = strlen($timestamp);
        if($len != 10 && $len != 13) {//时间戳长度格式不对
            $this->_returnMsg(array('errCode' => 1, 'errMsg' => '时间戳格式错误'));
        }
        if (strlen($timestamp) == 13) {
            $this->postParams['timestamp'] = substr($timestamp, 0, 10);
        }
        if($timestamp + 180 < time()) {//时间戳已过期(60秒内过期)
            $this->_returnMsg(array('errCode' => 1, 'errMsg' => '请求已超时'));
        }
        if(!$this->signKey) {
            $this->_returnMsg(array('errCode' => 1,'errMsg' => '签名密钥(signkey)参数缺失'));
        }
        if(!in_array($this->signKey, $this->signKeyList)) {
            $this->_returnMsg(array('errCode' => 1,'errMsg' => '签名密钥错误'));
        }
        if (isset($data['file'])) {
            unset($data['file']);
        }
        $postSign = isset($this->postParams['sign']) ?  trim($this->postParams['sign']) : '';
        if (!$postSign) {
            $this->_returnMsg(array('errCode' => 1,'errMsg' => '签名(sign)参数缺失'));
        }
        $sign = $this->getSign($data, $this->signKey);
        if ($postSign != $sign) {
            $this->_returnMsg(array('errCode' => 1,'errMsg' => '签名错误', 'correct' => $sign));
        }
    }
}    