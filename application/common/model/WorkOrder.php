<?php
namespace app\common\model;
use think\Model;

class WorkOrder extends Model
{
	public $error;
	protected $fields;
	protected $pk = 'worder_id';

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
    public function save($data = [], $where = [], $sequence = null)
    {
        parent::checkBeforeSave($data, $where);
        if (!$this->checkBeforeSave($data, $where)) {
            return false;
        }
        $flag = $this->exists;
        $result = $worderId = parent::save($data, $where, $sequence);
        if (!$flag) {
            $sn = $this->_getWorderSn();
            $this->save(['worder_sn' => $sn], ['worder_id' => $worderId]);
            //工单创建成功后填写工单号
            $worder = $this->getWorderDetail($sn, $data['post_user_id']);
            $user = db('user')->where(['user_id' => $worder['post_user_id']])->find();
            $this->worderLog($worder, $user, '创建工单');
        }
        return $result;
    }
    /**
     * 根据工单号获取售后工单信息
     * @param string $worderSn
     * @param array $user
     * @return boolean|unknown
     */
    public function getWorderDetail($worderSn = '', $user = [])
    {
        if (!$worderSn) {
            $this->error = '参数错误';
            return FALSE;
        }
        $where = [
            'worder_sn' => $worderSn, 
            'is_del' => 0,
        ];
        $info = $this->where($where)->find();
        if (!$info) {
            $this->error = lang('NO ACCESS');
            return FALSE;
        }
        return $info;
    }
    /**
     * 分配安装员操作
     * @param array $worder
     * @param array $user
     * @param int $installerId
     * @return boolean
     */
    public function worderDispatch($worder = [], $user = [], $installerId = 0)
    {
        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }
        //判断用户是否有分派工程师权限(仅服务商有分派工程师权限)
        if ($user['admin_type'] == ADMIN_SERVICE && $user['store_id'] != $worder['store_id']) {
            $this->error = '当前账户无操作权限';
            return FALSE;
        }
        $installer = db('user_installer')->where(['installer_id' => $installerId, 'is_del' => 0, 'store_id' => $worder['store_id']])->find();
        if (!$installer) {
            $this->error = '售后工程师不存在或已删除';
            return FALSE;
        }
        if (!$installer['status']) {
            $this->error = '售后工程师已禁用，请启用后选择';
            return FALSE;
        }
        $action = '分派工程师';
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['status']) {
            case -1://已取消可另外分派
                $action = '重新分派工程师';
                break;
            case 1://已分派工程师 可另外分派
                if ($worder['installer_id'] == $installerId) {
                    $this->error = '不能重复分派同一工程师';
                    return FALSE;
                }
                $action = '重新分派工程师';
                break;
            case 2://待上门  可另外分派
                if ($worder['installer_id'] == $installerId) {
                    $this->error = '不能重复分派同一工程师';
                    return FALSE;
                }
                $action = '重新分派工程师';
                break;
            case 3:
                $this->error = '工程师服务中,无操作权限';
                return FALSE;
            case 4:
                $this->error = '服务已完成,无操作权限';
                return FALSE;
            default:
                ;
                break;
        }
        $result = $this->save(['status' => 1, 'installer_id' => $installerId, 'dispatch_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $msg = '工程师姓名:'.$installer['realname'].'<br>工程师电话:'.$installer['phone'];
            $this->worderLog($worder, $user, $action, $msg);
            return TRUE;
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    /**
     * 工程师接单操作
     * @param array $worder
     * @param array $user
     * @param array $installer
     * @return boolean
     */
    public function worderReceive($worder, $user, $installer)
    {
        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }
        if (isset($worder['installer_id']) && $worder['installer_id'] && $worder['installer_id'] != $installer['installer_id']) {
            $this->error = '无操作权限';
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['status']) {
            case -1:
                $this->error = '工单已取消,无操作权限';
                return FALSE;
            case 0:
                $this->error = '工单待分派工程师,无操作权限';
                return FALSE;
            case 2:
                $this->error = '工单已接收,无操作权限';
                return FALSE;
            case 3:
                $this->error = '工程师服务中,无操作权限';
                return FALSE;
            case 4:
                $this->error = '服务已完成,无操作权限';
                return FALSE;
            default:
                ;
                break;
        }
        $result = $this->save(['status' => 2, 'receive_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $this->worderLog($worder, $user, '工程师接单');
            return TRUE;
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    /**
     * 工程师签到操作
     * @param array $worder
     * @param array $user
     * @param array $installer
     * @return boolean
     */
    public function worderSign($worder, $user, $installer)
    {
        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }
        if ($worder['installer_id'] != $installer['installer_id']) {
            $this->error = '无操作权限';
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['status']) {
            case -1:
                $this->error = '工单已取消,无操作权限';
                return FALSE;
            case 0:
                $this->error = '工单待分派工程师,无操作权限';
                return FALSE;
            case 1:
                $this->error = '工单待接单,无操作权限';
                return FALSE;
            case 3:
                $this->error = '工程师服务中,无操作权限';
                return FALSE;
            case 4:
                $this->error = '服务已完成,无操作权限';
                return FALSE;
            default:
                ;
                break;
        }
        $result = $this->save(['status' => 3, 'sign_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $this->worderLog($worder, $user, '工程师签到,服务开始');
            return TRUE;
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    /**
     * 工单完成操作
     * @param array $worder
     * @param array $user
     * @return boolean
     */
    public function worderFinish($worder, $user)
    {
        $worder = $this->getWorderDetail($worder['worder_sn'], $user);
        if (!$worder) {
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['status']) {
            case -1:
                $this->error = '工单已取消,无操作权限';
                return FALSE;
            case 0:
                $this->error = '待分派工程师,无操作权限';
                return FALSE;
            case 1:
                $this->error = '待接单,无操作权限';
                return FALSE;
            case 2:
                $this->error = '待上门,无操作权限';
                return FALSE;
            case 4:
                $this->error = '服务已完成,无操作权限';
                return FALSE;
        }
        $result = $this->save(['status' => 4, 'finish_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //确认完成，服务商服务费入账
            $where = [
                'is_del'    => 0,
                'worder_id' => $worder['worder_id'],
                'order_sn'  => $worder['order_sn'],
                'osku_id'   => $worder['osku_id'],
            ];
            $incomeModel = db('store_service_income');
            $exist = $incomeModel->where($where)->find();
            if (!$exist) {
                $amount = $worder['install_price'];
                $data = [
                    'store_id'      => $worder['store_id'],
                    'worder_id'     => $worder['worder_id'],
                    'worder_sn'     => $worder['worder_sn'],
                    'order_sn'      => $worder['order_sn'],
                    'osku_id'       => $worder['osku_id'],
                    'goods_id'      => $worder['goods_id'],
                    'sku_id'        => $worder['sku_id'],
                    'installer_id'  => $worder['installer_id'],
                    'install_amount'=> $amount,
                    'income_status' => 0,
                    'add_time'      => time(),
                    'update_time'   => time(),
                ];
                $logId = $incomeModel->insertGetId($data);
                if ($logId) {
                    //修改商户账户收益信息
                    $financeModel = new \app\common\model\StoreFinance();
                    $params = [
                        'pending_amount'=> $amount,
                        'total_amount'  => $amount,
                    ];
                    $result = $financeModel->financeChange($worder['store_id'], $params, '工单完成,计算收益', $worder['worder_sn']);
                }
            }
            //操作日志记录
            $this->worderLog($worder, $user, '确认完成');
            return TRUE;
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    public function TEST($worder, $assessId, $user)
    {
        //评论后，服务商安装服务费结算
        $where = [
            'is_del'    => 0,
            'worder_id' => $worder['worder_id'],
            'order_sn'  => $worder['order_sn'],
            'osku_id'   => $worder['osku_id'],
            'income_status' => 0,
        ];
        $incomeModel = db('store_service_income');
        $exist = $incomeModel->where($where)->find();
        if ($exist) {
            $assessId = 1;
            #TODO 根据评价数据计算得分
            $installAmount = $exist['install_amount'];
            $score = 70;
            $amount = $installAmount * $score/100;
            $data = [
                'assess_id'     => $assessId,
                'score'         => $score,
                'income_amount' => $amount,
                'income_status' => 1,
                'update_time'   => time(),
            ];
            $logId = $incomeModel->where(['log_id' => $exist['log_id']])->update($data);
            if ($logId) {
                //修改商户账户收益信息
                $financeModel = new \app\common\model\StoreFinance();
                $params = [
                    'amount'        => $amount,//可提现金额
                    'pending_amount'=> -$installAmount,//待结算金额(减去预安装金额)
                    'total_amount'  => $amount,
                ];
                if ($amount < $installAmount) {
                    $params['total_amount'] = - ($installAmount - $amount);
                }
                $result = $financeModel->financeChange($exist['store_id'], $params, '工单完成评价,结算收益', $worder['worder_sn']);
            }
        }
    }
    
    /**
     * 取消工单操作
     * @param int $worderId
     * @param int $userId
     * @return boolean
     */
    public function worderCancel($worder = [], $user = [])
    {
        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['status']) {
            case -1:
                $this->error = '工单已取消,无操作权限';
                return FALSE;
            case 3:
                $this->error = '工程师服务中,无操作权限';
                return FALSE;
            case 4:
                $this->error = '服务已完成,无操作权限';
                return FALSE;
            default:
                ;
                break;
        }
        #TODO 判断用户是否有取消权限
        $result = $this->save(['status' => -1, 'cancel_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $this->worderLog($worder, $user, '取消工单', '');
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    
    /**
     * 工单评价操作
     * @param array $worder
     * @param array $user
     * @param array $assessData 用户提交评价信息
     */
    public function worderAssess($worder = [], $user = [], $assessData = []){
        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }
        $nickname = isset($user['realname']) && $user['realname'] ? $user['realname'] : (isset($user['nickname']) && $user['nickname'] ? $user['nickname'] : (isset($user['username']) && $user['username'] ? $user['username'] : ''));
        $data = [
            'worder_id'     =>  $worder['worder_id'],
            'worder_sn'     =>  $worder['worder_sn'],
            'installer_id'  =>  $worder['installer_id'],
            'post_user_id'  =>  $user['user_id'],
            'nickname'      =>  $nickname,
            'type'          =>  $assessData['type'],//1 首次评价 2 追加评价(追加评价只有评价内容,没有评分)
            'msg'           =>  $assessData['msg'],
            'add_time'      =>  time(),
        ];
        $assessId = db('work_order_assess')->insertGetId($data);//添加评价记录
        if($assessId){
            //操作日志记录
            $this->worderLog($worder, $user, '工单评价', $assessData['msg']);
            switch ($assessData['type']){
                case 1://首次评价带评分,记录评分信息
                    $scoreData = $assessData['score'];
                    if(!$scoreData && !is_array($scoreData)){
                        foreach ($scoreData as $k=>$v){
                            //记录单次评分日志
                            $data = [
                                'assess_id'     => $assessId,
                                'installer_id'  => $worder['installer_id'],
                                'config_id'     => $k,
                                'value'         => $v,
                            ];
                            db('work_order_assess_log')->insert($data);//添加评分日志记录
                            model('user_installer')->assessAdd($worder['installer_id'],$k,$v);
                        }
                        return $assessId;
                    }else{
                        return false;
                    }
                    break;
                case 2:
                    return $assessId;
                    break;
                default:
                    return $assessId;
            }
        }else{
            return false;
        }
    }
    /**
     * 工单日志记录操作
     * @param array $worder
     * @param array $user
     * @param string $action
     * @param string $msg
     * @return number|string
     */
    public function worderLog($worder, $user, $action = '', $msg = '')
    {
        $nickname = isset($user['realname']) && $user['realname'] ? $user['realname'] : (isset($user['nickname']) && $user['nickname'] ? $user['nickname'] : (isset($user['username']) && $user['username'] ? $user['username'] : ''));
        $data = [
            'worder_id' => $worder['worder_id'],
            'worder_sn' => $worder['worder_sn'],
            'user_id'   => $user['user_id'],
            'nickname'  => $nickname,
            'action'    => $action,
            'msg'       => $msg,
            'add_time'  => time(),
        ];
        return $result = db('work_order_log')->insertGetId($data);
    }
    private function _getWorderSn($sn = '')
    {
        $sn = $sn ? $sn : date('YmdHis').get_nonce_str(6, 2);
        //判断售后工单号是否存在
        $info = $this->where(['worder_sn' => $sn])->find();
        if ($info){
            return $this->_getWorderSn();
        }else{
            return $sn;
        }
    }
}