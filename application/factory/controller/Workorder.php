<?php
namespace app\factory\controller;
//售后工单管理
class Workorder extends FactoryForm
{
    var $types;
    var $type = 1;
    var $statusList;
    var $orderTypes;
    public function __construct()
    {
        $this->modelName = 'work_order';
        $this->model = new \app\common\model\WorkOrder();
        $this->orderTypes = get_work_order_type();
        parent::__construct();
        if (strtolower($this->request->action()) != 'index') {
            $this->type = 2;
            $this->subMenu['menu']['0'] = [
                'name' => '维修工单列表',
                'url' => url('lists'),
            ];
            $action = 'lists';
        }else{
            $this->subMenu['menu']['0']['name'] = '安装工单列表';
            $action = 'index';
        }
        $this->subMenu['showmenu'] = true;
        $this->statusList = get_work_order_status();
        foreach ($this->statusList as $key => $value) {
            $this->subMenu['menu'][] = ['name'  => lang($value),'url'   => url($action, ['status' => $key])];
        }
        unset($this->subMenu['add']);
        $this->assign('orderTypes', $this->orderTypes);
        $this->assign('type', $this->type);
    }
    //维修工单
    public function lists()
    {
        $this->indextempfile = 'index';
        return $this->index();
    }
    public function _afterList($list){
        if ($list && $this->adminUser['admin_type'] == ADMIN_FACTORY) {
            foreach ($list as $key => $value) {
                if ($value['work_order_type'] == 1 && $value['work_order_status'] == 4) {
                    //判断安装工单是否存在维修中的记录
                    $exist = $this->model->where(['parent_id' => $value['worder_id'], 'work_order_type' => 2, 'work_order_status' => ['<>', -1]])->find();
                }
                $list[$key]['fix_id'] = isset($exist) && $exist ? $exist['worder_id']: 0;
            }
        }
        return $list;
    }
    public function edit()
    {
        $info = parent::_assignInfo();
        if ($info) {
            //派单之后不允许编辑
            if ($info['work_order_status'] != 0) {
                $this->error(lang('不允许编辑'));
            }
        }
        $type = isset($info['work_order_type']) ? intval($info['work_order_type']) : 0;
        //只有渠道和零售商可以编辑安装工单
        if ($type == 1 && !in_array($this->adminUser['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER])) {
            $this->error(lang('NO ACCESS'));
        }
        //只有厂商可以编辑维修工单
        if ($type == 2 && !in_array($this->adminUser['admin_type'], [ADMIN_FACTORY])) {
            $this->error(lang('NO ACCESS'));
        }
        return parent::edit();
    }
    public function add()
    {
        $params = $this->request->param();
        $type = isset($params['type']) ? intval($params['type']) : 0;
        //只有渠道和零售商可以新增安装工单
        if ($type == 1 && !in_array($this->adminUser['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER])) {
            $this->error(lang('NO ACCESS'));
        }
        //只有厂商可以新增维修工单
        if ($type == 2 && !in_array($this->adminUser['admin_type'], [ADMIN_FACTORY])) {
            $this->error(lang('NO ACCESS'));
        }
        return parent::add();
    }
    //指派售后工程师
    public function dispatch()
    {
        if ($this->adminUser['admin_type'] != ADMIN_SERVICE) {
            $this->error(lang('NO ACCESS'));
        }
        $info = $this->_assignInfo();
        if (IS_POST) {
            $params = $this->request->param();
            $installerId = isset($params['installer_id']) ? intval($params['installer_id']) : 0;
            if (!$installerId) {
                $this->error('请选择售后工程师');
            }
            $result = $this->model->worderDispatch($info, $this->adminUser, $installerId);
            if ($result !== FALSE) {
                //发送派单通知给工程师
                $push = new \app\common\service\PushBase();
                $sendData = [
                    'type'         => 'worker',
                    'worder_sn'    => $info['worder_sn'],
                    'worder_id'    => $info['worder_id'],
                ];
                //发送给服务商在线管理员
                $push->sendToUid(md5($installerId), json_encode($sendData));
                #TODO 发送服务通知/短信给工程师
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
     * 评价工单
     */
    public function assess(){
        $info = $this->_assignInfo();
        if (IS_POST) {
            $params = $this->request->param();
            $data = [
                'type'      =>  $params['type'],//1 首次评论 2 追加评论
                'msg'       =>  $params['msg'],
            ];
            if(isset($params['score'])){
                $data['score'] = $params['score'];
            }
            $assessId = $this->model->worderAssess($info,$this->adminUser,$data);
            if ($assessId === FALSE) {
                $this->error($this->model->error);
            }else{
                $this->success('工单评价成功', url('index'));
            }
        }else{
            //检查工单是否评论过
            $where = [
                'worder_id'     => $info['worder_id'],
                'is_del'        => 0,
            ];
            $assessInfo = db('work_order_assess')->where($where)->find();
            if($assessInfo){
                $type = 2;
            }else{
                $type = 1;
                //取得系统配置评价项
                $where = [
                    'is_del' => 0,
                    'config_key'      =>  CONFIG_WORKORDER_ASSESS,
                ];
                $configList = db('config')->where($where)->select();
                $this->assign('config',$configList);
            }
            $this->assign('type', $type);
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
        $type = $info['work_order_type'];
        //只有厂商和服务商有维修工单的查看权限
        if ($type == 2 && !in_array($this->adminUser['admin_type'], [ADMIN_FACTORY, ADMIN_SERVICE])) {
            $this->error('无操作权限');
        }
        $info = $this->model->getWorderDetail($info['worder_sn'], $this->adminUser);
        if ($info === FALSE) {
            $this->error($this->model->error);
        }
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
        $this->error(lang('NO ACCESS'));
    }
    function _getAlias()
    {
        return 'WO';
    }
    function _getField(){
        $field = 'I.*, WO.*, G.name as gname, GS.sku_name, I.phone as installer_phone';
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $field .= ',S.name';
        }
//         状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        $field .= ', if(work_order_status >= 0, work_order_status, 5) as order_status';
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
        return 'order_status ASC, WO.add_time DESC';
    }
    function _getWhere(){
        $params = $this->request->param();
        $status = isset($params['status']) ? intval($params['status']) : 0;
        if (!isset($this->statusList[$status])) {
            $status = 0;
        }
        $where = [
            'WO.is_del' => 0,
            'work_order_type' => $this->type,
        ];
        
        if (isset($params['status'])) {
            $where['WO.work_order_status'] = $status;
        }
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $where['WO.factory_id'] = $this->adminUser['store_id'];
        }elseif ($this->adminUser['admin_type'] == ADMIN_SERVICE){
            $where['WO.store_id'] = $this->adminUser['store_id'];
        }else {
            $where['WO.post_store_id'] = $this->adminUser['store_id'];
        }
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['WO.user_name|WO.phone'] = ['like','%'.$name.'%'];
            }
            $installerName = isset($params['installer_name']) ? trim($params['installer_name']) : '';
            if($installerName){
                $where['I.realname|I.phone'] = ['like','%'.$installerName.'%'];
            }
            if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
                $sname = isset($params['sname']) ? trim($params['sname']) : '';
                if($sname){
                    $where['S.name'] = ['like','%'.$sname.'%'];
                }
            }
        }
        return $where;
    }
    
    private function _getSkuSub($info = [])
    {
        //判断是否有新增权限
        if (!in_array($this->adminUser['admin_type'], [ADMIN_FACTORY, ADMIN_CHANNEL, ADMIN_DEALER]))
        {
            $this->error(lang('NO ACCESS'));
        }
        $params = $this->request->param();
        if (!$info) {
            $type = isset($params['type']) ? intval($params['type']) : 0;
            if (!isset($this->orderTypes[$type])) {
                $this->error('工单类型错误');
            }
        }else{
            $type = $info['type'];
        }
        //零售商和渠道商只允许添加安装工单 厂商仅允许添加维修工单
        if ($type == 1 && !in_array($this->adminUser['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER])) {
            $this->error(lang('NO ACCESS'));
        }elseif ($type == 2 && !in_array($this->adminUser['admin_type'], [ADMIN_FACTORY])){
            $this->error(lang('NO ACCESS'));
        }
        $ossubId = isset($params['ossub_id']) ? intval($params['ossub_id']) : 0;
        $name = $this->modelName = $this->orderTypes[$type];
        if (!$ossubId) {
            $this->error(lang('param_error'));
        }
        $orderSkuSubModel = db('order_sku_sub');
        $join = [];
        $skuModel = new \app\common\model\OrderSku();
        $ossub = $skuModel->getSubDetail($ossubId, FALSE, TRUE);
        if (!$ossub) {
            $this->error('参数错误');
        }
        if ($ossub['goods_type'] == 2) {
            $this->error('样品不允许安装/维修');
        }
        if ($ossub['order_status'] != 1) {
            $this->error('订单已取消或关闭，不允许添加工单');
        }
        if (!$ossub['pay_status']) {
            $this->error('订单未支付，不允许添加工单');
        }
        if($ossub['service'] && ($ossub['service']['service_status'] != -1 || $ossub['service']['service_status'] != -2)){
            $this->error('产品存在退款申请，不允许提交工单');
        }
        if ($type == 1) {
            //判断当前产品对应工单数量
            $exist = $this->model->where(['ossub_id' => $ossub['ossub_id'], 'work_order_type' => 1, 'work_order_status' => ['<>', -1]])->find();
            if ($exist) {
                $this->error('当前产品已申请安装工单', url('workorder/index'));
            }
        }
        if ($type == 2) {
            $wid = isset($params['wid']) ? intval($params['wid']) : 0;
            $info = $this->model->where(['worder_id' => $wid, 'work_order_type' => 1, 'work_order_status' => 4])->find();
            if (!$info) {
                $this->error(lang('param_error'));
            }
            //判断当前是否存在正在进行中的维修工单
            $exist = $this->model->where(['parent_id' => $wid, 'work_order_type' => 2, 'work_order_status' => ['<>', -1]])->find();
            if ($exist) {
                $this->error('当前工单存在维修中的工单，不允许添加');
            }
        }
        $wid = isset($params['wid']) ? intval($params['wid']) : 0;
        if ($wid) {
            $exist = $this->model->find($wid);//安装工单
            if ($exist) {
                $exist['appointment'] = date('Y-m-d H:i', time());
                $exist['work_order_type'] = 2;
                $this->assign('info', $exist);
            }
        }
        $this->assign('ossub', $ossub);
        return $ossub;
    }
    function _getData($ossub = [])
    {
        $data = parent::_getData();
        $params = $this->request->param();
        $info = parent::_assignInfo();
        if (!$info) {
            $ossub = $this->_getSkuSub($info);
        }
        $type = isset($params['type']) ? intval($params['type']) : '';
        $userName = isset($data['user_name']) ? trim($data['user_name']) : '';
        $phone = isset($data['phone']) ? trim($data['phone']) : '';
        $regionId = isset($data['region_id']) ? intval($data['region_id']) : '';
        $regionName = isset($data['region_name']) ? trim($data['region_name']) : '';
        $address = isset($data['address']) ? trim($data['address']) : '';
        $appointment = isset($data['appointment']) ? trim($data['appointment']) : '';
        $faultDesc = isset($data['fault_desc']) ? trim($data['fault_desc']) : '';
        if ($info && in_array($info['work_order_status'], [-1, 3, 4])) {
            $this->error('工单当前状态不允许编辑');
        }
        if (!$info || $info['region_id'] != $regionId) {
            $storeModel = new \app\common\model\Store();
            //根据安装地址分配服务商
            $storeId = $storeModel->getStoreFromRegion($regionId);
            if(!$storeId){
                $this->error('该区域暂无服务商');
            }
            $data['store_id'] = $storeId;
        }
        if (!$info && !$type) {
            $this->error('请选择工单类型');
        }
        if ($type && !isset($this->orderTypes[$type])) {
            $this->error('工单类型错误');
        }
        if (!$info) {
            $data['factory_id']     = $this->adminFactory['store_id'];
            $data['post_user_id']   = ADMIN_ID;
            $data['work_order_type']= $type;
            $data['osku_id']        = $ossub['osku_id'];
            $data['ossub_id']       = $ossub['ossub_id'];
            $data['order_sn']       = $ossub['order_sn'];
            $data['goods_id']       = $ossub['goods_id'];
            $data['sku_id']         = $ossub['sku_id'];
            $data['post_store_id']  = $this->adminUser['store_id'];
        }
        if ($ossub) {
            $data['install_price'] = $ossub['install_price'];
        }
        if (!$userName || !$phone || !$regionId || !$regionName) {
            $this->error('请完善客户信息');
        }
        if (!$appointment) {
            $this->error('请选择客户预约时间');
        }
        if (!$appointment) {
            $this->error('请填写客户预约服务时间');
        }
        if ($type == 2) {
            $parentId = isset($params['wid']) ? intval($params['wid']) : '';
            if ($parentId <= 0) {
                $this->error(lang('PARAM_ERROR'));
            }
            if (!$faultDesc) {
                $this->error('请简要描述故障信息');
            }
            $data['parent_id'] = $parentId;
        }
        if ($type == 1) {
            $data['fault_desc'] = '';
        }
        if (isset($data['imgs'])) {
            $data['images'] = $data['imgs'] ? implode(',', $data['imgs']) :'';
        }else {
            $data['images'] = '';
        }
        $data['appointment'] = $appointment ? strtotime($appointment) : 0;
        if ($data['appointment'] <= time()) {
            $this->error('预约服务时间必须大于当前时间');
        }
        return $data;
    }
    function _assignAdd(){
        parent::_assignAdd();
        $this->_getSkuSub();
    }
    function _assignInfo($pkId = 0)
    {
        $info = parent::_assignInfo();
        if ($info) {
            $info['images'] = $info['images'] ? explode(',', $info['images']) : [];
        }
        return $info;
    }
}