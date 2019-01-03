<?php
namespace app\factory\controller;
use app\common\controller\Store;

//保证金管理
class Security extends Store
{
    public function __construct()
    {
        $this->modelName = 'Security';
        $this->model = model('store');
        parent::__construct();
        unset($this->subMenu['add']);
    }
    function _assignInfo($pkId = 0)
    {
        $this->error(lang('NO ACCESS'));
    }
    function _getAlias()
    {
        return 'S';
    }
    function _getField(){
        return '*';
    }
    function _getJoin()
    {
        return [];
    }
    function  _getOrder()
    {
        return 'S.sort_order ASC, S.add_time DESC';
    }
    function _getWhere(){
        $where = [
            'S.is_del'          => 0,
            'S.check_status'    => 1,
            'S.store_type'      => ['IN', [STORE_CHANNEL, STORE_SERVICE]],
        ];
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $where['S.factory_id'] = $this->adminUser['store_id'];
        }
        $params = $this->request->param();
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['S.name'] = ['like','%'.$name.'%'];
            }
            $type = isset($params['type']) ? intval($params['type']) : '';
            if($type){
                $where['S.store_type'] = $type;
            }
            $uname = isset($params['uname']) ? trim($params['uname']) : '';
            if($uname){
                $where['S.user_name|S.mobile'] = ['like','%'.$uname.'%'];
            }
        }
        return $where;
    }
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $types = [
            STORE_CHANNEL =>'渠道商',
            STORE_DEALER =>'零售商',
        ];
        $this->assign('types', $types);
        $search = [
            ['type' => 'select', 'name' => 'type', 'options'=>'types', 'default_option' => '==商户类型=='],
            ['type' => 'input', 'name' =>  'name', 'value' => '商户名称', 'width' => '30'],
            ['type' => 'input', 'name' =>  'uname', 'value' => '联系人姓名/电话', 'width' => '30'],
        ];
        return $search;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = [
            ['title'     => '编号','width'    => '60','value'      => 'factory_id','type'      => 'index'],
            ['title'     => '商户类型', 'width'   => '*','value'     => 'store_type', 'type'      => 'function', 'function' => 'get_store_type'],
            ['title'     => '商户名称', 'width'   => '*','value'     => 'name', 'type'      => 'text'],
            ['title'     => '联系人', 'width'   => '*','value'     => 'user_name', 'type'      => 'text'],
            ['title'     => '联系电话', 'width'   => '*','value'     => 'mobile', 'type'      => 'text'],
            ['title'     => '保证金金额', 'width'   => '*','value'     => 'security_money', 'type'      => 'text'],
            ['title'     => '创建时间', 'width'   => '*','value'     => 'add_time','type'      => 'text'],
        ];
        return array_filter($table);
    }
}