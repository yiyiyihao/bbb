<?php
namespace app\api\controller;
use app\common\controller\Base;

class BaseApi extends Base
{
    protected $requestTime;
    protected $visitMicroTime;
    protected $postParams;
    protected $imgFile;
    protected $captureTime;
    protected $deviceCode;
    protected $faceApi;
    protected $apiType;
    
    public function __construct(){
        parent::__construct();
        /* if ($flag) {
            $action = $this->request->action();
            if (!method_exists($this, $action)) {
                die('NO ACCESS');
            }
            $this->_checkPostParams();
        } */
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
        if (!isset($data['errCode']) || !$data['errCode']) {
            $tempArr = ['errCode' => 0, 'errMsg' => 'ok'];
            $data = $data ? ($tempArr + $data) : $data;
        }
        $result = json_encode($data);
        if ($echo) {
            header('Content-Type:application/json');
            echo $result;
        }
        return $result;
    }
    protected function _getMillisecond() {
        list($t1, $t2) = explode(' ', microtime());
        return (float)sprintf('%.0f',(floatval($t1)+floatval($t2))*1000);
    }
}    