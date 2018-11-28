<?php
namespace app\factory\controller;
use app\factory\controller\BaseFactory;
use app\admin\controller\Login as adminLogin;

/**
 * @author chany
 * @date 2018-11-08
 * 后台管理登录操作
 */
class Login extends adminLogin
{
    var $factory;
    function __construct(){
        parent::__construct();
        $BaseFactory = new BaseFactory();
        $this->factory = $BaseFactory->factory;
    }
    public function index(){
        $this->loginIndexTpl = 'factory@login/index';
        return parent::index();
    }
}