<?php
namespace app\factory\controller;
use app\common\controller\Order as commonOrder;
//厂商订单管理
class Order extends commonOrder
{
    public function __construct()
    {
        parent::__construct();
        if ($this->adminUser['group_id'] == GROUP_E_COMMERCE_KEFU) {
            $this->subMenu['add'] = [
                'name' => '添加订单',
                'url' => url("import"),
            ];
        }
    }
    public function import()
    {
            $purchase = new \app\factory\controller\Purchase();
//             $purchase->indextempfile = 'purchase/index';
//             $cart = new \app\factory\controller\Cart();
//             $cartList = $cart->getAjaxList(null,'*');
            $cart = $this->getcart(false);
            $this->assign("cart",$cart);
            return $purchase->index();
    }
    
    public function getcart($ajax = true){
        /* $join = [
            ['goods_sku GS', 'GS.sku_id= C.sku_id', 'INNER'],
            ['goods_sku_service GSS', 'GSS.sku_id = C.sku_id AND GSS.is_del=0 AND GSS.store_id='.$this->adminStore['store_id'], 'LEFT'],
            ['goods G', 'C.goods_id=G.goods_id', 'INNER'],
        ]; */
//         $field = 'GS.price,C.num,GSS.price_service';
        
        $join = [
            ['goods_sku GS', 'GS.sku_id= C.sku_id', 'INNER'],
            ['goods G', 'C.goods_id=G.goods_id', 'INNER'],
        ];
        $field = 'GS.price,GS.install_price,C.num,G.name,G.thumb,GS.sku_name';
        if ($this->adminStore['store_type'] == STORE_DEALER) {
            $where=[
                ['SD.store_id','=',$this->adminStore['store_id']],
                ['S.status', '=', 1],
                ['S.is_del', '=', 0],
            ];
            $channel=db('store_dealer')->alias('SD')->field('S.store_id,S.store_type')->join('store S','S.store_id=SD.ostore_id')->where($where)->find();
            $join[] = ['goods_sku_service GSS', 'GSS.sku_id = C.sku_id AND GSS.is_del=0 AND GSS.store_id='.$channel['store_id'], 'LEFT'];
            $field .= ', GSS.price_service,GSS.install_price_service, GSS.id as gid';
        }
        $where = [
            'C.is_del'   => 0,
            'C.status'   => 1,
            'C.store_id' => $this->adminStore['store_id'],
        ];
        $cartList = db("cart")->alias("C")->field($field)->join($join)->where($where)->select();
        //计算清单商品数量
        $count = count($cartList);
        $totalAmount = 0;
        $sum=0;
        foreach ($cartList as $k => $v) {
            $price = isset($v['gid']) ? $v['price_service'] : $v['price'];
            $totalAmount += $price * $v['num'];
            $sum+=$v['num'];
            if ($this->adminUser['group_id'] == GROUP_E_COMMERCE_KEFU) {
                $cartList[$k]['price_service'] = $v['price'] + $v['install_price'];
            }elseif($this->adminStore['store_type'] != STORE_DEALER) {
                $cartList[$k]['price_service'] = $v['price'];
            }
        }
        $cart = [
            'count'  => $count,
            'sum'    => $sum,
            'amount' => round($totalAmount, 2),
            'list'   => $cartList,
        ];
        return $ajax ? $this->ajaxJsonReturn($cart) : $cart;
    }
    
    public function finance()
    {
        $this->subMenu['menu'] = [
            [
                'name' => '全部',
                'url' => url('finance'),
            ],
            [
                'name' => '待付款',
                'url' => url('finance', ['pay_status' => 0]),
            ],
            [
                'name' => '已完成',
                'url' => url('finance', ['finish_status' => 1]),
            ],
            [
                'name' => '已取消',
                'url' => url('finance', ['order_status' => 2]),
            ]
            
        ];
        return $this->index();
    }

    function _afterList($list)
    {
        if ($list) {
            $flag = $this->adminUser['admin_type']==ADMIN_FACTORY ? TRUE : FALSE;
            $orderModel = new \app\common\model\Order();
            $list = $orderModel->getOrderList($list,true,$flag);
        }
        return $list;
    }
    
    function _getWhere()
    {
        $where = parent::_getWhere();
        if ($this->adminUser['group_id'] == GROUP_E_COMMERCE_KEFU) {
            $where['order_from'] = 3;
            $where['user_store_id'] = $this->adminStore['store_id'];
        }

        if ($this->adminStore['store_type'] == STORE_FACTORY) {
            $where['S.store_type'] = ['NEQ',STORE_DEALER];
        }
        return $where;
    }
}