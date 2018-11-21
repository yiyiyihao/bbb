<?php
namespace app\admin\controller;
use app\common\controller\AdminBase;
/**
 * @author chany
 * @date 2018-11-08
 * 后台管理登录操作
 */
class Login extends AdminBase
{
    public function index()
    {
        if ($this->adminUser) {
            $this->success('用户已登录', '/');
        }
        if(IS_POST){
            $userName = input('post.username', '', 'trim');
            $passWord = input('post.password', '', 'trim');
            if(empty($userName)||empty($passWord)){
                return $this->error(lang('USERORPSW_NULL'));
            }
            //查询用户
            $map['username'] = $userName;
            $userModel = new \app\common\model\User();
            $user = $userModel->where($map)->find();
            if(empty($user)){
                return $this->error(lang('USERNOTEXIST'));
            }
            $user = $user->toArray();
            if(!$user['status']){
                return $this->error(lang('LOGIN_FORBIDDEN'));
            }
            if($user['password']<> $userModel->pwdEncryption($passWord)){
                return $this->error(lang('PSW_ERROR'));
            }
            $result = $this->updateLogin($user);
            if(!$result['error']){
                return $this->success(lang('LOGIN_SUCCESS'), "/", ['tipmsg'=>'正在登陆...'], 0);
            }else{
                return $this->error($result['msg']);
            }
        }else{
            $this->assign('title',config("setting.title"));
            $this->import_resource('base:js/Validform.min.js,base:js/form.js');
            $this->view->engine->layout(false);
            return $this->fetch();
        }
    }
    //页面登出
    public function logout(){
        $userModel = new \app\common\model\User();
        $userModel->logout();
        $this->redirect(url('/'));
        //        $this->redirect();
        //        return $this->success(lang('logout_success'), url('/'));
    }
}