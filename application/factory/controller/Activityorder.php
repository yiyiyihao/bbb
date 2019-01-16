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
    public function return()
    {
        $params = $this->request->param();
        $orderSn = isset($params['order_sn']) ? trim($params['order_sn']) : '';
        $this->subMenu['showmenu'] = false;
        $detail = $this->model->getOrderDetail($orderSn, $this->adminUser, TRUE, TRUE);
        if ($detail === false) {
            $this->error($this->model->error);
        }
        $order = $detail['order'];
        $return = $this->_checkActivity($order);
        $returnType = $return['return_type'];
        if ($returnType <= 0) {
            $this->error('当前订单不允许退款');
        }
        $user = $this->adminUser;
        $remark = $return['return_name'];
        $refundAmount = $return['return_amount'];
        //判断当前订单是否在优惠范围内
        if (IS_POST) {
            $serviceModel = new \app\common\model\OrderService();
            $result = $serviceModel->servuceActivityRefund($order, $refundAmount, $remark);
            if ($result === FALSE) {
                $this->error($serviceModel->error);
            }else{
                $this->success('退款成功');
            }
        }else{
            $this->assign('return', $return);
            $this->assign('info', $detail);
            return $this->fetch();
        }
    }
    private function _checkActivity($order)
    {
        $total = '2019';
        $activityPrice = 399;
        $startTime = time() - 1*24*60*60;//活动开始时间
        $entTime = time();//活动结束书剑
        $returnType = $returnAmount = 0;
        $name  = '';
        //1.计算订单下单时间是否在活动时间范围内
        if ($order['order_status'] == 1 && $order['pay_status'] == 1 && $order['close_refund_status'] == 0 && $order['pay_time'] >= $startTime && $order['pay_time'] <= $entTime) {
            //2.计算当前订单的实际支付顺序 是否逢九订单
            $where = [
                'order_type' => 2,
                'pay_status' => 1,
                'pay_time >= '.$startTime.' AND pay_time <=' .$order['pay_time'],
                'order_id <=' . $order['order_id'],
            ];
            $count = db('order')->where($where)->order('order_id ASC')->count();
            if ($count <= $total) {
                if ($count%10 == 9) {
                    $returnType = 1;//逢九免单
                    $name = '前2019位,按实际支付顺序,逢九免单';
                    $returnAmount = $order['paid_amount'];
                }else{
                    $returnType = 2;//前2019位享受促销价
                    $name = '前2019位,享受促销价格:'.$activityPrice.'元';
                    $returnAmount = $order['paid_amount'] >= $activityPrice ? ($order['paid_amount']-$activityPrice) : $order['paid_amount'];
                }
            }
        }
        return [
            'return_type' => $returnType,
            'return_name' => $name,
            'return_amount' => $returnAmount,
        ];
    }
    
    function _afterList($list)
    {
        if ($list) {
            foreach ($list as $key => $value) {
                $return = $this->_checkActivity($value);
                $list[$key]['return_type'] = $return['return_type'];
            }
        }
        return $list;
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