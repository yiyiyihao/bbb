<?php
namespace app\common\model;
use think\Model;

class OrderService extends Model
{
	public $error;
	protected $fields;
	protected $pk = 'service_id';
	protected $table;
	public $orderSkuModel;

	//自定义初始化
    protected function initialize()
    {
        $this->table = $this->config['prefix'].'order_sku_service';
        parent::initialize();
        $this->orderSkuModel = db('order_sku');
    }
    public function createService($order, $osku, $user, $params, $service = [])
    {
        $serviceType = isset($params['service_type']) ? intval($params['service_type']) : 0;
        $num = isset($params['num']) ? intval($params['num']) : 0;
        $refundAmount = isset($params['amount']) ? floatval($params['amount']) : 0;
        $remark = isset($params['remark']) ? trim($params['remark']) : '';
        $imgs = isset($params['imgs']) ? $params['imgs'] : [];
        
        $types = get_service_type();
        if (!$serviceType || !isset($types[$serviceType])) {
            $this->error = '售后类型错误';
            return FALSE;
        }
        if ($num <= 0) {
            $this->error = '产品数量必须大于0';
            return FALSE;
        }
        if ($num > $osku['num']) {
            $this->error = '产品数量不能超过('.$osku['num'].')';
            return FALSE;
        }
        if ($refundAmount <= 0) {
            $this->error = '退款金额必须大于0';
            return FALSE;
        }
        if ($refundAmount * $num > $osku['real_amount']) {
            $this->error = '退款金额不能超过('.$osku['real_amount'].')';
            return FALSE;
        }
        if ($order['pay_status'] != 1) {
            $this->error = '订单未付款';
            return FALSE;
        }
        //判断当前商品是否已申请退货/退款
        $exist = $this->where(['osku_id' => $osku['osku_id'], 'service_status' => ['NOT IN', [-1, 4]]])->find();
        if ($exist) {
            $this->error = '当前商品退货申请已存在';
            return FALSE;
        }
        $data = [
            'service_type'  => $serviceType,
            'store_id'      => $order['store_id'],
            'user_id'       => $user['user_id'],
            'user_store_id' => $order['user_store_id'],
            'order_id'      => $order['order_id'],
            'order_sn'      => $order['order_sn'],
            'osku_id'       => $osku['osku_id'],
            'num'           => $num,
            'refund_amount' => $refundAmount,
            'remark'        => $remark,
            'imgs'          => $imgs ? json_encode($imgs) : '',
        ];
        $where = [];
        if (!$service) {
            $data['service_sn'] = $this->_getServiceSn();
            $result = $serviceId = $this->save($data);
        }else{
            $serviceId = $service['service_id'];
            $data['service_status'] = 0;
            $result = $this->save($data, ['service_id' => $serviceId]);
        }
        if (!$result){
            $this->error = lang('system_error');
            return FALSE;
        }
        $this->orderSkuModel->where(['osku_id' => $osku['osku_id']])->update(['service_id' => $serviceId, 'service_status' => 0, 'update_time' => time()]);
        //记录日志
        $action = $serviceType ? '申请退款' : '申请退货退款';
        $orderModel = new Order();
        $orderModel->orderLog($order, $user, $action, $remark, $serviceId);
        return TRUE;
    }
    
