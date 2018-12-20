<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2018/12/20 0020
 * Time: 16:55
 */

namespace app\common\model;


use think\Model;

class Commission extends Model
{
    public $error;
    protected $fields;
    protected $pk = 'log_id';
    protected $table='store_commission';

    //自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }

}