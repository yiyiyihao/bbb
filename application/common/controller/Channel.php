<?php
namespace app\common\controller;

//渠道商管理
class Channel extends Store
{
    public function __construct()
    {
        $this->modelName = 'store_channel';
        $this->model = model('store');
        parent::__construct();
    }
    function _init()
    {
        $this->storeType = STORE_CHANNEL;//渠道商
        $this->adminType = ADMIN_CHANNEL;
        $this->groupId = GROUP_CHANNEL;
    }
    public function getAjaxList($where = [], $field = '')
    {
        $params = $this->request->param();
        $storeType = isset($params['store_type']) ? intval($params['store_type']) : 0;
        $where = ['is_del' => 0, 'status' => 1];
        if ($storeType) {
            $where['store_type'] = $storeType;
        }
        $this->model = db('store');
        parent::getAjaxList($where, 'store_id as id,  name');
    }
}