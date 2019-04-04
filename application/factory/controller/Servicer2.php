<?php
namespace app\factory\controller;
use app\common\controller\Servicer as adminServicer;

//服务商管理
class Servicer2 extends adminServicer
{
    public function _init()
    {
        //新服务商
        $this->storeType = STORE_SERVICE_NEW;
        $this->adminType = ADMIN_SERVICE_NEW;
        $this->groupId = GROUP_SERVICE_NEW;
    }
    
}