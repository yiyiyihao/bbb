<?php
namespace app\common\controller;

//服务商管理
class Servicer extends Store
{
    public function __construct()
    {
        $this->modelName = 'store_servicer';
        $this->model = model('store');
        parent::__construct();
    }
    function _init()
    {
        $this->storeType = STORE_SERVICE;//服务商
        $this->adminType = ADMIN_SERVICE;
        $this->groupId = GROUP_SERVICE;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = parent::_tableData();
        $table[] = ['title'=>'服务商编号','width'=>'100','value'=>'store_no','type'=>'text','sort'=>'40'];
        return $table;
    }
}