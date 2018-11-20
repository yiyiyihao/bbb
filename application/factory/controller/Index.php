<?php
namespace app\factory\controller;
use think\Controller;
use think\facade\Request;

class Index extends Controller
{
    function __construct(){
        $domain = Request::panDomain();
        #TODO根据domain取得厂商信息
        #TODO传值给厂商后台处理逻辑,渲染厂商后台页面信息
//         die();
    }
}
