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
        //渠道/零售商有采购功能
        if (!in_array($this->adminUser['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER])) {
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
        foreach ($info['imgs'] as $k=>$v){
            $imgs[$k]["thumb"] = $v;
            $imgs[$k]["thumb_big"] = $this->_thumbToBig($v);
        }
        $info['imgs'] = $imgs;
//         pre($info);
        $this->assign('info', $info);
        $this->import_resource(array(
            'script'=> 'cart.js,jquery.jqzoom-core.js',
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
        $result = $orderModel->createOrder(ADMIN_ID, 'goods', $skuId, $num, IS_POST, $post, $remark);
        if ($result === FALSE) {
            $this->error($orderModel->error);
        }
        if (IS_POST) {
            $this->success('下单成功,前往支付', url('myorder/pay', ['order_sn' => $result['order_sn']]));
        }else{
            $this->assign('list', $result);
            return $this->fetch();
        }
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