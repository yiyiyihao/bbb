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
     * 更新商品库存
     * @param array $sku 商品属性信息
     * @param int $num 修改商品库存数量(大于0为增加,小于0为减少)
     * @return boolean
     */
    public function _setGoodsStock($sku, $num)
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
    
    public function _checkSku($skuId = 0)
    {
        if(!$skuId){
            $this->error = '参数错误';
            return FALSE;
        }
        $sku = db('goods_sku')->where(['sku_id' => $skuId, 'is_del' => 0])->find();
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