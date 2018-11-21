<?php

namespace app\common\model;
use think\Model;

class Store extends Model
{
	public $error;
	
	protected $field = true;

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
}