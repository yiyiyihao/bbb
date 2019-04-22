<?php

namespace app\common\model;
use think\Model;

class Goods extends Model
{
	protected $fields;
	protected $pk = 'goods_id';

	//自定义初始化
    protected function initialize()
    {
        //需要调用`Model`的`initialize`方法
        parent::initialize();
        //TODO:自定义的初始化
    }
    /**
     * 更新产品库存
     * @param array $sku 产品属性信息
     * @param int $num 修改产品库存数量(大于0为增加,小于0为减少)
     * @return boolean
     */
    public function setGoodsStock($sku, $num)
    {
        if (!$sku || !$num) {
            return FALSE;
        }
        $stockType = $num > 0 ? 'inc' : 'dec';
        $saleType = $num > 0 ? 'dec' : 'inc';
        $step = abs($num);
        $result = db('goods_sku')->where(['sku_id' => $sku['sku_id']])->update(['sku_stock' => [$stockType, $step], 'sales' => [$saleType, $step]]);
        if ($result !== FALSE){
            $result = db('goods')->where(['goods_id' => $sku['goods_id']])->update(['goods_stock' => [$stockType, $step], 'sales' => [$saleType, $step]]);
            if ($result !== FALSE) {
                return TRUE;
            }
        }
        return FALSE;
    }
    public function checkGoods($goodsId = 0)
    {
        if(!$goodsId){
            $this->error = '参数错误';
            return FALSE;
        }
        $goods = $this->where(['goods_id' => $goodsId, 'is_del' => 0])->find();
        if (!$goods) {
            $this->error = '产品不存在或已删除';
            return FALSE;
        }
        if (!$goods['status']) {
            $this->error = '产品已下架';
            return FALSE;
        }
        $goods['specs_json'] = $goods['specs_json'] ? json_decode($goods['specs_json'], TRUE) : [];
        $goods['imgs'] = $goods['imgs'] ? json_decode($goods['imgs'], TRUE) : [];
        
        $data = $this->getGoodsSkus($goodsId);
        if (is_int($data)) {
            $goods['sku_id'] = $data;
            $goods['skus'] = [];
        }elseif (is_array($data)){
            $goods['sku_id'] = 0;
            $goods['skus'] = $data;
        }
        return $goods;
    }
    /**
     * 获取产品规格列表
     * @param int $goodsId
     * @return array
     */
    public function getGoodsSkus($goodsId = 0,$store=[],$flag=true)
    {
        if ($goodsId <= 0) {
            $this->error = '参数错误';
            return FALSE;
        }
        if (isset($store['store_type']) && $store['store_type']==STORE_DEALER) {//新服务商旗下的零售商按其所属服务商指定的价格进行采购
            $where=[
                ['SD.store_id','=',$store['store_id']],
                ['S.status', '=', 1],
                ['S.is_del', '=', 0],
            ];
            $channel=db('store_dealer')->alias('SD')->field('S.store_id,S.store_type')->join('store S','S.store_id=SD.ostore_id')->where($where)->find();
            if (isset($channel['store_type']) && $channel['store_type'] == STORE_SERVICE_NEW) {
                $field = 'GS.sku_id,GS.sku_name,GS.sku_sn,GS.sku_thumb,GS.sku_stock,GSS.install_price_service install_price,GSS.price_service price,(GSS.install_price_service+GSS.price_service) as price_total,GS.spec_value,GS.sales';
                $where = [
                    'GS.goods_id'  => $goodsId,
                    'GS.is_del'    => 0,
                    'GS.status'    => 1,
                    'GS.store_id'  => $store['factory_id'],
                    //'GS.spec_json' => ['NEQ', ''],
                ];
                $joinOn = 'GSS.sku_id = GS.sku_id AND GSS.is_del = 0 AND GSS.`status` = 1 AND GSS.store_id =' . $channel['store_id'];
                $skus = db('goods_sku')->alias('GS')->field($field)->where($where)->join('goods_sku_service GSS', $joinOn, 'left')->select();
                return $skus;
            }
        }
        $where = ['GS.is_del' => 0, 'GS.status' => 1, 'GS.goods_id' => $goodsId];
        $field='GS.sku_id,GS.sku_name,GS.sku_sn,GS.sku_thumb,GS.sku_stock,GS.install_price,GS.price,(GS.install_price+GS.price) as price_total,GS.spec_value,GS.sales';
        $skus = db('goods_sku')->alias('GS')->field($field)->order('GS.sort_order ASC,GS.update_time DESC')->where($where)->select();
        if ($flag && $skus && count($skus) == 1) {
            $sku = reset($skus);
            if ($sku && $sku['spec_value'] == "") {
                return $sku['sku_id'];
            }
        }
        return $skus;
    }
    public function checkSku($skuId = 0, $storeId = 0)
    {
        if(!$skuId){
            $this->error = '参数错误';
            return FALSE;
        }
        $where = ['sku_id' => $skuId, 'is_del' => 0];
        if ($storeId) {
            $where['store_id'] = $storeId;
        }
        $sku = db('goods_sku')->where($where)->find();
        if (!$sku) {
            $this->error = '产品不存在或已删除';
            return FALSE;
        }
        if (!$sku['status']) {
            $this->error = '产品已下架';
            return FALSE;
        }
        return $sku;
    }
}