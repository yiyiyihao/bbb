<?php
namespace app\common\model;
use think\Model;

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
     * 创建订单-记录佣金返回数据
     * @param int $step
     * @param array $order
     * @param array $promotion
     * @param array $promotSku
     * @param array $join
     * @return boolean
     */
    public function calculate($step = 1, $order, $promotion = [], $promotSku = [], $join = [])
    {
        if ($step == 1 && $order && $promotion && $promotSku && $join) {
            //1 销售佣金计算
            $result = $this->_save($order, $promotion, $promotSku, $join, 1);
            //2 管理佣金计算
            $result = $this->_save($order, $promotion, $promotSku, $join, 2);
            return TRUE;
        }elseif ($step == 2 || $step == -1){
            $status = $step == 2 ? 1: -1;
            $where = [
                ['order_sn',    '=', $order['order_sn']],
                ['join_id',     '=', $order['promot_join_id']],
                ['promot_id',   '=', $order['promot_id']],
                ['status',      '=', 0],
            ];
            $logIds = $this->where($where)->column('log_id');
            if ($logIds) {
                $result = $this->save(['status' => $status], ['log_id' => ['IN', $logIds]]);
            }
        }
        return FALSE;
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
            ['status',      '=', 1],
        ];
        $logs = $this->where($where)->select();
        if (!$logs) {
            return FALSE;
        }
        $logIds = [];
        $userLogModel = new \app\common\model\UserLog();
        foreach ($logs as $key => $value) {
            $logId = intval($value['log_id']);
            if (!$logId) {
                continue;
            }
            $logIds[] = $logId;
            //佣金入账
            $extra = [
                'msg'   => ($value['comm_type']==1 ? '销售' : '管理').'佣金入账',
                'order_sn' => $value['order_sn'],
                'extra_id' => $logId,
            ];
            $result = $userLogModel->record($value['user_id'], 'balance', $value['value'], 'fenxiao_order', $extra);
        }
        $result = $this->save(['status' => 2], ['log_id' => ['IN', $logIds]]);
        return TRUE;
    }
    
    
    private function _save($order, $promotion, $promotSku, $join, $type = 1)
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
                $userId = $distrtor['user_id'];
                $distrtId = $distrtor['distrt_id'];
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
                $value = $realAmount > 0 ? $realAmount*$cValue/100 : 0;
                break;
            default:
                ;
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
            'commission_json' => $commissionJson,
            'settle_type'   => $commission['type'],
            'settle_value'  => $commission['value'],
            'order_sn'      => $order['order_sn'],
            'join_id'       => $join['join_id'],
            'promot_id'     => $join['promot_id'],
            'post_udata_id' => $order['udata_id'],
            'post_user_id'  => $order['user_id'],
        ];
        $result = $this->save($data);
        //佣金入账
        $extra = [
            'msg'   => ($value['comm_type']==1 ? '销售' : '管理').'佣金入账',
            'order_sn' => $value['order_sn'],
            'extra_id' => $logId,
        ];
        $result = model('UserLog')->record($value['user_id'], 'balance', $value['value'], 'fenxiao_order', $extra);
        return TRUE;
    }
}