<?php
namespace app\common\model;
use think\Model;

class UserBank extends Model
{
	public $error;
	protected $fields;
	protected $pk = 'bank_id';

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
}