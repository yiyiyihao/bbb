<?php
namespace app\common\service;
class User
{
    var $error;
    var $userModel;
    public function __construct(){
        $this->userModel = db('user');
    }
    /**
     * 用户注册
     * @param string $username  登录用户名
     * @param string $password  登录密码
     * @param array $extra      其它用户信息
     * @return boolean|number
     */
    public function register($username = '', $password = '', $extra = [])
    {
        if (!$username) {
            $this->error = '登录用户名不能为空';
            return FALSE;
        }
        if ($password !== FALSE && !$password) {
            $this->error = '登录密码不能为空';
            return FALSE;
        }
        $phone = isset($extra['phone']) ? trim($extra['phone']) : '';
        $email = isset($extra['email']) ? trim($extra['email']) : '';
        $extra['username'] = $username;
        $extra['password'] = $password;
        $result = $this->_checkFormat($extra);
        if ($result === FALSE) {
            return FALSE;
        }
        //检查登录用户名是否存在
        $exist = $this->_checkUsername($username);
        if ($exist) {
            $this->error = '登录用户名已经存在';
            return FALSE;
        }
        $nickname = isset($extra['nickname']) ? trim($extra['nickname']) : (isset($extra['realname']) ? trim($extra['realname']) : '');
        $groupId = isset($extra['group_id']) ? intval($extra['group_id']) : 0;
        if ($groupId && in_array($groupId, [SYSTEM_SUPER_ADMIN, STORE_SUPER_ADMIN, STORE_MANAGER])) {
            $isAdmin = 1;
        }elseif ($groupId && $groupId == STORE_CLERK){
            $isAdmin = 2;
        }else{
            $isAdmin = 0;
        }
        $data = [
            'username'  => $username,
            'password'  => $password ? $this->_passwordEncryption($password) : '',
            'nickname'  => $nickname,
            'realname'  => isset($extra['realname']) ? trim($extra['realname']) : '',
            'avatar'    => isset($extra['avatar']) ? trim($extra['avatar']) : '',
            'phone'     => $phone,
            'email'     => $email,
            'age'       => isset($extra['age']) ? intval($extra['age']) : 0,
            'gender'    => isset($extra['gender']) ? intval($extra['gender']) : 0,
            'group_id'  => $groupId,
            'is_admin'  => $isAdmin,
            'add_time'  => time(),
            'update_time'=> time(),
            'fuser_id'  => isset($extra['fuser_id']) ? intval($extra['fuser_id']) : 0,
        ];
        $userId = $this->userModel->insertGetId($data);
        if ($userId === false) {
            $this->error = '系统出错';
            return FALSE;
        }
        return $userId;
    }
    public function update($userId = 0, $password = '', $extra = [])
    {
        if (!$userId) {
            $this->error = '参数错误';
            return FALSE;
        }
        $user = $this->userModel->where(['user_id' => $userId])->find();
        if (!$user) {
            $this->error = '用户不存在';
            return FALSE;
        }
        $phone = isset($extra['phone']) ? trim($extra['phone']) : '';
        $email = isset($extra['email']) ? trim($extra['email']) : '';
        $extra['password'] = $password;
        if (isset($extra['username'])) {
            unset($extra['username']);
        }
        $result = $this->_checkFormat($extra);
        if ($result === FALSE) {
            return FALSE;
        }
        $data = [
            'nickname'  => isset($extra['nickname']) ? trim($extra['nickname']) : $user['nickname'],
            'realname'  => isset($extra['realname']) ? trim($extra['realname']) : $user['realname'],
            'avatar'    => isset($extra['avatar']) ? trim($extra['avatar']) : $user['avatar'],
            'phone'     => isset($extra['phone']) ? trim($extra['phone']) : $user['phone'],
            'email'     => isset($extra['email']) ? trim($extra['email']) : $user['email'],
            'age'       => isset($extra['age']) ? trim($extra['age']) : $user['age'],
            'gender'    => isset($extra['gender']) ? intval($extra['gender']) : $user['gender'],
            'group_id'  => isset($extra['group_id']) ? intval($extra['group_id']) : $user['group_id'],
            'is_admin'  => isset($extra['is_admin']) ? intval($extra['is_admin']) : $user['is_admin'],
            'update_time'=> time(),
            'fuser_id'  => isset($extra['fuser_id']) ? intval($extra['fuser_id']) : $user['fuser_id'],
            'status'    => isset($extra['status']) ? intval($extra['status']) : $user['status'],
        ];
        if (isset($extra['password']) && $extra['password']) {
            $data['password'] = $this->_passwordEncryption($password);
        }
        $result = $this->userModel->where(['user_id' => $userId])->update($data);
        if ($result === false) {
            $this->error = '系统出错';
            return FALSE;
        }
        return $userId;
    }
    
    
    
    /**
     * 检查登录用户名是否存在
     * @param string $username
     * @return number
     */
    public function _checkUsername($username = '')
    {
        $exist = $this->userModel->where(['username' => $username, 'is_del' => 0])->find();
        return $exist ? 1: 0;
    }
    /**
     * 密码加密
     * @param string $password
     * @return string
     */
    public function __pwdEncryption($password = '')
    {
        if (!$password) {
            return FALSE;
        }
        return md5($password.'_admin_2018');
    }
    
    public function _checkFormat($extra = [])
    {
        $username = isset($extra['username']) ? trim($extra['username']) : '';
        $password = isset($extra['password']) ? trim($extra['password']) : '';
        $phone = isset($extra['phone']) ? trim($extra['phone']) : '';
        $email = isset($extra['email']) ? trim($extra['email']) : '';
        if ($phone == $username) {
            $exist = $this->userModel->where(['username' => $phone, 'is_del' => 0])->find();
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
        $pattern = '/^[a-zA-Z]\w{5,19}$/';
        if ($password && !preg_match($pattern, $password)) {
            $this->error = '登录密码格式:以字母开头，长度在6~20之间，只能包含字母、数字和下划线';
            return FALSE;
        }
        $pattern = '/^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/';
        if ($phone && !preg_match($pattern, $phone)) {
            $this->error = '手机号格式错误';
            return FALSE;
        }
        $pattern = '/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/';
        if ($email && !preg_match($pattern, $email)) {
            $this->error = 'email格式错误';
            return FALSE;
        }
        return TRUE;
    }
}