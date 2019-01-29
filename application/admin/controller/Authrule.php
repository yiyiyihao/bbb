<?php
namespace app\admin\controller;

//平台权限节点管理
class Authrule extends AdminForm
{
    public function __construct()
    {
        $this->modelName = 'auth_rule';
        $this->model = db('auth_rule');
        parent::__construct();
        if ($this->adminUser['user_id'] != 1) {
            $this->error(lang('NO ACCESS'));
        }
//         $this->perPage = 150;
    }
        
    public function grant()
    {
        $params = $this->request->param();
        $adminType = isset($params['type']) ? $params['type'] : 2;
        if (IS_POST){
            
        }else{
//             $this->assign('', );
            return $this->fetch();
        }
    }
    
    function _afterList($list)
    {
        parent::_afterList($list);
        foreach ($list as $k=>$v){
//             $module     = (!empty($v['module']) && $v['module'] != 'admin') ? '/'.$v['module'] : '';
            $module = '';
            $controller = !empty($v['controller']) ? '/'.$v['controller'] : '';
            $action     = !empty($v['action']) ? '/'.$v['action'] : '';
            $list[$k]['href'] = $module.$controller.$action;
        }
        /* if ($list) {
            $treeService = new \app\common\service\RuleTree();
            $list = $treeService->getTree($list);
        } */
        return $list;
    }
    
    function _assignInfo($id = 0){
        $info = parent::_assignInfo($id);
        if(!IS_POST){
            $this->_ruleList();
        }
        return $info;
    }
    
    function _getWhere()
    {
        $where  = parent::_getWhere();
        $params = $this->request->param();
        $pid    = 0;
        if(isset($params['pid'])) {
            $pid = $params['pid'];
        }
        $where[] = ['parent_id', '=', $pid];
        return $where;
    }
    
    function _getOrder()
    {
        return 'sort_order ASC, parent_id ASC';
    }
    
    function _tableData(){
        $table = parent::_tableData();
        $btnArray = [
            ['text'  => '下级菜单', 'action'=> 'index','icon'  => 'list','bgClass'=> 'bg-green','param'=> ['pid'=>'id']],
        ];
        $table['actions']['button'] = array_merge($table['actions']['button'],$btnArray);
        $table['actions']['width']  = '240';
        return $table;
    }
    
    private function _ruleList(){
        //取得现有的权限树形图
        $treeService = new \app\common\service\RuleTree();
        $where = ['is_del' => 0];
        $rule = $this->model->field("*")->where($where)->order("sort_order ASC,parent_id")->select();
        if ($rule) {
            $rule = $treeService->getTree($rule);
        }
        $this->assign('rulelist', $rule);
    }
}