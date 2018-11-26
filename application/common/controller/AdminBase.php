<?php
namespace app\common\controller;
use app\admin\service\Auth;
use app\common\model\AuthRule;
//登陆后管理内容公共处理
class AdminBase extends Backend
{
    var $subMenu;
    var $storeId;
    var $factory;
    var $adminUser;
    var $breadCrumb;
	//管理内容预处理方法
	public function __construct()
    {
    	parent::__construct();
    	//后台管理初始化操作
    	$this->init();
    }
    
    //后台管理预处理机制
    private function init() {
    	//检查管理员是否登陆
    	defined('ADMIN_ID') or define('ADMIN_ID', $this->isLogin());
    	$controller = $this->request->controller();
    	if(!ADMIN_ID && !in_array(strtolower($controller), ['login','apilog'])){
    		$this->redirect('/login');
    	}
    	$this->adminUser = session('admin_user');
    	//检查用户是否拥有操作权限
    	$this->storeId = isset($this->adminUser['store_id']) && $this->adminUser['store_id'] ? $this->adminUser['store_id'] : 0;
    	$this->factory = isset($this->adminUser['factory']) && $this->adminUser['factory'] ? $this->adminUser['factory'] : 0;
//     	if(!self::checkPurview($this->adminUser,$this->storeId)){
//     	    $this->error("没有操作权限");
//     	}
    	//初始化页面赋值
    	$this->initAssign();
    }
    
    //检查用户是否拥有操作权限
    private function checkPurview($user = [],$storeid = FALSE){
        if(ADMIN_ID == 1 || $user['groupPurview'] == 'all'){
            return true;
        }
        $auth = new Auth();
        $checkName = [
            'module'        =>  $this->request->module(),
            'controller'    =>  $this->request->controller(),
            'action'        =>  $this->request->action(),
        ];
        return $auth->check($checkName,json_decode($user['groupPurview'],true));
    }
    
    //页面初始化赋值
    protected function initAssign() {
        $server = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : $_SERVER['REQUEST_URI'];
        $self = strip_tags($server);
        $this->assign('self', $self);
        $this->assign('title',config('setting.title').lang('home_manager'));
        $this->assign('adminUser', $this->adminUser);
    }
    
    //获取页面的面包屑
    protected function bread(){
        //获取当前controller
        $module             = strtolower($this->request->module());
        $controller         = strtolower($this->request->controller());
        $action             = strtolower($this->request->action());
        $authRule       = AuthRule::getRuleList();        
        $listCrumb      = ['name'  => lang('index'),'url'   => url('index')];
        $activeCrumb    = ['name'  => lang($action),'url'   => ''];
        foreach ($authRule as $k=>$v){
            if($v['module'] == $module && $v['controller'] == $controller && empty($v['action'])){
                $listCrumb['name'] = $v['title'];
            }
            if($v['module'] == $module && $v['controller'] == $controller && $v['action'] == $action){
                $activeCrumb['name'] = $v['title'];
            }
        }
        $this->breadCrumb[] = $listCrumb;
        $this->breadCrumb[] = $activeCrumb;
        return $this->breadCrumb;
    }
    
    //渲染输出
    protected function fetch($template = '', $vars = [], $replace = [], $config = []) {
        //获取当前页二级菜单
        $subMenu = $this->subMenu;
        $this->assign('subMenu',$subMenu);
        //获取当前页面的面包屑        
        $breadCrumb = $this->bread();
        $this->assign('breadCrumb',$breadCrumb);
        return parent::fetch($template, $vars, $replace, $config);
    }
}