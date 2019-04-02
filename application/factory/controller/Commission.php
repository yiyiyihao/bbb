<?php
namespace app\factory\controller;
//收益(佣金)明细管理
class Commission extends FactoryForm
{
    public function __construct()
    {
        $this->modelName = 'commission';
        parent::__construct();
        //渠道/服务商
        if (!in_array($this->adminUser['admin_type'], [ADMIN_CHANNEL, ADMIN_SERVICE,ADMIN_SERVICE_NEW])) {
            $this->error(lang('NO ACCESS'));
        }
        if ($this->adminUser['admin_type']  == ADMIN_CHANNEL) {
            $this->modelName = 'store_commission';
        }else{
            $this->modelName = 'store_service_income';
        }
        $this->model = db($this->modelName);
        unset($this->subMenu['add']);
    }
    function _getAlias()
    {
        return 'C';
    }
    function _getField(){
        $field = 'C.*, G.name as gname';
        if ($this->adminUser['admin_type']  == ADMIN_CHANNEL) {
            $field .= ', S.name as sname';
        }else{
            $join[] = ['user_installer UI', 'UI.installer_id = C.installer_id', 'LEFT'];
            $field .= ', UI.realname';
        }
        return $field;
    }
    function _getJoin()
    {
        if ($this->adminUser['admin_type']  == ADMIN_CHANNEL) {
            $join[] = ['store S', 'S.store_id = C.from_store_id', 'LEFT'];
        }else{
            $join[] = ['user_installer UI', 'UI.installer_id = C.installer_id', 'LEFT'];
        }
        $join[] = ['goods G', 'G.goods_id = C.goods_id', 'LEFT'];
        return $join;
    }
    function  _getOrder()
    {
        return 'C.add_time DESC';
    }
    function _getWhere(){
        $params = $this->request->param();
        $where = [
            'C.is_del' => 0,
            'C.store_id' => $this->adminUser['store_id'],
        ];
        if ($params) {
            $sn = isset($params['sn']) ? trim($params['sn']) : '';
            if ($this->adminUser['admin_type']  == ADMIN_CHANNEL) {
                if($sn){
                    $where['order_sn'] = ['like','%'.$sn.'%'];
                }
                $sname = isset($params['sname']) ? trim($params['sname']) : '';
                if($sname){
                    $where['S.name'] = ['like','%'.$sname.'%'];
                }
            }else{
                if($sn){
                    $where['worder_sn'] = ['like','%'.$sn.'%'];
                }
                $realname = isset($params['realname']) ? trim($params['realname']) : '';
                if($realname){
                    $where['UI.realname'] = ['like','%'.$realname.'%'];
                }
            }
            $gname = isset($params['gname']) ? trim($params['gname']) : '';
            if($gname){
                $where['G.name'] = ['like','%'.$gname.'%'];
            }
            
        }
        return $where;
    }
    /**
     * 列表搜索配置
     */
    function _searchData(){
        if ($this->adminUser['admin_type']  == ADMIN_CHANNEL) {
            $search = [
                ['type' => 'input', 'name' =>  'sn', 'value' => '订单编号', 'width' => '30'],
                ['type' => 'input', 'name' =>  'gname', 'value' => '产品名称', 'width' => '30'],
                ['type' => 'input', 'name' =>  'sname', 'value' => '零售商名称', 'width' => '30'],
            ];
        }else{
            $search = [
                ['type' => 'input', 'name' =>  'sn', 'value' => '工单编号', 'width' => '30'],
                ['type' => 'input', 'name' =>  'realname', 'value' => '工程师名称', 'width' => '30'],
                ['type' => 'input', 'name' =>  'gname', 'value' => '产品名称', 'width' => '30'],
            ];
        }
        return $search;
    }
    function _tableData(){
        $table = parent::_tableData();
        if ($table) {
            unset($table['actions']);
        }
        return $table;
    }
}