<?php
namespace app\common\model;
use think\Db;
use think\Model;

class WorkOrder extends Model
{
	public $error;
	protected $fields;
	protected $pk = 'worder_id';
    protected $createTime = 'add_time';
    protected $updateTime = 'update_time';
    protected $autoWriteTimestamp = 'int';

    //腾讯地图KEY
    private $mapKey='TTZBZ-33P35-GBWIX-QOANN-MF6IJ-EFBDX';

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
    
    /**
     * 创建工单
     */
    public function save($data = [], $where = [], $sequence = null,$udata_id=0)
    {
        parent::checkBeforeSave($data, $where);
        if (!$this->checkBeforeSave($data, $where)) {
            return false;
        }
        $flag = $this->exists;
        if (!$flag) {
            $sn = $data['worder_sn'] = $this->_getWorderSn();
        }
        $result = $worderId = parent::save($data, $where, $sequence);
        if (!$flag) {
            $worder = [
                'worder_sn'    => $sn,
                'worder_id'    => $worderId,
                'post_user_id' => $data['post_user_id'],
                'phone'        => $data['phone'],
            ];
            $user = db('user')->where(['user_id' => $worder['post_user_id']])->find();
            //保存用户信息，如果有
            if (!empty($user) && isset($data['phone'])  && $data['phone'] && isset($data['user_name']) && $data['user_name']  && $user['phone'] == $data['phone'] && $user['realname'] != $data['user_name']) {
                db('user')->where(['user_id'=>$user['user_id']])->update(['realname'=>$data['user_name'],'update_time'=>time()]);
                $user['realname']=$data['user_name'];
            }
            if (empty($user)) {
                $user=db('user_data')->where(['is_del' => 0])->find($udata_id);
            }
            //工单日志
            $this->worderLog($worder, $user, 0, '创建工单');
            //发送工单通知给服务商
            $this->notify($worder,$data,$where,$user);
            //更新客户信息
            $this->UpdateStoreUser($user,$worder);

            return $sn;
        }
        return $result;
    }

    //更新客户信息
    public function UpdateStoreUser($postUser, $workOrder)
    {
        if ($postUser['admin_type'] == ADMIN_DEALER) {
            $storeUser = StoreUser::where([
                'store_id' => $postUser['store_id'],
                'mobile'   => $workOrder['phone'],
                'is_del'   => 0,
            ])->find();
            if ($storeUser && $storeUser['user_type'] == 0) {//成交客户
                $storeUser->user_type = 1;
                $storeUser->save();
            }
        }
    }
    public function notify($worder, $data, $flag=false)
    {
        //发送工单通知给服务商
        $push = new \app\common\service\PushBase();
        $groupId = db('user')->where('user_id', $data['post_user_id'])->value('group_id');
        $todoData = [
            'type'          => 1,//待分配工单
            'store_id'      => $data['store_id'],
            'post_store_id' => $data['post_store_id'],
            'post_user_id'  => $data['post_user_id'],
            'title'         => '【工单分派】' . get_group_name($groupId) . '提交了新的' . get_work_order_type($data['work_order_type']) . '请尽快分派',//待分配工单
        ];
        $todoModel = new Todo($todoData);
        $todoModel->save();
        $todoId = $todoModel->id;
        if (!$todoId) {
            $this->error='系统故障';
            return false;
        }
        $todoModel->url=url('workorder/dispatch', ['id' => $worder['worder_id'],'todo_id'=>$todoId]);
        $todoModel->save();

        $addTime = isset($worder['add_time']) ? $worder['add_time'] : time();
        $sendData = [
            'type'            => 'todo',
            'title'           => $todoData['title'],
            'url'             => $todoModel->url,
            'todo_id'         => $todoId,
            'todo_type'       => $todoData['type'],
            'add_time'        => getTime($addTime),
        ];
        $result=db('work_order')->where(['worder_id'=>$worder['worder_id']])->update(['todo_id'=>$todoId]);
        if ($result === false) {
            $this->error='系统故障';
            return false;
        }
        //发送给服务商在线管理员
        $push->sendToGroup('store'.$data['store_id'], json_encode($sendData));
        if (!$flag) {//创建工单时短信通知服务商
            $store = db('store')->alias('p1')
                ->field('p2.user_id,p1.mobile')
                ->join('user p2', 'p1.store_id=p2.store_id')
                ->where(['p2.store_id' => $data['store_id']])
                ->find();
            if (!empty($store) && !empty($store['mobile']) && check_mobile($store['mobile'])) {
                $param = [
                    'phone'         => $store['mobile'],
                    'user_id'       => $store['user_id'],
                    'workOrderType' => $data['work_order_type'],
                    'worderSn'      => $worder['worder_sn'],
                ];
                $informModel = new \app\common\model\LogInform();
                $informModel->sendInform($data['factory_id'], 'sms', $param, 'service_work_order_add');
            }
        }
    }

    public function refuseNotify($worder,$installer)
    {
        //发送工单通知给服务商
        $push = new \app\common\service\PushBase();
        $todoData = [
            'type'          => 2,//1首次工单分派，2重新发派工单，3线下收款确认，4商户审核，5.....
            'store_id'      => $worder['store_id'],
            'post_store_id' => $worder['store_id'],
            'post_user_id'  => $installer['user_id'],
            'title'         => '【工单分派】' . $installer['realname'] . '拒绝了' . get_work_order_type($worder['work_order_type']) . '，请尽快重新分派！',
        ];
        $todoModel = new Todo($todoData);
        $todoModel->save();
        $todoId = $todoModel->id;
        if (!$todoId) {
            $this->error='系统故障';
            return false;
        }
        $todoModel->url=url('workorder/dispatch', ['id' => $worder['worder_id'],'todo_id'=>$todoId]);
        $todoModel->save();
        $addTime = $worder['add_time'] ?? time();
        $addTime = is_numeric($addTime) ? $addTime : (strtotime($addTime)>0? strtotime($addTime):time());
        $sendData = [
            'type'            => 'todo',
            'title'           => $todoData['title'],
            'url'             => $todoModel->url,
            'todo_id'         => $todoId,
            'todo_type'       => $todoData['type'],
            'add_time'        => getTime($addTime),
        ];
        $result=db('work_order')->where(['worder_id'=>$worder['worder_id']])->update(['todo_id'=>$todoId]);
        if ($result === false) {
            $this->error='系统故障';
            return false;
        }
        //在线推送
        $push->sendToGroup('store'.$todoData['store_id'], json_encode($sendData));
        //短信通知
        $store = db('store')->alias('p1')
            ->field('p2.user_id,p1.mobile')
            ->join('user p2', 'p1.store_id=p2.store_id')
            ->where(['p2.store_id' => $worder['store_id']])
            ->find();
        if (!empty($store) && !empty($store['mobile']) && check_mobile($store['mobile'])) {
            $param = [
                'phone'         => $store['mobile'],
                'user_id'       => $store['user_id'],
                'workOrderType' => $worder['work_order_type'],
                'worderSn'      => $worder['worder_sn'],
                'installerName' => $installer['realname'],
            ];
            $informModel = new \app\common\model\LogInform();
            $informModel->sendInform($worder['factory_id'], 'sms', $param, 'service_work_order_refuse');
        }
    }
    
