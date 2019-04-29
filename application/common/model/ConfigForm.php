<?php


namespace app\common\model;


use think\Model;

class ConfigForm extends Model
{
    protected $createTime = 'add_time';
    protected $updateTime = 'update_time';
    protected $autoWriteTimestamp = 'int';
    // 设置json类型字段
    protected $json = ['value'];
    //protected $type = [
    //    'value' => 'array',
    //];

}