<?php
namespace app\common\controller;

//用户管理
class User extends FormBase
{
    var $adminType;
    public function __construct()
    {
        $this->modelName = 'user';
        $this->model = db($this->modelName);
        parent::__construct();
        $this->search= self::_searchData();
        $this->table = self::_tableData();
        $this->field = self::_fieldData();
        $this->adminType = $this->adminUser['admin_type'];
    }
    function _getAlias()
    {
        return 'U';
    }
    function _getField(){
        return 'U.*, S.name as sname, G.name as gname';
    }
    function _getJoin()
    {
        return [
            ['store S', 'S.store_id = U.store_id', 'LEFT'],
            ['user_group G', 'G.group_id = U.group_id', 'LEFT'],
        ];
    }
    function _getOrder()
    {
        return 'U.sort_order ASC, U.add_time DESC';
    }
    function _getWhere(){
        $where = [
            'U.is_del'     => 0,
            'U.admin_type' => ['>', 0],
            'U.user_id' => ['>', 1],
        ];
        if ($this->adminType > 1) {
            $where['U.admin_type'] = $this->adminType;
            $where['U.store_id'] = $this->adminUser['store_id'];
        }
        $params = $this->request->param();
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['U.username'] = ['like','%'.$name.'%'];
            }
        }
        return $where;
    }
    function _getData()
    {
        $data = parent::_getData();
        $params = $this->request->param();
        
        $pkId = $params && isset($params['id']) ? intval($params['id']) : 0;
        $params = $this->request->param();
        $username =  isset($data['username']) ? trim($data['username']) : '';
        $password =  isset($data['password']) ? trim($data['password']) : '';
        
        $groupId = $params && isset($params['group_id']) ? intval($params['group_id']) : 0;
        if (!$pkId) {
            if (!$username) {
                $this->error('登录用户名不能为空');
            }
            if (!$password) {
                $this->error('登录密码不能为空');
            }
        }
        if (!$groupId) {
            $this->error('请选择账户角色');
        }
        $userModel = new \app\common\model\User();
        $result = $userModel->_checkFormat($params);
        if ($result === FALSE) {
            $this->error($userModel->error);
        }
        if ($password) {
            $data['password'] = $userModel->_pwdEncryption($password);
        }
        $data['store_id'] = $this->adminUser['store_id'];
        $data['admin_type'] = $this->adminUser['admin_type'];
        return $data;
    }
    function _assignInfo($pkId = 0){
        $info = parent::_assignInfo($pkId);
        $this->_getUgroup();
        return $info;
    }
    function _getUgroup()
    {
        $groups = db('user_group')->where(['is_del' => 0, 'status' =>1,  'store_id' => ['IN', [0, $this->adminUser['store_id']]]])->select();
        $this->assign('groups', $groups);
        return $groups;
    }
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $search = [
            ['type' => 'input', 'name' =>  'name', 'value' => '登录用户名', 'width' => '30'],
        ];
        return $search;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = [
            ['title'     => '编号','width'    => '60','value'      => 'user_id','type'      => 'index'],
            ['title'     => '所属商户','width' => '100','value'     => 'sname','type'      => 'text'],
            ['title'     => '角色名称','width'  => '*','value'      => 'gname','type'      => 'text'],
            ['title'     => '登录用户名','width'  => '*','value'     => 'username','type'      => 'text'],
            ['title'     => '联系电话','width'  => '*','value'      => 'phone','type'      => 'text'],
            ['title'     => '状态','width'    => '80','value'      => 'status','type'      => 'yesOrNo', 'yes'       => '可用','no'        => '禁用'],
            ['title'     => '排序','width'    => '80','value'      => 'sort_order','type'      => 'text'],
            ['title'     => '操作','width'    => '*','value'      => 'user_id','type'      => 'button','button'    =>
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
        $array = [];
        if ($this->adminType != 1) {
            if ($this->adminUser['admin_type'] == 2) {
                $array = ['title'=>'厂商名称','type'=>'text','name'=>'','size'=>'40','default'=> $this->adminStore['name'], 'disabled' => 'disabled'];
            }else{
                $array = ['title'=>'所属厂商','type'=>'select','options'=>'factorys','name' => 'factory_id', 'size'=>'40' , 'datatype'=>'', 'default'=>'','default_option'=>'==所属厂商==','notetext'=>'请选择所属厂商'];
            }
        }else{
            $array = ['title'=>'二级域名','type'=>'text','name'=>'domain','size'=>'20','datatype'=>'','default'=>'','notetext'=>lang($this->modelName).'二级域名不能重复'];
        }
        $field = [
            $array,
            ['title'=>lang($this->modelName).'名称','type'=>'text','name'=>'name','size'=>'40','datatype'=>'*','default'=>'','notetext'=>lang($this->modelName).'名称请不要填写特殊字符'],
            ['title'=>'Logo','type'=>'uploadImg','name'=>'logo', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>''],
            ['title'=>lang($this->modelName).'地址','type'=>'text','name'=>'address','size'=>'60','datatype'=>'','default'=>'','notetext'=>'请填写'.lang($this->modelName).'地址'],
            ['title'=>'显示状态','type'=>'radio','name'=>'status','size'=>'20','datatype'=>'','default'=>'1','notetext'=>'','radioList'=>[
                ['text'=>'可用','value'=>'1'],
                ['text'=>'禁用','value'=>'0'],
            ]],
            ['title'=>'排序','type'=>'text','name'=>'sort_order','size'=>'20','datatype'=>'','default'=>'1','notetext'=>''],
        ];
        return $field;
    }
}