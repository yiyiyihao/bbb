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
        self::event('after_insert', function ($data) {
            self::_after($data);
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
        $result = model($model)->save($store, $where);
        if ($result !== FALSE) {
            $userModel = new \app\common\model\User();
            if ($store['password']) {
                $store['password'] = $userModel->pwdEncryption($store['password']);
            }else{
                unset($store['password']);
            }
            $userTabel = db('user');
            if (!$storeId) {
                $result = $userModel->save($store);
            }else{
                if (isset($store['username'])) {
                    unset($store['username']);
                }
                $result = $userModel->save($store, ['store_id' => $store['store_id'], 'group_id' => $store['group_id'], 'is_del' => 0]);
            }
            return TRUE;
        }
        return FALSE;
    }
}