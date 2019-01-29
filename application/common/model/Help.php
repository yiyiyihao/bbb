<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/1/28 0028
 * Time: 19:34
 */

namespace app\common\model;


use think\Model;

class Help extends Model
{
    protected $createTime = 'add_time';
    protected $updateTime = 'update_time';
    protected $autoWriteTimestamp = 'int';
    protected $type = [
        'visible_store_type' => 'array',
    ];

    public function setAnswerAttr($value)
    {
        return trim($value);
    }

    public function setTitleAttr($value)
    {
        return trim($value);
    }



}