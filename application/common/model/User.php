<?php
namespace app\common\model;
use think\Model;

class User extends Model
{
	public $error;
	protected $fields;
	protected $pk = 'user_id';

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
    public function authorized($factoryId, $params = [])
    {
        $userType       = isset($params['user_type']) ? trim($params['user_type']) : '';
        $appid          = isset($params['appid']) ? trim($params['appid']) : '';
        $thirdType      = isset($params['third_type']) ? trim($params['third_type']) : '';
        $thirdOpenid    = isset($params['third_openid']) ? trim($params['third_openid']) : '';
        $nickname       = isset($params['nickname']) ? trim($params['nickname']) : '';
        $avatar         = isset($params['avatar']) ? trim($params['avatar']) : '';
        $gender         = isset($params['gender']) ? trim($params['gender']) : 0;
        $unionid        = isset($params['unionid']) ? trim($params['unionid']) : '';
        if (!$factoryId){
            $this->error = '厂商ID不能为空';
            return FALSE;
        }
        if (!$userType){
            $this->error = '用户类型不能为空';
            return FALSE;
        }
        if (!$appid){
            $this->error = '应用appid不能为空';
            return FALSE;
        }
        if (!$thirdType){
            $this->error = '第三方账户类型不能为空';
            return FALSE;
        }
        if (!$thirdOpenid){
            $this->error = '第三方账户唯一标识不能为空';
            return FALSE;
        }
        $thirdTypes = [
            'wechat_applet' => '微信小程序',
            'wechat_js' => '微信公众号H5',
        ];
        if (!isset($thirdTypes[$thirdType])) {
            $this->error = '第三方账户类型错误';
            return FALSE;
        }
        //判断userData表第三方账号是否存在
        $where = [
            'factory_id'    => $factoryId,
            'third_openid'  => $thirdOpenid,
            'third_type'    => $thirdType,
            'is_del'        => 0,
        ];
        $userDataModel = new \app\common\model\UserData();
        $exist = $userDataModel->where($where)->find();
        $userId = 0;
        if (!$exist){
            if ($unionid) {
                //判断unionid对应第三方账户是否绑定账号
                $info = $userDataModel->where(['factory_id' => $factoryId, 'unionid' => $unionid, 'is_del' => 0, 'third_type' => ['<>', $thirdType]])->find();
                if ($info) {
                    $userId = isset($info['user_id']) && $info['user_id'] ? intval($info['user_id']) : 0;
                }
            }
            $openid = $this->getUserOpenid();
            $params['factory_id']   = $factoryId;
            $params['user_id']      = $userId;
            $params['openid']       = $openid;
            $params['user_type']    = $userType;
            $params['appid']        = $appid;
            $udataId = $userDataModel->save($params);
        }else{
            $udataId = $exist['udata_id'];
            $openid = $exist['openid'];
            $userId = $exist['user_id'];
            //修改第三方更新的数据
            $data = [];
            foreach ($exist as $key => $value) {
                if (isset($params[$key]) && trim($value) != trim($params[$key])) {
                    $data[$key] = trim($params[$key]);
                }
            }
            if ($data) {
                $userDataModel->save($data, ['udata_id' => $exist['udata_id']]);
            }
        }
        return ['openid' => $openid, 'user_id' => $userId, 'udata_id'=> $udataId];
    }
    public function bindPhone($openid, $phone)
    {
        if (!$openid || !$phone) {
            $this->error = lang('PARAM_ERROR');
            return FALSE;
        }
        $udataModel = new \app\common\model\UserData();
        $udataInfo = $udataModel->where(['openid' => $openid])->find();
        if (!$udataInfo){
            $this->error = '账号不存在或已删除';
            return FALSE;
        }
        $factoryId = $udataInfo['factory_id'];
        //判断手机号对应账户是否存在
        $exist = $this->where(['factory_id' => $factoryId, 'phone' => $phone, 'is_del' => 0])->find();
        if (!$exist) {
            $data = [
                'factory_id' => $factoryId,
                'username' => '',
                'nickname' => $udataInfo['nickname'],
                'realname' => $udataInfo['nickname'],
                'phone' => $phone,
                'avatar' => $udataInfo['avatar'],
                'gender' => $udataInfo['gender'],
            ];
            $userId = $this->save($data);
        }else{
            $userId = $exist['user_id'];
        }
        $result = $udataModel->save(['user_id' => $userId], ['udata_id' => $udataInfo['udata_id']]);
        return $userId;
    }
    public function changePhone($user, $oldPhone, $phone)
    {
        if (!$user || !isset($user['user_id']) || !$user['user_id']) {
            $this->error = lang('PARAM_ERROR');
            return FALSE;
        }
        if (!$oldPhone) {
            $this->error = lang('原手机号不能为空');
            return FALSE;
        }
        //验证原手机号格式
        $result = $this->checkPhone($user['factory_id'], $oldPhone);
        if ($result === FALSE) {
            return FALSE;
        }
        if (!$phone) {
            $this->error = lang('新手机号不能为空');
            return FALSE;
        }
        //验证新手机号格式
        $result = $this->checkPhone($user['factory_id'], $phone);
        if ($result === FALSE) {
            return FALSE;
        }
        if ($oldPhone == $phone) {
            $this->error = lang('更换的手机号不能与原手机号一致');
            return FALSE;
        }
        if (!isset($user['phone']) || !$user['phone']) {
            $this->error = lang('未绑定手机号,不能更换');
            return FALSE;
        }
        if ($user['phone'] != $oldPhone) {
            $this->error = lang('原手机号错误');
            return FALSE;
        }
        //判断新手机号是否已经绑定过账户
        $exist = $this->where(['factory_id' => $user['factory_id'], 'phone' => $phone, 'is_del' => 0])->find();
        if ($exist) {
            $this->error = lang('新手机号已绑定其它账户');
            return FALSE;
        }
        return $this->save(['phone' => $phone], ['user_id' => $user['user_id']]);
    }
    
