<?php
namespace app\common\model;
use think\Model;

class UserDistributor extends Model
{
	public $error;
	protected $fields;
	protected $pk = 'distrt_id';

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
    public function save($data = [], $where = [], $sequence = null)
    {
        if ($where && isset($data['check_status']) && $data['check_status'] == 1) {
            $code = self::_getCode();
            if ($code === FALSE) {
                $this->error = '分销员code生成数量限制(每日)';
                return FALSE;
            }
            $data['distrt_code'] = $code;
        }
        parent::save($data, $where, $sequence);
    }
    
    private function _getCode()
    {
        //code：“年月日”+“6位随机数字”
        $code = date('ymd').get_nonce_str(6, 2);
        //判断当日新增工程师数量是否超过9999个
        $beginToday = mktime(0,0,0,date('m'),date('d'),date('Y')); //今日开始时间戳
        $exist = $this->where(['add_time' => ['>=', $beginToday]])->count();
        if ($exist >= 9999) {
            return FALSE;
        }
        $info = $this->where(['distrt_code' => $code])->find();
        if ($info){
            return $this->_getCode();
        }else{
            return $code;
        }
    }
}