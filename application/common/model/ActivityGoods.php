<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/1/14 0014
 * Time: 12:16
 */

namespace app\common\model;


use think\Model;

class ActivityGoods extends Model
{
    //activity_goods

    protected $createTime = 'add_time';
    protected $updateTime = 'update_time';
    protected $autoWriteTimestamp = 'int';
}