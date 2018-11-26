<?php
namespace app\admin\controller;
use app\common\controller\Store;

//经销商管理
class Dealer extends Store
{
    var $storeType;
    var $parent;
    var $groupId;
    public function __construct()
    {
        $this->modelName = 'dealer';
        $this->model = model('store');
        $this->storeType = 2;//经销商
        $this->groupId = 1;
        parent::__construct();
    }
}