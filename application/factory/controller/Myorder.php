<?php
namespace app\factory\controller;
use app\common\controller\Order as commonOrder;
//买家订单管理
class Myorder extends commonOrder
{
    public $orderSkuModel;
    public $serviceModel;
    
    public function __construct()
    {
        $this->modelName = 'myorder';
        $this->model = model('order');
        parent::__construct();
        if (!in_array($this->adminUser['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER])) {
            $this->error('NO ACCESS');
        }
        unset($this->subMenu['add']);
        $this->orderSkuModel = db('order_sku');
        $this->serviceModel = new \app\common\model\OrderService();
    }
    public function return()
    {
        $params = $this->request->param();
        $orderSn = isset($params['order_sn']) ? trim($params['order_sn']) : '';
        $oskuId = isset($params['id']) ? intval($params['id']) : 0 ;
        $serviceId = isset($params['sid']) ? intval($params['sid']) : 0 ;
        $type = isset($params['type']) ? intval($params['type']) : 0 ;
        
        $order = $this->model->checkOrder($orderSn, $this->adminUser);
        if ($order === FALSE) {
            return FALSE;
        }
        $serviceModel = new \app\common\model\OrderService();
        $service = [];
        if ($serviceId) {
            //只有取消的售后可以重新申请
            $service = $serviceModel->getServiceDetail(FALSE, $this->adminUser, $serviceId);
            if (!$service) {
                $this->error($serviceModel->error);
            }
            if (!in_array($service['service_status'], [-1, 4])) {
                $this->error('申请已存在不能重复操作');
            }
            $type = $service['service_type'];
        }
        if (!$type) {
            $this->error('请选择售后类型');
        }
        $types = get_service_type();
        if (!isset($types[$type])) {
            $this->error('售后类型错误');
        }
        $name = $types[$type];
        
        $this->subMenu['menu'][] = [
            'name' => '申请售后: '.$name,
            'url' => url('return', ['order_sn' => $orderSn, 'id' => $oskuId, 'sid' => $serviceId, 'type' => $type]),
        ];
        
        //判断是否在退货退款时间内
        if (isset($this->config['returnTime']) && $order['pay_time'] && ($order['pay_time'] + $this->config['returnTime']) <= time()) {
            $this->error('超时不允许退货退款');
        }
        $osku = $this->orderSkuModel->where(['order_id' => $order['order_id'], 'osku_id' => $oskuId, 'return_status' => 0])->find();
        if (!$osku) {
            $this->error(lang('param_error'));
        }
        if (isset($this->config['returnCount']) && $this->config['returnCount']) {
            //判断售后申请次数
            $count = $serviceModel->where(['osku_id' => $osku['osku_id']])->count();
            if ($count && $count >= $this->config['returnCount']) {
                $this->error(lang('售后申请已达最大次数'));
            }
        }
        if (IS_POST) {
            $params = $this->request->param();
            $params['service_type'] = $type;
            $result = $this->serviceModel->createService($order, $osku, $this->adminUser, $params, $service, $this->config);
            if ($result === FALSE) {
                $this->error($this->serviceModel->error);
            }else{
                $this->success('售后申请成功,请耐心等待商家审核', url('detail', ['order_sn' => $orderSn]));
            }
        }else{
            $this->assign('service', $service);
            $this->assign('info', $order);
            $this->assign('osku', $osku);
            $this->assign('name', $name);
            return $this->fetch();
        }
    }
    public function updatePrice()
    {
        $this->error('NO ACCESS');
    }
    public function delivery()
    {
        $this->error('NO ACCESS');
    }
    public function pay()
    {
        $params = $this->request->param();
        $step = isset($params['step']) ? intval($params['step']) : 1;
        $orderSn = isset($params['order_sn']) ? trim($params['order_sn']) : '';
        $detail = $this->model->checkOrder($orderSn, $this->adminUser);
        #TODO 下单用户才有支付权限
        if ($detail['user_id'] != ADMIN_ID) {
            $this->error('无操作权限');
        }
        $this->assign('step', $step);
        //获取厂商设置未支付订单取消时间
        $factoryConfig = db('store')->where(['store_id' => $detail['store_id'], 'is_del' => 0])->value('config_json');
        $factoryConfig = $factoryConfig ? json_decode($factoryConfig, 1) : [];
        $factoryConfig['pending_order_cancel_time'] = isset($factoryConfig['pending_order_cancel_time']) ? $factoryConfig['pending_order_cancel_time'] : 30;//未设置默认30分钟
        $detail['cancel_countdown'] = $factoryConfig['pending_order_cancel_time'];
        //获取订单产品列表
        $oSkus = $this->model->getOrderSkus($detail['order_id']);
        if (!$oSkus) {
            $this->error('订单数据异常');
        }
        $sku = $oSkus[0];//单次仅购买一个产品
        $payments = $this->model->getOrderPayments($detail['store_id'], 1);
        $this->assign('order', $detail);
        if ($step == 1) {
            $this->assign('payments', $payments);
            $this->assign('skus', $oSkus);
            return $this->fetch();
        }else{
            $payCode = isset($params['pay_code']) ? trim($params['pay_code']) : '';
            if (!$payCode) {
                $this->error('请选择支付方式');
            }
            $payment = new \app\common\api\PaymentApi($detail['store_id'], $payCode);
            $detail['subject'] = $sku['sku_name'].' '.$sku['sku_spec'];
            $detail['product_id'] = $sku['sku_id'];
            //$detail['openid'] = 'oDDkf5RMJ5hLJ3oOOqGmTXyt3BJk';
            $result = $payment->init($detail);
            if ($result === FALSE) {
                $this->error($payment->error);
            }
            if ($payCode == 'wechat_native' && isset($result['code_url'])) {
                //根据url生成二维码
                $this->assign('code_url', $result['code_url']);
            }
            return $this->fetch();
        }
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
    private function _buildmap($param = []){
        $params = $this->request->param();
        $map = [
            'O.user_id' => ADMIN_ID,
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