<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/3/11 0011
 * Time: 15:11
 */

namespace app\open\controller\v10;

use app\open\controller\Base;
use app\open\validate\WorkOrderVal;
use think\Request;

class WorkOrder extends Base
{
    //工单列表
    public function index(Request $request)
    {
        $check = new WorkOrderVal();
        if (!$check->scene('list')->check($request->param())) {
            return $this->dataReturn(100100, $check->getError());
        }
        $userCheck = $this->getUser($request);
        if ($userCheck['code'] != 0) {
            return $this->dataReturn($userCheck);
        }
        $user = $userCheck['data'];
        $status = $request->param('status', '');
        $workOrderType = $request->param('type', '', 'intval');
        $where = ['WO.is_del' => 0];
        $join = [
            ['goods G', 'G.goods_id = WO.goods_id', 'LEFT'],
            ['user_installer UG', 'UG.installer_id = WO.installer_id', 'LEFT'],
        ];
        $field = 'WO.installer_id,WO.worder_id,WO.worder_sn,WO.work_order_type,WO.user_name,WO.phone,WO.region_name';
        $field .= ',WO.address,WO.appointment,WO.appointment_end,WO.work_order_status,WO.add_time,WO.cancel_time,WO.receive_time,WO.sign_time';
        $field .= ',WO.finish_time,G.name as sku_name,if(WO.work_order_status > 0, 0, 1) as wstatus,WO.device_sn';
        $where['WO.post_udata_id'] = $user['udata_id'];
        $field .= ',UG.realname installer_name,UG.phone installer_phone';
        if ($workOrderType) {
            $where['work_order_type'] = $workOrderType;
        }
        if ('' !== $status) {
            $where['WO.work_order_status'] = intval($status);
        }
        $order = 'WO.worder_id desc,wstatus ASC,WO.work_order_status ASC';
        $result = $this->getModelList(db('work_order'), $where, $field, $order, 'WO', $join);
        if ($result) {
            $list = $result['list'];
            foreach ($list as $key => $value) {
                $list[$key]['add_time'] = time_to_date($value['add_time']);
                $list[$key]['cancel_time'] = time_to_date($value['cancel_time']);
                $list[$key]['receive_time'] = time_to_date($value['receive_time']);
                $list[$key]['sign_time'] = time_to_date($value['sign_time']);
                $list[$key]['appointment'] = $value['appointment'] ? date('Y-m-d H:i', $value['appointment']) : '';
                $list[$key]['appointment_end'] = $value['appointment_end'] ? date('Y-m-d H:i', $value['appointment_end']) : '';
                $list[$key]['work_order_type'] = $value['work_order_type'];
                $list[$key]['work_order_type_txt'] = get_work_order_type($value['work_order_type']);
                $list[$key]['status_txt'] = get_work_order_installer_status($value['work_order_status']);
                //判断当前工单是否有首次评价和追加评价
                $exist = db('work_order_assess')->field('count(if(type = 1, true, NULL)) as type1, count(if(type = 2, true, NULL)) as type2')->where(['worder_id' => $value['worder_id']])->find();
                $list[$key]['first_assess'] = $exist && isset($exist['type1']) && $exist['type1'] > 0 ? 1 : 0;
                $list[$key]['append_assess'] = $exist && isset($exist['type2']) && $exist['type2'] > 0 ? 1 : 0;
                unset($list[$key]['installer_id'], $list[$key]['worder_id']);
            }
            $result['list'] = $list;
        }
        return $this->dataReturn(0, 'ok', $result);
    }

