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
    public function getAdminMenu($type = 1){
        $authRule = AuthRule::getRuleList();
        foreach ($authRule as $k=>$v){
//             $module     = (!empty($v['module']) && $v['module'] != 'admin') ? '/'.$v['module'] : '';
            $module = '';
            $controller = !empty($v['controller']) ? '/'.$v['controller'] : '';
            $action     = !empty($v['action']) ? '/'.$v['action'] : '';
            $authRule[$k]['href'] = $module.$controller.$action;
        }
        $this->authRule = $authRule;
        $adminMenu = self::_menu(0);
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