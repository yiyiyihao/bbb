<?php
namespace app\factory\controller;
//售后工单管理
class Worder extends BaseFactory
{
    var $orderTypes;
    public function __construct()
    {
        $this->modelName = 'work_order';
        $this->model = model($this->modelName);
        parent::__construct();
        if ($this->adminUser['admin_type'] != ADMIN_SERVICE && $this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $this->error(lang('NO ACCESS'));
        }
        $this->orderTypes = [
            1 => '安装工单',
            2 => '售后维修单'
        ];
        $this->assign('orderTypes', $this->orderTypes);
    }
    //分配安装员
    public function dispatch()
    {
        $info = $this->_assignInfo();
        if (IS_POST) {
            $params = $this->request->param();
            $installerId = isset($params['installer_id']) ? intval($params['installer_id']) : 0;
            if (!$installerId) {
                $this->error('请选择安装员');
            }
            $result = $this->model->save($params,['worder_id' => $info['worder_id']]);
            if ($result) {
                $this->success('安装员分配成功', url('index'));
            }else{
                $this->error('操作失败');
            }
        }else{
            $this->assign('info', $info);
            return $this->fetch();
        }
    }
    public function getAjaxList($where = [], $field = '')
    {
        $this->model = db('user_installer');
        parent::getAjaxList([], 'installer_id as id,  CONCAT(realname, " | ", phone) as name');
    }
    
    function _getAlias()
    {
        return 'WO';
    }
    function _getField(){
        $field = 'I.*, WO.*';
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $field .= ',S.name';
        }
        return $field;
    }
    function _getJoin()
    {
        $join[] = ['user_installer I', 'I.installer_id = WO.installer_id', 'LEFT'];
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $join[] = ['store S', 'S.store_id = WO.store_id', 'LEFT'];
        }
        return $join;
    }
    function  _getOrder()
    {
        return 'WO.add_time DESC';
    }
    function _getWhere(){
        $where = [
            'WO.is_del'      => 0,
        ];
        if ($this->adminUser['admin_type'] == 2) {
            $where['WO.factory_id'] = $this->adminUser['store_id'];
        }elseif ($this->adminUser['admin_type'] == 3 && $this->storeType == 3){
            $where['WO.ostore_id'] = $this->adminUser['store_id'];
        }
        $params = $this->request->param();
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['WO.user_name|WO.phone'] = ['like','%'.$name.'%'];
            }
            if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
                $sname = isset($params['sname']) ? trim($params['sname']) : '';
                if($name){
                    $where['S.name'] = ['like','%'.$sname.'%'];
                }
            }
            $orderType = isset($params['order_type']) ? intval($params['order_type']) : '';
            if($orderType){
                $where['order_type'] = $orderType;
            }
        }
        return $where;
    }
    function _getData()
    {
        $data = parent::_getData();
        $storeId = isset($data['store_id']) ? intval($data['store_id']) : '';
        $orderType = isset($data['order_type']) ? intval($data['order_type']) : '';
        $userName = isset($data['user_name']) ? trim($data['user_name']) : '';
        $phone = isset($data['phone']) ? trim($data['phone']) : '';
        $address = isset($data['address']) ? trim($data['address']) : '';
        $faultDesc = isset($data['fault_desc']) ? trim($data['fault_desc']) : '';
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY && !$storeId){
            $this->error('请选择服务商');
        }
        if (!$orderType) {
            $this->error('请选择工单类型');
        }
        if (!isset($this->orderTypes[$orderType])) {
            $this->error('工单类型错误');
        }
        if (!$userName) {
            $this->error('请填写客户姓名');
        }
        if (!$phone) {
            $this->error('请填写客户联系电话');
        }
        if (!$address) {
            $this->error('请填写客户地址');
        }
        if ($orderType == 2 && !$faultDesc) {
            $this->error('请简要描述故障信息');
        }
        if ($orderType == 1) {
            $data['fault_desc'] = '';
        }
        $data['images'] = '';
        if ($this->adminUser['admin_type'] == ADMIN_SERVICE) {
            $data['store_id'] = $this->adminStore['store_id'];
            $data['factory_id'] = $this->adminStore['factory_id'];
        }elseif ($this->adminUser['admin_type'] == ADMIN_FACTORY){
            $data['store_id'] = $storeId;
            $data['factory_id'] = $this->adminStore['store_id'];
        }
        return $data;
    }
    function _assignInfo($pkId = 0){
        $info = parent::_assignInfo();
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            //获取厂商下的服务商列表
            $stores = db('store')->field('store_id, name')->where(['is_del' => 0, 'status' => 1, 'factory_id' => $this->adminUser['store_id'], 'store_type' => STORE_SERVICE])->select();
            $this->assign('stores', $stores);
        }
        return $info;
    }
}