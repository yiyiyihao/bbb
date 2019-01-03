<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2018/12/29 0029
 * Time: 15:18
 */

namespace app\common\model;


use think\Model;

class WebPage extends Model
{
    protected $pk='id';
    protected $createTime = 'add_time';
    protected $updateTime = 'update_time';
    protected $autoWriteTimestamp = 'int';

    // 定义全局的查询范围
    protected function base($query)
    {
        $query->where('is_del', 0);
    }

}