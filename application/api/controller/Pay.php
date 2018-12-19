<?php
namespace app\api\controller;
use app\common\service\PushBase;
class Pay extends ApiBase
{
    public $payCode;
    public function __construct(){
        parent::__construct();
        $this->_checkPostParams();
        $params = $this->request->param();
        $this->payCode = isset($params['code']) ? $params['code'] : '';
    }
    public function wechat()
    {
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
        //获取通知的数据
        $result = $this->_wechatResXml($order['store_id'], $this->payCode, $this->postParams);
        if ($result && $order) {
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
                $push = new PushBase;
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
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单不存在/请求错误', 'order_sn' => $orderSn]);
        }
    }
    protected function _checkPostParams()
    {
        $this->requestTime = time();
        $this->visitMicroTime = $this->_getMillisecond();//会员访问时间(精确到毫秒)
        $notify = isset($GLOBALS["HTTP_RAW_POST_DATA"]) ? $GLOBALS["HTTP_RAW_POST_DATA"] : '';
        if (!$notify) {
            $notify = file_get_contents('php://input');
        }
        if (!$notify) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请求参数异常', 'params' => $notify]);
        }
//         $notify = '<xml><appid><![CDATA[wx06b088dbc933d613]]></appid>
// <bank_type><![CDATA[CFT]]></bank_type>
// <cash_fee><![CDATA[1]]></cash_fee>
// <fee_type><![CDATA[CNY]]></fee_type>
// <is_subscribe><![CDATA[N]]></is_subscribe>
// <mch_id><![CDATA[1520990381]]></mch_id>
// <nonce_str><![CDATA[Co9QiWUgfdZYNAJWXYld6k3i2OQjDOQn]]></nonce_str>
// <openid><![CDATA[ozO5o5F0XQTBGBHhS76lzlI5E8Bg]]></openid>
// <out_trade_no><![CDATA[20181217155356521005891782895]]></out_trade_no>
// <result_code><![CDATA[SUCCESS]]></result_code>
// <return_code><![CDATA[SUCCESS]]></return_code>
// <sign><![CDATA[07CF16B5151A01FFBCE58AF96CE8B000]]></sign>
// <time_end><![CDATA[20181217161447]]></time_end>
// <total_fee>1</total_fee>
// <trade_type><![CDATA[NATIVE]]></trade_type>
// <transaction_id><![CDATA[4200000219201812172231676123]]></transaction_id>
// </xml>';
        //将XML转为array
        //禁止引用外部xml实体
        libxml_disable_entity_loader(true);
        $this->postParams = xml_to_array($notify);
        if (!$this->postParams) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请求参数异常', 'params' => $this->postParams]);
        }
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
        $paymentService = new \app\common\api\PaymentApi($storeId, $payCode);
        $sign = $paymentService->_wechatGetSign($result);
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
}    