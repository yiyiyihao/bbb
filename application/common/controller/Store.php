<?php
namespace app\common\controller;

//商户管理
class Store extends FormBase
{
    var $storeType;
    var $groupId = 0;
    var $adminType;
    public function __construct()
    {
        $this->modelName = $this->modelName ? $this->modelName : 'store';
        $this->model = new \app\common\model\Store();
        parent::__construct();
        $this->_init();
        $this->uploadUrl = url('Upload/upload', ['prex' => 'store_profile_', 'thumb_type' => 'profile_thumb']);
        //系统管理员、厂商 直接通过
        if (in_array($this->adminUser['admin_type'],[ADMIN_SYSTEM,ADMIN_FACTORY])){
            return true;
        }
        //厂商列表
        if ($this->storeType == STORE_FACTORY) {
            $this->error(lang('NO ACCESS'));
        }
        //零售商列表
        if ($this->storeType == STORE_DEALER && !in_array($this->adminUser['admin_type'],[ADMIN_CHANNEL,ADMIN_SERVICE_NEW])) {
            $this->error(lang('NO ACCESS'));
        }
        //渠道商列表
        if ($this->storeType == STORE_CHANNEL && !in_array($this->adminUser['admin_type'],[ADMIN_FACTORY])) {
            $this->error(lang('NO ACCESS'));
        }

        //新服务商列表
        if ($this->storeType == STORE_SERVICE_NEW && !in_array($this->adminUser['admin_type'],[ADMIN_FACTORY])) {
            $this->error(lang('NO ACCESS'));
        }

        //if ($this->adminUser['admin_type'] != ADMIN_SYSTEM) {
        //    if ($this->storeType == STORE_FACTORY) {
        //        $this->error(lang('NO ACCESS'));
        //    }else{
        //        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
        //            if (!($this->storeType == STORE_DEALER && $this->adminUser['admin_type'] == ADMIN_CHANNEL) || $this->storeType != STORE_DEALER) {
        //                $this->error(lang('NO ACCESS'));
        //            }
        //        }
        //    }
        //}
    }
    public function manager()
    {
        $store = $this->_assignInfo();
        if ($store['check_status'] != 1) {
            $this->error('商户审核未通过');
        }
        //判断当前厂商是否设置过管理员
        $userModel = new \app\common\model\User();
        $info = $userModel->where(['admin_type' => $this->adminType, 'is_admin' => 1, 'store_id' => $store['store_id'], 'is_del' => 0])->find();
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
            $phone = isset($params['phone']) ? trim($params['phone']) : '';
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
            if (!$phone) {
                $this->error('管理员手机号不能为空');
            }
            $params['user_id'] = $info ? $info['user_id'] : 0;
            $result = $userModel->checkFormat($this->adminUser['factory_id'], $params);
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
                $params['is_admin'] = 1;
                $params['factory_id'] = $this->adminFactory['store_id'];
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
    public function resetpwd()
    {
        $params = $this->request->param();
//         $user = db('user')->where(['user_id' => $params['id']])->find();
//         if (!$user) {
//             $this->error('管理员不存在');
//         }
        $info = $this->model->getStoreDetail($params['id']);
        if ($info['check_status'] != 1) {
            $this->error('商户审核未通过');
        }
        $manager = $info['manager'];
        if (!$manager) {
            $this->error('未添加管理员');
        }
        if (!$manager['phone']) {
            $this->error('管理员未填写手机号');
        }
        $userController = new \app\common\controller\User();
        return $userController->resetpwd($manager['user_id']);
    }
    /**
     * 商户详情
     */
    public function detail()
    {
        $info = $this->_assignInfo();
        $this->assign('info', $info);
        return $this->fetch('admin@store/detail');
    }
    private function _check()
    {
        $check = TRUE;
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $check = FALSE;
        }else{
            $config = get_store_config($this->adminUser['factory_id'], TRUE, 'default');
            $check = isset($config['channel_operate_check']) ? intval($config['channel_operate_check']) : 0;
        }
        return $check;
    }
    
