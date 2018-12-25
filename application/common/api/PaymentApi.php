<?php
namespace app\common\api;

/**
 * 支付接口
 * @author xiaojun
 */
class PaymentApi
{
    var $payments;  //支付方式列表
    var $config;    //支付方式配置信息
    var $payCode;
    var $storeId;
    var $error;
    var $apiHost;
    public function __construct($storeId = 0, $payCode = '', $option = []){
        $this->storeId = $storeId;
        $this->payments = [
            'wechat_native' => [
                'code' => 'wechat_native',
                'name' => '微信扫码支付',
                'desc' => '用户打开"微信扫一扫“，扫描商户的二维码后完成支付',
                'display_type' => 1,//支付显示客户端1:PC端 2微信小程序端 3APP客户端
                'config' => [
                    'app_id' => [
                        'desc' => '微信支付分配的公众账号ID（企业号corpid即为此appId）',
                    ],
                    'mch_id' => [
                        'desc' => '微信支付分配的商户号',
                    ],
                    'mch_key' => [
                        'name' => '微信支付密钥',
                        'desc' => '微信商户平台(pay.weixin.qq.com)-->账户设置-->API安全-->密钥设置',
                    ],
                ],
            ],
            'alipay_page' => [
                'code' => 'alipay_page',
                'name' => '支付宝支付',
                'display_type' => 1,
                'desc' => '用户通过支付宝PC收银台完成支付，交易款项即时给到商户支付宝账户。（用户交易款项即时到账，交易订单三个月内可退款，提供退款、清结算、对账等配套服务。）',
                'config' => [
                    'app_id' => [
                        'desc' => '支付宝应用APPID',
                    ],
                    'alipay_public_key' => [
                        'name' => '支付宝公钥',
                        'desc' => '查看地址：https://openhome.alipay.com/platform/keyManage.htm 对应APPID下的支付宝公钥。',
                        'type' => 'textarea',
                    ],
                    'merchant_private_key' => [
                        'name' => '商户密钥',
                        'desc' => '支付宝公钥对应的支付宝商户密钥',
                        'type' => 'textarea',
                    ],
                ],
            ],
        ];
        if ($option) {
            $this->config = $option;
        }else{
            $payment = db('payment')->where(['is_del' => 0, 'status' => 1, 'store_id' => $storeId, 'pay_code' => $payCode])->find();
            $this->config = $payment && $payment['config_json'] ? json_decode($payment['config_json'], TRUE): [];
        }
        $this->payCode = strtolower($payCode);
        $this->apiHost = 'http://zxjapi.zhidekan.me/';
    }
    /**
     * 初始化支付数据
     * @param array $order
     * @return array
     */
    public function init($order = [])
    {
        if(!$order){
            $this->error = '订单信息不能为空';
            return FALSE;
        }
        $outTradeNo = trim($order['order_sn']);
        if(!$outTradeNo){
            $this->error = '订单编号不能为空';
            return FALSE;
        }
        $tradeType = '';
        switch ($this->payCode) {
            case 'wechat_app'://微信APP支付
                $tradeType = 'APP';
            case 'wechat_applet'://微信小程序支付
                $tradeType = $tradeType ? $tradeType : 'JSAPI';
            case 'wechat_native'://微信扫码支付
                $tradeType = $tradeType ? $tradeType : 'NATIVE';
            case 'wechat_js'://微信公众号支付
                $this->config['notify_url'] = $this->apiHost.'pay/wechat/code/'.$this->payCode;//异步通知地址
                $tradeType = isset($tradeType) && $tradeType ? $tradeType : 'JSAPI';
                $wechatApi = new \app\common\api\WechatPayApi($order['store_id'], $this->payCode, $this->config);
                $result = $wechatApi->wechatUnifiedOrder($order, $tradeType);
                if ($result === FALSE) {
                    $this->error = $wechatApi->error;
                    return FALSE;
                }else{
                    return $result;
                }
                break;
            case 'alipay_page'://支付宝网页支付
                $this->config['return_url'] = $this->apiHost.'pay/order/sn/'.$outTradeNo;//异步通知地址
                $this->config['notify_url'] = $this->apiHost.'pay/alipay/code/'.$this->payCode;//异步通知地址
                $alipayApi = new \app\common\api\AlipayPayApi($order['store_id'], $this->payCode, $this->config);
                $result = $alipayApi->pagePay($order, "GET");
                if ($result) {
                    return $result;
                }else{
                    $this->error = $this->error ? $this->error :'支付请求异常';
                    return FALSE;
                }
                break;
            default:
                $this->error = '支付方式错误';
                return FALSE;
                break;
        }
    }
}