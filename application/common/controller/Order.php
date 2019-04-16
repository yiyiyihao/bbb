<?php
namespace app\common\controller;
//厂商订单管理
use think\Db;

class Order extends FormBase
{
    public $config;
    public function __construct()
    {
        $this->modelName = $this->modelName ? $this->modelName : 'order';
        //$this->model = db($this->modelName);
        $this->model = new \app\common\model\Order();
        parent::__construct();
        $this->subMenu['showmenu'] = true;
        unset($this->subMenu['add']);
        $this->subMenu['menu'][] = [
            'name' => '待付款',
            'url' => url('index', ['pay_status' => 0]),
        ];
        $this->subMenu['menu'][] = [
            'name' => '已完成',
            'url' => url('index', ['finish_status' => 1]),
        ];
        $this->subMenu['menu'][] = [
            'name' => '已取消',
            'url' => url('index', ['order_status' => 2]),
        ];
        $this->subMenu['menu'][] = [
            'name' => '已关闭',
            'url' => url('index', ['order_status' => 3]),
        ];
        $this->subMenu['menu']['0']['name'] = '全部';
    }
    public function detail()
    {
        $params = $this->request->param();
        $orderSn = isset($params['order_sn']) ? trim($params['order_sn']) : '';
        /* $this->subMenu['menu'][] = [
            'name' => '订单查看',
            'url' => url('detail', ['order_sn' => $orderSn]),
        ]; */
        $this->subMenu['showmenu'] = false;
        $detail = $this->model->getOrderDetail($orderSn, $this->adminUser, TRUE, TRUE);
        if ($detail === false) {
            $this->error($this->model->error);
        }
        $this->assign('info', $detail);
        return $this->fetch('detail');
    }
    //取消订单
    public function cancel()
    {
        $params = $this->request->param();
        $orderSn = isset($params['order_sn']) ? trim($params['order_sn']) : '';
        $result = $this->model->orderCancel($orderSn, $this->adminUser);
        if ($result === FALSE) {
            $this->error($this->model->error);
        }else{
            $this->success('取消订单成功');
        }
    }
    //支付订单
    public function pay()
    {
        $this->subMenu['showmenu'] = false;
        $params = $this->request->param();
        $orderSn = isset($params['order_sn']) ? trim($params['order_sn']) : '';
        if (IS_POST) {
            $result = $this->model->orderPay($orderSn, $this->adminUser, $params);
            if ($result === FALSE) {
                $this->error($this->model->error);
            }else{
                $this->success('确认付款成功', url('index'));
            }
        }else{
            $this->subMenu['menu'][] = [
                'name' => '确定收款',
                'url' => url('pay', ['order_sn' => $orderSn]),
            ];
            $order = $this->model->checkOrder($orderSn, $this->adminUser);
            if ($order === FALSE) {
                $this->error($this->model->error);
            }
            if ($order['order_status'] == 2) {
                $this->error('订单已取消不能支付');
            }
            if ($order['pay_status'] > 0) {
                $this->error('订单已支付不能重复支付');
            }
            $payments = $this->model->getOrderPayments($this->adminUser['store_id']);
            $this->assign('payments', $payments);
            $this->assign('info', $order);
            return $this->fetch('pay');
        }
    }
    public function updatePrice()
    {
        $this->error(lang('NO ACCESS'));
        $params = $this->request->param();
        $orderSn = isset($params['order_sn']) ? trim($params['order_sn']) : '';
        if (IS_POST) {
            $result = $this->model->orderUpdatePrice($orderSn, $this->adminUser, $params);
            if ($result === FALSE) {
                $this->error($this->model->error);
            }else{
                $this->success('调整订单支付金额成功', url('index'));
            }
        }else{
            $this->subMenu['menu'][] = [
                'name' => '调整订单支付金额',
                'url' => url('updatePrice', ['order_sn' => $orderSn]),
            ];
            $order = $this->model->checkOrder($orderSn, $this->adminUser);
            if ($order === FALSE) {
                $this->error($this->model->error);
            }
            $this->assign('info', $order);
            return $this->fetch('updateprice');
        }
    }
    //产品发货
    public function delivery()
    {
        $params = $this->request->param();
        $routes = $this->request->route();
        $orderSn = isset($params['order_sn']) ? trim($params['order_sn']) : '';
        if (IS_POST) {
            $oskuIds = input('post.osku_id/a');
            if (!$oskuIds) {
                $this->error('请选择发货产品');
            }
            $params['osku_id'] = $oskuIds;
            $result = $this->model->orderDelivery($orderSn, $this->adminUser, $params);
            if ($result === FALSE) {
                $this->error($this->model->error);
            }else{
                $this->success('订单发货成功', url('detail', ['order_sn' => $orderSn]));
            }
        }else{
            $this->assign('deliverys', get_delivery());
            $this->subMenu['menu'][] = [
                'name' => '订单查看',
                'url' => url('detail', ['order_sn' => $orderSn]),
            ];
            $this->subMenu['menu'][] = [
                'name' => '订单产品发货',
                'url' => url('delivery', $routes),
            ];
            $order = $this->model->checkOrder($orderSn, $this->adminUser);
            if ($order === FALSE) {
                $this->error($this->model->error);
            }
            $detail = $this->model->getOrderDetail($orderSn, $this->adminUser);
            $this->assign('params', $params);
            $this->assign('info', $detail);
            return $this->fetch('delivery');
        }
    }
    public function finish()
    {
        $params = $this->request->param();
        $orderSn = isset($params['order_sn']) ? trim($params['order_sn']) : '';
        $result = $this->model->orderFinish($orderSn, $this->adminUser, $params);
        if ($result === FALSE) {
            $this->error($this->model->error);
        }else{
            $this->success('订单确认完成操作成功', url('detail', ['order_sn' => $orderSn]));
        }
    }
    //产品物流信息
    public function deliveryLogs(){
        $params = $this->request->param();
        $odeliveryId = isset($params['odelivery_id']) ? intval($params['odelivery_id']) : 0;
        $delivery = db('order_sku_delivery')->where(['odelivery_id' => $odeliveryId])->find();
        $this->subMenu['menu'][] = [
            'name' => '订单查看',
            'url' => url('detail', ['order_sn' => $delivery['order_sn']]),
        ];
        $this->subMenu['menu'][] = [
            'name' => '查看物流',
            'url' => url('deliveryLogs', ['odelivery_id' => $odeliveryId]),
        ];
        $result = $this->model->updateApi100($delivery['order_sn'], $this->adminUser, $odeliveryId);
        if ($result === FALSE) {
            $this->error('物流配送信息查看失败：'.$this->model->error);
        }
        //获取物流配送产品列表
        $skus = db('order_sku')->where(['osku_id' => ['IN', $delivery['osku_ids']]])->select();
        //获取物流跟踪日志
        $logs = db('order_track')->where(['odelivery_id' => $delivery['odelivery_id']])->order('track_id DESC')->select();
        $this->assign('info', $delivery);
        $this->assign('skus', $skus);
        $this->assign('list', $logs);
        return $this->fetch('delivery_log');
    }
    