    /**
     * 根据工单号获取售后工单信息
     * @param string $worderSn
     * @param array $user
     * @return boolean|unknown
     */
    public function getWorderDetail($worderSn = '', $user = [])
    {
        if (!$worderSn) {
            $this->error = '参数错误';
            return FALSE;
        }
        $where = [
            'worder_sn' => $worderSn, 
            'is_del' => 0,
        ];
        $info = $this->where($where)->find();
        if (!$info) {
            $this->error = lang('NO ACCESS');
            return FALSE;
        }
        if ($info['ossub_id']) {
            $orderSkuModel = new \app\common\model\OrderSku();
            $info['sub'] = $orderSkuModel->getSubDetail($info['ossub_id'], FALSE, TRUE);
        }else{
            $info['sub'] = db('goods')->find($info['goods_id']);
        }
        //获取工单日志
        $info['logs'] = db('work_order_log')->order('add_time DESC')->where(['worder_id' => $info['worder_id']])->select();
        //获取工单评价记录
        $info['assess_list'] = $this->getWorderAssess($info);
        $info['images'] = $info['images'] ? explode(',', $info['images']) : [];
        $info=$this->updateSignLocation($info);
        return $info;
    }

    //地址解析(地址转坐标)
    public function getCoder($params)
    {
        $param = [
            'address' => $params['address'],
            'key'      => $this->mapKey,
        ];
        $query=http_build_query($param);
        $url='https://apis.map.qq.com/ws/geocoder/v1/';
        $url.='?'.$query;
        $result=curl_request($url);
        $result=json_decode($result,true);
        return $result;
    }

    public function getAddress($param)
    {
        $lat = $param['lat'];//纬度
        $lng = $param['lng'];//经度
        if ($lat > 90 || $lat < -90) {
            return dataFormat(1, '参数错误[LAT]');
        }
        if ($lng > 180 || $lng < -180) {
            return dataFormat(1, '参数错误[LNG]');
        }
        $params = [
            'location' => $lat . ',' . $lng,
            'key'      => $this->mapKey,
            'get_poi'  => '0',
        ];
        $query = http_build_query($params);
        $url = 'https://apis.map.qq.com/ws/geocoder/v1/';
        $url .= '?' . $query;
        $result = curl_request($url);
        $result = json_decode($result, true);
        if (empty($result)) {
            return dataFormat(1, '第三方应用异常，请求失败');
        }
        if (isset($result['status']) && $result['status'] == '0') {
            $result = $result['result'];
            $data = [
                'address'   => $result['address'],
                'recommend' => $result['formatted_addresses']['recommend'],
                'province'  => $result['ad_info']['province'],
                'city'      => $result['ad_info']['city'],
            ];
            return dataFormat(0, 'ok',$data);
        }
        return dataFormat($result['status'], $result['message']);
    }


    public function updateSignLocation($info)
    {
        if ($info['sign_address'] && !$info['sign_lng'] && !$info['sign_lat']) {
            $result=$this->getCoder([
                'address'=>$info['sign_address']
            ]);
            if (isset($result['status']) && $result['status'] == 0 && isset($result['result']['location']['lng']) && isset($result['result']['location']['lat'])) {
                $info['sign_lng'] = $result['result']['location']['lng'];
                $info['sign_lat'] = $result['result']['location']['lat'];
                db('work_order')->where(['worder_id' => $info['worder_id']])->update([
                    'sign_lng'    => $info['sign_lng'],
                    'sign_lat'    => $info['sign_lat'],
                    'update_time' => time(),
                ]);
            }
        }
        return $info;
    }
    
    public function getWorderAssess($worder, $field = false)
    {
        $assessModel = db('work_order_assess');
        $field = $field ? $field : '*';
        $list = $assessModel->field($field)->where(['worder_id' => $worder['worder_id'], 'is_del' => 0])->select();
        if ($list) {
            foreach ($list as $key => $value) {
                $config = [];
                if ($value['type'] == 1) {
                    $config = db('work_order_assess_log')->alias("WOAL")->join("config C","C.config_id = WOAL.config_id")->field('C.name, WOAL.value as score')->where(['WOAL.assess_id' => $value['assess_id']])->select();
                }
                $list[$key]['configs'] = $config;
            }
        }
        return $list;
    }
    
