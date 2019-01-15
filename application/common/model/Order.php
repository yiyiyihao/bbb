<?php
namespace app\common\model;
use think\Model;

class Order extends Model
{
	public $error;
	public $orderSkuModel;
	public $orderSkuSubModel;
	protected $fields;
	protected $pk = 'order_id';

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
        $this->orderSkuModel = db('order_sku');
        $this->orderSkuSubModel = db('order_sku_sub');
    }
    public function getOrderList($list, $getother = FALSE)
    {
        if ($list) {
            $orderSkuModel = db('order_sku');
            $workOrderModel = db('work_order');
            foreach ($list as $key => $value) {
                $ossubId = 0;//可申请安装/售后的订单商品ID
                $list[$key]['_status'] = get_order_status($value);
                //判断订单申请安装状态
                $applyStatus = 0;
                $worderCount = $workOrderModel->where(['order_sn' => $value['order_sn'], 'work_order_status' => ['<>', -1]])->count();
                if ($worderCount > 0) {
                    $orderCount = $orderSkuModel->where(['order_id' => $value['order_id']])->sum('num');
                    if ($orderCount > $worderCount) {
                        $applyStatus = 1;
                    }else{
                        $applyStatus = 2;
                    }
                }
                if ($getother && $value['pay_status'] == 1) {
                    if ($applyStatus != 2) {
                        //获取可申请安装的订单商品
                        $where = [
                            'OSSUB.order_id'    => $value['order_id'],
                            'service_status = -2 OR service_status is NULL',
                            'work_order_status = -1 OR work_order_status is NULL',
                        ];
                        $join = [
                            ['order_sku_service OSSE', 'OSSE.ossub_id = OSSUB.ossub_id', 'LEFT'],
                            ['work_order WO', 'WO.ossub_id = OSSUB.ossub_id', 'LEFT'],
                        ];
                        $ossubId = db('order_sku_sub')->alias('OSSUB')->join($join)->where($where)->value('OSSUB.ossub_id');
                    }
                    if ($value['order_status'] == 1 && $value['close_refund_status'] != 2) {
                        $list[$key]['_workorder'] = [
                            'ossub_id' => $ossubId,
                        ];
                    }
                }
                $list[$key]['_apply_status'] = [
                    'ossub_id' => $ossubId,
                    'status' => $applyStatus,
                    'status_text' => get_order_apply_status($applyStatus),
                    'count' => $worderCount,
                ];
                if ($value['pay_code']) {
                    $list[$key]['pay_name'] = db('payment')->where(['pay_code' => $value['pay_code'], 'is_del' => 0, 'store_id' => $value['store_id']])->value('name');
                }
            }
        }
        return $list;
    }
    /**
     * 获取订单详情信息
     * @param string $orderSn   订单号
     * @param number $storeId   商户ID
     * @param number $userId    用户ID
     * @return array
     */
    public function getOrderDetail($orderSn = '', $user = [], $getlog = TRUE, $getskusub = FALSE)
    {
        if (!$orderSn) {
            return FALSE;
        }
        $order = $this->checkOrder($orderSn, $user);
        if ($order === FALSE) {
            return FALSE;
        }
        $order['_status'] = get_order_status($order);
        $payName = '';
        if ($order['pay_code']) {
            $payName = db('payment')->where(['pay_code' => $order['pay_code'], 'is_del' => 0, 'store_id' => $order['store_id']])->value('name');
        }
        $order['_pay_status'] = ['pay_code' => $order['pay_code'], 'name' => $payName, 'time' => $order['pay_time']];
        $order = $this->getOrderSkus($order, $getskusub);
        $detail['order'] = $order;
        if ($getlog) {
            $detail['logs'] = db('order_log')->where(['order_sn' => $orderSn])->order('add_time DESC, log_id DESC')->select();
//             $detail['user'] = db('user')->field('user_id, username, nickname, realname, avatar, phone, status')->where(['user_id' => $order['user_id'], 'is_del' => 0])->find();;
            $detail['store'] = db('store')->field('store_id, name')->where(['store_id' => $order['user_store_id']])->find();;
        }
        //根据条件关闭订单退换货
        if ($order['close_refund_status'] != 2 && $order['pay_status'] > 0) {
            $result = $this->orderCloseRefund($order);
        }
        return $detail;
    }
    /**
     * 订单完成/确认收货操作
     * @param string $orderSn     订单号
     * @param number $storeId   门店ID
     * @param number $userId    操作用户ID
     * @param array $extra      其它参数信息
     * @return boolean
     */
    public function orderFinish($orderSn = '', $user = [], $extra = [])
    {
        $order = $this->checkOrder($orderSn, $user);
        if (!$order) {
            return FALSE;
        }
        if ($order['order_status'] != 1) {
            $this->error = '订单已取消, 不能执行当前操作';
            return FALSE;
        }
        if (!$order['pay_status']) {
            $this->error = '订单未支付, 不能执行当前操作';
            return FALSE;
        }
        if ($order['order_type'] != 1 && !$order['delivery_status']) {
            $this->error = '订单未发货, 不能执行当前操作';
            return FALSE;
        }
        if ($order['finish_status']) {
            $this->error = '订单已完成, 不能执行当前操作';
            return FALSE;
        }
        $data = [
            'finish_status' => 2,
            'finish_time' => time(),
            'update_time' => time(),
        ];
        $result = $this->where(array('order_id' => $order['order_id']))->update($data);
        if (!$result) {
            $this->error = $this->getError();
            return FALSE;
        }
        if ($order['order_type'] != 1) {
            //修改订单产品表 已发货状态改为已收货
            $result = $this->orderSkuModel->where(['order_id' => $order['order_id'], 'delivery_status' => 1])->update(['delivery_status' => 2]);
            //修改订单产品物流表 收货状态改为1
            $result = db('order_sku_delivery')->where(['order_sn' => $orderSn])->update(['isreceive' => 1, 'receive_time' => time()]);
        }
        
        $remark = isset($extra['remark']) && trim($extra['remark']) ? trim($extra['remark']) : '';
        if ($order['order_type'] == 1) {
            $action = '确认完成';
        }else{
            $action = isset($user['admin_type']) && $user['admin_type'] == ADMIN_FACTORY ? '确认完成' : '确认收货';
        }
        $this->orderTrack($order, 0, $remark);
        return $this->orderLog($order, $user, $action, $remark);
    }
    /**
     * 订单发货操作
     * @param string $orderSn     订单号
     * @param number $storeId   门店ID
     * @param number $userId    操作用户ID
     * @param array $extra      其它参数信息
     * @return boolean
     */
    public function orderDelivery($orderSn = '', $user = [], $extra = [])
    {
        $order = $this->checkOrder($orderSn, $user);
        if (!$order) {
            return FALSE;
        }
        if ($order['order_status'] != 1) {
            $this->error = '订单已取消, 不能执行当前操作';
            return FALSE;
        }
        if (!$order['pay_status']) {
            $this->error = '订单未支付, 不能执行当前操作';
            return FALSE;
        }
        if ($order['order_type'] != 1 && ($order['delivery_status'] == 2 || $order['finish_status'])) {
            $this->error = '订单所有产品已发货, 不能执行当前操作';
            return FALSE;
        }
        $oskuIds = isset($extra['osku_id']) && $extra['osku_id'] ? $extra['osku_id'] : [];
        $oskuIds = $oskuIds ? array_filter($oskuIds) :[];
        $oskuIds = $oskuIds ? array_unique($oskuIds) :[];
        if (!$oskuIds) {
            $this->error = '请选择发货产品';
            return FALSE;
        }
        $skus = $this->orderSkuModel->where(['osku_id' => ['IN', $oskuIds], 'order_id' => $order['order_id'] , 'delivery_status' => 0])->select();
        if (!$skus || ($skus && count($skus) != count($oskuIds))) {
            $this->error = '选择产品已发货';
            return FALSE;
        }
        $ossubIds = [];
        $orderSkuSubModel = db('order_sku_sub');
        foreach ($skus as $key => $osku) {
            $subs = $orderSkuSubModel->where(['osku_id' => $osku['osku_id']])->column('ossub_id, ossub_id');
            $ossubIds = $subs ? $subs + $ossubIds : $ossubIds;
        }
        $isDelivery = isset($extra['is_delivery']) && intval($extra['is_delivery']) ? intval($extra['is_delivery']) : 0;
        $odeliveryId = 0;
        $deliveryName = $deliverySn = '';
        if ($isDelivery) {
            $deliveryIdentif = isset($extra['delivery_identif']) && trim($extra['delivery_identif']) ? trim($extra['delivery_identif']) : '';
            if (!$deliveryIdentif) {
                $this->error = '请选择物流公司';
                return FALSE;
            }
            $deliverys = get_delivery();
            if (!$deliverys[$deliveryIdentif]) {
                $this->error = '物流公司错误';
                return FALSE;
            }
            $deliverySn = isset($extra['delivery_sn']) && trim($extra['delivery_sn']) ? trim($extra['delivery_sn']) : '';
            if (!$deliverySn) {
                $this->error = '请输入第三方物流单号';
                return FALSE;
            }
            $deliveryName = $deliverys[$deliveryIdentif]['name'];
            $oskuIds = implode(',', $oskuIds);
            $ossubIds = implode(',', $ossubIds);
            $deliveryData = [
                'order_id'  => $order['order_id'],
                'order_sn'  => $order['order_sn'],
                'user_id'   => $order['user_id'],
                'osku_ids'  => $oskuIds ? $oskuIds : '',
                'ossub_ids' => $ossubIds ? $ossubIds : '',
                'delivery_identif'  => $deliveryIdentif,
                'delivery_name'     => $deliveryName,
                'delivery_status'   => 1,
                'delivery_sn'       => $deliverySn,
                'delivery_time'     => time(),
                'add_time'          => time(),
            ];
            $deliveryModel = db('order_sku_delivery');
            $odeliveryId = $deliveryModel->insertGetId($deliveryData);
            if (!$odeliveryId) {
                $this->error = '数据异常';
                return FALSE;
            }
        }
        $data = [
            'odelivery_ids'     => $odeliveryId,
            'delivery_status'   => 2, //0未发货 1部分发货 2已发货
            'delivery_time'     => time(),
            'update_time'       => time(),
        ];
        $result = $this->orderSkuModel->where(['osku_id' => ['IN', $oskuIds]])->update($data);
        if ($result === FALSE) {
            $deliveryModel->where(['odelivery_id' => $odeliveryId])->delete();
            $this->error = '操作异常';
            return FALSE;
        }
        $data = [
            'odelivery_id'      => $odeliveryId,
            'delivery_name'     => $deliveryName,
            'delivery_sn'       => $deliverySn,
            'delivery_status'   => 1,
            'delivery_time'     => time(),
            'update_time'       => time(),
        ];
        $result = $this->orderSkuSubModel->where(['ossub_id' => ['IN', $ossubIds]])->update($data);
        if ($result === FALSE) {
            $this->error = '操作异常';
            return FALSE;
        }
        $orderData = [
            'update_time'   => time(),
        ];
        //获取订单产品总数
        $orderCounts = $this->orderSkuModel->where(['order_id' => $order['order_id']])->count();
        //获取订单发货产品总数
        $deliveryCounts = $this->orderSkuSubModel->where(['order_id' => $order['order_id'], 'delivery_status' => ['>', 0]])->count();
        if ($orderCounts > $deliveryCounts) {
            $orderData['delivery_status'] = 1;
        }else{
            $orderData['delivery_status'] = 2;
        }
        $result = $this->where(array('order_id' => $order['order_id']))->update($orderData);
        if (!$result) {
            $this->error = $this->error();
            return FALSE;
        }
        if ($isDelivery) {
            $msg = '物流单号:'.$deliverySn.'('.$deliveryName.')';
        }else{
            $msg = '无需物流配送';
        }
        $remark = isset($extra['remark']) && trim($extra['remark']) ? trim($extra['remark']) : '';
        if ($remark) {
            $remark = $msg.'<br>备注：'.$remark;
        }else{
            $remark = $msg;
        }
        //订单日志
        $this->orderLog($order, $user, '订单发货', $remark);
        // 订单跟踪
        $msg = $odeliveryId ? ',等待产品揽收' : '';
        $this->orderTrack($order, $odeliveryId, '商家已发货'.$msg);
        return TRUE;
    }
    /**
     * 订单修改支付金额操作
     * @param string $orderSn
     * @param int $storeId
     * @param int $userId
     * @param array $extra
     * @return boolean
     */
    public function orderUpdatePrice($orderSn = '', $user = [], $extra = [])
    {
        $order = $this->checkOrder($orderSn, $user);
        if (!$order) {
            return FALSE;
        }
        if ($order['pay_status']) {
            $this->error = '已支付, 不能调整支付金额';
            return FALSE;
        }
        if ($order['delivery_status'] || $order['finish_status']) {
            $this->error = '已发货, 不能调整支付金额';
            return FALSE;
        }
        $remark = isset($extra['remark']) && trim($extra['remark']) ? trim($extra['remark']) : '管理员调整订单支付金额,[订单原价:'.$order['real_amount'].'元]';
        $realAmount = isset($extra['real_amount']) && floatval($extra['real_amount']) > 0 ? floatval($extra['real_amount']) : 0;
        if ($realAmount <= 0) {
            $this->error = '调整后的支付金额必须大于0';
            return FALSE;
        }
        if ($order['real_amount'] == $realAmount) {
            $this->error = '调整后的支付金额跟原有订单支付金额一致';
            return FALSE;
        }
        $data = [
            'real_amount' => $realAmount,
            'update_time' => time(),
        ];
        //调整订单支付金额
        $result = $this->where(['order_id' => $order['order_id']])->update($data);
        if ($result === FALSE) {
            $this->error = '订单操作异常';
            return FALSE;
        }
        $this->orderLog($order, $user, '调整订单支付金额', $remark);
        return TRUE;
    }
    /**
     * 订单支付操作
     * @param string $orderSn   订单号
     * @param number $storeId   门店ID
     * @param number $userId    操作用户ID
     * @param array $extra      其它参数信息
     *
     * @return boolean
     */
    public function orderPay($orderSn = '', $user = [], $extra = [])
    {
        $order = $this->checkOrder($orderSn, $user);
        if (!$order) {
            return FALSE;
        }
        /* if ($order['order_status'] != 1) {
            $this->error = '不能支付当前订单';
            return FALSE;
        } */
        if ($order['pay_status']) {
            $this->error = '已支付, 不能重复支付';
            return FALSE;
        }
        if ($order['delivery_status'] || $order['finish_status']) {
            $this->error = '已发货, 不能支付当前订单';
            return FALSE;
        }
        $payCode = isset($extra['pay_code']) ? trim($extra['pay_code']) : '';
        $paySn = '';
        if ($order['pay_type'] == 1 && $payCode != 'balance') {
            $paySn = isset($extra['pay_sn']) && trim($extra['pay_sn']) ? trim($extra['pay_sn']) : '';
            if (!$paySn) {
                $this->error = '第三方交易号不能为空';
                return FALSE;
            }
        }
        $remark = isset($extra['remark']) && trim($extra['remark']) ? trim($extra['remark']) : '';
        $paidAmount = isset($extra['paid_amount']) && floatval($extra['paid_amount']) > 0 ? floatval($extra['paid_amount']) : $order['real_amount'];
        $data = [
            'pay_status' => 1,
            'pay_time'   => time(),
            'update_time'=> time(),
        ];
        if ($paySn) {
            $data['pay_sn'] = $paySn;
        }
        if ($paidAmount > 0) {//实际支付金额
            $data['paid_amount'] = $paidAmount;
        }
        if ($payCode) {
            $data['pay_code'] = $payCode;
        }
        $order = $this->getOrderSkus($order, FALSE);
        $skus = $order['skus'];
        //将订单设置为已支付状态
        $result = $this->where(['order_id' => $order['order_id'], 'pay_status' => ['<>', 1]])->update($data);
        if ($result === FALSE) {
            $this->error = '订单操作异常';
            return FALSE;
        }
        if ($skus) {
            //处理订单产品中 库存计数为支付成功后减少库存的产品库存
            $goodsModel = new \app\common\model\Goods();
            foreach ($skus as $key => $value) {
                if ($value['stock_reduce_time'] == 2) {//支付成功后减少库存
                    $result = $goodsModel->setGoodsStock($value, -$value['num']);
                }
            }
        }
        $this->orderLog($order, $user, '支付订单', $remark);
        $this->orderTrack($order, 0, '订单已付款, 等待商家发货');
        
        if ($order['order_type'] == 1) {
            $this->orderFinish($orderSn, $user, ['remark' => '支付成功,订单完成']);
        }
        //订单支付成功后,订单入账处理
        if ($skus && $order['order_type'] == 1 && $order['user_store_id'] > 0 && $paidAmount > 0) {
            $where = [
                'is_del' => 0,
                'S.store_id' => $order['user_store_id'],
            ];
            $store = db('store')->alias('S')->join([['store_dealer SD', 'S.store_id = SD.store_id', 'INNER']])->where($where)->find();
            if ($store && $store['ostore_id']) {
                //获取厂商信息
                $factory = db('store')->where(['is_del' => 0, 'store_id' => $store['factory_id']])->find();
                if ($factory) {
                    $config = $factory['config_json'] ? json_decode($factory['config_json'], 1) : [];
                    $config = isset($config['default']) ? $config['default'] : [];
                    $ratio = $config && isset($config['channel_commission_ratio']) ? floatval($config['channel_commission_ratio']) : 0;
                    if ($ratio > 0) {
                        $dataSet = [];
                        //计算当前订单总收益
                        $totalAmount = round($order['real_amount'] * $ratio/100, 2);
                        foreach ($skus as $key => $value) {
                            $incomeAmount = round($value['real_price'] * $ratio/100, 2);//四舍五入保留小数点后两位
                            $dataSet[] = [
                                'store_id'          => $store['ostore_id'],
                                'from_store_id'     => $store['store_id'],
                                'order_id'          => $order['order_id'],
                                'order_sn'          => $order['order_sn'],
                                'osku_id'           => $value['osku_id'],
                                'goods_id'          => $value['goods_id'],
                                'sku_id'            => $value['sku_id'],
                                'order_amount'      => $value['real_price'],
                                'commission_ratio'  => $ratio,
                                'income_amount'     => $incomeAmount,
                                'add_time'          => time(),
                            ];
                        }
                        $result = db('store_commission')->insertAll($dataSet);
                        if ($result) {
                            //修改商户账户收益信息
                            $financeModel = new \app\common\model\StoreFinance();
                            $params = [
                                'pending_amount' => $totalAmount,
                                'total_amount' => $totalAmount,
                            ];
                            $result = $financeModel->financeChange($store['ostore_id'], $params, '订单支付,计算收益', $order['order_sn']);
                        }
                    }
                }
            }
        }
        return TRUE;
    }
    /**
     * 订单取消操作
     * @param string $orderSn   订单号
     * @param number $storeId   商户ID
     * @param number $userId    操作用户ID
     * @param string $remark    操作备注
     * @return boolean
     */
    public function orderCancel($orderSn = '', $user = [], $remark = ''){
        $order = $this->checkOrder($orderSn, $user);
        if ($order === FALSE) {
            return FALSE;
        }
        if (!$user) {
            $this->error = '参数错误';
            return FALSE;
        }
        if ($order['order_status'] != 1) {
            $this->error = '不能取消当前订单';
            return FALSE;
        }
        if ($order['pay_status']) {
            $this->error = '已支付, 不能取消当前订单';
            return FALSE;
        }
        if ($order['delivery_status'] || $order['finish_status']) {
            $this->error = '已发货, 不能取消当前订单';
            return FALSE;
        }
        $result = $this->save(['order_status' => 2], ['order_id' => $order['order_id']]);
        if (!$result) {
            $this->error = $this->error;
            return FALSE;
        }
        //取消订单，产品库存增加
        $order = $this->getOrderSkus($order);
        $skus = $order['skus'];
        if ($skus) {
            $goodsModel = new \app\common\model\Goods();
            foreach ($skus as $key => $value) {
                if ($value['stock_reduce_time'] == 1) {
                    $goodsModel->setGoodsStock($value, $value['num']);
                }
            }
        }
        $this->orderTrack($order, 0, $remark);
        $this->orderLog($order, $user, '取消订单', $remark);
        return TRUE;
    }
    public function createOrder($user, $from, $skuId, $num, $submit = FALSE, $addr = [], $remark = '', $orderType = 1)
    {
        if (!$user) {
            $this->error = lang('param_error');
            return FALSE;
        }
        if (($orderType == 1 && !isset($user['user_id'])) || ($orderType == 2 && !isset($user['udata_id']))) {
            $this->error = lang('param_error');
            return FALSE;
        }
        $userId = isset($user['user_id'])? intval($user['user_id']) : 0;
        if ($from == 'goods') {
            $goodsModel = new \app\common\model\Goods();
            $sku = $goodsModel->checkSku($skuId);
            if ($sku === FALSE) {
                $this->error = $goodsModel->error;
                return FALSE;
            }
            if ($num <= 0) {
                $this->error = '产品购买数量必须大于0';
                return FALSE;
            }
            //判断产品库存
            if ($sku['sku_stock'] < $num) {
                $this->error = '产品库存限制('.$sku['sku_stock'].')';
                return FALSE;
            }
            $incart = FALSE;
        }else{
            $this->error = '订单来源错误';
            return FALSE;
        }
        $list = $this->_getCartDatas($user, $incart, $skuId, $num);
        if ($list === FALSE) {
            return FALSE;
        }
        if (!$submit) {
            return $list;
        }else{
            $storeId = $list['store_id'];
            //收货地址
            $addrName = isset($addr['address_name']) && $addr['address_name'] ? trim($addr['address_name']) : '';
            $addrPhone = isset($addr['address_phone']) && $addr['address_phone'] ? trim($addr['address_phone']) : '';
            $regionId = isset($addr['region_id']) && $addr['region_id'] ? trim($addr['region_id']) : '';
            $addrRegion = isset($addr['region_name']) && $addr['region_name'] ? trim($addr['region_name']) : '';
            $addrDetail = isset($addr['address']) && $addr['address'] ? trim($addr['address']) : '';
            if ($orderType != 1 && (!$addrName || !$addrPhone || !$addrRegion || !$regionId || !$addrDetail)) {
                $this->error = '收货人姓名/电话/地址 不能为空';
                return FALSE;
            }
            $userModel = new \app\common\model\User();
            //验证手机号格式
            $result = $userModel->checkPhone(0, $addrPhone);
            if ($result === FALSE) {
                $this->error = $userModel->error;
                return FALSE;
            }
            if ($list['all_amount'] <= 0) {
                $this->error = '订单支付金额不能小于等于0';
                return FALSE;
            }
            //创建订单
            $orderSn = $this->_getOrderSn();
            $orderData = [
                'order_type'    => $orderType,   //1商户订单:支付成功后自动完成
                'order_sn'      => $orderSn,
                'store_id'      => $storeId,
                
                'user_id'       => $userId,
                'user_store_id' => isset($user['store_id']) ? intval($user['store_id']) : 0,
                'user_store_type' => isset($user['store_type']) ? intval($user['store_type']) : 0,
                
                'udata_id'      => isset($user['udata_id'])? intval($user['udata_id']) : 0,
                
                'goods_amount'  => $list['sku_amount'],
                'install_amount'=> $list['install_amount'],
                'delivery_amount'=> $list['delivery_amount'],
                'real_amount'   => $list['pay_amount'],
                'address_name'  => $addrName,
                'address_phone' => $addrPhone,
                'region_id'     => $regionId,
                'address_detail'=> $regionId ? ($addrRegion.' '.$addrDetail) : '',
                'remark'        => trim($remark),
                'add_time'      => time(),
                'update_time'   => time(),
                'extra'         => '',
            ];
            $orderModel = db('order');
            $orderSkuModel = db('order_sku');
            $orderSkuSubModel = db('order_sku_sub');
            try{
                $goodsModel = new \app\common\model\Goods();
                $skus = $storeIdArray = $cartIds = [];
                $orderId = $orderModel->insertGetId($orderData);
                if (!$orderId) {
                    $this->error = '订单创建失败';
                    return FALSE;
                }
                foreach ($list['skus'] as $key => $value) {
                    $skuId = $key;
                    if ($value) {
                        $goodsAmount = $value['num']*($value['price'] + $value['install_price']);
                        $deliveryAmount = isset($value['delivery_amount']) ? $value['delivery_amount'] : 0;
                        $skuInfo = $goodsModel->checkGoods($value['goods_id']);
                        $sku = [
                            'order_id'      => $orderId,
                            'order_sn'      => $orderSn,
                            'store_id'      => $list['store_id'],
                            
                            'user_id'       => $userId,
                            'user_store_id' => isset($user['store_id']) ? intval($user['store_id']) : 0,
                            
                            'udata_id'      => isset($user['udata_id'])? intval($user['udata_id']) : 0,
                            
                            'goods_id'      => $value['goods_id'],
                            'sku_id'        => $value['sku_id'],
                            'goods_type'    => $value['goods_type'],
                            'sku_name'      => $value['name'],
                            'sku_thumb'     => $skuInfo['thumb'] ? $skuInfo['thumb'] : '',
                            'sku_spec'      => $value['sku_name'],
                            'sku_spec'      => $value['spec_value'],
                            'sku_info'      => $skuInfo ? json_encode($skuInfo) : '',
                            'num'           => $value['num'],
                            
                            'sku_price'     => $value['price'],
                            'install_price' => $value['install_price'],
                            'price'         => $value['pay_price'],
                            'delivery_price'   => $deliveryAmount,
                            'real_price'       => $goodsAmount+$deliveryAmount,
                            'stock_reduce_time' => $value['stock_reduce_time'],
                            
                            'add_time'      => time(),
                            'update_time'   => time(),
                        ];
                        $oskuId = $orderSkuModel->insertGetId($sku);
                        if (!$oskuId) {
                            break;
                        }
                        for ($i = 0; $i < $value['num']; $i++) {
                            $dataSet[] = [
                                'good_sku_code' => $this->_getGoodsSkuCode('auto', $value['sku_sn']),
                                'order_id'      => $orderId,
                                'order_sn'      => $orderSn,
                                'store_id'      => $list['store_id'],
                                'osku_id'       => $oskuId,
                                
                                'user_id'       => $userId,
                                'user_store_id' => isset($user['store_id']) ? intval($user['store_id']) : 0,
                                
                                'udata_id'      => isset($user['udata_id'])? intval($user['udata_id']) : 0,
                                
                                'goods_id'      => $value['goods_id'],
                                'sku_id'        => $value['sku_id'],
                                
                                'sku_price'     => $value['price'],
                                'install_price' => $value['install_price'],
                                'price'         => $value['pay_price'],
                                'delivery_price'   => $deliveryAmount,
                                'real_price'       => $value['pay_price'] + $deliveryAmount,
                                
                                'add_time'      => time(),
                                'update_time'   => time(),
                            ];
                        }
                        $result = $orderSkuSubModel->insertAll($dataSet);
                        if ($result === FALSE) {
                            break;
                        }
                        if ($value['stock_reduce_time'] == 1) {
                            $skus[$skuId] = [
                                'sku_id'    => $value['sku_id'],
                                'goods_id'  => $value['goods_id'],
                                'num'       => $value['num'],
                            ];
                        }
                        if (isset($value['cart_id']) && $value['cart_id']) {
                            $cartIds[] = $value['cart_id'];
                        }
                        $orderData['order_id'] = $orderId;
                        $logId = $this->orderLog($orderData, $user, '创建订单', '提交购买商品并生成订单');
                        $trackId = $this->orderTrack($orderData, 0, '订单已提交, 系统正在等待付款');
                    }
                }
                if ($skus) {
                    //减少商品库存
                    foreach ($skus as $key => $value) {
                        $result = $goodsModel->setGoodsStock($value, -$value['num']);
                    }
                }
                #TODO 清理购物车产品
                /* if ($from == 'cart' && $cartIds) {
                    //清理购物车产品
                    $cartIds = implode(',', $cartIds);
                    $result = $this->delCartSku($cartIds, true);
                } */
                return $orderData;
            }catch(\Exception $e){
                $error = $e->getMessage();
                $this->error = $error;
                return FALSE;
            }
        }
    }
    
    /**
     * 订单关闭退货退款功能操作
     * @param string $orderSn   订单号
     * @param number $storeId   商户ID
     * @param number $userId    操作用户ID
     * @param string $remark    操作备注
     * @return boolean
     */
    public function orderCloseRefund($order = [], $user = [], $remark = ''){
        if (!$order) {
            $this->error = lang('param_error');
            return FALSE;
        }
        if (!$user) {
            $user = ['user_id' => 0, 'nickname' => '系统'];
        }
        $skus = isset($order['skus']) ? $order['skus'] : [];
        if (!$skus) {
            $order = $this->getOrderSkus($order);
            $skus = $order['skus'];
        }
        $oskuIds = array_column($skus, 'osku_id');
        if ($order['order_status'] != 1) {
            $this->error = lang('NO_OPERATE_PERMISSION');
            return FALSE;
        }
        if (!$order['pay_status']) {
            $this->error = '未支付,无操作权限';
            return FALSE;
        }
        if ($order['close_refund_status'] == 2) {//0未关闭 1部分关闭  2已关闭
            $this->error = '售后申请已关闭';
            return FALSE;
        }
        $closeFlag = 0;
        $config = get_store_config($order['store_id'], TRUE, 'default');
        if ($config) {
            //退货退款时间限制
            $returnTime = $config['order_return_day'] * 24 * 60 * 60;
            if ($returnTime > 0 && $order['pay_status'] > 0 && ($order['pay_time'] + $returnTime) <= time()) {
                $closeFlag = 1;
            }
        }
        $refundStatus = $order['close_refund_status'];
        $orderSkuServiceModel = db('order_sku_service');
        if ($closeFlag){
            //判断当前订单下的商品是否存在处理中的售后申请，存在则不关闭 (售后状态(-2已取消 -1拒绝申请 0申请中 1等待买家退货 2等待买家退款 3退款成功))
            $service = $orderSkuServiceModel->where(['order_id' => $order['order_id'], 'service_status' => ['IN', [0, 1, 2]]])->find();
            if ($service) {
                //存在处理中的售后申请(申请状态关闭部分)
                $refundStatus = 1;
            }else{
                $refundStatus = 2;
            }
            if ($order['close_refund_status'] != $refundStatus) {
                $result = $this->save(['close_refund_status' => $refundStatus], ['order_id' => $order['order_id']]);
            }
            //判断当前订单下单商户是否是零售商订单 & 订单关闭退款退货功能后,订单结算处理(部分关闭不结算)
            if ($order['user_store_id'] == ADMIN_DEALER && $refundStatus == 2) {
                $where = [
                    'order_id' => $order['order_id'],
                    'osku_id' => ['IN', $oskuIds],
                ];
                $commissionModel = db('store_commission');
                $commissions = $commissionModel->where($where)->select();
                if ($commissions) {
                    foreach ($commissions as $key => $commission) {
                        $ratio = $commission['commission_ratio'];
                        if ($ratio > 0) {
                            $commissionAmount = $commission['income_amount'];
                            //计算某个订单商品的退款金额
                            $refundAmount = $orderSkuServiceModel->where(['order_id' => $order['order_id'], 'osku_id' => $commission['order_id'], 'service_status' => 3])->sum('refund_amount');
                            $refundAmount = $refundAmount > 0 ? round($refundAmount * $ratio/100, 2) : 0;
                            $incomeAmount = round($commissionAmount - $refundAmount, 2);
                            $result = $commissionModel->where($where)->update(['commission_status' => 1, 'refund_amount' => $refundAmount, 'income_amount' => $incomeAmount, 'update_time' => time()]);
                            if ($result > 0) {
                                //可提现金额增加 待结算金额减少 总收益不变
                                $financeModel = new \app\common\model\StoreFinance();
                                $params = [
                                    'amount' => $incomeAmount,
                                    'pending_amount' => -$commissionAmount,
                                ];
                                if ($refundAmount > 0) {
                                    $params['total_amount'] = -$refundAmount;
                                }
                                $result = $financeModel->financeChange($commission['store_id'], $params, '订单收益入账', $order['order_sn']);
                            }
                        }
                    }
                }
                $remark = $remark ? $remark : '系统自动关闭退货退款功能';
                $this->orderTrack($order, 0, $remark);
                $this->orderLog($order, [], '关闭退货退款功能', $remark);
            }
        }
        return TRUE;
    }
    /**
     * 订单跟踪信息入库
     * @param array $sub            订单信息
     * @param number $odeliveryId   订单交易物流ID(order_sku_delivery表自增长ID)
     * @param string $remark        备注信息
     * @param string $time          信息跟踪时间
     * @return boolean
     */
    public function orderTrack($order = [], $odeliveryId = 0, $remark = '', $time = false){
        if (!$order){
            $this->error = '参数错误';
            return FALSE;
        }
        $time = $time ? $time : time();
        //添加订单跟踪记录
        $trackData = [
            'odelivery_id'  => $odeliveryId,
            'order_id'  => isset($order['order_id']) ? $order['order_id'] : '',
            'order_sn'  => isset($order['order_sn']) ? $order['order_sn'] : '',
            'msg'       => $remark ? $remark : '',
            'time'      => $time,
            'add_time'  => time(),
        ];
        $trackId = db('order_track')->insertGetId($trackData);
        if (!$trackId){
            $this->error = '订单信息跟踪:系统异常';
            return FALSE;
        }
        return TRUE;
    }
    /**
     * 订单日志记录操作
     * @param array $order
     * @param array $user
     * @param string $action
     * @param string $msg
     * @return number|string
     */
    public function orderLog($order, $user, $action = '', $msg = '', $serviceId = 0)
    {
        $udataId = $userId = 0;
        if($user && isset($user['user_id']) && $user['user_id'] > 0){
            $nickname = isset($user['realname']) && $user['realname'] ? $user['realname'] : (isset($user['nickname']) && $user['nickname'] ? $user['nickname'] : (isset($user['username']) && $user['username'] ? $user['username'] : ''));
            $nickname = $nickname ? $nickname : '用户';
            if ($order['user_store_id'] == $user['store_id']) {
                $nickname = '[买家]'.$nickname;
            }else{
                $nickname = '[卖家]'.$nickname;
            }
            $userId = $user['user_id'];
        }elseif($user && isset($user['udata_id']) && $user['udata_id'] > 0){
            $nickname = isset($user['realname']) && $user['realname'] ? $user['realname'] : (isset($user['nickname']) && $user['nickname'] ? $user['nickname'] : (isset($user['username']) && $user['username'] ? $user['username'] : ''));
            if (!$nickname) {
                $nickname = db('user_data')->where(['udata_id' => $user['udata_id']])->value('nickname');
                $nickname = $nickname ? $nickname : '用户';
            }
            $nickname = '[买家]'.$nickname;
            $udataId = $user['udata_id'];
        }else{
            $nickname = '系统';
        }
        $data = [
            'order_id'  => $order['order_id'],
            'order_sn'  => $order['order_sn'],
            'service_id'=> $serviceId,
            'user_id'   => $userId,
            'udata_id'  => $udataId,
            'nickname'  => $nickname,
            'action'    => $action,
            'msg'       => $msg,
            'add_time'  => time(),
        ];
        return $result = db('order_log')->insertGetId($data);
    }
    public function checkOrder($orderSn = '', $user = [])
    {
        if (!$orderSn) {
            $this->error = '订单号不能为空';
            return FALSE;
        }
        if (!$user) {
            $this->error = '参数错误';
            return FALSE;
        }
        $where = ['order_sn' => $orderSn];
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
        }elseif (isset($user['udata_id']) && $user['udata_id'] > 0) {
            $where['udata_id'] = $user['udata_id'];
        }
        $order = $this->where($where)->find();
        if (!$order) {
            $this->error = lang('NO ACCESS');
            return FALSE;
        }
        return $order;
    }
    public function getOrderPayments($storeId = 0, $displayType = 0)
    {
        $where = ['store_id' => $storeId, 'is_del' => 0, 'status' => 1];
        if ($displayType) {
            $where['display_type'] = $displayType;
        }
        return $payments = db('payment')->order('sort_order ASC, add_time DESC')->where($where)->select();
    }
    public function getOrderSkus($order, $getsub = FALSE)
    {
        $oskus = db('order_sku')->where(['order_id' => $order['order_id']])->select();
        if ($oskus && $getsub) {
            $orderSkuSubModel = db('order_sku_sub');
            $orderSkuServiceModel = db('order_sku_service');
            $workOrderModel = db('work_order');
            foreach ($oskus as $key => $osku) {
                $subs = $orderSkuSubModel->where(['osku_id' => $osku['osku_id']])->select();
                if ($subs) {
                    foreach ($subs as $key1 => $sub) {
                        if ($order['close_refund_status'] != 2) {
                            //获取未取消的售后申请(售后状态(-2已取消 -1拒绝申请 0申请中 1等待买家退货 2等待买家退款 3退款成功))
                            $service = $orderSkuServiceModel->order('add_time DESC, service_id DESC')->where(['ossub_id' => $sub['ossub_id']])->find();
                        }
                        $subs[$key1]['service'] = isset($service) ? $service : [];
                        //获取安装工单(状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成))
                        $subs[$key1]['work_order'] = $workOrderModel->order('add_time DESC, worder_id DESC')->where(['ossub_id' => $sub['ossub_id']])->find();
                    }
                }
                $oskus[$key]['subs'] = $subs;
            }
        }
        $order['skus'] = $oskus;
        return $order;
    }
    /**
     * 更新快递100数据
     * @param  string 	$order_sn  订单号 (必传)
     * @param  string 	$o_d_id  订单物流主键id (必传)
     * @return [boolean]
     */
    public function updateApi100($orderSn, $user, $odeliveryId) {
        $order = $this->checkOrder($orderSn, $user);
        if (!$order) {
            return FALSE;
        }
        if (!$odeliveryId) {
            $this->error = '物流数据不能为空';
            return FALSE;
        }
        $delivery = db('order_sku_delivery')->where(['odelivery_id' => $odeliveryId])->find();
        if (!$delivery) {
            $this->error = '物流信息不存在';
            return FALSE;
        }
        if(!$delivery['delivery_sn']){
            $this->error = '物流单号不存在';
            return FALSE;
        }
        // 获取物流标识
        $identif = $delivery['delivery_identif'];
        if (!$identif) {
            $this->error = '物流唯一标志号码不存在';
            return FALSE;
        }
        if (in_array($delivery['delivery_status'], [3, 6])) {
            return TRUE;
        }
        // 统计当前已发货物流跟踪条数、和最后一条记录
        $where = [
            'odelivery_id' => $odeliveryId,
            'order_sn' => $orderSn,
        ];
        $trackModel = db('order_track');
        $count = $trackModel->where($where)->count();
        $track = $trackModel->where($where)->field('order_sn, time')->order('track_id DESC')->find();
        $datas = $this->_kuaidi100($identif, $delivery['delivery_sn']);
        if ($datas === FALSE){
            return FALSE;
        }
        krsort($datas['data']);
        foreach($datas['data'] as $v){
            $_time = isset($v['time']) && $v['time'] ? strtotime($v['time']): '';
            if ($count != 1 && $_time <= $track['time']) {
                continue;
            }
            $time = $_time ? $_time : time();
            $this->orderTrack($order, $odeliveryId, $v['context'], $time);
        }
        $data = [];
        if (isset($datas['message']) && $datas['message'] && $delivery['delivery_msg'] != $datas['message']) {
            $data['delivery_msg'] = $datas['message'];
        }
        if (isset($datas['state']) && $datas['state'] && $delivery['delivery_status'] != $datas['state']) {
            $data['delivery_status'] = $datas['state'];
        }
        if ($data) {
            db('order_sku_delivery')->where(['odelivery_id' => $odeliveryId])->update($data);
        }
        return TRUE;
    }
    /**
     * 根据快递单号查询快递100获取快递信息
     * @param  string 	$com  	快递代码 (必传)
     * @param  string 	$nu  	快递单号 (必传)
     * @return [result]
     */
    private function _kuaidi100($identif = '' , $deliverySn = '') {
        if(empty($identif) || empty($deliverySn)) {
            $this->error = '快递请求错误';
            return FALSE;
        }
        $url = 'http://www.kuaidi100.com/query?';
        $params = [
            'id' => 1,
            'type' => $identif,
            'postid' => $deliverySn,
        ];
        $url .= http_build_query($params);
        $result = curl_post($url, []);
        if($result) {
            if ($result['status'] == 200) {
                unset($result['status']);
                switch ($result['state']) {
                    case '0':
                        $result['message'] = '运输中';
                        break;
                    case '1':
                        $result['message'] = '已揽件';
                        break;
                    case '2':
                        $result['message'] = '疑难件';
                        break;
                    case '3':
                        $result['message'] = '已签收';
                        break;
                    case '4':
                        $result['message'] = '已退签';
                        break;
                    case '5':
                        $result['message'] = '派送中';
                        break;
                    case '6':
                        $result['message'] = '已退回';
                        break;
                    default:
                        $result['message'] = '其他';
                        break;
                }
                return $result;
            } else if($result['status'] == 201) {
                $this->error = $result['message'];
                return FALSE;
            } else if($result['status'] == 2) {
                $this->error = '接口出现异常';
                return FALSE;
            } else {
                $this->error = '物流单暂无结果'.$result['message'];
                return FALSE;
            }
        } else {
            $this->error = '查询失败，请稍候重试';
            return FALSE;
        }
    }
    /**
     * 获取购物车数据
     * @param array $user
     * @param bool $incart
     * @param array|int $skuIds
     * @param int $num
     * @return array
     */
    private function _getCartDatas($user = [], $incart = FALSE, $skuIds = [], $num = 0)
    {
        $userId = isset($user['user_id'])? intval($user['user_id']) : 0;
        if ($incart) {
        }else{
            $where = [
                'sku_id' => intval($skuIds),
            ];
            $join = [['goods G', 'G.goods_id = S.goods_id', 'INNER']];
            $field = 'S.store_id, S.sku_id, S.sku_sn, S.goods_type, G.goods_id, G.name, S.sku_name, S.price, S.install_price, '.$num.' as num, S.sample_purchase_limit,  S.sku_thumb, G.thumb, S.sku_stock, S.stock_reduce_time, S.spec_value, G.is_del as gdel, G.status as gstatus, S.status as sstatus, S.is_del as sdel';
            $list = db('GoodsSku')->alias('S')->join($join)->field($field)->where($where)->limit(1)->select();
            if (!$list) {
                $this->error = '产品不存在或已删除';
                return FALSE;
            }
        }
        $carts = $datas = $storeIds = [];
        $skuCount = $skuTotal = $deliveryAmount = $skuAmount = $installAmount = $payAmount = 0;
        if ($list) {
            $storeModel = db('store');
            $skuList = $skus = $storeAmounts = [];
            foreach ($list as $key => $value) {
                $skuList[] = $skuId = $value['sku_id'];
                $num = intval($value['num']);
                //样品限制单个用户购买数量
                if ($value['goods_type'] == 2 && $value['sample_purchase_limit'] > 0) {
                    $count = db('order')->alias('O')->join('order_sku OS', 'O.order_id = OS.order_id', 'INNER')->where(['sku_id' => $skuId, 'order_status' => 1])->count();
                    $total = $count + $num;
                    if ($total > $value['sample_purchase_limit']) {
                        $this->error = '单个用户样品限购数量为('.$value['sample_purchase_limit'].')';
                        return FALSE;
                    }
                }
                $storeIds[$value['store_id']] = $storeId = $value['store_id'];
                
                //产品库存为0/已删除/已禁用 则为 已失效
                $amount = 0;
                $disable = $unsale = 0;
                //判断购买数量是否大于库存数量
                if ($value['sku_stock'] <= 0 || $value['sku_stock'] < $num) {
                    $disable = 1; //库存不足
                }elseif($value['sdel'] || $value['gdel']|| !$value['gstatus']|| !$value['sstatus']){
                    $unsale = 1; //已下架
                }else{
                    $installAmount  = $installAmount + ($value['install_price'] * $num);
                    $skuCount++;
                    $skuTotal = $skuTotal + $num;
                    $skuAmount = $skuAmount + ($value['price'] * $num);
                }
                $value['pay_price'] = $value['price'] + $value['install_price'];
                if (isset($value['sku_thumb']) && $value['sku_thumb']) {
                    $value['sku_thumb'] = trim($value['sku_thumb']);
                }elseif (isset($value['thumb']) && $value['thumb']){
                    $value['sku_thumb'] = trim($value['thumb']);
                }else{
                    $value['sku_thumb'] = '';
                }
                $value['disable'] = $disable;
                $value['unsale'] = $unsale;
                unset($value['gdel'], $value['gstatus'],$value['sstatus'], $value['sdel'], $value['thumb']);
                $skus[$skuId] = $value;
            }
            $store = $storeModel->field('store_id, name')->where(['store_id' => $storeId])->find();
            $skuIds = !empty($skuIds) ? $skuIds : implode(',', $skuList);
            if (count($storeIds) > 1) {
                $this->error = '不允许跨厂商购买产品';
                return FALSE;
            }
            if (!$skus || !$storeIds) {
                $this->error = '请选择购买产品';
                return FALSE;
            }
        }
        $payAmount = $allAmount = $skuAmount + $installAmount + $deliveryAmount;
        $return = [
            'skus'      => $skus,                  //产品列表
            'sku_total' => intval($skuTotal),       //产品总数量
            'sku_count' => intval($skuCount),       //产品种类数量(不重复)
            'all_amount'        => sprintf("%.2f",$allAmount),      //产品总金额
            'delivery_amount'   => sprintf("%.2f",$deliveryAmount), //物流费用
            'install_amount'    => sprintf("%.2f",$installAmount),  //安装费用
            'sku_amount'        => sprintf("%.2f",$skuAmount),      //产品总金额
            'pay_amount'        => sprintf("%.2f",$payAmount),      //需支付金额
            'sku_ids'           => $skuIds,
            'store_id'          => $storeId,
        ];
        return $return;
    }
    /**
     * 生成订单编号
     * @param string $sn
     * @return string
     */
    private function _getOrderSn($sn = '')
    {
        $sn = date('YmdHis').substr(implode(NULL, array_map('ord', str_split(substr(uniqid(), 7, 13), 1))), 0, 6).get_nonce_str(9, 2);
        $exist = $this->where(['order_sn' => $sn])->find();
        if ($exist) {
            return $this->_getOrderSn();
        }else{
            return $sn;
        }
    }
    /**
     * 生成产品唯一串码
     * @param string $code
     * @return string
     */
    private function _getGoodsSkuCode($prex = '', $skuSn = '')
    {
        $code = $prex.'_'.$skuSn.'_'.get_nonce_str(10, 2);
        $exist = db('order_sku_sub')->where(['good_sku_code' => $code])->find();
        if ($exist) {
            return $this->_getGoodsSkuCode();
        }else{
            return $code;
        }
    }
}