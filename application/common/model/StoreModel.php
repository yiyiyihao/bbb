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
    protected $autoWriteTimestamp = true;


    //public static function init()
    //{
    //    self::event('after_write', function ($store) {
    //        if (!isset($store['store_no']) || empty($store['store_no'])) {
    //            self::getMchKey($store['store_type']);
    //            return false;
    //        }
    //    });
    //}


    private static function getMchKey($storeType = 1)
    {
        //商户编号：商户类型+“年月日”+“4位随机数字”
        $key = $storeType.date('ymd').get_nonce_str(4, 2);
        //判断当日新增商户数量是否超过9999个
        $beginToday = mktime(0,0,0,date('m'),date('d'),date('Y')); //今日开始时间戳
        $exist = db('store')->where(['store_type' => $storeType, 'add_time' => ['>=', $beginToday]])->count();
        if ($exist >= 9999) {
            return FALSE;
        }
        //判断商户编号是否存在
        $info = db('store')->where(['store_no' => $key])->find();
        if ($info){
            return self::getMchKey($storeType);
        }else{
            return $key;
        }
    }

}