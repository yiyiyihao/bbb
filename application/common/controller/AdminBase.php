<?php
namespace app\common\controller;
use app\admin\service\Auth;
use app\common\model\AuthRule;
use think\facade\Request;
//登陆后管理内容公共处理
class AdminBase extends Backend
{
    var $subMenu;
    var $adminUser;
    var $adminStore;
    var $adminFactory;//厂商二级域名登录赋值
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
        if(!ADMIN_ID && !in_array(strtolower($controller), ['login'])){
            $this->redirect('/login');
        }else{
            $this->adminUser = session('admin_user');
            //如果有登录
            if ($this->adminUser) {
                $this->adminFactory = $this->adminFactory ? $this->adminFactory : session('admin_factory');
                if ($this->adminUser['store_id']) {
                    $this->adminStore = db('store')->field('store_id, name')->where(['store_id' => $this->adminUser['store_id'], 'is_del' => 0])->find();
                }
                //如果角色0，不验证权限
                if($this->adminUser['group_id']==0){
                    $allrules =model('AuthRule')->getALLRule();
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
                    $allrules=db('user_group')->field('menu_json')->where(['group_id'=>$this->adminUser['group_id'],'is_del' => 0, 'status' => 1])->find();
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
                    $this->error('没有权限','admin/index/home');
                }

            }
        }
                //检查用户是否拥有操作权限
//      if(!self::checkPurview($this->adminUser,$this->storeId)){
//          $this->error("没有操作权限");
//      }
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
        $this->assign('adminStore', $this->adminStore);
        $this->assign('adminFactory', $this->adminFactory);
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