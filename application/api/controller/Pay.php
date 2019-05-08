<?php
namespace app\api\controller;
use app\common\service\PushBase;
use think\facade\Log;

class Pay extends ApiBase
{
    public $payCode;
    public $params;
    public function __construct(){
        parent::__construct();
        $this->params = $this->request->param();
        $action = strtolower($this->request->action());
//         if ($action != 'order') {
//             $this->_checkPostParams();
//         }
        $this->payCode = isset($this->params['code']) ? $this->params['code'] : '';
    }
    public function wechat()
    {
        $this->postParams= [
            'out_trade_no' => '20190508150050509848884608029',
            'transaction_id' => '11',
        ];
        //         $orderSn = '20190117001642974849330125579';
        $orderSn = isset($this->postParams['out_trade_no']) ? $this->postParams['out_trade_no'] : '';
        $openid = isset($this->postParams['openid']) ? $this->postParams['openid'] : '';
        if ($orderSn) {
            $order = db('order')->where(['order_sn' => $orderSn])->find();
            if (!$order) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单号不存在', 'order_sn' => $orderSn]);
            }
            if (!$this->payCode) {
                $this->payCode = $order['pay_code'] ? $order['pay_code'] : $this->payCode;
            }
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单号为空']);
        }
        $result = 1;
        //获取通知的数据
        $result = $this->_wechatResXml($order['store_id'], $this->payCode, $this->postParams);
        if ($result && $order) {
            if ($order['pay_status'] > 0) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单已支付', 'order_sn' => $orderSn]);
            }
            if ($order['order_type'] == 2){
                $user = db('user_data')->where(['udata_id' => $order['udata_id']])->find();
            }else{
                $user = db('user')->where(['user_id' => $order['user_id']])->find();
            }
            $orderModel = new \app\common\model\Order();
            $paidAmount = isset($this->postParams['total_fee']) ? intval($this->postParams['total_fee'])/100 : 0;
            $extra = [
                'pay_sn'        => $this->postParams['transaction_id'],
                'paid_amount'   => $paidAmount,
                'pay_code'      => $this->payCode,
                'remark'        => '支付完成,等待商家发货',
            ];
            $result = $orderModel->orderPay($orderSn, $user, $extra);
            pre($orderModel->error);
            if ($result === FALSE) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '支付错误:'.$orderModel->error, 'order_sn' => $orderSn]);
            }else{
                $push = new \app\common\service\PushBase();
                $data = [
                    'type'          => 'order',
                    'orderSn'       => $orderSn,
                    'paidAmount'    => $paidAmount,
                ];
                //发送给店铺下所有管理用户
                $push->sendToGroup('store'.$order['store_id'], json_encode($data));
                
                $this->activity([
                    'order_sn' => $orderSn,
                    'user' => $user,
                    'extra' => $extra,
                ]);
                /* //活动商品支付支付后回款处理
                 Hook::add('after_pay', PayNotify::class);
                 Hook::listen('after_pay', compact('orderSn','user','extra')); */
                
                $this->_returnMsg(['msg' => '支付成功', 'order_sn' => $orderSn]);
            }
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单不存在/请求错误', 'order_sn' => $orderSn]);
        }
    }
    
    public function alipay()
    {
        $orderSn = isset($this->postParams['out_trade_no']) ? $this->postParams['out_trade_no'] : '';
        if ($orderSn) {
            //1、商户需要验证该通知数据中的out_trade_no是否为商户系统中创建的订单号，
            $order = db('order')->where(['order_sn' => $orderSn])->find();
            if (!$order) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单号不存在', 'order_sn' => $orderSn]);
            }
            if (!$this->payCode) {
                $this->payCode = $order['pay_code'] ? $order['pay_code'] : $this->payCode;
            }
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单号为空']);
        }
        $alipayApi = new \app\common\api\AlipayPayApi($order['store_id'], $this->payCode);
        $result = $alipayApi->checkSign($this->postParams);
        if($result) {//验证成功
            if ($order['pay_status'] > 0) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单已支付', 'order_sn' => $orderSn]);
            }
            $user = db('user')->where(['user_id' => $order['user_id']])->find();
            $paidAmount = isset($this->postParams['total_amount']) ? floatval($this->postParams['total_amount']) : 0;
            //2、判断total_amount是否确实为该订单的实际金额（即商户订单创建时的金额），
            if ($paidAmount < $order['real_amount']) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '支付宝支付金额与订单应付金额不一致', 'order_sn' => $orderSn]);
            }
            $orderModel = new \app\common\model\Order();
            //交易状态
            $tradeStatus = $this->postParams['trade_status'];
            if(in_array($tradeStatus, ['TRADE_FINISHED', 'TRADE_SUCCESS'])) {
                $extra = [
                    'pay_sn'        => $this->postParams['trade_no'],//支付宝交易号
                    'paid_amount'   => $paidAmount,
                    'pay_code'      => $this->payCode,
                    'remark'        => '支付完成,等待商家发货',
                ];
                $result = $orderModel->orderPay($orderSn, $user, $extra);
                if ($result === FALSE) {
                    $this->_returnMsg(['errCode' => 1, 'errMsg' => '支付错误:'.$orderModel->error, 'order_sn' => $orderSn]);
                }else{
                    $push = new \app\common\service\PushBase();
                    $data = [
                        'type'          => 'order',
                        'orderSn'       => $orderSn,
                        'paidAmount'    => $paidAmount,
                    ];
                    //发送给店铺下所有管理用户
                    $push->sendToGroup('store'.$order['store_id'], json_encode($data));
                    $this->_returnMsg(['msg' => '支付成功', 'order_sn' => $orderSn]);
                }
                //判断该笔订单是否在商户网站中已经做过处理
                //如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
                //请务必判断请求时的total_amount与通知时获取的total_fee为一致的
                //如果有做过处理，不执行商户的业务程序
                //注意： TRADE_FINISHED退款日期超过可退款期限后（如三个月可退款），支付宝系统发送该交易状态通知
                //TRADE_SUCCESS付款完成后，支付宝系统发送该交易状态通知
            }
            //——请根据您的业务逻辑来编写程序（以上代码仅作参考）——
            echo "success";	//请不要修改或删除
        }
        if ($result) {
            if ($order['pay_status'] > 0) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单已支付', 'order_sn' => $orderSn]);
            }
            $user = db('user')->where(['user_id' => $order['user_id']])->find();
            $orderModel = new \app\common\model\Order();
            $paidAmount = isset($this->postParams['total_fee']) ? intval($this->postParams['total_fee'])/100 : 0;
            $extra = [
                'pay_sn'        => $this->postParams['transaction_id'],
                'paid_amount'   => $paidAmount,
                'pay_code'      => $this->payCode,
                'remark'        => '支付完成,等待商家发货',
            ];
            $result = $orderModel->orderPay($orderSn, $user, $extra);
            if ($result === FALSE) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '支付错误:'.$orderModel->error, 'order_sn' => $orderSn]);
            }else{
                $push = new \app\common\service\PushBase();
                $data = [
                    'type'          => 'order',
                    'orderSn'       => $orderSn,
                    'paidAmount'    => $paidAmount,
                ];
                //发送给店铺下所有管理用户
                $push->sendToGroup('store'.$order['store_id'], json_encode($data));
                $this->_returnMsg(['msg' => '支付成功', 'order_sn' => $orderSn]);
            }
        }else{
            //验证失败
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '签名验证失败', 'order_sn' => $orderSn]);
        }
    }
    protected function _checkPostParams()
    {
        $this->requestTime = time();
        $this->visitMicroTime = $this->_getMillisecond();//会员访问时间(精确到毫秒)
        $action = strtolower($this->request->action());
        switch ($action) {
            case 'alipay':
                $this->postParams = $this->request->post();
                break;
            case 'wechat':
                $notify = isset($GLOBALS["HTTP_RAW_POST_DATA"]) ? $GLOBALS["HTTP_RAW_POST_DATA"] : '';
                if (!$notify) {
                    $notify = file_get_contents('php://input');
                }
                if (!$notify) {
                    $notify = $_POST;
                }
                if (!$notify) {
                    $this->_returnMsg(['errCode' => 1, 'errMsg' => '请求参数异常1', 'params' => $notify]);
                }
                //将XML转为array
                //禁止引用外部xml实体
                libxml_disable_entity_loader(true);
                $this->postParams = xml_to_array($notify);
                break;
            default:
                ;
                break;
        }
        if (!$this->postParams) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请求参数异常2', 'params' => $this->postParams]);
        }
    }
    /**
     * 请确保项目文件有可写权限，不然打印不了日志。
     */
    private function writeLog($text) {
        // $text=iconv("GBK", "UTF-8//IGNORE", $text);
        //$text = characet ( $text );
        $dir = env('runtime_path').'log/'.date("Ym");
        $filename = $dir.'/wechat_'.(date('d')).'.log';
        if (!file_exists($dir)) {
            mkdir($dir);
            chmod($dir,0777);
        }
        //判断文件是否存在不存在则创建
        if (!file_exists($filename)) {
            $myfile = fopen($filename, "w") or die("Unable to open file!");
        }
        file_put_contents ($filename, date ( "Y-m-d H:i:s" ) . "  " . $text . "\r\n", FILE_APPEND );
    }
    /**
     * 处理返回参数
     */
    protected function _returnMsg($data, $echo = FALSE){
        $result = parent::_returnMsg($data, $echo);
        $responseTime = $this->_getMillisecond() - $this->visitMicroTime;//响应时间(毫秒)
        $error = isset($data['errMsg'])   ? trim($data['errMsg']) : '';
        $method = $this->request->action();
        $addData = [
            'request_time'  => $this->requestTime,
            'return_time'   => time(),
            'method'        => trim($method),
            'request_params'=> is_array($this->postParams) ? json_encode($this->postParams) : trim($this->postParams),
            'return_params' => $result,
            'response_time' => $responseTime,
            'error'         => isset($data['errCode'])  ? intval($data['errCode']) : 0,
            'error_msg'     => $error,
            'order_sn'      => isset($data['order_sn']) ? trim($data['order_sn']) : '',
            'pay_code'      => trim($this->payCode),
        ];
        $apiLogId = db('apilog_pay')->insertGetId($addData);
        if (isset($data['errCode']) && $data['errCode'] > 0) {
            echo $this->_wechatReturn("FAIL", $error);
        }else{
            echo $this->_wechatReturn("SUCCESS");
        }
        exit();
    }
    /**
     * 处理微信异步通知的xml
     * @param string $xml
     * @return array
     */
    private function _wechatResXml($storeId = 0, $payCode, $result)
    {
        if($result['return_code'] != 'SUCCESS'){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $result['return_msg']]);
        }
        $wechatApi = new \app\common\api\WechatPayApi($storeId, $payCode);
        if (!$wechatApi->config) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '微信配置错误', 'order_sn' => $result['out_trade_no']]);
        }
        $sign = $wechatApi->_wechatGetSign($result);
        $error = isset($result['sign']) && ($result['sign'] == $sign) ? 0 : 1;
        if ($error) {
            $this->_returnMsg(['errCode' => $error, 'errMsg' => '签名错误: '.'[sign:'.$sign.'] [notify_sign:'.$result['sign'].']']);
        }
        return $result;
    }
    /**
     * 返回结果给微信
     * @param string $result
     * @return string
     */
    private function _wechatReturn($result = "SUCCESS", $error = ''){
        if($result == "SUCCESS"){
            $text = "OK";
        }else{
            $text = $error ? $error : "价格核对失败";
        }
        $return = "<xml>
        <return_code><![CDATA[{$result}]]></return_code>
        <return_msg><![CDATA[{$text}]]></return_msg>
        </xml>";
        return $return;
    }
    
    
    public function activity($param)
    {
        $orderSn = isset($param['order_sn']) ? trim($param['order_sn']) : '';
        $model = new \app\common\model\Order();
        $user = $param['user'];
        $detail = $model->getOrderDetail($orderSn, $user, TRUE, TRUE);
        if ($detail === false) {
            Log::error('退款失败，原因【' . $model->error . '】,参数：', $param);
            return false;
        }
        $order = $detail['order'];
        $return = $this->_checkActivity($order,$user);
        $returnType = $return['return_type'];
        if ($returnType <= 0) {
            Log::error('当前订单不允许退款，原因【' . $model->error . '】,参数：', $param);
            return false;
        }
        $remark = $return['return_name'];
        $refundAmount = $return['return_amount'];
        $refundFlag = $return['return_flag'];
        if ($refundAmount > 0 && $refundFlag) {
            $serviceModel = new \app\common\model\OrderService();
            $result = $serviceModel->servuceActivityRefund($order, $refundAmount, $remark);
            if ($result === FALSE) {
                Log::error('当前订单不允许退款，原因【' . $serviceModel->error . '】,参数：', $param);
                return false;
            } else {
                Log::info('退款成功', $param);
                return true;
            }
        }
    }
    
    
    private function _checkActivity($order,$user)
    {
        $actInfo=db('activity')->where([
            'is_del'=>0,
            'status'=>1,
            'store_id'=>$user['factory_id'],
            'start_time'=>['<=',time()],
            'end_time'=>['>=',time()],
        ])->find();
        if (empty($actInfo)) {
            Log::error('当前没有可用活动');
            return [
                'return_type' => -1,
                'return_name' => '当前没有可用活动',
                'return_amount' => 0,
                'return_flag'   => false,
            ];
        }
        $goodsId=explode(',',$actInfo['goods_id']);
        $total = $actInfo['activity_total'];
        $activityPrice = $actInfo['activity_price'];
        $startTime = $actInfo['start_time'];//活动开始时间
        $entTime = $actInfo['end_time'];//活动结束书剑
        $returnType = $returnAmount = 0;
        $name = '';
        $num = $actInfo['free_num'];
        $flag = FALSE;
        //1.计算订单下单时间是否在活动时间范围内
        if ($order['order_status'] == 1 && $order['pay_status'] == 1 && $order['close_refund_status'] == 0 && $order['pay_time'] >= $startTime && $order['pay_time'] <= $entTime) {
            //         if ($order['order_status'] == 1 && $order['pay_status'] == 1) {
            //2.计算当前订单的实际支付顺序 是否逢九订单
            $where=[
                ['O.order_type','=',2],
                ['O.pay_status','=',1],
                ['O.pay_time','>=',$startTime],
                ['O.pay_time','<=',$entTime],
                ['OS.goods_id','in',$goodsId],
            ];
            $count = db('Order')->alias('O')->join('order_sku OS','O.order_sn=OS.order_sn')->where($where)->count();
            //$count = Order::a->where($where)->order('order_id ASC')->count();
            if ($count <= $total) {
                if ($num>=0 && $count % 10 == $num) {
                    $returnType = 1;//逢九免单
                    $name = '前'.$total.'位,按实际支付顺序,逢九免单';
                    $returnAmount = $order['paid_amount'];
                    $flag = TRUE;
                } else {
                    $returnType = 2;//前2019位享受促销价
                    $name = '前'.$total.'位,享受促销价格:' . $activityPrice . '元';
                    $returnAmount = $order['paid_amount'] >= $activityPrice ? ($order['paid_amount'] - $activityPrice) : $order['paid_amount'];
                    $flag = TRUE;
                }
            }
        }
        return [
            'return_type' => $returnType,
            'return_name' => $name,
            'return_amount' => $returnAmount,
            'return_flag'   => $flag,
        ];
    }
}    