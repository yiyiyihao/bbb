<?php
namespace app\common\model;
use think\Model;

class Channel extends Model
{
	public $error;
	protected $pk = 'store_id';
	protected $table = 'store_channel';
	
	protected $field = true;
	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
}