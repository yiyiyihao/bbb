<?php
namespace app\common\model;
use think\Model;

class UserData extends Model
{
	public $error;
	protected $fields;
	protected $pk = 'udata_id';

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
}