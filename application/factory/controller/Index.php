<?php
namespace app\factory\controller;
use app\factory\controller\BaseFactory;
use app\admin\controller\Index as adminIndex;

class Index extends adminIndex
{
    var $factory;
    function __construct(){
        parent::__construct();
        $BaseFactory = new BaseFactory();
        $this->adminFactory = $BaseFactory->adminFactory;
    }
}
