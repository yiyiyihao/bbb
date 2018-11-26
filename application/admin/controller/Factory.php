<?php
namespace app\admin\controller;
use app\common\controller\FormBase;

//厂商管理
class Factory extends FormBase
{
    var $adminType;
    var $groupId;
    public function __construct()
    {
        $this->modelName = 'factory';
        $this->model = db($this->modelName);
        $this->adminType = 2;//厂商
        $this->groupId = 1;
        parent::__construct();
        $this->search= self::_searchData();
        $this->table = self::_tableData();
        $this->field = self::_fieldData();
        $this->uploadUrl = url('admin/Upload/upload', ['prex' => 'goods_', 'thumb_type' => 'goods_thumb']);
    }
    public function manager()
    {
        $factory = parent::_assignInfo();
        $factoryId = intval($factory['factory_id']);
        //判断当前厂商是否设置过管理员
        $userModel = new \app\common\model\User();
        $info = $userModel->where(['admin_type' => $this->adminType, 'link_id' => $factoryId, 'is_del' => 0])->find();
        if ($info) {
            $name = '编辑厂商管理员';
            $where = ['user_id' => $info['user_id']];
        }else{
            $name = '新增厂商管理员';
            $where = [];
        }
        if (IS_POST) {
            $params = $this->request->param();
            $username = isset($params['username']) ? trim($params['username']) : '';
            $password = isset($params['password']) ? trim($params['password']) : '';
            if (isset($params['id'])) {
                unset($params['id']);
            }
            if (!$info) {
                if (!$username) {
                    $this->error('登录用户名不能为空');
                }
                if (!$password) {
                    $this->error('登录密码不能为空');
                }
            }
            $params['user_id'] = $info ? $info['user_id'] : 0;
            $result = $userModel->_checkFormat($params);
            if ($result === FALSE) {
                $this->error($userModel->error);
            }
            if ($params['password']) {
                $params['password'] = $userModel->pwdEncryption(trim($params['password']));
            }
            if (!$info) {
                $params['admin_type'] = $this->adminType;
                $params['link_id'] = $factoryId;
                $params['group_id'] = $this->groupId;
            }
            $result = $userModel->save($params, $where);
            if ($result) {
                $this->success($name.lang('SUCCESS'), url('index'));
            }else{
                $this->error($userModel->error);
            }
        }else{
            $this->assign("name", $name);
            $this->assign('factory', $factory);
            $this->assign('info', $info);
            return $this->fetch();
        }
    }
    public function del(){
        $info = parent::_assignInfo();
        parent::del();
    }
    function _afterDel($info = FALSE){
        $result = db('user')->where(['admin_type' => $this->adminType, 'group_id' => $this->groupId, 'link_id' => $info['factory_id']])->update(['update_time' => time(), 'admin_type' => 0, 'group_id' => 0, 'link_id' => 0]);
        return TRUE;
    }
    function _getData(){
        $data = parent::_getData();
        $params = $this->request->param();
        $pkId = $params && isset($params['id']) ? intval($params['id']) : 0;
        
        $name = $data && isset($data['name']) ? trim($data['name']) : '';
        $domain = $data && isset($data['domain']) ? trim($data['domain']) : '';
        
        if (!$name) {
            $this->error('厂商名称不能为空');
        }
        $where = ['name' => $name, 'is_del' => 0];
        if($pkId){
            $where['factory_id'] = ['neq', $pkId];
        }
        $exist = $this->model->where($where)->find();
        if($exist){
            $this->error('厂商名称已存在,请重新输入');
        }
        if (!$domain) {
            $this->error('厂商二级域名不能为空');
        }
        $where = ['domain' => $domain, 'is_del' => 0];
        if($pkId){
            $where['factory_id'] = ['neq', $pkId];
        }
        $exist = $this->model->where($where)->find();
        if($exist){
            $this->error('厂商二级域名已存在,请重新输入');
        }
        if (isset($data['file'])) {
            unset($data['file']);
        }
        return $data;
    }
    function _getAlias()
    {
        return 'F';
    }
    function _getField(){
        $field = 'U.username, F.name, F.*';
        return $field;
    }
    function _getJoin()
    {
        $join[] = ['user U', 'F.factory_id = U.link_id AND U.admin_type = '.$this->adminType, 'LEFT'];
        return $join;
    }
    function _getOrder()
    {
        return 'F.sort_order ASC, F.add_time DESC';
    }
    function _getWhere(){
        $where = [
            'F.is_del'      => 0,
        ];
        $params = $this->request->param();
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['F.name'] = ['like','%'.$name.'%'];
            }
        }
        return $where;
    }
    /**
     * 列表搜索配置
     */
    private function _searchData(){
        $search = [
            ['type' => 'input', 'name' =>  'name', 'value' => '厂商名称', 'width' => '20'],
        ];
        return $search;
    }
    /**
     * 列表项配置
     */
    private function _tableData(){
        $table = [
            ['title'     => '编号','width'    => '60','value'      => 'factory_id','type'      => 'index'],
            ['title'     => '厂商名称','width'  => '200','value'     => 'name','type'      => 'text'],
            ['title'     => '二级域名','width'  => '100','value'     => 'domain','type'      => 'text'],
            ['title'     => 'LOGO','width'   => '60','value'     => 'logo', 'type'      => 'image'],
            ['title'     => '管理员账号','width' => '120','value'     => 'username','type'      => 'text'],
            ['title'     => '厂商地址','width'  => '*','value'       => 'address','type'      => 'text'],
            ['title'     => '状态','width'    => '60','value'      => 'status','type'      => 'yesOrNo', 'yes'       => '可用','no'        => '禁用'],
            ['title'     => '排序','width'    => '60','value'      => 'sort_order','type'      => 'text'],
            ['title'     => '操作','width'    => '*','value'   => 'factory_id','type'      => 'button','button'    =>  
                [
                    ['text'  => '管理员','action'=> 'manager', 'icon'  => 'user','bgClass'=> 'bg-yellow',],
                    ['text'  => '编辑','action'=> 'edit','icon'  => 'edit','bgClass'=> 'bg-main'],
                    ['text'  => '删除','action'=> 'del','icon'  => 'delete','bgClass'=> 'bg-red']
                ]
            ]
        ];
        return $table;
    }
    /**
     * 详情字段配置
     */
    private function _fieldData(){
        $field = [
            ['title'=>'厂商名称','type'=>'text','name'=>'name','size'=>'40','datatype'=>'*','default'=>'','notetext'=>'厂商名称请不要填写特殊字符'],
            ['title'=>'二级域名','type'=>'text','name'=>'domain','size'=>'20','datatype'=>'','default'=>'','notetext'=>'厂商二级域名不能重复'],
            ['title'=>'厂商Logo','type'=>'uploadImg','name'=>'logo','size'=>'20','datatype'=>'','default'=>'','notetext'=>''],
            ['title'=>'厂商地址','type'=>'text','name'=>'address','size'=>'60','datatype'=>'','default'=>'','notetext'=>'请填写厂商地址'],
            ['title'=>'显示状态','type'=>'radio','name'=>'status','size'=>'20','datatype'=>'','default'=>'1','notetext'=>'','radioList'=>[
                ['text'=>'可用','value'=>'1'],
                ['text'=>'禁用','value'=>'0'],
            ]],
            ['title'=>'排序','type'=>'text','name'=>'sort_order','size'=>'20','datatype'=>'','default'=>'1','notetext'=>''],
        ];
        return $field;
    }
}