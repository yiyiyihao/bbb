<?php
namespace app\common\model;
use think\Model;

class UserAddress extends Model
{
	public $error;
	protected $fields;
	protected $pk = 'address_id';

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
}