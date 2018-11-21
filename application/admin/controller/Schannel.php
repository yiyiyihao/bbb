<?php
namespace app\admin\controller;

//渠道商理
class Schannel extends Store
{
    var $storeType;
    var $parent;
    var $groupId;
    public function __construct()
    {
        $this->modelName = 'channel';
        $this->model = model('store');
        $this->storeType = 2;//渠道商
        $this->groupId = 2;
        parent::__construct();
    }
}