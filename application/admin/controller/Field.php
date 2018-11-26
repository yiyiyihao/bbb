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
    }
}