    function _afterList($list)
    {
        if ($list) {
            $flag = in_array($this->adminUser['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER,ADMIN_SERVICE_NEW]) ? TRUE : FALSE;
            $list = $this->model->getOrderList($list, $flag);
        }
        return $list;
    }
    
    function _getField(){
        $field= 'S.name as sname, O.*';
        if ($this->adminStore['store_type'] == STORE_SERVICE_NEW) {
            $field.=',SS.name ssname';
        }
        return $field;
    }
    function _getAlias(){
        return 'O';
    }
    function _getJoin(){
        $join[] = ['store S', 'S.store_id = O.user_store_id', 'LEFT'];
        if ($this->adminStore['store_type'] == STORE_SERVICE_NEW) {
            $join = [
                ['store_dealer SD', 'SD.store_id = O.user_store_id', 'LEFT'],
                ['store S', 'S.store_id = SD.store_id', 'LEFT'],
                ['store SS', 'SS.store_id = O.user_store_id', 'LEFT'],
            ];
        }
        return $join;
    }
    function _getOrder(){
        //return 'O.update_time DESC';
        return 'O.add_time DESC';
    }
    function _getWhere(){
        $params = $this->request->param();
        $where = $this->_buildmap($params);
        if ($params && !isset($where['O.order_status'])) {
            $where['O.order_status'] = ['neq','4'];
        }
        if ($this->adminStore['store_type']==STORE_DEALER) {
            $where['O.user_store_id']=$this->adminStore['store_id'];
        } elseif ($this->adminStore['store_type']==STORE_FACTORY) {
            $where['O.store_id']=$this->adminStore['store_id'];
        } elseif ($this->adminStore['store_type']==STORE_SERVICE_NEW) {
            $storeId=$this->adminStore['store_id'];
            $where[]=Db::raw('O.user_store_id = '.$storeId.' OR SD.ostore_id='.$storeId);
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
    protected function _buildmap($param = []){
        $params = $this->request->param();
        $map = [
            'order_type' => ['IN', '1,3'],
        ];
        if(isset($param['pay_status'])){
            $map['O.order_status'] = 1;
            $map['O.pay_status'] = $param['pay_status'];
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