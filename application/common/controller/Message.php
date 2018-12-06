<?php
namespace app\common\controller;

//售后工程师管理
class Message extends FormBase
{
    var $adminType;
    public function __construct()
    {
        $this->modelName = 'sys_message';
        $this->model = model($this->modelName);
        parent::__construct();
        
        if (!in_array($this->adminUser['admin_type'], [ADMIN_SYSTEM, ADMIN_FACTORY])) {
            if ($this->adminUser['admin_type'] != ADMIN_SERVICE) {
                $this->error('NO ACCESS');
            }
        }
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY){
            $this->_getFactorys();
        }
        $this->search= self::_searchData();
        $this->table = self::_tableData();
        $this->field = self::_fieldData();
        $this->uploadUrl = url('Upload/upload', ['prex' => 'store_logo_', 'thumb_type' => 'logo_thumb']);
    }
    
    function _getData()
    {
        $info = $this->_assignInfo();
        $params = parent::_getData();
        $adminUser = $this->adminUser;
        $params['post_user_id'] = $adminUser['user_id'];
        $params['store_id'] = $adminUser['store_id'];
//dump($adminUser);exit;
        return $params;
    }
    function _getAlias()
    {
        return 'SM';
    }
    function _getField(){
        return 'SM.*, S.name as sname';
    }
    function _getJoin()
    {
        return [
            ['store S', 'S.store_id = SM.store_id', 'LEFT'],
        ];
    }
    function _getOrder()
    {
        return 'SM.sort_order ASC, SM.add_time DESC';
    }
    function _getWhere(){
        $where = [
            'SM.is_del'=> 0,
        ];
        $where['SM.store_id'] = $this->adminUser['store_id'];
        $params = $this->request->param();
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['SM.name'] = ['like','%'.$name.'%'];
            }
            $storeid = isset($params['store_id']) ? trim($params['store_id']) : '';
            if($storeid){
                $where['SM.store_id'] = ['like','%'.$storeid.'%'];
            }
        }
        return $where;
    }
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $search = [
            ['type' => 'input', 'name' =>  'store_id', 'value' => '所属商户', 'width' => '30'],
            ['type' => 'input', 'name' =>  'name', 'value' => '公告标题', 'width' => '30'],
            
        ];
        return $search;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table=parent::_tableData();
        return array_filter($table);
    }
    /**
     * 详情字段配置
     */
    function _fieldData(){
        /*$array = [];
        if ($this->adminUser['admin_type'] == ADMIN_SERVICE){
            $array = ['title'=>'服务商名称','type'=>'text','name'=>' ','size'=>'40','default'=> $this->adminStore['name'], 'disabled' => 'disabled'];
        }else{
            $servicers = db('store')->field('store_id as id, name as cname')->where(['is_del' => 0, 'status' => 1, 'store_type' => STORE_SERVICE, 'factory_id' => $this->adminUser['store_id']])->select();
            $this->assign('servicers', $servicers);
            $array = [      'title'=>'选择服务商',
                            'type'=>'select',
                            'options'=>'servicers',
                            'name' => 'store_id', 
                            'size'=>'40' , 
                            'datatype'=>'*', 
                            'default'=>'',
                            'default_option'=>'==选择服务商==',
                            'notetext'=>'请选择服务商'];
        }*/
        
        $field = [
            ['title'=>'公告标题',  'type'=>'text','name'=>'name','size'=>'50','datatype'=>'*','default'=>'','notetext'=>'公告标题'],
            ['title'=>'描述信息','type'=>'text','name'=>'description', 'size'=>'80', 'datatype'=>'*','default'=>'','notetext'=>'请填写描述信息'],
            ['title'=>'排序',      'type'=>'text','name'=>'sort_order','size'=>'20','datatype'=>'','default'=>'1','notetext'=>''],
            ['title'=>'是否置顶','type'=>'radio','name'=>'is_top','size'=>'20','datatype'=>'','default'=>'0','notetext'=>'','radioList'=>[
                ['text'=>'置顶','value'=>'1'],
                ['text'=>'不置顶','value'=>'0'],
            ]],
            ['title'=>'展示场景','type'=>'radio','name'=>'special_display','size'=>'20','datatype'=>'','default'=>'0','notetext'=>'','radioList'=>[
                ['text'=>'登录弹窗','value'=>'1'],
                ['text'=>'正常推送','value'=>'0'],
            ]],
             ['title'=>'公告内容',   'type'=>'ueditor','name'=>'content','size'=>'','datatype'=>'','default'=>'','notetext'=>''],
        ];
        $field=parent::_tableData();
        return array_filter($field);
    }
}


