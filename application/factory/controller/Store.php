<?php
namespace app\factory\controller;
class Store extends FactoryForm
{
    public function __construct()
    {
        $this->modelName = 'store';
        $this->model = new \app\common\model\Store();
        parent::__construct();
        if (!in_array($this->adminUser['admin_type'], [ADMIN_FACTORY, ADMIN_CHANNEL])) {
            $this->error('NO ACCESS');
        }
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $this->subMenu['showmenu'] = true;
            $this->subMenu['menu'][] = [
                'name' => '待审核入驻申请',
                'url' => url('index', ['status' => 0]),
            ];
            $this->subMenu['menu'][] = [
                'name' => '已拒绝入驻申请',
                'url' => url('index', ['status' => 2]),
            ];
        }
        $action = strtolower($this->request->action());
        if (in_array($action, ['add', 'edit', 'del'])) {
            $this->error('NO ACCESS');
        }
    }
    public function detail()
    {
        $info = $this->_assignInfo();
        return $this->fetch();
    }
    public function check()
    {
        $info = $this->_assignInfo();
        //只有厂商才有权限
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $this->error(lang('NO_OPERATE_PERMISSION'));
        }
        $checkStatus = $info['check_status'];
        //已拒绝不允许审核
        if (in_array($checkStatus, [1, 2])) {
            $this->error('操作已审核');
        }
        if ($info['factory_id'] != $this->adminUser['factory_id']) {
            $this->error(lang('NO_OPERATE_PERMISSION'));
        }
        $params = $this->request->param();
        if (IS_POST) {
            $remark = isset($params['remark']) ? trim($params['remark']) : '';
            $checkStatus = isset($params['check_status']) ? intval($params['check_status']) : 0;
            if (!$checkStatus && !$remark) {
                $this->error('请填写拒绝理由');
            }
            $status = $checkStatus > 0 ? 1: 2;
            $data = [
                'check_status' => $status,
                'admin_remark' => $remark,
            ];
            $result = $this->model->save($data, ['store_id' => $info['store_id']]);
            if ($result !== FALSE) {
                $this->success('操作成功', url('index', ['status' => $status]));
            }else{
                $this->error('操作失败');
            }
        }else{
            $this->assign('info', $info);
            return $this->fetch('store/check');
        }
    }
//     function _getAlias()
//     {
//         return 'SAR';
//     }
//     function _getField(){
//         $field = '*, S.name';
//         return $field;
//     }
//     function _getJoin()
//     {
//         $join[] = ['store S', 'action_store_id = S.store_id', 'INNER'];
//         return $join;
//     }
//     function  _getOrder()
//     {
//         return 'sort_order ASC, add_time DESC';
//     }
    function _getWhere(){
        $params = $this->request->param();
        $status = isset($params['status']) ? intval($params['status']) : 1;
        $where = [
            'is_del'        => 0,
            'enter_type'    => 1,
        ];
        if (isset($params['status'])) {
            $where['check_status'] = $status;
        }
        if ($this->adminUser['admin_type'] == ADMIN_CHANNEL) {
            $where['action_store_id'] = $this->adminUser['store_id'];
        }
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['name'] = ['like','%'.$name.'%'];
            }
            $uname = isset($params['uname']) ? trim($params['uname']) : '';
            if($uname){
                $where['user_name|mobile'] = ['like','%'.$uname.'%'];
            }
        }
        return $where;
    }
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $search = [
            ['type' => 'input', 'name' =>  'name', 'value' => '商户名称', 'width' => '30'],
            ['type' => 'input', 'name' =>  'uname', 'value' => '联系人姓名/电话', 'width' => '30'],
        ];
        return $search;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = parent::_tableData();
        if ($table['actions']['button']) {
            $table['actions']['button']= [
                ['text'  => '查看详情','action'=> 'detail', 'icon'  => 'detail','bgClass'=> 'bg-green'],
                ['text'  => '审核','action'=> 'condition', 'icon'  => 'check','bgClass'=> 'bg-red','condition'=>['action'=>'check','rule'=>'$vo["check_status"] == 0']],
            ];
            $table['actions']['width']  = '*';
        }
        return $table;
    }
    function _assignInfo($pkId = 0){
        $info = $this->model->getStoreDetail(input('id'));
        $this->assign('info', $info);
        $this->assign('user', $info['manager']);
        return $info;
    }
}