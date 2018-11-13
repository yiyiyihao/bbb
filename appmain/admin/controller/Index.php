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
        //获取菜单
        $userInfo = session('admin_user');
        $menuList = $this->getMenu($userInfo);
        if (ADMIN_ID != 1) {
            unset($menuList['index']['menu']['analysis']['list']['api'], $menuList['content']['menu']['order']['list']['payment'], $menuList['user']['menu']['user']['list']['group']);
            unset($menuList['index']['menu']['analysis']['list']['win']);
        }
//         pre($menuList);
//         $menuList = json_encode($menuList);
        $this->assign('user',$userInfo);
        $this->assign('menuList',$menuList);
        return $this->fetch();
    }
    /**
     * 后台默认数据汇总页
     */
    public function home()
    {
        return $this->fetch();
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
        $menuList = array();
        $menuList = controller("menu","service")->getAdminMenu();
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
