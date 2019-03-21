<?php
namespace app\open\controller\v10\order;

use app\open\controller\Base;
use think\Request;

class Order extends Base
{
    private $orderModel;
    private $user;
    private $error = FALSE;
    private $postParams;
    private $sellerLimit = FALSE;
    
    public function __construct(Request $request)
    {
        parent::__construct();
        $this->orderModel = new \app\common\model\Order();
        $this->postParams = $request->param();
        $this->user = $this->postParams['user'];
        /**
         * Error 开头:003000
         */
    }
    /**
     * 获取卖家订单列表
     * @return \think\response\Json
     */
    public function index()
    {
        $field = 'order_id, order_type, order_sn, real_amount, address_name, address_phone, address_detail, order_status, pay_status, delivery_status, finish_status, add_time';
        $where = [
            ['seller_udata_id', '=', $this->user['udata_id']],
            ['order_type', '=', 2],
        ];
        $result = $this->getModelList($this->orderModel, $where, $field, 'add_time ASC');
        if ($result && isset($result['list'])) {
            foreach ($result['list'] as $key => $value) {
                $where = [
                    ['order_id', '=', $value['order_id']],
                ];
                $skus = model('order_sku')->field('sku_id, sku_name, sku_thumb, sku_spec, num, price')->where($where)->select();
                $result['list'][$key]['skus'] = $skus;
                $result['list'][$key]['_status'] = get_order_status($value);
                unset($result['list'][$key]['order_id'], $result['list'][$key]['order_type']);
            }
        }
        return $this->dataReturn(0, 'ok', $result);
    }
    /**
     * 获取买家下单订单列表
     * @return \think\response\Json
     */
    public function list()
    {
        $field = 'order_id, order_type, order_sn, real_amount, address_name, address_phone, address_detail, order_status, pay_status, delivery_status, finish_status, add_time';
        $where = [
            ['udata_id', '=', $this->user['udata_id']],
            ['order_type', '=', 2],
        ];
        $result = $this->getModelList($this->orderModel, $where, $field, 'add_time ASC');
        if ($result && isset($result['list'])) {
            foreach ($result['list'] as $key => $value) {
                $where = [
                    ['order_id', '=', $value['order_id']],
                ];
                $skus = model('order_sku')->field('sku_id, sku_name, sku_thumb, sku_spec, num, price')->where($where)->select();
                $result['list'][$key]['skus'] = $skus;
                $result['list'][$key]['_status'] = get_order_status($value);
                unset($result['list'][$key]['order_id'], $result['list'][$key]['order_type']);
            }
        }
        return $this->dataReturn(0, 'ok', $result);
    }
    /**
     * 订单支付
     */
    public function pay()
    {
        $info = $this->_verifyOrder();
        if ($this->error) {
            return $info;
        }
        $payCode = isset($this->postParams['pay_code']) ? trim($this->postParams['pay_code']) : '';
        $paySn = isset($this->postParams['pay_sn']) ? trim($this->postParams['pay_sn']) : '';
        $remark = isset($this->postParams['remark']) ? trim($this->postParams['remark']) : '';
        
        if (!$payCode) {
            return $this->dataReturn('003018', 'missing pay_code');
        }
        if ($info['order_status'] === 2) {
            return $this->dataReturn('003015', 'order cancelled');
        }
        if ($info['order_status'] === 3) {
            return $this->dataReturn('003016', 'order closed');
        }
        if ($info['pay_status'] !== 0) {
            return $this->dataReturn('003017', 'order paid');
        }
        $params = [
            'pay_code'  => $payCode,
            'pay_sn'    => $paySn,
            'remark'    => $remark,
        ];
        $result = $this->orderModel->orderPay($info['order_sn'], $this->user, $params);
        if ($result === FALSE) {
            return $this->dataReturn('003014', $this->orderModel->error);
        }
        return $this->dataReturn(0, 'ok');
    }
    /**
     * 订单发货
     * @return \think\response\Json|array|\think\response\Json
     */
    public function delivery()
    {
        $this->sellerLimit = TRUE;
        $info = $this->_verifyOrder();
        if ($this->error) {
            return $info;
        }
        $oskuIds = isset($this->postParams['osku_ids']) ? $this->postParams['osku_ids']: [];
        $remark = isset($this->postParams['remark']) ? trim($this->postParams['remark']) : '';
        if (!$oskuIds) {
            return $this->dataReturn('003019', 'missing osku_ids');
        }
        if (!is_array($oskuIds)) {
            return $this->dataReturn('003020', 'invalid osku_ids');
        }
        $orderSkuModel = new \app\common\model\OrderSku();
        foreach ($oskuIds as $key => $value) {
            if (intval($value) <= 0) {
                return $this->dataReturn('003020', 'invalid osku_ids');
            }
            $where = [
                ['order_id', '=', $info['order_id']],
                ['osku_id', '=', $value],
            ];
            //判断订单商品是否存在
            $exist = $orderSkuModel->where($where)->find();
            if (!$exist) {
                return $this->dataReturn('003020', 'invalid osku_ids');
            }
        }
        if ($info['order_status'] === 2) {
            return $this->dataReturn('003015', 'order cancelled');
        }
        if ($info['order_status'] === 3) {
            return $this->dataReturn('003016', 'order closed');
        }
        if ($info['pay_status'] !== 1) {
            return $this->dataReturn('003017', 'order not paid');
        }
        if ($info['delivery_status'] === 2) {
            return $this->dataReturn('003021', 'order has been shipped');
        }
        $params = [
            'is_delivery'   => 0,
            'osku_id'       => $oskuIds,
            'remark'        => $remark,
        ];
        $result = $this->orderModel->orderDelivery($info['order_sn'], $this->user, $params);
        if ($result === FALSE) {
            return $this->dataReturn('003014', $this->orderModel->error);
        }
        return $this->dataReturn(0, 'ok');
    }
    /**
     * 订单完成
     * @return \think\response\Json|array|\think\response\Json
     */
    public function finish()
    {
        $info = $this->_verifyOrder();
        if ($this->error) {
            return $info;
        }
        $remark = isset($this->postParams['remark']) ? trim($this->postParams['remark']) : '';
        if ($info['order_status'] === 2) {
            return $this->dataReturn('003015', 'order cancelled');
        }
        if ($info['order_status'] === 3) {
            return $this->dataReturn('003016', 'order closed');
        }
        if ($info['pay_status'] !== 1) {
            return $this->dataReturn('003017', 'order not paid');
        }
        if ($info['delivery_status'] !== 2) {
            return $this->dataReturn('003021', 'order not shipped');
        }
        if ($info['finish_status'] === 2) {
            return $this->dataReturn('003025', 'order has been completed');
        }
        $params = [
            'remark'        => $remark,
        ];
        $result = $this->orderModel->orderFinish($info['order_sn'], $this->user, $params);
        if ($result === FALSE) {
            return $this->dataReturn('003014', $this->orderModel->error);
        }
        return $this->dataReturn(0, 'ok');
    }
    
