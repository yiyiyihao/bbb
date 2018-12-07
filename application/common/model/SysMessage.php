<?php
namespace app\common\model;
use think\Model;

class SysMessage extends Model
{
    public $error;
    protected $fields;
    protected $pk = 'msg_id';
    
    //自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
    public function save($data = [], $where = [], $sequence = null)
    {
        parent::checkBeforeSave($data, $where);
        if (!$this->checkBeforeSave($data, $where)) {
            return false;
        }
        $flag = $this->exists;
        $result = $msgId = parent::save($data, $where, $sequence);
       
        return $result;
    }
    
}