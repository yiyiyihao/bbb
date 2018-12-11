<?php
namespace app\factory\controller;
//售后工单管理
class Worder extends FactoryForm
{
    var $orderTypes;
    var $statusList;
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
        $this->subMenu['showmenu'] = true;
        $this->statusList = get_worder_status();
        foreach ($this->statusList as $key => $value) {
            $this->subMenu['menu'][] = ['name'  => lang($value),'url'   => url('index', ['status' => $key])];
        }
        $this->assign('orderTypes', $this->orderTypes);
    }
    //指派售后工程师
    public function dispatch()
    {
        $info = $this->_assignInfo();
        if (IS_POST) {
            $params = $this->request->param();
            $installerId = isset($params['installer_id']) ? intval($params['installer_id']) : 0;
            if (!$installerId) {
                $this->error('请选择售后工程师');
            }
            $result = $this->model->worderDispatch($info, $this->adminUser, $installerId);
            if ($result !== FALSE) {
                $this->success('售后工程师指派成功', url('index'));
            }else{
                $this->error('操作失败:'.$this->model->error);
            }
        }else{
            $this->assign('info', $info);
            return $this->fetch();
        }
    }
    /**
     * 工单详情
     */
    public function detail()
    {
        $info = $this->_assignInfo();
        //查询售后产品
        $info['goods'] = db('goods_sku')->alias('GS')->join([['goods G', 'G.goods_id = GS.goods_id', 'INNER']])->where(['sku_id' => $info['sku_id'], 'G.goods_id' => $info['goods_id']])->find();
        $info['logs'] = db('work_order_log')->order('add_time DESC')->where(['worder_id' => $info['worder_id']])->select();
        $this->assign('info', $info);
        return $this->fetch();
    }
    /**
     * 取消工单
     */
    public function cancel()
    {
        $info = $this->_assignInfo();
        $result = $this->model->worderCancel($info, $this->adminUser);
        if ($result === FALSE) {
            $this->error($this->model->error);
        }else{
            $this->success('取消售后订单成功');
        }
    }
    public function getAjaxList($where = [], $field = '')
    {
        $this->model = db('user_installer');
        parent::getAjaxList([], 'installer_id as id,  CONCAT(realname, " | ", phone) as name');
    }
    public function del()
    {
        #TODO 判断工单状态对应删除权限
        
//         parent::del();    
    }
    
    function _getAlias()
    {
        return 'WO';
    }
    function _getField(){
        $field = 'I.*, WO.*, G.name as gname, GS.sku_name';
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $field .= ',S.name';
        }
        return $field;
    }
    function _getJoin()
    {
        $join[] = ['user_installer I', 'I.installer_id = WO.installer_id', 'LEFT'];
        $join[] = ['goods G', 'WO.goods_id = G.goods_id', 'LEFT'];
        $join[] = ['goods_sku GS', 'WO.sku_id = GS.sku_id', 'LEFT'];
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
        $params = $this->request->param();
        $status = isset($params['status']) ? intval($params['status']) : 0;
        if (!isset($this->statusList[$status])) {
            $status = 0;
        }
        $where = [
            'WO.is_del' => 0,
        ];
        if (isset($params['status'])) {
            $where['WO.status'] = $status;
        }
        if ($this->adminUser['admin_type'] == 2) {
            $where['WO.factory_id'] = $this->adminUser['store_id'];
        }elseif ($this->adminUser['admin_type'] == 3 && $this->storeType == 3){
            $where['WO.ostore_id'] = $this->adminUser['store_id'];
        }
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['WO.user_name|WO.phone'] = ['like','%'.$name.'%'];
            }
            if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
                $sname = isset($params['sname']) ? trim($params['sname']) : '';
                if($sname){
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
        $info = parent::_assignInfo();
        $storeId = isset($data['store_id']) ? intval($data['store_id']) : '';
        $orderType = isset($data['order_type']) ? intval($data['order_type']) : '';
        $goodsId = isset($data['goods_id']) ? intval($data['goods_id']) : '';
        $skuId = isset($data['sku_id']) ? intval($data['sku_id']) : '';
        $userName = isset($data['user_name']) ? trim($data['user_name']) : '';
        $phone = isset($data['phone']) ? trim($data['phone']) : '';
        $address = isset($data['address']) ? trim($data['address']) : '';
        $appointment = isset($data['appointment']) ? trim($data['appointment']) : '';
        $data['appointment'] = strtotime($appointment);
        $faultDesc = isset($data['fault_desc']) ? trim($data['fault_desc']) : '';
        $regionId = isset($data['region_id']) ? intval($data['region_id']) : '';
        if ($info && in_array($info['status'], [-1, 3, 4])) {
            $this->error('工单当前状态不允许编辑');
        }
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY && !$storeId){//如果是厂商,且未选择服务商,根据安装地址分配服务商
            $storeID = model('servicer')->getStoreFromRegion($regionId);
            if(!$storeID){
                $this->error('该区域暂无服务商');
            }
            $data['store_id'] = $storeID;
        }
        if (!$orderType) {
            $this->error('请选择工单类型');
        }
        if (!isset($this->orderTypes[$orderType])) {
            $this->error('工单类型错误');
        }
        if (!$goodsId) {
            $this->error('请选择售后产品');
        }
        if (!$skuId) {
            $this->error('请选择售后产品规格属性');
        }
        if (!$info) {
            if ($this->adminUser['admin_type'] == ADMIN_SERVICE) {
                $data['store_id'] = $this->adminStore['store_id'];
                $data['factory_id'] = $this->adminStore['factory_id'];
            }elseif ($this->adminUser['admin_type'] == ADMIN_FACTORY){
                $data['store_id'] = $storeId;
                $data['factory_id'] = $this->adminStore['store_id'];
            }
            $data['post_user_id'] = ADMIN_ID;
            $storeId = $data['factory_id'];
        }else{
            $storeId = $info['factory_id'];
        }
        //根据产品规格获取预安装费
        $goodsModel = new \app\common\model\Goods();
        $sku = $goodsModel->checkSku($skuId, $storeId);
        if (!$sku) {
            $this->error('您选择的售后产品不存在或已删除');
        }
        $data['install_price'] = $sku['install_price'];
        if (!$userName) {
            $this->error('请填写客户姓名');
        }
        if (!$phone) {
            $this->error('请填写客户联系电话');
        }
        if (!$regionId) {
            $this->error('请选择客户所在区域');
        }
        if (!$address) {
            $this->error('请填写客户地址');
        }
        if (!$appointment) {
            $this->error('请填写客户预约服务时间');
        }
        if ($orderType == 2 && !$faultDesc) {
            $this->error('请简要描述故障信息');
        }
        if ($orderType == 1) {
            $data['fault_desc'] = '';
        }
        $data['images'] = '';
        return $data;
    }
    function _assignInfo($pkId = 0){
        $info = parent::_assignInfo();
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $factoryId = $this->adminUser['store_id'];
            //获取厂商下的服务商列表
            $stores = db('store')->field('store_id, name')->where(['is_del' => 0, 'status' => 1, 'factory_id' => $this->adminUser['store_id'], 'store_type' => STORE_SERVICE])->select();
            $this->assign('stores', $stores);
        }elseif ($this->adminUser['admin_type'] == ADMIN_SERVICE){
            $factoryId = $this->adminUser['factory_id'];
        }
        $this->assign('factory_id', $factoryId);
        return $info;
    }
}