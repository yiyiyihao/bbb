<?php
namespace app\common\model;
use think\Model;

class Cart extends Model
{
	public $error;
	protected $pk = 'cart_id';
	
	protected $field = true;
	//自定义初始化
	protected function initialize()
	{
	    parent::initialize();
	}
}