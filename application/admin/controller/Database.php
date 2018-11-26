<?php
namespace app\admin\controller;
use app\common\controller\FormBase;

//数据表管理
class Database extends FormBase
{
    public function __construct()
    {
        $this->modelName = 'model';
        $this->model = db('model');
        parent::__construct();
    }
}