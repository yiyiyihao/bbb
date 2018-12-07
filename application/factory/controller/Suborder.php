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
        if ($this->adminUser['admin_type'] != ADMIN_CHANNEL) {
            $this->error('NO ACCESS');
        }
        unset($this->subMenu['add']);
    }
    public function cancel()
    {
        $this->error('NO ACCESS');
    }
    public function pay()
    {
        $this->error('NO ACCESS');
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
        $where = $this->buildmap($params);
        if ($params && !isset($where['O.status'])) {
            $where['O.status'] = ['neq','4'];
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
    private function buildmap($param = []){
        $params = $this->request->param();
        $map = [
            'AS.ostore_id' => $this->adminUser['store_id'],
            'S.is_del' => 0,
            'S.status' => 1,
        ];
        if(isset($param['pay_status'])){
            $map['O.status'] = 1;
            $map['O.pay_status'] = $param['pay_status'];
        }elseif(isset($param['delivery_status'])){
            if ($param['delivery_status']) {
                $map['O.delivery_status'] = 2;
            }else{
                $map['O.delivery_status'] = ['IN', [1,0]];
            }
            $map['O.pay_status'] = 1;
            $map['O.finish_status'] = 0;
        }elseif(isset($param['finish_status'])){
            $map['O.finish_status'] = 2;
        }elseif(isset($param['status'])){
            $map['O.status'] = $param['status'];
        }
        return $map;
    }
}