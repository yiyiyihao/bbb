<?php
namespace app\factory\controller;
use app\common\controller\Order as commonOrder;
//厂商订单管理
class Order extends commonOrder
{
    public function __construct()
    {
        parent::__construct();
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

    public function pay_confirm()
    {
        $orderId=$this->request->param('id',0,'intval');
        $paySn=$this->request->param('pay_sn','');
        $remark=$this->request->param('remark','');
        if (empty($orderId)) {
            $this->error(lang('PARAM_ERROR'));
        }
        $info=$this->_assignInfo($orderId);
        if (empty($info)) {
            $this->error('订单不存在或已删除');
        }
        if ($info['pay_type'] != 2) {
            $this->error('线上支付订单无须收款确认');
        }
        if ($info['pay_status'] !=0) {
            $stauts=get_order_status($info)['status_text'];
            $this->error('操作失败，订单'.$stauts);
        }
        $data = [
            'pay_sn'      => $paySn,
            'remark'      => $remark,
            'pay_status'  => 1,
            'pay_time'    => time(),
            'update_time' => time(),
        ];
        $result=db('order')->where(['order_id'=>$orderId])->update($data);
        if ($result === false) {
            $this->error('操作失败，系统故障');
        }
        $this->success('操作成功！');
    }

    function _afterList($list)
    {
        if ($list) {
            $orderModel = new \app\common\model\Order();
            $list = $orderModel->getOrderList($list);
        }
        return $list;
    }
}