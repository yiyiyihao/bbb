<?php
namespace app\common\controller;
use app\common\controller\CommonBase;
use think\facade\Request;
/**
 * @author chany
 * @date 2018-11-08
 * 管理登录操作
 */
class Login extends CommonBase
{
    public function index()
    {
        if(IS_POST){
            $domain = Request::panDomain();
            $userName = input('post.username', '', 'trim');
            $passWord = input('post.password', '', 'trim');
            if(empty($userName)||empty($passWord)){
                return $this->error(lang('USERORPSW_NULL'));
            }
            //查询用户
            $map['username'] = $userName;
            $userModel = new \app\common\model\User();
            $adminDomain = config('app.admin_domain');
            if (strtolower($adminDomain) == strtolower($domain)) {
                $map['admin_type'] = 1;
                $user = $userModel->where($map)->find();
            }elseif ($this->adminFactory){
                $factoryId = $this->adminFactory['store_id'];
                $sql = 'username = "'.$userName.'"'.' AND admin_type > 1 AND ((admin_type = 2 AND U.store_id = '.$factoryId.') OR (admin_type != 2 AND S.factory_id = '.$factoryId.'))';
                $user = $userModel->alias('U')->join('store S', 'S.store_id = U.store_id', 'INNER')->where($sql)->find();
            }else{
                return $this->error(lang('LOGIN_FORBIDDEN'));
            }
            if(empty($user)){
                return $this->error(lang('USERNOTEXIST'));
            }
            $user = $user->toArray();
            if(!$user['status']){
                return $this->error(lang('LOGIN_FORBIDDEN'));
            }
            if($user['password']<> $userModel->_pwdEncryption($passWord)){
                return $this->error(lang('PSW_ERROR'));
            }
            $result = $this->updateLogin($user,$domain);
            if(!$result['error']){
                return $this->success(lang('LOGIN_SUCCESS'), "/", ['tipmsg'=>'正在登陆...'], 0);
            }else{
                return $this->error($result['msg']);
            }
        }else{
            $this->assign('title',config("setting.title").lang('home_manager'));
            $this->import_resource('base:js/Validform.min.js,base:js/form.js');
            $this->view->engine->layout(false);
            return $this->fetch();
        }
    }
    //页面登出
    public function logout(){
        $userModel = new \app\common\model\User();
        $domain = Request::panDomain();
        $userModel->logout($domain);
        $this->redirect(url('/'));
        //        $this->redirect();
        //        return $this->success(lang('logout_success'), url('/'));
    }
}