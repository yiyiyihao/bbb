<?php
namespace app\common\api;

/**
 * 微信接口
 * @author xiaojun
 */
class WechatPayApi
{
    var $config;
    var $error;
    var $storeId;
    var $templateCodes;
    public function __construct($storeId, $payCode = '', $option = []){
        if (!$storeId) {
            $this->error = lang('paran_error');
            return FALSE;
        }
        if ($option) {
            $this->config = $option;
        }else{
            $payment = db('payment')->where(['is_del' => 0, 'status' => 1, 'store_id' => $storeId, 'pay_code' => $payCode])->find();
            $this->config = $payment && $payment['config_json'] ? json_decode($payment['config_json'], TRUE): [];
        }
        $this->rsaPrivateKey = isset($this->config['merchant_private_key']) ? trim($this->config['merchant_private_key']) : '';
        if (!$this->config['mch_key']) {
            $this->error = '私钥配置错误，请检查配置';
            return FALSE;
        }
        $this->payCode = strtolower($payCode);
        $this->storeId = $storeId;
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
            $params['product_id'] = isset($order['product_id']) ? trim($order['product_id']): 0;
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
    }
    /**
     * 订单退款
     * @param array $order 退款订单信息
     * @param array $service 售后信息
     * @return boolean
     */
    public function tradeRefund($order = [], $service = [])
    {
        $params = [
            'appid'     => trim($this->config['app_id']),
            'mch_id'    => trim($this->config['mch_id']),
            'nonce_str' => get_nonce_str(32),
            'out_trade_no'      => trim($order['order_sn']),
            'transaction_id'    => trim($order['pay_sn']),
            'spbill_create_ip'  => $_SERVER['REMOTE_ADDR'],
            'total_fee'         => intval((100 * $order['paid_amount'])),
            'refund_fee'         => intval((100 * $service['refund_amount'])),
            'out_refund_no'     => $service['service_sn'],
        ];
        //订单信息
        $params['sign'] = $this->_wechatGetSign($params);
        // 数字签名
        $paramsXml = array_to_xml($params);
        $url = 'https://api.mch.weixin.qq.com/secapi/pay/refund';//退款接口地址
        $returnXml = $this->_wechatPostXmlCurl($paramsXml, $url, TRUE, TRUE);
        if ($returnXml === FALSE) {
            return FALSE;
        }
        $result = xml_to_array($returnXml);
        if ($result) {
            if (isset($result['return_code']) && $result['return_code'] == 'SUCCESS' && isset($result['result_code']) && $result['result_code'] == 'SUCCESS') {
                return TRUE;
            }else{
                $this->error = isset($result['err_code_des']) ? $result['err_code_des'] : $result['return_msg'];
                return FALSE;
            }
        }else{
            $this->error = $this->error ? $this->error :'支付请求异常';
            return FALSE;
        }
    }
    
    public function tradeRefundQuery($service = [])
    {
        $params = [
            'appid'     => trim($this->config['app_id']),
            'mch_id'    => trim($this->config['mch_id']),
            'nonce_str' => get_nonce_str(32),
            'out_trade_no'      => trim($service['order_sn']),
            'out_refund_no'     => $service['service_sn'],
        ];
        //订单信息
        $params['sign'] = $this->_wechatGetSign($params);
        // 数字签名
        $paramsXml = array_to_xml($params);
        $url = 'https://api.mch.weixin.qq.com/pay/refundquery';//退款接口地址
        $returnXml = $this->_wechatPostXmlCurl($paramsXml, $url, TRUE, TRUE);
        if ($returnXml === FALSE) {
            return FALSE;
        }
        $result = xml_to_array($returnXml);
        if ($result) {
            if (isset($result['return_code']) && $result['return_code'] == 'SUCCESS' && isset($result['result_code']) && $result['result_code'] == 'SUCCESS') {
                return $result;
            }else{
                $this->error = isset($result['err_code_des']) ? $result['err_code_des'] : $result['return_msg'];
                return FALSE;
            }
        }else{
            $this->error = $this->error ? $this->error :'支付请求异常';
            return FALSE;
        }
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
    private function _wechatPostXmlCurl($xml, $url, $second = 120, $cert = FALSE)
    {
        //初始化curl
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_TIMEOUT, $second);
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
        if ($cert) {
            $sslcert = dirname(getcwd()).'/public/certs/'.$this->storeId.'/'.$this->payCode.'_apiclient_cert.pem';
            $sslkey = dirname(getcwd()).'/public/certs/'.$this->storeId.'/'.$this->payCode.'_apiclient_key.pem';
            if (!file_exists($sslcert) || !file_exists($sslkey)) {
                $this->error = '未上传微信支付证书文件(apiclient_cert.pem和apiclient_key.pem)';
                return FALSE;
            }
            curl_setopt($ch, CURLOPT_SSLCERT, $sslcert);
            curl_setopt($ch, CURLOPT_SSLKEY, $sslkey);
        }
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
            }elseif ($errno == 28) {
                $this->error = '连接超时，请稍后重试';
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