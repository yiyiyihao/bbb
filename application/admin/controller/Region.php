<?php
namespace app\admin\controller;
//地址管理
class Region extends AdminForm
{
    public function __construct()
    {
        $this->modelName = 'region';
        $this->model = db('region');
        parent::__construct();
    }
    function _getAjaxField($field = ''){
        $this->perPage = 100;
        $pk = $this->model->getPk();
        $field = $pk.' as id, region_name as name';
        return $field;
    }
}