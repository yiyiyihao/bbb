<?php
namespace app\factory\controller;
use app\common\controller\Region as commonRegion;
//地址管理
class Region extends commonRegion
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