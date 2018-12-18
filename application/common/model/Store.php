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
            db('store_finance')->insert(['store_id' => $data['store_id']]);
        });
        self::event('after_update', function ($data) {
            self::_after($data, $data['store_id']);
        });
    }
    public function save($data = [], $where = [], $sequence = null){
        if (!$where) {
            ;
        }
        //获取商户编号
        $data['store_no'] = self::_getMchKey();
        return parent::save($data, $where);
    }
    private static function _after($store, $storeId = 0)
    {
        if (!$store) {
            return FALSE;
        }
        $store = $store->toArray();
        $storeType = isset($store['store_type']) ? $store['store_type'] : '';
        switch ($storeType) {
            case STORE_FACTORY:
                $model = 'factory';
                break;
            case STORE_CHANNEL:
                $model = 'channel';
                break;
            case STORE_DEALER:
                $model = 'dealer';
                break;
            case STORE_SERVICE:
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
    private static function _getMchKey()
    {
        $key = get_nonce_str(10, 2);
        //判断商户密钥是否存在
        $info = db('store')->where(['store_no' => $key])->find();
        if ($info){
            return $this->_getMchKey();
        }else{
            return $key;
        }
    }
}