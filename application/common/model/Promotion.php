<?php

namespace app\common\model;
use think\Model;

class Promotion extends Model
{
	protected $fields;
	protected $pk = 'promot_id';
	public $promTypes = [
	    'ratio' => '结算百分比',
	    'fix_amount' => '结算固定金额',
	];

	//自定义初始化
    protected function initialize()
    {
        //需要调用`Model`的`initialize`方法
        parent::initialize();
        //TODO:自定义的初始化
    }
    public function save($data = [], $where = [], $sequence = null)
    {
        if (!$data['skus']) {
            $this->error = '请求参数错误';
            return FALSE;
        }
        $promotId = $where && isset($where['promot_id']) ? intval($where['promot_id']): 0;
        $result = parent::save($data, $where, $sequence);
        if (!$promotId) {
            $promotId = $this->promot_id;
        }
        $pskuModel = new \app\common\model\PromotionSku();
        $dataSet = $goodsIds = [];
        foreach ($data['skus'] as $key => $value) {
            $goodsIds[] = $value['goods_id'];
            $map = [
                ['is_del', '=', 0],
                ['promot_id', '=', $promotId],
                ['goods_id', '=', $value['goods_id']],
                ['sku_id', '=', $value['sku_id']],
            ];
            $value['promot_id'] = $promotId;
            $value['promot_type'] = isset($data['promot_type']) ? trim($data['promot_type']) : 'fenxiao';
            $exist = $pskuModel->where($map)->find();
            if ($exist) {
                $value['prom_sku_id'] = $exist['prom_sku_id'];
            }else{
//                 $value['prom_sku_id'] = 0;
            }
            $dataSet[] = $value;
        }
        $result = $pskuModel->saveAll($dataSet);
        if ($where && $goodsIds) {
            $map = [
                'promot_id' => $promotId,
                'goods_id' => ['NOT IN', $goodsIds],
            ];
            $result = $pskuModel->save(['is_del' => 1], $map);
        }
        return $result;
    }
}