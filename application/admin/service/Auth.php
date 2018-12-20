<?php
/**
 * 权限认证类
 */
namespace app\admin\service;

class Auth{

    //默认配置
    protected $_config = [
        'AUTH_ON'           => true,                // 认证开关
    ];
    protected $_common = [];

    public function __construct() {
        $this->_common = [
            [
                'module'        => 'factory',
                'controller'    => 'upload',
                'action'        => '*',
            ]
        ];
    }
    
    /**
     * 验证操作权限
     */
    public function check($request,$groupPurview = []){
        //获取用户需要验证的所有有效规则列表
        $commonPurview      = $this->_common;//获取默认权限
        $authList           = array_merge($groupPurview,$commonPurview);
        $module             = strtolower($request->module());
        $controller         = strtolower($request->controller());
        $action             = strtolower($request->action());
        foreach ($authList as $k=>$v){
            $key = $v['module'];
            if($v['controller']) $key .= '_'.$v['controller'];
            $v['action']    = empty($v['action']) ? 'index' : $v['action'];
            if($v['action'])     $key .= '_'.$v['action'];
            $tempRule[$key] = $v;
        }
        $tempAction = $module . '_' . $controller . '_' . $action;
        $tempAllAction = $module . '_' . $controller . '_*';//兼容配置所有权限授权点
        if(!isset($tempRule[$tempAction]) && !isset($tempRule[$tempAllAction]) && $action != 'logout' && $action != 'upload' && !IS_AJAX){
            return false;
        }else{
            return true;
        }
    }

    /**
     * 检查权限
     * @param name string|array  需要验证的规则列表,支持逗号分隔的权限规则或索引数组
     * @param purview  string|array     认证用户的组权限
     * @param relation string    如果为 'or' 表示满足任一条规则即通过验证;如果为 'and'则表示需满足所有规则才能通过验证
     * @return boolean           通过验证返回true;失败返回false
     */
    public function check_old($name, $purview, $type=1, $relation='or') {
        //获取用户需要验证的所有有效规则列表
        $authList = $purview;
        if (is_string($name)) {
            $name = strtolower($name);
            if (strpos($name, ',') !== false) {
                $name = explode(',', $name);
            } else {
                $name = array($name);
            }
        }
        if (is_array($name)) {
//             $module     = strtolower($name['module']);
            $controller = strtolower($name['controller']);
            $action     = strtolower($name['action']);
            $name       = [];
//             $name[]     = $module.'_*';
            $name[]     = $controller.'_*';
            $name[]     = $controller.'_'.$action;
        }
        $list = array(); //保存验证通过的规则名
        if ($authList) {
            foreach ( $authList as $auth ) {
                if (in_array($auth , $name)){
                    $list[] = $auth ;
                }
            }
        }
        
        if ($relation == 'or' and !empty($list)) {
            return true;
        }
        return false;
    }
}
