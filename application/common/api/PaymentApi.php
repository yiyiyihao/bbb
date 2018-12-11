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
                        'desc' => '微信商户平台(pay.weixin.qq.com)-->账户设置-->API安全-->密钥设置',
                    ],
                ],
            ],
            'wechat_applet' => [
                'code' => 'wechat_applet',
                'name' => '微信小程序支付',
                'display_type' => 2,
                'desc' => '用户在微信小程序中使用微信支付的场景',
                'config' => [
                    'app_id' => [
                        'desc' => '微信分配的小程序ID',
                    ],
                    'mch_id' => [
                        'desc' => '微信支付分配的商户号',
                    ],
                    'mch_key' => [
                        'desc' => '微信商户平台(pay.weixin.qq.com)-->账户设置-->API安全-->密钥设置',
                    ],
                ],
            ],
//             'wechat_js' => [
//                 'code' => 'wechat_js',
//                 'name' => '微信公众号支付',
//                 'desc' => '用户通过微信扫码、关注公众号等方式进入商家H5页面，并在微信内调用JSSDK完成支付',
//                 'display_type' => 3,
//                 'config' => [
//                     'app_id' => [
//                         'desc' => '微信支付分配的公众账号ID',
//                     ],
//                     'mch_id' => [
//                         'desc' => '微信支付分配的商户号',
//                     ],
//                     'mch_key' => [
//                         'desc' => '微信商户平台(pay.weixin.qq.com)-->账户设置-->API安全-->密钥设置',
//                     ],
//                 ],
//             ],
//             'wechat_app' => [
//                 'code' => 'wechat_app',
//                 'name' => '微信APP支付',
//                 'desc' => '商户APP中集成微信SDK，用户点击后跳转到微信内完成支付',
//                 'display_type' => 3,
//                 'config' => [
//                     'app_id' => [
//                         'desc' => '微信APP支付分配的APPID',
//                     ],
//                     'mch_id' => [
//                         'desc' => '微信APP支付分配的商户号',
//                     ],
//                     'mch_key' => [
//                         'desc' => '微信商户平台(pay.weixin.qq.com)-->账户设置-->API安全-->密钥设置',
//                     ],
//                 ],
//             ],
        ];
        if ($option) {
            $this->config = $option;
        }else{
            $payment = db('payment')->where(['is_del' => 0, 'status' => 1, 'store_id' => $storeId, 'pay_code' => $payCode])->find();
            $this->config = $payment && $payment['config_json'] ? json_decode($payment['config_json'], TRUE): [];
        }
        $this->payCode = strtolower($payCode);
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
        $tradeType = '';
        switch ($this->payCode) {
            case 'wechat_app'://微信APP支付
                $tradeType = 'APP';
            case 'wechat_applet'://微信小程序支付
                $tradeType = $tradeType ? $tradeType : 'JSAPI';
            case 'wechat_native'://微信扫码支付
                $tradeType = $tradeType ? $tradeType : 'NATIVE';
            case 'wechat_js'://微信公众号支付
                $this->config['notify_url'] = 'http://'.$_SERVER['HTTP_HOST'].'/api/pay/wechat/code/'.$this->payCode;//异步通知地址
                $tradeType = isset($tradeType) && $tradeType ? $tradeType : 'JSAPI';
                $result = $this->wechatUnifiedOrder($order, $tradeType);
                if ($result) {
                    if (isset($result['return_code']) && $result['return_code'] == 'SUCCESS' && isset($result['result_code']) && $result['result_code'] == 'SUCCESS') {
                        if ($tradeType == 'JSAPI') {
                            $jsApiData = [
                                'appId'     => trim($this->config['app_id']),
                                'timeStamp' => strval(time()),
                                'nonceStr'  => strval(get_nonce_str(32)),
                                'package'   => 'prepay_id='.$result['prepay_id'],
                                'signType'  => 'MD5',
                            ];
                            $jsApiData['paySign'] = $this->_wechatGetSign($jsApiData, trim($this->config['mch_key']));
                            return $jsApiData;
                        }elseif ($tradeType == 'APP'){
                            $jsApiData = [
                                'appid'     => trim($this->config['app_id']),
                                'partnerid' => trim($this->config['mch_id']),
                                'prepayid'  => trim($result['prepay_id']),
                                'package'   => 'Sign=WXPay',
                                'noncestr'  => strval(get_nonce_str(32, 3)),
                                'timestamp' => strval(time()),
                            ];
                            $jsApiData['sign'] = $this->_wechatGetSign($jsApiData, trim($this->config['mch_key']));
                            return $jsApiData;
                        }else{
                            return $result;
                        }
                    }else{
                        $this->error = isset($result['err_code_des']) ? $result['err_code_des'] : $result['return_msg'];
                        return FALSE;
                    }
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
    /**
     * 微信统一下单功能
     * @param array $order      订单信息
     * @param string $tradeType 交易类型
     * @return array
     */
    public function wechatUnifiedOrder($order = [], $tradeType = 'JSAPI') {
        $params = [
            'appid'     => trim($this->config['app_id']),
            'body'      => isset($order['subject']) ? trim($order['subject']) : '产品购买',
            'mch_id'    => trim($this->config['mch_id']),
            'nonce_str' => get_nonce_str(32),
            'notify_url'=> trim($this->config['notify_url']),
            'out_trade_no'      => trim($order['order_sn']),
            'spbill_create_ip'  => $_SERVER['REMOTE_ADDR'],
            'trade_type'        => $tradeType,
            'total_fee'         => intval((100 * $order['real_amount'])),
        ];
        if ($tradeType == 'JSAPI') {
            $params['openid'] = isset($order['openid']) ? trim($order['openid']): '';
            if (!$params['openid']) {
                $this->error = 'openid缺失';
                return FALSE;
            }
        }elseif ($tradeType == 'NATIVE'){
            $params['product_id'] = isset($order['product_id']) ? intval($order['product_id']): 0;
            if (!$params['product_id']) {
                $this->error = '产品ID(product_id)缺失';
                return FALSE;
            }
        }
        //订单信息
        $params['sign'] = $this->_wechatGetSign($params);
        // 数字签名
        $paramsXml = array_to_xml($params);
        $url = 'https://api.mch.weixin.qq.com/pay/unifiedorder';//统一下单接口地址
        $returnXml = $this->_wechatPostXmlCurl($paramsXml, $url, true);
        if ($returnXml === FALSE) {
            return FALSE;
        }
        $result = xml_to_array($returnXml);
        return $result;
    }
    
    /**
     * 生成签名
     * @return 签名，本函数不覆盖sign成员变量，如要设置签名需要调用SetSign方法赋值
     */
    public function _wechatGetSign($data = [])
    {
        //签名步骤一：按字典序排序参数
        ksort($data);
        $string = to_url_params($data);
        //签名步骤二：在string后加入KEY
        $string = $string . "&key=".trim($this->config['mch_key']);
        //签名步骤三：MD5加密
        $string = md5($string);
        //签名步骤四：所有字符转为大写
        $result = strtoupper($string);
        return $result;
    }
    /*
     *与微信通讯获得二维码地址信息，必须以xml格式
     */
    private function _wechatPostXmlCurl($xml, $url, $second = 60)
    {
        //初始化curl
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_TIMEOUT, $second);
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
        
//         $code = $this->payCode == 'wechat_app' ? $this->payCode : 'wechat_js';
//         $sslcert = dirname(getcwd()).'/biapp/common/cert/'.$code.'_apiclient_cert.pem';
//         $sslkey = dirname(getcwd()).'/biapp/common/cert/'.$code.'_apiclient_key.pem';
        $sslcert = dirname(getcwd()).'/public/certs/'.$this->storeId.'/'.$this->payCode.'_apiclient_cert.pem';
        $sslkey = dirname(getcwd()).'/public/certs/'.$this->storeId.'/'.$this->payCode.'_apiclient_key.pem';
        
        curl_setopt($ch, CURLOPT_SSLCERT, $sslcert);
        curl_setopt($ch, CURLOPT_SSLKEY, $sslkey);
        
        //设置header
        curl_setopt($ch, CURLOPT_HEADER, FALSE);
        //要求结果为字符串且输出到屏幕上
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
        //post提交方式
        curl_setopt($ch, CURLOPT_POST, TRUE);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $xml);
        //运行curl
        $data = curl_exec($ch);
        $errno = curl_errno($ch);
        $info  = curl_getinfo($ch);
        curl_close($ch);
        if ($errno > 0) {
            if ($errno == 58) {
                $this->error = 'CURL证书错误';
                return FALSE;
            }else{
                $this->error = 'CURL错误'.$errno;
                return FALSE;
            }
        }
        //返回结果
        return $data;
    }
}