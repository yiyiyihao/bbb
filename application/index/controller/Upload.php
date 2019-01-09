<?php
namespace app\index\controller;
use app\common\controller\UploadBase;

class Upload extends UploadBase
{
    public function __construct()
    {
        //放过所有跨域
        $origin = isset($_SERVER['HTTP_ORIGIN']) ? $_SERVER['HTTP_ORIGIN'] : '';
        header('Access-Control-Allow-Origin:' . $origin);
        header('Access-Control-Allow-Methods:POST');
        header('Access-Control-Allow-Headers:x-requested-with,content-type');
        parent::__construct();
    }
}