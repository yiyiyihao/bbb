<?php
namespace app\factory\controller;
use app\common\controller\Order as commonOrder;
//下级订单管理(渠道下的零售商订单管理)
class Suborder extends commonOrder
{
    public function __construct()
    {
        $this->modelName = 'suborder';
        $this->model = model('order');
        parent::__construct();
        if ($this->adminUser['admin_type'] != ADMIN_SERVICE_NEW) {
            $this->error('NO ACCESS');
        }
        $this->subMenu['menu']['0']['name'] = '全部';
        unset($this->subMenu['add']);
    }
    public function cancel()
    {
        $this->error('NO ACCESS');
    }
    public function pay()
    {
        if ($this->adminUser['admin_type'] != ADMIN_SERVICE_NEW) {
            $this->error('NO ACCESS');
        }
        return parent::pay();
    }
    public function updatePrice()
    {
        $this->error('NO ACCESS');
    }
    public function delivery()
    {
        $this->error('NO ACCESS');
    }
    public function finish()
    {
        $this->error('NO ACCESS');
    }
    function _getJoin(){
        return [
            ['user U', 'O.user_id = U.user_id', 'LEFT'],
            ['store S', 'O.user_store_id = S.store_id', 'LEFT'],
            ['store_dealer AS', 'O.user_store_id = AS.store_id', 'LEFT'],
        ];
    }
    function _getWhere(){
        $params = $this->request->param();
        $where = $this->_buildmap($params);
        if ($params && !isset($where['O.order_status'])) {
            $where['O.order_status'] = ['neq','4'];
        }
        if ($params) {
            $sn = isset($params['sn']) ? trim($params['sn']) : '';
            if($sn){
                $where['O.order_sn'] = ['like','%'.$sn.'%'];
            }
            $payNo = isset($params['pay_no']) ? trim($params['pay_no']) : '';
            if($payNo){
                $where['O.pay_sn'] = ['like','%'.$payNo.'%'];
            }
            $sname = isset($params['sname']) ? trim($params['sname']) : '';
            if($sname){
                $where['S.name'] = ['like','%'.$sname.'%'];
            }
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['O.address_name'] = ['like','%'.$name.'%'];
            }
            $phone = isset($params['phone']) ? trim($params['phone']) : '';
            if($phone){
                $where['O.address_phone'] = ['like','%'.$phone.'%'];
            }
        }
        return $where;
    }
    function _afterList($list)
    {
        if ($list) {
            $list = $this->model->getOrderList($list);
        }
        return $list;
    }
    protected function _buildmap($param = []){
        $params = $this->request->param();
        $map = [
            'AS.ostore_id' => $this->adminUser['store_id'],
            'S.is_del' => 0,
            'S.status' => 1,
        ];
        if(isset($param['pay_status'])){
            $map['O.order_status'] = 1;
            $map['O.pay_status'] = $param['pay_status'];
            $map['O.order_status'] = 1;
        }elseif(isset($param['delivery_status'])){
            if ($param['delivery_status']) {
                $map['O.delivery_status'] = 2;
            }else{
                $map['O.delivery_status'] = ['IN', [1,0]];
            }
            $map['O.pay_status'] = 1;
            $map['O.finish_status'] = 0;
            $map['O.order_status'] = 1;
        }elseif(isset($param['finish_status'])){
            $map['O.finish_status'] = 2;
            $map['O.order_status'] = 1;
        }elseif(isset($param['order_status'])){
            $map['O.order_status'] = $param['order_status'];
        }
        return $map;
    }
}