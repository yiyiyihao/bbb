<?php
namespace app\common\controller;
use think\facade\Request;
use app\common\model\User;
use think\Session;
use app\common\model\AuthRule;
//公共处理
class CommonBase extends Base
{
    var $subMenu;
    var $adminUser;
    var $adminStore;
    var $adminFactory;//厂商二级域名登录赋值
    var $breadCrumb;
	//公共预处理方法
	public function __construct()
    {
    	parent::__construct();
    	$domain = Request::panDomain();
    	$adminDomain = config('app.admin_domain');
    	$systemKeepsDomains = config('app.system_keeps_domain');
    	if($domain == $adminDomain){
    	    $this->initAdmin($domain);
    	}elseif (!$domain || in_array($domain, $systemKeepsDomains)){
    	    return ;
    	}else{
    	    $this->initFactory($domain);
    	}
    	//检查管理员是否登陆
    	defined('ADMIN_ID') or define('ADMIN_ID', $this->isLogin($domain));
    	$controller = $this->request->controller();
    	if(!ADMIN_ID && !in_array(strtolower($controller), ['login'])){
    	    $this->redirect('/login');
    	}else{
    	    //公共登录鉴权处理
    	    $this->commonInit($domain);
    	}
    	if (ADMIN_ID) {
    	    $this->actionLog();
    	}
    }
    //公共登录处理初始化
    protected function commonInit($domain){
        $this->adminUser = session($domain.'_user');
        $factoryRoom     = $this->adminUser['factory_id'] ? $this->adminUser['factory_id'] : 0;
        $storeType       = $this->adminUser['store_type'] ? $this->adminUser['store_type'] : 'admin';
        $storeRoom       = $this->adminUser['store_id'] ? $this->adminUser['store_id'] : 0;
        $loginData = array(
            'type'          => 'login',
            'id'            => md5($this->adminUser['user_id']),
            'factoryRoom'   => 'factory'.$factoryRoom,  //各厂商下级分组
            'storeType'     => $storeType,              //各角色大类型分组
            'storeRoom'     => 'store'.$storeRoom,      //各角色子用户分组
        );
        $this->assign('loginData',json_encode($loginData));
        //判断用户是否需要强制修改初始密码
        $controller = strtolower($this->request->controller());
        if (isset($this->adminUser['pwd_modify']) && $this->adminUser['pwd_modify']> 0 && !in_array($controller, ['index', 'login'])) {
            $this->redirect(url('index/password'));
        }
        //是超级管理员,不验证操作权限
        if($this->adminUser['user_id']!==1){
            //普通用户 //从登陆信息中取出权限配置
            $groupPurview = $this->adminUser['groupPurview'];
            //json转数组
            $groupPurview   = $groupPurview ? json_decode($groupPurview,true) : [];
            if ($this->adminUser && ($this->adminUser['admin_type'] == 0 && $this->adminUser['store_id'] == 0) || ($this->adminStore && $this->adminStore['check_status'] != 1)) {
                $flag = (strtolower($this->request->controller()) == 'apply') || !(!($controller == 'login') && !($controller == 'upload') && !($controller == 'region'));
                if (!$flag) {
                    $storeId = $this->adminUser['store_id'];
                    if ($storeId > 0) {
                        $adminStore = db('store')->field('store_id, name, factory_id, store_type, store_no, check_status, status')->where(['store_id' => $storeId, 'is_del' => 0])->find();
                        if ($adminStore['check_status'] == 1) {
                            //重新执行登录
                            $this->updateLogin($this->adminUser['user_id'], $this->adminFactory['domain']);
                            $flag = TRUE;
                        }
                    }
                    if (!$flag) {
                        $this->redirect(url('apply/index'));
                    }
                }else{
                    $groupPurview = [['module' => 'factory', 'controller' => 'apply', 'action' => 'index']];
                }
            }
            if(!empty($groupPurview)){
                $authService    = new \app\admin\service\Auth();
                $return         = $authService->check($this->request,$groupPurview);
                if(!$return){
                    $this->error(lang('PERMISSION_DENIED'));
                }
            }else{
                $controller     = strtolower($this->request->controller());
                if($controller != 'login'){
                    $this->error(lang('NO_GROUP'));
                }
            }
        }
        //初始化页面赋值
        $this->initAssign();
    }    
    
