<?php
namespace app\api\controller;

use app\common\model\ConfigForm;

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
    public $userTypes;
    
    public $signData = [];
    public function __construct(){
        parent::__construct();
        if ($this->request->param('test')) {
        }
        $this->_checkPostParams();
        $this->method = trim($this->postParams['method']);
        $this->page = isset($this->postParams['page']) && $this->postParams['page'] ? intval($this->postParams['page']) : 0;
        $this->pageSize = isset($this->postParams['page_size']) && $this->postParams['page_size'] ? intval($this->postParams['page_size']) : 0;
        $this->page = isset($this->postParams['page']) && $this->postParams['page'] ? intval($this->postParams['page']) : 1;
        $this->pageSize = isset($this->postParams['page_size']) && $this->postParams['page_size'] ? intval($this->postParams['page_size']) : 10;
        if ($this->pageSize > 50) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '单页显示数量(page_size)不能大于50']);
        }
        $this->signKey = isset($this->postParams['signkey']) && $this->postParams['signkey'] ? trim($this->postParams['signkey']) : '';
        if (!$this->mchKey) {
            $this->mchKey = isset($this->postParams['mchkey']) && $this->postParams['mchkey'] ? trim($this->postParams['mchkey']) : '';
        }
        //客户端签名密钥
        $this->signKeyList = [
            'H5_FENXIAO'        => '0X65M8ixVmwq',
            'H5_MANAGER'        => 'VO17NvGtExcc',
            'APPLETS_INTALLER'  => 'SjeGczso8Ya2',
            'APPLETS_USER'      => 'fYb180XXDddf',
            'APPLETS_USER1'     => 'SjeGczso8Ya3',
            'TEST'              => 'ds7p7auqyjj8',
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
        $this->userTypes = [
            'manager'   => '管理员客户端',
            'installer' => '师傅端',
            'user'      => '用户端',
        ];
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
    protected function getWebDetail()
    {
        $webConfig = new \app\common\model\WebConfig();
        $detail = $webConfig->where(['key' => 'setting', 'store_id' => $this->factory['store_id']])->value('value');
        if ($detail) {
            $detail = json_decode($detail, 1);
            if (isset($detail['login_bg'])) {
                unset($detail['login_bg']);
            }
            $detail['content'] = '万佳安物联科技源于1998年，是中国最早专业从事视频安防技术的国家级高新技术企业， 依托于自主研发的领先视频技术、云端技术、人脸识别AI技术、物联网技术，为行业安防、系统集成、智慧城市提供一站式的智能化解决方案及产品。利用实时视频连接技术、云端技术、AI技术，打造全球领先的全连接物联视频云服务平台，为千家万户及各行业实现安全、智能、便捷的优质产品和服务。 公司目前员工620人，其中来自腾讯、华为、中兴等知名企业核心技术精英百余名。公司拥有300多项荣誉证书，及500多项自主知识产权（含发明专利），拥有视频技术专家、AI技术专家在内400多人的研发团队。连续十年荣获中国十大民族品牌，位列全球安防前50强。公司致力于打造全新的物联技术及物联智能生活服务平台领军企业。 ';
        }else{
            $detail = [];
        }
        $this->_returnMsg(['detail' => $detail]);
    }
    
    protected function getStoreDetail()
    {
        $storeNo = isset($this->postParams['store_no']) ? trim($this->postParams['store_no']) : '';
        if (!$storeNo) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户编号不能为空']);
        }
        $store = db('store')->where(['store_no' => $storeNo, 'is_del' => 0])->field('store_no, name')->find();
        $this->_returnMsg(['detail' => $store]);
    }
    //获取第三方openid
    protected function getThirdOpenid(){
        $type = isset($this->postParams['type']) ? intval($this->postParams['type']) : 0;
        $config = get_store_config($this->factory['store_id']);
        $wechatConfig = $config && isset($config['wechat_applet']) ? $config['wechat_applet'] : [];
        if (!$wechatConfig) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '厂商未配置小程序信息']);
        }
        switch ($type) {
            case 1://智享家师傅端
                $type = 'installer';
                $name = '智享家师傅端';
//                 $wxproAppId       = 'wx06b088dbc933d613';
//                 $wxproAppSecret   = 'f295d42b655e1217c4bc34e9f6ada817';
            break;
            case 2://用户端
                $type = 'user';
                $name = '智享家用户端';
//                 $wxproAppId       = 'wxf0b833c0aa297da9';
//                 $wxproAppSecret   = '93785b74f09b91c592bc09553ccb6e98';
            break;
            default:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '客户端类型错误']);
            break;
        }
        $wxproAppId       = isset($wechatConfig[$type.'_appid']) ? trim($wechatConfig[$type.'_appid']) : '';
        $wxproAppSecret   = isset($wechatConfig[$type.'_appsecret']) ? trim($wechatConfig[$type.'_appsecret']) : '';
        if (!$wxproAppId || !$wxproAppSecret) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '厂商未配置'.$name.'小程序信息']);
        }
        $code = isset($this->postParams['code']) ? trim($this->postParams['code']) : '';
        if (!$code) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'code不能为空']);
        }
        //////////////////////////////测试//////////////////////////////////////////////////////////////////////////////
        //$userService = new \app\common\model\User();
        //$openid = $userService->getUserOpenid();
        //$this->_returnMsg(['openid' =>$openid , 'appid' => 'wxf0b833c0aa297da9']);
        //return true;
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        $url = 'https://api.weixin.qq.com/sns/jscode2session?appid='.trim($wxproAppId).'&secret='.trim($wxproAppSecret).'&js_code='.$code.'&grant_type=authorization_code';
        $result = curl_post_https($url, []);
        if (isset($result['errcode']) && $result['errcode']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $result['errcode'].':'.$result['errmsg']]);
        }else{
            $openid = $result && isset($result['openid']) ? trim($result['openid']) : '';
            $this->_returnMsg(['third_openid' => $openid, 'appid' => $wxproAppId]);
        }
    }
    //授权登录
    protected function authorized()
    {
        $userType   = isset($this->postParams['user_type']) ? trim($this->postParams['user_type']) : '';
        $appid      = isset($this->postParams['appid']) ? trim($this->postParams['appid']) : '';
        $thirdType  = isset($this->postParams['third_type']) ? trim($this->postParams['third_type']) : '';
        $thirdOpenid= isset($this->postParams['third_openid']) ? trim($this->postParams['third_openid']) : '';
        $nickname   = isset($this->postParams['nickname']) ? trim($this->postParams['nickname']) : '';
        $avatar     = isset($this->postParams['avatar']) ? trim($this->postParams['avatar']) : '';
        $gender     = isset($this->postParams['gender']) ? trim($this->postParams['gender']) : 0;
        $unionid    = isset($this->postParams['unionid']) ? trim($this->postParams['unionid']) : '';
        
        if (!$userType) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户类型不能为空']);
        }
        if (!isset($this->userTypes[$userType])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户类型错误']);
        }
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
        $result = $codeModel->sendSmsCode($this->factory['store_id'], $phone, $type, $this->fromSource);
        if ($result === FALSE){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $codeModel->error]);
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
        $codeModel = new \app\common\model\LogCode();
        $result = $codeModel->verifyCode($this->postParams);
        if ($result === FALSE){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $codeModel->error]);
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
        if (isset($user['phone']) && $user['phone']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '您已经绑定手机号了，如需修改请更换手机号']);
        }
