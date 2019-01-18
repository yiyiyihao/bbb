<?php
namespace app\api\controller;
use app\common\controller\Base;

class Test extends Base
{
    public function initialize()
    {
        //放过所有跨域
        $origin = isset($_SERVER['HTTP_ORIGIN']) ? $_SERVER['HTTP_ORIGIN'] : '';
        header('Access-Control-Allow-Origin:' . $origin);
        header('Access-Control-Allow-Methods:POST');
        header('Access-Control-Allow-Headers:x-requested-with,content-type');
    }
    
    public function order()
    {
        //1.创建订单
        $orderModel = new \app\common\model\Order();
        $skuId = 40;//商品规格ID
        $num = 1;//商品数量
        $submit = FALSE;//是否提交订单
        $submit = TRUE;//是否提交订单
        $params = [
            'address_name' => '收货人姓名',
            'address_phone' => '13698547852',
            'region_id' => 1965,
            'region_name' => '广东省 深圳市',
            'address' => '详细地址',
        ];
        $remark = '买家备注';
        $orderType = 2;//活动订单类型
        $user = [
            'udata_id' => 1,
        ];
        $order = $orderModel->createOrder($user, 'goods', $skuId, $num, $submit, $params, $remark, $orderType);
        echo $orderModel->error;
        pre($order);
        
        //2.取消订单
        $user = [
            'udata_id' => 1,
        ];
        $orderSn = '20190115103650505310460546505';
        $result = $orderModel->orderCancel($orderSn, $user);
        echo $orderModel->error;
        pre($result);
        //3.确认完成
        $user = [
            'udata_id' => 1,
        ];
        $orderSn = '20190115103910101575165714584';
        $result = $orderModel->orderFinish($orderSn, $user);
        echo $orderModel->error;
        pre($result);
    }
    
    public function getopenid(){
        $wechatApi = new \app\common\api\WechatApi(FALSE, 'h5');
        $code = '';
        $result = $wechatApi->getOauthOpenid($code, TRUE);
        if ($result === FALSE) {
            die($wechatApi->error);
        }
        $userModel = new \app\common\model\User();
        $params = [
            'user_type'     => 'user',
            'appid'         => $result['appid'],
            'third_openid'  => $result['openid'],
            'nickname'      => isset($result['nickname']) ? trim($result['nickname']) : '',
            'avatar'        => isset($result['headimgurl']) ? trim($result['headimgurl']) : '',
            'gender'        => isset($result['sex']) ? intval($result['sex']) : 0,
            'unionid'       => isset($result['unionid']) ? trim($result['unionid']) : '',
        ];
        $oauth = $userModel->authorized(1, $params);
        pre($oauth);
        
        
        /* $request = $this->request->param();
        $appid = 'wxd3bbb9c41f285e8d';
        $appsecret = '0aa9afd28b6140cd97abf6fe47dc7082';
        $code = $request['code'];
        $url = 'https://api.weixin.qq.com/sns/oauth2/access_token?appid='.$appid.'&secret='.$appsecret.'&code='.$code.'&grant_type=authorization_code';
        $request = curl_post($url,[]);
        if($request['errcode'] == 0){
            $return = [
                'errCode' => 0,
                'openid'  => $request['openid'],
            ];
        }else{
            $return = $request;
        }
        return $this->ajaxJsonReturn($return); */
        //正确的话返回access_token 和openid
        /**
         * { "access_token":"ACCESS_TOKEN","expires_in":7200,"refresh_token":"REFRESH_TOKEN","openid":"OPENID","scope":"SCOPE" }
         */
    }
    public function getscope(){
        $appid = 'wxd3bbb9c41f285e8d';
        $appsecret = '0aa9afd28b6140cd97abf6fe47dc7082';
        $uri   = urlEncode('http://m.smarlife.cn');
        $scopeUrl = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='.$appid.'&redirect_uri='.$uri.'&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect';
        $return = [
            'errCode' => 0,
            'url'   => $scopeUrl,
        ];
        return $this->ajaxJsonReturn($return);
    }
    
    public function jspay(){
        $config = [
            'app_id'        =>  'wxd3bbb9c41f285e8d',
            'mch_id'        =>  '1520990381',
            'mch_key'       =>  'cugbuQVsnihCoQEx3MXD2WYlYtdoQJCH',
            'notify_url'    =>  'https://api.smarlife.cn/test/jsnotify',
        ];
        $wechatApi = new \app\common\api\WechatPayApi(1, 'wechat_js', $config);
        $return = [
            'errCode' => 0,
            'msg'   => '请求成功',
        ];
        $factoryId = 1;
        $order = [
            'openid'        => 'o5hVy1rH9Z4QNpH7X5ytgYulAhdQ',
            'order_sn'      => get_nonce_str(32),
            'real_amount'   => '0.01',
            'store_id'      => $factoryId,
        ];
        $paymentApi = new \app\common\api\PaymentApi($factoryId, 'wechat_js');
        $result = $paymentApi->init($order);
        if($result){
            $return['params'] = $result;
        }else{
            $return['errCode'] = 1;
            $return['error'] = $paymentApi->error;
        }
        return $this->ajaxJsonReturn($return);
    }
    
