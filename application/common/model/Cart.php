<?php
namespace app\common\model;
use think\Model;

class Cart extends Model
{
	public $error;
	protected $pk = 'cart_id';
	protected $field = true;
    protected $createTime = 'add_time';
    protected $updateTime = 'update_time';
    protected $autoWriteTimestamp = 'int';
}