    public function add()
    {
        $check = $this->_check();
        if (!$check) {
            return parent::add();
        }else{
            $params = $this->request->param();
            if (IS_POST) {
                $data = $this->_getData();
                $data = [
                    'factory_id'        => $this->adminUser['factory_id'],
                    'action_store_id'   => $this->adminUser['store_id'],
                    'action_user_id'    => ADMIN_ID,
                    'to_store_id'       => 0,
                    'to_store_name'     => isset($data['name']) ? trim($data['name']) : '',
                    'action_type'       => 'add',
                    'before'            => '',
                    'after'             => $data ? json_encode($data): '',
                    'modify'            => $data ? json_encode($data): '',
                    'check_status'      => 0,
                    'add_time'          => time(),
                    'update_time'       => time(),
                ];
                $result = db('store_action_record')->insertGetId($data);
                if ($result === FALSE) {
                    $this->error('系统错误');
                }else{
                    $this->success('新增商户操作提交，等待厂商审核', url('storeaction/index', ['status' => 0]));
                }
            }else{
                return parent::add();
            }
        }
    }
    private function _beforeUpdate()
    {
        $info = $this->_assignInfo();
        //判断对象是否存在待处理的申请
        $exist = db('store_action_record')->where(['to_store_id' => $info['store_id'], 'check_status' => 0])->find();
        if ($exist) {
            if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
                $this->error('当前商户存在待审核的操作记录,请前往审核', url('storeaction/check', ['id' => $exist['record_id']]));
            }else{
                $this->error('当前商户存在待审核的操作记录,请等待审核');
            }
        }
    }
    public function edit()
    {
        $this->_beforeUpdate();
        $check = $this->_check();
        if (!$check) {
            return parent::edit();
        }else{
            $info = $this->_assignInfo();
            //判断是否已存在未处理的编辑申请
            $exist = db('store_action_record')->where(['to_store_id' => $info['store_id'], 'action_type' => 'edit', 'check_status' => 0])->find();
            if ($exist) {
                $this->error('存在待审核的编辑操作');
            }
            $params = $this->request->param();
            if (IS_POST) {
                $data = $this->_getData();
                if (!isset($info['ostore_id']) || $info['ostore_id'] != $this->adminUser['store_id']) {
                    $this->error(lang('NO ACCESS'));
                }
                $temp = [];
                foreach ($info as $key => $value) {
                    if (isset($data[$key]) && $data[$key] != $value && $key != 'update_time') {
                        $temp[$key] = $data[$key];
                    }
                }
                if ($temp) {
                    $data = [
                        'factory_id'        => $this->adminUser['factory_id'],
                        'action_store_id'=> $this->adminUser['store_id'],
                        'action_user_id'=> ADMIN_ID,
                        'to_store_id'   => $info['store_id'],
                        'to_store_name' => isset($info['name']) ? trim($info['name']) : '',
                        'action_type'   => 'edit',
                        'before'         => $info ? json_encode($info): '',
                        'after'         => $data ? json_encode($data): '',
                        'modify'        => $temp ? json_encode($temp): '',
                        'check_status'  => 0,
                        'add_time'      => time(),
                        'update_time'    => time(),
                    ];
                    $result = db('store_action_record')->insertGetId($data);
                    if ($result === FALSE) {
                        $this->error('系统错误');
                    }else{
                        $this->success('编辑商户操作提交，等待厂商审核', url('storeaction/index', ['status' => 0]));
                    }
                }else{
                    $this->error('未修改商户信息');
                }
            }else{
                return parent::edit();
            }
        }
    }
    
    /**
     * 删除
     */
    public function del(){
        $params = $this->request->param();
        $storeId = isset($params['id']) ? intval($params['id']): 0;
        $this->_beforeUpdate();
        $check = $this->_check();
        $result = $this->model->del($storeId, $this->adminUser, $check);
        if ($result === FALSE) {
            $this->error($this->model->error);
        }else{
            if ($this->adminUser['admin_type'] == ADMIN_CHANNEL) {
                $this->success('删除商户操作提交，等待厂商审核');
            }else{
                $this->success('删除成功');
            }
        }
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
                case 6:
                    $model = 'servicer';
                    $bank=db('store_bank')->where(['bank_type'=>1,'store_id'=>$info['store_id'],'status'=>1,'is_del'=>0])->find();
                    $this->assign('bank', $bank);
                    $financeModel = new \app\common\model\StoreFinance();
                    $finance = $financeModel->financeDetail($info['store_id']);
                    $serviceCount = db('work_order')->where(['store_id' => $info['store_id'], 'sign_time' => ['>', 0]])->count();
                    $this->assign('finance', $finance);
                    $this->assign('service_count', $serviceCount);
                    break;
                default:
                    return FALSE;
                    break;
            }
            $detail = model($model)->where(['store_id' => $info['store_id']])->find();
            if ($this->adminUser['admin_type'] != ADMIN_SYSTEM) {
                if ($info['factory_id'] != $this->adminFactory['store_id']) {
                    $this->error(lang('NO ACCESS'));
                }
                if (!in_array($this->adminUser['admin_type'], [ADMIN_FACTORY, ADMIN_CHANNEL]) && $this->adminStore['store_id'] != $detail['ostore_id']) {
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
            if ($info['store_type'] == STORE_DEALER) {
                //获取渠道商名称
                $info['channel_name'] = $this->model->where(['store_id' => $info['ostore_id']])->value('name');
            }
        }
        $this->assign('info', $info);
        return $info;
    }
    function _afterList($list)
    {
        if ($list) {
            foreach ($list as $key => $value) {
                $flag = $this->model->checkDel($value, $this->adminUser);
                $list[$key]['unset_del'] = $flag === FALSE ? 1: 0;
                switch ($this->storeType) {
                    case STORE_DEALER:
                        //计算订单金额 订单数量
                        $order = db('order')->field('count(order_id) as num, sum(real_amount) as amount')->where(['user_store_id' => $value['store_id'], 'pay_status' => 1])->find();
                        $list[$key]['order_num'] = $order ? intval($order['num']) : 0;
                        $list[$key]['order_amount'] = $order ? floatval($order['amount']) : 0;
                        $list[$key]['address'] = $value['region_name'].' '.$value['address'];
                        break;
                    case STORE_CHANNEL:
                        //所属零售商数量
                        $where = [
                            'S.store_type'  => STORE_DEALER,
                            'S.is_del'      => 0,
                            'S.check_status'=> 1,
                            'SD.ostore_id'  => $value['store_id'],
                        ];
                        $join = [
                            ['store_dealer SD', 'S.store_id = SD.store_id', 'INNER'],
                        ];
                        $list[$key]['dealer_count'] = db('store')->alias('S')->join($join)->where($where)->count();
                        break;
                    case STORE_SERVICE:
                        //服务次数
                        $list[$key]['service_count'] = db('work_order')->where(['store_id' => $value['store_id'], 'sign_time' => ['>', 0]])->count();
                        break;
                    case STORE_SERVICE_NEW:
                        //服务次数
                        $list[$key]['service_count'] = db('work_order')->where(['store_id' => $value['store_id'], 'sign_time' => ['>', 0]])->count();
                        //所属零售商数量
                        $where = [
                            'S.store_type'  => STORE_DEALER,
                            'S.is_del'      => 0,
                            'S.check_status'=> 1,
                            'SD.ostore_id'  => $value['store_id'],
                        ];
                        $join = [
                            ['store_dealer SD', 'S.store_id = SD.store_id', 'INNER'],
                        ];
                        $list[$key]['dealer_count'] = db('store')->alias('S')->join($join)->where($where)->count();
                        break;
                    default:
                        ;
                        break;
                }
            }
        }
        return $list;
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
            if (in_array($this->adminUser['admin_type'],[ADMIN_CHANNEL,ADMIN_SERVICE_NEW])) {
                $data['ostore_id'] = $this->adminStore['store_id'];
            }
            if (!$factoryId) {
                $this->error('请选择所属厂商');
            }
        }
        if (!$name) {
            $this->error(lang($this->modelName).'名称不能为空');
        }
        $where = ['name' => $name, 'is_del' => 0, 'store_type' => $this->storeType];
        if ($this->storeType != STORE_FACTORY) {
            $where['factory_id'] = $factoryId;
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
        if (!$pkId) {
            $data['config_json'] = '';
            $data['check_status'] = 1;
        }
        $data['store_type'] = $this->storeType;
        if (isset($data['sample_amount']) && $data['sample_amount']) {
            $data['sample_amount'] = floatval($data['sample_amount']);
        }
        return $data;
    }
    function _getAlias()
    {
        return 'S';
    }
    function _getField(){
        $field = 'S.name, U.*, SS.*, S.*';
        if ($this->storeType != STORE_FACTORY) {
            $field .= ', S1.name as sname';
            if ($this->storeType == STORE_DEALER){
                $field .= ', S2.name as cname';
            }
            switch ($this->storeType) {
                case STORE_DEALER:
                    break;
                case STORE_CHANNEL:
                case STORE_SERVICE:
                case STORE_SERVICE_NEW:
                    $field .= ', SS.*';
                    break;
                default:
                    ;
                    break;
            }
        }
        $field .= ', S.store_id';
        return $field;
    }
    function _getJoin()
    {
        $join[] = ['user U', 'U.store_id = S.store_id AND is_admin = 1 AND U.admin_type = '.$this->adminType, 'LEFT'];
        switch ($this->storeType) {
            case 1://厂商
                $tabel = 'store_factory SS';
                break;
            case 2://渠道商
                $tabel = 'store_channel SS';
                break;
            case 3://经销商
                $tabel = 'store_dealer SS';
                break;
            case 4://服务商
                $tabel = 'store_servicer SS';
                break;
            case 6://新服务商
                $tabel = 'store_dealer SS';
                break;
            default:
                $this->error(lang('PARAM_ERROR'));
                return FALSE;
                break;
        }
        $join[] = [$tabel, 'S.store_id = SS.store_id', 'INNER'];
        switch ($this->storeType) {
            case STORE_DEALER:
                $join[] = ['store S2', 'S2.store_id = SS.ostore_id', 'LEFT'];
            break;
            case STORE_SERVICE:
            case STORE_CHANNEL:
                $join[] = ['store_finance SF', 'SF.store_id = S.store_id', 'LEFT'];
            break;
            default:
                ;
            break;
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
        $params = $this->request->param();
        $status = isset($params['status']) ? intval($params['status']) : 1;
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $status = 1;
        }
        $where = [
            'S.is_del'      => 0,
            'S.store_type'  => $this->storeType,
            'S.check_status'=> $status,
        ];
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $where['S.factory_id'] = $this->adminUser['store_id'];
        }elseif ($this->storeType == STORE_DEALER && in_array($this->adminUser['admin_type'],[ADMIN_CHANNEL,ADMIN_SERVICE_NEW])){
            $where['SS.ostore_id'] = $this->adminUser['store_id'];
        }
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
        if ($this->storeType == STORE_DEALER && $this->adminUser['admin_type'] == ADMIN_CHANNEL) {
            foreach ($table as $key => $value) {
                if (isset($value['value']) && $value['value'] == 'cname') {
                    unset($table[$key]);
                    break;
                }
            }
        }
        if ($table['actions']['button']) {
            $table['actions']['button']= [
                ['text'  => '查看详情','action'=> 'detail', 'icon'  => 'detail','bgClass'=> 'bg-green'],
                ['text'  => '编辑','action'=> 'condition', 'icon'  => 'pencil','bgClass'=> 'bg-main','condition'=>['action'=>'edit','rule'=>'$vo["check_status"] == 1']],
                ['text'  => '删除','action'=> 'condition', 'js-action' => TRUE, 'icon'  => 'delete','bgClass'=> 'bg-red','condition'=>['action'=>'del','rule'=>'$vo["check_status"] == 1 && (!isset($vo["unset_del"]) || $vo["unset_del"] != 1)']],
                ['text'  => '管理员','action'=> 'condition', 'icon'  => 'user','bgClass'=> 'bg-green','condition'=>['action'=>'manager','rule'=>'$vo["check_status"] == 1']],
                ['text'  => '重置密码','action'=> 'condition', 'js-action' => TRUE, 'icon'  => 'user-setting','bgClass'=> 'bg-yellow','condition'=>['action'=>'resetpwd','rule'=>'$vo["username"] != "" && $vo["check_status"] == 1']],
                ['text'  => '审核','action'=> 'condition', 'icon'  => 'check','bgClass'=> 'bg-red','condition'=>['action'=>'check','rule'=>'$vo["username"] != "" && $vo["check_status"] == 0']],
            ];
            $table['actions']['width']  = '*';
        }
        return $table;
    }
    /**
     * 详情字段配置
     */
    function _fieldData(){
        $array = $logo = $status = $sort = $array1 = $array2 = $array3 = $array4 = $array5 = $array6 = $array7 = $array8 = $array9 = [];
        if ($this->storeType == STORE_FACTORY) {
            $logo = ['title'=>'Logo','type'=>'uploadImg','name'=>'logo', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>''];
            $array = ['title'=>'二级域名','type'=>'text','name'=>'domain','size'=>'20','datatype'=>'','default'=>'','notetext'=>lang($this->modelName).'二级域名不能重复'];
        }
        if ($this->storeType == STORE_DEALER && in_array($this->adminUser['admin_type'], [ADMIN_FACTORY, ADMIN_CHANNEL])) {
            if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
                $channels = $this->model->field('store_id as id, name as cname')->where(['factory_id' => $this->adminUser['store_id'], 'store_type' => STORE_CHANNEL, 'is_del' => 0, 'status' => 1])->select();
                $this->assign('channels', $channels);
                $array1= ['title'=>'所属渠道商','type'=>'select','options'=>'channels','name' => 'ostore_id', 'size'=>'40' , 'datatype'=>'*', 'default'=>'','default_option'=>'==所属渠道商==','notetext'=>'请选择所属渠道商'];
            }
            //$array2= ['title'=>'已采购样品金额','type'=>'text','name'=>'sample_amount','size'=>'20','datatype'=>'*','default'=>'','notetext'=>'请填写已采购样品金额'];
            $array4 = ['title'=>'身份证正面','type'=>'uploadImg','name'=>'idcard_font_img', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>''];
            $array5 = ['title'=>'身份证反面','type'=>'uploadImg','name'=>'idcard_back_img', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>''];
            $array7 = ['title'=>'签约合同','type'=>'uploadImg','name'=>'signing_contract_img', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>''];
            $array8 = ['title'=>'选择区域','type'=>'region','length'=>3,'name'=>'region_id','size'=>'30','datatype'=>'*','default'=>'','notetext'=>'请选择区域'];
            $array9 = ['title'=>lang($this->modelName).'地址','type'=>'text','name'=>'address','size'=>'60','datatype'=>'','default'=>'','notetext'=>'请填写'.lang($this->modelName).'地址'];
        }
        if (in_array($this->storeType, [STORE_CHANNEL, STORE_SERVICE])) {
            $array2 = ['title'=>'保证金金额','type'=>'text','name'=>'security_money','size'=>'10','datatype'=>'*','default'=>'','notetext'=>'请填写保证金金额'];
            $array3 = ['title'=>'负责区域','type'=>'region','length'=>2,'name'=>'region_id','size'=>'30','datatype'=>'*','default'=>'','notetext'=>'请选择负责区域'];
            $array4 = ['title'=>'身份证正面','type'=>'uploadImg','name'=>'idcard_font_img', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>''];
            $array5 = ['title'=>'身份证反面','type'=>'uploadImg','name'=>'idcard_back_img', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>''];
            $array6 = ['title'=>'营业执照','type'=>'uploadImg','name'=>'license_img', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>''];
            $array7 = ['title'=>'签约合同','type'=>'uploadImg','name'=>'signing_contract_img', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>''];
            //$array8 = ['title'=>'签约合影照片','type'=>'uploadImg','name'=>'group_photo', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>''];
        }
        if (in_array($this->storeType, [STORE_SERVICE_NEW])) {
            $array2 = ['title'=>'缴纳保证金金额','type'=>'text','name'=>'security_money','size'=>'10','datatype'=>'*','default'=>'','notetext'=>'请填写保证金金额'];
            $array3 = ['title'=>'公司法人身份证正面','type'=>'uploadImg','name'=>'idcard_font_img', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>'公司法人身份证正面'];
            $array4 = ['title'=>'公司法人身份证反面','type'=>'uploadImg','name'=>'idcard_back_img', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>'公司法人身份证正面'];
            $array5 = ['title'=>'营业执照','type'=>'uploadImg','name'=>'license_img', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>'公司营业执照'];
            $array6 = ['title'=>'签约合同','type'=>'uploadImg','name'=>'signing_contract_img', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>'签约合同 (带有双方公司名称)'];
            $array7 = ['title'=>'负责区域','type'=>'region','length'=>2,'name'=>'region_id','size'=>'30','datatype'=>'*','default'=>'','notetext'=>'请选择负责区域'];
        }

        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $status = ['title'=>'显示状态','type'=>'radio','name'=>'status','size'=>'20','datatype'=>'','default'=>'1','notetext'=>'','radioList'=>[
                ['text'=>'可用','value'=>'1'],
                ['text'=>'禁用','value'=>'0'],
            ]];
            $sort = ['title'=>'排序','type'=>'text','name'=>'sort_order','size'=>'20','datatype'=>'','default'=>'1','notetext'=>''];
        }
        $field = [
            $array, $array1,
            ['title'=>lang($this->modelName).'名称','type'=>'text','name'=>'name','size'=>'40','datatype'=>'*','default'=>'','notetext'=>lang($this->modelName).'名称请不要填写特殊字符'],
            $logo,
            ['title'=>lang($this->modelName).'联系人姓名','type'=>'text','name'=>'user_name','size'=>'20','datatype'=>'*','default'=>'','notetext'=>'请填写'.lang($this->modelName).'联系人姓名'],
            ['title'=>lang($this->modelName).'联系电话','type'=>'text','name'=>'mobile','size'=>'20','datatype'=>'*','default'=>'','notetext'=>'请填写'.lang($this->modelName).'联系电话'],
            $array2,$array3,$array4,$array5,$array6,$array7,$array8,$array9,           
            $status,
            $sort,
        ];
        return array_filter($field);
    }
    function _init()
    {
        
    }
}