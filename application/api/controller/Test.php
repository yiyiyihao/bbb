<?php
namespace app\api\controller;
use app\common\controller\Base;

class Test extends Base
{
    public function index()
    {
        $request = $this->request->param();
        header("Content-type: text/html; charset=utf-8");
        $url = 'http://'.$_SERVER['HTTP_HOST'].'/index';
        $params['timestamp'] = time();
        $params['signkey'] = 'ds7p7auqyjj8';
        $params['method'] = isset($request['method']) ? trim($request['method']) : '';
        if ($request) {
            $params = array_merge($params, $request);
        }
        $params['timestamp'] = time();
//         $params ['sign'] = $this->generateSign($params, $params['signkey']);
        echo '<pre>';
        print_r($params);
        $params['sign'] = $this->getSign($params, $params['signkey']);
        $params = json_encode($params);
        pre($params, 1);
        echo "<hr>";
        $result = curl_post_https($url, $params);
        pre($result);
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
            $prestr.= $key."=".$val."&";
        }
        //去掉最后一个&字符
        $prestr = substr($prestr,0,count($prestr)-2);
        
        //字符串末端补充signkey签名密钥
        $prestr = $prestr . $signkey;
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