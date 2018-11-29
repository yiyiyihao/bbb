<?php
namespace app\admin\controller;
use app\common\controller\Store;

//厂商管理
class Factory extends Store
{
    public function __construct()
    {
        $this->modelName = 'factory';
        $this->model = model('store');
        parent::__construct();
    }
    function _init()
    {
        $this->storeType = STORE_FACTORY;//厂商
        $this->adminType = ADMIN_FACTORY;
        $this->groupId = GROUP_FACTORY;
    }
    //厂商参数设置
    public function config()
    {
        $info = $this->_assignInfo();
        pre($info);
    }
}