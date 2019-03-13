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
        $status = $request->param('status', '', 'intval');
        $workOrderType = $request->param('type', '', 'intval');
        $where = ['WO.is_del' => 0];
        $join = [
            ['goods G', 'G.goods_id = WO.goods_id', 'LEFT'],
            ['user_installer UG', 'UG.installer_id = WO.installer_id', 'LEFT'],
        ];
        $field = 'WO.installer_id,WO.worder_id,WO.worder_sn,WO.work_order_type,WO.user_name,WO.phone,WO.region_name';
        $field .= ',WO.address,WO.appointment,WO.work_order_status,WO.add_time,WO.cancel_time,WO.receive_time,WO.sign_time';
        $field .= ',WO.finish_time,G.name as sku_name,if(WO.work_order_status > 0, 0, 1) as wstatus';
        $where['WO.post_user_id'] = $user['user_id'];
        $field .= ',UG.realname installer_name,UG.phone installer_phone';
        if ($workOrderType) {
            $where['work_order_type'] = $workOrderType;
        }
        if ('' !== $status) {
            $where['WO.work_order_status'] = $status;
        }
        $order = 'wstatus ASC,  WO.work_order_status ASC';
        $list = $this->getModelList(db('work_order'), $where, $field, $order, 'WO', $join);
        if (empty($list)) {
            return $this->dataReturn(1, '暂无数据');
        }
        foreach ($list as $key => $value) {
            $list[$key]['add_time'] = time_to_date($value['add_time']);
            $list[$key]['cancel_time'] = time_to_date($value['cancel_time']);
            $list[$key]['receive_time'] = time_to_date($value['receive_time']);
            $list[$key]['sign_time'] = time_to_date($value['sign_time']);
            $list[$key]['appointment'] = $value['appointment'] ? date('Y-m-d H:i', $value['appointment']) : '';
            $list[$key]['work_order_type'] = $value['work_order_type'];
            $list[$key]['work_order_type_txt'] = get_work_order_type($value['work_order_type']);
            $list[$key]['status_txt'] = get_work_order_installer_status($value['work_order_status']);
            //判断当前工单是否有首次评价和追加评价
            $exist = db('work_order_assess')->field('count(if(type = 1, true, NULL)) as type1, count(if(type = 2, true, NULL)) as type2')->where(['worder_id' => $value['worder_id']])->find();
            $list[$key]['first_assess'] = $exist && isset($exist['type1']) && $exist['type1'] > 0 ? 1 : 0;
            $list[$key]['append_assess'] = $exist && isset($exist['type2']) && $exist['type2'] > 0 ? 1 : 0;
        }
        return $this->dataReturn(0, 'ok', $list);
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
        $field .= ',WO.phone,WO.region_name,WO.address,WO.appointment,WO.images,WO.fault_desc,WO.work_order_status';
        $field .= ',WO.add_time,WO.dispatch_time,WO.cancel_time,WO.receive_time,WO.sign_time,WO.finish_time';
        $where = [
            'WO.is_del'       => 0,
            'WO.post_user_id' => $user['user_id'],
            'WO.worder_sn'    => $worderSn,
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
        $detail['work_order_type_txt'] = get_work_order_type($detail['work_order_type']);
        $detail['status_txt'] = get_work_order_installer_status($detail['work_order_status']);
        $exist = db('work_order_assess')->field('count(if(type = 1, true, NULL)) as type1, count(if(type = 2, true, NULL)) as type2')->where(['worder_id' => $detail['worder_id']])->find();
        $detail['first_assess'] = $exist && isset($exist['type1']) && $exist['type1'] > 0 ? 1 : 0;
        $detail['append_assess'] = $exist && isset($exist['type2']) && $exist['type2'] > 0 ? 1 : 0;
        $sku = db('goods')->field('goods_id,name,thumb')->where(['goods_id' => $detail['goods_id']])->find();
        //工单完成后获取首次评价
        $workOrderModel = new \app\common\model\WorkOrder();
        $assess = $workOrderModel->getWorderAssess($detail, 'assess_id, type, msg, add_time');
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
            'is_del'       => 0,
            'post_user_id' => $user['user_id'],
            'worder_sn'    => $worderSn,
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
        $score = $request->param('score', '', 'trim');

        $worderSn = $request->param('worder_sn', '', 'trim');
        $where = [
            'is_del'       => 0,
            'post_user_id' => $user['user_id'],
            'worder_sn'    => $worderSn,
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
        $scores = $score ? json_decode($score, 1) : [];
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

    //提交维修工单
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
        //return db('goods')->where($where)->find();



        return;

        $user = $this->_checkOpenid(FALSE, FALSE, TRUE);
        //         if ($user['installer']) {
        //             $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务工程师不允许申请工单']);
        //         }
        $goods = $this->_checkGoods();
        $userName = isset($this->postParams['user_name']) ? trim($this->postParams['user_name']) : '';
        $phone = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        $regionId = isset($this->postParams['region_id']) ? intval($this->postParams['region_id']) : 0;
        $regionName = isset($this->postParams['region_name']) ? trim($this->postParams['region_name']) : '';
        $address = isset($this->postParams['address']) ? trim($this->postParams['address']) : '';
        $appointment = isset($this->postParams['appointment']) ? trim($this->postParams['appointment']) : '';
        $faultDesc = isset($this->postParams['fault_desc']) ? trim($this->postParams['fault_desc']) : '';
        $images = isset($this->postParams['images']) ? trim($this->postParams['images']) : '';
        if (!$userName) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '客户姓名(user_name)缺失']);
        }
        if (!$phone) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '客户电话(phone)缺失']);
        }
        if (!$regionId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务区域(region_id)缺失']);
        }
        if (!$regionName) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务区域(region_name)缺失']);
        }
        if (!$address) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '客户地址(address)缺失']);
        }
        if (!$appointment) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '预约服务时间(appointment)缺失']);
        }
        //         if (!$faultDesc) {
        //             $this->_returnMsg(['errCode' => 1, 'errMsg' => '故障描述(fault_desc)缺失']);
        //         }
        $storeModel = new \app\common\model\Store();
        //根据安装地址分配服务商
        $storeId = $storeModel->getStoreFromRegion($regionId);
        if (!$storeId) {
            //获取当前地址的parent_id
            $parentId = db('region')->where(['region_id' => $regionId])->value('parent_id');
            if ($parentId) {
                $storeId = $storeModel->getStoreFromRegion($parentId);
            }
            if (!$storeId) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '抱歉，您选择的区域暂无服务商']);
            }
        }
        $workOrderModel = model('work_order');
        $this->postParams['install_price'] = $goods['install_price'];
        $this->postParams['work_order_type'] = 2;
        $this->postParams['post_user_id'] = $user['user_id'];
        $this->postParams['user_id'] = $user['user_id'];
        $this->postParams['factory_id'] = $this->factory['store_id'];
        $this->postParams['store_id'] = $storeId;
        $this->postParams['appointment'] = strtotime($appointment);
        //报修上传故障图片(英文分号分隔)
        $images = $this->postParams['images'] ? trim($this->postParams['images']) : '';
        $images = $images ? explode(',', $images) : [];
        $images = $images ? array_unique($images) : [];
        $images = $images ? array_filter($images) : [];
        if (count($images) > 3) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '图片最大数量(3)']);
        }
        $this->postParams['images'] = implode(',', $images);
        $sn = $workOrderModel->save($this->postParams);
        if ($sn) {
            $this->_returnMsg(['msg' => '维修工单提交成功', 'worder_sn' => $sn]);
        } else {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '系统错误']);
        }
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
        $phone = $request->param('phone');
        $user = db('user')->where(['is_del' => 0, 'phone' => $phone])->find();
        if (empty($user)) {
            return dataFormat(100101, '手机号未绑定');
        }
        if (!$user['status']) {
            return dataFormat(100102, '用户已被禁用');
        }
        return dataFormat(0, 'ok', $user);
    }

}