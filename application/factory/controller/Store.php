<?php
namespace app\factory\controller;
use think\Db;

class Store extends FactoryForm
{
    public function __construct()
    {
        $this->modelName = 'store';
        $this->model = new \app\common\model\Store();
        parent::__construct();
        if (!in_array($this->adminUser['admin_type'], [ADMIN_FACTORY, ADMIN_CHANNEL,ADMIN_SERVICE_NEW])) {
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
        //只有厂商,新服务商才有权限
        if (!in_array($this->adminUser['admin_type'],[ADMIN_FACTORY,ADMIN_SERVICE_NEW])) {
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
                $this->error('请填写备注（不通过原因）');
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

    public function unbindwechat()
    {
        $this->subMenu['menu']=[];
        //只有厂商才有权限
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $this->error(lang('NO_OPERATE_PERMISSION'));
        }

        if (IS_POST) {
            $factoryId=$this->adminUser['factory_id'];
            $mobile=input('mobile','','trim');
            if (empty($mobile)) {
                $this->error('请填写要解绑的商户注册手机号');
            }
            $mobile=explode(',',str_replace('，',',',$mobile));
            $mobile=array_map(function ($item){
                $v=trim($item);
                if ($v && preg_match('/^1\d{10}$/', $v)) {
                    return $v;
                }
            },$mobile);
            $mobile=array_unique(array_filter($mobile));
            if (empty($mobile)) {
                $this->error('请填写有效手机号');
            }
            $user=db('user')->whereIn('phone',$mobile)->where(['is_del'=>0,'factory_id'=>$factoryId])->column('store_id','user_id');
            $userIds=array_keys($user);
            $storeIds=array_unique(array_filter(array_values($user)));
            if (empty($userIds)) {
                $this->error('该手机号未绑定');
            }
            Db::startTrans();
            $result=db('user_data')->whereIn('user_id',$userIds)->update(['user_id'=>0]);
            if ($result===false) {
                Db::rollback();
                $this->error('解绑失败');
            }
            if ($result > 0) {
                $ret1=db('user')->whereIn('user_id',$userIds)->where(['is_del'=>0,'factory_id'=>$factoryId])->update(['is_del'=>1]);
                $ret2=db('store')->whereIn('store_id',$storeIds)->where(['is_del'=>0,'factory_id'=>$factoryId])->update(['is_del'=>1]);
                if ($ret1 === false || $ret2 === false) {
                    Db::rollback();
                    $this->error('解绑失败');
                }
                Db::commit();
                session('api_user_data', []);
                session('api_admin_user', []);
                session('api_wechat_oauth', []);
                session('udata', []);
                session('api_source', '');
                $this->success('成功解绑'.$result.'条数据');
            }
            $this->error('数据无修改');
        } else {
            return $this->fetch('unbind_wechat');
        }


    }

    //获得网点分布及订单数据
    public function distribute()
    {
        if (!in_array($this->adminUser['admin_type'], [ADMIN_FACTORY, STORE_SERVICE_NEW])) {
            return json(dataFormat(1, "非法访问"));
        }
        //p($this->adminUser);
        $data=[];
        $arr['service'] = [];
        $arr['dealer'] = [];
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {//厂商，获取话旗下服务商表列表
            $data['service'] = db('store')->field('store_id,name,region_name,address')->where([
                'is_del'       => 0,
                'status'       => 1,
                'check_status' => 1,
                'store_type'   => ['IN',STORE_SERVICE_NEW, STORE_SERVICE],
                'factory_id'   => $this->adminUser['factory_id'],
            ])->cursor();
            $data['dealer'] = db('store')->field('store_id,name,region_name,address')->where([
                'is_del'       => 0,
                'status'       => 1,
                'check_status' => 1,
                'store_type'   => STORE_DEALER,
                'factory_id'   => $this->adminUser['factory_id'],
            ])->cursor();

        } else {//服务商
            $data['dealer'] = db('store')->alias('p1')
                ->field('p1.store_id,p1.name,p1.region_name,p1.address')
                ->join('store_dealer p2', 'p2.store_id=p1.store_id')
                ->where([
                    'p1.is_del'       => 0,
                    'p1.status'       => 1,
                    'p1.check_status' => 1,
                    'p2.ostore_id'    => $this->adminUser['store_id'],
                ])->cursor();;
        }
        foreach ($data as $key => $value) {
            foreach ($value as $k => $v) {
                $arr[$key][$k]=$v;
                $arr[$key][$k]['order_count'] = db('order')->where([
                    'order_status'  => 1,
                    'user_store_id' => $v['store_id'],
                ])->count();
                unset($arr[$key][$k]['store_id']);
            }
        }
        $arr['store_type']=$this->adminStore['store_type'];
        return json(dataFormat(0, 'ok', $arr));
    }

    function _getAlias()
    {
        return 'S';
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

    public function _getJoin()
    {
        $join=[];
        if ($this->adminUser['admin_type'] == ADMIN_SERVICE_NEW) {
            $join[]=['store_dealer SD','SD.store_id = S.store_id'];
        }
        return $join;
    }
    
    function _getWhere(){
        $params = $this->request->param();
        $status = isset($params['status']) ? intval($params['status']) : 1;
        $where = [
            'S.is_del'        => 0,
            'S.enter_type'    => 1,
        ];
        if (isset($params['status'])) {
            $where['S.check_status'] = $status;
        }
        if ($this->adminUser['admin_type'] == ADMIN_CHANNEL) {
            $where['action_store_id'] = $this->adminUser['store_id'];
        }

        if ($this->adminUser['admin_type'] == ADMIN_SERVICE_NEW) {
            $where['SD.ostore_id'] = $this->adminUser['store_id'];
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