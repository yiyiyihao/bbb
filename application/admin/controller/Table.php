<?php
namespace app\admin\controller;
use app\admin\controller\AdminForm;
use think\Db;

//数据表列表字段管理
class Table extends AdminForm
{
    var $pid;
    var $pModel;
    public function __construct()
    {
        $this->modelName = 'form_table';
        $this->model = model('table');
        $this->pModel= db('form_model');
        parent::__construct();
        $this->perPage = 100;
        $params = $this->request->param();
        $this->pid = isset($params['pid']) ? intval($params['pid']) : 0;
        $this->subMenu['add']['url'] = url("add",['pid'=>$this->pid]);
    }
    
    /**
     * 获取提交数据
     */
    function _getData(){
        $data = parent::_getData();
        $data['model_id'] = $this->pid;
        return $data;
    }
    
    /**
     * 列表查询条件
     */
    function _getWhere(){
//         $where = parent::_getWhere();
        $where['model_id']  = $this->pid;
        return $where;
    }
}