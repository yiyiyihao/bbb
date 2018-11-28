<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: 流年 <liu21st@gmail.com>
// +----------------------------------------------------------------------

// 应用公共文件

function get_installer_status($status = FALSE)
{
    $list = [
        -4 => '服务商拒绝申请',
        -3 => '服务商审核中',
        -2 => '厂商拒绝申请',
        -1 => '厂商审核中',
        0  => '禁用',
        1  => '正常',
    ];
    if ($status === FALSE) {
        return $list;
    }
    if ($status && isset($list[$status])) {
        return $list[$status];
    }else{
        return '';
    }
}

function get_admin_type($type = FALSE){
    $storeTypes = [
        1 => '平台',
        2 => '厂商',
        3 => '渠道商',
        4 => '经销商',
        5 => '服务商',
    ];
    if ($type === FALSE) {
        return $storeTypes;
    }
    if ($type && isset($storeTypes[$type])) {
        return $storeTypes[$type];
    }else{
        return '-';
    }
}
/**
 * 删除目录下的所有文件和目录
 * @param string $dir
 */
function del_file_by_dir($dir) {
    //1、将目录内容全部获取出
    $list = scandir($dir);
    //2、遍历目录
    foreach($list as $f){
        //3、将 .  .. 排除在外
        if($f != '.' && $f != '..'){
            //4、如果内容文件 unlink
            if(is_file($dir."/".$f)){
                unlink($dir."/".$f);
            }else{
                //5、目录   递归
                del_file_by_dir($dir."/".$f);
            }
        }
    }
    //6、循环外删除目录!!
    rmdir($dir); 
}

function array_implode($array = [])
{
    $array = $array ? array_filter($array) : [];
    $array = $array ? array_unique($array) : [];
    $implode = $array ? implode(',', $array) : '';
    return $implode;
}

/**
 *
 * 拼接签名字符串
 * @param array $urlObj
 *
 * @return 返回已经拼接好的字符串
 */
function to_url_params($urlObj)
{
    $buff = "";
    foreach ($urlObj as $k => $v)
    {
        if($k != "sign"){
            $buff .= $k . "=" . $v . "&";
        }
    }
    $buff = trim($buff, "&");
    return $buff;
}
/*
 *xml to array
 */
function xml_to_array($xml)
{
    $array_data = json_decode(json_encode(simplexml_load_string($xml, 'SimpleXMLElement', LIBXML_NOCDATA)), true);
    return $array_data;
}
/*
 *array to xml
 */
function array_to_xml($arr)
{
    $xml = "<xml>";
    foreach ($arr as $key=>$val)
    {
        $xml.="<".$key.">".$val."</".$key.">";
    }
    $xml.="</xml>";
    return $xml;
}
/**
 *
 * 产生随机字符串，不长于32位
 * @param int $length
 * @return 产生的随机字符串
 */
function get_nonce_str($length = 32, $type = 1)
{
    if ($type == 1) {
        $chars = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    }else{
        $chars = "0123456789";
    }
    
    $str ="";
    for ( $i = 0; $i < $length; $i++ )  {
        $str .= substr($chars, mt_rand(0, strlen($chars)-1), 1);
    }
    return $str;
}
function object_array($array) {
    if(is_object($array)) {
        $array = (array)$array;
    } if(is_array($array)) {
        foreach($array as $key=>$value) {
            $array[$key] = object_array($value);
        }
    }
    return $array;
}
/**
 * 二维数组排序
 * @param array $array 排序的数组
 * @param string $key 排序主键
 * @param string $type 排序类型 asc|desc
 * @param bool $reset 是否返回原始主键
 * @return array
 */
function array_order($array, $key, $type = 'asc', $reset = false)
{
    if (empty($array) || !is_array($array)) {
        return $array;
    }
    foreach ($array as $k => $v) {
        $keysvalue[$k] = $v[$key];
    }
    if ($type == 'asc') {
        asort($keysvalue);
    } else {
        arsort($keysvalue);
    }
    $i = 0;
    foreach ($keysvalue as $k => $v) {
        $i++;
        if ($reset) {
            $new_array[$k] = $array[$k];
        } else {
            $new_array[$i] = $array[$k];
        }
    }
    return $new_array;
}

function array_trim($array)
{
    foreach ($array as $key => &$value) {
        $value = trim($value);
    }
    return $array;
}

/**
 * 系统断点调试方法
 */
function pre($array, $undie = 0)
{
    echo '<pre>';
    print_r($array);
    echo '</pre>';
    if($undie){
        return ;
    }
    exit();
}

/**
 * 格式化时间戳
 * @param int $timediff 时间戳
 * @param number $return_type 返回数据类型 1：带单位字符串 2：返回分钟数 3： 数组
 */
function timediff($timediff, $return_type = 1)
{
    //计算天数
    $days = trim(intval($timediff/86400));
    //计算小时数
    $remain = $timediff%86400;
    $hours = trim(intval($remain/3600));
    //计算分钟数
    $remain = $remain%3600;
    $mins = trim(intval($remain/60));
    //计算秒数
    $secs = trim($remain%60);
    $return = '';
    if ($return_type == 1) {
        if($days){
            $return = $days.'天';
        }
        if($hours){
            $return .= $return ? ''.$hours.'时' : $hours.'时';
        }
        if($mins){
            $return .= $return ? ''.$mins.'分' : $mins.'分';
        }
        if($secs){
            $return .= $return ? ''.$secs.'秒' : $secs.'秒';
        }
    }elseif($return_type == 2){//返回分钟数
        $return = round($timediff%86400/60, 2);
    }else{
        $return = ["day" => $days,"hour" => $hours,"min" => $mins,"sec" => $secs];
    }
    return $return;
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
    $json = json_decode($data,true);
    if (empty($json)){
        return $data = $data ? $data : $url.':'.$error;
    }
    //显示获得的数据
    return $json;
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
    $post_data = json_encode($post_data);
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
        return $data = $data ? $data : $url.':'.$error;
    }
    //显示获得的数据
    return $json;
}