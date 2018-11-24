<?php
namespace app\admin\controller;
use app\common\controller\FormBase;

//平台权限节点管理
class Authrule extends FormBase
{
    public function __construct()
    {
        $this->modelName = 'auth_rule';
        $this->model = db('auth_rule');
        parent::__construct();
        $this->table = self::_tableData();
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
    
    private function _tableData(){
        $table = [
            [
                'title'     => '编号',
                'width'     => '60',
                'value'     => 'id',
                'type'      => 'index',
            ],
            [
                'title'     => '图标',
                'width'     => '50',
                'value'     => 'icon',
                'type'      => 'icon',
            ],
            [
                'title'     => '节点名称',
                'width'     => '100',
                'value'     => 'cname',
                'type'      => 'text',
            ],
            [
                'title'     => '操作地址',
                'width'     => '*',
                'value'     => 'href',
                'type'      => 'text',
            ],
            [
                'title'     => '是否验证权限',
                'width'     => '120',
                'value'     => 'authopen',
                'type'      => 'yesOrNo',
                'yes'       => '开启',
                'no'        => '关闭',
            ],
            [
                'title'     => '是否显示菜单',
                'width'     => '120',
                'value'     => 'menustatus',
                'type'      => 'yesOrNo',
                'yes'       => '开启',
                'no'        => '关闭',
            ],
            [
                'title'     => '状态',
                'width'     => '60',
                'value'     => 'status',
                'type'      => 'yesOrNo',
                'yes'       => '可用',
                'no'        => '禁用',
            ],
            [
                'title'     => '排序',
                'width'     => '60',
                'value'     => 'sort_order',
                'type'      => 'text',
            ],
            [
                'title'     => '操作',
                'width'     => '160',
                'type'      => 'button',
                'button'    =>  [
                    [
                        'text'  => '编辑',
                        'action'=> 'edit',
                        'icon'  => 'edit',
                        'bgClass'=> 'bg-main',
                    ],
                    [
                        'text'  => '删除',
                        'action'=> 'del',
                        'icon'  => 'delete',
                        'bgClass'=> 'bg-red',
                    ],
                ]
            ],
        ];
        return $table;
    }
}