    /**
     * 登录用户
     * @param string $user
     * @param number $userId
     * @return boolean 登录状态
     */
    public function setLogin($user = FALSE, $userId = 0,$domain = 'admin')
    {
        if(!$user && !$userId){
            $this->error = lang('PARAM_ERROR');
            return FALSE;
        }
        if($user){
            $userId = $user['user_id'];
            // 更新登录信息
            $data = [
                'user_id' => $userId,
                'last_login_time' => NOW_TIME,
            ];
            $result = $this->save($data, ['user_id' => $userId]);
            if ($result === FALSE) {
                $this->error = lang('SYSTEM_ERROR');
                return FALSE;
            }
        }else{
            //重新取得用户信息
            $user = $this->checkUser($userId, TRUE);
        }
        if ($user['admin_type'] <= 0 && $user['is_admin'] <= 0) {
            $this->error = lang('PERMISSION_DENIED');
            return FALSE;
        }
        if ($user['group_id']) {
            //获取账户角色权限
            $group = db('user_group')->where(['group_id' => $user['group_id'], 'is_del' => 0, 'status' => 1])->find();
            if (!$group) {
                $this->error = lang('PERMISSION_DENIED');
                return FALSE;
            }
            $groupPurview = $group['menu_json'];
        }else{
            #TODO 获取系统设置权限
            $groupPurview = [];
        }
        $adminStore = [];
        $storeType = 0;
        if ($user['admin_type'] != ADMIN_SYSTEM) {
            if ($user['is_admin'] <= 0) {
                $this->error = lang('PERMISSION_DENIED');
                return FALSE;
            }
            if ($user['store_id'] < 0) {
                $this->error = lang('PERMISSION_DENIED');
                return FALSE;
            }
            if (isset($user['store'])&& $user['store']) {
                $adminStore = $user['store'];
            }elseif ($user['store_id'] > 0){
                $adminStore = db('store')->field('store_id, name, factory_id, store_type, store_no, check_status, status')->where(['store_id' => $user['store_id'], 'is_del' => 0])->find();
            }
            if ($adminStore) {
                $storeType = $adminStore['store_type'];
                session('admin_store',$adminStore);
            }
        }
        //设置session
		$adminUser = [
		    'user_id'         => $user['user_id'],
		    'admin_type'      => $user['admin_type'],
		    'factory_id'      => $user['factory_id'],
		    'store_id'        => $user['store_id'],
		    'store_type'      => $storeType,
		    'group_id'        => $user['group_id'],
		    'username'        => $user['username'],
		    'realname'        => $user['realname'],
		    'nickname'        => $user['nickname'],
		    'phone'           => $user['phone'],
		    'last_login_time' => $user['last_login_time'],
		    'groupPurview'    => $groupPurview,
		    'pwd_modify'      => $user['pwd_modify'],
		];
		$this->setSession($domain, $adminUser);
        return TRUE;        
    }
    public function setSession($domain, $user)
    {
        session($domain.'_user', $user);
    }
    /**
     * 密码加密
     * @param string $password
     * @return string
     */
    public function pwdEncryption($password = '')
    {
        if (!$password) {
            return FALSE;
        }
        return md5($password.'_admin_2018');
    }
    
