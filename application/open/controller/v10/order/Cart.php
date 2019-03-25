<?php
namespace app\open\controller\v10\order;

use app\open\controller\Base;
use think\Request;

class Cart extends Base
{
    private $cartModel;
    private $orderModel;
    private $user;
    private $error = FALSE;
    private $postParams;
    
    public function __construct(Request $request)
    {
        parent::__construct();
        $this->cartModel = model('cart');
        $this->orderModel = new \app\common\model\Order();
        $this->postParams = $request->param();
        $this->user = $this->postParams['user'];
        /**
         * Error 开头:003100
         */
    }
    public function list()
    {
        $result = $this->orderModel->_getCartDatas($this->user, TRUE);
        if ($result === FALSE) {
            return $this->dataReturn(1, $this->orderModel->error);
        }
        if ($result && $result['skus']) {
            foreach ($result['skus'] as $key => $value) {
                unset($result['skus'][$key]['activity_id'], $result['skus'][$key]['store_id'], $result['skus'][$key]['sample_purchase_limit'], $result['skus'][$key]['stock_reduce_time']);
                unset($result['skus'][$key]['udata_id'],$result['skus'][$key]['goods_type'],$result['skus'][$key]['name'],$result['skus'][$key]['sku_stock']);
            }
        }
        return $this->dataReturn(0, 'ok', $result);
    }
    public function preview()
    {
        $skuIds = isset($this->postParams['sku_ids']) ? $this->postParams['sku_ids'] : [];
        if (!isset($this->postParams['sku_ids'])) {
            return $this->dataReturn('003112', 'missing sku_ids');
        }
        if (!is_array($skuIds)) {
            return $this->dataReturn('003113', 'invalid sku_ids');
        }
        $skuIds = array_unique(array_filter($skuIds));
        foreach ($skuIds as $key => $value) {
            $skuId = intval($value);
            if ($skuId <= 0) {
                return $this->dataReturn('003113', 'invalid sku_ids');
            }
            //判断购物车商品是否存在
            $where = [
                ['sku_id', '=', $skuId],
                ['udata_id', '=', $this->user['udata_id']],
            ];
            $info = $this->cartModel->where($where)->find();
            if (!$info) {
                return $this->dataReturn('003114', 'sku_id not exist('.$skuId.')');
            }
        }
        $result = $this->orderModel->_getCartDatas($this->user, TRUE, $skuIds);
        if ($result === FALSE) {
            return $this->dataReturn(1, $this->orderModel->error);
        }
        if ($result && $result['skus']) {
            foreach ($result['skus'] as $key => $value) {
                unset($result['skus'][$key]['activity_id'], $result['skus'][$key]['store_id'], $result['skus'][$key]['sample_purchase_limit'], $result['skus'][$key]['stock_reduce_time']);
                unset($result['skus'][$key]['udata_id'],$result['skus'][$key]['goods_type'],$result['skus'][$key]['name'],$result['skus'][$key]['sku_stock']);
            }
        }
        return $this->dataReturn(0, 'ok', $result);
    }
    public function add()
    {
        $skuId = isset($this->postParams['sku_id']) ? intval($this->postParams['sku_id']) : 0;
        $num = isset($this->postParams['amount']) ? intval($this->postParams['amount']) : 0;
        if (!isset($this->postParams['sku_id'])) {
            return $this->dataReturn('003100', 'missing sku_id');
        }
        if (!isset($this->postParams['amount'])) {
            return $this->dataReturn('003101', 'missing amount');
        }
        if ($skuId <= 0) {
            return $this->dataReturn('003102', 'invalid sku_id');
        }
        if ($num <= 0) {
            return $this->dataReturn('003103', 'invalid amount');
        }
        //判断sku_id是否存在
        $where = [
            ['sku_id', '=', $skuId],
            ['is_del', '=', 0],
            ['store_id', '=', $this->user['factory_id']],
        ];
        $sku = model('goods_sku')->where($where)->find();
        if (!$sku) {
            return $this->dataReturn('003104', 'invalid sku_id');
        }
        if (!$sku['status']) {
            return $this->dataReturn('003105', 'goods has been removed');
        }
        if ($sku['sku_stock'] < $num) {
            return $this->dataReturn('003106', 'exceeded stock');
        }
        //判断是否是自己的商品
        if ($sku['udata_id'] == $this->user['udata_id']) {
            return $this->dataReturn('003111', 'not allowed to buy your own goods');
        }
        //判断购物车商品是否存在
        $where = [
            ['sku_id', '=', $skuId],
            ['udata_id', '=', $this->user['udata_id']],
        ];
        $exist = $this->cartModel->where($where)->find();
        $where = [];
        if ($exist) {
            $num = $exist['num'] + $num;
            if ($sku['sku_stock'] < $num) {
                return $this->dataReturn('003106', 'exceeded stock');
            }
            $data = [
                'num' => $num,
            ];
            $where['cart_id'] = $exist['cart_id'];
        }else{
            $data = [
                'sku_id'    => $skuId,
                'goods_id'  => $sku['goods_id'],
                'store_id'  => $sku['store_id'],
                'seller_udata_id' => $sku['udata_id'],
                'udata_id'  => $this->user['udata_id'],
                'num'       => $num,
            ];
        }
        $result = $this->cartModel->save($data, $where);
        if ($result === FALSE) {
            return $this->dataReturn(-1, 'system_error');
        }
        return $this->dataReturn(0, 'ok', ['cate_id' => $this->cartModel->cart_id]);
    }
    public function edit()
    {
        $info = $this->_verifyCart();
        if ($this->error) {
            return $info;
        }
        $num = isset($this->postParams['amount']) ? intval($this->postParams['amount']) : 0;
        if (!isset($this->postParams['amount'])) {
            $this->error = true;
            return $this->dataReturn('003101', 'missing amount');
        }
        if ($num <= 0) {
            $this->error = true;
            return $this->dataReturn('003103', 'invalid amount');
        }
        $cartId = $info['cart_id'];
        //判断购物车商品是否存在
        $where = [
            ['cart_id', '=', $cartId],
            ['udata_id', '=', $this->user['udata_id']],
        ];
        $exist = $this->cartModel->where($where)->find();
        if (!$exist) {
            $this->error = true;
            return $this->dataReturn('003108', 'invalid cart_id');
        }
        //判断sku_id是否存在
        $where = [
            ['sku_id', '=', $exist['sku_id']],
            ['is_del', '=', 0],
            ['store_id', '=', $this->user['factory_id']],
        ];
        $sku = model('goods_sku')->where($where)->find();
        if (!$sku) {
            $this->error = true;
            return $this->dataReturn('003104', 'invalid sku_id');
        }
        if (!$sku['status']) {
            $this->error = true;
            return $this->dataReturn('003105', 'goods has been removed');
        }
        if ($sku['sku_stock'] < $num) {
            $this->error = true;
            return $this->dataReturn('003106', 'exceeded stock');
        }
        $data = ['num' => $num];
        $result = $this->cartModel->save($data, ['cart_id' => $cartId]);
        if ($result === FALSE) {
            return $this->dataReturn(-1, 'system_error');
        }
        return $this->dataReturn(0, 'ok');
    }
    public function del()
    {
        $info = $this->_verifyCart();
        if ($this->error) {
            return $info;
        }
        $result = $this->cartModel->where(['cart_id' => $info['cart_id']])->delete();
        if ($result === FALSE) {
            return $this->dataReturn(003110, 'system_error');
        }
        return $this->dataReturn(0, 'ok');
    }
    
