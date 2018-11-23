<?php

namespace app\common\model;
use think\Model;

class User extends Model
{
	public $error;
	
	protected $fields;

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
    /**
     * 检查用户ID对应信息是否存在
     * @param number $userId    用户ID
     * @param string $groupFlag 是否返回用户管理员分组信息
     * @return array
     */
    public function _checkUser($userId = 0, $groupFlag = FALSE)
    {
        $user = db('User')->where(['user_id' => ADMIN_ID, 'is_del' => 0])->find();
        if (!$user){
            $this->error = lang('USERNOTEXIST');
            return FALSE;
        }
        if(!$user['status']){
            $this->error = lang('LOGIN_FORBIDDEN');
            return FALSE;
        }
        if ($groupFlag) {
            if ($user['group_id'] <= 0) {
                $this->error = lang('PERMISSION_DENIED');
                return FALSE;
            }
            $group = db('user_group')->where(['group_id' => $user['group_id'], 'is_del' => 0, 'status' => 1])->find();
            if (!$group) {
                $this->error = lang('PERMISSION_DENIED');
                return FALSE;
            }
            $user['group'] = $group;
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
            $pattern = '/^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/';
            if ($phone && !preg_match($pattern, $phone)) {
                $this->error = '手机号格式错误';
                return FALSE;
            }
        }
        //检查用户名格式
        $pattern = '/^[\w]{5,16}$/';
        if ($username) {
            $uncheckName = $extra && isset($extra['uncheck_name']) ? $extra['uncheck_name'] : 0;
            if (!$uncheckName && !preg_match($pattern, $username)) {
                $this->error = '登录用户名格式:5-16位字符长度,只能由英文数字下划线组成';
                return FALSE;
            }
            //检查登录用户名是否存在
            $exist = $this->_checkUsername($username);
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
        if ($phone && !preg_match($pattern, $phone)) {
            $this->error = '手机号格式错误';
            return FALSE;
        }
        return TRUE;
    }
    /**
     * 检查登录用户名是否存在
     * @param string $username
     * @return number
     */
    public function _checkUsername($username = '')
    {
        $exist = $this->where(['username' => $username, 'is_del' => 0])->find();
        return $exist ? 1: 0;
    }
    
    /**
     * 登录用户
     * @param string $user
     * @param number $userId
     * @return boolean 登录状态
     */
    public function setLogin($user = FALSE, $userId = 0)
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
            if ($user['group_id'] <= 0) {
                $this->error = lang('PERMISSION_DENIED');
                return FALSE;
            }
            $group = db('user_group')->where(['group_id' => $user['group_id'], 'is_del' => 0, 'status' => 1])->find();
            if (!$group) {
                $this->error = lang('PERMISSION_DENIED');
                return FALSE;
            }
        }else{
            //重新取得用户信息
            $user = $this->_checkUser($userId, TRUE);
            $group = $user['group'];
        }
        $factory = [];
        if ($group['group_id'] != 1) {
            if ($user['store_id'] <= 0) {
                $this->error = lang('PERMISSION_DENIED');
                return FALSE;
            }
            $store = db('store')->field('store_id, factory_id, store_type, name')->where(['store_id' => $user['store_id'], 'is_del' => 0, 'status' => 1])->find();
            if (!$store) {
                $this->error = lang('PERMISSION_DENIED');
                return FALSE;
            }
            $storeType = $store['store_type'];
            if ($storeType != 1) {
                $factory = db('store')->where(['store_id' => $store['factory_id'], 'is_del' => 0, 'status' => 1])->field('store_id, name')->find();
            }else{
                $factory = $store;
            }
        }else{
            $storeType = 0;
        }
        
		$user['groupPurview'] = $group['menu_json'];
        //设置session
		$adminUser = [
		    'user_id'         => $user['user_id'],
		    'factory_id'      => $user['store_id'],
		    'store_id'        => $user['store_id'],
		    'factory'         => $factory,
		    'store_type'      => $storeType,
		    'group_id'        => $user['group_id'],
		    'username'        => $user['username'],
		    'phone'           => $user['phone'],
		    'last_login_time' => $user['last_login_time'],
		    'groupPurview'    => $user['groupPurview'],
		];
    	session('admin_user', $adminUser);
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
    public function logout(){
        session('admin_user', null);
    }    
}