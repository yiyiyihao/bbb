<?php
namespace app\api\controller;
use app\common\controller\Base;

class ApiBase extends Base
{
    protected $requestTime;
    protected $visitMicroTime;
    protected $postParams;
    
    public function __construct(){
        parent::__construct();
    }
    protected function _checkPostParams()
    {
        $this->requestTime = time();
        $this->visitMicroTime = $this->_getMillisecond();//会员访问时间(精确到毫秒)
        $data = file_get_contents('php://input');
        if ($data) {
            $tempData = json_decode($data, true);
        }else{
            $tempData = [];
        }
        if (!$data || !$tempData ) {
            $data = $_POST;
        }
        if (!$tempData) {
            $tempData = $data ? $data : (isset($GLOBALS["HTTP_RAW_POST_DATA"]) ? $GLOBALS["HTTP_RAW_POST_DATA"] : '');
            $this->_logResult("HTTP_RAW_POST_DATA\r\n".$tempData);
            $this->_logResult("request\r\n".json_encode($this->request));
        }
        if(!is_array($tempData)) {
            $this->postParams = json_decode($tempData, true);
        }else{
            $this->postParams = $tempData;
        }
        if (!$this->postParams) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请求参数异常']);
        }
    }
    /**
     * 处理返回参数
     * @param array $data
     */
    protected function _returnMsg($data, $echo = TRUE)
    {
        $arr=[
            'errCode'=>0,
            'errMsg'=>'ok',
        ];
        $data = json_decode(json_encode($data), true);
        $ret=array_merge($arr, $data);
        $ret['msg']=$ret['errMsg'];//兼容以前代码
        $result = json_encode($data);
        if ($echo) {
            header('Content-Type:application/json');
            echo $result;
        }else{
            return $result;
        }
        //if (!isset($data['errCode']) || !$data['errCode']) {
        //    $tempArr = ['errCode' => 0, 'errMsg' => 'ok'];
        //    $data = $data ? ($tempArr + $data) : $data;
        //}
        //$result = json_encode($data);
        //if ($echo) {
        //    header('Content-Type:application/json');
        //    echo $result;
        //}
        //return $result;
    }
    protected function _getMillisecond() {
        list($t1, $t2) = explode(' ', microtime());
        return (float)sprintf('%.0f',(floatval($t1)+floatval($t2))*1000);
    }
    /**
     * 写日志，方便测试（看网站需求，也可以改成把记录存入数据库）
     * 注意：服务器需要开通fopen配置
     * @param $word 要写入日志里的文本内容 默认值：空值
     */
    protected function _logResult($word='', $logTxt = '_log') {
        $errorFile = env('runtime_path')."/log/api".$logTxt.".txt";
        file_put_contents($errorFile, date('Y-m-d H:i:s')."\r\n".$word."\r\n", FILE_APPEND);
    }
}    