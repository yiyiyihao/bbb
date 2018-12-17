<?php
namespace app\factory\controller;
//售后管理
class Service extends FactoryForm
{
    public $serviceModel;
    public function __construct()
    {
        $this->modelName = 'order_sku_service';
        $this->model = db($this->modelName);
        parent::__construct();
        if (!in_array($this->adminUser['admin_type'], [ADMIN_FACTORY, ADMIN_CHANNEL, ADMIN_DEALER])) {
            $this->error(lang('NO ACCESS'));
        }
        $this->serviceModel = new \app\common\model\OrderService();
        $action = $this->adminUser['admin_type'] == ADMIN_FACTORY ? 'seller' : 'index';
        unset($this->subMenu['add']);
        //售后状态(-1拒绝申请 0申请中 1等待买家退货 2等待卖家退款 3退款成功 4已取消)
        $this->subMenu['menu'] = [
            [
                'name' => lang($this->modelName).lang('LIST'),
                'url' => url($action),
            ],
            [
                'name' => '待审核',
                'url' => url($action, ['status' => 0]),
            ],
            [
                'name' => '已拒绝',
                'url' => url($action, ['status' => -1]),
            ],
            [
                'name' => '已完成',
                'url' => url($action, ['status' => 3]),
            ],
            [
                'name' => '已取消',
                'url' => url($action, ['status' => 4]),
            ]
        ];
        $this->subMenu['showmenu'] = true;
    }
    /**
     * 售后订单列表
     */
    public function seller()
    {
        $this->indextempfile = 'index';
        return $this->index();
    }
    public function detail()
    {
        $params = $this->request->param();
        $service = $this->_assignInfo();
        $service = $this->serviceModel->getServiceDetail($service['service_sn'], $this->adminUser, 0, TRUE);
        if (!$service) {
            $this->error($this->serviceModel->error);
        }
        $this->assign('info', $service);
        return $this->fetch();
    }
    public function cancel()
    {
        $params = $this->request->param();
        $service = $this->_assignInfo();
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $this->error('NO ACCESS');
        }
        $result = $this->serviceModel->serviceCancel($service, $this->adminUser);
        if ($result === FALSE) {
            $this->error($this->serviceModel->error);
        }
        $this->success('取消成功');
    }
    public function check()
    {
        $params = $this->request->param();
        $service = $this->_assignInfo();
        if ($service['service_status'] != 0) {
            $this->error('审核已处理，不能重复操作');
        }
        if (IS_POST) {
            $result = $this->serviceModel->serviceCheck($service, $this->adminUser, $params);
            if ($result === FALSE) {
                $this->error($this->serviceModel->error);
            }else {
                $this->success('操作成功', url('seller'));
            }
        }else{
            $service = $this->serviceModel->getServiceDetail($service['service_sn'], $this->adminUser);
            if (!$service) {
                $this->error($this->serviceModel->error);
            }
            $this->assign('info', $service);
            return $this->fetch();
        }
    }
    public function delivery()
    {
        $params = $this->request->param();
        $service = $this->_assignInfo();
        if ($service['service_status'] != 1) {
            $this->error('无操作权限');
        }
        if (IS_POST) {
            $result = $this->serviceModel->serviceDelivery($service, $this->adminUser, $params);
            if ($result === FALSE) {
                $this->error($this->serviceModel->error);
            }else {
                #TODO 根据来源返回页面
                $this->success('退货信息填写成功', url('myorder/detail', ['order_sn' => $service['order_sn']]));
            }
        }else{
            $this->assign('deliverys', get_delivery());
            $service = $this->serviceModel->getServiceDetail($service['service_sn'], $this->adminUser);
            if (!$service) {
                $this->error($this->serviceModel->error);
            }
            $this->assign('info', $service);
            return $this->fetch();
        }
    }
    public function refund()
    {
        $params = $this->request->param();
        $service = $this->_assignInfo();
        if ($service['service_status'] != 2) {
            $this->error('无操作权限');
        }
        if (IS_POST) {
            $result = $this->serviceModel->serviceRefund($service, $this->adminUser, $params);
            if ($result === FALSE) {
                $this->error($this->serviceModel->error);
            }else {
                $this->success('确认退款操作成功', url('seller'));
            }
        }else{
            $service = $this->serviceModel->getServiceDetail($service['service_sn'], $this->adminUser);
            if (!$service) {
                $this->error($this->serviceModel->error);
            }
            $this->assign('info', $service);
            return $this->fetch();
        }
    }
    function _getField(){
        return ' S.*, U.username, S1.name as sname, S1.mobile,OS.sku_name';
    }
    function _getAlias(){
        return 'S';
    }
    function _getJoin(){
        return [
            ['order_sku OS', 'S.osku_id = OS.osku_id', 'LEFT'],
            ['store S1', 'S1.store_id = S.user_store_id', 'LEFT'],
            ['user U', 'S.user_id = U.user_id', 'LEFT'],
        ];
    }
    function _getOrder(){
        return 'S.update_time DESC';
    }
    function _getWhere(){
        $params = $this->request->param();
        $where = [
            'S.is_del' => 0,
        ];
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $where['S.store_id'] = $this->adminUser['store_id'];
        }else{
            $where['S.user_store_id'] = $this->adminUser['store_id'];
        }
        if ($params) {
            $type = isset($params['type']) ? intval($params['type']) : '';
            if($type){
                $where['S.service_type'] = $type;
            }
            if(isset($params['status'])){
                $where['S.service_status'] = intval($params['status']);
            }
            $sn = isset($params['sn']) ? trim($params['sn']) : '';
            if($sn){
                $where['S.order_sn'] = ['like','%'.$sn.'%'];
            }
            $gname = isset($params['gname']) ? trim($params['gname']) : '';
            if($gname){
                $where['OS.sku_name'] = ['like','%'.$gname.'%'];
            }
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['S.name|S.mobile|U.username'] = ['like','%'.$name.'%'];
            }
        }
        return $where;
    }
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $types = get_service_type();
        $this->assign('types', $types);
        $search = [
            ['type' => 'input', 'name' =>  'sn', 'value' => '订单编号', 'width' => '30'],
//             ['type' => 'select', 'name' => 'type', 'options'=>'types', 'default_option' => '==售后服务类型=='],
            ['type' => 'input', 'name' =>  'gname', 'value' => '产品名称', 'width' => '30'],
            ['type' => 'input', 'name' =>  'name', 'value' => '买家商户名称/账号/联系电话', 'width' => '30'],
        ];
        return $search;
    }
