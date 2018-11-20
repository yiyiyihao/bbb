<?php
namespace app\admin\controller;
use app\common\controller\AdminBase;
use app\common\model\User;
/**
 * @author chany
 * @date 2018-11-08
 * 后台管理登录操作
 */
class Login extends AdminBase
{
    public function index()
    {
        if(IS_POST){
            $userName = input('post.username');
            $passWord = input('post.password', '', 'trim');
            if(empty($userName)||empty($passWord)){
                return $this->error(lang('userorpsw_null'));
            }
            //查询用户
            $map['username'] = $userName;
            $userInfo = User::where($map)->find();
            if(empty($userInfo)){
                return $this->error(lang('usernotexist'));
            }
            $userInfo = $userInfo->toArray();
            if(!$userInfo['status']){
                return $this->error(lang('login_forbidden'));
            }
            if($userInfo['password']<> md5($passWord)){
                return $this->error(lang('psw_error'));
            }
            $result = $this->updateLogin($userInfo);
            if(!$result['error']){
                return $this->success(lang('login_success'),"/",['tipmsg'=>'正在登陆...'],0);
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
        $userMod = new User();
        $userMod->logout();
        $this->redirect(url('/'));
        //        $this->redirect();
        //        return $this->success(lang('logout_success'), url('/'));
    }
}