    //工单详情
    public function detail(Request $request)
    {
        $check = new WorkOrderVal();
        if (!$check->scene('detail')->check($request->param())) {
            return $this->dataReturn(100100, $check->getError());
        }
        $userCheck = $this->getUser($request);
        if ($userCheck['code'] != 0) {
            return $this->dataReturn($userCheck);
        }
        $user = $userCheck['data'];
        $worderSn = $request->param('worder_sn', '', 'trim');
        $field = 'WO.worder_id,WO.worder_sn,WO.installer_id,WO.goods_id,WO.work_order_type,WO.order_sn,WO.user_name';
        $field .= ',WO.phone,WO.region_name,WO.address,WO.appointment,WO.appointment_end,WO.images,WO.fault_desc,WO.work_order_status';
        $field .= ',WO.device_sn,WO.device_type,WO.add_time,WO.dispatch_time,WO.cancel_time,WO.receive_time,WO.sign_time,WO.finish_time';
        $where = [
            'WO.is_del'        => 0,
            'WO.post_udata_id' => $user['udata_id'],
            'WO.worder_sn'     => $worderSn,
        ];
        $join = [];
        $detail = db('work_order')->alias('WO')->join($join)->field($field)->where($where)->find();
        if (empty($detail)) {
            return $this->dataReturn(100103, '工单号不存在或已被删除');
        }
        $detail['add_time'] = time_to_date($detail['add_time']);
        $detail['dispatch_time'] = time_to_date($detail['dispatch_time']);
        $detail['cancel_time'] = time_to_date($detail['cancel_time']);
        $detail['receive_time'] = time_to_date($detail['receive_time']);
        $detail['sign_time'] = time_to_date($detail['sign_time']);
        $detail['finish_time'] = time_to_date($detail['finish_time']);

        $detail['images'] = $detail['images'] ? explode(',', $detail['images']) : [];
        $detail['appointment'] = $detail['appointment'] ? date('Y-m-d H:i', $detail['appointment']) : '';
        $detail['appointment_end'] = $detail['appointment_end'] ? date('Y-m-d H:i', $detail['appointment_end']) : '';
        $detail['work_order_type_txt'] = get_work_order_type($detail['work_order_type']);
        $detail['status_txt'] = get_work_order_installer_status($detail['work_order_status']);
        $exist = db('work_order_assess')->field('count(if(type = 1, true, NULL)) as type1, count(if(type = 2, true, NULL)) as type2')->where(['worder_id' => $detail['worder_id']])->find();
        $detail['first_assess'] = $exist && isset($exist['type1']) && $exist['type1'] > 0 ? 1 : 0;
        $detail['append_assess'] = $exist && isset($exist['type2']) && $exist['type2'] > 0 ? 1 : 0;
        $sku = db('goods')->field('goods_id,name,thumb')->where(['goods_id' => $detail['goods_id']])->find();
        //工单完成后获取首次评价
        $workOrderModel = new \app\common\model\WorkOrder();
        $assess = $workOrderModel->getWorderAssess($detail, 'assess_id, type, msg, add_time');
        unset($detail['installer_id'], $detail['worder_id']);
        $result = ['detail' => $detail, 'sku' => $sku, 'assess_list' => $assess];
        return $this->dataReturn(0, 'ok', $result);
    }

    //取消工单
    public function cancel(Request $request)
    {
        $check = new WorkOrderVal();
        if (!$check->scene('cancel')->check($request->param())) {
            return $this->dataReturn(100100, $check->getError());
        }
        $userCheck = $this->getUser($request);
        if ($userCheck['code'] != 0) {
            return $this->dataReturn($userCheck);
        }
        $user = $userCheck['data'];
        $worderSn = $request->param('worder_sn', '', 'trim');
        $remark = $request->param('remark');
        $where = [
            'is_del'        => 0,
            'post_udata_id' => $user['udata_id'],
            'worder_sn'     => $worderSn,
        ];
        $workOrder = db('work_order')->where($where)->find();
        if (empty($workOrder)) {
            return $this->dataReturn(100103, '工单号不存在或已被删除');
        }
        $worderModel = new \app\common\model\WorkOrder();
        $result = $worderModel->worderCancel($workOrder, $user, $remark);
        if ($result !== FALSE) {
            return $this->dataReturn(0, '工单取消成功');
        } else {
            return $this->dataReturn(100105, $worderModel->error);
        }
    }

