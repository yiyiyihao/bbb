<?php
namespace app\common\api;

/**
 * 支付宝接口
 * @author xiaojun
 */
class AlipayPayApi
{
    public $error;
    protected $config;
    protected $gatewayUrl = 'https://openapi.alipay.com/gateway.do';
    protected $postCharset = "UTF-8";
    protected $signType = "RSA2";
    protected $rsaPrivateKeyFilePath = FALSE;
    protected $rsaPrivateKey;
    protected $alipayPublicKey;
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
        $this->alipayPublicKey = isset($this->config['alipay_public_key']) ? trim($this->config['alipay_public_key']) : '';
        if (!$this->rsaPrivateKey || !$this->alipayPublicKey) {
            $this->error = '私钥配置错误，请检查配置';
            return FALSE;
        }
        $this->payCode = strtolower($payCode);
    }
    public function pagePay($order = [], $httpmethod = "POST")
    {
        $totalAmount = floatval($order['real_amount']);
        $bizContent = [
            'product_code'  => 'FAST_INSTANT_TRADE_PAY',
            'body' => '',
            'subject'       => isset($order['subject']) ? trim($order['subject']) : '产品购买',
            'out_trade_no'  => trim($order['order_sn']),
            'total_amount'  => floatval($order['real_amount']),  //付款金额，必填(订单总金额，单位为元，精确到小数点后两位，取值范围[0.01,100000000])
        ];
        $bizContent = json_encode($bizContent,JSON_UNESCAPED_UNICODE);
//         $bizContent = '{"product_code":"FAST_INSTANT_TRADE_PAY","body":"","subject":"11","total_amount":"0.02","out_trade_no":"20181221171909100971243370754"}';
        $totalParams = [
            'biz_content'=> $bizContent,
            'app_id'    => trim($this->config['app_id']),
            'version'   => '1.0',
            'format'    => 'json',
            'sign_type' => $this->signType,
            'method'    => 'alipay.trade.page.pay',
            'timestamp' => date('Y-m-d H:i:s', time()),
//             'alipay_sdk' => 'alipay-sdk-php-20161101',
//             'terminal_type' => null,
//             'terminal_info' => null,
//             'prod_code' => null,
            'notify_url'=> trim($this->config['notify_url']),
            'return_url'=> trim($this->config['return_url']),
            'charset'   => $this->postCharset,
        ];
        //待签名字符串
        $preSignStr = $this->getSignContent($totalParams);
        //签名
        $totalParams["sign"] = $this->generateSign($totalParams, $this->signType);
        if ("GET" == strtoupper($httpmethod)) {
            //value做urlencode
            $preString = $this->getSignContentUrlencode($totalParams);
            //拼接GET请求串
            $requestUrl = $this->gatewayUrl."?".$preString;
            return $requestUrl;
        } else {
            //拼接表单字符串
            return $this->buildRequestForm($totalParams);
        }
    }
    /**
     * 验签方法
     * @param $arr 验签支付宝返回的信息，使用支付宝公钥。
     * @return boolean
     */
    public function checkSign($arr){
        $this->writeLog(json_encode($arr));
        $result = $this->rsaCheckV1($arr, $this->alipayPublicKey, $this->signType);
        return $result;
    }
    /** rsaCheckV1 & rsaCheckV2
     *  验证签名
     *  公钥是否是读取字符串还是读取文件，是根据初始化传入的值判断的。
     **/
    protected function rsaCheckV1($params, $rsaPublicKeyFilePath,$signType='RSA') {
        $sign = $params['sign'];
        $params['sign_type'] = null;
        $params['sign'] = null;
        return $this->verify($this->getSignContent($params), $sign, $rsaPublicKeyFilePath,$signType);
    }
    protected function rsaCheckV2($params, $rsaPublicKeyFilePath, $signType='RSA') {
        $sign = $params['sign'];
        $params['sign'] = null;
        return $this->verify($this->getSignContent($params), $sign, $rsaPublicKeyFilePath, $signType);
    }
    protected function verify($data, $sign, $rsaPublicKeyFilePath, $signType = 'RSA') {
        if (!$this->alipayPublicKey) {
            $this->error = '支付宝公钥不能为空';
            return FALSE;
        }
        if($this->checkEmpty($this->alipayPublicKey)){
            $pubKey= $this->alipayrsaPublicKey;
            $res = "-----BEGIN PUBLIC KEY-----\n" .
                wordwrap($pubKey, 64, "\n", true) .
                "\n-----END PUBLIC KEY-----";
        }else {
            //读取公钥文件
            $pubKey = file_get_contents($rsaPublicKeyFilePath);
            //转换为openssl格式密钥
            $res = openssl_get_publickey($pubKey);
        }
        if (!$res) {
            $this->error = '支付宝RSA公钥错误。请检查公钥格式是否正确';
            return FALSE;
        }
        //调用openssl内置方法验签，返回bool值
        if ("RSA2" == $signType) {
            $result = (bool)openssl_verify($data, base64_decode($sign), $res, OPENSSL_ALGO_SHA256);
        } else {
            $result = (bool)openssl_verify($data, base64_decode($sign), $res);
        }
        if(!$this->checkEmpty($this->alipayPublicKey)) {
            //释放资源
            openssl_free_key($res);
        }
        return $result;
    }
    /**
     * 建立请求，以表单HTML形式构造（默认）
     * @param $para_temp 请求参数数组
     * @return 提交表单HTML文本
     */
    protected function buildRequestForm($para_temp) {
        
        $sHtml = "<form id='alipaysubmit' name='alipaysubmit' action='".$this->gatewayUrl."?charset=".trim($this->postCharset)."' method='POST'>";
        while (list ($key, $val) = each ($para_temp)) {
            if (false === $this->checkEmpty($val)) {
                $val = $this->characet($val, $this->postCharset);
                $val = str_replace("'","&apos;",$val);
                //$val = str_replace("\"","&quot;",$val);
                $sHtml.= "<input type='hidden' name='".$key."' value='".$val."'/>";
            }
        }
        //submit按钮控件请不要含有name属性
        $sHtml = $sHtml."<input type='submit' value='ok' style='display:none;''></form>";
        $sHtml = $sHtml."<script>document.forms['alipaysubmit'].submit();</script>";
        return $sHtml;
    }
    protected function generateSign($params, $signType = "RSA") {
        return $this->alipaySign($this->getSignContent($params), $signType);
    }
    protected function getSignContent($params) {
        ksort($params);
        
        $stringToBeSigned = "";
        $i = 0;
        foreach ($params as $k => $v) {
            if (false ===  $this->checkEmpty($v) && "@" != substr($v, 0, 1)) {
                
                // 转换成目标字符集
                $v = $this->characet($v, 'UTF-8');
                
                if ($i == 0) {
                    $stringToBeSigned .= "$k" . "=" . "$v";
                } else {
                    $stringToBeSigned .= "&" . "$k" . "=" . "$v";
                }
                $i++;
            }
        }
        
        unset ($k, $v);
        return $stringToBeSigned;
    }
    
    //此方法对value做urlencode
    protected function getSignContentUrlencode($params) {
        ksort($params);
        
        $stringToBeSigned = "";
        $i = 0;
        foreach ($params as $k => $v) {
            if (false === $this->checkEmpty($v) && "@" != substr($v, 0, 1)) {
                
                // 转换成目标字符集
                $v = $this->characet($v, 'UTF-8');
                
                if ($i == 0) {
                    $stringToBeSigned .= "$k" . "=" . urlencode($v);
                } else {
                    $stringToBeSigned .= "&" . "$k" . "=" . urlencode($v);
                }
                $i++;
            }
        }
        
        unset ($k, $v);
        return $stringToBeSigned;
    }
    protected function alipaySign($data, $signType = "RSA") {
        if($this->checkEmpty($this->rsaPrivateKeyFilePath)){
            $priKey = $this->rsaPrivateKey;
            $res = "-----BEGIN RSA PRIVATE KEY-----\n" .
                wordwrap($priKey, 64, "\n", true) .
                "\n-----END RSA PRIVATE KEY-----";
        }else {
            $priKey = file_get_contents($this->rsaPrivateKeyFilePath);
            $res = openssl_get_privatekey($priKey);
        }
        if (!$res) {
            $this->error = '您使用的私钥格式错误，请检查RSA私钥配置';
            return FALSE;
        }
        if ("RSA2" == $signType) {
            openssl_sign($data, $sign, $res, OPENSSL_ALGO_SHA256);
        } else {
            openssl_sign($data, $sign, $res);
        }
        if(!$this->checkEmpty($this->rsaPrivateKeyFilePath)){
            openssl_free_key($res);
        }
        $sign = base64_encode($sign);
        return $sign;
    }
    /**
     * 校验 $value是否非空
     *  if not set ,return true;
     *    if is null , return true;
     **/
    protected function checkEmpty($value) {
        if (!isset($value)) return true;
        if ($value === null) return true;
        if (trim($value) === "") return true;
        return false;
    }
    /**
     * 转换字符集编码
     * @param $data
     * @param $targetCharset
     * @return string
     */
    private function characet($data, $targetCharset) {
        
        if (!empty($data)) {
            $fileType = 'UTF-8';
            if (strcasecmp($fileType, $targetCharset) != 0) {
                $data = mb_convert_encoding($data, $targetCharset, $fileType);
// 				$data = iconv($fileType, $targetCharset.'//IGNORE', $data);
            }
        }
        return $data;
    }
    
    /**
     * 请确保项目文件有可写权限，不然打印不了日志。
     */
    private function writeLog($text) {
        // $text=iconv("GBK", "UTF-8//IGNORE", $text);
        //$text = characet ( $text );
        $dir = env('runtime_path').'log/'.date("Ym");
        $filename = $dir.'/alipay_'.(date('d')).'.log';
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
}