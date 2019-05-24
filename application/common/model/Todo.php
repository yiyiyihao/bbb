<?php


namespace app\common\model;


use think\Model;

class Todo extends Model
{
    protected $createTime = 'add_time';
    protected $updateTime = 'update_time';
    protected $autoWriteTimestamp = 'int';

}