    //工单评价
    public function assess(Request $request)
    {
        $check = new WorkOrderVal();
        if (!$check->scene('assess')->check($request->param())) {
            return $this->dataReturn(100100, $check->getError());
        }
        $userCheck = $this->getUser($request);
        if ($userCheck['code'] != 0) {
            return $this->dataReturn($userCheck);
        }
        $user = $userCheck['data'];
        $type = $request->param('type', '', 'intval');
        $msg = $request->param('msg');
        $score = $request->param('score');

        $worderSn = $request->param('worder_sn', '', 'trim');
        $where = [
            'is_del'        => 0,
            'post_udata_id' => $user['udata_id'],
            'worder_sn'     => $worderSn,
        ];
        $workOrder = db('work_order')->where($where)->find();
        if (empty($workOrder)) {
            return $this->dataReturn(100103, '工单号不存在或已被删除');
        }
        //1 首次评论 2 追加评论
        if ($type <= 0 || !in_array($type, [1, 2])) {
            return $this->dataReturn(100100, '评价类型错误');
        }
        if ($type == 1 && empty($score)) {
            return $this->dataReturn(100100, '评分不能为空');
        }
        //$scores = $score ? json_decode($score, 1) : [];
        $scores = $score;
        if ($type == 1 && empty($scores)) {
            return $this->dataReturn(100100, '评分数据格式不正确');
        }
        $params = [
            'type'  => $type,
            'msg'   => $msg,
            'score' => [],
        ];
        if ($scores) {
            $config = $this->getAssessConfig();
            if ($config['code'] !== '0') {
                return $this->dataReturn($config);
            }
            $config = $config['data'];
            $scores = array_column($scores, 'score', 'config_id');
            foreach ($config as $key => $value) {
                $id = $value['config_id'];
                $name = $value['name'];
                if (!isset($scores[$id])) {
                    return $this->dataReturn(100100, $name . ' 评价不能为空');
                }
                if ($scores[$id] <= 0 || $scores[$id] > $value['score']) {
                    return $this->dataReturn(100100, $name . ' 必须在(1-' . $value['score'] . '分之间)');
                }
                $params['score'][$id] = $scores[$id];
            }
        }
        $worderModel = new \app\common\model\WorkOrder();
        $result = $worderModel->worderAssess($workOrder, $user, $params);
        if ($result !== FALSE) {
            return $this->dataReturn(0, '评价完成');
        } else {
            return $this->dataReturn(100104, $worderModel->error);
        }
    }

    //获取工单评分配置
    public function assessConfig(Request $request)
    {
        $check = new WorkOrderVal();
        if (!$check->scene('assessConfig')->check($request->param())) {
            return $this->dataReturn(100100, $check->getError());
        }
        $userCheck = $this->getUser($request);
        if ($userCheck['code'] != 0) {
            return $this->dataReturn($userCheck);
        }
        $config = $this->getAssessConfig();
        return $this->dataReturn($config);
    }

    //提交工单
    public function add(Request $request)
    {
        $check = new WorkOrderVal();
        if (!$check->scene('add')->check($request->param())) {
            return $this->dataReturn(100100, $check->getError());
        }
        $userCheck = $this->getUser($request);
        if ($userCheck['code'] != 0) {
            return $this->dataReturn($userCheck);
        }
        $user = $userCheck['data'];
        $data['user_name'] = $request->param('user_name');
        $data['phone'] = $request->param('user_mobile');
        $data['region_id'] = $request->param('region_id');
        $data['region_name'] = $request->param('region_name');
        $data['address'] = $request->param('address');
        $data['appointment'] = $request->param('appointment_start', '', 'trim,strtotime');
        $data['appointment_end'] = $request->param('appointment_end', '', 'trim,strtotime');
        $data['fault_desc'] = $request->param('fault_desc','');
        $data['goods_id'] = $request->param('goods_id', '0', 'intval');
        $data['device_sn'] = $request->param('device_sn','');
        $data['device_type'] = $request->param('device_type','');
        $data['work_order_type'] = $request->param('work_type',2,'intval');
        if ($data['appointment'] > $data['appointment_end']) {
            return $this->dataReturn(100100, '预约开始时必须小于结束时间');
        }
        if ($data['appointment_end']-$data['appointment']>21600) {
            return $this->dataReturn(100100, '预约开始时与结束时间跨度不能超过6小时');
        }
        //if ($data['work_order_type']==2 && empty($data['device_sn'])){
        //    return $this->dataReturn(100100, '提交维修工单时设备串码不能为空');
        //}
        //if ($data['work_order_type']==1 && empty($data['device_type'])  && empty($data['device_sn']) ) {
        //    return $this->dataReturn(100100, '提交安装工单时，设备串码和设备类型不能同时为空');
        //}
        if ($data['work_order_type']==1) {
            $where=[
                ['work_order_type','=',1],
                ['post_udata_id','=',$user['udata_id']],
                ['is_del','=',0],
            ];
            if (!empty($data['device_sn'])) {
                $where[]=['device_sn','=',$data['device_sn']];
                $where[]=['work_order_status','>',-1];
                $order=model('work_order')->where($where)->find();
                if (!empty($order)) {
                    return $this->dataReturn(100100, '提交安装工单已提交，请耐心等候');
                }
            } else {
                $where[]=['device_type','=',$data['device_type']];
                $where[]=['work_order_status','>',-1];
                $order=model('work_order')->where($where)->order('worder_id DESC')->find();
                if (!empty($order) && (time()- strtotime($order['add_time'])<60) ) {
                    return $this->dataReturn(100100, '操作频繁！');
                }
            }
        }

        if ($data['appointment'] < time()) {
            return $this->dataReturn(100100, '预约时间不能早于当前时间');
        }
        //报修上传故障图片(英文分号分隔)
        $images = $request->param('images', '', 'trim');
        $images = array_unique(array_filter(explode(',', $images)));
        if (count($images) > 3) {
            return $this->dataReturn(100106, '抱歉，图片最多只能保存3张');
        }
        if ($data['goods_id']) {
            $where = [
                'goods_id' => $data['goods_id'],
                'is_del'   => 0,
            ];
            $goods = db('goods')->where($where)->find();
            if (empty($goods)) {
                return $this->dataReturn(100105, '查无该商品信息');
            }
        }
        //@todo 设备串码码证

        $storeModel = new \app\common\model\Store();
        //根据安装地址分配服务商
        $storeId = $storeModel->getStoreFromRegion($data['region_id']);
        if (!$storeId) {
            //获取当前地址的parent_id
            $parentId = db('region')->where(['region_id' => $data['region_id']])->value('parent_id');
            if ($parentId) {
                $storeId = $storeModel->getStoreFromRegion($parentId);
            }
            if (!$storeId) {
                return $this->dataReturn(100106, '抱歉，您选择的区域暂无服务商');
            }
        }
        $data['post_udata_id'] = $user['udata_id'];
        $data['images'] = implode(',', $images);
        $data['install_price'] = $goods['install_price'] ?? '';
        $data['post_user_id'] = $user['user_id'];
        $data['user_id'] = $user['user_id'];
        $data['factory_id'] = $this->factoryId;
        $data['store_id'] = $storeId;

        $workOrderModel = model('work_order');
        $sn = $workOrderModel->save($data);
        if ($sn) {
            return $this->dataReturn(0, '工单提交成功', ['worder_sn' => $sn]);
        } else {
            return $this->dataReturn(100107, '系统错误');
        }
    }

