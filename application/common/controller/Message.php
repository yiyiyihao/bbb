<?php
namespace app\common\controller;

//售后工程师管理
class Message extends FormBase
{

    public function __construct()
    {
        $this->modelName = 'sys_message';
        $this->model = new \app\common\model\SysMessage();
        parent::__construct();
        $this->search= self::_searchData();
        $this->table = self::_tableData();
        $this->field = self::_fieldData();
       
    }
    
    function _getField(){
        $field = 'SM.*';
        $field .= ', S.name as sname';
        return $field;
    }
    function _getAlias(){
        return 'SM';
    }
    function _getJoin(){
        $join[] = ['store S', 'S.store_id = SM.store_id', 'INNER'];
        return $join;
    }
    function _getWhere(){
        $params = $this->request->param();
        $where = ['SM.is_del' => 0];
        if ($this->adminUser['store_id']) {
            $where['SM.store_id'] = $this->adminUser['store_id'];
        }
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['SM.name'] = ['like','%'.$name.'%'];
            }
        }
        return $where;
    }
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $search = [
            ['type' => 'input', 'name' =>  'name', 'value' => '公告标题', 'width' => '30'],
        ];
        return $search;
    }
    function _assignAdd()
    {
        parent::_assignAdd();
    }
    function _assignInfo($id = 0){
        $info = parent::_assignInfo($id);
        $this->assign('info', $info);
        $store = new \app\common\controller\Store();
        $store->_getFactorys();
        return $info;
    }
    function _getData()
    {
        $data = parent::_getData();
        $data['post_user_id']=$this->adminUser['user_id'];
        $data['store_id']=$this->adminUser['store_id'];
        return $data;
    }
    
    function _tableData(){
        $table = parent::_tableData();
        $table['actions']['button'][]=["text"=> "发布","action"=> "publish","icon"=> "edit","bgClass"=> "bg-yellow"  , 
        ];
        $table['status']=["title"=>"公告进度","width"=>"80", "sort"=> 60,"type"=>"status", "value"=>"status","status"=>
                [['text'  => '禁用',     'value'   => 0],
                 ['text'  => '待发布', 'value'   => 1],
                 ['text'  => '已发布','value' => 2]]];
        return $table;
    }
}