//         if ($user['third_type'] == 'wechat_applet' && !$fromid) {
//             $this->_returnMsg(['errCode' => 1, 'errMsg' => '小程序表单提交标志(fromid)缺失']);
//         }
        $userModel = new \app\common\model\User();
        //仅验证手机号格式
        $result = $userModel->checkPhone($this->factory['store_id'], $phone, FALSE);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }
        //判断手机号对应用户是否存在
        $where = ['U.phone' => $phone, 'U.is_del' => 0, 'UD.user_type' => $user['user_type']];
        $exist = $userModel->alias('U')->join('user_data UD', 'U.user_id = UD.user_id', 'INNER')->where($where)->find();
        if ($exist) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '手机号已注册,请使用其它号码']);
        }
        $result = $userModel->bindPhone($user['openid'], $phone);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }else{
            $this->_returnMsg(['msg' => '手机号绑定成功']);
        }
    }
    //更换手机号
    protected function changePhone()
    {
        $user = $this->_checkOpenid(FALSE, 'U.user_id, U.factory_id, U.phone, U.username', FALSE);
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
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }else{
            $this->_returnMsg(['msg' => '手机号更换成功']);
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
    protected function getRegions($field = 'region_id, region_name, parent_id')
    {
        $parentId = isset($this->postParams['parent_id']) && $this->postParams['parent_id'] ? intval($this->postParams['parent_id']) : 0;
        if ($parentId) {
            $where['parent_id'] = $parentId;
        }else{
            $where['parent_id'] = 1;
        }
        $regions = db('region')->field($field)->where($where)->select();
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
        $regionName = isset($this->postParams['region_name']) ? trim($this->postParams['region_name']) : '';
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
//         $name = '哦哦哦';
//         $addressDetail = '去去去去去去';
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
            $where = [
                'user_id'   => $user['user_id'],
                'is_del'    => 0,
                'address_id'=> ['<>', $addressId],
                'isdefault' => 1,
            ];
            db('UserAddress')->where($where)->update(['isdefault' => 0, 'update_time' => time()]);
        }
        unset($data['add_time'], $data['update_time']);
        $this->_returnMsg(['msg' => '收货地址'.$msg.'成功', 'address' => $data]);
    }
   
    //设置默认收货地址
    protected function setDefaultAddress()
    {
        $user = $this->_checkOpenid();
        $address = $this->_checkAddress($user['user_id']);
        $result = db('UserAddress')->where(['user_id' => $user['user_id'], 'is_del'    => 0])->update(['isdefault' => 0, 'update_time' => time()]);
        $result = db('UserAddress')->where(['address_id' => $address['address_id']])->update(['isdefault' => 1, 'update_time' => time()]);
        $this->_returnMsg(['msg' => '设置默认地址成功']);
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
    //获取维修产品列表
    protected function getWorkOrderGoodsList()
    {
        $where = [
            'store_id'  => $this->factory['store_id'],
            'is_del'    => 0,
            'goods_type'=> 1,
            'status'    => 1,
        ];
        $field = 'goods_id, name, cate_thumb, thumb';
        $order = 'sort_order ASC, add_time ASC';
        $list = $this->_getModelList(db('goods'), $where, $field, $order);
        if ($list) {
            foreach ($list as $key => $value) {
                $list[$key]['thumb'] = $value['cate_thumb'] ? $value['cate_thumb'] : $value['thumb'];
                unset($list[$key]['cate_thumb']);
            }
        }
        $this->_returnMsg(['list' => $list]);
    }
    //客户申请售后服务
    protected function postWorkOrder()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
//         if ($user['installer']) {
//             $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务工程师不允许申请工单']);
//         }
        $goods = $this->_checkGoods();
        $userName   = isset($this->postParams['user_name']) ? trim($this->postParams['user_name']) : '';
        $phone      = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        $regionId   = isset($this->postParams['region_id']) ? intval($this->postParams['region_id']) : 0;
        $regionName = isset($this->postParams['region_name']) ? trim($this->postParams['region_name']) : '';
        $address    = isset($this->postParams['address']) ? trim($this->postParams['address']) : '';
        $appointment= isset($this->postParams['appointment']) ? trim($this->postParams['appointment']) : '';
        $faultDesc  = isset($this->postParams['fault_desc']) ? trim($this->postParams['fault_desc']) : '';
        $images     = isset($this->postParams['images']) ? trim($this->postParams['images']) : '';
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
//         if (!$faultDesc) {
//             $this->_returnMsg(['errCode' => 1, 'errMsg' => '故障描述(fault_desc)缺失']);
//         }
        $storeModel = new \app\common\model\Store();
        //根据安装地址分配服务商
        $storeId = $storeModel->getStoreFromRegion($regionId);
        if(!$storeId){
            //获取当前地址的parent_id
            $parentId = db('region')->where(['region_id' => $regionId])->value('parent_id');
            if ($parentId) {
                $storeId = $storeModel->getStoreFromRegion($parentId);
            }
            if(!$storeId){
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '抱歉，您选择的区域暂无服务商']);
            }
        }
        $workOrderModel = model('work_order');
        $this->postParams['install_price'] = $goods['install_price'];
        $this->postParams['work_order_type'] = 2;
        $this->postParams['post_user_id'] = $user['user_id'];
        $this->postParams['user_id'] = $user['user_id'];
        $this->postParams['factory_id'] = $this->factory['store_id'];
        $this->postParams['store_id'] = $storeId;
        $this->postParams['appointment'] = strtotime($appointment);
        //报修上传故障图片(英文分号分隔)
        $images = $this->postParams['images'] ?trim($this->postParams['images']) : '';
        $images = $images ? explode(',', $images) : [];
        $images = $images ? array_unique($images) : [];
        $images = $images ? array_filter($images) : [];
        if (count($images) > 3) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '图片最大数量(3)']);
        }
        $this->postParams['images'] = implode(',', $images);
        $sn = $workOrderModel->save($this->postParams);
        if ($sn) {
            $this->_returnMsg(['msg' => '维修工单提交成功', 'worder_sn' => $sn]);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '系统错误']);
        }
    }
    //申请成为服务工程师
    protected function applyBeInstaller()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        if (isset($user['phone']) && !$user['phone']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '未绑定手机号不能申请']);
        }
        //$exist=db('user_installer')->where(['phone'=>$user['phone'],'is_del'=>0])->find();
        //if (!empty($exist)){
        //    $this->_returnMsg(['errCode' => 1, 'errMsg' => '该号码已经被注册']);
        //}
        if ($user['installer'] && !in_array($user['installer']['check_status'], [-2, -4])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '不能重复申请']);
        }
        $store = $this->_checkStore();
        if (!in_array($store['store_type'],[STORE_SERVICE,STORE_SERVICE_NEW])){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '您选择的商户不是服务商']);
        }
        $realname = isset($this->postParams['realname']) ? trim($this->postParams['realname']) : '';
        $securityRecordNum = isset($this->postParams['security_record_num']) ? trim($this->postParams['security_record_num']) : '';
        $idcardFontImg = isset($this->postParams['idcard_font_img']) ? trim($this->postParams['idcard_font_img']) : '';
        $idcardBackImg = isset($this->postParams['idcard_back_img']) ? trim($this->postParams['idcard_back_img']) : '';
        $workTime = isset($this->postParams['work_time']) ? trim($this->postParams['work_time']) : '';
        if (strtotime($workTime)<=0) {
            //$this->_returnMsg(['errCode' => 1, 'errMsg' => '从业时间格式错误']);
        }
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
        $installerModel = new \app\common\model\UserInstaller();
        $phone = $user['phone'];
        $data = [
            'realname'            => $realname,
            'phone'               => $phone,
            'remark'              => $remark,
            'idcard_font_img'     => $idcardFontImg,
            'idcard_back_img'     => $idcardBackImg,
            'work_time'           => $workTime,
            'security_record_num' => $securityRecordNum,
        ];
        $checkStatus = -3;
        if ($user['installer']) {
            $where = ['job_no' => $user['installer']['job_no']];
        }else{
            $where = [];
            //0禁用 1正常 -1厂商审核中 -2厂商拒绝 -3服务商审核中 -4服务商拒绝
            $data['factory_id'] = $this->factory['store_id'];
            $data['store_id'] = $store['store_id'];
            $data['user_id'] = $user['user_id'];
        }
        $data['check_status'] = $checkStatus;
        $msg = $checkStatus == 1? '申请成功' : '已提交申请，请耐心等待审核通过';
        $result = $installerModel->save($data, $where);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '申请失败']);
        }else{
            //修改用户真实姓名
            db('user')->where(['user_id' => $user['user_id']])->update(['realname' => $realname]);
            $this->_returnMsg(['msg' => $msg]);
        }
    }
    //获取工程师详情
    protected function getInstallerDetail()
    {
        $user = $this->_checkOpenid();
        $field = 'S.store_no, S.name as store_name, UI.job_no, UI.realname, UI.phone, UI.idcard_font_img, UI.idcard_back_img, UI.security_record_num, UI.service_count, UI.score, UI.work_time, UI.check_status, UI.remark, UI.admin_remark';
        $installer =  $this->_checkInstaller($user['user_id'], $field);
        if ($installer['check_status'] != -2 && $installer['check_status'] != -4) {
            //0禁用 1正常 -1厂商审核中 -2厂商拒绝 -3服务商审核中 -4服务商拒绝
            $installer['admin_remark'] = '';
        }
        $this->_returnMsg(['detail' => $installer]);
    }
    //服务工程师售后工单列表
    protected function getWorkOrderList()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = $user['installer'];
        $orderType = isset($this->postParams['type']) ? intval($this->postParams['type']): '';
        $status = isset($this->postParams['status']) ? intval($this->postParams['status']): FALSE;
        $where = ['WO.is_del' => 0];
        if (!$installer) {
            if (isset($this->postParams['status']) && trim($this->postParams['status']) != "") {
                $where['work_order_status'] = $status;
            }
        }else{
            if (!get_work_order_installer_status($status)) {
                $status = FALSE;
            }
        }
        if ($orderType && !in_array($orderType, [1, 2])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后工单类型(work_order_type)错误']);
        }
        $join = [
            ['goods G', 'G.goods_id = WO.goods_id', 'LEFT'],
//             ['work_order_assess WOA', 'WOA.worder_id = WO.worder_id', 'LEFT'],
            ['user_installer UG', 'UG.installer_id = WO.installer_id', 'LEFT'],
        ];
        $field = 'WO.installer_id,  WO.worder_id, WO.worder_sn, WO.work_order_type, WO.user_name, WO.phone, WO.region_name, WO.address, WO.appointment, WO.work_order_status';
        $field.= ', IF(WO.add_time > 0, FROM_UNIXTIME(WO.add_time), "") as add_time';
        $field.= ', IF(WO.cancel_time > 0, FROM_UNIXTIME(WO.cancel_time), "") as cancel_time';
        $field.= ', IF(WO.receive_time > 0, FROM_UNIXTIME(WO.receive_time), "") as receive_time';
        $field.= ', IF(WO.sign_time > 0, FROM_UNIXTIME(WO.sign_time), "") as sign_time';
        $field.= ', IF(WO.finish_time > 0, FROM_UNIXTIME(WO.finish_time), "") as finish_time';
        $field .= ', G.name as sku_name';
        if (!$installer) {
            $where['WO.post_user_id'] = $user['user_id'];
            $field .= ', UG.realname as installer_name, UG.phone as installer_phone';
        }else{
            if ($status >= -1 || $status === FALSE) {
                $sql = 'WO.installer_id = '.$installer['installer_id'].' OR (WOIR.worder_id = WO.worder_id AND WOIR.installer_id = '.$installer['installer_id'].')';
                $where[] = ['', 'EXP', \think\Db::raw($sql)];
            }else{
                if ($status == -2) {
                    $installStatus = 1;
                }else{
                    $installStatus = 2;
                }
                $sql = '(WOIR.worder_id = WO.worder_id AND WOIR.installer_id = '.$installer['installer_id'].' AND WOIR.status = '.$installStatus.')';
                $where[] = ['', 'EXP', \think\Db::raw($sql)];
            }
            $join[] = ['work_order_installer_record WOIR', 'WOIR.worder_id = WO.worder_id AND WOIR.installer_id = '.$installer['installer_id'].' AND WOIR.is_del = 0', 'LEFT'];
            $field .= ', (case when WOIR.status = 1 then -2 when WOIR.status = 2 then -3 else WO.work_order_status END) as work_order_status';
            if ($status !== FALSE && $status >= -1) {
                $where['work_order_status'] = $status;
            }
        }
        if ($orderType) {
            $where['work_order_type'] = $orderType;
        }
        $order  = 'WO.worder_id desc,wstatus ASC,WO.work_order_status ASC';
        $field .= ', if(WO.work_order_status > 0, 0, 1) as wstatus';
        //$field .= ', if(WOA.assess_id > 0, 1, 0) as has_assess';
        $list = $this->_getModelList(db('work_order'), $where, $field, $order, 'WO', $join);
        if ($list) {
            foreach ($list as $key => $value) {
                $list[$key]['appointment'] = $value['appointment'] ? date('Y-m-d H:i', $value['appointment']) : '';
                $list[$key]['work_order_type'] = $value['work_order_type'];
                $list[$key]['work_order_type_txt'] = get_work_order_type($value['work_order_type']);
                $list[$key]['status_txt'] = get_work_order_installer_status($value['work_order_status']);
                //判断当前工单是否有首次评价和追加评价
                $exist = db('work_order_assess')->field('count(if(type = 1, true, NULL)) as type1, count(if(type = 2, true, NULL)) as type2')->where(['worder_id' => $value['worder_id']])->find();
                $list[$key]['first_assess'] = $exist && isset($exist['type1']) && $exist['type1'] > 0  ? 1 : 0;
                $list[$key]['append_assess'] = $exist && isset($exist['type2']) && $exist['type2'] > 0  ? 1 : 0;
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
        //$where = ['WO.worder_sn' => $worderSn, 'WO.is_del' => 0];
        $where='WO.worder_sn='.$worderSn.' AND WO.is_del=0';

        $field = 'WO.worder_id, WO.worder_sn, WO.installer_id, WO.goods_id,G.name goods_name, WO.work_order_type, WO.order_sn, WO.user_name, WO.phone, WO.region_name, WO.address, WO.appointment, WO.images, WO.fault_desc';
        $field .= ', WO.work_order_status, WO.add_time, WO.dispatch_time, WO.cancel_time, WO.receive_time, WO.sign_time, WO.finish_time';
        $join = [
            ['goods G','G.goods_id=WO.goods_id','LEFT'],
        ];
        if ($installer) {
            //$where[] = 'WO.installer_id = '.$installer['installer_id'].' OR (WOIR.worder_id = WO.worder_id AND WOIR.installer_id = '.$installer['installer_id'].')';
            $where .= ' AND ( WO.installer_id = '.$installer['installer_id'].' OR (WOIR.worder_id = WO.worder_id AND WOIR.installer_id = '.$installer['installer_id'].'))';
            $join[] =['work_order_installer_record WOIR', 'WOIR.worder_id = WO.worder_id AND WOIR.installer_id = '.$installer['installer_id'].' AND WOIR.is_del = 0', 'LEFT'];
            $field .= ', (case when WOIR.status = 1 then -2 when WOIR.status = 2 then -3 else WO.work_order_status END) as work_order_status';
        }else{
            //$where['WO.post_user_id'] = $user['user_id'];
            $where.=' AND WO.post_user_id='.$user['user_id'];
        }
        $detail = db('work_order')->alias('WO')->join($join)->field($field)->where($where)->find();
        if (!$detail) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后工单不存在或已删除']);
        }
        $detail['add_time'] = time_to_date($detail['add_time']);
        $detail['dispatch_time'] = time_to_date($detail['dispatch_time']);
        $detail['cancel_time'] = time_to_date($detail['cancel_time']);
        $detail['receive_time'] = time_to_date($detail['receive_time']);
        $detail['sign_time'] = time_to_date($detail['sign_time']);
        $detail['finish_time'] = time_to_date($detail['finish_time']);
        
        $detail['images'] = $detail['images']? explode(',', $detail['images']) : [];
        $detail['appointment'] = $detail['appointment'] ? date('Y-m-d H:i', $detail['appointment']) : '';
        $detail['work_order_type_txt'] = get_work_order_type($detail['work_order_type']);
        $detail['status_txt'] = get_work_order_installer_status($detail['work_order_status']);
        
        $exist = db('work_order_assess')->field('count(if(type = 1, true, NULL)) as type1, count(if(type = 2, true, NULL)) as type2')->where(['worder_id' => $detail['worder_id']])->find();
        $detail['first_assess'] = $exist && isset($exist['type1']) && $exist['type1'] > 0  ? 1 : 0;
        $detail['append_assess'] = $exist && isset($exist['type2']) && $exist['type2'] > 0  ? 1 : 0;
        
        if ($return) {
            return $detail;
        }
        $installer = db('user_installer')->field('job_no, realname, phone, service_count, score')->where(['installer_id' => $detail['installer_id']])->find();
        $sku = db('goods')->field('goods_id, name, thumb')->where(['goods_id' => $detail['goods_id']])->find();
        $assess = [];
        //工单完成后获取首次评价
        if ($detail) {
            $workOrderModel = new \app\common\model\WorkOrder();
            $assess = $workOrderModel->getWorderAssess($detail, 'assess_id, type, msg, add_time');
        }
        $logs = [];
        if ($user['installer']) {
            //获取工程师工单日志
            $logs = db('work_order_log')->field('worder_sn, action, msg, FROM_UNIXTIME(add_time) add_time')->where(['worder_id' => $detail['worder_id'], 'installer_id' => $user['installer']['installer_id']])->select();
        }
        $logs = $logs ? $logs : [];
        unset($detail['worder_id'], $detail['installer_id'], $detail['osku_id']);
        $result = ['detail' => $detail, 'installer' => $installer, 'sku' => $sku, 'assess_list' => $assess, 'logs' => $logs];
        $this->_returnMsg($result);
    }
    //服务工程师拒绝接单
    protected function refuseWorkOrder()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = $user['installer'];
        if (!$installer) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前用户不是服务工程师']);
        }
        if (!$installer['status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务工程师已禁用,请联系服务商']);
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
    //服务工程师接单
    protected function receiveWorkOrder()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = $user['installer'];
        if (!$installer) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前用户不是服务工程师']);
        }
        if (!$installer['status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务工程师已禁用,请联系服务商']);
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
    //服务工程师现场签到
    protected function signWorkOrder()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = $user['installer'];
        if (!$installer) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前用户不是服务工程师']);
        }
        if (!$installer['status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务工程师已禁用,请联系服务商']);
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
    //工程师完成工单
    protected function finishWorkOrder()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = $user['installer'];
        if (!$installer) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '当前用户不是服务工程师']);
        }
        if ($installer && !$installer['status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务工程师已禁用,请联系服务商']);
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
    //客户取消工单
    protected function cancelWorkOrder()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        $installer = $user['installer'];
        if ($installer) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工程师不允许取消工单']);
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
    //工单完成后客户评价
    protected function assessWorkOrder()
    {
        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        if ($user['installer']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工程师无评价功能']);
        }
        $detail = $this->getWorkOrderDetail(TRUE);
        $type = isset($this->postParams['type']) ? intval($this->postParams['type']) : 0;
        $msg = isset($this->postParams['msg']) ? trim($this->postParams['msg']) : '';
        $score = isset($this->postParams['score']) ? trim($this->postParams['score']) : '';
        if ($type <= 0 || !in_array($type, [1,2])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '评价类型错误']);
        }
