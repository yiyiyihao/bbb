<?php
namespace app\common\controller;

//厂商管理
class Factory extends Store
{
    public function __construct()
    {
        $this->modelName = 'store_factory';
        $this->model = model('store');
        parent::__construct();
    }
    function _init()
    {
        $this->storeType = STORE_FACTORY;//厂商
        $this->adminType = ADMIN_FACTORY;
        $this->groupId   = GROUP_FACTORY;
    }
}