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
        if ($user['admin_type'] <= 0) {
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
        
        if ($user['admin_type'] != ADMIN_SYSTEM) {
            if ($user['store_id'] <= 0) {
                $this->error = lang('PERMISSION_DENIED');
                return FALSE;
            }
            if (isset($user['store'])&& $user['store']) {
                $adminStore = $user['store'];
            }else{
                $adminStore = db('store')->field('store_id, name, factory_id, store_type')->where(['store_id' => $user['store_id'], 'is_del' => 0])->find();
            }
            session('admin_store',$adminStore);
        }
        //设置session
		$adminUser = [
		    'user_id'         => $user['user_id'],
		    'admin_type'      => $user['admin_type'],
		    'factory_id'      => $user['admin_type'] == 2 ? $user['store_id'] : 0,
		    'store_id'        => $user['store_id'],
		    'group_id'        => $user['group_id'],
		    'username'        => $user['username'],
		    'phone'           => $user['phone'],
		    'last_login_time' => $user['last_login_time'],
		    'groupPurview'    => $groupPurview,
		];
		session($domain.'_user', $adminUser);
        return TRUE;        
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
    }    
    
    /**
     * 获取用户平台openid
     * @return 产生的随机字符串
     */
    public function _getUserOpenid()
    {
        $openid = get_nonce_str(30);
        $exist = db('user_data')->where(['openid' => $openid])->find();
        if ($exist) {
            return $this->_getUserOpenid();
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
    public function _checkFormat($extra = [])
    {
        $username = isset($extra['username']) ? trim($extra['username']) : '';
        $password = isset($extra['password']) ? trim($extra['password']) : '';
        $phone = isset($extra['phone']) ? trim($extra['phone']) : '';
        if ($phone == $username) {
            $exist = $this->where(['username' => $phone, 'is_del' => 0])->find();
            if ($exist) {
                $this->error = '手机号已存在';
                return FALSE;
            }
            $pattern = '/^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9]|19[0|1|2|3|5|6|7|8|9]|17[0|1|2|3|5|6|7|8|9])\d{8}$/';
            if ($phone && !preg_match($pattern, $phone)) {
                $this->error = '手机号格式错误';
                return FALSE;
            }
        }
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
            $exist = $this->checkUsername($username);
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
        $pattern = '/^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/';
        if ($phone) {
            if (!preg_match($pattern, $phone)) {
                $this->error = '手机号格式错误';
                return FALSE;
            }
            //验证手机号唯一性
            $uncheckPhone = $extra && isset($extra['uncheck_phone']) ? $extra['uncheck_phone'] : 0;
            $userId = $extra && isset($extra['user_id']) ? $extra['user_id'] : 0;
            if (!$uncheckPhone && $userId) {
                $exist = $this->where(['phone' => $phone, 'user_id' => ['<>', $userId], 'is_del' => 0])->find();
                if ($exist) {
                    $this->error = '手机号已存在';
                    return FALSE;
                }
            }
        }
        return TRUE;
    }
    /**
     * 检查登录用户名是否存在
     * @param string $username
     * @return number
     */
    public function checkUsername($username = '')
    {
        $exist = $this->where(['username' => $username, 'is_del' => 0])->find();
        return $exist ? 1: 0;
    }
}