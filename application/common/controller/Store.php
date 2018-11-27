<?php
namespace app\common\controller;

//商户管理
class Store extends FormBase
{
    var $storeType;
    var $parent;
    var $groupId;
    var $adminType = 1;
    public function __construct()
    {
        $this->modelName = $this->modelName ? $this->modelName : 'store';
        $this->model = $this->model ? $this->model : model($this->modelName);
        parent::__construct();
        $this->groupId = 0;
        if ($this->adminUser['user_id'] != 1) {
            if ($this->adminUser['admin_type'] != 2 || $this->storeType == 1) {//厂商
                $this->error(lang('NO ACCESS'));
            }
        }
        
        if ($this->adminUser['admin_type'] != 2){
            $this->_getFactorys();
        }
        $this->search= self::_searchData();
        $this->table = self::_tableData();
        $this->field = self::_fieldData();
        $this->uploadUrl = url('admin/Upload/upload', ['prex' => 'store_logo_', 'thumb_type' => 'logo_thumb']);
    }
    public function manager()
    {
        $store = parent::_assignInfo();
        //判断当前厂商是否设置过管理员
        $userModel = new \app\common\model\User();
        $info = $userModel->where(['admin_type' => $this->adminType, 'store_id' => $store['store_id'], 'is_del' => 0])->find();
        if ($info) {
            $name = '编辑'.lang($this->modelName).'管理员';
            $where = ['user_id' => $info['user_id']];
        }else{
            $name = '新增'.lang($this->modelName).'管理员';
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
                $params['store_id'] = $store['store_id'];
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
            $this->assign('factory', $store);
            $this->assign('info', $info);
            return $this->fetch('store/manager');
        }
    }
    /**
     * 删除
     */
    function del(){
        $params = $this->request->param();
        $pkId = intval($params['id']);
        $info = parent::_assignInfo($pkId);
        //判断商户类型
        $storeType = $info['store_type'];
        if ($storeType == 1) {
            //判断厂商下是否存在其它商户
            $exist = $this->model->where(['store_id' => $pkId, 'is_del' => 0])->find();
            $msg = '厂商下存在其它商户，不允许删除';
        }else{
            $exist = [];
            #TODO 判断渠道商 经销商 服务商不能删除条件
            $msg = '';
        }
        if ($exist) {
            $this->error($msg);
        }
        parent::del();
    }
    function _afterDel($info = [])
    {
        if ($info) {
            //删除关联用户
            $user = db('user')->where(['store_id' => $info['store_id'], 'is_del' => 0])->update(['update_time' => time(), 'is_del' => 1]);
        }
        return TRUE;
    }
    function _assignInfo($pkId = 0){
        $info = parent::_assignInfo();
        if ($info) {
            switch ($info['store_type']) {
                case 1:
                    $model = 'factory';
                    break;
                case 2:
                    $model = 'channel';
                    break;
                case 3:
                    $model = 'dealer';
                    break;
                case 4:
                    $model = 'servicer';
                    break;
                default:
                    return FALSE;
                    break;
            }
            $detail = model($model)->where(['store_id' => $info['store_id']])->find();
            if ($detail) {
                $info = $info->toArray();
                $detail = $detail->toArray();
                $info = array_merge($info, $detail);
            }
            $user = db('user')->where(['store_id' => $info['store_id'], 'is_del' => 0, 'group_id' => $this->groupId])->find();
            $this->assign('user', $user);
        }
        $this->assign('info', $info);
        return $info;
    }
    function _getData()
    {
        $data = parent::_getData();
        $params = $this->request->param();
        $pkId = $params && isset($params['id']) ? intval($params['id']) : 0;
        $factoryId = $params && isset($params['factory_id']) ? intval($params['factory_id']) : 0;
        $address = $data && isset($data['address']) ? trim($data['address']) : '';
        $name = $data && isset($data['name']) ? trim($data['name']) : '';
        $domain = $data && isset($data['domain']) ? trim($data['domain']) : '';
        if ($this->storeType != 1) {
            if ($this->adminUser['store_id']) {
                $data['factory_id'] = $factoryId = $this->adminUser['store_id'];
            }
            if (!$factoryId) {
                $this->error('请选择所属厂商');
            }
        }
        if (!$name) {
            $this->error(lang($this->modelName).'名称不能为空');
        }
        $where = ['name' => $name, 'is_del' => 0, 'store_type' => $this->storeType];
        if ($this->storeType != 1) {
            $where['store_id'] = $factoryId;
        }
        if($pkId){
            $where['store_id'] = ['neq', $pkId];
        }
        $exist = $this->model->where($where)->find();
        if($exist){
            $this->error('当前'.lang($this->modelName).'名称已存在');
        }
        if ($this->storeType == 1) {
            if (!$domain) {
                $this->error(lang($this->modelName).'二级域名不能为空');
            }
            if (strtolower(trim($domain)) == 'admin') {
                $this->error('保留域名,不允许设置');
            }
            //验证二级域名是否唯一
            $where = ['SF.domain' => $domain, 'S.is_del' => 0];
            if($pkId){
                $where['S.store_id'] = ['neq', $pkId];
            }
            $exist = db('store_factory')->alias('SF')->join([['store S', 'S.store_id = SF.store_id', 'INNER']])->where($where)->find();
            if($exist){
                $this->error('二级域名已存在');
            }
        }
        $data['store_type'] = $this->storeType;
        return $data;
    }
    function _getAlias()
    {
        return 'S';
    }
    function _getField(){
        $field = 'S.name, U.*, AS.*, S.*';
        if ($this->storeType == 2) {
            $field .= ', CG.name as gname';
        }
        if ($this->storeType != 1) {
            $field .= ', S1.name as sname';
        }
        return $field;
    }
    function _getJoin()
    {
        $join[] = ['user U', 'U.store_id = S.store_id AND U.admin_type = '.$this->adminType, 'LEFT'];
        switch ($this->storeType) {
            case 1://厂商
                $tabel = 'store_factory AS';
                break;
            case 2://渠道商
                $tabel = 'store_channel AS';
                break;
            case 3://经销商
                $tabel = 'store_dealer AS';
                break;
            case 4://服务商
                $tabel = 'store_servicer AS';
                break;
            default:
                $this->error(lang('PARAM_ERROR'));
                return FALSE;
                break;
        }
        $join[] = [$tabel, 'S.store_id = AS.store_id', 'INNER'];
        if ($this->storeType == 2) {
            $join[] = ['channel_grade CG', 'CG.cgrade_id = AS.cgrade_id', 'LEFT'];
        }
        if ($this->storeType != 1) {
            $join[] = ['store S1', 'S.factory_id = S1.store_id', 'LEFT'];
        }
        return $join;
    }
    function  _getOrder()
    {
        return 'S.sort_order ASC, S.add_time DESC';   
    }
    function _getWhere(){
        $where = [
            'S.is_del'      => 0,
            'S.store_type'  => $this->storeType,
        ];
        if ($this->adminUser['admin_type'] == 2) {
            $where['S.factory_id'] = $this->adminUser['store_id'];
        }
        $params = $this->request->param();
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['S.name'] = ['like','%'.$name.'%'];
            }
        }
        return $where;
    }
    function _getFactorys()
    {
        //获取所属厂商列表
        $stores = db('store')->where(['is_del' => 0, 'status' => 1, 'store_type' => 1])->field('store_id as id, name as cname')->select();
        $this->assign('factorys', $stores);
    }
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $search = [
            ['type' => 'input', 'name' =>  'name', 'value' => lang($this->modelName).'名称', 'width' => '20'],
        ];
        return $search;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $array = [];
        if ($this->storeType == 1) {
            $array = ['title'     => '二级域名','width'  => '100','value'     => 'domain','type'      => 'text'];
        }else{
            $array = ['title'     => '所属厂商','width'  => '100','value'     => 'sname','type'      => 'text'];
        }
        $table = [
            ['title'     => '编号','width'    => '60','value'      => 'factory_id','type'      => 'index'],
            $array,
            ['title'     => lang($this->modelName).'名称','width'  => '*','value'   => 'name','type'      => 'text'],
            ['title'     => 'LOGO', 'width'   => '60','value'     => 'logo', 'type'      => 'image'],
            ['title'     => '管理员账号','width' => '120','value'     => 'username','type'      => 'text'],
            ['title'     => lang($this->modelName).'地址','width'  => '*','value'       => 'address','type'      => 'text'],
            ['title'     => '状态','width'    => '60','value'      => 'status','type'      => 'yesOrNo', 'yes'       => '可用','no'        => '禁用'],
            ['title'     => '排序','width'    => '60','value'      => 'sort_order','type'      => 'text'],
            ['title'     => '操作','width'    => '*','value'   => 'store_id','type'      => 'button','button'    =>
                [
                    ['text'  => '管理员','action'=> 'manager', 'icon'  => 'user','bgClass'=> 'bg-yellow',],
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
        if ($this->storeType != 1) {
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