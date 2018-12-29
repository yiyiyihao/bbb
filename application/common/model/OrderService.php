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
    /**
     * 申请订单售后服务
     * @param array $order
     * @param array $osku
     * @param array $user
     * @param array $params
     * @param array $service
     * @param array $storeConfig
     * @return boolean
     */
    public function createService($order, $ossub, $user, $params, $service = [])
    {
        if (!$order || !$ossub || !$user || !$params) {
            $this->error = lang('PARAM_ERROR');
            return FALSE;
        }
        $orderSkuModel = new \app\common\model\OrderSku();
        $ossub = $orderSkuModel->getSubDetail($ossub['ossub_id'], FALSE, FALSE, TRUE);
        if (!$ossub) {
            $this->error(lang('param_error'));
        }
        if ($ossub['work_order'] && $ossub['work_order'] != -1) {
            $this->error(lang('当前产品存在安装工单，不允许申请售后'));
        }
        $serviceType = isset($params['service_type']) ? intval($params['service_type']) : 0;
        $num = 1;
        $refundAmount = $ossub['real_price'];
        
        $remark = isset($params['remark']) ? trim($params['remark']) : '';
        $imgs = isset($params['imgs']) ? $params['imgs'] : [];
        if ($refundAmount <= 0) {
            $this->error = '退款金额必须大于0';
            return FALSE;
        }
        if ($order['pay_status'] != 1) {
            $this->error = '订单未完成支付';
            return FALSE;
        }
        if ($service && $service['service_status'] != -1) {
            $this->error = '申请已存在不能重复申请';
            return FALSE;
        }
        $storeConfig = get_store_config($order['store_id'], TRUE, 'default');
        $returnTime = 0;
        //判断商户是否可提现(超时不允许提现)
        if ($storeConfig && isset($storeConfig['order_return_day']) && $storeConfig['order_return_day'] > 0) {
            $returnTime = $storeConfig['order_return_day'] * 24 * 60 * 60;
        }
        //return_status -1为关闭退货退款 0为可退货退款 1为已退款 2为已退货退款
        if ($order['close_refund_status'] != 0 || ($order['pay_time'] + $returnTime) <= time()) {
            $this->error = '不允许操作';
            return FALSE;
        }
        //判断当前产品是否已申请退货/退款
        $exist = $this->where(['ossub_id' => $ossub['ossub_id'], 'service_status' => ['NOT IN', [-1, -2]]])->find();
        if ($exist) {
            $this->error = '当前产品已申请退货退款';
            return FALSE;
        }
        $data = [
            'store_id'      => $order['store_id'],
            'user_id'       => $user['user_id'],
            'user_store_id' => $order['user_store_id'],
            'order_id'      => $order['order_id'],
            'order_sn'      => $order['order_sn'],
            'osku_id'       => $ossub['osku_id'],
            'ossub_id'      => $ossub['ossub_id'],
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
        //记录日志
        $orderModel = new Order();
        $orderModel->orderLog($order, $user, '申请退货退款', $remark, $serviceId);
        return TRUE;
    }
    /**
     * 售后订单审核(卖家)
     * @param array $service
     * @param array $user
     * @param array $params
     * @return boolean
     */
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
        //售后类型(1退货退款)
        //售后状态(-1拒绝申请 0申请中 1等待买家退货 2等待卖家退款 3退款成功 -2已取消)
        switch ($type) {
            case 1://退货退款
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
        $types = get_service_type();
        $action = $checkStatus ? '同意' : '拒绝';
        $orderModel = new Order();
        $orderModel->orderLog($order, $user, $action.$types[$type], $remark, $service['service_id']);
        return TRUE;
    }
    /**
     * 售后订单退货信息录入(买家)
     * @param array $service
     * @param array $user
     * @param array $extra
     * @return boolean
     */
    public function serviceDelivery($service, $user = [], $extra = [])
    {
        $service = $this->getServiceDetail($service['service_sn'], $user);
        $remark = isset($extra['remark']) ? trim($extra['remark'])  : '';
        if (!$service){
            return FALSE;
        }
        if ($service['service_type'] != 1) {
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
            'delivery_identif'  => $isDelivery ? $deliveryIdentif : '',
            'delivery_name'     => $isDelivery && $deliveryIdentif ? $deliverys[$deliveryIdentif]['name']: '',
            'delivery_sn'       => $isDelivery ? $deliverySn : '',
            'delivery_time'     => time(),
            'delivery_status'   => 1,
            
            'service_status'    => $serviceStatus,
        ];
        $result = $this->save($data, ['service_id' => $service['service_id']]);
        if ($result === FALSE){
            $this->error = lang('system_error');
            return FALSE;
        }
        $types = get_service_type();
        $orderModel = new Order();
        if ($isDelivery) {
            $remark = '物流公司:'.$deliverys[$deliveryIdentif]['name'].'<br>'.'物流单号:'.$deliverySn.'<br>'.$remark;
        }
        $orderModel->orderLog($order, $user, '买家填写退货信息', $remark, $service['service_id']);
        return TRUE;
    }
    
    /**
     * 售后订单退款(卖家)
     * @param array $service
     * @param array $user
     * @param array $params
     * @return boolean
     */
    public function serviceRefund($service, $user, $params)
    {
        $transferNo = isset($params['transfer_no']) ? trim($params['transfer_no'])  : '';
        $remark = isset($params['remark']) ? trim($params['remark'])  : '';
//         if (!$transferNo) {
//             $this->error = '请填写退款转账流水号';
//             return FALSE;
//         }
        
        $service = $this->getServiceDetail($service['service_sn'], $user);
        if (!$service){
            return FALSE;
        }
        //售后状态(-2已取消 -1拒绝申请 0申请中 1等待买家退货 2等待卖家退款 3退款成功)
        switch ($service['service_status']) {
            case -2:
                $this->error = '售后申请已取消,不允许退款';
                return FALSE;
            break;
            case -1:
                $this->error = '售后申请已拒绝,不允许退款';
                return FALSE;
            break;
            case 0:
                $this->error = '售后申请未审核,不允许退款';
                return FALSE;
            break;
            case 1:
                $this->error = '等待卖家退货,不允许退款';
                return FALSE;
            break;
            case 3:
                $this->error = '已完成退款,不允许重复操作';
                return FALSE;
            break;
            default:
            break;
        }
        if ($user['admin_type'] != ADMIN_FACTORY) {
            $this->error = '无退款权限';
            return FALSE;
        }
        //判断订单是否已支付(是否在线支付)
        $order = db('Order')->where(['order_id' => $service['order_id'], 'store_id' => $user['store_id']])->find();
        if (!$order) {
            $this->error = lang('param_error');
            return FALSE;
        }
        if ($order['pay_type'] != 1) {
            $this->error = lang('非在线支付，不允许退款操作');
            return FALSE;
        }
        if (!$order['pay_code'] || !$order['pay_sn']) {
            $this->error = lang('支付异常,不允许操作');
            return FALSE;
        }
        $subModel = db('order_sku_sub');
        $osub = $subModel->where(['order_id' => $service['order_id'], 'ossub_id' => $service['ossub_id']])->find();
        if (!$osub) {
            $this->error = lang('param_error');
            return FALSE;
        }
        $payCode = $order['pay_code'];
        $config = db('payment')->where(['pay_code' => $payCode, 'is_del' => 0, 'status' => 1])->find();
        if (!$config) {
            $this->error = lang('支付配置已删除/已禁用，请检查配置详情');
            return FALSE;
        }
        $apiType = $config['api_type'];
        $storeId = $order['store_id'];
        switch ($apiType) {
            case 'alipay':
                $alipayApi = new \app\common\api\AlipayPayApi($storeId, $payCode);
                $result = $alipayApi->tradeRefund($order, $service);
                if ($result === FALSE) {
                    $this->error = $alipayApi->error;
                    return FALSE;
                }
                $remark = '支付宝原路退款';
            break;
            case 'wechat':
                $wechatApi = new \app\common\api\WechatPayApi($storeId, $payCode);
                $result = $wechatApi->tradeRefund($order, $service);
                if ($result === FALSE) {
                    $this->error = $wechatApi->error;
                    return FALSE;
                }
                $remark = '微信原路退款';
            break;
            default:
                $this->error = lang('接口未开通');
                return FALSE;
            break;
        }
        $transferNo = $service['service_sn'];
        $serviceStatus = 3;//已完成
        $data = [
            'refund_time'    => time(),
            'service_status' => $serviceStatus,
            'transfer_no'    => $transferNo,
            'admin_remark'   => $remark,
        ];
        $result = $this->save($data, ['service_id' => $service['service_id']]);
        if ($result === FALSE){
            $this->error = lang('system_error');
            return FALSE;
        }
        //退货退款完成时,库存还原
        if ($service['service_type'] == 1) {
            $goodsModel = new \app\common\model\Goods();
            $goodsModel->setGoodsStock($osub, $service['num']);
        }
        $commissionModel = db('store_commission');
        $where = [
            'order_id'  => $service['order_id'],
            'osku_id'   => $service['osku_id'],
            'commission_status' => 0,//收益状态(0待结算 1已结算 2已退还)
            'is_del'    => 0,
            'status'    => 1,
        ];
        //退款成功后判断当前产品是否存在佣金返利
        $commission = $commissionModel->where($where)->find();
        if ($commission) {
            $ratio = $commission['commission_ratio'];
            $skuCount = $subModel->where(['order_id' => $service['order_id'], 'osku_id' => $service['osku_id']])->count();
            //计算已退款的产品数量
            $refundCount = $this->where(['order_id' => $service['order_id'], 'osku_id' => $service['osku_id'], 'service_status' => $serviceStatus])->count();
            
            $refundAmount = round($service['refund_amount'] * $ratio/ 100, 2);
            $data = [
                'refund_amount' => ['inc', $service['refund_amount']],
                'income_amount' => ['dec', $refundAmount],
                'update_time' => time(),
            ];
            //判断当前订单商品是否已全部退款
            if ($refundCount >= $skuCount) {
                $data = ['commission_status' => 2];
            }
            $result = $commissionModel->where($where)->update($data);
            //可提现金额不变 待结算金额减少 总收益减少
            $financeModel = new \app\common\model\StoreFinance();
            $params = [
                'pending_amount'=> -$refundAmount,
                'total_amount'  => -$refundAmount,
            ];
            $result = $financeModel->financeChange($commission['store_id'], $params, '买家退款,收益退还');
        }
        $orderModel = new Order();
        $orderModel->orderLog($order, $user, '卖家退款', $remark, $service['service_id']);
        //当订单下所有产品都已经完成退款时,当前订单改为已关闭状态
        $totalCount = $this->orderSkuModel->where(['order_id' => $service['order_id']])->sum('num');
        $refundCount = db('order_sku_service')->where(['order_id' => $service['order_id'], 'service_status' => $serviceStatus])->count();
        if ($refundCount >= $totalCount) {
            //3为订单关闭状态
            $result = $orderModel->save(['order_status' => 3, 'close_refund_status' => 2], ['order_id' => $service['order_id']]);
            $orderModel->orderLog($order, [], '订单关闭', '订单产品全部退款，系统自动关闭订单');
        }else{
            //判断订单是否需要关闭退货退款
            $orderModel->orderCloseRefund($order);
        }
        return TRUE;
    }
    public function serviceRefundDetail($service)
    {
        if ($service['service_status'] && $service['service_type'] == 1) {
            $payCode = $service['sub']['pay_code'];
            $config = db('payment')->where(['pay_code' => $payCode, 'is_del' => 0, 'status' => 1])->find();
            if (!$config) {
                $this->error = lang('支付配置已删除/已禁用，请检查配置详情');
                return FALSE;
            }
            $apiType = $config['api_type'];
            $config = $config['config_json'] ? json_decode($config['config_json'], 1) : [];
            $storeId = $service['sub']['store_id'];
            switch ($apiType) {
                case 'alipay':
                    $alipayApi = new \app\common\api\AlipayPayApi($storeId, $payCode);
                    $result = $alipayApi->tradeRefundQuery($service);
                    if ($result === FALSE) {
                        $this->error = $alipayApi->error;
                        return FALSE;
                    }
                    break;
                case 'wechat':
                    $wechatApi = new \app\common\api\WechatPayApi($storeId, $payCode);
                    $result = $wechatApi->tradeRefundQuery($service);
                    if ($result === FALSE) {
                        $this->error = $wechatApi->error;
                        return FALSE;
                    }
                    break;
                default:
                    $this->error = lang('接口未开通');
                    return FALSE;
                    break;
            }
            return $result;
        }else{
            return FALSE;
        }
    }
    
    /**
     * 售后订单取消(买家)
     * @param array $service
     * @param array $user
     * @param string $remark
     * @return boolean
     */
    public function serviceCancel($service = [], $user = [], $remark = ''){
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
        //售后状态(-2已取消 -1拒绝申请 0申请中 1等待买家退货 2等待卖家退款 3退款成功)
        if ($service['service_status'] == 3) {
            $this->error = '已退款，不允许取消';
            return FALSE;
        }
        if ($service['service_status'] == -2) {
            $this->error = '已取消，不能重复操作';
            return FALSE;
        }
        $serviceStatus = -2;//取消状态
        $result = $this->save(['service_status' => $serviceStatus], ['service_id' => $service['service_id']]);
        if (!$result) {
            $this->error = $this->error;
            return FALSE;
        }
        $orderModel = new Order();
        $orderModel->orderLog($order, $user, '取消申请', $remark, $service['service_id']);
        return TRUE;
    }
    
    /**
     * 售后订单查询(买家/卖家)
     * @param string $serviceSn
     * @param array $user
     * @param int $serviceId
     * @param boolean $log
     * @return array
     */
    public function getServiceDetail($serviceSn, $user = [], $serviceId = 0, $getlog = FALSE)
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
                    $ids = db('store')->alias('S')->join([['store_dealer SD', 'S.store_id = SD.store_id', 'INNER']])->where(['S.is_del' => 0, 'SD.ostore_id' => $user['store_id']])->column('S.store_id');
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
        if ($getlog) {
            $service['logs'] = db('order_log')->where(['service_id' => $service['service_id']])->select();
        }
        $orderSkuModel = new \app\common\model\OrderSku();
        $service['sub'] = $orderSkuModel->getSubDetail($service['ossub_id'], FALSE, FALSE, TRUE);
        $service['imgs'] = $service['imgs'] ? json_decode($service['imgs'], 1) : [];
        return $service;
    }
    /**
     * 生成售后订单号
     * @param string $sn
     * @return string
     */
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