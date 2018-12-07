<?php
namespace app\factory\controller;
//收益(佣金)明细管理
class Commission extends FactoryForm
{
    public function __construct()
    {
        $this->modelName = 'commission';
        $this->model = db($this->modelName);
        parent::__construct();
        //渠道
        if (!in_array($this->adminUser['admin_type'], [ADMIN_CHANNEL])) {
            $this->error(lang('NO ACCESS'));
        }
        unset($this->subMenu['add']);
        $this->search= self::_searchData();
    }
    function _getAlias()
    {
        return 'C';
    }
    function _getField(){
        $field = 'C.*, S.name as sname, G.name as gname';
        return $field;
    }
    function _getJoin()
    {
        $join[] = ['store S', 'S.store_id = C.from_store_id', 'LEFT'];
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
            if($sn){
                $where['order_sn'] = ['like','%'.$sn.'%'];
            }
            $gname = isset($params['gname']) ? trim($params['gname']) : '';
            if($gname){
                $where['G.name'] = ['like','%'.$gname.'%'];
            }
            $sname = isset($params['sname']) ? trim($params['sname']) : '';
            if($sname){
                $where['S.name'] = ['like','%'.$sname.'%'];
            }
        }
        return $where;
    }
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $search = [
            ['type' => 'input', 'name' =>  'sn', 'value' => '订单编号', 'width' => '30'],
            ['type' => 'input', 'name' =>  'gname', 'value' => '商品名称', 'width' => '30'],
            ['type' => 'input', 'name' =>  'sname', 'value' => '零售商名称', 'width' => '30'],
        ];
        return $search;
    }
}