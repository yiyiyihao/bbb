<?php
namespace app\admin\controller;
use app\common\controller\Store;

//渠道商理
class Channel extends Store
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