<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2018/12/27 0027
 * Time: 11:00
 */

namespace app\common\model;


use think\Model;

class WebMenu extends Model
{

    protected $createTime = 'add_time';
    protected $updateTime = 'update_time';
    protected $autoWriteTimestamp = 'int';

    // 定义全局的查询范围
    protected function base($query)
    {
        $query->where('m.is_del', 0)->order('m.sort');
    }

}