    public function serviceCheck($service, $user, $params)
    {
        $service = $this->getServiceDetail($service['service_sn'], $user);
        if (!$service){
            return FALSE;
        }
        $type = $service['service_type'];
        $checkStatus = isset($params['check_status']) && intval($params['check_status']) ? 1 : 0;
        $remark = isset($params['admin_remark']) ? trim($params['admin_remark'])  : '';
        if (!$checkStatus && !$remark) {
            $this->error = '请填写拒绝理由';
            return FALSE;
        }
        $order = db('order')->where(['order_id' => $service['order_id']])->find();
        if (!$order) {
            $this->error = 'param_error';
            return FALSE;
        }
        //售后类型(1退款 2退货退款)
        //售后状态(-1拒绝申请 0申请中 1等待买家退货 2等待卖家退款 3退款成功 4已取消)
        switch ($type) {
            case 1://退款
                $serviceStatus = $checkStatus ? 3: -1;
            break;
            case 2://退货退款
                $serviceStatus = $checkStatus ? 1: -1;
            break;
            default:
                $this->error = lang('param_error');
                return FALSE;
            break;
        }
        //判断审核状态
        if ($service['service_status'] != 0) {
            $this->error = '申请已处理';
            return FALSE;
        }
        $data = [
            'service_status' => $serviceStatus,
            'admin_remark' => $remark,
        ];
        $result = $this->save($data, ['service_id' => $service['service_id']]);
        if ($result === FALSE){
            $this->error = lang('system_error');
            return FALSE;
        }
        $this->orderSkuModel->where(['osku_id' => $service['osku_id']])->update(['service_status' => $serviceStatus, 'update_time' => time()]);
        $types = get_service_type();
        $action = $checkStatus ? '同意' : '拒绝';
        $orderModel = new Order();
        $orderModel->orderLog($order, $user, $action.$types[$type], $remark, $service['service_id']);
        return TRUE;
    }
    public function serviceDelivery($service, $user = [], $extra = [])
    {
        $service = $this->getServiceDetail($service['service_sn'], $user);
        $remark = isset($extra['remark']) ? trim($extra['remark'])  : '';
        if (!$service){
            return FALSE;
        }
        if ($service['service_type'] != 2) {
            $this->error = lang('param_error');
            return FALSE;
        }
        if ($service['service_status'] != 1) {
            $this->error = lang('param_error');
            return FALSE;
        }
        $isDelivery = isset($extra['is_delivery']) && intval($extra['is_delivery']) ? intval($extra['is_delivery']) : 0;
        $deliveryIdentif = isset($extra['delivery_identif']) && trim($extra['delivery_identif']) ? trim($extra['delivery_identif']) : '';
        $deliverySn = isset($extra['delivery_sn']) && trim($extra['delivery_sn']) ? trim($extra['delivery_sn']) : '';
        if ($isDelivery) {
            if (!$deliveryIdentif) {
                $this->error = '请选择物流公司';
                return FALSE;
            }
            $deliverys = get_delivery();
            if (!$deliverys[$deliveryIdentif]) {
                $this->error = '物流公司错误';
                return FALSE;
            }
            if (!$deliverySn) {
                $this->error = '请输入第三方物流单号';
                return FALSE;
            }
        }
        $order = db('order')->where(['order_id' => $service['order_id']])->find();
        if (!$order) {
            $this->error = 'param_error';
            return FALSE;
        }
        $serviceStatus = 2; //退货后等待卖家退款
        $data = [
            'is_delivery'       => $isDelivery,
            'delivery_identif'  => $isDelivery ? $deliveryIdentif : '',
            'delivery_name'     => $isDelivery ? $deliveryIdentif && $deliverys[$deliveryIdentif]['name']: '',
            'delivery_sn'       => $isDelivery ? $deliverySn : '',
            'delivery_time'     => time(),
            
            'service_status'    => $serviceStatus,
        ];
        $result = $this->save($data, ['service_id' => $service['service_id']]);
        if ($result === FALSE){
            $this->error = lang('system_error');
            return FALSE;
        }
        $this->orderSkuModel->where(['osku_id' => $service['osku_id']])->update(['service_status' => $serviceStatus, 'update_time' => time()]);
        $types = get_service_type();
        $orderModel = new Order();
        if ($isDelivery) {
            $remark = '物流公司:'.$deliverys[$deliveryIdentif]['name'].'<br>'.'物流单号:'.$deliverySn.'<br>'.$remark;
        }
        $orderModel->orderLog($order, $user, '买家填写退货信息', $remark, $service['service_id']);
        return TRUE;
    }
    
