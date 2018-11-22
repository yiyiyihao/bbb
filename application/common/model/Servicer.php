<?php
namespace app\common\model;
use think\Model;

class Servicer extends Model
{
	public $error;
	protected $pk = 'store_id';
	protected $table = 'store_servicer';
	
	protected $field = true;
	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
}