<?php
namespace app\common\model;
use think\Model;

class Servicer extends Model
{
	public $error;
	protected $pk = 'store_id';
	protected $table;
	
	protected $field = true;
	//自定义初始化
	protected function initialize()
	{
	    $this->table = $this->config['prefix'].'store_servicer';
	    parent::initialize();
	}
}