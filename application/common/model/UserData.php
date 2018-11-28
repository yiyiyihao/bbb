<?php
namespace app\common\model;
use think\Model;

class UserData extends Model
{
	public $error;
	protected $fields;

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
}