<?php
namespace app\common\controller;
use app\admin\controller\AdminForm;

//非表单后台页面测试
class Test extends AdminForm
{        
    public function __construct()
    {
        $this->modelName = 'auth_rule';
        $this->model = db('auth_rule');
        parent::__construct();
        $this->table = self::_tableData();
        $this->field = self::_fieldData();
        $this->perPage = 100;
    }    
}