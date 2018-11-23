<?php
namespace app\common\model;
use think\Model;

class Dealer extends Model
{
	public $error;
	protected $pk = 'store_id';
	protected $table;
	
	protected $field = true;
	//自定义初始化
	protected function initialize()
	{
	    $this->table = $this->config['prefix'].'store_dealer';
	    parent::initialize();
	}
}