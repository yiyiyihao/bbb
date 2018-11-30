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
    	//检查管理员是否登陆
    	defined('ADMIN_ID') or define('ADMIN_ID', $this->isLogin($domain));
    	$controller = $this->request->controller();
    	if(!ADMIN_ID && !in_array(strtolower($controller), ['login'])){
    	    $this->redirect('/login');
    	}else{
        	if($domain == $adminDomain){
        	    $this->initAdmin($domain);
        	}else{
        	    $this->initFactory($domain);
        	}
    	    //公共登录鉴权处理
    	    $this->commonInit($domain);
    	}
    }
    //公共登录处理初始化
    protected function commonInit($domain){
        $this->adminUser = session($domain.'_user');
        //如果有登录
        if ($this->adminUser) {
            //如果角色0，不验证权限
            if($this->adminUser['group_id']==0){
                $allrules = model('AuthRule')->getALLRule();
                foreach ($allrules as $k => $v) {
                    if($v['menustatus']==1){
                        $menus[$k]['id']=$v['id'];
                        $menus[$k]['module']=strtolower($v['module']);
                        $menus[$k]['controller']=strtolower($v['controller']);
                        $menus[$k]['action']=strtolower($v['action']);
                        $menus[$k]['parent_id']=$v['parent_id'];
                        $menus[$k]['menustatus']=$v['menustatus'];
                        $menus[$k]['title']=$v['title'];
                    }
                    $this->adminUser['rule'][]=strtolower($v['module'].'/'.$v['controller'].'/'.$v['action']);
                }
                //$menus[]=['rule'=>'admin/login/index','title'=>'用户登录','parent_id'=>0];
                $this->adminUser['rule'][]='admin/index/index';
                $this->adminUser['rule'][]='admin/login/index';
                $this->adminUser['rule'][]='admin/login/logout';
                $this->adminUser['rule'][]='admin/gcate/';
            }else{
                //普通用户
                //根据用户角色id查询menu_json，
                $allrules = db('user_group')->field('menu_json')->where(['group_id'=>$this->adminUser['group_id'],'is_del' => 0, 'status' => 1])->find();
                if(!$allrules['menu_json']){
                    session('admin_user',NULL);
                    $this->error('未分配角色','login');
                }
                //json转数组
                $allrules= $allrules['menu_json'] ? json_decode($allrules['menu_json'],true) : [];
                //遍历取出可显示的
                foreach ($allrules as $k => $v) {
                    $this->adminUser['rule'][]=$v['rule'];
                    if($v['menustatus']==1){
                        $menus[$k]=$v;
                        $rule=explode('/',$v['rule']);
                        $menus[$k]['module']=strtolower($rule[0]);
                        $menus[$k]['controller']=strtolower($rule[1]);
                        $menus[$k]['action']=strtolower($rule[2]);
                    }
                }
                $this->adminUser['rule'][]='admin/index/index';
                $this->adminUser['rule'][]='admin/login/index';
                $this->adminUser['rule'][]='admin/login/logout';
            }
            $this->adminUser['menus']=$menus;
            //pre($this->adminUser);
            if ($this->adminUser['store_id']) {
                
                $this->adminStore = db('store')->field('store_id, name')->where(['store_id' => $this->adminUser['store_id'], 'is_del' => 0])->find();
            }
            $action = strtolower($this->request->module().'/'.$this->request->controller().'/'.$this->request->action());
            
            //dump($action);dump($this->adminUser);exit;
            if(!in_array($action,$this->adminUser['rule'])){
                //                     $this->error('没有权限','admin/index/home');
            }
            //初始化页面赋值
            $this->initAssign();
        }
    }    
    
    //平台管理后台初始化流程
    protected function initAdmin($domain){
        
    }
    
    //厂商管理后台初始化流程
    protected function initFactory($domain){
        $this->adminFactory = $this->adminFactory ? $this->adminFactory : session('admin_factory');
        $this->adminStore = $this->adminStore ? $this->adminStore : session('admin_store');
    }
    
    //页面初始化赋值
    protected function initAssign() {
        $server = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : $_SERVER['REQUEST_URI'];
        $self = strip_tags($server);
        $this->assign('self', $self);
        $this->assign('title',config('setting.title').lang('home_manager'));
        $this->assign('adminUser', $this->adminUser);
        $this->assign('adminStore', $this->adminStore);
        $this->assign('adminFactory', $this->adminFactory);
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
        $menuService = new \app\admin\service\Menu;
        $menuList = $menuService->getAdminMenu();
        $menuList = array_order($menuList, 'sort_order', 'asc', true);
        return $menuList;
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
        return [
            'error' => 0,
        ];;
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
    protected function _getFactorys()
    {
        //获取所属厂商列表
        $stores = db('store')->where(['is_del' => 0, 'status' => 1, 'store_type' => 1])->field('store_id as id, name as cname')->select();
        $this->assign('factorys', $stores);
    }
}