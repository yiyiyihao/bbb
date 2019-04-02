<?php
namespace app\factory\controller;
use app\common\controller\Servicer as adminServicer;

//服务商管理
class Servicer extends adminServicer
{
    function _init()
    {
        $this->storeType = STORE_SERVICE;
        $this->adminType = ADMIN_SERVICE;
        $this->groupId = GROUP_SERVICE;
    }
    
}