    /**
     * 注销当前用户
     * @return void
     */
    public function logout($domain = 'admin'){
        session($domain.'_user', null);
        session('admin_factory',null);
        session('admin_store',null);
    }    
    
    /**
     * 获取用户平台openid
     * @return 产生的随机字符串
     */
    public function getUserOpenid()
    {
        $openid = get_nonce_str(30);
        $exist = db('user_data')->where(['openid' => $openid])->find();
        if ($exist) {
            return $this->getUserOpenid();
        }else{
            return $openid;
        }
    }
    /**
     * 检查用户ID对应信息是否存在
     * @param number $userId    用户ID
     * @param string $groupFlag 是否返回用户管理员分组信息
     * @return array
     */
    public function checkUser($userId = 0, $groupFlag = FALSE)
    {
        $user = db('User')->where(['user_id' => $userId, 'is_del' => 0])->find();
        if (!$user){
            $this->error = lang('USERNOTEXIST');
            return FALSE;
        }
        if(!$user['status']){
            $this->error = lang('LOGIN_FORBIDDEN');
            return FALSE;
        }
        if ($user['admin_type'] && $user['store_id']) {
            $user['store'] = db('store')->field('store_id, name, store_type')->where(['store_id' => $user['store_id'], 'is_del' => 0, 'status' => 1])->find();
        }
        if ($groupFlag) {
            if ($user['group_id']) {
                $group = db('user_group')->where(['group_id' => $user['group_id'], 'is_del' => 0, 'status' => 1])->find();
                if (!$group) {
                    $this->error = lang('PERMISSION_DENIED');
                    return FALSE;
                }
                $user['group'] = $group;
            }
        }
        return $user;
    }
    /**
     * 用户信息格式检查
     * @param array $extra
     * @return boolean
     */
    public function checkFormat($factoryId = 0, $extra = [])
    {
        $username = isset($extra['username']) ? trim($extra['username']) : '';
        $password = isset($extra['password']) ? trim($extra['password']) : '';
        $phone = isset($extra['phone']) ? trim($extra['phone']) : '';
        //检查用户名格式
        $pattern = '/^[\w]{5,16}$/';
        if ($username) {
            //是否验证用户名格式
            $uncheckName = $extra && isset($extra['uncheck_name']) ? $extra['uncheck_name'] : 0;
            if (!$uncheckName && !preg_match($pattern, $username)) {
                $this->error = '登录用户名格式:5-16位字符长度,只能由英文数字下划线组成';
                return FALSE;
            }
            //检查登录用户名是否存在
            $exist = $this->checkUsername($factoryId, $username);
            if ($exist) {
                $this->error = '登录用户名已经存在';
                return FALSE;
            }
        }
        //检查密码格式
        $pattern = '/^\w{5,20}$/';
        if ($password && !preg_match($pattern, $password)) {
            $this->error = '登录密码格式:长度在5~20之间，只能包含字母、数字和下划线';
            return FALSE;
        }
        if ($phone) {
            return $this->checkPhone($factoryId, $phone, TRUE, $extra);
        }
        return TRUE;
    }
    public function checkPhone($factoryId = 0, $phone = '', $unique = FALSE, $extra = [])
    {
        $pattern = '/^(13[0-9]|14[0|9]|15[0-9]|167[0-9]|17[0-9]|18[0-9]|19[0-9])\d{8}$/';
        if ($phone) {
            if (!preg_match($pattern, $phone)) {
                $this->error = '手机号格式错误';
                return FALSE;
            }
            if ($unique) {
                //验证手机号唯一性
                $userId = $extra && isset($extra['user_id']) ? $extra['user_id'] : 0;
                if (!$userId) {
                    $userId = $extra && isset($extra['id']) ? $extra['id'] : 0;
                }
                $where = ['phone' => $phone, 'factory_id' => $factoryId, 'user_id' => ['<>', $userId], 'is_del' => 0];
                if ($userId) {
                    $where['user_id'] = ['<>', $userId];
                }
                $exist = $this->where($where)->find();
                if ($exist) {
                    $this->error = '手机号已存在';
                    return FALSE;
                }
                return TRUE;
            }
        }
        return TRUE;
    }
    /**
     * 检查登录用户名是否存在
     * @param string $username
     * @return number
     */
    public function checkUsername($factoryId = 0, $username = '')
    {
        $exist = $this->where(['username' => $username, 'factory_id' => $factoryId, 'is_del' => 0])->find();
        return $exist ? 1: 0;
    }
}