<?php
namespace app\api\controller;

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
//         $this->thisTime = time() - 6*24*60*60;//5天前
//         $this->thisTime = time() - 5*24*60*60;//4天前
//         $this->thisTime = time() - 3*24*60*60;//3天前
//         $this->thisTime = time() - 2*24*60*60;//2天前
//         $this->thisTime = time() - 1*24*60*60;//1天前
        $this->thisTime = time();
        $this->configKey = 'db_config';
    }
    public function index()
    {
        $return = [];
        $orderModel = db('order', $this->configKey);
        $workOrderModel = db('work_order', $this->configKey);
        $beginToday = mktime(0,0,0,date('m'),date('d'),date('Y'));
        //今日服务人数 累计服务人数
        $where = [
            ['factory_id', '=', $this->factoryId],
        ];
        $field = 'count(IF(add_time >= '.$beginToday.' AND work_order_status > 0 , true, null)) as today_count';
        $field .= ', count(*) as total_count';
        $field .= ', count(IF(work_order_status = 0, true, null)) as pendding_count';
        $field .= ', count(IF(work_order_status = 3, true, null)) as service_count';
        $field .= ', count(IF(work_order_status = 4, true, null)) as finish_count';
        $todayStartTime = $this->thisTime - 24*60*60;
        $todayEndTime = $this->thisTime;
        $field .= ', count(IF(add_time >= '.$todayStartTime.' AND add_time <= '.$todayEndTime.' AND work_order_status > 0, true, null)) as 24_count';
        $todayStartTime = $this->thisTime - 48*60*60;
        $todayEndTime = $this->thisTime - 24*60*60;
        $field .= ', count(IF(add_time >= '.$todayStartTime.' AND add_time <= '.$todayEndTime. ' AND work_order_status > 0, true, null)) as 48_count';
        $workOrder = $workOrderModel->where($where)->field($field)->find();
        $countPercent = $workOrder['48_count'] > 0 ? $workOrder['24_count']/$workOrder['48_count'] : 0;
        $workOrder['today_count_percent']= sprintf("%01.2f", $countPercent*100).'%';
        unset($workOrder['48_count'], $workOrder['24_count']);
        //工单完成率
        $countPercent = $workOrder['total_count'] > 0 ? $workOrder['service_count']/$workOrder['total_count'] : 0;
        $workOrder['finish_percent']= sprintf("%01.2f", $countPercent*100).'%';
        
        $return['work_order'] = $workOrder;
        //今日交易额 总交易额 今日交易笔数 总交易笔数
        $where = [
            ['factory_id', '=', $this->factoryId],
        ];
        $field = 'sum(IF(add_time >= '.$beginToday.', real_amount, 0)) as today_amount';
        $field .= ', sum(real_amount) as total_amount';
        $field .= ', count(IF(add_time >= '.$beginToday.', true, null)) as today_count';
        $field .= ', count(*) as total_count';
        $field .= ', count(IF(delivery_status = 0, true, null)) as pendding_count';
        $field .= ', count(IF(delivery_status = 2, true, null)) as delivery_count';
        $field .= ', count(IF(finish_status = 2, true, null)) as finish_count';
        
        $todayStartTime = $this->thisTime - 24*60*60;
        $todayEndTime = $this->thisTime;
        $field .= ', sum(IF(add_time >= '.$todayStartTime.' AND add_time <= '.$todayEndTime.', real_amount, 0)) as 24_amount';
        $field .= ', count(IF(add_time >= '.$todayStartTime.' AND add_time <= '.$todayEndTime.', true, null)) as 24_count';
        $todayStartTime = $this->thisTime - 48*60*60;
        $todayEndTime = $this->thisTime - 24*60*60;
        $field .= ', sum(IF(add_time >= '.$todayStartTime.' AND add_time <= '.$todayEndTime.', real_amount, 0)) as 48_amount';
        $field .= ', count(IF(add_time >= '.$todayStartTime.' AND add_time <= '.$todayEndTime.', true, null)) as 48_count';
        $order = $orderModel->where($where)->field($field)->find();
        
        //交易金额计算同比 = 当前时间24小时内的交易金额/当前时间48-24小时的交易金额
        $amountPercent = $order['48_amount'] > 0 ? $order['24_amount']/$order['48_amount'] : 0;
        $order['today_amount_percent']= sprintf("%01.2f", $amountPercent*100).'%';
        
        $countPercent = $order['48_count'] > 0 ? $order['24_count']/$order['48_count'] : 0;
        $order['today_count_percent']= sprintf("%01.2f", $countPercent*100).'%';
        
        $amountPercent = $order['total_amount'] > 0 ? $order['today_amount']/$order['total_amount'] : 0;
        $order['total_amount_percent']= sprintf("%01.2f", $amountPercent*100).'%';
        
        $countPercent = $order['total_count'] > 0 ? $order['today_count']/$order['total_count'] : 0;
        $order['total_count_percent']= sprintf("%01.2f", $countPercent*100).'%';
        unset($order['48_count'], $order['24_count'], $order['48_amount'], $order['24_amount']);
        
        //订单完成率
        $countPercent = $order['total_count'] > 0 ? $order['finish_count']/$order['total_count'] : 0;
        $order['finish_percent']= sprintf("%01.2f", $countPercent*100).'%';
        $return['order'] = $order;
        //实时订单列表
        $join = [
            ['order_sku OS', 'OS.order_id = O.order_id', 'INNER'],
        ];
        $where = [
            ['O.factory_id', '=', $this->factoryId],
        ];
        $orders = db('order', $this->configKey)->field('sku_name, real_amount, FROM_UNIXTIME(O.add_time, "%Y年%m月%d日 %H:%i:%s") as add_time')->alias('O')->join($join)->where($where)->limit(0, 7)->order('O.add_time DESC')->select();
        $return['orders'] = $orders ? $orders : [];
        $where = [
            ['store_id', '=', $this->factoryId],
        ];
        $return['goods'] = db('goods', $this->configKey)->where($where)->field('name, min_price, sales, (min_price * sales) as total_price')->order('sales DESC')->limit(0, 8)->select();
        
        //获取近七日工单
        $workOrders = [];
        for ($i = 6; $i >=0; $i--) {
            //php获取昨日起始时间戳和结束时间戳
            $beginTime = mktime(0,0,0,date('m'),date('d')-$i,date('Y'));
            $endTime = $beginTime + 24*60*60-1;
            $day = date('m-d', $beginTime);
            $where = [
                ['add_time', '>=', $beginTime],
                ['add_time', '<=', $endTime],
            ];
            $field = 'count(IF(work_order_type = 1, true, null)) as install_count, count(IF(work_order_type = 2, true, null)) as repair_count';
            $info = db('work_order', $this->configKey)->field($field)->where($where)->find();
            $workOrders['day'][] = $day;
            $workOrders['install_count'][] = $info['install_count'];
            $workOrders['repair_count'][] = $info['repair_count'];
        }
        $return['work_order_lines'] = $workOrders;
        
        //商户统计(服务商 零售商 售后工程师)
        $where = [
            ['factory_id', '=', $this->factoryId],
        ];
        $field = 'count(IF(store_type = '.STORE_SERVICE_NEW.', true, null)) as servicer_count, count(IF(store_type = '.STORE_DEALER.', true, null)) as dealer_count';
        $store = db('store', $this->configKey)->field($field)->where($where)->find();
        $return['store'] = $store;
        $where = [
            ['factory_id', '=', $this->factoryId],
        ];
        $count = db('user_installer', $this->configKey)->where($where)->count();
        $return['user_installer']['installer_count'] = $count;
        if ($this->request->param('test')) {
            pre($return);
        }
        $this->_returnMsg(['return' => $return]);
    }
    public function timer()
    {
        $time = date('Y-m-d H:i:s');
//         try {
            //定时器在每日8点到20点 每秒执行
            $hour = date('H', $this->thisTime);
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
            
            $this->_returnScreenMsg(['time' => $time]);
//         } catch (\Exception $e) {
//             $this->errorArray = $e;
//             $this->_returnScreenMsg(['time' => $time, 'errCode' => 1, 'errMsg' => $e]);
//         }
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
            ['latitude', '<>', ''],
            ['longitude', '<>', ''],
        ];
        $rand = rand(60, 80);
        $citys = db('region', $this->configKey)->where($where)->limit(0, $rand)->orderRaw('rand()')->column('region_id, region_name');
        $servicers = [];
        foreach ($citys as $key => $value) {
            //每个服务商生成1-10个零售商
            $dealerCount = rand(1, 10);
            //获取城市下的区域列表
            $where = [
                ['parent_id', '=', $key],
                ['latitude', '<>', ''],
                ['longitude', '<>', ''],
            ];
            $lists = db('region', $this->configKey)->where($where)->field('region_id, region_name')->orderRaw('rand()')->limit(0, $dealerCount)->select();
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
                        'work_time' => date('Y-m-d', $this->thisTime),
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
        $timeRand = rand(0, 2*60*60);
        $storeCount = 350;
        if ($timeRand > $storeCount) {
//             $this->errorArray = ['createRand' => $timeRand];
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
//             ['O.add_time', '>=', $this->thisTime-24*60*60],
            ['OSS.install_price', '>', 0],
        ];
        $result = $this->_iworder($where, 20, (24*60*60-15*60));
        return TRUE;
    }
    private function _createRepairWorkOrder()
    {
        $workOrderModel = db('work_order', $this->configKey);
        $beginToday = mktime(0,0,0,date('m', $this->thisTime),date('d', $this->thisTime),date('Y', $this->thisTime));
        $endToday = mktime(0,0,0,date('m', $this->thisTime),date('d', $this->thisTime)+1,date('Y', $this->thisTime))-1;
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
//             $this->errorArray['createRepairCount'] = $count."==".$num;
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
//                 $max = $endToday - $this->thisTime;
//                 $max = 1*24*60*60;
                $max = (20-8)*60*60;
                for ($i = 0; $i <= $num; $i++) {
                    $rand = rand(0, $max);
                    if ($rand <= 1) {
                        $dataset[] = [
                            'worder_sn'         => $this->_getWorderSn(),
                            'work_order_type'   => 2,
                            'factory_id'        => $this->factoryId,
                            'add_time'          => $this->thisTime,
                            'images'            => '',
                            'fault_desc'        => '',
                        ];
                    }else{
//                         $this->errorArray['createRepairRand'][] = $i."==".$rand;
                    }
                }
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
        $hour = date('H', $this->thisTime);
        if ($hour >= 9 && $hour <= 18) {
            $where = [
                ['delivery_status', '=', 0],
                ['finish_status', '=', 0],
            ];
            $orderIds = $orderModel->where($where)->where('add_time', '<=', ($this->thisTime - 30 * 60))->column('order_id');
            if ($orderIds) {
                foreach ($orderIds as $key => $value) {
                    $timeRand = rand(0, (60-30)*60);
                    if ($timeRand > 1) {
                        unset($orderIds[$key]);
                    }
                }
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
            foreach ($orderIds as $key => $value) {
                $timeRand = rand(0, (7-3)*24*60*60);
                if ($timeRand > 1) {
                    unset($orderIds[$key]);
                }
            }
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
        //待分派的工单修改成为服务中的工单(新工单 有80-90%的概率 在1-15分钟内分派)
        $this->_signWorkOrder($pro, $total, 1);
        
        $pro = rand(10, 20);
        $total = 24*60*60 - 15*60;
        //待分派的工单修改成为服务中的工单(新工单 有10-20%的概率 在15分-24小时内分派)
        $this->_signWorkOrder($pro, $total, 2);
        
        $workOrderModel = db('work_order', $this->configKey);
        //工单完成(到预约时间10-15分钟完成)
        $where = [
            'work_order_status' => 3,
            'factory_id' => $this->factoryId,
        ];
        $worderIds = $workOrderModel->where($where)->where('appointment', '>=', 'appointment + 10 * 60')->column('worder_id');
        if ($worderIds) {
            foreach ($worderIds as $key => $value) {
                $timeRand = rand(0, (15-10)*60);
                $count = 1;
                if ($timeRand > $count) {
                    unset($worderIds[$key]);
                }
            }
            $data = [
                'work_order_status' => 4,
                'finish_time' => $this->thisTime,
                'finish_confirm_time'   => $this->thisTime,
            ];
            $result = db('work_order', $this->configKey)->where('worder_id', 'IN', $worderIds)->update($data);
        }
        return TRUE;
    }
    private function _signWorkOrder($pro, $total, $type)
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
                $rand = rand(0, 100* ($total));
                if ($rand <= ($pro * 1)) {
                    $data = [
                        'work_order_status' => 3,
                        'dispatch_time' => $this->thisTime,
                        'receive_time'  => $this->thisTime,
                        'sign_time'     => $this->thisTime,
                        'update_time'   => $this->thisTime,
                    ];
                    $result = $workOrderModel->where(['worder_id' => $value['worder_id']])->update($data);
                }else{
                    $this->errorArray[$type][$key] = $pro.'=='.$total.'=='.$rand;
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
     * 中断并返回数据,后面程序继续执行,避免用户等待(immediate)
     * 可用于返回值后,继续执行程序,但程序占得所以资源没有释放,一直占用,务必注意,最好给单独脚本执行
     * @param   string|array      $data 字符串或数组,数组将被转换成json字符串
     * @param   intval      $set_time_limit 设置后面程序最大执行时间,0不限制,但web页面设置最大执行时间不一定靠谱,可改用脚本或单独开子进程
     * @return
     */
    function returnAndContinue($data = '',$set_time_limit=10)
    {
        $str=is_string($data)  ? $data : json_encode($data , JSON_UNESCAPED_UNICODE);
        header('Content-Type:application/json');
        echo $str;
        if(function_exists('fastcgi_finish_request')){			//Nginx使用
            fastcgi_finish_request();		//后面输出客户端获取不到
        }else {			//apache 使用
            $size = ob_get_length();
            header("Content-length: $size");
            header('Connection:close');
            ob_end_flush();
            //ob_flush();       //加了没效果
            flush();
        }
        ignore_user_abort(true);
        set_time_limit($set_time_limit);
        return $str;
    }
    /**
     * 处理接口返回信息
     */
    protected function _returnScreenMsg($data, $echo = TRUE){
        $result = self::returnAndContinue($data);
        $responseTime = $this->_getMillisecond() - $this->visitMicroTime;//响应时间(毫秒)
        $addData = [
            'request_time'  => $this->requestTime,
            'return_time'   => $this->thisTime,
            'method'        => $this->method ? $this->method : '',
            'return_params' => $result,
            'response_time' => $responseTime,
            'error'         => isset($data['errCode']) ? intval($data['errCode']) : 0,
            'errmsg'        => json_encode($this->errorArray),
            'show_time'     => date('Y-m-d H:i:s'),
        ];
        $apiLogId = db('apilog_timer',$this->configKey)->insertGetId($addData);
        sleep(1);//休眠1秒后,再次执行刷数据任务
        $url = "http://" .$this->request->host() . $this->request->url();
        curl_request($url);
        exit();
    }
    /**
     * 处理接口返回信息
     */
    protected function _returnMsg($data, $echo = TRUE){
        if (!isset($data['errCode']) || !$data['errCode']) {
            $tempArr = ['errCode' => 0, 'errMsg' => 'ok'];
            $data = $data ? ($tempArr + $data) : $data;
        }
        $result = json_encode($data);
        if ($echo) {
            header('Content-Type:application/json');
            echo $result;
        }
        $responseTime = $this->_getMillisecond() - $this->visitMicroTime;//响应时间(毫秒)
        $addData = [
            'module'        => $this->request->module(),
            'controller'    => strtolower($this->request->controller()),
            'action'        => $this->request->action(),
            'request_time'  => $this->requestTime,
            'request_source'=> 'screen',
            'return_time'   => time(),
            'method'        => $this->method ? $this->method : '',
            'request_params'=> json_encode($this->request->param()),
            'return_params' => $result,
            'response_time' => $responseTime,
            'error'         => isset($data['errCode'])  ? intval($data['errCode']) : 0,
            'msg'           => isset($data['errMsg'])  ? $data['errMsg'] : '',
        ];
        $apiLogId = db('apilog_app', $this->configKey)->insertGetId($addData);
        exit();
    }
}