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
    /**
     * 重置密码
     */
    public function resetpwd($user = [])
    {
        $params = $this->request->param();
        $userId = isset($params['id']) ? intval($params['id']) : 0;
        if (!$userId){
            $this->error(lang('ERROR'));
        }
        $userModel = new \app\common\model\User();
        $user = $userModel->find($userId);
        if (!$user || $user['is_del']){
            $this->error('账户不存在或已删除');
        }
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
            if (!$this->adminUser['store_id']) {
                $this->error(lang('NO ACCESS'));
            }
            if ($this->adminUser['admin_type'] != $user['admin_type']) {
                $this->error(lang('NO ACCESS'));
            }
        }
        $phone = $user['phone'];
        if (!$phone){
            $this->error('当前账户未绑定手机号');
        }
        $password = get_nonce_str(8, 2);//账户初始密码
        $data = [
            'pwd_modify' => 1,
            'password'  => $userModel->pwdEncryption($password)
        ];
        $result = $userModel->save($data, ['user_id' => $userId]);
        if ($result){
            $informModel = new \app\common\model\LogInform();
            $extra = ['name' => $user['nickname'], 'password' => $password];
            $result = $informModel->sendInform($this->adminUser['store_id'], 'sms', $user, 'reset_pwd', $extra);
            if ($result === FALSE) {
                $this->error($informModel->error);
            }else {
                if ($result !== FALSE) {
                    $this->success('重置密码成功');
                }else{
                    $this->error('重置密码错误:'.$result['result']);
                }
            }
        }else{
            $this->error(lang('system_error'));
        }
    }
    function del()
    {
        $info = $this->_assignInfo();
        if ($info['admin_type'] != $this->adminUser['admin_type']) {
            $this->error(lang('NO_OPERATE_PERMISSION'));
        }
        $group = db('user_group')->find($info['group_id']);
        if ($group['is_system']) {
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
        $result = $userModel->checkFormat($this->adminUser['factory_id'], $params);
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
            'is_del'    => 0, 
            'status'    => 1,
        ];
        if ($this->adminUser['admin_type'] != ADMIN_SYSTEM) {
            $where['group_type'] = 2;
            $where['store_type'] = $this->adminStore['store_type'];
            $where['is_system'] = 0;
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
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = parent::_tableData();
        $table['actions']['button'][] = ['text'  => '重置密码','action'=> 'resetpwd', 'icon'  => '','bgClass'=> 'bg-yellow', 'value' => 'user_id', 'js-action' => TRUE];
        $table['actions']['width']  = '*';
        foreach ($table['actions']['button'] as $key => $value) {
            if ($value['action'] == 'del') {
                $table['actions']['button'][$key] = ['text'  => '删除', 'js-action' => TRUE, 'action'=> 'condition', 'icon'  => 'delete','bgClass'=> 'bg-red','condition'=>['action'=>'del','rule'=>'$vo["is_system"] == 0']];
            }
        }
        return $table;
    }
}