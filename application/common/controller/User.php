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
        $this->adminType = $this->adminUser['admin_type'];
    }
    function del()
    {
        $this->error(lang('NO ACCESS'));
        $info = $this->_assignInfo();
        $group = db('user_group')->find($info['group_id']);
        if ($group['is_system'] || !$group['store_id']) {
            $this->error('管理员账号不允许删除');
        }
        parent::del();
    }
    
    function _getAlias()
    {
        return 'U';
    }
    function _getField(){
        return 'U.*, S.name as sname, G.name as gname, G.is_system';
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
            $data['password'] = $userModel->pwdEncryption($password);
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
        $where = [
            'is_del' => 0, 
            'status' =>1,
        ];
        if ($this->adminUser['admin_type'] != ADMIN_SYSTEM) {
            $where['group_type'] = 1;
        }
        $groups = db('user_group')->where($where)->select();
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