    /**
     * 分配安装员操作
     * @param array $worder
     * @param array $user
     * @param int $installerId
     * @return boolean
     */
    public function worderDispatch($worder = [], $user = [], $installerId = 0)
    {
        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }
        //if ($user['admin_type'] != ADMIN_SERVICE) {
        //    $this->error = '当前账户无操作权限';
        //    return FALSE;
        //}
        //判断用户是否有分派工程师权限(仅服务商有分派工程师权限)
        if (!in_array($user['admin_type'],[ADMIN_SERVICE,ADMIN_SERVICE_NEW]) && $user['store_id'] != $worder['store_id']) {
            $this->error = '当前账户无操作权限';
            return FALSE;
        }
        $installer = db('user_installer')->where(['installer_id' => $installerId, 'is_del' => 0, 'store_id' => $worder['store_id']])->find();
        if (!$installer) {
            $this->error = '售后工程师不存在或已删除';
            return FALSE;
        }
        if (!$installer['status']) {
            $this->error = '售后工程师已禁用，请启用后选择';
            return FALSE;
        }
        $action = '分派工程师';
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['work_order_status']) {
            case -1://已取消可另外分派
                $this->error = '已取消不能重新派单';
                return FALSE;
                $action = '重新分派工程师';
                break;
            case 1://已分派工程师 可另外分派
                if ($worder['installer_id'] == $installerId) {
                    $this->error = '不能重复分派同一工程师';
                    return FALSE;
                }
                $action = '重新分派工程师';
                break;
            case 2://待上门  可另外分派
                if ($worder['installer_id'] == $installerId) {
                    $this->error = '不能重复分派同一工程师';
                    return FALSE;
                }
                $action = '重新分派工程师';
                break;
            case 3:
                $this->error = '工程师服务中,无操作权限';
                return FALSE;
            case 4:
                $this->error = '服务已完成,无操作权限';
                return FALSE;
            default:
                ;
                break;
        }
        $result = $this->save(['work_order_status' => 1, 'installer_id' => $installerId, 'dispatch_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $msg = '工程师姓名:'.$installer['realname'].'<br>工程师电话:'.$installer['phone'];
            $this->worderLog($worder, $user, $installerId, $action, $msg);
            if ($worder['installer_id'] != $installerId) {
                $this->_worderInstallerLog($worder, $installerId, 'dispatch', 0);
                //状态(1已拒绝  2分派转移)
                if ($worder['installer_id'] > 0) {
                    $this->_worderInstallerLog($worder, $worder['installer_id'], 'dispatch_other', 2);
                }
            }
            //分派工程师后通知工程师
            $informModel = new \app\common\model\LogInform();
            $result = $informModel->sendInform($user['factory_id'], 'sms', $installer, 'worder_dispatch_installer');
            if ($worder['todo_id']) {
                //完成待办事项
                $todo=new Todo;
                $ret=$todo->finish($worder['todo_id']);
                if ($ret['code'] !== '0') {
                    log_msg($ret);
                }
            }
            //发送派单通知给工程师
            $push = new \app\common\service\PushBase();
            $sendData = [
                'type'         => 'worker',
                'worder_sn'    => $worder['worder_sn'],
                'worder_id'    => $worder['worder_id'],
            ];
            //发送给服务商在线管理员
            $push->sendToUid(md5($installerId), json_encode($sendData));

            return TRUE;
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    /**
     * 工程师拒绝工单操作
     * @param array $worder
     * @param array $user
     * @param array $installer
     * @return boolean
     */
    public function worderRefuse($worder, $user, $installer, $remark = '')
    {
        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }
        if (isset($worder['installer_id']) && $worder['installer_id'] && $worder['installer_id'] != $installer['installer_id']) {
            $this->error = lang('NO_OPERATE_PERMISSION');
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['work_order_status']) {
            case -1:
                $this->error = '工单已取消,无操作权限';
                return FALSE;
            case 0:
                $this->error = '工单待分派工程师,无操作权限';
                return FALSE;
            case 2:
                $this->error = '工单已接收,无操作权限';
                return FALSE;
            case 3:
                $this->error = '工程师服务中,无操作权限';
                return FALSE;
            case 4:
                $this->error = '服务已完成,无操作权限';
                return FALSE;
            default:
                ;
                break;
        }
        $result = $this->save(['work_order_status' => 0, 'installer_id' => 0], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $this->worderLog($worder, $user, $installer['installer_id'], '工程师拒绝接单', $remark);
            $this->_worderInstallerLog($worder, $installer['installer_id'], 'refuse', 1);
            $this->refuseNotify($worder,$installer);
            return TRUE;
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    /**
     * 工程师接单操作
     * @param array $worder
     * @param array $user
     * @param array $installer
     * @return boolean
     */
    public function worderReceive($worder, $user, $installer,$appointmentConfirm)
    {

        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }

        if ($appointmentConfirm <= 0) {
            $this->error = '服务确认时间不正确';
            return FALSE;
        }

        if (isset($worder['installer_id']) && $worder['installer_id'] && $worder['installer_id'] != $installer['installer_id']) {
            $this->error = lang('NO_OPERATE_PERMISSION');
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['work_order_status']) {
            case -1:
                $this->error = '工单已取消,无操作权限';
                return FALSE;
            case 0:
                $this->error = '工单待分派工程师,无操作权限';
                return FALSE;
            case 2:
                $this->error = '工单已接收,无操作权限';
                return FALSE;
            case 3:
                $this->error = '工程师服务中,无操作权限';
                return FALSE;
            case 4:
                $this->error = '服务已完成,无操作权限';
                return FALSE;
            default:
                ;
                break;
        }
        $result = $this->save([
            'work_order_status'   => 2,
            'appointment_confirm' => $appointmentConfirm,
            'receive_time'        => time()
        ], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $this->worderLog($worder, $user, $installer['installer_id'], '工程师接单','确认上门服务时间:'.date('Y-m-d H:i',$appointmentConfirm));
            return TRUE;
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    /**
     * 工程师签到操作
     * @param array $worder
     * @param array $user
     * @param array $installer
     * @return boolean
     */
    public function worderSign($worder, $user, $installer,$address='',$lng=0,$lat=0)
    {
        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }
        if ($worder['installer_id'] != $installer['installer_id']) {
            $this->error = lang('NO_OPERATE_PERMISSION');
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['work_order_status']) {
            case -1:
                $this->error = '工单已取消,无操作权限';
                return FALSE;
            case 0:
                $this->error = '工单待分派工程师,无操作权限';
                return FALSE;
            case 1:
                $this->error = '工单待接单,无操作权限';
                return FALSE;
            case 3:
                $this->error = '工程师服务中,无操作权限';
                return FALSE;
            case 4:
                $this->error = '服务已完成,无操作权限';
                return FALSE;
            default:
                ;
                break;
        }
        $result = $this->save([
            'work_order_status' => 3,
            'sign_time'         => time(),
            'sign_address'      => $address,
            'sign_lng'          => $lng,
            'sign_lat'          => $lat,
        ], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $this->worderLog($worder, $user, $installer['installer_id'], '工程师签到,服务开始','签到地址：'.$address);
            return TRUE;
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    /**
     * 工单完成操作
     * @param array $worder
     * @param array $user
     * @return boolean
     */
    public function worderFinish($worder, $user)
    {
        $worder = $this->getWorderDetail($worder['worder_sn'], $user);
        if (!$worder) {
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['work_order_status']) {
            case -1:
                $this->error = '工单已取消,无操作权限';
                return FALSE;
            case 0:
                $this->error = '待分派工程师,无操作权限';
                return FALSE;
            case 1:
                $this->error = '待接单,无操作权限';
                return FALSE;
            case 2:
                $this->error = '待上门,无操作权限';
                return FALSE;
            case 4:
                $this->error = '服务已完成,无操作权限';
                return FALSE;
        }
        $result = $this->save(['work_order_status' => 4, 'finish_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //2019-04-17 只有电商客服下的安装工单有服务费
            if ($worder['work_order_type'] == 1 && $worder['carry_goods'] == 0) {
                //确认完成，服务商服务费入账(只有安装工单)
                $where = [
                    'is_del'    => 0,
                    'worder_id' => $worder['worder_id'],
                    'order_sn'  => $worder['order_sn'],
                    'osku_id'   => $worder['osku_id'],
                ];
                $incomeModel = db('store_service_income');
                $exist = $incomeModel->where($where)->find();
                if (!$exist) {
                    $config = get_store_config($worder['factory_id'], TRUE, 'default');
//                     $returnRatio = isset($config['servicer_return_ratio']) ? floatval($config['servicer_return_ratio']) : 0;
                    $returnRatio = 100;
                    $amount = $worder['install_price'];
                    $data = [
                        'store_id'      => $worder['store_id'],
                        'worder_id'     => $worder['worder_id'],
                        'worder_sn'     => $worder['worder_sn'],
                        'order_sn'      => $worder['order_sn'],
                        'osku_id'       => $worder['osku_id'],
                        'goods_id'      => $worder['goods_id'],
                        'sku_id'        => $worder['sku_id'],
                        'installer_id'  => $worder['installer_id'],
                        'install_amount'=> $amount,
                        'return_ratio'  => $returnRatio > 0 ? $returnRatio : 0,
                        'income_status' => 0,
                        'add_time'      => time(),
                        'update_time'   => time(),
                    ];
                    $logId = $incomeModel->insertGetId($data);
                    if ($logId) {
                        //修改商户账户收益信息
                        $financeModel = new \app\common\model\StoreFinance();
                        $params = [
                            'pending_amount'=> $amount,
                            'total_amount'  => $amount,
                        ];
                        $result = $financeModel->financeChange($worder['store_id'], $params, '工单完成,计算收益', $worder['worder_sn']);
                    }
                }
            }
            $field = $worder['work_order_type'] == 1 ? 'install_count' : 'repair_count';
            //增加工程师服务次数
            model('user_installer')->save([
                'service_count' =>	\Think\Db::raw('service_count+1'),
                $field		    =>	\Think\Db::raw($field.'+1'),
            ],['installer_id'=>$worder['installer_id']]);
            //操作日志记录
            $this->worderLog($worder, $user, $worder['installer_id'], '工程师确认服务完成');
            return TRUE;
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    public function serviceSettlement($worder, $assessId, $user, $score = 0)
    {
        //评论后，服务商安装服务费结算
        $where = [
            'is_del'    => 0,
            'worder_id' => $worder['worder_id'],
            'order_sn'  => $worder['order_sn'],
            'osku_id'   => $worder['osku_id'],
            'income_status' => 0,
        ];
        $incomeModel = db('store_service_income');
        $exist = $incomeModel->where($where)->find();
        if ($exist) {
            $returnRatio = $exist['return_ratio']/100;
            //根据评价数据计算得分
            $installAmount = $exist['install_amount'];
            $totalScore = 5;
            //@update_at 20190328 modified by Jinzhou
            //消费者的评价打分，不会对服务商的安装费产生影响, 相当于取消服务商考核
            $score=5;
            //绩效考核百分比
            $baseAmount = $installAmount * (1 - $returnRatio);//基本服务金额
            $otherAmount = $installAmount * $returnRatio;
            $amount = round($baseAmount + $otherAmount * $score/$totalScore, 2);
            $data = [
                'assess_id'     => $assessId,
                'score'         => $score,
                'income_amount' => $amount,
                'income_status' => 1,
                'update_time'   => time(),
            ];
            $logId = $incomeModel->where(['log_id' => $exist['log_id']])->update($data);
            if ($logId) {
                //修改商户账户收益信息
                $financeModel = new \app\common\model\StoreFinance();
                $params = [
                    'amount'        => $amount,//可提现金额
                    'pending_amount'=> -$installAmount,//待结算金额(减去预安装金额)
                ];
                if ($amount < $installAmount) {
                    $params['total_amount'] = - ($installAmount - $amount);
                }
                $result = $financeModel->financeChange($exist['store_id'], $params, '工单完成评价,结算收益', $worder['worder_sn']);
            }
        }
    }
    
    /**
     * 取消工单操作
     * @param int $worderId
     * @param int $userId
     * @return boolean
     */
    public function worderCancel($worder = [], $user = [], $remark = '')
    {
        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }
        $type = $worder['work_order_type'];
        //只有厂商和服务商有维修工单的取消权限
        if ($type == 2 && isset($user['admin_type']) && $user['admin_type']>0 && !in_array($user['admin_type'], [ADMIN_FACTORY, ADMIN_SERVICE])) {
            $this->error = lang('NO_OPERATE_PERMISSION');
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['work_order_status']) {
            case -1:
                $this->error = '工单已取消';
                return FALSE;
            case 3:
                $this->error = '工程师服务中';
                return FALSE;
            case 4:
                $this->error = '服务已完成';
                return FALSE;
            default:
                ;
                break;
        }
        $result = $this->save(['work_order_status' => -1, 'cancel_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $this->worderLog($worder, $user, 0, '取消工单', $remark);
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    public function worderDrop($worder = [], $user = [], $remark = '')
    {
        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['work_order_status']) {
            case 0:
                $this->error = '工单待分派,不允许删除';
                return FALSE;
            case 1:
                $this->error = '工单待接单,不允许删除';
                return FALSE;
            case 2:
                $this->error = '工单待上门,不允许删除';
                return FALSE;
            case 3:
                $this->error = '工程师服务中,不允许删除';
                return FALSE;
            default:
                break;
        }
        $result = '';
        if ($result !== FALSE) {
            //操作日志记录
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }


    /**
     * 追加评价
     */
    public function workAssessAppend($worder,$user,$param)
    {
        $status = $worder['work_order_status'];
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($status) {
            case -1:
                $this->error = '工单已取消,不允许评价';
                return false;
            case 0:
                $this->error = '工单待分派,不允许评价';
                return false;
            case 1:
                $this->error = '工单待接单,不允许评价';
                return false;
            case 2:
                $this->error = '工单待上门,不允许评价';
                return false;
            case 3:
                $this->error = '工程师服务中,不允许评价';
                return false;
            default:
                break;
        }
        $first= db('work_order_assess')->where([
            'worder_id' => $worder['worder_id'],
            'worder_sn' => $worder['worder_sn'],
            'type'      => 1,
        ])->find();
        if (empty($first)) {
            $this->error = '您之前未评价过,不允追加评价';
            return false;
        }
        $append= db('work_order_assess')->where([
            'worder_id' => $worder['worder_id'],
            'worder_sn' => $worder['worder_sn'],
            'type'      => 2,
        ])->find();
        if (!empty($append)) {
            $this->error = '一个工单只能追加一次评价';
            return false;
        }
        if (!isset($param['msg']) && empty($param['msg'])) {
            $this->error = '追加评价内容不能为空';
            return false;
        }

        $nickname = isset($user['realname']) && $user['realname'] ? $user['realname'] : (isset($user['nickname']) && $user['nickname'] ? $user['nickname'] : (isset($user['username']) && $user['username'] ? $user['username'] : ''));
        $data = [
            'worder_id'     =>  $worder['worder_id'],
            'worder_sn'     =>  $worder['worder_sn'],
            'installer_id'  =>  $worder['installer_id'],
            'post_user_id'  =>  $user ? $user['user_id'] : 0,
            'nickname'      =>  $user['user_id'] ? ($nickname ? $nickname : '客户') : '系统',
            'type'          =>  2,//1 首次评价 2 追加评价(追加评价只有评价内容,没有评分)
            'msg'           =>  $param['msg'],
            'add_time'      =>  time(),
        ];
        $assessId = db('work_order_assess')->insertGetId($data);//添加评价记录
        if (!$assessId) {
            $this->error = '系统故障，操作失败';
            return false;
        }
        $action =  '追加评价';
        //操作日志记录
        $this->worderLog($worder, $user, 0, $action, $param['msg']);
        return true;
    }



    /**
     * 首次评价
     * @param $worder 工单信息
     * @param $user   提交的用户
     * @param $assessConfig 评价配置
     * @param $scoreConfig  评分配置
     * @param $assess       评价信息
     * @param $score        评分信息
     * @return bool
     */
    public function workAssessFirst($worder,$user,$assessConfig,$scoreConfig,$assess,$score)
    {
        if (!$worder) {
            $this->error = '参数错误';
            return false;
        }

        if (empty($assess) || empty($score)) {
            $this->error = '请先完善全部评价信息再提交';
        }
        $msg='';
        foreach ($assessConfig as $k=>$v) {
            if ($v['is_required']  && (!isset($assess[$v['id']])) || $assess[$v['id']]==='' || $assess[$v['id']]===null ) {
                $this->error = $v['name'].'不能为空';
                return false;
            }
            if ($v['type']==6) {
                $msg=isset($assess[$v['id']]) && is_string($assess[$v['id']]) ? $assess[$v['id']]:'';
            }
        }
        foreach ($scoreConfig as $k=>$v) {
            if ($v['is_required']  && (!isset($score[$v['id']])) || $score[$v['id']]==='' || $score[$v['id']]===null ) {
                $this->error = $v['name'].'不能为空';
                return false;
            }
            if ($score[$v['id']]>5 ||$score[$v['id']]<=0) {
                $this->error = $v['name'].'得分只能在1~5之间';
                return false;
            }
        }
        $status = $worder['work_order_status'];
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($status) {
            case -1:
                $this->error = '工单已取消,不允许评价';
                return false;
            case 0:
                $this->error = '工单待分派,不允许评价';
                return false;
            case 1:
                $this->error = '工单待接单,不允许评价';
                return false;
            case 2:
                $this->error = '工单待上门,不允许评价';
                return false;
            case 3:
                $this->error = '工程师服务中,不允许评价';
                return false;
            default:
                break;
        }
        //是否已经评价过
        $exit = db('work_order_assess')->where([
            'worder_sn' => $worder['worder_sn'],
            'worder_id' => $worder['worder_id'],
            'type'      => 1,//1首次评价 2追加评价
            'is_del'    => 0,
        ])->find();
        if (!empty($exit)) {
            $this->error = '用户已经评价过';
            return false;
        }
        $nickname = isset($user['realname']) && $user['realname'] ? $user['realname'] : (isset($user['nickname']) && $user['nickname'] ? $user['nickname'] : (isset($user['username']) && $user['username'] ? $user['username'] : ''));
        $data = [
            'worder_id'    => $worder['worder_id'],
            'worder_sn'    => $worder['worder_sn'],
            'installer_id' => $worder['installer_id'],
            'post_user_id' => $user ? $user['user_id'] : 0,
            'nickname'     => $user['user_id'] ? ($nickname ? $nickname : '客户') : '系统',
            'type'         => 1,//1 首次评价 2 追加评价(追加评价只有评价内容,没有评分)
            'msg'          => $msg,
            'add_time'     => time(),
        ];
        $assessId = db('work_order_assess')->insertGetId($data);//添加评价记录
        if (!$assessId) {
            $this->error = '系统故障，操作失败';
            return false;
        }

        //写入评价数据
        $postData = [];
        foreach ($assess as $k => $v) {
            $postData[] = [
                'config_form_id' => $k,
                'worder_id'      => $worder['worder_id'],
                'store_id'       => $user['factory_id'],
                'post_store_id'  => $user['store_id'],
                'post_user_id'   => $user['user_id'],
                'config_value'   => $v,
                'assess_id'      => $assessId,
            ];
        }
        $sum = 0;
        foreach ($score as $k => $v) {
            $postData[] = [
                'config_form_id' => $k,
                'worder_id'      => $worder['worder_id'],
                'store_id'       => $user['factory_id'],
                'post_store_id'  => $user['store_id'],
                'post_user_id'   => $user['user_id'],
                'config_value'   => $v,
                'assess_id'      => $assessId,
            ];
            $sum += $v;
            //评份日志，对应表：user_installer_score
            model('user_installer')->assessAdd($worder['installer_id'], $k, $v);
        }

        $model = new ConfigFormLogs;
        $result = $model->saveAll($postData);
        if ($result->isEmpty()) {
            $this->error = '操作失败';
            return false;
        }
        $avgScore = round($sum/count($score),1);
        //安装工单
        if ($worder['work_order_type'] == 1 && $worder['carry_goods'] == 0) {
            //首次-综合评价,处理安装服务费发放结算
            $this->serviceSettlement($worder, $assessId, $user, $avgScore);

        }
        //更新工程师评价数据
        $this->getStatics($worder['installer_id'],$user['factory_id'],true);
        //更新服务商评价数据
        $this->getServiceStatics($worder['store_id'],$user['factory_id'],true);
        //工单记录
        $action ='首次评价';
        //操作日志记录
        $this->worderLog($worder, $user, 0, $action, $msg);
        return true;
    }
    
    /**
     * 工单评价操作
     * @param array $worder
     * @param array $user
     * @param array $assessData 用户提交评价信息
     * @deprecated 2019/05/08 JINZHOU
     */
    public function worderAssess($worder = [], $user = [], $assessData = []){
        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }
        
        $status = $worder['work_order_status'];
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($status) {
            case -1:
                $this->error = '工单已取消,不允许评价';
                return FALSE;
            case 0:
                $this->error = '工单待分派,不允许评价';
                return FALSE;
            case 1:
                $this->error = '工单待接单,不允许评价';
                return FALSE;
            case 2:
                $this->error = '工单待上门,不允许评价';
                return FALSE;
            case 3:
                $this->error = '工程师服务中,不允许评价';
                return FALSE;
            default:
                break;
        }
        if (!$user) {
            $assessData = [
                'type'  => 1,
                'msg'   => '默认好评',
            ];
            $assessData['score'] = db('config')->where(['config_key' => CONFIG_WORKORDER_ASSESS, 'status' => 1, 'is_del' => 0])->column('config_id, 5 as config_value');
        }
        if (!$assessData) {
            $this->error = '参数错误';
            return FALSE;
        }
        //判断评价是否存在
        $log = db('work_order_assess')->where(['worder_id' => $worder['worder_id'], 'type' => $assessData['type']])->find();
        if ($log) {
            $this->error = '不能重复评价';
            return FALSE;
        }
        /* //判断当前工单是否存在首次评价
        if ($assessData['type'] == 1) {
            //判断当前工单是否存在首次评价
            $log = db('work_order_assess')->where(['worder_id' => $worder['worder_id'], 'type' => 1])->find();
            if ($log) {
                $this->error = '工单已评价';
                return FALSE;
            }
        } */
        $nickname = isset($user['realname']) && $user['realname'] ? $user['realname'] : (isset($user['nickname']) && $user['nickname'] ? $user['nickname'] : (isset($user['username']) && $user['username'] ? $user['username'] : ''));
        $data = [
            'worder_id'     =>  $worder['worder_id'],
            'worder_sn'     =>  $worder['worder_sn'],
            'installer_id'  =>  $worder['installer_id'],
            'post_user_id'  =>  $user ? $user['user_id'] : 0,
            'nickname'      =>  $user['user_id'] ? ($nickname ? $nickname : '客户') : '系统',
            'type'          =>  $assessData['type'],//1 首次评价 2 追加评价(追加评价只有评价内容,没有评分)
            'msg'           =>  $assessData['msg'],
            'add_time'      =>  time(),
        ];
        $assessId = db('work_order_assess')->insertGetId($data);//添加评价记录
        if($assessId){
            $action = $assessData['type'] ? '首次评价': '追加评价';
            //操作日志记录
            $this->worderLog($worder, $user, 0, $action, $assessData['msg']);
            switch ($assessData['type']){
                case 1://首次评价带评分,记录评分信息
                    $scoreData = $assessData['score'];
                    if($scoreData && is_array($scoreData)){
                        $score = 0;
                        $len = count($scoreData);
                        foreach ($scoreData as $k=>$v){
                            $score += $v;
                            //记录单次评分日志
                            $data = [
                                'assess_id'     => $assessId,
                                'installer_id'  => $worder['installer_id'],
                                'config_id'     => $k,
                                'value'         => $v,
                            ];
                            db('work_order_assess_log')->insert($data);//添加评分日志记录
                            model('user_installer')->assessAdd($worder['installer_id'],$k,$v);
                        }
                        $score = round($score/$len,1);
                        //更新工程师综合得分
                        model('user_installer')->scoreUpdate($worder['installer_id'],$score);
                        //安装工单
                        if ($worder['work_order_type'] == 1 && $worder['carry_goods'] == 0) {
                            //首次评价,处理安装服务费发放结算
                            $this->serviceSettlement($worder, $assessId, $user, $score);
                        }
                        return $assessId;
                    }else{
                        $this->error = '没有评分项';
                        return false;
                    }
                    break;
                case 2:
                    return $assessId;
                    break;
                default:
                    return $assessId;
            }
        }else{
            return false;
        }
    }
    /**
     * 工单日志记录操作
     * @param array $worder
     * @param array $user
     * @param string $action
     * @param string $msg
     * @return number|string
     */
    public function worderLog($worder, $user, $installerId = 0, $action = '', $msg = '')
    {
        //$nickname = isset($user['realname']) && $user['realname'] ? $user['realname'] : (isset($user['nickname']) && $user['nickname'] ? $user['nickname'] : (isset($user['username']) && $user['username'] ? $user['username'] : ''));
        $username = '';
        if (isset($user['realname']) && $user['realname']) {
            $username = $user['realname'];
        } elseif (isset($user['nickname']) && $user['nickname']) {
            $username = $user['nickname'];
        } elseif (isset($user['username']) && $user['username']) {
            $username = $user['username'];
        }
        $data = [
            'worder_id'    => $worder['worder_id'],
            'worder_sn'    => $worder['worder_sn'],
            'installer_id' => $installerId,
            'user_id'      => isset($user['user_id']) ? $user['user_id'] : 0,
            'udata_id'     => isset($user['udata_id']) ? $user['udata_id'] : 0,
            'nickname'     => $user ? ($username? $username:'客户') : '系统',
            'action'       => $action,
            'msg'          => $msg,
            'add_time'     => time(),
        ];
        return $result = db('work_order_log')->insertGetId($data);
    }


    public function getConfigKey($cateId,$type)
    {
        $arr=[
            0=>'work_order_install_add',
            1=>'installer_confirm',
            2=>'install_user_confirm',//用户评价，之前命名的时候理解有误，命名本意跟实际需求不对应
            3=>'installer_assess',//用户评分
            4=>'repairman_confirm',
            5=>'repair_user_confirm',//用户评价,之前命名的时候理解有误，命名本意跟实际需求不对应
            6=>'repair_assess',//用户评分
        ];
        if ($type==='' || !key_exists($type,$arr)) {
            return dataFormat(1,'请选择表单的类型');
        }
        $key=$arr[$type].'_'.$cateId;
        return dataFormat(0,'ok',['key'=>$key]);
    }

    public function getGoodsCateId($param)
    {
        $worderId=isset($param['worder_id']) &&  $param['worder_id'] ? $param['worder_id']: 0;
        $worderSn=isset($param['worder_sn']) &&  $param['worder_sn'] ? $param['worder_sn']: '';
        if (empty($worderId) && empty($worderSn)) {
            return dataFormat(1,'参数错误');
        }
        $where=[
            'p1.is_del'=>0,
            'p2.is_del'=>0,
        ];
        if (!empty($worderId)) {
            $where['p1.worder_id']=$worderId;
        }
        if (!empty($worderSn)) {
            $where['p1.worder_sn']=$worderSn;
        }
        $cateId=db('work_order')
            ->alias('p1')
            ->join('goods p2','p1.goods_id=p2.goods_id')
            ->where($where)
            ->value('cate_id');
        return dataFormat(0,'ok',['cate_id'=>$cateId]);
    }

    public function getWorkerConfig($param)
    {
        $worderId=isset($param['worder_id']) &&  $param['worder_id'] ? $param['worder_id']: 0;
        $worderSn=isset($param['worder_sn']) &&  $param['worder_sn'] ? $param['worder_sn']: '';
        $type=isset($param['type']) &&  $param['type'] ? $param['type']: 0;
        $factoryId=isset($param['factory_id']) &&  $param['factory_id'] ? $param['factory_id']: 1;
        if (empty($worderId) && empty($worderSn)) {
            return dataFormat(1,'参数错误');
        }
        $ret=$this->getGoodsCateId($param);
        $cateId=$ret['data']['cate_id'];
        $data=$this->getConfigKey($cateId,$type);
        if ($data['code'] != 0) {
            $data;
        }
        $key=$data['data']['key'];
        $result = ConfigForm::field('id,name,is_required,type,value')->where([
            'is_del'   => 0,
            'store_id' => $factoryId,
            'key'      => $key,
        ])->order('sort_order ASC')->select();
        return dataFormat(0,'ok',$result->toArray());
    }

    public function getWorkOrderConfig($cateId,$type,$factoryId)
    {
        $data=$this->getConfigKey($cateId,$type);
        if ($data['code'] != 0) {
            $data;
        }
        $key=$data['data']['key'];

        $result = ConfigForm::field('id,name,is_required,type,value')->where([
            'is_del'   => 0,
            'store_id' => $factoryId,
            'key'      => $key,
        ])->order('sort_order ASC')->select();
        return dataFormat(0,'ok',$result->toArray());
    }

    public function getWorkOrderConfLogs($workId,$cateId,$type,$factoryId=1)
    {
        $result=$this->getConfigKey($cateId,$type,$factoryId);
        if ($result['code'] != 0) {
            return $result;
        }
        $key=$result['data']['key'];
        $config=db('config_form_logs')
            ->alias('p1')
            ->field('p2.name,p2.type,p2.value,p1.config_value')
            ->join('config_form p2','p1.config_form_id=p2.id')
            ->where([
                'p2.is_del'    => 0,
                'p2.store_id'  => $factoryId,
                'p2.key'       => $key,
                'p1.is_del'    => 0,
                'p1.type'      => 0,//0首次
                'p1.worder_id' => $workId,
            ])
            ->order('p2.sort_order ASC')
            ->select();
        foreach ($config as $k=>$v) {
            if (in_array($v['type'], [2, 3, 4])) {
                $config[$k]['value']=json_decode($config[$k]['value'],true);
                $config[$k]['config_value']=json_decode($config[$k]['config_value'],true);
            }
        }
        return dataFormat(0,'ok',$config);
    }

    public function getConfigAndLogs($param)
    {
        $result=$this->getGoodsCateId($param);
        if ($result['code'] != 0) {
            return $result;
        }
        $cateId=$result['data']['cate_id'];
        $type=$param['type'];
        $result=$this->getConfigKey($cateId,$type);
        $key=$result['data']['key'];
        $data = db('config_form')->alias('p1')
            ->field('p1.id,p1.name,p1.is_required,p1.type,p1.value,p2.id log_id,p2.config_value')
            ->join([
                ['config_form_logs p2', 'p2.config_form_id=p1.id AND p2.is_del=0 AND p2.worder_id=' . $param['worder_id'],'LEFT']
            ])
            ->where([
                'p1.store_id' => $param['store_id'],
                'p1.key'      => $key,
                'p1.is_del'   => 0,
            ])->order('p1.sort_order ASC')
            ->select();
        foreach ($data as $k=>$v) {
            if (in_array($v['type'], [2, 3, 4])) {
                $data[$k]['value']=json_decode($data[$k]['value'],true);
                $data[$k]['config_value']=json_decode($data[$k]['config_value'],true);
            }
        }
        return dataFormat(0,'ok',$data);
    }

    public function getConfigLogDetail($param)
    {
        $workAddInfo=[];//工单提交信息
        $workOrderInfo=[];//安装\维修 详情
        $assessInfo=[];//用户评价配置
        $scoreInfo=[];//用户评分配置
        if ($param['work_order_type']==1) {//安装工单
            $workAddInfo=$this->getWorkOrderConfLogs($param['worder_id'],$param['cate_id'],0,$param['factory_id']);
            $workAddInfo=isset($workAddInfo['data'])?$workAddInfo['data']:[];
            $workOrderInfo=$this->getWorkOrderConfLogs($param['worder_id'],$param['cate_id'],1,$param['factory_id']);
            $workOrderInfo=isset($workOrderInfo['data'])?$workOrderInfo['data']:[];
            $assessInfo=$this->getWorkOrderConfLogs($param['worder_id'],$param['cate_id'],2,$param['factory_id']);
            $assessInfo=isset($assessInfo['data'])?$assessInfo['data']:[];
            $scoreInfo=$this->getWorkOrderConfLogs($param['worder_id'],$param['cate_id'],3,$param['factory_id']);
            $scoreInfo=isset($scoreInfo['data'])?$scoreInfo['data']:[];
        }else{
            $workOrderInfo=$this->getWorkOrderConfLogs($param['worder_id'],$param['cate_id'],4,$param['factory_id']);
            $workOrderInfo=isset($workOrderInfo['data'])?$workOrderInfo['data']:[];
            $assessInfo=$this->getWorkOrderConfLogs($param['worder_id'],$param['cate_id'],5,$param['factory_id']);
            $assessInfo=isset($assessInfo['data'])?$assessInfo['data']:[];
            $scoreInfo=$this->getWorkOrderConfLogs($param['worder_id'],$param['cate_id'],6,$param['factory_id']);
            $scoreInfo=isset($scoreInfo['data'])?$scoreInfo['data']:[];
        }
        $result['work_add_info']=$workAddInfo;
        $result['work_info']=$workOrderInfo;
        $result['assess_info']=$assessInfo;
        $result['score_info']=$scoreInfo;
        //追加评价的内容
        $result['append_msg'] = db('work_order_assess')->where([
            'is_del'    => 0,
            'type'      => 2,
            'worder_id' => $param['worder_id'],
        ])->value('msg');
        return $result;
    }

    //回收分派工单，重新分派
    public function dispatch_recycle(WorkOrder $worder)
    {
        if ($worder['is_del'] == 1) {
            return dataFormat(1,'工单已经删除');
        }
        if ($worder['work_order_status'] != 1) {
            return dataFormat(2,'工单状态'.get_work_order_status($worder['work_order_status']).',不能回收重新分派');
        }
        $worder->work_order_status=0;
        $worder->dispatch_time=0;
        $worder->installer_id=0;
        $worder->cancel_time=0;
        $worder->receive_time=0;
        $worder->sign_time=0;
        $work = [
            'worder_id'       => $worder->worder_id,
            'worder_sn'       => $worder->worder_sn,
            'work_order_type' => $worder->work_order_type,
            'factory_id'      => $worder->factory_id,
            'store_id'        => $worder->store_id,
            'post_store_id'   => $worder->post_store_id,
            'post_user_id'    => $worder->post_user_id,
            'add_time'        => $worder->add_time,
        ];
        $installerId=$worder->installer_id;
        if ($worder->save()) {
            $this->worderLog($work,[],$installerId,"撤回已分派工单",'工程师超时未接单，重新分派');
            //通知服务商
            $this->notify($work,$work);
        }
        return dataFormat(0,'ok');
    }

    private function _worderInstallerLog($worder, $installerId, $action = "dispatch_other", $status = 1)
    {
        $logModel = db('work_order_installer_record');
        
        $exist = $logModel->where(['worder_id' => $worder['worder_id'], 'installer_id' => $installerId, 'is_del' => 0])->find();
        if ($exist) {
            $result = $logModel->where(['log_id' => $exist['log_id']])->update(['is_del' => 1, 'update_time' => time()]);
        }
        if ($action == 'dispatch') {
            return FALSE;
        }
        $data = [
            'worder_id'     => $worder['worder_id'],
            'worder_sn'     => $worder['worder_sn'],
            'installer_id'  => $installerId,
            'action'        => $action,
            'status'        => $status,//状态(1已拒绝   2分派转移)
            'add_time'      => time(),
            'update_time'   => time(),
        ];
        return $result = db('work_order_installer_record')->insertGetId($data);
    }
    private function _getWorderSn($sn = '')
    {
        $sn = $sn ? $sn : date('YmdHis').get_nonce_str(6, 2);
        //判断售后工单号是否存在
        $info = $this->where(['worder_sn' => $sn])->find();
        if ($info){
            return $this->_getWorderSn();
        }else{
            return $sn;
        }
    }

    public function getAccessTitle($factoryId)
    {
        //取出第一个商品安装评价配置
        $installAssessKey = db('config_form')->where([
            ['is_del', '=', 0],
            ['store_id', '=', $factoryId],
            ['key', 'like', 'installer_assess_%'],
        ])->value('key');
        if (empty($installAssessKey)) {
            return dataFormat(1, '厂商未配置安装工单评分信息');
        }
        //取出第一个商品评价维修配置
        $repairAssessKey = db('config_form')->where([
            ['is_del', '=', 0],
            ['store_id', '=', $factoryId],
            ['key', 'like', 'repair_assess_%'],
        ])->value('key');
        if (empty($repairAssessKey)) {
            return dataFormat(1, '厂商未配置维工单评分信息');
        }
        $arr = db('config_form')->where([
            ['is_del', '=', 0],
            ['store_id', '=', $factoryId],
            ['key', 'IN', [$installAssessKey, $repairAssessKey]],
        ])->group('name')->column('name');
        return dataFormat(0, 'ok', $arr);
    }


    public function getServiceStaticsDuring($storeId,$factoryId,$startTime,$endTime)
    {
        //取出第一个商品安装评价配置
        $installAssessKey = db('config_form')->where([
            ['is_del', '=', 0],
            ['store_id', '=', $factoryId],
            ['key', 'like', 'installer_assess_%'],
        ])->value('key');
        if (empty($installAssessKey)) {
            return dataFormat(1, '厂商未配置安装工单评分信息');
        }
        //取出第一个商品评价维修配置
        $repairAssessKey = db('config_form')->where([
            ['is_del', '=', 0],
            ['store_id', '=', $factoryId],
            ['key', 'like', 'repair_assess_%'],
        ])->value('key');
        if (empty($repairAssessKey)) {
            return dataFormat(1, '厂商未配置维工单评分信息');
        }
        $where=[
            ['p1.add_time','>=',$startTime],
            ['p1.add_time','<',$endTime],
            ['p1.is_del','=',0],
            ['p2.is_del','=',0],
            ['p3.is_del','=',0],
            ['p3.key','=',$repairAssessKey],
            ['p1.factory_id','=',$factoryId],
            //['p1.store_id','=',$storeId],
        ];
        if ($storeId > 0) {
            $where[]=['p1.store_id','=',$storeId];
        }
        $repairSql = db('work_order')
            ->alias('p1')
            ->field('p3.id,p3.key,p3.name,p2.config_value')
            ->join([
                ['config_form_logs p2', 'p2.worder_id=p1.worder_id', 'LEFT'],
                ['config_form p3', 'p3.id=p2.config_form_id', 'LEFT'],
            ])->where($where)->buildSql();
        $where=[
            ['p4.add_time','>=',$startTime],
            ['p4.add_time','<',$endTime],
            ['p4.is_del','=',0],
            ['p5.is_del','=',0],
            ['p6.is_del','=',0],
            ['p6.key','=',$installAssessKey],
            ['p4.factory_id','=',$factoryId],
            //['p4.store_id','=',$storeId],
        ];
        if ($storeId > 0) {
            $where[]=['p4.store_id','=',$storeId];
        }

        $installSql = db('work_order')
            ->alias('p4')
            ->field('p6.id,p6.key,p6.name,p5.config_value')
            ->join([
                ['config_form_logs p5', 'p5.worder_id=p4.worder_id', 'LEFT'],
                ['config_form p6', 'p6.id=p5.config_form_id', 'LEFT'],
            ])->where($where)->buildSql();
        $query = Db::table($repairSql . ' AS a')->unionAll($installSql)->buildSql();
        $data = Db::table($query . ' as b')->fieldRaw('`name`,avg(config_value) `value`')->group('`name`')->select();
        if (empty($data)) {
            return dataFormat(1,'暂无数据');
        }
        //该服务商所有工单
        $where3=[
            ['add_time','>=',$startTime],
            ['add_time','<',$endTime],
            ['factory_id','=',$factoryId],
            ['is_del','=',0],
            //['store_id','=',$storeId],
        ];
        if ($storeId > 0) {
            $where3[]=['store_id','=',$storeId];
        }
        $countAll = db('work_order')->where($where3)->count();
        $where4=[
            ['add_time','>=',$startTime],
            ['add_time','<',$endTime],
            ['factory_id','=',$factoryId],
            ['work_order_status','=',4],
            ['is_del','=',0],
        ];
        if ($storeId > 0) {
            $where4[]=['store_id','=',$storeId];
        }
        $countFinish = db('work_order')->where($where4)->count();
        $rate=$countAll>0? round($countFinish/$countAll,2)*5:0;
        $data[]=[
            'name'=>'解决率',
            'value'=>$rate,
        ];
        //综合分数
        $sum=array_sum(array_column($data,'value'));
        $count=count($data);
        $scoreOverall=0;
        if ($count > 0) {
            $scoreOverall=number_format($sum/$count,2,'.','');
        }
        return dataFormat(0, 'ok', [
            'score_overall' => $scoreOverall,
            'score_detail'  => $data,
        ]);
    }

    /**
     * 获取服务商的评价数据
     * @param $storeId  服务商ID
     * @param $factoryId 厂商ID
     * @param bool $flag true直接更新服务商数据，fase获取不到数据时候才更新
     * @return array
     */
    public function getServiceStatics($storeId,$factoryId=1,$flag=false)
    {
        if (!$flag) {
            $result = db('store')->field('score_overall,score_detail')->where([
                'store_id'   => $storeId,
                'store_type' => STORE_SERVICE,
                'factory_id' => $factoryId,
                'is_del'     => 0,
            ])->find();
            if (!empty($result['score_detail'])) {
                $result['score_detail'] = json_decode($result['score_detail'], true);
                return dataFormat(0, 'ok', $result);
            }
        }
        //取出第一个商品安装评价配置
        $installAssessKey = db('config_form')->where([
            ['is_del', '=', 0],
            ['store_id', '=', $factoryId],
            ['key', 'like', 'installer_assess_%'],
        ])->value('key');
        if (empty($installAssessKey)) {
            return dataFormat(1, '厂商未配置安装工单评分信息');
        }
        //取出第一个商品评价维修配置
        $repairAssessKey = db('config_form')->where([
            ['is_del', '=', 0],
            ['store_id', '=', $factoryId],
            ['key', 'like', 'repair_assess_%'],
        ])->value('key');
        if (empty($repairAssessKey)) {
            return dataFormat(1, '厂商未配置维工单评分信息');
        }
        $repairSql = db('work_order')
            ->alias('p1')
            ->field('p3.id,p3.key,p3.name,p2.config_value')
            ->join([
                ['config_form_logs p2', 'p2.worder_id=p1.worder_id', 'LEFT'],
                ['config_form p3', 'p3.id=p2.config_form_id', 'LEFT'],
            ])->where([
                'p1.is_del'   => 0,
                'p2.is_del'   => 0,
                'p3.is_del'   => 0,
                'p1.store_id' => $storeId,
                'p3.key'      => $repairAssessKey,
            ])->buildSql();
        $installSql = db('work_order')
            ->alias('p4')
            ->field('p6.id,p6.key,p6.name,p5.config_value')
            ->join([
                ['config_form_logs p5', 'p5.worder_id=p4.worder_id', 'LEFT'],
                ['config_form p6', 'p6.id=p5.config_form_id', 'LEFT'],
            ])->where([
                'p4.is_del'   => 0,
                'p5.is_del'   => 0,
                'p6.is_del'   => 0,
                'p4.store_id' => $storeId,
                'p6.key'      => $installAssessKey,
            ])->buildSql();
        $query = Db::table($repairSql . ' AS a')->unionAll($installSql)->buildSql();
        $data = Db::table($query . ' as b')->fieldRaw('`name`,avg(config_value) `value`')->group('`name`')->select();
        //该服务商所有工单
        $countAll = db('work_order')->where([
            'store_id'   => $storeId,
            'factory_id' => $factoryId,
            'is_del'     => 0,
        ])->count();
        $countFinish = db('work_order')->where([
            'store_id'          => $storeId,
            'factory_id'        => $factoryId,
            'is_del'            => 0,
            'work_order_status' => 4,
        ])->count();
        $rate=round($countFinish/$countAll,2)*5;
        $data[]=[
            'name'=>'解决率',
            'value'=>$rate,
        ];
        //综合分数
        $sum=array_sum(array_column($data,'value'));
        $count=count($data);
        $scoreOverall=0;
        if ($count > 0) {
            $scoreOverall=number_format($sum/$count,2,'.','');
        }
        $bool = db('store')->where([
            'store_id' => $storeId,
            'is_del'   => 0,
        ])->update([
            'score_overall' => $scoreOverall,
            'score_detail'  => json_encode($data),
            'update_time'   => time(),
        ]);
        return dataFormat(0, 'ok', [
            'score_overall' => $scoreOverall,
            'score_detail'  => $data,
        ]);
    }

    /**
     * @param int $installId  工程师ID
     * @param int $factoryId 厂商ID
     * @param bool $flag   true直接更新工程师数据，fase获取不到数据时候才更新
     * @return array
     */
    public function getStatics($installId = 0,$factoryId=1,$flag=false)
    {
        if (!$flag) {
            $result=db('user_installer')->field('score_overall,score_detail')->where([
                'installer_id'=>$installId,
                'is_del'=>0,
            ])->find();
            if (!empty($result['score_detail'])) {
                $result['score_detail']=json_decode($result['score_detail'],true);
                return dataFormat(0,'ok',$result);
            }
        }
        $installAssessKey = db('config_form')->where([
            ['is_del', '=', 0],
            ['store_id', '=', $factoryId],
            ['key', 'like', 'installer_assess_%'],
        ])->value('key');
        if (empty($installAssessKey)) {
            return dataFormat(1, '厂商未配置安装工单评分信息');
        }
        $repairAssessKey = db('config_form')->where([
            ['is_del', '=', 0],
            ['store_id', '=', $factoryId],
            ['key', 'like', 'repair_assess_%'],
        ])->value('key');
        if (empty($repairAssessKey)) {
            return dataFormat(1, '厂商未配置维工单评分信息');
        }
        $repairSql = db('work_order')
            ->alias('p1')
            ->field('p3.id,p3.key,p3.name,p2.config_value')
            ->join([
                ['config_form_logs p2', 'p2.worder_id=p1.worder_id', 'LEFT'],
                ['config_form p3', 'p3.id=p2.config_form_id', 'LEFT'],
            ])->where([
                'p1.is_del'       => 0,
                'p2.is_del'       => 0,
                'p3.is_del'       => 0,
                'p1.installer_id' => $installId,
                'p3.key'          => $repairAssessKey,
            ])->buildSql();
        $installSql = db('work_order')
            ->alias('p4')
            ->field('p6.id,p6.key,p6.name,p5.config_value')
            ->join([
                ['config_form_logs p5', 'p5.worder_id=p4.worder_id', 'LEFT'],
                ['config_form p6', 'p6.id=p5.config_form_id', 'LEFT'],
            ])->where([
                'p4.is_del'       => 0,
                'p5.is_del'       => 0,
                'p6.is_del'       => 0,
                'p4.installer_id' => $installId,
                'p6.key'          => $installAssessKey,
            ])->buildSql();
        $query = Db::table($repairSql . ' AS a')->unionAll($installSql)->buildSql();
        $data = Db::table($query . ' as b')->fieldRaw('`name`,avg(config_value) `value`')->group('`name`')->select();

        //该工程师所有工单
        $countAll = db('work_order')->where([
            'installer_id' => $installId,
            'factory_id'   => $factoryId,
            'is_del'       => 0,
        ])->count();
        $countFinish = db('work_order')->where([
            'installer_id'      => $installId,
            'factory_id'        => $factoryId,
            'is_del'            => 0,
            'work_order_status' => 4,
        ])->count();
        $rate=round($countFinish/$countAll,2)*5;
        $data[]=[
            'name'=>'解决率',
            'value'=>$rate,
        ];
        //综合分数
        $sum=array_sum(array_column($data,'value'));
        $count=count($data);
        $scoreOverall=0;
        if ($count > 0) {
            $scoreOverall=number_format($sum/$count,2,'.','');
        }
        $bool = db('user_installer')->where([
            'installer_id' => $installId,
            'is_del'       => 0,
        ])->update([
            'score_overall' => $scoreOverall,
            'score_detail'  => json_encode($data),
            'update_time'   => time(),
        ]);
        return dataFormat(0, 'ok', [
            'score_overall' => $scoreOverall,
            'score_detail'  => $data,
        ]);
    }
}