    public function serviceRefund($service, $user, $params)
    {
        $service = $this->getServiceDetail($service['service_sn'], $user);
        if (!$service){
            return FALSE;
        }
        $type = $service['service_type'];
        $transferNo = isset($params['transfer_no']) ? trim($params['transfer_no'])  : '';
        $remark = isset($params['admin_remark']) ? trim($params['admin_remark'])  : '';
        if (!$transferNo) {
            $this->error = '请填写退款转账流水号';
            return FALSE;
        }
        $order = db('order')->where(['order_id' => $service['order_id']])->find();
        if (!$order) {
            $this->error = 'param_error';
            return FALSE;
        }
        //判断审核状态
        if ($service['service_status'] != 2) {
            $this->error = '操作异常';
            return FALSE;
        }
        $serviceStatus = 3;//已完成
        $data = [
            'service_status' => $serviceStatus,
            'admin_remark' => $remark,
        ];
        $result = $this->save($data, ['service_id' => $service['service_id']]);
        if ($result === FALSE){
            $this->error = lang('system_error');
            return FALSE;
        }
        $this->orderSkuModel->where(['osku_id' => $service['osku_id']])->update(['service_status' => $serviceStatus, 'update_time' => time()]);
        $orderModel = new Order();
        $orderModel->orderLog($order, $user, '卖家退款', $remark, $service['service_id']);
        return TRUE;
    }
    
    
    public function serviceCancel($service = '', $user = [], $remark = ''){
        $service = $this->getServiceDetail($service['service_sn'], $user);
        if (!$service){
            return FALSE;
        }
        if (!$user) {
            $this->error = '参数错误';
            return FALSE;
        }
        $order = db('order')->where(['order_id' => $service['order_id']])->find();
        if (!$order) {
            $this->error = 'param_error';
            return FALSE;
        }
        //售后状态(-1拒绝申请 0申请中 1等待买家退货 2等待卖家退款 3退款成功 4已取消)
        if ($service['service_status'] == 3) {
            $this->error = '已退款，不允许取消';
            return FALSE;
        }
        if ($service['service_status'] == 4) {
            $this->error = '已取消，不能重复操作';
            return FALSE;
        }
        $serviceStatus = 4;//取消状态
        $result = $this->save(['service_status' => $serviceStatus], ['service_id' => $service['service_id']]);
        if (!$result) {
            $this->error = $this->error;
            return FALSE;
        }
        $this->orderSkuModel->where(['osku_id' => $service['osku_id']])->update(['service_status' => $serviceStatus, 'update_time' => time()]);
        $orderModel = new Order();
        $orderModel->orderLog($order, $user, '取消申请', $remark, $service['service_id']);
        return TRUE;
    }
    
    public function getServiceDetail($serviceSn, $user = [], $serviceId = 0, $log = FALSE)
    {
        if (!$serviceSn && !$serviceId) {
            $this->error = '参数错误';
            return FALSE;
        }
        if (!$user) {
            $this->error = '参数错误';
            return FALSE;
        }
        if ($serviceSn) {
            $where = ['service_sn' => $serviceSn];
        }else{
            $where = ['service_id' => $serviceId];
        }
        
        if ($user && isset($user['store_id']) && $user['store_id'] > 0) {
            if ($user['admin_type'] == ADMIN_FACTORY) {
                $where['store_id'] = $user['store_id'];
            }elseif (in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER])){
                $storeIds = [$user['store_id']];
                if ($user['admin_type'] == ADMIN_CHANNEL) {
                    //获取零售商的下级经销商
                    $ids = db('store')->alias('S')->join([['store_dealer SD', 's.store_id = SD.store_id', 'INNER']])->where(['S.is_del' => 0, 'SD.ostore_id' => $user['store_id']])->column('S.store_id');
                    $storeIds = $ids ? array_merge($ids, $storeIds) : $storeIds;
                }
                $where['user_store_id'] = ['IN', $storeIds];
            }
        }
        $service = $this->where($where)->find();
        if (!$service) {
            $this->error = lang('NO ACCESS');
            return FALSE;
        }
        if ($log) {
            $service['logs'] = db('order_log')->where(['service_id' => $service['service_id']])->select();
        }
        $service['imgs'] = $service['imgs'] ? json_decode($service['imgs'], 1) : [];
        return $service;
    }
    private function _getServiceSn($sn = '')
    {
        $sn = get_nonce_str(12, 2). substr(implode(NULL, array_map('ord', str_split(substr(uniqid(), 7, 13), 1))), 0, 6);
        $exist = $this->where(['service_sn' => $sn])->find();
        if ($exist) {
            return $this->_getServiceSn();
        }else{
            return $sn;
        }
    }
}