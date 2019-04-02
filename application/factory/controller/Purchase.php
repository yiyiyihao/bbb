<?php
namespace app\factory\controller;
//采购管理
class Purchase extends FactoryForm
{
    public function __construct()
    {
        $this->modelName = '采购';
        $this->model = model('goods');
        parent::__construct();
        //渠道/零售商有采购功能
        if (!in_array($this->adminUser['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER,ADMIN_SERVICE_NEW])) {
            $this->error(lang('NO ACCESS'));
        }
        unset($this->subMenu['add']);
    }
    public function detail()
    {
        $info = $this->_assignInfo();
        $skus = $this->model->getGoodsSkus($info['goods_id']);
        $this->assign('skus', is_array($skus) ? $skus : []);
        $info['sku_id'] = is_int($skus) ? $skus : 0;
        $info['thumb_big'] = $this->_thumbToBig($info['thumb']);
        $info['imgs'] = json_decode($info['imgs'],true);
        if ($info['imgs']) {
            foreach ($info['imgs'] as $k=>$v){
                $imgs[$k]["thumb"] = $v;
                $imgs[$k]["thumb_big"] = $this->_thumbToBig($v);
            }
        }else{
            $imgs = [];
        }
        $info['imgs'] = $imgs;
		$info['specs'] = json_decode($info['specs_json'],true);
        //pre($info);
        $this->assign('info', $info);
        $this->import_resource(array(
            'script'=> 'jquery.jqzoom-core.js',
            'style' => 'goods.css,jquery.jqzoom.css',
        ));
        return $this->fetch();
    }
    public function confirm()
    {
        $params = $this->request->param();
        $skuId = isset($params['sku_id']) ? intval($params['sku_id']) : 0;
        $num = isset($params['num']) ? intval($params['num']) : 0;
        $remark = isset($params['remark']) ? trim($params['remark']) : '';
        if ($skuId <= 0 || $num <= 0) {
            $this->error('参数错误');
        }
        $this->model = db('goods_sku');
        $sku = $this->_assignInfo($skuId);
        $orderModel = new \app\common\model\Order();
        $post = $this->request->post();
        if (IS_POST) {
            $num = isset($post['num']) ? intval($post['num']) : 0;
        }
        $payments = $orderModel->getOrderPayments($sku['store_id'], 1);
        if (IS_POST) {
            $payCode = isset($params['pay_code']) ? trim($params['pay_code']) : '';
            if (!$payCode) {
                $this->error('请选择支付方式');
            }
            $order = $orderModel->createOrder($this->adminUser, 'goods', $skuId, $num, IS_POST, $params, $remark);
            if ($order === FALSE) {
                $this->error($orderModel->error);
            }
            $this->success('下单成功,前往支付', url('myorder/pay', ['order_sn' => $order['order_sn'], 'pay_code' => $payCode, 'step' => 2]), ['order_sn'=>$order['order_sn']]);
//             $this->success('下单成功,前往支付', url('myorder/pay', ['order_sn' => $result['order_sn']]));
        }else{
            $result = $orderModel->createOrder($this->adminUser, 'goods', $skuId, $num, FALSE, $params, $remark);
            if ($result === FALSE) {
                $this->error($orderModel->error);
            }
            $this->assign('payments', $payments);
            $this->assign('list', $result);
            return $this->fetch();
        }
    }
    
    /**
     * ajax获取产品属性值
     */
    public function getspec(){
        $params = $this->request->param();
        $id = isset($params['id']) ? intval($params['id']) : 0;
        if($id){
            if(IS_POST){
                $post = $this->request->post();
                $specs = isset($post['specs']) ? trim($post['specs']) : '';
                if(!empty($specs)){
                    $skuInfo = db('goods_sku')->where("goods_id = {$id} AND spec_json='{$specs}' AND status=1 AND is_del=0")->find();
                    if($skuInfo){
                        $return = array(
                            'status'    => 1,
                            'data'      => array(
                                'skuid' => $skuInfo['sku_id'],
                                'price' => ($skuInfo['price'] + $skuInfo['install_price']),
                                'sku'   => $skuInfo['sku_stock'],
                            )
                        );
                    }else{
                        $return['status']   = 0;
                    }
                }else{
                    $return['status']   = 0;
                }
            }
        }else{
            $return['status']   = 0;
        }
        $this->ajaxJsonReturn($return);
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
    
    private function _thumbToBig($src){
        return str_replace("500x500","1000x1000",$src);
    }
}