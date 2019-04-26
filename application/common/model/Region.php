<?php
namespace app\common\model;
use think\Model;

class Region extends Model
{
	public $error;
	protected $pk = 'region_id';
	protected $table;
	
	protected $field = true;
	//自定义初始化
	protected function initialize()
	{
	    parent::initialize();
	}
}