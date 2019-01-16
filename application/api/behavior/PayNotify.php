<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/1/16 0016
 * Time: 13:37
 */

namespace app\api\behavior;


use app\common\model\Order;
use think\facade\Log;
use think\facade\Request;

class PayNotify
{

    public function run(Request $request, $param = [])
    {
        $form = $request::module() . '_' . $request::controller() . '_' . $request::action();
        if (strtolower($form) === 'api_pay_wechat' && IS_POST) {
            $orderSn = isset($param['order_sn']) ? trim($param['order_sn']) : '';
            $model = new Order;
            $user = $param['user'];
            $detail = $model->getOrderDetail($orderSn, $user, TRUE, TRUE);
            if ($detail === false) {
                Log::error('退款失败，原因【' . $model->error . '】,参数：', $param);
                return false;
            }
            $order = $detail['order'];
            $return = $this->_checkActivity($order);
            $returnType = $return['return_type'];
            if ($returnType <= 0) {
                Log::error('当前订单不允许退款，原因【' . $model->error . '】,参数：', $param);
                return false;
            }
            $remark = $return['return_name'];
            $refundAmount = $return['return_amount'];
            $serviceModel = new \app\common\model\OrderService();
            $result = $serviceModel->servuceActivityRefund($order, $refundAmount, $remark);
            if ($result === FALSE) {
                Log::error('当前订单不允许退款，原因【' . $serviceModel->error . '】,参数：', $param);
                return false;
            } else {
                Log::info('退款成功', $param);
                return true;
            }
        }
    }


    private function _checkActivity($order)
    {
        $goodsId=[1];
        $now = time();
        $config = db('activity')->where([
            //['start_time', '<=', $now],
            //['end_time', '>=', $now],
            ['is_del', 0],
            ['status', 1],
            ['id', 1],
        ])->find();
        if (empty($config)) {
            Log::error('活动未配置');
            return true;
        }
        $total = $config['activity_total'];
        $activityPrice = $config['activity_price'];
        $startTime = $config['start_time'];//活动开始时间
        $entTime = $config['end_time'];//活动结束书剑
        $returnType = $returnAmount = 0;
        $name = '';
        //1.计算订单下单时间是否在活动时间范围内
        if ($order['order_status'] == 1 && $order['pay_status'] == 1 && $order['close_refund_status'] == 0 && $order['pay_time'] >= $startTime && $order['pay_time'] <= $entTime) {
            //2.计算当前订单的实际支付顺序 是否逢九订单
            $where=[
                ['O.order_type',2],
                ['O.pay_status',1],
                ['O.pay_time','>=',$startTime],
                ['O.pay_time','<=',$order['pay_time']],
                ['OS.goods_id','in',$goodsId],
            ];
            $count = Order::alias('O')->join('order_sku OS','O.order_sn=OS.order_sn')->where($where)->count();
            //$count = Order::a->where($where)->order('order_id ASC')->count();
            if ($count <= $total) {
                if ($count % 10 == 9) {
                    $returnType = 1;//逢九免单
                    $name = '前'.$total.'位,按实际支付顺序,逢九免单';
                    $returnAmount = $order['paid_amount'];
                } else {
                    $returnType = 2;//前2019位享受促销价
                    $name = '前'.$total.'位,享受促销价格:' . $activityPrice . '元';
                    $returnAmount = $order['paid_amount'] >= $activityPrice ? ($order['paid_amount'] - $activityPrice) : $order['paid_amount'];
                }
            }
        }
        return [
            'return_type' => $returnType,
            'return_name' => $name,
            'return_amount' => $returnAmount,
        ];
    }


}