<?php
namespace app\api\controller;

class Index extends ApiBase
{
    public $method;
    public $reduceStock;
    public $page;
    public $pageSize;
    
    public $signKeyList;
    public $signKey;
    public $mchKey;
    public $fromSource;
    public $factory;
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
        $this->mchKey = isset($this->postParams['mchkey']) && $this->postParams['mchkey'] ? trim($this->postParams['mchkey']) : '';
        //客户端签名密钥get_nonce_str(12)
        $this->signKeyList = [
            'Applets'   => '8c45pve673q1',
            'TEST'      => 'ds7p7auqyjj8',
        ];
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
    protected function authorized()
    {
        $thirdType      = isset($this->postParams['third_type']) ? trim($this->postParams['third_type']) : '';
        $thirdOpenid    = isset($this->postParams['third_openid']) ? trim($this->postParams['third_openid']) : '';
        $nickname       = isset($this->postParams['nickname']) ? trim($this->postParams['nickname']) : '';
        $avatar         = isset($this->postParams['avatar']) ? trim($this->postParams['avatar']) : '';
        $gender         = isset($this->postParams['gender']) ? trim($this->postParams['gender']) : 0;
        $unionid        = isset($this->postParams['unionid']) ? trim($this->postParams['unionid']) : '';
        
        $userModel = new \app\common\model\User();
        $result = $userModel->authorized($this->factory['store_id'], $this->postParams);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }
        $openid = $result['openid'];
        $userId = $result['user_id'];
        if ($userId) {
            //更新登录时间
            $result = $userModel->save(['last_login_time' => time()], ['user_id' => $userId]);
        }
        $profile = $this->_checkOpenid($openid, 'UD.user_id, UD.openid, UD.avatar, UD.nickname, UD.gender, ifnull(U.age, 0) as age', TRUE, FALSE);
        if ($profile['user_id'] <= 0) {
            $profile = [];
        }
        if ($profile && (isset($profile['user_id']) || $profile['user_id'] == null)) {
            unset($profile['user_id']);
        }
        $this->_returnMsg(['openid' => $openid, 'profile' => $profile]);
    }
    //短信验证码发送
    protected function sendSmsCode()
    {
        $phone  = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        $type   = isset($this->postParams['type']) ? trim($this->postParams['type']) : 'bind_phone';
        $codeModel = new \app\common\model\LogCode();
        $result = $codeModel->sendSmsCode($this->factory['store_id'], $phone, $type);
        if ($result === FALSE){
            $this->_returnMsg(['msg' => '验证码发送失败:'.$codeModel->error]);
        }else{
            if ($result['status']) {
                $this->_returnMsg(['msg' => '验证码发送成功,5分钟内有效']);
            }else{
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '验证码发送失败:'.$result['result']]);
            }
        }
    }
    //短信验证码验证
    protected function checkSmsCode()
    {
        $phone  = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        $type   = isset($this->postParams['type']) ? trim($this->postParams['type']) : 'bind_phone';
        $codeModel = new \app\common\model\LogCode();
        $result = $codeModel->verifyCode($this->postParams);
        if ($result === FALSE){
            $this->_returnMsg(['errCode' => 1, 'msg' => $codeModel->error]);
        }else{
            $this->_returnMsg(['msg' => '验证成功']);
        }
    }
    //手机号绑定
    protected function bindPhone()
    {
        $phone = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        $fromid = isset($this->postParams['fromid']) ? trim($this->postParams['fromid']) : '';
        if (!$phone) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '手机号(phone)缺失']);
        }
        
        $user = $this->_checkOpenid(FALSE, FALSE, FALSE, FALSE);
        if ($user['phone']) {
            $this->_returnMsg(['errCode' => 1, 'msg' => '您已经绑定手机号了，如需修改请更换手机号']);
        }
