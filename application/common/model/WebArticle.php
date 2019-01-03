<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2018/12/26 0026
 * Time: 17:11
 */

namespace app\common\model;


use think\Model;

class WebArticle extends Model
{
    protected $pk='id';
    protected $type = [
        'menu_id' => 'array',
    ];


}