<?php
namespace app\admin\controller;

//服务商管理
class Sservicer extends Store
{
    var $storeType;
    var $parent;
    var $groupId;
    public function __construct()
    {
        $this->modelName = 'servicer';
        $this->model = model('store');
        $this->storeType = 4;//服务商
        $this->groupId = 2;
        parent::__construct();
    }
}