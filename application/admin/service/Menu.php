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
    public function getAdminMenu($user = [],$domain = ''){
        $domain = !empty($domain) ? $domain : config('app.admin_domain');
        $authRule = AuthRule::getRuleList($domain);//这里只取出在允许在菜单中显示的数据
        foreach ($authRule as $k=>$v){
//             $module     = (!empty($v['module']) && $v['module'] != 'admin') ? '/'.$v['module'] : '';
            $module = '';
            $controller = !empty($v['controller']) ? '/'.$v['controller'] : '';
            $action     = !empty($v['action']) ? '/'.$v['action'] : '';
            $authRule[$k]['href'] = url($module.$controller.$action);
        }
        $this->authRule = $authRule;
        if(isset($user['group_id']) && $user['group_id'] > 0){
            $groupPurview = getGroupPurview($user['group_id']);
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
        $adminDomain = config('app.admin_domain');   
        $pid = ($domain == $adminDomain) ? 1 : 2;
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