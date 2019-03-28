<?php
namespace app\factory\controller;

class Storeaction extends FactoryForm
{
    public function __construct()
    {
        $this->modelName = 'store_action_record';
        $this->model = db('store_action_record');
        parent::__construct();
        if (!in_array($this->adminUser['admin_type'], [ADMIN_FACTORY, ADMIN_CHANNEL])) {
            $this->error('NO ACCESS');
        }
        $this->subMenu['showmenu'] = true;
        $this->subMenu['menu'][] = [
            'name' => '待审核操作申请',
            'url' => url('index', ['status' => 0]),
        ];
        $this->subMenu['menu'][] = [
            'name' => '已拒绝操作申请',
            'url' => url('index', ['status' => 2]),
        ];
        $this->subMenu['menu']['0']['name'] = '全部';
        $action = strtolower($this->request->action());
        if (in_array($action, ['add', 'edit', 'del'])) {
            $this->error('NO ACCESS');
        }
    }
    public function detail()
    {
        $this->subMenu['showmenu'] = false;
        $info = $this->_assignInfo();
        return $this->fetch();
    }
    public function check()
    {
        $this->subMenu['showmenu'] = false;
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $this->error('NO ACCESS');
        }
        $info = $this->_assignInfo();
        $flag = FALSE;
        if ($info['to_store_id']) {
            //判断操作的商户是否存在
            $exist = db('store')->where(['store_id' => $info['to_store_id'], 'is_del' => 0])->find();
            if (!$exist) {
                $remark = '商户不存在或已删除[系统拒绝申请]';
                $flag = TRUE;
            }
            if (!$flag && $info['action_type'] == 'del') {
                //判断零售商是否有订单数据
                $exist = db('order')->where(['user_store_id' => $info['to_store_id']])->find();
                if ($exist) {
                    $remark = '零售商有订单数据[系统拒绝申请]';
                    $flag = TRUE;
                }
            }
        }
        if ($flag) {
            $data = [
                'check_status' => 2,
                'check_time'   => time(),
                'remark'       => $remark,
            ];
            $result = $this->model->where(['record_id' => $info['record_id']])->update($data);
            $this->error($remark);
        }
        if (IS_POST) {
            $params = $this->request->param();
            $remark = isset($params['remark']) ? trim($params['remark']) : '';
            $checkStatus = isset($params['check_status']) ? intval($params['check_status']) : 0;
            if (!$checkStatus && !$remark) {
                $this->error('请填写拒绝理由');
            }
            $after = $info['after'];
            if (!$after && $info['action_type'] != 'del') {
                $this->error('参数错误');
            }
            $storeId = 0;
            if ($checkStatus == 1) {
                $storeModel = new \app\common\model\Store();
                if ($info['action_type'] == 'del' && $info['to_store_id']) {
                    $result = $storeModel->del($info['to_store_id'], $this->adminUser);
                }else{
                    $where = [];
                    if ($info['to_store_id']) {
                        $where['store_id'] = $info['to_store_id'];
                    }
                    $after['check_status'] = 1;
                    $storeId = $storeModel->save($after, $where);
                }
            }
            $data = [
                'check_status' => $checkStatus > 0 ? 1: 2,
                'check_time'   => time(),
                'remark'       => $remark,
            ];
            if ($info['action_type'] == 'add' && $storeId > 0) {
                $data['to_store_id'] = $storeId;
            }
            $result = $this->model->where(['record_id' => $info['record_id']])->update($data);
            if ($result !== FALSE) {
                $this->success('操作成功', url('index'));
            }else{
                $this->error('操作失败');
            }
        }else{
            return $this->fetch();
        }
    }
    function _getAlias()
    {
        return 'SAR';
    }
    function _getField(){
        $field = 'SAR.*, S.name';
        return $field;
    }
    function _getJoin()
    {
        $join[] = ['store S', 'SAR.action_store_id = S.store_id', 'INNER'];
        return $join;
    }
    function  _getOrder()
    {
        return 'SAR.sort_order ASC, SAR.add_time DESC';
    }
    function _getWhere(){
        $params = $this->request->param();
        $status = isset($params['status']) ? intval($params['status']) : 1;
        $where = [
            'SAR.is_del'        => 0,
            'SAR.factory_id'    => $this->adminUser['factory_id'],
        ];
        if (isset($params['status'])) {
            $where['SAR.check_status'] = $status;
        }
        if ($this->adminUser['admin_type'] == ADMIN_CHANNEL) {
            $where['SAR.action_store_id'] = $this->adminUser['store_id'];
        }
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['S.name'] = ['like','%'.$name.'%'];
            }
            $sname = isset($params['sname']) ? trim($params['sname']) : '';
            if($sname){
                $where['SAR.to_store_name'] = ['like','%'.$sname.'%'];
            }
        }
        return $where;
    }
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $search = [];
        if ($this->adminUser['admin_type']== ADMIN_FACTORY) {
            $search[] = ['type' => 'input', 'name' =>  'name', 'value' => '操作商户名称', 'width' => '30'];
        }
        $search[] = ['type' => 'input', 'name' =>  'sname', 'value' => '被操作商户名称', 'width' => '30'];
        return $search;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = parent::_tableData();
        if ($table) {
            foreach ($table as $key => $value) {
                if ($this->adminUser['admin_type'] != ADMIN_FACTORY && isset($value['value']) && $value['value'] == 'name') {
                    unset($table[$key]);
                }
            }
        }
        if ($table['actions']['button']) {
            $table['actions']['button']= [
                ['text'  => '查看详情','action'=> 'detail', 'icon'  => 'detail','bgClass'=> 'bg-green'],
                ['text'  => '审核','action'=> 'condition', 'icon'  => 'check','bgClass'=> 'bg-red','condition'=>['action'=>'check','rule'=>'$vo["check_status"] == 0 && $adminUser["admin_type"] == '.ADMIN_FACTORY]],
            ];
            $table['actions']['width']  = '*';
        }
        return $table;
    }
    function _assignInfo($pkId = 0){
        $info = parent::_assignInfo();
        if ($info) {
            $info['name'] = db('store')->where(['store_id' => $info['action_store_id']])->value('name');
        }
        if (!$info || $info['is_del']) {
            $this->error('安装工程师不存在或已删除');
        }
        $fields = $this->_fields();
        $info['before'] = $info['before'] ? json_decode($info['before'], 1) : [];
        $info['after'] = $info['after'] ? json_decode($info['after'], 1) : [];
        $params = $this->request->param();
        $this->assign('info', $info);
        $this->assign('before', $info['before']);
        $this->assign('after', $info['after']);
        $this->assign('_fields', $fields);
        $this->assign('info', $info);
        return $info;
    }
    private function _fields()
    {
        $fields = [
            'store_type'    => ['name' => '商户类型', 'type' => 'function', 'function' => 'get_store_type'],
            'name'          => ['name' => '商户名称', 'type' => 'text'],
            'logo'          => ['name' => '商户LOGO', 'type' => 'image'],
            'user_name'     => ['name' => '联系人姓名', 'type' => 'text'],
            'mobile'        => ['name' => '联系人电话', 'type' => 'text'],
            //'sample_amount' => ['name' => '已采购样品金额', 'type' => 'text'],
            'security_money' => ['name' => '保证金金额', 'type' => 'text'],
            
            'idcard_font_img'   => ['name' => '法人身份证正面', 'type' => 'image'],
            'idcard_back_img'   => ['name' => '法人身份证背面', 'type' => 'image'],
            'signing_contract_img'  => ['name' => '签约合同图片', 'type' => 'image'],
            'license_img'           => ['name' => '营业执照', 'type' => 'image'],
            //'group_photo'   => ['name' => '签约合影图片', 'type' => 'image'],
            
            'region_name'   => ['name' => '商户区域地址', 'type' => 'text'],
            'address'       => ['name' => '商户地址', 'type' => 'text'],
            'sort_order'    => ['name' => '显示排序', 'type' => 'text'],
        ];
        return $fields;
    }
}
