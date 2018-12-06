<?php
namespace app\admin\controller;
use think\Request;

//用户分组管理
class Ugroup extends AdminForm
{
    var $storeId;
    public function __construct()
    {
        $this->modelName = 'user_group';
        $this->model = db($this->modelName);
        parent::__construct();
    }
    
    /**
     * 用户组授权
     */
    public function purview(){       
        $params = $this->request->param();
        $pkId   = intval($params['id']);
        //取得当前用户组详情
        $info = parent::_assignInfo($pkId);
        $group = 'factory';
        $groupType = 2;
        if(isset($info['group_type']) && $info['group_type']){
            switch ($info['group_type']){
                case 1:
                    $group      = 'admin';
                    $groupType  = 1;
                break;
                case 2:
                    $group      = 'factory';
                break;
            }
        }
        $menus  = [];
        //获取所有权限及子权限
        $rules  =   model('AuthRule')->getALLRule($group);
        if($pkId){
            if(IS_POST){
                $msg = lang($this->modelName.'_purview');
                //接收提交的权限id
                $rule=$params['rule'];
                //遍历id取出权限信息，保存在$menus中，
                foreach ($rule as $k => $v) {
//                     $menudata=db('AuthRule')->find($v);
//                     $menudata               =   $rules[$v];
                    $menus[$k]['id']        =   $rules[$v]['id'];
                    $menus[$k]['module']    =   $rules[$v]['module'];
                    $menus[$k]['controller']=   $rules[$v]['controller'];
                    $menus[$k]['action']    =   $rules[$v]['action'];
//                     $menus[$k]['rule']=strtolower($menudata['module'].'/'.$menudata['controller'].'/'.$menudata['action']);
//                     $menus[$k]['parent_id']=$menudata['parent_id'];
//                     $menus[$k]['menustatus']=$menudata['menustatus'];
//                     $menus[$k]['title']=$menudata['title'];
//                     $menus[$k]['icon']=$menudata['icon'];
                }            
                //dump($menus);exit;
                //数组转json
                $grouppurview = json_encode($menus);
                $data['menu_json'] = $grouppurview;
                //根据角色id保存数据库
                $pk   =   $this->model->getPk();
                $where[$pk] = $pkId; 
                $rs = $this->model->where($where)->update($data);
                if($rs !== FALSE){
                    $msg .= lang('success');
                    $this->success($msg, url("index"), TRUE);
                }else{
                    $msg .= lang('fail');
                    $this->error($msg);
                }

            }else{
                $rules = $this->_menu($rules,$groupType);
                //所有权限分配模板
                $this->assign('rules', $rules);
                $ruleInfo = $info['menu_json'];
                //有授权
                if($ruleInfo != ''){
                    $ruleInfo = json_decode($ruleInfo,true); 
                    //dump($ruleInfo);exit;
                    //遍历授权字符串取出id回显
                    foreach ($ruleInfo as $k => $v) {
                        $grouppurview[] =   $v['id'];  
                    }
                }else{
                    $grouppurview       =   '';
                }
//                 $grouppurview = 'all';
                //取得当前用户组授权树
                /*$purviewvList = controller("purview","service")->getGroupPurview($info['menu_json']);
                $this->assign('purviewvList', $purviewvList);*/
                $this->assign('grouppurview', $grouppurview);
                return $this->fetch();
            }
        }else{
            $this->error(lang('param_error'));
        }
    }
    
    /**
     * 重组数组分层
     */
    private function _menu($rules = [],$pid){
        $menu = [];
        foreach ($rules as $k=>$v){
            if($v['parent_id'] == $pid){
                $menu[$k] = $v;
                $child = self::_menu($rules,$v['id']);
                if(!empty($child)){
                    $menu[$k]['list'] = $child;
                }
            }
        }
        return $menu;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = parent::_tableData();
        $btnArray = [];
        $btnArray = ['text'  => '授权','action'=> 'purview', 'icon'  => 'setting','bgClass'=> 'bg-yellow'];
        $table['actions']['button'][] = $btnArray;
        $table['actions']['width']  = '210';
        return $table;
    }
    
    function _getWhere(){
        $where = ['is_del' => 0];
        $params = $this->request->param();
        if ($this->adminUser['admin_type'] != ADMIN_SYSTEM) {
            $where['is_system'] = 0;
        }
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['name'] = ['like','%'.$name.'%'];
            }
        }
        return $where;
    }
    function _getData()
    {
        $data = parent::_getData();
        $name = trim($data['name']);
        if (!$name) {
            $this->error('分组名称不能为空');
        }
        $where = ['name' => $name, 'is_del' => 0];
        $params = $this->request->param();
        $pkId = $params && isset($params['id']) ? intval($params['id']) : 0;
        if($pkId){
            $where['group_id'] = ['neq', $pkId];
        }
        $exist = $this->model->where($where)->find();
        if($exist){
            $this->error('当前分组名称已存在');
        }
        $data['name'] = $name;
        $data['menu_json'] = '';
        return $data;
    }
    function del(){
        $params = $this->request->param();
        $pkId = intval($params['id']);
        if ($pkId <= USER) {
            $this->error('系统分组，不允许删除');
        }
        $info = parent::_assignInfo($pkId);
        //判断当前分组下是否存在用户
        $device = db('user')->where(['group_id' => $pkId, 'is_del' => 0])->find();
        if ($device) {
            $this->error('分组下存在用户，不允许删除');
        }
        parent::del();
    }
}
