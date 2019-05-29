<?php


namespace app\common\model;


use think\Db;
use think\Model;

class StoreUser extends Model
{
    protected $createTime = 'add_time';
    protected $updateTime = 'update_time';
    protected $autoWriteTimestamp = 'int';
    private $perPage = 10;


    public function getStoreUser($id, $user)
    {
        $mobile = $this->where(['id' => $id, 'is_del' => 0])->value('mobile');
        if (empty($mobile)) {
            return dataFormat(1, '用户不存在');
        }
        //基本信息
        $field = 'p1.id,p1.user_type,p1.realname,p1.mobile,p1.region_name,p1.address,p1.deal_close_time,p1.deal_amount,p1.remark,p2.name,p2.thumb';
        $join = [
            ['goods p2', 'p1.goods_id = p2.goods_id AND p2.is_del = 0']
        ];
        $result['info'] = $this->alias('p1')->field($field)->join($join)->where([
            'p1.id'       => $id,
            'p1.store_id' => $user['store_id'],
            'p1.is_del'   => 0,
        ])/*->fetchSql(true)*/ ->find();
        //订单记录
        $field = 'p1.order_id,p1.order_sn,p1.pay_type,p3.name pay_name,p1.order_type,p1.pay_status,p1.pay_sn,p1.paid_amount,p1.add_time,p1.order_status';
        $join = [
            ['work_order p2', 'p1.order_sn = p2.order_sn'],
            ['payment p3', 'p3.pay_code = p1.pay_code', 'LEFT']
        ];
        $where = [
            'p2.is_del'       => 0,
            'p1.user_id'      => $user['user_id'],
            'p2.phone'        => $mobile,
            'p1.order_status' => ['<', 4],
        ];
        $subQuery = db('order')->alias('p1')
            ->field($field)
            ->join($join)
            ->where($where)
            ->order('p1.order_id DESC')
            ->buildSql();
        $param = filter_request();
        $param['tab'] = 2;
        $orders = Db::table($subQuery . ' pt')
            ->group('pt.order_id')
            ->order('pt.order_id DESC')
            ->paginate($this->perPage, false, [
                'query' => $param,
                'path'  => url('store_user/detail'),
            ]);
        $list = $orders->items();
        $orderModel = new Order;
        foreach ($list as $k => $v) {//安装状态
            $install = $orderModel->getInstallStatus($v);
            $list[$k]['install_apply'] = $install['data'];
        }
        $result['order']['list'] = $list;
        $result['order']['page'] = $orders->render();
        //工单记录
        $param = filter_request();
        $param['tab'] = 3;
        $field = 'p1.worder_id,p1.worder_sn,p1.work_order_type,p1.order_sn,p1.goods_id,p1.user_name,p1.region_name,p1.address,p1.appointment,p1.add_time,p1.carry_goods,p1.work_order_status,p2.realname,p3.`name` goods_name,CASE when p1.work_order_status IN (0,1,2) AND p1.appointment<' . time() . ' THEN 1 ELSE 0  END is_overtime';
        $join = [
            ['user_installer p2', 'p1.installer_id = p2.installer_id AND p2.is_del = 0', 'LEFT'],
            ['goods p3', 'p3.goods_id = p1.goods_id AND p3.is_del = 0', 'LEFT'],
        ];
        $workOrder = db('work_order')->alias('p1')->field($field)->where([
            'p1.phone'  => $mobile,
            'p1.is_del' => 0,
        ])->join($join)->paginate($this->perPage, false, [
            'query'    => $param,
            'var_page' => 'p',
            'path'     => url('store_user/detail'),
        ]);
        $result['work_order']['list'] = $workOrder->items();
        $result['work_order']['page'] = $workOrder->render();

        return dataFormat(0, 'ok', $result);
    }
}