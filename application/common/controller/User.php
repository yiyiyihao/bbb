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
        $info = $this->_assignInfo();
        if ($info['admin_type'] != $this->adminUser['admin_type']) {
            $this->error(lang('NO_OPERATE_PERMISSION'));
        }
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
            $phone = isset($params['phone']) ? trim($params['phone']) : '';
            if($phone){
                $where['U.phone'] = ['like','%'.$phone.'%'];
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
        $phone =  isset($data['phone']) ? trim($data['phone']) : '';
        
        $groupId = $params && isset($params['group_id']) ? intval($params['group_id']) : 0;
        if (!$pkId) {
            if (!$username) {
                $this->error('登录用户名不能为空');
            }
            if (!$password) {
                $this->error('登录密码不能为空');
            }
            if (!$groupId) {
                $this->error('请选择账户角色');
            }
        }
        if (!$phone) {
            $this->error('手机号不能为空');
        }
        $userModel = new \app\common\model\User();
        $result = $userModel->checkFormat($params);
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
        if ($info && $info['group_id']) {
            $info['group'] = db('user_group')->find($info['group_id']);
            $this->assign('info', $info);
        }
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
            ['type' => 'input', 'name' =>  'phone', 'value' => '手机号', 'width' => '30'],
        ];
        return $search;
    }
}