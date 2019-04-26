<?php
namespace app\common\model;
use think\Model;

class UserWithdraw extends Model
{
	public $error;
	protected $fields;
	protected $pk = 'log_id';

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
}