    /**
     * 验证表单信息
     * @param int $cartId
     * @param string $field
     * @return \think\response\Json|array
     */
    private function _verifyCart($cartId = 0)
    {
        if (!$cartId) {
            $cartId = isset($this->postParams['cart_id']) ? intval($this->postParams['cart_id']) : 0;
            if (!isset($this->postParams['cart_id'])) {
                $this->error = true;
                return $this->dataReturn('003107', 'missing cart_id');
            }
        }
        if ($cartId <= 0) {
            $this->error = true;
            return $this->dataReturn('003108', 'invalid cart_id');
        }
        //判断购物车商品是否存在
        $where = [
            ['cart_id', '=', $cartId],
            ['udata_id', '=', $this->user['udata_id']],
        ];
        $info = $this->cartModel->where($where)->find();
        if (!$info) {
            $this->error = true;
            return $this->dataReturn('003109', 'data not exist');
        }
        return $info->toArray();
    }
    /**
     * 检查并处理add/edit对应的请求参数
     * @param array $info
     * @return array
     */
    private function _checkField($info = [])
    {
        $skuId = isset($this->postParams['sku_id']) ? intval($this->postParams['sku_id']) : 0;
        $num = isset($this->postParams['amount']) ? intval($this->postParams['amount']) : 0;
        if (!isset($this->postParams['sku_id'])) {
            $this->error = true;
            return $this->dataReturn('003100', 'missing sku_id');
        }
        if (!isset($this->postParams['amount'])) {
            $this->error = true;
            return $this->dataReturn('003101', 'missing amount');
        }
        if ($skuId <= 0) {
            $this->error = true;
            return $this->dataReturn('003102', 'invalid sku_id');
        }
        if ($num <= 0) {
            $this->error = true;
            return $this->dataReturn('003103', 'invalid amount');
        }
        //判断sku_id是否存在
        $where = [
            ['sku_id', '=', $skuId],
            ['is_del', '=', 0],
            ['store_id', '=', $this->user['factory_id']],
        ];
        $sku = model('goods_sku')->where($where)->find();
        if (!$sku) {
            $this->error = true;
            return $this->dataReturn('003104', 'invalid sku_id');
        }
        if (!$sku['status']) {
            $this->error = true;
            return $this->dataReturn('003105', 'goods has been removed');
        }
        if ($sku['sku_stock'] < $num) {
            $this->error = true;
            return $this->dataReturn('003106', 'exceeded stock');
        }
        //判断购物车商品是否存在
        $where = [
            ['sku_id', '=', $skuId],
            ['udata_id', '=', $this->user['udata_id']],
        ];
        $exist = $this->cartModel->where($where)->find();
        $where = [];
        if ($exist) {
            $num = $exist['num'] + $num;
            if ($sku['sku_stock'] < $num) {
                $this->error = true;
                return $this->dataReturn('003106', 'exceeded stock');
            }
            $data = [
                'num' => $num,
            ];
            $where['cart_id'] = $exist['cart_id'];
        }else{
            $data = [
                'sku_id'    => $skuId,
                'goods_id'  => $sku['goods_id'],
                'store_id'  => $sku['store_id'],
                'seller_udata_id' => $sku['udata_id'],
                'udata_id'  => $this->user['udata_id'],
                'num'       => $num,
            ];
        }
        
        $return =  [
            'name'      => $name,
            'parent_id'  => $parentId,
        ];
        return $return;
    }
   
}