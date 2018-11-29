<?php
namespace app\common\controller;

//渠道商管理
class Channel extends Store
{
    public function __construct()
    {
        $this->modelName = 'channel';
        $this->model = model('store');
        parent::__construct();
    }
    function _init()
    {
        $this->storeType = STORE_CHANNEL;//渠道商
        $this->adminType = ADMIN_CHANNEL;
        $this->groupId = GROUP_CHANNEL;
    }
}