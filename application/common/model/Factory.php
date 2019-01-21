<?php
namespace app\common\model;
use think\Model;

class Factory extends Model
{
	public $error;
	protected $pk = 'store_id';
	protected $table;
	
	protected $field = true;
	//自定义初始化
    protected function initialize()
    {
        $prefix = $this->getConfig('prefix');
        $this->table = $prefix.'store_factory';
        parent::initialize();
    }
}