    public function index()
    {
        $request = $this->request->param();
        header("Content-type: text/html; charset=utf-8");
//         $url = 'http://'.$_SERVER['HTTP_HOST'].'/index';
        $url = 'http://'.$_SERVER['HTTP_HOST'].'/admin';
        $params['timestamp'] = time();
        $params['signkey'] = 'ds7p7auqyjj8';
        $params['mchkey'] = '1458745225';
        $params['method'] = isset($request['method']) ? trim($request['method']) : '';
        if ($request) {
            $params = array_merge($params, $request);
        }
        $params['timestamp'] = time();
        if ($params['method'] == 'postWorkOrder') {
            $params['images'] = 'http:\/\/pimvhcf3v.bkt.clouddn.com\/api_20181218201941_default.png;http:\/\/pimvhcf3v.bkt.clouddn.com\/api_20181218201941_default.png';
//             $params['images'] = ['http:\/\/pimvhcf3v.bkt.clouddn.com\/api_20181218201941_default.png', 'http:\/\/pimvhcf3v.bkt.clouddn.com\/api_20181218201941_default.png'];
        }elseif ($params['method'] == 'assessWorkOrder'){
            $params['score'] = json_encode([
                [
                    'config_id' => 1,
                    'score' => 2,
                ],
                [
                    'config_id' => 2,
                    'score' => 5,
                ],
            ]);
        }
//         $params ['sign'] = $this->generateSign($params, $params['signkey']);
        echo '<pre>';
        print_r($params);
        $params['sign'] = $this->getSign($params, $params['signkey']);
        if ($params['method'] == 'uploadImage') {
            $filename = $_SERVER['DOCUMENT_ROOT'].'\default.png';
            if (file_exists($filename)) {
                echo 'exist';
            }else{
                echo 'no';
            }
            $params['file'] = new \CURLFile($filename);
        }else{
            $params = json_encode($params);
            echo "<hr>";
        }
        pre($params, 1);
        echo "<hr>";
        $result = $this->curl_post_https($url, $params);
        pre($result);
    }
    /**
     * curl函数
     * @url :请求的url
     * @post_data : 请求数组
     **/
    function curl_post_https($url, $post_data){
        if (empty($url)){
            return false;
        }
        //初始化
        $curl = curl_init();
        //设置抓取的url
        curl_setopt($curl, CURLOPT_URL, $url);
        curl_setopt($curl, CURLOPT_TIMEOUT, 0);
        //设置头文件的信息作为数据流输出
        curl_setopt($curl, CURLOPT_HEADER, 0);
        //设置获取的信息以文件流的形式返回，而不是直接输出。
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        //设置post方式提交
        curl_setopt($curl, CURLOPT_POST, 1);
        curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "POST");
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0); // 信任任何证书
        curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 0); // 检查证书中是否设置域名（为0也可以，就是连域名存在与否都不验证了）
        //设置post数据
        curl_setopt($curl, CURLOPT_POSTFIELDS, $post_data);
        //执行命令
        $data = curl_exec($curl);
        $error = '';
        if($data === false){
            $error = curl_error($curl);
            echo 'Curl error: ' . $error;
        }
        //关闭URL请求
        curl_close($curl);
        echo $data;
        $json = json_decode($data,true);
        if (empty($json)){
            return $data = $data ? $data : $url.':'.$error;
        }
        //显示获得的数据
        return $json;
    }
    protected function getSign($params, $signkey)
    {
        //除去待签名参数数组中的空值和签名参数(去掉空值与签名参数后的新签名参数组)
        $para = array();
        while (list ($key, $val) = each ($params)) {
            if($key == 'sign' || $key == 'signkey' || $val === "")continue;
            else	$para [$key] = $params[$key];
        }
        //对待签名参数数组排序
        ksort($para);
        reset($para);
        
        //把数组所有元素，按照“参数=参数值”的模式用“&”字符拼接成字符串
        $prestr  = "";
        
        while (list ($key, $val) = each ($para)) {
            if (is_array($val)) {
                $prestr.= $key."=".implode(',', $val)."&";
            }else{
                $prestr.= $key."=".$val."&";
            }
        }
        //去掉最后一个&字符
        $prestr = substr($prestr,0,count($prestr)-2);
        
        //字符串末端补充signkey签名密钥
        $prestr = $prestr . $signkey;
        var_dump($prestr);
        //生成MD5为最终的数据签名
        $mySgin = md5($prestr);
        return $mySgin;
    }
    /**
     * curl函数
     * @url :请求的url
     * @post_data : 请求数组
     **/
    function curl_post($url, $post_data){
        if (empty($url)){
            return false;
        }
        //初始化
        $curl = curl_init();
        //设置抓取的url
        curl_setopt($curl, CURLOPT_URL, $url);
        //设置头文件的信息作为数据流输出
        curl_setopt($curl, CURLOPT_HEADER, 0);
        //设置获取的信息以文件流的形式返回，而不是直接输出。
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        //设置post方式提交
        curl_setopt($curl, CURLOPT_POST, 1);
        //设置post数据
        curl_setopt($curl, CURLOPT_POSTFIELDS, $post_data);
        //执行命令
        $data = curl_exec($curl);
        $error = '';
        if($data === false){
            $error = curl_error($curl);
            echo 'Curl error: ' . $error;
        }
        //关闭URL请求
        curl_close($curl);
        $json = json_decode($data,true);
        if (empty($json)){
            return $data;
        }
        //显示获得的数据
        return $json;
    }
}