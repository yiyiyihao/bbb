<?php
namespace app\factory\controller;
use app\common\controller\Order as commonOrder;
//活动订单管理
class Activityorder extends commonOrder
{
    public function __construct()
    {
        parent::__construct();
        $this->subMenu['menu'] = [
            [
                'name' => '全部',
                'url' => url('index'),
            ],
            [
                'name' => '待付款',
                'url' => url('index', ['pay_status' => 0]),
            ],
            [
                'name' => '待发货',
                'url' => url('index', ['delivery_status' => 0]),
            ],
            [
                'name' => '待收货',
                'url' => url('index', ['delivery_status' => 1]),
            ],
            [
                'name' => '已完成',
                'url' => url('index', ['finish_status' => 1]),
            ],
            [
                'name' => '已取消',
                'url' => url('index', ['order_status' => 2]),
            ]
            
        ];
    }
    protected function _buildmap($param = []){
        $params = $this->request->param();
        $map = [
            'order_type' => 2,
        ];
        $map['O.store_id'] = $this->adminUser['store_id'];
        if(isset($param['pay_status'])){
            $map['O.order_status'] = 1;
            $map['O.pay_status'] = $param['pay_status'];
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