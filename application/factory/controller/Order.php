<?php
namespace app\factory\controller;
use app\common\controller\Order as commonOrder;
//厂商订单管理
class Order extends commonOrder
{
    public function __construct()
    {
        parent::__construct();
        if ($this->adminUser['group_id'] == 9) {
            $this->subMenu['add'] = [
                'name' => '添加订单',
                'url' => url("import"),
            ];
        }
        pre($this->subMenu, 1);
        $this->assign('subMenu', $this->subMenu);
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
        return $list;
    }
}