<?php
namespace app\admin\controller;
class Apilog extends AdminForm
{
    public function __construct()
    {
        $this->modelName = 'apilog_app';
        $this->model = db('apilog_app');
        parent::__construct();
        unset($this->subMenu['add']);
    }
    public function detail()
    {
        $info = parent::_assignInfo();
        return $this->fetch();
    }
    function _getWhere()
    {
        $where = [
        ];
        $params = $this->request->param();
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if ($name) {
                $where['method'] = ['like', '%'.$name.'%'];
            }
            $status = isset($params['status']) ? intval($params['status']) : '';
            if (isset($params['status']) && $status > -1) {
                $where['error'] = $status;
            }
        }
        return $where;
    }
    function _getOrder()
    {
        return 'request_time DESC';
    }
    
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $statusList = [
            1 => '异常',
            0 => '正常',
        ];
        $this->assign('status_list', $statusList);
        $search = [
            ['type' => 'input', 'name' =>  'name', 'value' => '接口名称', 'width' => '30'],
            ['type' => 'select', 'name' => 'status', 'options'=>'status_list', 'default_option' => '==请求状态==', 'default' => -1],
        ];
        return $search;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = [
            ['title'     => '编号','width'    => '60','value'      => '','type'      => 'index'],
            ['title'     => '请求来源','width'    => '120','value'      => 'request_source','type'      => 'text'],
            ['title'     => '接口名称', 'width'   => '*','value'     => 'method', 'type'      => 'text'],
            ['title'     => '请求时间', 'width'   => '180','value'     => 'request_time', 'type'      => 'function', 'function' => 'time_to_date'],
            ['title'     => '响应时间', 'width'   => '180','value'     => 'return_time', 'type'      => 'function', 'function' => 'time_to_date'],
            ['title'     => '响应时长(毫秒)', 'width'   => '160','value'     => 'response_time', 'type'      => 'text'],
            ['title'     => '状态','width'    => '100','value'      => 'error','type'      => 'yesOrNo', 'yes' => '异常','no' => '正常'],
            ['title'     => '操作','width'    => '160','value'   => 'log_id','type'      => 'button','button'    =>
                [
                    ['text'  => '查看','action'=> 'detail','icon'  => 'detail','bgClass'=> 'bg-main'],
                ]
            ]
        ];
        return array_filter($table);
    }
}