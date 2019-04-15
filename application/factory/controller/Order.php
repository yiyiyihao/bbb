<?php
namespace app\factory\controller;
use app\common\controller\Order as commonOrder;
//厂商订单管理
class Order extends commonOrder
{
    public function __construct()
    {
        parent::__construct();
        if ($this->adminUser['group_id'] == 16) {
            $this->subMenu['add'] = [
                'name' => '添加订单',
                'url' => url("import"),
            ];
        }
    }
    public function import()
    {
        if (IS_POST) {
            
        }else{
            $purchase = new \app\factory\controller\Purchase();
//             $purchase->indextempfile = 'purchase/index';
//             $cart = new \app\factory\controller\Cart();
//             $cartList = $cart->getAjaxList(null,'*');
            $cart = $this->getcart(false);
            $this->assign("cart",$cart);
            return $purchase->index();
        }
    }
    
    public function getcart($ajax = true){
        $join = [
            ['goods_sku GS', 'GS.sku_id= C.sku_id', 'INNER'],
            ['goods G', 'C.goods_id=G.goods_id', 'INNER'],
        ];
        $where = [
            'C.is_del'   => 0,
            'C.status'   => 1,
            'C.store_id' => $this->adminStore['store_id'],
        ];
        $cartList = db("cart")->alias("C")->join($join)->where($where)->select();
        //计算清单商品数量
        $count = count($cartList);
        $totalAmount = 0;
        foreach ($cartList as $k=>$v){
            $totalAmount += $v['price']*$v['num'];
        }
        $cart = [
            'count' =>  $count,
            'amount'=>  round($totalAmount,2),
            'list'  =>  $cartList,
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
            $flag = in_array($this->adminUser['admin_type'], [ADMIN_FACTORY,ADMIN_CHANNEL, ADMIN_DEALER,ADMIN_SERVICE_NEW]) ? TRUE : FALSE;
            $orderModel = new \app\common\model\Order();
            $list = $orderModel->getOrderList($list,true);
        }
        //p($list);
        return $list;
    }
}