    //可维修产品列表
    public function goods(Request $request)
    {
        $check = new WorkOrderVal();
        if (!$check->scene('goods')->check($request->param())) {
            return $this->dataReturn(100100, $check->getError());
        }
        $userCheck = $this->getUser($request);
        if ($userCheck['code'] != 0) {
            return $this->dataReturn($userCheck);
        }
        $user = $userCheck['data'];

        $where = [
            'is_del'     => 0,
            'goods_type' => 1,
            'status'     => 1,
        ];
        $field = 'goods_id, name, cate_thumb, thumb';
        $order = 'sort_order ASC, add_time ASC';
        //$this->paginate = false;//不分页
        $list = $this->getModelList(db('goods'), $where, $field, $order);
        if (empty($list)) {
            $list['code'] = 0;
            return $this->dataReturn($list);
        }
        foreach ($list['list'] as $key => $value) {
            $list['list'][$key]['thumb'] = $value['cate_thumb'] ? $value['cate_thumb'] : $value['thumb'];
            unset($list['list'][$key]['cate_thumb']);
        }
        return $this->dataReturn(0,'ok',$list);
    }


    private function getAssessConfig()
    {
        $config = db('config')->field('config_id,name,config_value score')
            ->where(['is_del' => 0, 'status' => 1, 'config_key' => CONFIG_WORKORDER_ASSESS])
            ->order('sort_order ASC, add_time ASC')
            ->select();
        if (empty($config)) {
            return dataFormat(100106, '系统未配置评分信息');
        }
        return dataFormat(0, 'ok', $config);
    }


    private function getUser(Request $request)
    {
        $openid = $request->param('openid');
        $where = [
            'third_openid' => $openid,
            'third_type'   => 'echodata',
            'user_type'    => 'open',
            'is_del'       => 0,
        ];
        $user = model('user_data')->where($where)->find();
        if (empty($user)) {
            $user = model('user_data');
            $user->save([
                'openid'      => $openid,
                'add_time'    => time(),
                'update_time' => time(),
                'third_type'  => 'echodata',
                'user_type'   => 'open',
            ]);
        }
        return dataFormat(0, 'ok', $user);
    }

}