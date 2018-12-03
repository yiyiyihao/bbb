<?php
namespace app\admin\service;
use app\common\model\AuthRule;
/**
 * 后台菜单接口
 */
class Menu{
    var $authRule;
    /**
     * 获取菜单结构
     */
    public function getAdminMenu($user = [],$domain = 'admin'){
        $authRule = AuthRule::getRuleList($domain);//这里只取出在允许在菜单中显示的数据
        foreach ($authRule as $k=>$v){
//             $module     = (!empty($v['module']) && $v['module'] != 'admin') ? '/'.$v['module'] : '';
            $module = '';
            $controller = !empty($v['controller']) ? '/'.$v['controller'] : '';
            $action     = !empty($v['action']) ? '/'.$v['action'] : '';
            $authRule[$k]['href'] = $module.$controller.$action;
        }
        $this->authRule = $authRule;
        if(isset($user['groupPurview'])){
            $groupPurview = $user['groupPurview'];
            if(!empty($groupPurview)){
                $groupPurview = json_decode($groupPurview,true);
                $tempRule = [];
                foreach ($groupPurview as $k=>$v){
                    if(isset($authRule[$v['id']])){
                        $tempRule[$v['id']] = $authRule[$v['id']];
                    }
                }
                $this->authRule = $tempRule;
            }
        }
        $pid = ($domain == 'admin') ? 1 : 2;
        $adminMenu = self::_menu($pid);
        return $adminMenu;
    }
    
    /**
     * 重组数组分层
     */
    private function _menu($pid){
        $menu = [];
        foreach ($this->authRule as $k=>$v){
            if($v['parent_id'] == $pid){
                $menu[$k] = $v;
                $child = self::_menu($v['id']);
                if(!empty($child)){
                    $menu[$k]['list'] = $child;
                }
            }
        }
        return $menu;
    }
}