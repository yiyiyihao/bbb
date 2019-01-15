<?php
namespace app\common\model;
use think\Model;

class OrderSku extends Model
{
	public $error;
	protected $fields;
	protected $pk = 'osku_id';

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
    public function getSubDetail($ossubId = 0, $field = '', $getservice = FALSE, $getworder = FALSE)
    {
        $join = [
            ['order_sku OS', 'OS.osku_id = OSS.osku_id', 'INNER'],
            ['order O', 'O.order_id = OSS.order_id', 'INNER'],
        ];
        $field = $field ? $field : 'OS.goods_type, OS.sku_name, OS.sku_spec, OS.sku_thumb, O.*, OSS.*';
        $where = [
            'ossub_id' => $ossubId,
        ];
        $ossub = db('order_sku_sub')->field($field)->alias('OSS')->join($join)->where($where)->find();
        $ossub['service'] = $ossub['work_order'] = [];
        if ($getservice || $getworder) {
            if (isset($ossub['ossub_id']) && $ossub['ossub_id']) {
                $orderSkuServiceModel = db('order_sku_service');
                $workOrderModel = db('work_order');
                if ($getservice) {
                    $ossub['service'] = $orderSkuServiceModel->order('add_time DESC, service_id DESC')->where(['ossub_id' => $ossub['ossub_id']])->find();
                }
                if($getworder){
                    //获取安装工单(状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成))
                    $ossub['work_order'] = $workOrderModel->order('add_time DESC, worder_id DESC')->where(['ossub_id' => $ossub['ossub_id']])->find();
                }
            }
        }
        return $ossub;
    }
}