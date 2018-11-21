<?php
namespace app\admin\controller;

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
        $this->storeType = 3;//经销商
        $this->groupId = 2;
        parent::__construct();
    }
}