<?php

namespace app\open\controller\v10\order;

use app\open\controller\Base;
use app\open\validate\CartValidate;
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
        $this->user = $request->user;
        /**
         * Error 开头:003100
         */
    }

    /**
     * 购物车列表
     * @return \think\response\Json
     */
    public function list()
    {
        $result = $this->_getCartData($this->user, TRUE);
        return $this->dataReturn($result);
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
                return $this->dataReturn('003114', 'sku_id not exist(' . $skuId . ')');
            }
        }
        $result = $this->orderModel->_getCartDatas($this->user, TRUE, $skuIds);
        if ($result === FALSE) {
            return $this->dataReturn(1, $this->orderModel->error);
        }
        if ($result && $result['skus']) {
            foreach ($result['skus'] as $key => $value) {
                unset($result['skus'][$key]['activity_id'], $result['skus'][$key]['store_id'], $result['skus'][$key]['sample_purchase_limit'], $result['skus'][$key]['stock_reduce_time']);
                unset($result['skus'][$key]['udata_id'], $result['skus'][$key]['goods_type'], $result['skus'][$key]['name'], $result['skus'][$key]['sku_stock']);
            }
        }
        return $this->dataReturn(0, 'ok', $result);
    }


    /**
     * 加入购物车
     * @param Request $request
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function add(Request $request)
    {
        $check = new CartValidate();
        if (!$check->scene('add')->check($request->param())) {
            return $this->dataReturn('003100', $check->getError());
        }
        $skuId=$request->param('sku_id',0,'intval');
        $num=$request->param('num',0,'intval');

        //判断sku_id是否存在
        $where = [
            ['sku_id', '=', $skuId],
            ['is_del', '=', 0],
            ['store_id', '=', $this->user['factory_id']],
        ];
        $sku = model('goods_sku')->where($where)->find();
        if (!$sku) {
            return $this->dataReturn('003101', '该商品不存在或已经删除');
        }
        if (!$sku['status']) {
            return $this->dataReturn('003102', '该商品已经删除');
        }
        if ($sku['sku_stock'] < $num) {
            return $this->dataReturn('003103', '该商品库存不足');
        }
        //判断是否是自己的商品
        if ($sku['udata_id'] == $this->user['udata_id']) {
            return $this->dataReturn('003104', '厂商不能自产自销');
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
                return $this->dataReturn('003105', '该商品库存不足');
            }
            $data = [
                'num' => $num,
            ];
            $where['cart_id'] = $exist['cart_id'];
        } else {
            $data = [
                'sku_id'          => $skuId,
                'goods_id'        => $sku['goods_id'],
                'store_id'        => $sku['store_id'],
                'seller_udata_id' => $sku['udata_id'],
                'udata_id'        => $this->user['udata_id'],
                'num'             => $num,
            ];
        }
        $result = $this->cartModel->save($data, $where);
        if ($result === FALSE) {
            return $this->dataReturn(-1, '系统故障，请稍后重试~');
        }
        return $this->dataReturn(0, '加入购物车成功', ['cart_id' => $this->cartModel->cart_id]);
    }

    /**
     * 删除购物车中商品
     * @param Request $request
     * @return array|\think\response\Json
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     */
    public function del(Request $request)
    {
        $check = new CartValidate();
        if (!$check->scene('del')->check($request->param())) {
            return $this->dataReturn('003100', $check->getError());
        }
        $cartId=$request->param('cart_id',0,'intval');
        //判断购物车商品是否存在
        $where = [
            ['cart_id', '=', $cartId],
            ['udata_id', '=', $this->user['udata_id']],
        ];
        $info = $this->cartModel->where($where)->find();
        if (!$info) {
            return $this->dataReturn('003106', '商品不存在或已删除');
        }
        $result = $this->cartModel->where(['cart_id' => $info['cart_id']])->delete();
        if ($result === FALSE) {
            return $this->dataReturn(-1, '系统故障，请稍后重试');
        }
        return $this->dataReturn(0, '删除成功');
    }

    public function edit(Request $request)
    {
        $check = new CartValidate();
        if (!$check->scene('edit')->check($request->param())) {
            return $this->dataReturn('003100', $check->getError());
        }
        $cartId=$request->param('cart_id',0,'intval');
        $num=$request->param('num',0,'intval');
        //判断购物车商品是否存在
        $where = [
            ['cart_id', '=', $cartId],
            ['udata_id', '=', $this->user['udata_id']],
        ];
        $exist = $this->cartModel->where($where)->find();
        if (!$exist) {
            return $this->dataReturn('003107', '商品不存在或已删除');
        }
        //判断sku_id是否存在
        $where = [
            ['sku_id', '=', $exist['sku_id']],
            ['is_del', '=', 0],
            ['store_id', '=', $this->user['factory_id']],
        ];
        $sku = model('goods_sku')->where($where)->find();
        if (!$sku) {
            return $this->dataReturn('003108', '商品规格不存在或已删除');
        }
        if (!$sku['status']) {
            return $this->dataReturn('003109', '商品已删除');
        }
        if ($sku['sku_stock'] < $num) {
            return $this->dataReturn('003110', '商品已库存不足');
        }
        $data = ['num' => $num];
        $result = $this->cartModel->save($data, ['cart_id' => $cartId]);
        if ($result === FALSE) {
            return $this->dataReturn(-1, '系统故障，请稍后重试');
        }
        return $this->dataReturn(0, '操作成功');
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
        } else {
            $data = [
                'sku_id'          => $skuId,
                'goods_id'        => $sku['goods_id'],
                'store_id'        => $sku['store_id'],
                'seller_udata_id' => $sku['udata_id'],
                'udata_id'        => $this->user['udata_id'],
                'num'             => $num,
            ];
        }

        $return = [
            'name'      => $name,
            'parent_id' => $parentId,
        ];
        return $return;
    }

    private function _getCartData($user, $skuIds = [])
    {
        $where = [
            ['C.udata_id', '=', $user['udata_id']],
            ['C.seller_udata_id', '<>', $user['udata_id']],
        ];
        $join = [
            ['goods_sku S', 'C.sku_id = S.sku_id', 'INNER'],
            ['goods G', 'C.goods_id = G.goods_id', 'INNER'],
        ];
        $field = 'C.cart_id,G.activity_id,G.activity_id,S.store_id,S.udata_id,S.sku_id,S.sku_sn,S.goods_type,G.goods_id,G.name,S.sku_name,S.price,S.install_price,C.num,S.sample_purchase_limit,S.sku_thumb,G.thumb,S.sku_stock,S.stock_reduce_time,S.spec_value,G.is_del as gdel,G.status as gstatus,S.status as sstatus,S.is_del as sdel';
        $order = 'C.cart_id DESC';
        $result = $this->getModelList(db('cart'), $where, $field, $order, 'C', $join);
        $ret = [
            //'list'            => $list,//产品列表
            'sku_total'       => 0,//产品总数量
            'sku_count'       => 0,//产品种类数量(不重复)
            'all_amount'      => 0,//订单总金额
            'delivery_amount' => 0,//物流费用
            'install_amount'  => 0,//安装费用
            'sku_amount'      => 0,//产品总金额
            'pay_amount'      => 0,//需支付金额
        ];
        $result = array_merge($result, $ret);
        if (empty($result['list'])) {
            return dataFormat(0, 'ok', $result);
        }
        $carts = $datas = $storeIds = [];
        $skuCount = $skuTotal = $deliveryAmount = $skuAmount = $installAmount = $payAmount = 0;
        $storeModel = db('store');
        $skuList = $skus = $storeAmounts = [];
        foreach ($result['list'] as $key => $value) {
            if ($value['activity_id']) {
                $where = [
                    ['id', '=', $value['activity_id']],
                    ['is_del', '=', 0],
                    ['start_time', '<=', time()],
                    ['end_time', '>=', time()],
                ];
                $value['price'] = db('activity')->where($where)->value('activity_price');
            }
            $skuList[] = $skuId = $value['sku_id'];
            $num = intval($value['num']);
            //样品限制单个用户购买数量
            if ($value['goods_type'] == 2 && $value['sample_purchase_limit'] > 0) {
                $count = db('order')->alias('O')->join('order_sku OS', 'O.order_id = OS.order_id', 'INNER')->where(['sku_id' => $skuId, 'order_status' => 1])->count();
                $total = $count + $num;
                if ($total > $value['sample_purchase_limit']) {
                    return dataFormat('003107', '单个用户样品限购数量为(' . $value['sample_purchase_limit'] . ')');
                }
            }
            $storeIds[$value['store_id']] = $storeId = $value['store_id'];

            //产品库存为0/已删除/已禁用 则为 已失效
            $amount = 0;
            $disable = $unsale = 0;
            //判断购买数量是否大于库存数量
            if ($value['sku_stock'] <= 0 || $value['sku_stock'] < $num) {
                $disable = 1; //库存不足
            } elseif ($value['sdel'] || $value['gdel'] || !$value['gstatus'] || !$value['sstatus']) {
                $unsale = 1; //已下架
            } else {
                $installAmount = $installAmount + ($value['install_price'] * $num);
                if ($num > 0) {
                    $skuCount++;
                }
                $skuTotal += $num;
                $skuAmount += $value['price'] * $num;
            }
            $value['pay_price'] = $value['price'] + $value['install_price'];
            if (isset($value['sku_thumb']) && $value['sku_thumb']) {
                $value['sku_thumb'] = trim($value['sku_thumb']);
            } elseif (isset($value['thumb']) && $value['thumb']) {
                $value['sku_thumb'] = trim($value['thumb']);
            } else {
                $value['sku_thumb'] = '';
            }
            $value['disable'] = $disable;
            $value['unsale'] = $unsale;
            unset($value['gdel'], $value['gstatus'], $value['sstatus'], $value['sdel'], $value['thumb']);
            $skus[$skuId] = $value;
            unset($result['list'][$key]['activity_id'], $result['list'][$key]['store_id'], $result['list'][$key]['sample_purchase_limit'], $result['list'][$key]['stock_reduce_time']);
            unset($result['list'][$key]['udata_id'], $result['list'][$key]['goods_type'], $result['list'][$key]['name'], $result['list'][$key]['sku_stock']);
        }
        //$store = $storeModel->field('store_id, name')->where(['store_id' => $storeId])->find();
        $skuIds = !empty($skuIds) ? $skuIds : implode(',', $skuList);
        if (count($storeIds) > 1) {
            return dataFormat('003108', '不允许跨厂商购买产品');
        }
        if (!$skus || !$storeIds) {
            return dataFormat('003109', '请选择购买产品');
        }
        $payAmount = $allAmount = $skuAmount + $installAmount + $deliveryAmount;
        $result['sku_total'] = intval($skuTotal);
        $result['sku_count'] = intval($skuCount);
        $result['all_amount'] = sprintf("%.2f", $allAmount);
        $result['delivery_amount'] = sprintf("%.2f", $deliveryAmount);
        $result['install_amount'] = sprintf("%.2f", $installAmount);
        $result['sku_amount'] = sprintf("%.2f", $skuAmount);
        $result['pay_amount'] = sprintf("%.2f", $payAmount);
        return dataFormat('0', 'ok', $result);
    }

}