    //平台管理后台初始化流程
    protected function initAdmin($domain){
        
    }
    
    //厂商管理后台初始化流程
    protected function initFactory($domain){
        $this->adminFactory = $this->adminFactory ? $this->adminFactory : session('admin_factory');
        if (!$this->adminFactory) {
            $factory = db('store_factory')->alias('SF')->join('store S', 'S.store_id = SF.store_id', 'INNER')->where(['domain' => trim($domain), 'S.is_del' => 0])->find();
            $this->adminFactory = $factory;
            session('admin_factory', $factory);
        }
        $this->adminStore = $this->adminStore ? $this->adminStore : session('admin_store');
    }
    
    //页面初始化赋值
    protected function initAssign() {
        $server = isset($_SERVER['REDIRECT_URL']) ? $_SERVER['REDIRECT_URL'] : $_SERVER['REQUEST_URI'];
        $self = strip_tags($server);
        $this->assign('self', $self);
        $this->assign('title', '【'.get_store_type($this->adminUser['store_type']).'】 '.lang('home_manager'));
        $this->assign('adminUser', $this->adminUser);
        $this->assign('adminStore', $this->adminStore);
        $this->assign('adminFactory', $this->adminFactory);
    }    
    
    /**
     * 取得管理员菜单
     */
    protected function getMenu(){
        $domain = Request::panDomain();
        $menuList = array();
        $menuService = new \app\admin\service\Menu;
        $menuList = $menuService->getAdminMenu($this->adminUser, $domain);
        $menuList = array_order($menuList, 'sort_order', 'asc', true);
        return $menuList;
    }
    
    /**
     * 初始化表单页面二级菜单
     */
    protected function initSubMenu($adminUser = []){
        if($adminUser['user_id'] == 1) return;
        if(empty($adminUser['groupPurview'])) $this->error(lang('NO_GROUP'));
        $groupPurview = $adminUser['groupPurview'];
        $purviewList = json_decode($groupPurview,1);
        $subMenu = $this->subMenu;
        $module             = strtolower($this->request->module());
        $controller         = strtolower($this->request->controller());
        $action             = strtolower($this->request->action());
        foreach ($subMenu['menu'] as $k=>$menu){
            $flag = false;
            $tempStr = url($module.$menu['url']);
            foreach ($purviewList as $key=>$v){
                $pstr = url($v['module'].'/'.$v['controller'].'/'.$v['action']);
//                 if($pstr == $tempStr){//之前严格校验操作权限
                if(strpos($tempStr,$pstr) !== false){//现改成包含校验,可能会有问题,后续优化 @chany 2018-12-20
                    $flag = true;
                }
                if($flag) continue;
            }
            if(!$flag){
                unset($subMenu['menu'][$k]);
            }
        }
        if(isset($subMenu['add']['url'])){
            $tempStr = url($module.$subMenu['add']['url']);
            $flag = false;
            foreach ($purviewList as $key=>$v){
                $pstr = url($v['module'].'/'.$v['controller'].'/'.$v['action']);
                if($pstr == $tempStr){
                    $flag = true;
                }
                if($flag) continue;
            }
            if(!$flag){
                unset($subMenu['add']);
            }
        }elseif (isset($subMenu['add']) && $subMenu['add']){
            foreach ($subMenu['add'] as $k=>$add){
                $flag = false;
                $tempStr = url($module.$add['url']);
                foreach ($purviewList as $key=>$v){
                    $pstr = url($v['module'].'/'.$v['controller'].'/'.$v['action']);
                    if($pstr == $tempStr){
                        $flag = true;
                    }
                    if($flag) continue;
                }
                if(!$flag){
                    unset($subMenu['add'][$k]);
                }
            }
        }
        $this->subMenu = $subMenu;
//         pre($this->subMenu);
    }
    
