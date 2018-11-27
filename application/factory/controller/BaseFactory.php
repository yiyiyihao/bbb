<?php
namespace app\factory\controller;
use think\facade\Request;
use app\common\controller\AdminBase;

class BaseFactory extends AdminBase
{
    var $factory;
    function __construct(){
        $domain = Request::panDomain();
        if ($domain) {
            //根据domain取得厂商信息
            $factory = db('factory')->where(['domain' => trim($domain), 'is_del' => 0])->find();
            if ($factory) {
                //传值给厂商后台处理逻辑,渲染厂商后台页面信息
                parent::__construct();
            }
        }
    }
}
