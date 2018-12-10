<?php
namespace app\common\model;
use think\Model;

class StoreFinance extends Model
{
	public $error;
	protected $pk = 'store_id';
	
	protected $field = true;
	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
    public function financeChange($storeId = 0, $change = [], $action = '', $remark = '')
    {
        $info = $this->financeDetail($storeId);
        if (!$info) {
            return FALSE;
        }
        if (!$change || !is_array($change)){
            $this->error = '参数错误';
            return FALSE;
        }
        $data = [];
        foreach ($change as $key => $value) {
            if ($value >= 0) {
                $data[$key] = ['inc', $value];
            }else{
                $data[$key] = ['dec', abs($value)];
            }
        }
        $result = $this->where(['store_id' => $storeId])->update($data);
        if ($result === FALSE) {
            $this->error = '系统异常';
            return FALSE;
        }
        return TRUE;
    }
    public function financeDetail($storeId = 0)
    {
        $info = $this->where(['store_id' => $storeId])->find();
        if (!$info) {
            $this->error = '参数错误';
            return FALSE;
        }
        return $info;
    }
}