<?php
namespace app\common\controller;
use app\common\controller\CommonBase;
use think\facade\Env;
use think\facade\Request;
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
//         pre($this->adminStore);
        if ($this->adminUser['store_id']) {
            $storeModel = new \app\common\model\Store();
            $store = $storeModel->getStoreDetail($this->adminUser['store_id']);
            if ($store === FALSE) {
                $this->error($storeModel->error);
            }
            $types = [
                STORE_DEALER => [
                    'name' => '零售商',
                ],
                STORE_CHANNEL => [
                    'name' => '渠道商',
                ],
                STORE_SERVICE => [
                    'name' => '服务商',
                ],
            ];
            $this->assign('name', $types[$store['store_type']]['name']);
            $this->assign('info', $store);
        }
        if (IS_POST){
            $params = $this->request->param();
            //商户审核未通过可以修改现有商户信息
            if ($this->adminUser['store_id'] && $store && $store['check_status'] != 1) {
                $name = $params && isset($params['name']) ? trim($params['name']) : '';
                $userName = $params && isset($params['user_name']) ? trim($params['user_name']) : '';
                $where = ['name' => $name, 'is_del' => 0, 'store_id' => ['<>', $this->adminUser['store_id']], 'factory_id' => $this->adminUser['factory_id'], 'store_type' => $store['store_type']];
                $exist = $storeModel->where($where)->find();
                if($exist){
                    $this->error('当前'.$types[$store['store_type']]['name'].'名称已存在');
                }
            }
            $realname = isset($params['realname']) && $params['realname'] ? trim($params['realname']) : '';
            $phone = isset($params['phone']) && $params['phone'] ? trim($params['phone']) : '';
            if (!$realname) {
                $this->error('真实姓名不能为空');
            }
            if (!$user['phone']) {
                if (!$phone) {
                    $this->error('联系电话不能为空');
                }
            }else{
                unset($params['phone']);
            }
            
            $params['user_id'] = $user['user_id'];
            $result = $userModel->checkFormat($this->adminUser['factory_id'], $params);
            if ($result === FALSE) {
                $this->error($userModel->error);
            }
            $result = $userModel->save($params, ['user_id' => ADMIN_ID]);
            if ($result === FALSE) {
                $this->error($userModel->error);
            }else{
                if ($this->adminUser['store_id'] && $store && $store['check_status'] != 1) {
                    if ($store['check_status'] == 2) {
                        $params['check_status'] = 0;
                        $this->adminStore['check_status'] = intval($params['check_status']);
                    }
                    $this->adminStore['name'] = trim($params['name']);
                    $params['store_type'] = $store['store_type'];
                    $result = $storeModel->save($params, ['store_id' => $this->adminUser['store_id']]);
                    session('admin_store', $this->adminStore);
                }
                if (isset($this->adminUser['realname'])) {
                    $flag = FALSE;
                    if ($realname != $this->adminUser['realname']) {
                        $flag = TRUE;
                        $this->adminUser['realname'] = $realname;
                    }
                    if ($phone != $this->adminUser['phone']) {
                        $flag = TRUE;
                        $this->adminUser['phone'] = $phone;
                    }
                    if ($flag) {
                        //更新缓存信息
                        $domain = Request::panDomain();
                        $userModel->setSession($domain, $this->adminUser);
                    }
                }
                $this->success('修改资料成功');
            }
        }else{
            $this->assign('user', $user);
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
            $result = $userModel->checkFormat($this->adminUser['factory_id'], ['password' => $newPwd]);
            if ($result === FALSE) {
                $this->error($userModel->error);
            }
            //判断原密码是否正确
            if ($user['password'] <> $userModel->pwdEncryption($password)) {
                $this->error('原登录密码验证错误');
            }
            $data = ['password' => $userModel->pwdEncryption($newPwd)];
            if ($user['pwd_modify'] > 0) {
                $data['pwd_modify'] = 0;
            }
            $result = $userModel->save($data, ['user_id' => ADMIN_ID]);
            if ($result === FALSE) {
                $this->error($userModel->error);
            }else{
                if ($user['pwd_modify'] > 0) {
                    //更新session
                    $domain = Request::panDomain();
                    $this->adminUser['pwd_modify'] = 0;
                    $userModel->setSession($domain, $this->adminUser);
                }
                $this->success('修改密码成功');
            }
        }else{
            $this->assign('info', $user);
            return $this->fetch();
        }
    }
}
