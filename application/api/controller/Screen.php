<?php
namespace app\api\controller;
use GatewayWorker\Lib\Db;

/**
 * 定时器定时执行模拟数据
 * @author xiaojun
 */
class Screen extends Timer
{
    private $goodslist;
    private $configKey;
    private $factoryId = 1;
    
    private $thisTime;
    
    public function __construct(){
        parent::__construct();
        $this->thisTime = time();
        $this->configKey = 'db_config';
    }
    public function index()
    {
        
    }
    public function timer()
    {
        $time = date('Y-m-d H:i:s');
        try {
            //定时器在每日8点到20点 每秒执行
            $hour = date('H');
            if ($hour < 8 || $hour > 20) {
                return FALSE;
            }
            //生成订单
            $this->_createOrder();
            //生成安装工单
            $this->_createInstallWorkOrder();
            //生成维修工单
            $this->_createRepairWorkOrder();
            //修改订单状态(待发货 已发货 已完成)
            $this->_updateOrderStatus();
            //修改工单状态(待分派 服务中 已完成)
            $this->_updateWorkOrderStatus();
            
            $this->_returnMsg(['time' => $time]);
        } catch (\Exception $e) {
            $this->errorArray = $e;
            $this->_returnMsg(['time' => $time, 'errCode' => 1, 'errMsg' => $e]);
        }
    }
    public function store()
    {
        //60-80个服务商 每个服务商生成1-10个零售商 5-10个工程师 （按城市地区生成服务商 再按服务区域生成零售商和工程师 零售商下的订单 自动转到服务商这里 服务商分配给下面的工程师 ）
        $regionModel = db('region', $this->configKey);
        $storeModel = db('store', $this->configKey);
        $storeServicerModel = db('store_servicer', $this->configKey);
        $storeDealerModel = db('store_dealer', $this->configKey);
        $installerModel = db('user_installer', $this->configKey);
        //生成服务商
        $where = [
            ['parent_id', '=', 1],
        ];
        $regions = $regionModel->where($where)->column('region_id');
        $where = [
            ['parent_id', 'IN', $regions],
        ];
        $rand = rand(60, 80);
        $citys = db('region', $this->configKey)->where($where)->limit(0, $rand)->orderRaw('rand()')->column('region_id, region_name');
        $servicers = [];
        foreach ($citys as $key => $value) {
            //每个服务商生成1-10个零售商
            $dealerCount = rand(1, 10);
            //获取城市下的区域列表
            $lists = db('region', $this->configKey)->where('parent_id', $key)->field('region_id, region_name')->orderRaw('rand()')->limit(0, $dealerCount)->select();
            $count = count($lists);
            //生成服务商
            $data = [
                'factory_id' => $this->factoryId,
                'store_type' => STORE_SERVICE_NEW,
                'name'      => $value,
                'add_time' => $this->thisTime,
                'config_json' => '',
                'enter_type' => 0,
                'region_id' => $key,
                'region_name' => $value,
                'store_id' => 0,
            ];
            $storeId = $storeModel->insertGetId($data);
            if ($storeId > 0) {
                $data = [
                    'store_id' => $storeId,
                ];
                $result = $storeServicerModel->insert($data);
                for ($i = 0; $i < $count; $i++) {
                    $data = [
                        'factory_id' => $this->factoryId,
                        'store_type' => STORE_DEALER,
                        'name'      => $value.'_零售商'.$i,
                        'add_time' => $this->thisTime,
                        'config_json' => '',
                        'enter_type' => 3,
                        'store_id' => 0,
                        'region_id' => $lists[$i]['region_id'],
                        'region_name' => $value. ' ' .$lists[$i]['region_name'],
                    ];
                    $dealerId = $storeModel->insertGetId($data);
                    if ($dealerId > 0) {
                        $data = [
                            'store_id' => $dealerId,
                            'ostore_id' => $storeId,
                        ];
                        $result = $storeDealerModel->insert($data);
                    }
                }
                
                //每个服务商生成5-10个工程师
                $rand = rand(5, 10);
                for ($i = 0; $i < $rand; $i++) {
                    $data = [
                        'factory_id' => $this->factoryId,
                        'store_id' => $storeId,
                        'add_time' => $this->thisTime,
                        'check_status' => 1,
                        'installer_id' => 0,
                        'work_time' => date('Y-m-d'),
                    ];
                    $result = $installerModel->insertGetId($data);
                }
            }
        }
        pre($citys);
    }
    public function goods()
    {
        $this->goodslist = [
            [
                'name'      => '商品名称',
                'amount'    => '23.56',
                'is_install'=> 1,//是否可安装
            ],
            [
                'name'      => '测试商品',
                'amount'    => '19.99',
                'is_install'=> 1,//是否可安装
            ],
            [
                'name'      => '苹果',
                'amount'    => '19.99',
                'is_install'=> 1,//是否可安装
            ],
            [
                'name'      => '雪梨',
                'amount'    => '9.54',
                'is_install'=> 1,//是否可安装
            ],
            [
                'name'      => '葡萄',
                'amount'    => '40',
                'is_install'=> 1,//是否可安装
            ],
            [
                'name'      => '荔枝',
                'amount'    => '30',
                'is_install'=> 0,//是否可安装
            ],
            [
                'name'      => '油桃',
                'amount'    => '20',
                'is_install'=> 0,//是否可安装
            ],
            [
                'name'      => '香蕉',
                'amount'    => '10',
                'is_install'=> 0,//是否可安装
            ],
        ];
        $dataset = [];
        foreach ($this->goodslist as $key => $value) {
            $dataset[] = [
                'store_id' => $this->factoryId,
                'name' => $value['name'],
                'min_price' => $value['amount'],
                'goods_stock' => 0,
                'add_time'  => $this->thisTime,
                'content' => '',
                'install_price' => $value['is_install'],
            ];
        }
        db('goods', $this->configKey)->insertAll($dataset);
        pre($dataset);
    }
    private function _createOrder()
    {
        $orderModel = db('order', $this->configKey);
        //订单各零售商大概在8点到20点 每30分钟-2小时左右生成一个订单 每天生成4-5个订单 左右
        //随机获取零售商数据
        $where = [
            ['factory_id', '=', $this->factoryId],
            ['store_type', '=', STORE_DEALER],
        ];
        $store = db('store', $this->configKey)->where($where)->orderRaw('rand()')->find();
        if (!$store) {
            return FALSE;
        }
        //判断当前零售商当日订单生成数量
        $where = [
            ['factory_id', '=', $this->factoryId],
            ['user_store_id', '=', $store['store_id']],
        ];
        $orderCount = $orderModel->where($where)->count();
        if ($orderCount >= 5) {
            return FALSE;
        }
        //获取当前零售商最后一次创建订单时间
        $where = [
            ['factory_id', '=', $this->factoryId],
            ['user_store_id', '=', $store['store_id']],
        ];
        $lastOrder = $orderModel->where($where)->order('add_time DESC')->find();
        $timeRand = rand(30* 60, 2*60*60);
        if ($lastOrder && ($lastOrder['add_time'] - $this->thisTime) <= $timeRand) {
            return FALSE;
        }
        $goods = db('goods', $this->configKey)->orderRaw('rand()')->find();
        if (!$goods) {
            return FALSE;
        }
        $orderSkuModel = db('order_sku', $this->configKey);
        $orderSkuSubModel = db('order_sku_sub', $this->configKey);
        $num = rand(1, 4);
        $orderSn = $this->_getOrderSn();
        $data = [
            'order_type'    => 0,
            'order_sn'      => $orderSn,
            'factory_id'    => $this->factoryId,
            'user_store_id' => $store['store_id'],
            'goods_amount'  => $goods['min_price'] * $num,
            'real_amount'   => $goods['min_price'] * $num,
            'add_time'      => $this->thisTime,
            'extra'         => '',
        ];
        $orderId = $orderModel->insertGetId($data);
        if ($orderId) {
            $data = [
                'order_id'  => $orderId,
                'order_sn'  => $orderSn,
                'goods_id'      => $goods['goods_id'],
                'user_store_id' => $store['store_id'],
                'sku_name'  => $goods['name'],
                'num'       => $num,
                'sku_price' => $goods['min_price'],
                'price'     => $goods['min_price'],
                'real_price'=> $goods['min_price'],
                
                'add_time'  => $this->thisTime,
            ];
            $oskuId = $orderSkuModel->insertGetId($data);
            $dataset = [];
            for ($i = 0; $i < $num; $i++) {
                $dataset[] = [
                    'order_id'  => $orderId,
                    'order_sn'  => $orderSn,
                    'goods_id'      => $goods['goods_id'],
                    'user_store_id' => $store['store_id'],
                    'osku_id'   => $oskuId,
                    'sku_price' => $goods['min_price'],
                    'price'     => $goods['min_price'],
                    'real_price'=> $goods['min_price'],
                    'add_time'  => $this->thisTime,
                    'good_sku_code' => $oskuId.'_'.$i,
                    'install_price' => $goods['install_price'],
                ];
            }
            $orderSkuSubModel->insertAll($dataset);
            
            $result = db('goods', $this->configKey)->where(['goods_id' => $goods['goods_id']])->setInc('sales', $num);
        }
        return TRUE;
    }
    private function _createInstallWorkOrder()
    {
        //获取未安装的且创建时长在1-15分钟内的订单(创建安装工单概率80%)
        $where = [
            ['O.factory_id', '=', $this->factoryId],
            ['O.add_time', '>=', $this->thisTime-15*60],
            ['O.add_time', '<=', $this->thisTime-1*60],
            ['OSS.install_price', '>', 0],
        ];
        $result = $this->_iworder($where, 80, (15*60 - 1*60));
        
        //获取未安装的且创建时长在15分钟-24小时内的订单(创建安装工单概率20%)
        $where = [
            ['O.factory_id', '=', $this->factoryId],
            ['O.add_time', '<', $this->thisTime-15*60],
            ['O.add_time', '>=', $this->thisTime-24*60*60],
            ['OSS.install_price', '>', 0],
        ];
        $result = $this->_iworder($where, 20, (24*60*60-15*60));
        return TRUE;
    }
    private function _createRepairWorkOrder()
    {
        $workOrderModel = db('work_order', $this->configKey);
        $beginToday = mktime(0,0,0,date('m'),date('d'),date('Y'));
        $endToday = mktime(0,0,0,date('m'),date('d')+1,date('Y'))-1;
        //获取当日安装工单总数
        $where = [
            ['work_order_type', '=', 1],
            ['factory_id', '=', $this->factoryId],
            ['add_time', '>=', $beginToday],
        ];
        $count = $workOrderModel->where($where)->count();
        if ($count > 0) {
            //维修工单目标总数 = 每日安装工单*5/100
            $num = $count * 5/ 100;
            //判断是否已达到当前目标数
            $where = [
                ['work_order_type', '=', 2],
                ['factory_id', '=', $this->factoryId],
                ['add_time', '>', $beginToday],
            ];
            $count = $workOrderModel->where($where)->count();
            if ($count >= $num) { //已达到目标数则不创建维修工单
                return FALSE;
            }else{
                $dataset = [];
                //未达到目标数则根据概率判断是否创建维修工单
                $diffnum = $num - $count;
//                 $max = $endToday - $this->thisTime;
                $max = 1*24*60*60;
                for ($i = 0; $i < $diffnum; $i++) {
                    $rand = rand(1, $max);
                    if ($rand <= 1) {
                        $dataset[] = [
                            'worder_sn'         => $this->_getWorderSn(),
                            'work_order_type'   => 2,
                            'factory_id'        => $this->factoryId,
                            'add_time'          => $this->thisTime,
                            'images'            => '',
                            'fault_desc'        => '',
                        ];
                    }
                }
                echo "REPAIR===:<br>";
                pre($dataset, 1);
                if ($dataset) {
                    $workOrderModel->insertAll($dataset);
                }
            }
        }
        return TRUE;
    }
    private function _updateOrderStatus()
    {
        $orderModel = db('order', $this->configKey);
        $orderSkuModel = db('order_sku', $this->configKey);
        //订单发货(订单创建30分钟-60分钟内发货 且时间在当天 09-18点)
        $hour = date('H');
        if ($hour >= 9 && $hour <= 18) {
            $where = [
                ['delivery_status', '=', 0],
                ['finish_status', '=', 0],
            ];
            $orderIds = $orderModel->where($where)->where('add_time', '<=', ($this->thisTime - 30 * 60))->column('order_id');
            if ($orderIds) {
                $data = [
                    'delivery_status' => 2,
                    'update_time' => $this->thisTime,
                ];
                $result = $orderModel->where('order_id', 'IN', $orderIds)->update($data);
                $data['delivery_time'] = $this->thisTime;
                $result = $orderSkuModel->where('order_id', 'IN', $orderIds)->update($data);
            }
        }
        $orderModel = db('order', $this->configKey);
        //订单完成(已发货3-7天内确认收货)
        $where = [
            ['O.delivery_status', '=', 2],
            ['O.finish_status', '=', 0],
            ['delivery_time', '<=', $this->thisTime - 3*24*60*60],
        ];
        $join = [
            ['order_sku OS', 'O.order_id = OS.order_id', 'INNER'],
        ];
        $orderIds = $orderModel->alias('O')->join($join)->where($where)->column('O.order_id');
        if ($orderIds) {
            $data = [
                'finish_status' => 2,
                'update_time' => $this->thisTime,
            ];
            $result = db('order', $this->configKey)->where('order_id', 'IN', $orderIds)->update($data);
        }
        return TRUE;
    }
    private function _updateWorkOrderStatus()
    {
        $pro = rand(80, 90);
        $total = 15*60 - 1*60;
        //待分派的订单修改成为服务中的订单(新工单 有80-90%的概率 在1-15分钟内分派)
        $this->_signWorkOrder($pro, $total);
        $pro = rand(10, 20);
        $total = 24*60*60 - 15*60;
        
        //待分派的订单修改成为服务中的订单(新工单 有10-20%的概率 在15分-24小时内分派)
        $this->_signWorkOrder($pro, $total);
        $workOrderModel = db('work_order', $this->configKey);
        //工单完成(到预约时间10-15分钟完成)
        $where = [
            'work_order_status' => 3,
            'factory_id' => $this->factoryId,
        ];
        $data = [
            'work_order_status' => 4,
            'finish_time' => $this->thisTime,
            'finish_confirm_time'   => $this->thisTime,
        ];
        $rand = rand(150, 300);
        $start = $rand/10 * 60;
        $end = 15 * 60;
        $result = $workOrderModel->where($where)->where('appointment', '>=', 'appointment +'.$start)->where('appointment', '<=', 'appointment +'.$end)->update($data);
        return TRUE;
    }
    private function _signWorkOrder($pro, $total)
    {
        $workOrderModel = db('work_order', $this->configKey);
        $max = 100;
        $field = 'worder_id';
        $where = [
            ['factory_id', '=', $this->factoryId],
            ['work_order_status', '=', 0],
        ];
        $worders = $workOrderModel->field($field)->where($where)->limit(0, $max)->select();
        if ($worders) {
            $dataset = [];
            foreach ($worders as $key => $value) {
                $rand = rand(1, 100* ($total));
                if ($rand <= ($pro * 1)) {
                    $data = [
                        'work_order_status' => 3,
                        'dispatch_time' => $this->thisTime,
                        'receive_time' => $this->thisTime,
                        'sign_time' => $this->thisTime,
                        'update_time' => $this->thisTime,
                    ];
                    echo '更新状态-服务中===:<br>';
                    $result = $workOrderModel->where(['worder_id' => $value['worder_id']])->update($data);
                }
            }
        }
        return true;
    }
    private function _iworder($where, $pro, $total)
    {
        $max = 100;
        $orderModel = db('order', $this->configKey);
        $workOrderModel = db('work_order', $this->configKey);
        $join = [
            ['order_sku_sub OSS', 'OSS.order_id = O.order_id', 'LEFT'],
            ['work_order WO', 'WO.ossub_id = OSS.ossub_id', 'LEFT'],
            ['store_dealer SD', 'SD.store_id = O.user_store_id', 'LEFT'],
        ];
        
        $field = 'O.order_id, O.order_sn, OSS.ossub_id, O.add_time, SD.ostore_id, O.user_store_id, OSS.goods_id';
        $orders = $orderModel->field($field)->alias('O')->join($join)->where($where)->whereNull('WO.ossub_id')->limit(0, $max)->select();
        if ($orders) {
            $dataset = [];
            foreach ($orders as $key => $value) {
                //预约时间:0-3天内的10-18点 且大于当前时间2小时以上
                $appointment = $this->_getAppointment();
                $servicerId = $value['ostore_id'];
                //获取当前服务商下的随机工程师ID
                $where = [
                    ['factory_id', '=', $this->factoryId],
                    ['store_id', '=', $servicerId],
                ];
                $installerId = db('user_installer', $this->configKey)->where($where)->limit(0, 1)->orderRaw('rand()')->value('installer_id');
                if ($installerId) {
                    //判断每个订单出现的概率
                    $rand = rand(1, 100* $total);
                    if ($rand <= ($pro * 1)) {
                        $dataset[] = [
                            'worder_sn'         => $this->_getWorderSn(),
                            'work_order_type'   => 1,
                            'factory_id'        => $this->factoryId,
                            'installer_id'      => $installerId,
                            'add_time'          => $this->thisTime,
                            'post_store_id'     => $value['user_store_id'],
                            'goods_id'          => $value['goods_id'],
                            'images'            => '',
                            'fault_desc'        => '',
                            'ossub_id'          => $value['ossub_id'],
                            'order_sn'          => $value['order_sn'],
                            'appointment'       => $appointment,
                        ];
                    }
                }
            }
            echo "INSTALL===:<br>";
            if ($dataset) {
                $result = $workOrderModel->insertAll($dataset);
            }
        }
        return TRUE;
    }
    private function _getAppointment()
    {
        //预约时间:0-3天内的10-18点 且大于当前时间2小时以上
        $today = strtotime(date("Y-m-d"), $this->thisTime);
        $day = rand(0, 3);
        $startTime = $today + $day*24*60*60 +  10*60*60;
        $startTime = ($startTime - $this->thisTime) > 2*60 ? $startTime : $this->thisTime + 2*60;
        $endTime = $today + $day*24*60*60 + 16*60*60;
        $time = rand($startTime, $endTime);
        if (!$time) {
            return $this->_getAppointment();
        }
        return $time;
    }
    private function _getOrderSn($sn = '')
    {
        $sn = date('YmdHis').substr(implode(NULL, array_map('ord', str_split(substr(uniqid(), 7, 13), 1))), 0, 6).get_nonce_str(9, 2);
        $orderModel = db('order', $this->configKey);
        $exist = $orderModel->where(['order_sn' => $sn])->find();
        if ($exist) {
            return $this->_getOrderSn();
        }else{
            return $sn;
        }
    }
    private function _getWorderSn($sn = '')
    {
        $sn = $sn ? $sn : date('YmdHis').get_nonce_str(6, 2);
        $workOrderModel = db('work_order', $this->configKey);
        //判断售后工单号是否存在
        $info = $workOrderModel->where(['worder_sn' => $sn])->find();
        if ($info){
            return $this->_getWorderSn();
        }else{
            return $sn;
        }
    }
    /**
     * 处理接口返回信息
     */
    protected function _returnMsg($data, $echo = TRUE){
        $result = parent::_returnMsg($data);
        $responseTime = $this->_getMillisecond() - $this->visitMicroTime;//响应时间(毫秒)
        $addData = [
            'request_time'  => $this->requestTime,
            'return_time'   => $this->thisTime,
            'method'        => $this->method ? $this->method : '',
            'return_params' => $result,
            'response_time' => $responseTime,
            'error'         => isset($data['errCode']) ? intval($data['errCode']) : 0,
            'errmsg'        => $this->errorArray ? json_encode($this->errorArray) : '',
            'show_time'     => date('Y-m-d H:i:s'),
        ];
        $apiLogId = db('apilog_screen')->insertGetId($addData);
        exit();
    }
}