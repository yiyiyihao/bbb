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
        $this->storeType = 3;//经销商
        $this->adminType = 4;
        parent::__construct();
    }
}