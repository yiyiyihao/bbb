<?php
namespace app\api\controller;

class Admin extends Index
{
    private $loginUser;
    private $h5Url = 'http://m.smarlife.cn';
    public function __construct(){
        $origin = isset($_SERVER['HTTP_ORIGIN']) ? $_SERVER['HTTP_ORIGIN'] : '';
        $allowOrigin = array(
            'http://m.wanjiaan.com',
        );
        if(in_array($origin, $allowOrigin)){
            header('Access-Control-Allow-Origin:'.$origin);
            header('Access-Control-Allow-Methods:POST');
            header('Access-Control-Allow-Headers:x-requested-with,content-type');
        }
//         parent::__construct();
    }
    public function login()
    {
        $name = 'login_';
        $session = session($name);
        if (!$session) {
            $session = get_nonce_str(12);
            session($name, $session);
        }
        pre($_SESSION);
        return $session;
        
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
            'factory_id'=> $this->factory['store_id'], 
            'is_del'    => 0, 
            'username'  => $username,
            'group_id'  => ['>', 0],
            'admin_type'=> ['IN', [ADMIN_FACTORY, ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_SERVICE]],
            'is_admin'  => ['>', 0],
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
        pre($result);
    }
}