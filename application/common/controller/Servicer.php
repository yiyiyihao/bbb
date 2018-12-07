<?php
namespace app\common\controller;

//服务商管理
class Servicer extends Store
{
    public function __construct()
    {
        $this->modelName = 'store_servicer';
        $this->model = model('store');
        parent::__construct();
    }
    function _init()
    {
        $this->storeType = STORE_SERVICE;//服务商
        $this->adminType = ADMIN_SERVICE;
        $this->groupId = GROUP_SERVICE;
    }
}