<?php
namespace app\open\controller\v10\cart;

use app\open\controller\Base;
use think\Request;

class Cart extends Base
{
    private $cartModel;
    private $user;
    private $error = FALSE;
    private $postParams;
    
    public function __construct(Request $request)
    {
        parent::__construct();
        $this->cartModel = model('cart');
        $this->postParams = $request->param();
        $this->user = $this->postParams['user'];
        /**
         * Error 开头:003000
         */
    }
    public function list()
    {
        $field = 'cart_id, cart_type, cart_id, real_amount, address_name, address_phone, address_detail, cart_status, pay_status, delivery_status, finish_status, add_time';
        $where = [
            ['udata_id', '=', $this->user['udata_id']],
            ['cart_type', '=', 2],
        ];
        $result = $this->getModelList($this->cartModel, $where, $field, 'add_time ASC');
        if ($result && isset($result['list'])) {
            foreach ($result['list'] as $key => $value) {
                $where = [
                    ['cart_id', '=', $value['cart_id']],
                ];
                $skus = model('cart_sku')->field('sku_id, sku_name, sku_thumb, sku_spec, num, price')->where($where)->select();
                $result['list'][$key]['skus'] = $skus;
                $result['list'][$key]['_status'] = get_cart_status($value);
                unset($result['list'][$key]['cart_id'], $result['list'][$key]['cart_type']);
            }
        }
        return $this->dataReturn(0, 'ok', $result);
    }
    public function info()
    {
        $field = 'cart_id, cart_type, cart_id, goods_amount, delivery_amount, real_amount, install_amount, paid_amount, pay_code, pay_sn, address_name, address_phone, address_detail';
        $field .= ', cart_status, pay_status, delivery_status, finish_status, add_time, cancel_time, pay_time, finish_time';
        $info = $this->_verifycart(FALSE, $field);
        if ($this->error) {
            return $info;
        }
        $info['_status'] = get_cart_status($info);
        //获取订单商品列表
        $where = [
            ['cart_id', '=', $info['cart_id']],
        ];
        $skus = model('cart_sku')->field('sku_id, sku_name, sku_thumb, sku_spec, num, price, delivery_status, delivery_time')->where($where)->select();
        $info['skus'] = $skus;
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
        $result = $this->cartModel->createcart($this->user, 'goods', $skuId, $num, $submit, $address, $remark, 2);
        if ($result === FALSE) {
            return $this->dataReturn('003011', $this->cartModel->error);
        }
        if ($submit) {
            return $this->dataReturn(0, 'ok', ['cart_id' => $result['cart_id']]);
        }else{
            if ($result && $result['skus']) {
                foreach ($result['skus'] as $key => $value) {
                    unset($result['skus'][$key]['activity_id'], $result['skus'][$key]['store_id'], $result['skus'][$key]['sample_purchase_limit'], $result['skus'][$key]['stock_reduce_time']);
                }
            }
            unset($result['sku_ids'], $result['store_id']);
            return $this->dataReturn(0, 'ok', $result);
        }
    }
    public function cancel()
    {
        $info = $this->_verifycart();
        if ($this->error) {
            return $info;
        }
        $result = $this->cartModel->cartCancel($info['cart_id'], $this->user);
        if ($result === FALSE) {
            return $this->dataReturn('003014', $this->cartModel->error);
        }
        return $this->dataReturn(0, 'ok');
    }
    
    /**
     * 验证表单信息
     * @param string $cartId
     * @param string $field
     * @return \think\response\Json|array
     */
    private function _verifycart($cartId = '', $field = '')
    {
        if (!$cartId) {
            $cartId = isset($this->postParams['cart_id']) ? trim($this->postParams['cart_id']) : '';
        }
        if (!$cartId) {
            $this->error = true;
            return $this->dataReturn('003012', 'missing cart_id');
        }
        $field = $field ? $field : '*';
        $info = $this->cartModel->field($field)->where('cart_id', $cartId)->where('udata_id', $this->user['udata_id'])->find();
        if (!$info) {
            $this->error = true;
            return $this->dataReturn('003013', 'cart not exist');
        }
        return $info->toArray();
    }
}