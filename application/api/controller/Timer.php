<?php
namespace app\api\controller;
/**
 * 定时器执行接口
 * @author xiaojun
 */
class Timer extends ApiBase
{
    var $method;
    var $errorArray = [];
    public function __construct(){
        parent::__construct();
        $this->method = $this->request->action();
        $this->_checkPostParams();
    }
    /**
     * 每分钟执行定时器
     */
    public function minute()
    {
        $time = date('Y-m-d H:i:s');
        $thisTime = time();
        try {
            //获取系统默认配置
            $default = get_system_config('system_default');
            $defaultConfig = $default['config_value'];
            
            $storeModel = new \app\common\model\Store();
            $orderModel = new \app\common\model\Order();
            $workOrderModel = new \app\common\model\WorkOrder();
            //获取厂商配置
            $where = ['store_type' => STORE_FACTORY, 'is_del' => 0];
            $lists = $storeModel->where($where)->field('store_id, config_json')->select();
            $factorys = [];
            if ($lists) {
                $cancelMap = $finishMap = $assessMap =$factoryIds= [];
                foreach ($lists as $key => $value) {
                    $factoryId = $value['store_id'];
                    $config = $value['config_json'] ? json_decode($value['config_json'], 1) : [];
                    $config = isset($config['default']) ? $config['default'] : [];
                    if ($defaultConfig) {
                        //合并默认配置
                        foreach ($defaultConfig as $k => $v) {
                            if (!isset($config[$k])) {
                                $config[$k] = $v;
                            }
                        }
                    }
                    //待支付订单超时时间限制(分钟)
                    $orderCancelMinute = $config && isset($config['order_cancel_minute']) ? $config['order_cancel_minute'] : 0;
                    if ($orderCancelMinute > 0) {
                        $cancelMap[] = '(store_id = '.$factoryId.' AND add_time <= '. ($thisTime - ($orderCancelMinute * 60)).')';
                    }
                    //退货退款时间(天数),支付成功后超过配置时间则不允许退货退款
                    $orderReturnDay = $config && isset($config['order_return_day']) ? $config['order_return_day'] : 0;
                    if ($orderReturnDay > 0) {
                        $orderReturnDayTime = $orderReturnDay * 24 * 60 * 60;
                        $finishMap[] = '(store_id = '.$factoryId.' AND pay_time <= '. ($thisTime - $orderReturnDayTime).')';
                    }

                    /* //工单自动评价时间(天数),售后服务完成，如超过配饰时间用户未评价仍然未评价，系统自动给好评并完成服务费结算；
                    $workOrderAssessDay = $config && isset($config['workorder_auto_assess_day']) ? $config['workorder_auto_assess_day'] : 0;
                    if ($workOrderAssessDay > 0) {
                        $workOrderAssessDayTime = $workOrderAssessDay * 24 * 60 * 60;
                        $assessMap[] = '(factory_id = '.$factoryId.' AND finish_time <= '. ($thisTime - $workOrderAssessDayTime).')';
                    } */

                    $factoryIds[]=$factoryId;


                }
                if ($cancelMap) {
                    $cancelSql = 'order_status = 1 AND pay_status = 0';
                    $cancelSql .= ' AND ('.implode(' OR ', $cancelMap).')';
                    $orders = $orderModel->where($cancelSql)->select();
                    if ($orders) {
                        $remark = '订单超时未付款，系统自动取消订单';
                        //订单批量取消
                        foreach ($orders as $key => $value) {
                            $result = $orderModel->orderCancel($value['order_sn'], ['user_id' => 0, 'nickname' => '系统'], $remark);
                            if ($result === FALSE) {
                                $this->errorArray['cancel'][] = [
                                    'action'    => $remark,
                                    'order_sn'  => $value['order_sn'],
                                    'error'     => $orderModel->error,
                                ];
                            }
                        }
                    }
                }
                if ($finishMap) {
                    $finishSql = 'order_status = 1 AND pay_status = 1 AND finish_status = 2 AND pay_time > 0 AND close_refund_status != 2';
                    $finishSql .= ' AND ('.implode(' OR ', $finishMap).')';
                    $orders = $orderModel->where($finishSql)->select();
                    if ($orders) {
                        //订单批量控制是否可退还并将不可退还的订单佣金改为入账状态
                        foreach ($orders as $key => $value) {
                            $result = $orderModel->orderCloseRefund($value, FALSE, '自动关闭退货退款功能');
                            if ($result === FALSE) {
                                $this->errorArray['finish'][] = [
                                    'action'    => $remark,
                                    'order_sn'  => $value['order_sn'],
                                    'error'     => $orderModel->error,
                                ];
                            }
                        }
                    }
                }
                /* if ($assessMap) {
                    $assessSql = implode(' OR ', $assessMap);
                    //获取未进行首次评价的已完成的工单(安装和维修工单)
                    $assessWhere = [
                        'work_order_status' => 4,
                    ];
                    $where[] = ['', 'EXP', \think\Db::raw('assess_id IS NULL OR assess_id = 0')];
                    $where[] = ['', 'EXP', \think\Db::raw($assessSql)];
                    $join = [
                        ['work_order_assess WOS', 'WO.worder_id = WOS.worder_id AND WOS.type = 1', 'LEFT'],
                    ];
                    $workOrders = $workOrderModel->field('WOS.*, WO.*')->alias('WO')->join($join)->where($assessWhere)->select();
                    if ($workOrders) {
                        foreach ($workOrders as $key => $value) {
                            //自动评价+安装费返还
                            $result = $workOrderModel->worderAssess($value, FALSE, FALSE);
                            if ($result === FALSE) {
                                $this->errorArray['assess'][] = [
                                    'action'    => '自动评价',
                                    'order_sn'  => $value['worder_sn'],
                                    'error'     => $workOrderModel->error,
                                ];
                            }
                        }
                    }
                } */
                //工单分派1小时后工程师未接单，工单将自动返回至服务商
                if (!empty($factoryIds)) {
                    $where = [
                        'work_order_status' => 1,
                        'is_del'            => 0,
                        'dispatch_time'     => ['<=', $thisTime - 3600],
                        'factory_id'        => ['in', $factoryIds],
                    ];
                    $workOrders=$workOrderModel->where($where)->cursor();
                    foreach ($workOrders as $value) {
                        $result = $workOrderModel->dispatch_recycle($value);
                        if ($result['code'] !== '0') {
                            $this->errorArray['dispatch_recycle'][] = [
                                'action'    => '撤回已分派工单，重新分派',
                                'worder_sn' => $value['worder_sn'],
                                'error'     => $result['msg'],
                            ];
                        }
                    }
                }
            }
            $this->_returnMsg(['time' => $time]);
        } catch (\Exception $e) {
            $this->errorArray = $e;
            $this->_returnMsg(['time' => $time, 'errCode' => 1, 'errMsg' => $e]);
        }
    }
    
    protected function _checkPostParams()
    {
        $this->requestTime = time();
        $this->visitMicroTime = $this->_getMillisecond();//会员访问时间(精确到毫秒)
    }
    /**
     * 处理接口返回信息
     */
    protected function _returnMsg($data, $echo = TRUE){
        $result = parent::_returnMsg($data);
        $responseTime = $this->_getMillisecond() - $this->visitMicroTime;//响应时间(毫秒)
        $addData = [
            'request_time'  => $this->requestTime,
            'return_time'   => time(),
            'method'        => $this->method ? $this->method : '',
            'return_params' => $result,
            'response_time' => $responseTime,
            'error'         => isset($data['errCode']) ? intval($data['errCode']) : 0,
            'errmsg'        => $this->errorArray ? json_encode($this->errorArray) : '',
            'show_time'     => date('Y-m-d H:i:s'),
        ];
        $apiLogId = db('apilog_timer')->insertGetId($addData);
        exit();
    }
}    