//     function _afterList($list)
//     {
//         pre($list);
//     }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = parent::_tableData();
        $table['actions']['button'][] = ['text'  => '详情查看', 'action'=> 'detail', 'icon'  => 'setting','bgClass'=> 'bg-main'];
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $table['actions']['button'][] = ['text'  => '审核', 'action'=> 'check', 'icon'  => 'setting','bgClass'=> 'bg-yellow'];
            $table['actions']['button'][] = ['text'  => '退款', 'action'=> 'refund', 'icon'  => '','bgClass'=> 'bg-red'];
        }else{
            $table['actions']['button'][] = ['text'  => '取消', 'action'=> 'cancel', 'icon'  => 'setting','bgClass'=> 'bg-gray'];
            $table['actions']['button'][] = ['text'  => '退货', 'action'=> 'delivery', 'icon'  => 'setting','bgClass'=> 'bg-yellow'];
        }
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $table['actions']['button'][] = [
                'text'  => '审核', 'action'=> 'condition', 'icon'  => 'setting','bgClass'=> 'bg-yellow',
                'condition' => [
                    'action' => 'check',
                    'rule' => '$vo["service_status"] == 0'
                ]
            ];
            $table['actions']['button'][] = [
                'text'  => '退款', 'action'=> 'condition', 'icon'  => '','bgClass'=> 'bg-red',
                'condition' => [
                    'action' => 'refund',
                    'rule' => '$vo["service_status"] == 2'
                ]
            ];
        }else{
            $table['actions']['button'][] = [
                'text'  => '取消', 'action'=> 'condition', 'icon'  => 'setting','bgClass'=> 'bg-gray',
                'condition' => [
                    'action' => 'cancel',
                    'rule' => '$vo["service_status"] != 0'
                ]
            ];
            $table['actions']['button'][] = [
                'text'  => '退货',
                'action'=> 'condition',
                'icon'  => 'setting',
                'bgClass'=> 'bg-yellow',
                'condition' => [
                    'action' => 'delivery',
                    'rule' => '$vo["service_status"] == 0'
                ]
            ];
        }
        $table['actions']['width']  = '*';
        return $table;
    }
}