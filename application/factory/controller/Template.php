<?php
namespace app\factory\controller;
class Template extends FactoryForm
{
    public function __construct()
    {
        $this->modelName = 'template_config';
        $this->model = model($this->modelName);
        parent::__construct();
        if (!in_array($this->adminUser['admin_type'], [ADMIN_FACTORY])){
            $this->error(lang('NO ACCESS'));
        }
        $this->perPage = 10;
    }
    public function add(){
        $this->error('操作错误');
    }
    public function del(){
        $this->error('操作错误');
    }
    public function _getData()
    {
        $data = parent::_getData();
        $isClick = isset($data['is_click']) ? intval($data['is_click']) : 0;
        $url = isset($data['url']) ? trim($data['url']) : '';
        if (!$isClick){
            $data['url'] = '';
        }else{
            if (!$url) {
                $this->error('网页地址不能为空');
            }
        }
        return $data;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = parent::_tableData();
        if ($table['actions']['button']) {
            $table['actions']['width']  = '100';
        }
        return $table;
    }
}