//         if (!$msg) {
//             $this->_returnMsg(['errCode' => 1, 'errMsg' => '请输入评价内容']);
//         }
        if ($type == 1 && !$score) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '评分内容不能为空']);
        }
        $worderModel = new \app\common\model\WorkOrder();
        $params = [
            'type'  =>  $type,//1 首次评论 2 追加评论
            'msg'   =>  $msg,
        ];
        $scores = $score ? json_decode($score, 1) : [];
        if($scores){
            $temp = [];
            $config = $this->getWorkOrderAssessConfig(TRUE);
            $config=$config['score'];
            $scores = array_column($scores, 'score', 'config_id');
            foreach ($config as $key => $value) {
                $id = $value['config_id'];
                $name = $value['name'];
                if (!isset($scores[$id])) {
                    $this->_returnMsg(['errCode' => 1, 'errMsg' => $name.' 评价不能为空']);
                }
                if ($scores[$id] <= 0 || $scores[$id] > $value['score']) {
                    $this->_returnMsg(['errCode' => 1, 'errMsg' => $name.' 必须在(1-'.$value['score'].'分之间)']);
                }
                $temp[$id] = $scores[$id];
            }
            $params['score'] = $temp;
        }
        $result = $worderModel->worderAssess($detail, $user, $params);
        if ($result !== FALSE) {
            $this->_returnMsg(['msg' => '操作成功:评价完成']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $worderModel->error]);
        }
    }
    //获取工单评分配置
    protected function getWorkOrderAssessConfig($return = FALSE)
    {
        if (!$return) {
            $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
            if ($user['installer']) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '工程师无评价功能']);
            }
        }
        $config = db('config')->field('config_id, name, config_value as score')->order('sort_order ASC, add_time ASC')->where(['is_del' => 0, 'status' => 1, 'config_key' => CONFIG_WORKORDER_ASSESS])->select();
        $form = ConfigForm::field('id config_id,name,is_required,type,value')->where([
            'key'      => 'work_order_assess',
            'is_del'   => 0,
            'store_id' => $this->factory['store_id'],
        ])->order('sort_order')->select();
        $result = [
            'score'  => $config,
            'detail' => $form,
        ];
        if ($return) {
            return $result;
        }
        $this->_returnMsg(['config' => $result]);
    }
    //上传图片接口
    protected function uploadImage($verifyUser = TRUE)
    {
        if ($verifyUser){
            $user = $this->_checkOpenid();
        }
        $file = $this->request->file('file');
        if (!$file) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请选择上传图片']);
        }
        $type = isset($this->postParams['type']) ? trim($this->postParams['type']) : '';
        if (!$type || !in_array($type, ['idcard', 'store_profile', 'order_service'])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '图片类型错误']);
        }
        //图片上传到七牛
        $upload = new \app\common\controller\UploadBase();
        $result = $upload->upload(TRUE, 'file', 'api_'.$type.'_');
        if (!$result || !$result['status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $result['info']]);
        }
        unset($result['status']);
        $this->_returnMsg(['msg' => '图片上传成功', 'file' => $result]);
    }
    protected function uploadImageSource($verifyUser = TRUE)
    {
        if ($verifyUser){
            $user = $this->_checkOpenid();
        }
        $image = isset($this->postParams['image-data']) ? trim($this->postParams['image-data']) : '';
        
        if (!$image) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '图片数据不能为空']);
        }
        $type = isset($this->postParams['type']) ? trim($this->postParams['type']) : 'idcard';
        if (!$type || !in_array($type, ['idcard', 'store_profile', 'order_service', 'distributor'])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '图片类型错误']);
        }
        
        if (preg_match('/^(data:\s*image\/(\w+);base64,)/',$image, $res)) {
            $image = base64_decode(str_replace($res[1],'', $image));
        }
        $fileSize = strlen($image);
        //图片上传到七牛
        $upload = new \app\common\controller\UploadBase();
        $result = $upload->qiniuUploadData($image, 'api_'.$type.'_', $type, $fileSize);
        if (!$result || !$result['status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $result['info']]);
        }
        unset($result['status']);
        $this->_returnMsg(['msg' => '图片上传成功', 'file' => $result]);
    }

    protected function getFormConfig()
    {
        $cateId=isset($this->postParams['cate_id']) ? intval($this->postParams['cate_id']) : 0;
        if (empty($cateId)) {
            $goodsId=isset($this->postParams['goods_id']) ? intval($this->postParams['goods_id']) : 0;
            $cateId=db('goods')->where(['goods_id'=>$goodsId,'is_del'=>0])->value('cate_id');
        }
        if (empty($cateId)) {
            $skuId=isset($this->postParams['sku_id']) ? intval($this->postParams['sku_id']) : 0;
            $cateId=db('goods_sku')
                ->alias('GS')
                ->join('goods G','G.goods_id=GS.goods_id')
                ->where(['GS.is_del'=>0,'G.is_del'=>0,'GS.sku_id'=>$skuId])
                ->value('G.cate_id');
        }
        if (empty($cateId)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请先选择商品类型']);
        }
        $type=$skuId=isset($this->postParams['type']) ? intval($this->postParams['type']) : '';
        $arr=[
            'work_order_install_add',
            'installer_confirm',
            'install_user_confirm',
            'installer_assess',
            'repairman_confirm',
            'repair_user_confirm',
            'repair_assess',
        ];
        if ($type==='' || !key_exists($type,$arr)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请选择表单的类型']);
        }
        $result = ConfigForm::field('name,is_required,type,value')->where([
            'is_del'   => 0,
            'store_id' => $this->factory['store_id'],
            'key'      => $arr[$type] . '_' . $cateId,
        ])->order('sort_order ASC')->select();
        $this->_returnMsg(['msg' => 'ok', 'list' => $result]);
    }
    /****************************************************************====================================================================*************************************************************/
    private function _checkGoods($goodsId = 0, $field = FALSE)
    {
        $goodsId = $goodsId ? $goodsId : (isset($this->postParams['goods_id']) ? intval($this->postParams['goods_id']) : 0);
        if (!$goodsId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '产品ID(goods_id)缺失']);
        }
        $field = $field ? $field: '*';
        $where = [
            'goods_id' => $goodsId,
            'is_del' => 0,
            'store_id' => $this->factory['store_id'],
        ];
        return db('goods')->field($field)->where($where)->find();
    }
    /**
     * 验证工程师信息
     * @param number $userId
     * @param string $field
     * @return string|string[]
     */
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
        $field = $field ? $field.', UD.user_type' : 'UD.*, U.user_id, U.phone, U.status';
        $where = [
            'openid' => $openid, 
            'UD.factory_id' => $this->factory['store_id'],
        ];
        $user = db('user_data')->alias('UD')->join('user U', 'UD.user_id = U.user_id AND U.is_del = 0', 'LEFT')->field($field)->where($where)->find();
        if (!$user['user_id']) {
            if (!isset($user['user_type']) || !$user['user_type']) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户不存在']);
            }
            if ($verify) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '未绑定手机号']);
            }
            $user['openid'] = $openid;
        }else{
            $installer = [];
            if (isset($user['status']) && !$user['status']) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户已禁用不允许登录']);
            }
            if (isset($user['user_id']) && $installFlag && $user['user_type'] == 'installer') {
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
    protected function _getModelList($model, $where = [], $field = '*', $order = false, $alias = false, $join = [], $group = false, $having = false)
    {
        if($alias)  $model->alias($alias);
        if($join)   $model->join($join);
        if($where)  $model->where($where);
        if($having) $model->having($having);
        if($order)  $model->order($order);
        if($group)  $model->group($group);
        if ($this->pageSize > 0) {
            if (method_exists($model, 'save')) {
                $result = $model->alias($alias)->join($join)->where($where)->having($having)->order($order)->field($field)->group($group)->paginate($this->pageSize, false, ['page' => $this->page]);
            }else{
                $result = $model->field($field)->paginate($this->pageSize, false, ['page' => $this->page]);
            }
            if ($result) {
                return $result->items();
            }
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
//         $data['sing_data'] = $this->signData;
        $result = parent::_returnMsg($data);
        $responseTime = $this->_getMillisecond() - $this->visitMicroTime;//响应时间(毫秒)
//         if (strlen($this->postParams['timestamp']) == 13) {
//             $this->postParams['timestamp'] = substr($this->postParams['timestamp'], 0, 10);
//         }
        $ret=json_decode($result,true);
        $addData = [
            'module'        => $this->request->module(),
            'controller'    => strtolower($this->request->controller()),
            'action'        => $this->request->action(),
            'request_time'  => $this->requestTime,
            'request_source'=> $this->fromSource ? $this->fromSource : '',
            'return_time'   => time(),
            'method'        => $this->method ? $this->method : '',
            'request_params'=> $this->postParams ? json_encode($this->postParams) : '',
            'return_params' => $result,
            'response_time' => $responseTime,
            'error'         => isset($ret['errCode'])  ? intval($ret['errCode']) : 0,
            'msg'           => isset($ret['errMsg'])  ? $ret['errMsg'] : '',
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
//         $this->postParams['sign_data'] = $para;
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
        $this->signData = $prestr;
        
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
        if($len != 10) {//时间戳长度格式不对
            $this->_returnMsg(array('errCode' => 1, 'errMsg' => '时间戳格式错误(10位有效长度)'));
        }
        if (strlen($timestamp) == 13) {
//             $this->postParams['timestamp'] = $timestamp = substr($timestamp, 0, 10);
        }
        if($timestamp + 180 < time()) {//时间戳已过期(180秒内过期)
            $this->_returnMsg(array('errCode' => 1, 'errMsg' => '请求已超时'));
        }
        if(!$this->signKey) {
            $this->_returnMsg(array('errCode' => 1,'errMsg' => '签名密钥(signkey)参数缺失'));
        }
        if(!in_array($this->signKey, $this->signKeyList)) {
            $this->_returnMsg(array('errCode' => 1,'errMsg' => '签名密钥错误'));
        }
        if (strtolower($this->request->controller()) == 'index' && !$this->mchKey) {
            $this->_returnMsg(array('errCode' => 1,'errMsg' => '商户密钥(mchkey)参数缺失'));
        }
        if($this->mchKey){
            //根据商户密钥获取商户信息
            $this->factory = db('store_factory')->alias('SF')->join('store S', 'S.store_id = SF.store_id', 'INNER')->where(['store_no' => trim($this->mchKey), 'store_type' => STORE_FACTORY, 'S.is_del' => 0])->find();
            if(!$this->factory) {
                $this->_returnMsg(array('errCode' => 1,'errMsg' => '商户密钥(mchkey)对应商户不存在或已删除'));
            }
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