<?php

namespace app\admin\model;
use think\Model;

class Store extends Model
{
	public $error;
	public $storeTypes;
	protected $pk = 'store_id';
	
	protected $field = true;
	//自定义初始化
    protected function initialize()
    {
        $this->storeTypes = [
            1 => '厂商',
            2 => '渠道商',
            3 => '经销商',
            4 => '服务商',
        ];
        parent::initialize();
    }
}