<?php
namespace app\admin\controller;
use app\common\controller\FormBase;
use think\Request;
//商品规格管理
class Gspec extends FormBase
{
    public function __construct()
    {
        $this->modelName = 'goods_spec';
        $this->model = db($this->modelName);
        parent::__construct();
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
        $join[] = ['store S', 'S.store_id = GS.factory_id', 'INNER'];
        return $join;
    }
    function _getWhere(){
        $params = $this->request->param();
        $where = ['GS.is_del' => 0];
        if ($this->adminUser['store_id']) {
            $where['GS.factory_id'] = $this->adminUser['store_id'];
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
        $where = ['name' => $name, 'is_del' => 0, 'factory_id' => $this->storeId];
        $params = $this->request->param();
        $pkId = $params && isset($params['id']) ? intval($params['id']) : 0;
        if($pkId){
            $where['spec_id'] = ['neq', $pkId];
        }
        if ($this->adminUser['factory_id']) {
            $data['factory_id'] = $this->adminUser['factory_id'];
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
}
