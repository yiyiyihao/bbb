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
    public function index()
    {
        session_start();
        pre($_SESSION, 1);
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
        // 获得响应结果里的：头大小
        // 根据头大小去获取头信息内容
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