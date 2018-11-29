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
        $this->table = self::_tableData();
        $this->field = self::_fieldData();
        $this->perPage = 100;
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
            $module     = (!empty($v['module']) && $v['module'] != 'admin') ? '/'.$v['module'] : '';
            $controller = !empty($v['controller']) ? '/'.$v['controller'] : '';
            $action     = !empty($v['action']) ? '/'.$v['action'] : '';
            $list[$k]['href'] = $module.$controller.$action;
        }
        if ($list) {
            $treeService = new \app\common\service\RuleTree();
            $list = $treeService->getTree($list);
        }
        return $list;
    }
    
    function _assignInfo($id = 0){
        $info = parent::_assignInfo($id);
        if(!IS_POST){
            $this->_ruleList();
        }
        return $info;
    }
    function _getOrder()
    {
        return 'sort_order ASC, parent_id ASC';
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
    
    function _tableData(){
        $table = [
            ['title'     => '编号','width'     => '60','value'     => 'id','type'      => 'index'],
            ['title'     => '图标','width'     => '50','value'     => 'icon','type'      => 'icon'],
            ['title'     => '节点名称','width'   => '*','value'     => 'cname','type'      => 'text'],
            ['title'     => '操作地址','width'     => '*','value'     => 'href','type'      => 'text'],
            ['title'     => '是否验证权限','width'     => '120','value'     => 'authopen','type'      => 'yesOrNo','yes'       => '开启','no'        => '关闭'],
            ['title'     => '是否显示菜单','width'     => '120','value'     => 'menustatus','type'      => 'yesOrNo','yes'       => '开启','no'        => '关闭'],
            ['title'     => '状态','width'     => '60','value'     => 'status','type'      => 'yesOrNo','yes'       => '可用','no'        => '禁用'],
            ['title'     => '排序','width'     => '60','value'     => 'sort_order','type'      => 'text'],
            ['title'     => '操作','width'     => '160','type'      => 'button','value'   => 'id','button'    =>  [['text'  => '编辑','action'=> 'edit','icon'  => 'edit','bgClass'=> 'bg-main'],['text'  => '删除','action'=> 'del','icon'  => 'delete','bgClass'=> 'bg-red']]]
        ];
        return $table;
    }
    /**
     * 详情字段配置
     */
    /*function _fieldData(){
        parent::_fieldData();
        $field = [
            ['title'=>'上级节点','type'=>'select','options'=>'rulelist','name'=>'parent_id','size'=>'40','datatype'=>'','default'=>'','default_option'=>'==顶级节点==','notetext'=>'顶级节点请留空,其它上级节点请慎重选择'],
            ['title'=>'权限名称','type'=>'text','name'=>'title','size'=>'20','datatype'=>'*','default'=>'','notetext'=>'请填写权限节点名称'],
            ['title'=>'权限模块','type'=>'text','name'=>'module','size'=>'20','datatype'=>'','default'=>'','notetext'=>'请填写权限节点操作module,留空默认admin'],
            ['title'=>'权限控制器','type'=>'text','name'=>'controller','size'=>'20','datatype'=>'','default'=>'','notetext'=>'请填写权限节点操作控制器'],
            ['title'=>'权限操作','type'=>'text','name'=>'action','size'=>'20','datatype'=>'','default'=>'','notetext'=>'请填写权限节点操作行为'],
            ['title'=>'菜单图标','type'=>'text','name'=>'icon','size'=>'20','datatype'=>'','default'=>'','notetext'=>'请填写权限节点操作行为'],
            ['title'=>'节点状态','type'=>'radio','name'=>'status','size'=>'20','datatype'=>'','default'=>'1','notetext'=>'','radioList'=>[
                ['text'=>'可用','value'=>'1'],
                ['text'=>'禁用','value'=>'0'],
            ]],
            ['title'=>'权限状态','type'=>'radio','name'=>'authopen','size'=>'20','datatype'=>'','default'=>'1','notetext'=>'','radioList'=>[
                ['text'=>'开启','value'=>'1'],
                ['text'=>'关闭','value'=>'0'],
            ]],
            ['title'=>'显示状态','type'=>'radio','name'=>'menustatus','size'=>'20','datatype'=>'','default'=>'1','notetext'=>'','radioList'=>[
                ['text'=>'开启','value'=>'1'],
                ['text'=>'关闭','value'=>'0'],
            ]],
            ['title'=>'排序','type'=>'text','name'=>'sort_order','size'=>'20','datatype'=>'','default'=>'255','notetext'=>''],
        ];
        return $field;
    }*/
}