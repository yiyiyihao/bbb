<?php
namespace app\common\controller;

//财务管理
class Finance extends Store
{
    public function __construct()
    {
        $this->modelName = 'channel';
        $this->model = model('store');
        $this->storeType = 2;//渠道商
        $this->adminType = 3;
        parent::__construct();
    }
}