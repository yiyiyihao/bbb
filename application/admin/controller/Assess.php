<?php
namespace app\admin\controller;

//评价配置管理
class Assess extends AdminForm
{
    public $configKey;
    public function __construct()
    {
        $this->modelName = 'ASSESS_CONFIG';
        $this->model = db('config');
        parent::__construct();
        if ($this->adminUser['admin_type'] != 1) {
            $this->error(lang('NO ACCESS'));
        }
        $this->configKey = CONFIG_WORKORDER_ASSESS;
        $this->search= self::_searchData();
        $this->table = self::_tableData();
        $this->field = self::_fieldData();
    }
    function _getData()
    {
        $data = parent::_getData();
        $info = $this->_assignInfo();
        $name = isset($data['name']) ? $data['name'] : '';
        if (!$name) {
            $this->error('参数名称不能为空');
        }
        //判断参数名称是否存在
        $where = [
            'name' => $name,
            'is_del' => 0,
            'config_key' => $this->configKey,
        ];
        if ($info) {
            $where['config_id'] = ['<>', $info['config_id']];
        }else{
            $data['config_key'] = $this->configKey;
            $data['config_value'] = 5;//固定配置为五分可选
            $data['post_user_id'] = ADMIN_ID;//添加用户id
        }
        $exist = $this->model->where($where)->find();
        if ($exist) {
            $this->error('参数名称已存在');
        }
        return $data;
    }
    function _getWhere()
    {
        $where = [
            'is_del' => 0,
            'config_key' => $this->configKey,
        ];
        $params = $this->request->param();
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if ($name) {
                $where['name'] = ['like', '%'.$name.'%'];
            }
        }
        return $where;
    }
    
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $search = [
            ['type' => 'input', 'name' =>  'name', 'value' => '参数名称', 'width' => '30'],
        ];
        return $search;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = [
            ['title'     => '编号','width'    => '60','value'      => 'factory_id','type'      => 'index'],
            ['title'     => '参数名称', 'width'   => '*','value'     => 'name', 'type'      => 'text'],
            /* ['title'     => '评价分数', 'width'   => '160', 'value'     => 'config_value', 'type'      => 'text'], */
            ['title'     => '显示排序','width'    => '*','value'      => 'sort_order','type'      => 'text'],
            ['title'     => '状态','width'    => '*','value'      => 'status','type'      => 'yesOrNo', 'yes'       => '可用','no'        => '禁用'],
            ['title'     => '操作','width'    => '*','value'   => 'config_id','type'      => 'button','button'    =>
                [
                    ['text'  => '编辑','action'=> 'edit','icon'  => 'edit','bgClass'=> 'bg-main'],
                    ['text'  => '删除','action'=> 'del','icon'  => 'delete','bgClass'=> 'bg-red']
                ]
            ]
        ];
        return array_filter($table);
    }
    /**
     * 详情字段配置
     */
    function _fieldData(){
        $field = [
            ['title'=>'参数名称','type'=>'text','name'=>'name','size'=>'40','datatype'=>'*','default'=>'','notetext'=>'参数名称请不要填写特殊字符'],
            /* ['title'=>'评价分数','type'=>'text','name'=>'config_value',  'disabled'   => 'disabled', 'size'=>'20','default'=>'5'], */
            ['title'=>'显示排序','type'=>'text','name'=>'sort_order','size'=>'20','datatype'=>'','default'=>'1','notetext'=>''],
            ['title'=>'显示状态','type'=>'radio','name'=>'status','size'=>'20','datatype'=>'','default'=>'1','notetext'=>'','radioList'=>[
                ['text'=>'可用','value'=>'1'],
                ['text'=>'禁用','value'=>'0'],
            ]],
            
        ];
        return array_filter($field);
    }
}