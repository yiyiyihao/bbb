<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/3/8 0008
 * Time: 17:00
 */


namespace app\common\model;

use think\Model;


class StoreModel extends Model
{
    protected $pk = 'store_id';
    protected $name='store';
    protected $createTime = 'add_time';
    protected $updateTime = 'update_time';
    protected $autoWriteTimestamp = false;

}