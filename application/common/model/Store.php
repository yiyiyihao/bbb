<?php
namespace app\common\model;
use think\Model;

class Store extends Model
{
	public $error;
	protected $pk = 'store_id';
	
	protected $field = true;
	protected $updateWhere;
	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
        
    }
    public static function init()
    {
        self::event('after_insert', function ($store) {
            self::_after($store);
        });
        self::event('after_update', function ($store) {
            $storeType = db('store')->where(['store_id' => $store['store_id']])->value('store_type');
            self::_after($store, $storeType);
        });
    }
    private static function _after($store, $storeType = 0)
    {
        if (!$store) {
            return FALSE;
        }
        $store = $store->toArray();
        $storeType = $storeType ? $storeType : (isset($store['store_type']) ? $store['store_type'] : '');
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
        $result = model($model)->save($store);
        $userModel = model('user');
        if ($store['password']) {
            $store['password'] = $userModel->pwdEncryption($store['password']);
        }
        $result = $userModel->save($store);
        return TRUE;
    }
}