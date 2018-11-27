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
        $this->storeType = 1;//厂商
        $this->adminType = 2;
        parent::__construct();
    }
}