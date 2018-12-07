<?php
namespace app\common\model;
use think\Model;

class Store extends Model
{
	public $error;
	protected $pk = 'store_id';
	
	protected $field = true;
	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
        
    }
    public static function init()
    {
        self::event('after_insert', function ($data) {
            self::_after($data);
            db('store_account')->insert(['store_id' => $data['store_id']]);
        });
        self::event('after_update', function ($data) {
            self::_after($data, $data['store_id']);
        });
    }
    private static function _after($store, $storeId = 0)
    {
        if (!$store) {
            return FALSE;
        }
        $store = $store->toArray();
        $storeType = isset($store['store_type']) ? $store['store_type'] : '';
        switch ($storeType) {
            case 1:
                $model = 'factory';
                break;
            case 2:
                $model = 'channel';
                break;
            case 3:
                $model = 'dealer';
                break;
            case 4:
                $model = 'servicer';
                break;
            default:
                return FALSE;
                break;
        }
        $where = [];
        if ($storeId) {
            $where = ['store_id' => $storeId];
        }
        return $result = model($model)->save($store, $where);
    }
}