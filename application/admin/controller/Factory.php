<?php
namespace app\admin\controller;
use app\common\controller\Store;

//厂商管理
class Factory extends Store
{
    var $storeType;
    var $parent;
    var $groupId;
    public function __construct()
    {
        $this->modelName = 'factory';
        $this->model = model('store');
        $this->storeType = 1;//厂商
        $this->groupId = 2;
        parent::__construct();
    }
}