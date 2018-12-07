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
    }
    /**
     * 每分钟执行定时器
     */
    public function minute()
    {
        $thisTime = time();
        //获取系统默认配置
        $default = $this->getSystemConfig('system_default');
        $defaultConfig = $default['config_value'];
        
        $storeModel = new \app\common\model\Store();
        $orderModel = new \app\common\model\Order();
        //获取厂商时间配置
        $where = ['store_type' => STORE_FACTORY, 'is_del' => 0];
        $lists = $storeModel->where($where)->field('store_id, config_json')->select();
        $factorys = [];
        if ($lists) {
            $cancelMap = $finishMap = [];
            foreach ($lists as $key => $value) {
                $factoryId = $value['store_id'];
                $config = $value['config_json'] ? json_decode($value['config_json'], 1) : [];
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
                pre($config, 1);
                //退货退款时间(天数),支付成功后超过配置时间则不允许退货退款
                $orderReturnDay = $config && isset($config['order_return_day']) ? $config['order_return_day'] : 0;
                if ($orderReturnDay > 0) {
                    $orderReturnDay = 0;
                    $finishMap[] = '(store_id = '.$factoryId.' AND pay_time <= '. ($thisTime - ($orderReturnDay * 24 * 60 * 60)).')';
                }
            }
            if ($cancelMap) {
                $cancelSql = 'order_status != 0 AND pay_status = 0';
                $cancelSql .= ' AND ('.implode(' OR ', $cancelMap).')';
                $orders = $orderModel->where($cancelSql)->select();
                if ($orders) {
                    $remark = '订单超时未付款，系统自动取消订单';
                    //订单批量取消
                    foreach ($orders as $key => $value) {
                        $result = $orderModel->orderCancel($value['order_sn'], ['user_id' => 0, 'nickname' => '系统'], $remark);
                        if ($result === FALSE) {
                            $this->errorArray[] = [
                                'action'    => $remark,
                                'order_sn'  => $value['order_sn'],
                                'error'     => $orderModel->error,
                            ];
                        }
                    }
                }
            }
            if ($finishMap) {
                $finishSql = 'order_status != 0 AND pay_status = 1 AND pay_time > 0';
                $finishSql .= ' AND ('.implode(' OR ', $finishMap).')';
                $orders = $orderModel->where($finishSql)->select();
                if ($orders) {
                    $remark = '系统自动关闭退货退款功能';
                    //订单批量控制是否可退还并将不可退还的订单佣金改为入账状态
                    foreach ($orders as $key => $value) {
                        $result = $orderModel->orderCloseReturn($value, ['user_id' => 0, 'nickname' => '系统'], $remark);
                        if ($result === FALSE) {
                            $this->errorArray[] = [
                                'action'    => $remark,
                                'order_sn'  => $value['order_sn'],
                                'error'     => $orderModel->error,
                            ];
                        }
                    }
                }
            }
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
        ];
        $apiLogId = db('apilog_timer')->insertGetId($addData);
        exit();
    }
}    