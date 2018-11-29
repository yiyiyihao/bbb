<?php
namespace app\admin\controller;
use app\common\controller\Store;

//经销商管理
class Dealer extends Store
{
    public function __construct()
    {
        $this->modelName = 'dealer';
        $this->model = model('store');
        parent::__construct();
    }
    function _init()
    {
        $this->storeType = STORE_DEALER;//经销商
        $this->adminType = ADMIN_DEALER;
        $this->groupId = GROUP_DEALER;
    }
}