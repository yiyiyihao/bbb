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
            //获取商户编号
            $storeNo = self::_getMchKey($data['store_type']);
            if ($storeNo === FALSE) {
                $this->error = '商户编号生成数量限制(每日)';
                return FALSE;
            }
            $data['store_no'] = $storeNo;
        }
        return parent::save($data, $where);
    }

    public function notify($data,$user)
    {
        if (in_array($data['store_type'], [STORE_DEALER]) && (!isset($data['ostore_id']) || $data['ostore_id']<=0) ) {
            return false;
        }
        if (isset($data['check_status']) && $data['check_status']==1) {
            return false;
        }
        //发送工单通知给服务商
        $push = new \app\common\service\PushBase();
        $todoData = [
            'type'          => 2,//1首次工单分派，2重新发派工单，3线下收款确认，4商户审核，5.....
            'store_id'      => in_array($data['store_type'],[STORE_DEALER])? $data['ostore_id']:$data['factory_id'],
            'post_store_id' => $data['store_id'],
            'post_user_id'  => $user['user_id'],
            'url'           => url('store/check', ['id' => $data['store_id']]),
            'title'         => '【审核】'.$data['user_name'].'提交了'.get_store_type($data['store_type']).'申请，请予以审核',
        ];
        $todoModel = new Todo($todoData);
        $todoModel->save();
        $todoId = $todoModel->id;
        if (!$todoId) {
            $this->error='系统故障';
            return false;
        }
        $addTime = time();
        $sendData = [
            'type'            => 'store',
            'title'           => $todoData['title'],
            'url'             => $todoData['url'],
            'todo_id'         => $todoId,
            'todo_type'       => $todoData['type'],
            'add_time'        => getTime($addTime),
        ];
        $result=db('store')->where(['store_id'=>$todoData['store_id']])->update(['todo_id'=>$todoId]);
        if ($result === false) {
            $this->error='系统故障';
            return false;
        }
        //在线推送
        $push->sendToGroup('store'.$todoData['store_id'], json_encode($sendData));
        return true;
        //短信通知
        //$store = db('store')->alias('p1')
        //    ->field('p2.user_id,p1.mobile')
        //    ->join('user p2', 'p1.store_id=p2.store_id')
        //    ->where(['p2.store_id' => $todoData['store_id']])
        //    ->find();
        //if (!empty($store) && !empty($store['mobile']) && check_mobile($store['mobile'])) {
        //    $param = [
        //        'phone'         => $store['mobile'],
        //        'user_id'       => $store['user_id'],
        //        'workOrderType' => $worder['work_order_type'],
        //        'worderSn'      => $worder['worder_sn'],
        //        'installerName' => $installer['realname'],
        //    ];
        //    $informModel = new \app\common\model\LogInform();
        //    $informModel->sendInform($worder['factory_id'], 'sms', $param, 'service_work_order_refuse');
        //}

    }

    public function del($storeId = 0, $user = [], $check = TRUE)
    {
        if (!$storeId) {
            $this->error = lang('param_error');
            return FALSE;
        }
        $info = $this->getStoreDetail($storeId);
        if (!$info) {
            $this->error = lang('param_error');
            return FALSE;
        }
        if (!in_array($user['admin_type'], [ADMIN_FACTORY, ADMIN_CHANNEL])) {
            $this->error = lang('NO_OPERATE_PERMISSION');
            return FALSE;
        }
        if ($user['admin_type'] == ADMIN_FACTORY && $info['factory_id'] != $user['store_id']) {
            $this->error = lang('NO_OPERATE_PERMISSION');
            return FALSE;
        }
        if ($user['admin_type'] == ADMIN_CHANNEL && $info['ostore_id'] != $user['store_id']) {
            $this->error = lang('NO_OPERATE_PERMISSION');
            return FALSE;
        }
        $flag = $this->checkDel($info, $user);
        if ($flag === FALSE) {
            return FALSE;
        }
        if ($user['admin_type'] == ADMIN_FACTORY || !$check) {
            $data = ['is_del' => 1, 'update_time' => time()];
            //1.删除商户信息
            $result = $this->where(['store_id' => $info['store_id']])->update($data);
            if ($result === FALSE) {
                $this->error = lang('SYSTEM_ERROR');
                return FALSE;
            }
            //2.删除商户对应管理账户信息
            $user = db('user')->where(['store_id' => $info['store_id'], 'is_del' => 0])->update($data);
        }else{
            //判断是否已存在未处理的编辑申请
            $exist = db('store_action_record')->where(['to_store_id' => $info['store_id'], 'action_type' => 'del', 'check_status' => 0])->find();
            if ($exist) {
                $this->error = lang('存在待审核的删除操作');
                return FALSE;
            }
            $data = [
                'factory_id'        => $user['factory_id'],
                'action_store_id'   => $user['store_id'],
                'action_user_id'    => $user['user_id'],
                'to_store_id'       => $info['store_id'],
                'to_store_name'     => isset($info['name']) ? trim($info['name']) : '',
                'action_type'       => 'del',
                'before'            => $info ? json_encode($info): '',
                'after'             => '',
                'modify'            => '',
                'check_status'      => 0,
                'add_time'          => time(),
                'update_time'       => time(),
            ];
            $result = db('store_action_record')->insertGetId($data);
        }
        return TRUE;
    }
    public function checkDel($info, $user)
    {
        //判断商户类型
        $storeType = $info['store_type'];
        switch ($storeType) {
            case STORE_FACTORY:
                $this->error = lang('NO_OPERATE_PERMISSION');
                return FALSE;
                //判断厂商下是否存在其它商户
                $exist = $this->where(['factory_id' => $info['store_id'], 'is_del' => 0])->find();
                $msg = '厂商下存在其它商户数据，不允许删除';
                if (!$exist) {
                    //判断厂商是否有订单数据
                    $exist = db('order')->where(['store_id' => $info['store_id']])->find();
                    $msg = '厂商下有订单数据,不允许删除';
                    if (!$exist) {
                        //判断厂商下是否有安装工程师数据
                        $exist = db('user_installer')->where(['factory_id' => $info['store_id']])->find();
                        $msg = '厂商下存在安装工程师,不允许删除';
                        if (!$exist) {
                            //判断服务商是否有工单数据
                            $exist = db('work_order')->where(['factory_id' => $info['store_id']])->find();
                            $msg = '厂商下存在工单数据,不允许删除';
                        }
                    }
                }
                break;
            case STORE_CHANNEL:
                if ($user['admin_type'] != ADMIN_FACTORY) {
                    $this->error = lang('NO_OPERATE_PERMISSION');
                    return FALSE;
                }
                //判断渠道商下级是否存在经销商
                $exist = $this->alias('S')->join('store_dealer SD', 'SD.store_id = S.store_id', 'INNER')->where(['S.is_del' => 0, 'SD.ostore_id' => $info['store_id']])->find();
                $msg = '渠道商下存在零售商，不允许删除';
                if (!$exist) {
                    //判断渠道商是否有订单数据
                    $exist = db('order')->where(['user_store_id' => $info['store_id']])->find();
                    $msg = '渠道商下有订单数据,不允许删除';
                }
                break;
            case STORE_DEALER:
                //判断零售商是否有订单数据
                $exist = db('order')->where(['user_store_id' => $info['store_id']])->find();
                $msg = '零售商有订单数据,不允许删除';
                break;
            case STORE_SERVICE:
                if ($user['admin_type'] != ADMIN_FACTORY) {
                    $this->error = lang('NO_OPERATE_PERMISSION');
                    return FALSE;
                }
                //判断服务商是否有安装工程师数据
                $exist = db('user_installer')->where(['store_id' => $info['store_id']])->find();
                $msg = '服务商下存在安装工程师,不允许删除';
                if (!$exist) {
                    //判断服务商是否有工单数据
                    $exist = db('work_order')->where(['store_id' => $info['store_id']])->find();
                    $msg = '服务商有工单数据,不允许删除';
                }
                break;
            case STORE_SERVICE_NEW:
                if ($user['admin_type'] != ADMIN_FACTORY) {
                    $this->error = lang('NO_OPERATE_PERMISSION');
                    return FALSE;
                }
                //判断服务商是否有安装工程师数据
                $exist = db('user_installer')->where(['store_id' => $info['store_id']])->find();
                $msg = '服务商下存在安装工程师,不允许删除';
                if (!$exist) {
                    //判断服务商是否有工单数据
                    $exist = db('work_order')->where(['store_id' => $info['store_id']])->find();
                    $msg = '服务商有工单数据,不允许删除';
                }
                //判断渠道商下级是否存在经销商
                $exist = $this->alias('S')->join('store_dealer SD', 'SD.store_id = S.store_id', 'INNER')->where(['S.is_del' => 0, 'SD.ostore_id' => $info['store_id']])->find();
                $msg = '渠道商下存在零售商，不允许删除';
                if (!$exist) {
                    //判断渠道商是否有订单数据
                    $exist = db('order')->where(['user_store_id' => $info['store_id']])->find();
                    $msg = '渠道商下有订单数据,不允许删除';
                }
                break;
            default:
                return TRUE;
                break;
        }
        if ($exist) {
            $this->error = lang($msg);
            return FALSE;
        }
        return TRUE;
    }
    
    public function getStoreDetail($storeId = 0)
    {
        $info = $this->where(['store_id' => $storeId, 'is_del' => 0])->find();
        if(!$info){
            $this->error = '商户不存在';
            return FALSE;
        }
        if ($info) {
            switch ($info['store_type']) {
                case 1:
                    $model = 'factory';
                    $groupId = GROUP_FACTORY;
                    break;
                case 2:
                    $model = 'channel';
                    $groupId = GROUP_CHANNEL;
                    break;
                case 3:
                    $model = 'dealer';
                    $groupId = GROUP_DEALER;
                    break;
                case 4:
                    $model = 'servicer';
                    $groupId = GROUP_SERVICE;
                    break;
                case 6:
                    $model = 'servicer';
                    $groupId = GROUP_SERVICE_NEW;
                    break;
                default:
                    return FALSE;
                    break;
            }
            $detail = model($model)->where(['store_id' => $info['store_id']])->find();
            if ($detail) {
                $info = $info->toArray();
                $detail = $detail->toArray();
                $info = array_merge($info, $detail);
            }
            $info['manager'] = db('user')->where(['store_id' => $info['store_id'], 'is_admin' => 1, 'is_del' => 0, 'group_id' => $groupId])->find();
            if ($info['store_type'] == STORE_DEALER) {
                //获取渠道商名称
                $channel = $this->where(['store_id' => $info['ostore_id']])->field('name, store_no')->find();
                $info['channel_name'] = $channel ? $channel['name'] : '';
                $info['channel_no'] = $channel ? $channel['store_no'] : '';
            }
        }
        return $info;
    }
    //根据region_id获取店铺id
    public function getStoreFromRegion($regionId = FALSE, $factoryId = 1){
        if(!empty($regionId)){
            $where = [
                'region_id' =>  $regionId,
                //'store_type'=> STORE_SERVICE,
                'is_del'    => 0,
                'status'    => 1,
                'factory_id'=> $factoryId,
            ];
            $info = db('store')->where($where)->whereIn('store_type',[STORE_SERVICE,STORE_SERVICE_NEW])->find();
            if($info) return $info['store_id'];
            return false;
        }
    }
    
    private static function _after($store, $storeId = 0)
    {
        if (!$store) {
            return FALSE;
        }
        $store = $store->toArray();
        $storeType = isset($store['store_type']) ? $store['store_type'] : '';
        $model = self::_getmodel($storeType);
        if (!$model) {
            return false;
        }
        $where = [];
        if ($storeId) {
            //判断当前商户ID是否存在
            $exist = model($model)->find($storeId);
            if ($exist) {
                $where = ['store_id' => $storeId];
            }
            if (isset($store['last_type']) && $store['last_type'] != $storeType) {
                $model1 = self::_getmodel($store['last_type']);
                model($model1)->where(['store_id' => $storeId])->delete();
            }
        }
        return $result = model($model)->save($store, $where);
    }
    private static function _getmodel($storeType)
    {
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
            case 5:
                $model = 'echodata';
                break;
            case 6:
                $model = 'servicer';
                break;
            default:
                return FALSE;
                break;
        }
        return $model;
    }
    public static function _getMchKey($storeType = 1)
    {
        $key = get_nonce_str(10, 2);
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
            return self::_getMchKey($storeType);
        }else{
            return $key;
        }
    }
}