<?php
namespace app\admin\controller;
use app\common\controller\FormBase;

//数据表字段管理
class Field extends FormBase
{
    public function __construct()
    {
        $this->modelName = 'field';
        $this->model = db('field');
        parent::__construct();
        $this->subMenu['add'] = [];
//         $params = $this->request->param();
//         $pid = $params['pid'];
//         $this->subMenu['add']['url'] = url("add",['pid'=>$pid]);
    }
    
    /**
     * 列表查询条件
     */
    function _getWhere(){
        $where = parent::_getWhere();
        $params = $this->request->param();
        $pid = $params['pid'];
        $where['model_id']  = $pid;
        return $where;
    }
}