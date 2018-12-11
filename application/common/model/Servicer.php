<?php
namespace app\common\model;
use think\Model;

class Servicer extends Model
{
	public $error;
	protected $pk = 'store_id';
	protected $table;
	
	protected $field = true;
	//自定义初始化
	protected function initialize()
	{
	    $this->table = $this->config['prefix'].'store_servicer';
	    parent::initialize();
	}
	
	//根据region_id获取店铺id
	public function getStoreFromRegion($regionId = FALSE){
	    if(!empty($regionId)){
	        $where = [
	            'region_id'=>$regionId,
	        ];
	        $info = $this->where($where)->find();
	        if($info) return $info['store_id'];
	        return false;
	    }
	}
}