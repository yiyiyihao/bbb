<?php
namespace app\factory\controller;
//采购管理
class Purchase extends FactoryForm
{
    public function __construct()
    {
        $this->modelName = 'goods';
        $this->model = model($this->modelName);
        parent::__construct();
        //仅零售商有采购功能
        if ($this->adminUser['admin_type'] != ADMIN_DEALER) {
            $this->error(lang('NO ACCESS'));
        }
        unset($this->subMenu['add']);
    }
    public function detail()
    {
        $info = $this->_assignInfo();
        $this->assign('info', $info);
        
        $orderModel = new \app\common\model\Order();
        $skuId = 2;
        $num = 1;
        $submit = 1;
        $addr = [
            'name' => '测试',
            'phone' => '13462541254',
            'region_name' => '广东省广州市',
            'address' => '测试地址',
        ];
        $result = $orderModel->createOrder(ADMIN_ID, 'goods', $skuId, $num, $submit, $addr);
        if ($result === FALSE) {
            $this->error($orderModel->error);
        }
        pre($result);
        
        return $this->fetch();
    }
    function  _getOrder()
    {
        return 'add_time DESC';
    }
    function _getWhere(){
        $params = $this->request->param();
        $where = [
            'is_del' => 0,
            'status' => 1,
            'store_id' => $this->adminFactory['store_id'],
        ];
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['name'] = ['like','%'.$name.'%'];
            }
        }
        return $where;
    }
    function _assignInfo($pkId = 0){
        $info = parent::_assignInfo();
        return $info;
    }
}