//         if ($user['third_type'] == 'wechat_applet' && !$fromid) {
//             $this->_returnMsg(['errCode' => 1, 'errMsg' => '小程序表单提交标志(fromid)缺失']);
//         }
        $userModel = new \app\common\model\User();
        //验证手机号格式
        $result = $userModel->checkPhone($this->factory['store_id'], $phone);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'msg' => $userModel->error]);
        }
        $result = $userModel->bindPhone($user['openid'], $phone);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'msg' => $userModel->error]);
        }else{
            #TODO 手机号绑定后续
            $this->_returnMsg(['msg' => '手机号绑定成功']);
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
        $userModel= new \app\common\model\User();
        $result = $userModel->save($this->postParams, ['user_id' => $user['user_id']]);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }
        $this->_returnMsg(['msg' => '个人资料更新成功']);
    }
    //用户个人信息
    protected function getUserProfile($openid = '')
    {
        $profile = $user = $this->_checkOpenid($openid, 'UD.openid, U.realname, U.nickname, U.avatar, U.gender, U.age, U.user_id, U.phone', TRUE);
        unset($profile['openid']);
        if ($profile && (isset($profile['user_id']) || $profile['user_id'] == null)) {
            unset($profile['user_id']);
        }
        $this->_returnMsg(['openid' => $user['openid'], 'profile' => $profile]);
    }
    //获取区域列表
    protected function getRegions()
    {
        $parentId = isset($this->postParams['parent_id']) && $this->postParams['parent_id'] ? intval($this->postParams['parent_id']) : 0;
        if ($parentId) {
            $where['parent_id'] = $parentId;
        }else{
            $where['parent_id'] = 1;
        }
        $regions = db('region')->field('region_id, region_name, parent_id')->where($where)->select();
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
        unset($data['add_time'], $data['update_time']);
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
    //客户申请售后服务
    protected function postWorkOrder()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
//         if ($user['installer']) {
//             $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后工程师不允许申请工单']);
//         }
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $userName   = isset($this->postParams['user_name']) ? trim($this->postParams['user_name']) : '';
        $phone      = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        $regionId   = isset($this->postParams['region_id']) ? intval($this->postParams['region_id']) : 0;
        $regionName = isset($this->postParams['region_name']) ? trim($this->postParams['region_name']) : '';
        $address    = isset($this->postParams['address']) ? trim($this->postParams['address']) : '';
        $appointment = isset($this->postParams['appointment']) ? trim($this->postParams['appointment']) : '';
        $faultDesc = isset($this->postParams['fault_desc']) ? trim($this->postParams['fault_desc']) : '';
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
        if (!$appointment) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '预约服务时间(appointment)缺失']);
        }
        $appointment = isset($this->postParams['appointment']) ? trim($this->postParams['appointment']) : '';
        $images = isset($this->postParams['images']) ? trim($this->postParams['images']) : '';
        $faultDesc = isset($this->postParams['fault_desc']) ? trim($this->postParams['fault_desc']) : '';
        if (!$appointment) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '客户预约服务时间(appointment)缺失']);
        }
        if (!$faultDesc) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '故障描述(fault_desc)缺失']);
        }
        $params = $this->postParams;
        $workOrderModel = model('work_order');
        $this->postParams['work_order_type'] = 2;
        $this->postParams['post_user_id'] = $user['user_id'];
        $this->postParams['user_id'] = $user['user_id'];
        #TODO 报修上传故障图片
        $this->postParams['images'] = '';
        pre($this->postParams);
        $result = $workOrderModel->save($this->postParams);
        if ($result) {
            $this->_returnMsg(['msg' => '售后工单申请成功']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '系统错误']);
        }
    }
    //客户提交售后评价
    protected function postWorkOrderReview()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = $user['installer'];
        if ($installer) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工程师不允许提交售后评价']);
        }
        $detail = $this->getWorkOrderDetail(TRUE);
        $worderModel = new \app\common\model\WorkOrder();
        $result = $worderModel->worderAssess($detail, $user);
        if ($result !== FALSE) {
            $this->_returnMsg(['msg' => '接单成功,请联系客户上门服务']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $worderModel->error]);
        }
    }
    protected function getWorkOrderReviewConfig()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = $user['installer'];
        if ($installer) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工程师不允许提交售后评价']);
        }
        $config = db('config')->where(['is_del' => 0, 'status' => 1, 'config_key' => CONFIG_WORKORDER_ASSESS])->select();
    }
    
    //申请成为售后工程师
    protected function applyBeInstaller()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        if (!$user['phone']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '未绑定手机号不能申请']);
        }
        if ($user['installer'] && !in_array($user['installer']['check_status'], [-2, -4])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '不能重复申请']);
        }
        $store = $this->_checkStore();
        if ($store['store_type'] != STORE_SERVICE){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务商不存在']);
        }
        $realname = isset($this->postParams['realname']) ? trim($this->postParams['realname']) : '';
        $securityRecordNum = isset($this->postParams['security_record_num']) ? trim($this->postParams['security_record_num']) : '';
        $idcardFontImg = isset($this->postParams['idcard_font_img']) ? trim($this->postParams['idcard_font_img']) : '';
        $idcardBackImg = isset($this->postParams['idcard_back_img']) ? trim($this->postParams['idcard_back_img']) : '';
        $workTime = isset($this->postParams['work_time']) ? trim($this->postParams['work_time']) : '';
        $remark = isset($this->postParams['remark']) ? trim($this->postParams['remark']) : '';
        if (!$realname){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '真实姓名(realname)缺失']);
        }
        if (!$idcardFontImg){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '身份证正面(idcard_font_img)缺失']);
        }
        if (!$idcardBackImg){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '身份证背面(idcard_back_img)缺失']);
        }
        /* if (!$securityRecordNum) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '公安机关备案号(security_record_num)缺失']);
        }
        if (!$workTime) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '从业时间(work_time)缺失']);
        } */
        $installerModel = new \app\common\model\UserInstaller();
        $phone = $user['phone'];
        $data = [
            'realname'  => $realname,
            'phone'     => $phone,
            'remark'    => $remark,
            'idcard_font_img' => $idcardFontImg,
            'idcard_back_img' => $idcardBackImg,
            'work_time' => $workTime,
        ];
        if ($user['installer']) {
            $data['check_status'] = $checkStatus = $user['installer']['check_status'] == -2 ? -1 : -3;
            $where = ['job_no' => $user['installer']['job_no']];
        }else{
            //0禁用 1正常 -1厂商审核中 -2厂商拒绝 -3服务商审核中 -4服务商拒绝
            $checkStatus = $installerModel->getInstallerStatus($store['store_id'], $this->factory['store_id']);
            $data['factory_id'] = $this->factory['store_id'];
            $data['store_id'] = $store['store_id'];
            $data['user_id'] = $user['user_id'];
            $data['check_status'] = $checkStatus;
        }
        $msg = $checkStatus == 1? '申请成功' : '已提交申请，请耐心等待审核通过';
        $result = $installerModel->save($data, $where);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '申请失败']);
        }else{
            $this->_returnMsg(['msg' => $msg]);
        }
    }
    //获取工程师详情
    protected function getInstallerDetail()
    {
        $user = $this->_checkOpenid();
        $field = 'UI.job_no, UI.realname, UI.phone, UI.idcard_font_img, UI.idcard_back_img, UI.security_record_num, UI.service_count, UI.score, UI.work_time, UI.check_status, UI.remark, UI.admin_remark';
        $installer =  $this->_checkInstaller($user['user_id'], $field);
        if ($installer['check_status'] != -2 && $installer['check_status'] != -4) {
            //0禁用 1正常 -1厂商审核中 -2厂商拒绝 -3服务商审核中 -4服务商拒绝
            $installer['admin_remark'] = '';
        }
        $this->_returnMsg(['detail' => $installer]);
    }
    
    //售后工程师售后工单列表
    protected function getWorkOrderList()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = $user['installer'];
        if (!$installer) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前用户不是售后工程师']);
        }
        $orderType = isset($this->postParams['work_order_type']) ? intval($this->postParams['work_order_type']): 1;
        $status = isset($this->postParams['status']) ? intval($this->postParams['status']): 1;
        if (!get_work_order_status($status)) {
            $status = 1;
        }
        if (!$orderType || !in_array($orderType, [1, 2])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后工单类型(work_order_type)错误']);
        }
        $where = [
            'installer_id' => $installer['installer_id'], 
            'is_del' => 0,
        ];
        if ($orderType) {
            $where['work_order_type'] = $orderType;
        }
        if (isset($this->postParams['status'])) {
            $where['work_order_status'] = $status;
        }
        $field = 'worder_sn, work_order_type, user_name, phone, region_name, address, appointment, work_order_status, add_time, cancel_time, receive_time, sign_time, finish_time';
        $order = 'add_time ASC';
        $list = $this->_getModelList(db('work_order'), $where, $field, $order);
        if ($list) {
            foreach ($list as $key => $value) {
                $list[$key]['status_txt'] = get_work_order_status($value['work_order_status']);
                $list[$key]['appointment'] = $value['appointment'] ? date('Y-m-d H:i', $value['appointment']) : '';
                $list[$key]['work_order_type'] = get_work_order_type($value['work_order_type']);
            }
        }
        $this->_returnMsg(['list' => $list]);
    }
    //售后工单详情
    protected function getWorkOrderDetail($return = FALSE)
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = isset($user['installer']) ? $user['installer'] : [];
        $worderSn = isset($this->postParams['worder_sn']) ? trim($this->postParams['worder_sn']) : 0;
        if (!$worderSn) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后工单编号(worder_sn)缺失']);
        }
        $where = ['worder_sn' => $worderSn, 'is_del' => 0];
        if ($installer) {
            $where['installer_id'] = $installer['installer_id'];
        }else{
            $where['user_id'] = $user['user_id'];
        }
        $field = $return ? 'worder_id, ' : '';
        $field .= ' worder_sn, installer_id, osku_id, work_order_type, order_sn, user_name, phone, region_name, address, appointment, images, fault_desc';
        $field .= ', work_order_status, add_time, dispatch_time, cancel_time, receive_time, sign_time, finish_time';
        $detail = db('work_order')->field($field)->where($where)->find();
        if (!$detail) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后工单不存在或已删除']);
        }
        $detail['images'] = $detail['images']? json_decode($detail['images'], 1) : [];
        $detail['status_txt'] = get_work_order_status($detail['work_order_status']);
        $detail['appointment'] = $detail['appointment'] ? date('Y-m-d H:i', $detail['appointment']) : '';
        $detail['work_order_type'] = get_work_order_type($detail['work_order_type']);
        if ($return) {
            return $detail;
        }
        $installer = db('user_installer')->field('job_no, realname, phone, service_count, score')->where(['installer_id' => $detail['installer_id']])->find();
        $sku = db('order_sku')->field('sku_name, sku_thumb, sku_spec, price')->where(['osku_id' => $detail['osku_id']])->find();
        unset($detail['installer_id'], $detail['osku_id']);
        $this->_returnMsg(['detail' => $detail, 'installer' => $installer, 'sku' => $sku]);
    }
    //售后工程师拒绝接单
    protected function refuseWorkOrder()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = $user['installer'];
        if (!$installer) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前用户不是售后工程师']);
        }
        if (!$installer['status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后工程师已禁用,请联系服务商']);
        }
        $remark = isset($this->postParams['remark']) ? trim($this->postParams['remark']) : '';
        if (!$remark) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '操作备注(remark)不能为空']);
        }
        $detail = $this->getWorkOrderDetail(TRUE);
        $worderModel = new \app\common\model\WorkOrder();
        $result = $worderModel->worderRefuse($detail, $user, $installer, $remark);
        if ($result !== FALSE) {
            $this->_returnMsg(['msg' => '已拒绝']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $worderModel->error]);
        }
    }
    protected function getWorderActionReason($type = 'refuse')
    {
        $reasons = [];
        switch ($type) {
            case 'refuse'://拒接接单
                $reasons = ['我没时间', '其他'];
                break;
            case 'cancel'://取消工单
                $reasons = ['不需要服务了', '信息填写错误', '改为其他时间了', '其他'];
                break;
            default:
                ;
                break;
        }
        $this->_returnMsg(['reasons' => $reasons]);
    }
    //售后工程师接单
    protected function receiveWorkOrder()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = $user['installer'];
        if (!$installer) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前用户不是售后工程师']);
        }
        if (!$installer['status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后工程师已禁用,请联系服务商']);
        }
        $detail = $this->getWorkOrderDetail(TRUE);
        $worderModel = new \app\common\model\WorkOrder();
        $result = $worderModel->worderReceive($detail, $user, $installer);
        if ($result !== FALSE) {
            $this->_returnMsg(['msg' => '接单成功,请联系客户上门服务']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $worderModel->error]);
        }
    }
    //售后工程师现场签到
    protected function signWorkOrder()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = $user['installer'];
        if (!$installer) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前用户不是售后工程师']);
        }
        if (!$installer['status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后工程师已禁用,请联系服务商']);
        }
        $detail = $this->getWorkOrderDetail(TRUE);
        $worderModel = new \app\common\model\WorkOrder();
        $result = $worderModel->worderSign($detail, $user, $installer);
        if ($result !== FALSE) {
            $this->_returnMsg(['msg' => '签到成功,服务开始']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $worderModel->error]);
        }
    }
    //工程师取消工单
    protected function cancelWorkOrder()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = $user['installer'];
        if (!$installer) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前用户不是售后工程师']);
        }
        if ($installer && !$installer['status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后工程师已禁用,请联系服务商']);
        }
        $remark = isset($this->postParams['remark']) ? trim($this->postParams['remark']) : '';
        if (!$remark) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '操作备注(remark)不能为空']);
        }
        $detail = $this->getWorkOrderDetail(TRUE);
        $worderModel = new \app\common\model\WorkOrder();
        $result = $worderModel->worderCancel($detail, $user, $remark);
        if ($result !== FALSE) {
            $this->_returnMsg(['msg' => '工单取消成功']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $worderModel->error]);
        }
    }
    //工程师完成工单
    protected function finishWorkOrder()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = $user['installer'];
        if (!$installer) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前用户不是售后工程师']);
        }
        if ($installer && !$installer['status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后工程师已禁用,请联系服务商']);
        }
        $detail = $this->getWorkOrderDetail(TRUE);
        $worderModel = new \app\common\model\WorkOrder();
        $result = $worderModel->worderFinish($detail, $user);
        if ($result !== FALSE) {
            $this->_returnMsg(['msg' => '服务完成,等待评价']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $worderModel->error]);
        }
    }
    //TODO用户绑定到工单
    //工单完成后客户评价
    protected function assessWorkOrder()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $detail = $this->getWorkOrderDetail(TRUE);
        #TODO 验证用户是否已绑定工单
        
    }
    //上传图片接口
    protected function uploadImage()
    {
        $user = $this->_checkOpenid();
        $file = $this->request->file('file');
        if (!$file) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请选择上传图片']);
        }
        //图片上传到七牛
        $upload = new \app\common\controller\UploadBase();
        $result = $upload->upload(TRUE, 'file', 'api_');
        if (!$result || !$result['status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $result['info']]);
        }
        unset($result['status']);
        $this->_returnMsg(['msg' => '图片上传成功', 'file' => $result]);
    }
    /****************************************************************====================================================================*************************************************************/
    private function _checkInstaller($userId = 0, $field = FALSE)
    {
        $join = [
            ['store S', 'S.store_id = UI.store_id'],
            ['store F', 'F.store_id = UI.factory_id'],
        ];
        $field = $field ? $field: 'UI.installer_id, UI.job_no, UI.realname, UI.phone, S.name as store_name, F.name as factory_name, UI.check_status, UI.status';
        $where = [
            'UI.user_id' => $userId, 
            'UI.is_del' => 0,
            'UI.factory_id' => $this->factory['store_id'],
        ];
        $exist = db('user_installer')->alias('UI')->join($join)->field($field)->where($where)->find();
        if ($exist) {
            $exist['status_txt'] = get_installer_status($exist['check_status']);
        }
        return $exist;
    }
    /**
     * 验证商户信息
     * @param number $storeId
     * @return array
     */
    private function _checkStore($storeNo = FALSE)
    {
        $storeNo = $storeNo ? $storeNo : (isset($this->postParams['store_no']) ? intval($this->postParams['store_no']) : 0);
        if (!$storeNo) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户号(store_no)缺失']);
        }
        $store = db('store')->where(['store_no' => $storeNo, 'is_del' => 0])->find();
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
    private function _checkOpenid($openid = '', $field = '', $installFlag = FALSE, $verify = TRUE)
    {
        $openid = $openid ? $openid : (isset($this->postParams['openid']) ? trim($this->postParams['openid']) : '');
        if (!$openid) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '登录用户唯一标识(openid)缺失']);
        }
        $field = $field ? $field : 'UD.*, U.user_id, U.phone, U.status';
        $where = [
            'openid' => $openid, 
            'UD.factory_id' => $this->factory['store_id'],
        ];
        $user = db('user_data')->alias('UD')->join('user U', 'UD.user_id = U.user_id AND U.is_del = 0', 'LEFT')->field($field)->where($where)->find();
        if (!$user['user_id']) {
            if ($verify) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '未绑定手机号']);
            }
        }else{
            $installer = [];
            if (isset($user['status']) && !$user['status']) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户已禁用不允许登录']);
            }
            if (isset($user['user_id']) && $installFlag) {
                $installer = $this->_checkInstaller($user['user_id']);
            }
            $user['installer'] = $installer;
        }
        return $user ? $user : [];
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
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '地址ID(address_id)缺失']);
        }
        $address = db('UserAddress')->field('address_id, name, phone, region_id, region_name, address, isdefault')->where(['user_id' => $userId, 'is_del' => 0, 'address_id' => $addressId])->find();
        if (!$address) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '地址不存在或已删除']);
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
        if(!$this->mchKey) {
            $this->_returnMsg(array('errCode' => 1,'errMsg' => '商户密钥(mchkey)参数缺失'));
        }
        //根据商户密钥获取商户信息
        $this->factory = db('store_factory')->alias('SF')->join('store S', 'S.store_id = SF.store_id', 'INNER')->where(['store_no' => trim($this->mchKey), 'store_type' => STORE_FACTORY, 'S.is_del' => 0])->find();
        if(!$this->factory) {
            $this->_returnMsg(array('errCode' => 1,'errMsg' => '商户密钥(mchkey)对应商户不存在或已删除'));
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