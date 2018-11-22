<?php
namespace app\admin\controller;
use app\common\controller\AdminBase;
/**
 * @author chany
 * @date 2018-11-08
 */
class Index extends AdminBase
{
    /**
     * 框架首页
     */
    public function index()
    {
        $menuList = $this->getMenu($this->adminUser);
        $this->assign('menuList', $menuList);
        config('app_trace',false);
        return $this->fetch();
    }
    /**
     * 后台首页
     */
    public function home()
    {
//         $this->assign('weekData',$weekData);
        return $this->fetch();
    }
    /**
     * 修改资料
     */
    public function profile()
    {
        $userModel = new \app\common\model\User();
        $user = $userModel->_checkUser(ADMIN_ID, TRUE);
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
            $result = $userModel->_checkFormat($params);
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
        $user = $userModel->_checkUser(ADMIN_ID, FALSE);
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
            $result = $userModel->_checkFormat(['password' => $newPwd]);
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
    
    /**
     * 取得管理员菜单
     */
    protected function getMenu($loginUserInfo = array(),$cutUrl = '',$urlComplete = true){
        $loginUserInfo['action_purview'] = 'all';
        if(!empty($loginUserInfo)){
            if($loginUserInfo['action_purview'] != 'all'){
                $menuPurview = unserialize($loginUserInfo['action_purview']);
            }else{
                $menuPurview = FALSE;
            }
        }
        if (ADMIN_ID == 1) {
            $method = 'getAdminMenu';
        }else{
            switch ($loginUserInfo['store_type']) {
                case 1://厂商
                    $method = 'getFactoryMenu';
                    break;
                case 2://渠道商
                    $method = 'getChannelMenu';
                    break;
                case 3://经销商
                    $method = 'getDealerMenu';
                    break;
                case 4://服务商
                    $method = 'getServiceMenu';
                    break;
                default:
                    $this->error(lang('NO ACCESS'));
                    break;
            }
        }
        $menuList = array();
        $menuService = new \app\admin\service\Menu();
        $menuList = $menuService->$method();
        /* $menuList = controller("menu", "service")->getAdminMenu(); */
        if ($menuPurview) {
            foreach ($menuList as $key => $value) {
                if ($value && $value['menu']) {
                    foreach ($value['menu'] as $menuKey => $vo) {
                        if (!$vo ) {
                            break;
                        }
                        $url = $vo['url'];
                        $temp = explode('/', $url);
                        $count = count($temp);
                        $tempKey = $temp[2].'_'.$temp[3];
                        if (in_array($tempKey, $menuPurview)) {
                            $menu[$key]['name'] = $value['name'];
                            $menu[$key]['icon'] = $value['icon'];
                            $menu[$key]['order'] = $value['order'];
                            $menu[$key]['menu'][$menuKey] = $vo;
                        }
                    }
                }
            }
        }else{
            $menu = $menuList;
        }
        $menuList = array_order($menu, 'order', 'asc', true);
        session('admin_menu',$menuList);
        return $menuList;
    }
}