    /**
     * 检测用户是否登录
     * @return int 用户ID
     */
    protected function isLogin($domain){
        if(session($domain.'_user')){
            $user = session($domain.'_user');
            return $user['user_id'];
        }else{
            return false;
        }
    }
    /**
     * 更新用户信息
     */
    protected function updateLogin($userInfo = FALSE, $domain = 'admin'){
        defined('ADMIN_ID') or define('ADMIN_ID', $this->isLogin());
        $userMod = new User();
        $result = $userMod->setLogin($userInfo,ADMIN_ID,$domain);
        if ($result === false) {
            return [
                'error' => 1,
                'msg' => $userMod->error,
            ];
        }
        $this->actionLog('登录后台', $userInfo);
        return [
            'error' => 0,
        ];;
    }
    /**
     * 后台管理员登录操作日志记录
     * @param string $content
     * @param array $user
     */
    protected function actionLog($title = '', $user = [])
    {
        $request = $this->request;
        $action = strtolower($request->action());
        $title = $title ? $title : lang($action);
        $user = $user ? $user : $this->adminUser;
        $controller = strtolower($request->controller());
        if ($controller == 'index' && $action == 'index') {
            $title = '后台首页';
        }
        $params = $request->param();
        $name = $user ? (trim($user['realname'] ? $user['realname'] : ($user['nickname'] ? $user['nickname'] : $user['username']))) : '';
        $data = [
            'user_id'   => ADMIN_ID,
            'user_name'      => $name,
            'admin_type'=> $user ? $user['admin_type'] : 0,
            'store_id'  => $user ? $user['store_id'] : 0,
            'module'    => strtolower($request->module()),
            'controller'=> $controller,
            'action'    => $action,
            'url'       => $request->host().$request->url(),
            'add_time'  => time(),
            
            'request_method' => $request->method(),
            'request_params' => $params ? json_encode($params) : '',
            
            'title' => $title,
        ];
        db('apilog_action')->insertGetId($data);
    }
    
    //获取页面的面包屑
    protected function bread(){
        //获取当前controller
        $module             = strtolower($this->request->module());
        $controller         = strtolower($this->request->controller());
        $action             = strtolower($this->request->action());
        $domain             = Request::panDomain();
        $authRule           = AuthRule::getALLRule($domain);
//         pre($authRule);
        //检查是否有上级操作节点
        //检查是否有上一页来源
        $listCrumb      = ['name'  => lang('index'),'url'   => url('index')];
        $activeCrumb    = ['name'  => lang($action),'url'   => ''];
        foreach ($authRule as $k=>$v){
            if($v['module'] == $module && $v['controller'] == $controller && $v['action'] == 'index'){
                $listCrumb['name'] = $v['title'];
            }
            if($v['module'] == $module && $v['controller'] == $controller && empty($v['action'])){
                $listCrumb['name'] = $v['title'];
            }
            if($v['module'] == $module && $v['controller'] == $controller && $v['action'] == $action){
                $activeCrumb['name'] = $v['title'];
                if($v['parent_id'] > 0){
                    $parentInfo = $authRule[$v['parent_id']];
                    $listCrumb['name']  = $parentInfo['title'];
                    if(!$parentInfo['controller']){
                        $listCrumb['url']   = '';
                    }
                }
            }
        }
        $this->breadCrumb[] = $listCrumb;
        $this->breadCrumb[] = $activeCrumb;
        return $this->breadCrumb;
    }
    
    //渲染输出
    protected function fetch($template = '', $vars = [], $replace = [], $config = []) {
        //获取当前页二级菜单
        if(!empty($this->subMenu)) $this->initSubMenu($this->adminUser);
        $subMenu = $this->subMenu;
        $this->assign('subMenu',$subMenu);
        //获取当前页面的面包屑
        $breadCrumb = $this->bread();
        $this->assign('breadCrumb',$breadCrumb);
        return parent::fetch($template, $vars, $replace, $config);
    }
    protected function _getFactorys()
    {
        //获取所属厂商列表
        $stores = db('store')->where(['is_del' => 0, 'status' => 1, 'store_type' => 1])->field('store_id as id, name as cname')->select();
        $this->assign('factorys', $stores);
    }
}