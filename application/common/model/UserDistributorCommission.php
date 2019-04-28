<?php
namespace app\common\model;
use think\Model;
use think\Db;

class UserDistributorCommission extends Model
{
	public $error;
	protected $fields;
	protected $pk = 'log_id';

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
    /**
     * 佣金记录
     * @param array $order
     * @param int $promotId
     * @param array $promotSku
     * @param int $joinId
     * @return boolean
     */
    public function calculate($order, $promotId = 0, $orderSku = [], $joinId = 0)
    {
        if (!$orderSku) {
            return FALSE;
        }
        $where = [
            ['is_del', '=', 0],
            ['join_id', '=', $joinId],
            ['promot_id', '=', $promotId],
            ['store_id', '=', $order['factory_id']],
            ['udata_id', '<>', $order['udata_id']],
        ];
        $join = model('PromotionJoin')->where($where)->find();
        if (!$join) {
            return FALSE;
        }
        $goodsId = $orderSku['goods_id'];
        $where = [
            ['promot_id', '=', $promotId],
            ['is_del', '=', 0],
            ['goods_id', '=', $goodsId],
            ['store_id', '=', $order['factory_id']],
        ];
        $promotSku = model('PromotionSku')->where($where)->find();
        if (!$promotSku) {
            return FALSE;
        }
        //1 销售佣金计算
        $result = $this->_save($order, $promotSku, $join, 1);
        //2 管理佣金计算
        $result = $this->_save($order, $promotSku, $join, 2);
        return TRUE;
        
    }
    /**
     * 订单佣金结算
     * @param array $order
     * @return boolean
     */
    public function settlement($order)
    {
        $where = [
            ['order_sn',    '=', $order['order_sn']],
            ['join_id',     '=', $order['promot_join_id']],
            ['promot_id',   '=', $order['promot_id']],
            ['commission_status', '=', 0],
        ];
        $logs = $this->where($where)->select();
        if (!$logs) {
            return FALSE;
        }
        $logIds = [];
        $userLogModel = new \app\common\model\UserLog();
        $userModel = new \app\common\model\User();
        foreach ($logs as $key => $value) {
            $logId = intval($value['log_id']);
            if (!$logId) {
                continue;
            }
            $logIds[] = $logId;
            //佣金入账
            $extra = [
                'msg'   => '分销'.($value['comm_type']==1 ? '销售' : '管理').'佣金入账',
                'order_sn' => $value['order_sn'],
                'extra_id' => $logId,
            ];
            $amount = $value['value'];
            $userId = intval($value['user_id']);
            $result = $userLogModel->record($userId, 'amount', $amount, 'fenxiao_order', $extra);
            if ($result !== FALSE && $amount > 0) {
                //减少待结算金额 总金额不变
                $result = $userModel->where('user_id', $userId)->setDec('pending_amount', $amount);
            }
        }
        //收益状态(0待结算 1已结算 2已退还)
        $result = $this->save(['commission_status' => 1], ['log_id' => ['IN', $logIds]]);
        return TRUE;
    }
    /**
     * 佣金退还
     * @param array $order
     */
    public function return($order)
    {
        $where = [
            ['order_sn',    '=', $order['order_sn']],
            ['join_id',     '=', $order['promot_join_id']],
            ['promot_id',   '=', $order['promot_id']],
            ['commission_status', '=', 0],//收益状态(0待结算 1已结算 2已退还)
        ];
        $logs = $this->where($where)->select();
        if (!$logs) {
            return FALSE;
        }
        $userModel = model('User');
        $logIds = [];
        foreach ($logs as $key => $value) {
            $logIds[] = $value['log_id'];
            if ($value['value'] > 0) {
                //减少待结算金额和总金额
                $data = [
                    'pending_amount' => Db::raw('pending_amount-'.$value),
                    'total_amount' => Db::raw('total_amount-'.$value),
                ];
                $result = $userModel->save($data, ['user_id' => $value['user_id']]);
            }
        }
        //收益状态(0待结算 1已结算 2已退还)
        $result = $this->save(['commission_status' => 2], ['log_id' => ['IN', $logIds]]);
        return TRUE;
    }
    private function _save($order, $promotSku, $join, $type = 1)
    {
        $field = $type == 1? 'sale' : 'manage';
        $distrtId = $join['distrt_id'];
        $userId = $join['user_id'];
        //判断订单是否已经完成佣金计算
        $where = [
            ['order_sn', '=', $order['order_sn']],
            ['comm_type', '=', $type],
        ];
        $exist = $this->where($where)->find();
        if ($exist) {
            return FALSE;
        }
        if ($type == 2) {
            $distributor = model('UserDistributor');
            //获取分销员的上级
            $distrtor = $distributor->where('distrt_id', $distrtId)->find();
            if ($distrtor && $distrtor['parent_id']) {
                $parent = $distributor->where('distrt_id', $distrtor['parent_id'])->find();
                if (!$parent) {
                    return FALSE;
                }
                $userId = $parent['user_id'];
                $distrtId = $parent['distrt_id'];
            }else{
                return FALSE;
            }
        }
        $realAmount = $order['real_amount'];
        
        $commissionJson = $promotSku[$field.'_commission'];
        $commission = json_decode($commissionJson, 1);
        $cType = $commission ? $commission['type'] : '';
        $cValue = $commission ? $commission['value'] : '';
        switch ($cType) {
            case 'ratio':
                $value = $realAmount > 0 ? $realAmount*$cValue/100 : 0;
                break;
            case 'fix_amount':
                $value = $realAmount > $cValue ? $cValue : $realAmount;
                break;
            default:
                return FALSE;
                break;
        }
        //保留小数点后两位四舍五入
        $value = sprintf("%0.2f", $value);
        //计算管理员佣金
        $data = [
            'user_id'   => $userId,
            'distrt_id' => $distrtId,
            'value'     => $value,
            'comm_type' => $type,
            'commission_json'   => $commissionJson,
            'settle_type'   => $commission['type'],
            'settle_value'  => $commission['value'],
            'order_sn'      => $order['order_sn'],
            'join_id'       => $join['join_id'],
            'promot_id'     => $join['promot_id'],
            'post_udata_id' => $order['udata_id'],
            'post_user_id'  => $order['user_id'],
            'commission_status' => 0,//收益状态(0待结算 1已结算 2已退还)
            'add_time'  => time(),
            'update_time'  => time(),
        ];
        $result = $this->insert($data);
        if($value > 0){
            //增加用户待结算金额和总金额
            $data = [
                'pending_amount' => Db::raw('pending_amount+'.$value),
                'total_amount' => Db::raw('total_amount+'.$value),
            ];
            $result = model('User')->save($data, ['user_id' => $userId]);
        }
        return TRUE;
    }
}