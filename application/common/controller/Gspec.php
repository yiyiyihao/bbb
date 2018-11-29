<?php
namespace app\common\controller;
use think\Request;
//商品规格管理
class Gspec extends FormBase
{
    public function __construct()
    {
        $this->modelName = 'goods_spec';
        $this->model = db($this->modelName);
        parent::__construct();
        $this->search= self::_searchData();
        $this->table = self::_tableData();
    }
    function _getField(){
        $field = 'GS.*';
//         if ($this->showOther) {
            $field .= ', S.name as sname';
//         }
        return $field;
    }
    function _getAlias(){
        return 'GS';
    }
    function _getOrder(){
        return 'GS.sort_order ASC, GS.add_time DESC';
    }
    function _getJoin(){
        $join[] = ['store S', 'S.store_id = GS.store_id', 'INNER'];
        return $join;
    }
    function _getWhere(){
        $params = $this->request->param();
        $where = ['GS.is_del' => 0];
        if ($this->adminUser['store_id']) {
            $where['GS.store_id'] = $this->adminUser['store_id'];
        }
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['GS.name'] = ['like','%'.$name.'%'];
            }
            $sname = isset($params['sname']) ? trim($params['sname']) : '';
            if($sname){
                $where['S.name'] = ['like','%'.$sname.'%'];
            }
        }
        return $where;
    }
    function _getData()
    {
        $data = parent::_getData();
        $name = trim($data['name']);
        if (!$name) {
            $this->error('规格名称不能为空');
        }
        $where = ['name' => $name, 'is_del' => 0, 'store_id' => $this->adminUser['store_id']];
        $params = $this->request->param();
        $pkId = $params && isset($params['id']) ? intval($params['id']) : 0;
        if($pkId){
            $where['spec_id'] = ['neq', $pkId];
        }
        if ($this->adminUser['store_id']) {
            $data['store_id'] = $this->adminUser['store_id'];
        }
        $exist = $this->model->where($where)->find();
        if($exist){
            $this->error('当前规格名称已存在');
        }
        $specValue = $data['specname'];
        if (!$specValue) {
            $this->error('请输入规格属性');
        }
        $specValue = implode(',',$specValue);
        $data['value'] = $specValue;
        unset($data['specname']);
        return $data;
    }
    function _assignInfo($id = 0)
    {
        $info = parent::_assignInfo($id);
        if ($info) {
            $info['value'] = explode(',', $info['value']);
        }
        $store = new \app\common\controller\Store();
        $store->_getFactorys();
        
        $this->assign('info', $info);
        return $info;
    }
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $search = [
            ['type' => 'input', 'name' =>  'name', 'value' => lang($this->modelName).'名称', 'width' => '20'],
        ];
        return $search;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = [
            ['title'     => '编号','width'    => '60','value'      => 'spec_id','type'      => 'index'],
            ['title'     => '厂商名称','width'  => '*','value'   => 'sname','type'      => 'text'],
            ['title'     => lang($this->modelName).'名称','width'  => '*','value'   => 'name','type'      => 'text'],
            ['title'     => lang($this->modelName).'对应属性值','width'  => '*','value'   => 'value','type'      => 'text'],
            ['title'     => '状态','width'    => '80','value'      => 'status','type'      => 'yesOrNo', 'yes'       => '可用','no'        => '禁用'],
            ['title'     => '排序','width'    => '80','value'      => 'sort_order','type'      => 'text'],
            ['title'     => '操作','width'    => '*','value'   => 'spec_id','type'      => 'button','button'    =>
                [
                    ['text'  => '编辑','action'=> 'edit','icon'  => 'edit','bgClass'=> 'bg-main'],
                    ['text'  => '删除','action'=> 'del','icon'  => 'delete','bgClass'=> 'bg-red']
                ]
            ]
        ];
        return array_filter($table);
    }
}