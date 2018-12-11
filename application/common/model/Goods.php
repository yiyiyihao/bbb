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
    public function getGoodsSkus($goodsId = 0)
    {
        if ($goodsId <= 0) {
            $this->error = '参数错误';
            return FALSE;
        }
        $where = ['is_del' => 0, 'status' => 1, 'goods_id' => $goodsId];
        $skus = db('goods_sku')->field('sku_id, sku_name, sku_sn, sku_thumb, sku_stock, install_price, price, spec_value, sales')->order('sort_order ASC, update_time DESC')->where($where)->select();
        if ($skus && count($skus) == 1) {
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