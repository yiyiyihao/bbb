<?php
namespace app\admin\controller;
use app\common\controller\AdminBase;
use think\facade\Request;
/**
 * @author chany
 * @date 2018-11-08
 * 后台管理登录操作
 */
class Login extends AdminBase
{
    var $loginIndexTpl = 'index';
    public function index()
    {
        if ($this->adminUser) {
            $this->success('用户已登录', '/');
        }
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
            $adminDomin = config('app.admin_domain');;
            if (strtolower($adminDomin) == strtolower($domain)) {
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
            return $this->fetch($this->loginIndexTpl);
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