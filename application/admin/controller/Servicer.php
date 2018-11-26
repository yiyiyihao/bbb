<?php
namespace app\admin\controller;
use app\common\controller\Store;

//服务商管理
class Servicer extends Store
{
    var $storeType;
    var $parent;
    var $groupId;
    public function __construct()
    {
        $this->modelName = 'servicer';
        $this->model = model('store');
        $this->storeType = 3;//服务商
        $this->groupId = 1;
        parent::__construct();
    }
}