    public function info()
    {
        $field = 'order_id, order_type, order_sn, goods_amount, delivery_amount, real_amount, install_amount, paid_amount, pay_code, address_name, address_phone, address_detail';
        $field .= ', order_status, pay_status, delivery_status, finish_status, add_time, cancel_time, pay_time, finish_time';
        $info = $this->_verifyOrder(FALSE, $field);
        if ($this->error) {
            return $info;
        }
        $info['_status'] = get_order_status($info);
        //获取订单商品列表
        $where = [
            ['order_id', '=', $info['order_id']],
        ];
        $skus = model('order_sku')->field('osku_id, sku_id, goods_id, sku_name, sku_thumb, sku_spec, num, price, delivery_status, delivery_time')->where($where)->select();
        if ($skus) {
            foreach ($skus as $key => $value) {
                $skus[$key]['delivery_time'] = $value['delivery_time'] ? time_to_date($value['delivery_time']) : '';
            }
        }
        $info['skus'] = $skus;
        unset($info['order_id'], $info['order_type']);
        $info['cancel_time'] = $info['cancel_time'] ? time_to_date($info['cancel_time']) : '';
        $info['pay_time'] = $info['pay_time'] ? time_to_date($info['pay_time']) : '';
        $info['finish_time'] = $info['finish_time'] ? time_to_date($info['finish_time']) : '';
        
        return $this->dataReturn(0, 'ok', $info);
    }
    public function create()
    {
        $skuId = isset($this->postParams['sku_id']) ? intval($this->postParams['sku_id']) : 0;
        $num = isset($this->postParams['num']) ? intval($this->postParams['num']) : 0;
        $submit = isset($this->postParams['submit']) ? intval($this->postParams['submit']) : 0;
        $remark = isset($this->postParams['remark']) ? trim($this->postParams['remark']) : '';
        $address = isset($this->postParams['address']) ? $this->postParams['address'] : [];
        if (!isset($this->postParams['sku_id'])) {
            return $this->dataReturn('003000', 'missing sku_id');
        }
        if ($skuId <= 0) {
            return $this->dataReturn('003001', 'invalid sku_id');
        }
        if (!isset($this->postParams['num'])) {
            return $this->dataReturn('003002', 'missing num');
        }
        if ($num <= 0) {
            return $this->dataReturn('003003', 'invalid num');
        }
        if ($submit > 0) {
            if (!isset($this->postParams['address'])) {
                return $this->dataReturn('003004', 'missing address');
            }
            if (!is_array($address)) {
                return $this->dataReturn('003005', 'invalid address');
            }
            $name = isset($address['address_name']) ? trim($address['address_name']) : '';
            $phone = isset($address['address_phone']) ? trim($address['address_phone']) : '';
            $regionId = isset($address['region_id']) ? intval($address['region_id']) : '';
            $regionName = isset($address['region_name']) ? trim($address['region_name']) : '';
            $detail = isset($address['detail']) ? trim($address['detail']) : '';
            if (!$name) {
                return $this->dataReturn('003006', 'missing address_name under the address array');
            }
            if (!$phone) {
                return $this->dataReturn('003007', 'missing address_phone under the address array');
            }
            if (!$regionId) {
                return $this->dataReturn('003008', 'missing region_id under the address array');
            }
            if (!$regionName) {
                return $this->dataReturn('003009', 'missing region_name under the address array');
            }
            if (!$detail) {
                return $this->dataReturn('003010', 'missing detail under the address array');
            }
            $address['address'] = $detail;
        }
        $result = $this->orderModel->createOrder($this->user, 'goods', $skuId, $num, $submit, $address, $remark, 2);
        if ($result === FALSE) {
            return $this->dataReturn('003011', $this->orderModel->error);
        }
        if ($submit) {
            return $this->dataReturn(0, 'ok', ['order_sn' => $result['order_sn']]);
        }else{
            if ($result && $result['skus']) {
                foreach ($result['skus'] as $key => $value) {
                    unset($result['skus'][$key]['activity_id'], $result['skus'][$key]['store_id'], $result['skus'][$key]['sample_purchase_limit'], $result['skus'][$key]['stock_reduce_time']);
                    unset($result['skus'][$key]['udata_id'],$result['skus'][$key]['goods_type'],$result['skus'][$key]['name'],$result['skus'][$key]['sku_stock']);
                }
            }
            return $this->dataReturn(0, 'ok', $result);
        }
    }
    public function cancel()
    {
        $info = $this->_verifyOrder();
        if ($this->error) {
            return $info;
        }
        $remark = isset($this->postParams['remark']) ? trim($this->postParams['remark']) : '';
        $result = $this->orderModel->orderCancel($info['order_sn'], $this->user, $remark);
        if ($result === FALSE) {
            return $this->dataReturn('003014', $this->orderModel->error);
        }
        return $this->dataReturn(0, 'ok');
    }
    /**
     * 验证表单信息
     * @param string $orderSn
     * @param string $field
     * @return \think\response\Json|array
     */
    private function _verifyOrder($orderSn = '', $field = '')
    {
        if (!$orderSn) {
            $orderSn = isset($this->postParams['order_sn']) ? trim($this->postParams['order_sn']) : '';
        }
        if (!$orderSn) {
            $this->error = true;
            return $this->dataReturn('003012', 'missing order_sn');
        }
        $field = $field ? $field : '*';
        $where = [
            ['order_sn', '=', $orderSn],
        ];
        if ($this->sellerLimit) {
            $where[] = ['seller_udata_id', '=', $this->user['udata_id']];
        }else{
            $where[] = ['udata_id|seller_udata_id', '=', $this->user['udata_id']];
        }
        $info = $this->orderModel->field($field)->where($where)->find();
        if (!$info) {
            $this->error = true;
            return $this->dataReturn('003013', 'order not exist');
        }
        return $info->toArray();
    }
}