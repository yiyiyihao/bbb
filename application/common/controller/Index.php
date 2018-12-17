<?php
namespace app\common\controller;
use app\common\controller\CommonBase;
use think\facade\Env;
/**
 * @author chany
 * @date 2018-11-08
 */
class Index extends CommonBase
{
    /**
     * 框架首页
     */
    public function index()
    {
        $menuList = $this->getMenu();
//         pre($menuList);
        $this->assign('menuList', $menuList);
        config('app_trace',false);
        return $this->fetch();
    }
    /**
     * 后台首页
     */
    public function home()
    {
        return $this->fetch();
    }
    /**
     * 清理缓存
     */
    public function clearcache()
    {
        if ($this->adminUser['user_id'] != 1) {
            $this->error(lang('NO ACCESS'));
        }
        $runtimePath = Env::get('RUNTIME_PATH');
        if (file_exists($runtimePath)) {
            //删除目录下的所有文件/目录
            del_file_by_dir($runtimePath);
        }
        $this->success('缓存清理成功', url('home'));
    }
    /**
     * 修改资料
     */
    public function profile()
    {
        $userModel = new \app\common\model\User();
        $user = $userModel->checkUser(ADMIN_ID, TRUE);
        if (IS_POST){
            $params = $this->request->param();
            $realname = isset($params['realname']) && $params['realname'] ? trim($params['realname']) : '';
            $phone = isset($params['phone']) && $params['phone'] ? trim($params['phone']) : '';
            if (!$realname) {
                $this->error('真实姓名不能为空');
            }
            if (!$phone) {
                $this->error('联系电话不能为空');
            }
            $result = $userModel->checkFormat($params);
            if ($result === FALSE) {
                $this->error($userModel->error);
            }
            $result = $userModel->save($params, ['user_id' => ADMIN_ID]);
            if ($result === FALSE) {
                $this->error($userModel->error);
            }else{
                $this->success('修改资料成功');
            }
        }else{
            $this->assign('info', $user);
            return $this->fetch();
        }
    }
    /**
     * 修改密码
     */
    public function password()
    {
        $userModel = new \app\common\model\User();
        $user = $userModel->checkUser(ADMIN_ID, FALSE);
        if (IS_POST){
            $params = $this->request->param();
            $password = isset($params['password']) && $params['password'] ? trim($params['password']) : '';
            $newPwd = isset($params['new_pwd']) && $params['new_pwd'] ? trim($params['new_pwd']) : '';
            $rePwd = isset($params['re_pwd']) && $params['re_pwd'] ? trim($params['re_pwd']) : '';
            if (!$password) {
                $this->error('原密码不能为空');
            }
            if (!$newPwd) {
                $this->error('新密码不能为空');
            }
            if (!$rePwd) {
                $this->error('确认密码不能为空');
            }
            if ($password == $newPwd) {
                $this->error('新密码不能与原密码一致');
            }
            if ($newPwd != $rePwd) {
                $this->error('新密码与确认密码不一致');
            }
            $result = $userModel->checkFormat(['password' => $newPwd]);
            if ($result === FALSE) {
                $this->error($userModel->error);
            }
            //判断原密码是否正确
            if ($user['password'] <> $userModel->pwdEncryption($password)) {
                $this->error('原登录密码验证错误');
            }
            $result = $userModel->save(['password' => $userModel->pwdEncryption($newPwd), 'update_time' => time()], ['user_id' => ADMIN_ID]);
            if ($result === FALSE) {
                $this->error($userModel->error);
            }else{
                $this->success('修改密码成功');
            }
        }else{
            $this->assign('info', $user);
            return $this->fetch();
        }
    }    
}
