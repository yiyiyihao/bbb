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
        $skus = $this->model->getGoodsSkus($info['goods_id'],$this->adminStore);
        $price=array_column($skus,'price_total');
        $min=min($price);
        $max=max($price);
        $priceTotal=$min;
        if ($max > $min) {
            $priceTotal.='~'.$max;
        }
        $this->assign('price_total',$priceTotal);
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

    public function addCart()
    {
        $skuId = $this->request->param('sku_id', '0', 'intval');
        $factoryId = $this->adminStore['factory_id'];
        $num = $this->request->param('num', 0, 'intval');

        //判断sku_id是否存在
        $where = [
            ['sku_id', '=', $skuId],
            ['is_del', '=', 0],
            ['store_id', '=', $factoryId],
        ];
        $sku = model('goods_sku')->where($where)->find();
        if (!$sku) {
            $this->error('该商品不存在或已经删除');
        }
        if (!$sku['status']) {
            $this->error('该商品已经删除');
        }
        if ($sku['sku_stock'] < $num) {
            $this->error('该商品库存不足');
        }

        //判断是否是自己的商品
        if ($sku['store_id'] == $this->adminStore['store_id']) {
            $this->error('厂商不能自产自销');
        }
        //判断购物车商品是否存在
        $where = [
            ['sku_id', '=', $skuId],
            ['store_id', '=', $this->adminStore['store_id']],
        ];
        $storeId = $this->adminStore['store_id'];
        $exist = \app\common\model\Cart::where(['is_del' => 0, 'store_id' => $storeId, 'sku_id' => $skuId])->find();
        $where = [];
        if ($exist) {
            $num = $exist['num'] + $num;
            if ($sku['sku_stock'] < $num) {
                $this->error('该商品库存不足');
            }
            $data = [
                'num' => $num,
            ];
            $where['cart_id'] = $exist['cart_id'];
        } else {
            $data = [
                'sku_id'   => $skuId,
                'goods_id' => $sku['goods_id'],
                'store_id' => $this->adminStore['store_id'],
                'num'      => $num,
            ];
        }
        $cartModel = new \app\common\model\Cart();
        $result = $cartModel->save($data, $where);
        if ($result === FALSE) {
            $this->error('系统故障，请稍后重试~');
        }
        $this->success('加入购物车成功');
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
            $params['pay_type']=1;
            if ($payCode == 'offline_pay') {
                $params['pay_type']=2;//线下支付
            }
            $order = $orderModel->createOrder($this->adminUser, 'goods', $skuId, $num, IS_POST, $params, $remark);
            if ($order === FALSE) {
                $this->error($orderModel->error);
            }
            $this->success('下单成功,前往支付', url('myorder/pay', ['order_sn' => $order['order_sn'], 'pay_code' => $payCode, 'step' => 2]), ['order_sn'=>$order['order_sn']]);
            //$this->success('下单成功,前往支付', url('myorder/pay', ['order_sn' => $result['order_sn']]));
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
                    if ($this->adminStore['store_type']==STORE_DEALER) {
                        $where=[
                            ['SD.store_id','=',$this->adminStore['store_id']],
                            ['S.status', '=', 1],
                            ['S.is_del', '=', 0],
                        ];
                        $channel=db('store_dealer')->alias('SD')->field('S.store_id,S.store_type')->join('store S','S.store_id=SD.ostore_id')->where($where)->find();
                        if (isset($channel['store_type']) && $channel['store_type'] == STORE_SERVICE_NEW) {
                            $field = 'GS.sku_id,GS.sku_name,GS.sku_sn,GS.sku_thumb,GS.sku_stock,GSS.install_price_service install_price,GSS.price_service price,GS.spec_value,GS.sales';
                            $where = [
                                'GS.goods_id'  => $id,
                                'GS.is_del'    => 0,
                                'GS.status'    => 1,
                                'GS.store_id'  => $this->adminStore['factory_id'],
                                'GS.spec_json' => $specs,
                            ];
                            $joinOn = 'GSS.sku_id = GS.sku_id AND GSS.is_del = 0 AND GSS.`status` = 1 AND GSS.store_id =' . $channel['store_id'];
                            $skuInfo = db('goods_sku')->alias('GS')->field($field)->where($where)->join('goods_sku_service GSS', $joinOn, 'left')->find();
                        }
                    }else{
                        $skuInfo = db('goods_sku')->where("goods_id = {$id} AND spec_json='{$specs}' AND status=1 AND is_del=0")->find();
                    }
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

    public function _getAlias()
    {
        return 'G';
    }
    
    function  _getOrder()
    {
        $order='G.add_time DESC';
        if ($this->adminStore['store_type'] == STORE_DEALER) {
            $order='GS.sort_order ASC';
        }
        return $order;
    }
    function _getWhere(){
        $params = $this->request->param();
        $where = [
            'G.is_del' => 0,
            'G.status' => 1,
            'G.store_id' => $this->adminFactory['store_id'],
        ];
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['G.name'] = ['like','%'.$name.'%'];
            }
        }
        return $where;
    }

    public function _getJoin()
    {
        $join=[];
        if ($this->adminStore['store_type'] == STORE_DEALER) {
            $where=[
                ['SD.store_id','=',$this->adminStore['store_id']],
                ['S.status', '=', 1],
                ['S.is_del', '=', 0],
            ];
            $channel=db('store_dealer')->alias('SD')->field('S.store_id,S.store_type')->join('store S','S.store_id=SD.ostore_id')->where($where)->find();
            if (isset($channel['store_type']) && $channel['store_type'] == ADMIN_SERVICE_NEW) {
                $join[]=['goods_service GS','G.goods_id = GS.goods_id AND GS.is_del=0 and GS.status=1 and GS.store_id='.$channel['store_id']];
            }
        }
        return $join;
    }

    public function _afterList($list)
    {
        if ($this->adminStore['store_type'] == STORE_DEALER) {
            foreach ($list as $k=>$v) {
                $list[$k]['min_price']=$list[$k]['min_price_service'];
                $list[$k]['max_price']=$list[$k]['max_price_service'];
            }
        }
        return $list;
    }
    
    private function _thumbToBig($src){
        return str_replace("500x500","1000x1000",$src);
    }
}