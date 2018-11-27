<?php
namespace app\admin\controller;
use app\common\controller\Store;

//服务商管理
class Servicer extends Store
{
    public function __construct()
    {
        $this->modelName = 'servicer';
        $this->model = model('store');
        $this->storeType = 4;//服务商
        $this->adminType = 5;
        parent::__construct();
    }
}