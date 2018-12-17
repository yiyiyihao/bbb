<?php
namespace app\common\controller;

//商户管理
class Store extends FormBase
{
    var $storeType;
    var $groupId;
    var $adminType;
    public function __construct()
    {
        $this->modelName = $this->modelName ? $this->modelName : 'store';
        $this->model = $this->model ? $this->model : model($this->modelName);
        parent::__construct();
        $this->_init();
        if ($this->adminUser['admin_type'] != ADMIN_SYSTEM) {
            if ($this->storeType == STORE_FACTORY) {
                $this->error(lang('NO ACCESS'));
            }else{
                if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
                    if (!($this->storeType == STORE_DEALER && $this->adminUser['admin_type'] == ADMIN_CHANNEL) || $this->storeType != STORE_DEALER) {
                        $this->error(lang('NO ACCESS'));
                    }
                }
            }
        }
        if (!$this->adminUser['store_id']){
            $this->_getFactorys();
        }
        $this->uploadUrl = url('Upload/upload', ['prex' => 'store_logo_', 'thumb_type' => 'logo_thumb']);
    }
    public function manager()
    {
        $store = $this->_assignInfo();
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
        $this->error(lang('NO ACCESS'));
        $params = $this->request->param();
        $pkId = intval($params['id']);
        $info = $this->_assignInfo($pkId);
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
            if ($this->adminUser['admin_type'] != 1) {
                if ($info['factory_id'] != $this->adminFactory['store_id']) {
                    $this->error(lang('NO ACCESS'));
                }
                if ($this->adminUser['admin_type'] != 2 && $this->adminStore['store_id'] != $detail['ostore_id']) {
                    $this->error(lang('NO ACCESS'));
                }
            }
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
        $domain = $data && isset($data['domain']) ? strtolower(trim($data['domain'])) : '';
        if ($this->storeType != 1) {
            if ($this->adminUser['store_id']) {
                $data['factory_id'] = $factoryId = $this->adminFactory['store_id'];
            }
            if ($this->adminUser['admin_type'] > 2) {
                $data['ostore_id'] = $factoryId = $this->adminStore['store_id'];
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
            //判断域名前缀是否可设置
            $sysKeepDomins = config('app.system_keeps_domain');;
            if (in_array($domain, $sysKeepDomins)) {
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
        $data['config_json'] = '';
        $data['store_type'] = $this->storeType;
        return $data;
    }
    function _getAlias()
    {
        return 'S';
    }
    function _getField(){
        $field = 'S.name, U.*, AS.*, S.*';
        if ($this->storeType == STORE_CHANNEL) {
            $field .= ', CG.name as gname';
        }elseif ($this->storeType == STORE_DEALER){
            $field .= ', S2.name as cname';
        }
        if ($this->storeType != STORE_FACTORY) {
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
        if ($this->storeType == STORE_CHANNEL) {
            $join[] = ['channel_grade CG', 'CG.cgrade_id = AS.cgrade_id', 'LEFT'];
        }elseif ($this->storeType == STORE_DEALER){
            $join[] = ['store S2', 'S2.store_id = AS.ostore_id', 'LEFT'];
        }
        if ($this->storeType != STORE_FACTORY) {
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
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $where['S.factory_id'] = $this->adminUser['store_id'];
        }elseif ($this->adminUser['admin_type'] == ADMIN_DEALER && $this->storeType == STORE_DEALER){
            $where['AS.ostore_id'] = $this->adminUser['store_id'];
        }
        $params = $this->request->param();
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['S.name'] = ['like','%'.$name.'%'];
            }
            $uname = isset($params['uname']) ? trim($params['uname']) : '';
            if($uname){
                $where['S.user_name|S.mobile'] = ['like','%'.$uname.'%'];
            }
        }
        return $where;
    }
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $search = [
            ['type' => 'input', 'name' =>  'name', 'value' => lang($this->modelName).'名称', 'width' => '30'],
            ['type' => 'input', 'name' =>  'uname', 'value' => '联系人姓名/电话', 'width' => '30'],
        ];
        return $search;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = parent::_tableData();
        $btnArray = [];
        $btnArray = ['text'  => '管理员','action'=> 'condition', 'icon'  => 'user','bgClass'=> 'bg-green','condition'=>['action'=>'manager','rule'=>'$vo["store_id"] != 1']];
        $table['actions']['button'][] = $btnArray;
        $table['actions']['width']  = '210';
        return $table;
    }
    /**
     * 详情字段配置
     */
    function _fieldData(){
        $array = $array1 = $array2 = $array3 = [];
        if ($this->storeType != STORE_FACTORY) {
            if ($this->adminUser['admin_type'] != ADMIN_SYSTEM){
                $array = ['title'=>'厂商名称','type'=>'text','name'=>'','size'=>'40','default'=> $this->adminFactory['name'], 'disabled' => 'disabled'];
            }else{
                $array = ['title'=>'所属厂商','type'=>'select','options'=>'factorys','name' => 'factory_id', 'size'=>'40' , 'datatype'=>'', 'default'=>'','default_option'=>'==所属厂商==','notetext'=>'请选择所属厂商'];
            }
        }else{
            $array = ['title'=>'二级域名','type'=>'text','name'=>'domain','size'=>'20','datatype'=>'','default'=>'','notetext'=>lang($this->modelName).'二级域名不能重复'];
        }
        if ($this->storeType == STORE_DEALER && $this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $channels = $this->model->field('store_id as id, name as cname')->where(['factory_id' => $this->adminUser['store_id'], 'store_type' => STORE_CHANNEL, 'is_del' => 0, 'status' => 1])->select();
            $this->assign('channels', $channels);
            $array1= ['title'=>'所属渠道商','type'=>'select','options'=>'channels','name' => 'ostore_id', 'size'=>'40' , 'datatype'=>'*', 'default'=>'','default_option'=>'==所属渠道商==','notetext'=>'请选择所属渠道商'];
        }
        if (in_array($this->storeType, [STORE_CHANNEL, STORE_SERVICE])) {
            $array2 = ['title'=>'保证金金额','type'=>'text','name'=>'security_money','size'=>'10','datatype'=>'*','default'=>'','notetext'=>'请填写保证金金额'];
            $array3 = ['title'=>'负责区域','type'=>'region','length'=>2,'name'=>'region_id','size'=>'30','datatype'=>'*','default'=>'','notetext'=>'请选择负责区域'];
        }
        $field = [
            $array, $array1,
            ['title'=>lang($this->modelName).'名称','type'=>'text','name'=>'name','size'=>'40','datatype'=>'*','default'=>'','notetext'=>lang($this->modelName).'名称请不要填写特殊字符'],
            ['title'=>'Logo','type'=>'uploadImg','name'=>'logo', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>''],
            ['title'=>lang($this->modelName).'联系人姓名','type'=>'text','name'=>'user_name','size'=>'20','datatype'=>'*','default'=>'','notetext'=>'请填写'.lang($this->modelName).'联系人姓名'],
            ['title'=>lang($this->modelName).'联系电话','type'=>'text','name'=>'mobile','size'=>'20','datatype'=>'*','default'=>'','notetext'=>'请填写'.lang($this->modelName).'联系电话'],
            $array2,
            $array3,
            ['title'=>lang($this->modelName).'地址','type'=>'text','name'=>'address','size'=>'60','datatype'=>'','default'=>'','notetext'=>'请填写'.lang($this->modelName).'地址'],
            ['title'=>'显示状态','type'=>'radio','name'=>'status','size'=>'20','datatype'=>'','default'=>'1','notetext'=>'','radioList'=>[
                ['text'=>'可用','value'=>'1'],
                ['text'=>'禁用','value'=>'0'],
            ]],
            ['title'=>'排序','type'=>'text','name'=>'sort_order','size'=>'20','datatype'=>'','default'=>'1','notetext'=>''],
        ];
        return array_filter($field);
    }
    function _init()
    {
        
    }
}