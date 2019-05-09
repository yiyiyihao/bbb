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
    
    /**
     * 创建工单
     */
    public function save($data = [], $where = [], $sequence = null,$udata_id=0)
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
            $worder = [
                'worder_sn' => $sn,
                'worder_id' => $worderId,
                'post_user_id' => $data['post_user_id'],
            ];
            $user = db('user')->where(['user_id' => $worder['post_user_id']])->find();
            if (empty($user)) {
                $user=db('user_data')->where(['is_del' => 0])->find($udata_id);
            }
            //发送工单通知给服务商
            $push = new \app\common\service\PushBase();
            $sendData = [
                'type'  => 'worker',
                'worder_sn'    => $worder['worder_sn'],
                'worder_id'    => $worder['worder_id'],
            ];
            //发送给服务商在线管理员
            $push->sendToGroup('store'.$data['store_id'], json_encode($sendData));
            $this->worderLog($worder, $user, 0, '创建工单');
            return $sn;
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
        if ($info['ossub_id']) {
            $orderSkuModel = new \app\common\model\OrderSku();
            $info['sub'] = $orderSkuModel->getSubDetail($info['ossub_id'], FALSE, TRUE);
        }else{
            $info['sub'] = db('goods')->find($info['goods_id']);
        }
        //获取工单日志
        $info['logs'] = db('work_order_log')->order('add_time DESC')->where(['worder_id' => $info['worder_id']])->select();
        //获取工单评价记录
        $info['assess_list'] = $this->getWorderAssess($info);
        $info['images'] = $info['images'] ? explode(',', $info['images']) : [];
        return $info;
    }
    
    public function getWorderAssess($worder, $field = false)
    {
        $assessModel = db('work_order_assess');
        $field = $field ? $field : '*';
        $list = $assessModel->field($field)->where(['worder_id' => $worder['worder_id'], 'is_del' => 0])->select();
        if ($list) {
            foreach ($list as $key => $value) {
                $config = [];
                if ($value['type'] == 1) {
                    $config = db('work_order_assess_log')->alias("WOAL")->join("config C","C.config_id = WOAL.config_id")->field('C.name, WOAL.value as score')->where(['WOAL.assess_id' => $value['assess_id']])->select();
                }
                $list[$key]['configs'] = $config;
            }
        }
        return $list;
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
        //if ($user['admin_type'] != ADMIN_SERVICE) {
        //    $this->error = '当前账户无操作权限';
        //    return FALSE;
        //}
        //判断用户是否有分派工程师权限(仅服务商有分派工程师权限)
        if (!in_array($user['admin_type'],[ADMIN_SERVICE,ADMIN_SERVICE_NEW]) && $user['store_id'] != $worder['store_id']) {
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
        switch ($worder['work_order_status']) {
            case -1://已取消可另外分派
                $this->error = '已取消不能重新派单';
                return FALSE;
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
        $result = $this->save(['work_order_status' => 1, 'installer_id' => $installerId, 'dispatch_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $msg = '工程师姓名:'.$installer['realname'].'<br>工程师电话:'.$installer['phone'];
            $this->worderLog($worder, $user, $installerId, $action, $msg);
            if ($worder['installer_id'] != $installerId) {
                $this->_worderInstallerLog($worder, $installerId, 'dispatch', 0);
                //状态(1已拒绝  2分派转移)
                if ($worder['installer_id'] > 0) {
                    $this->_worderInstallerLog($worder, $worder['installer_id'], 'dispatch_other', 2);
                }
            }
            //分派工程师后通知工程师
            $informModel = new \app\common\model\LogInform();
            $result = $informModel->sendInform($user['factory_id'], 'sms', $installer, 'worder_dispatch_installer');
            return TRUE;
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    /**
     * 工程师拒绝工单操作
     * @param array $worder
     * @param array $user
     * @param array $installer
     * @return boolean
     */
    public function worderRefuse($worder, $user, $installer, $remark = '')
    {
        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }
        if (isset($worder['installer_id']) && $worder['installer_id'] && $worder['installer_id'] != $installer['installer_id']) {
            $this->error = lang('NO_OPERATE_PERMISSION');
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['work_order_status']) {
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
        $result = $this->save(['work_order_status' => 0, 'installer_id' => 0], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $this->worderLog($worder, $user, $installer['installer_id'], '工程师拒绝接单', $remark);
            $this->_worderInstallerLog($worder, $installer['installer_id'], 'refuse', 1);
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
            $this->error = lang('NO_OPERATE_PERMISSION');
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['work_order_status']) {
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
        $result = $this->save(['work_order_status' => 2, 'receive_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $this->worderLog($worder, $user, $installer['installer_id'], '工程师接单');
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
    public function worderSign($worder, $user, $installer,$address='')
    {
        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }
        if ($worder['installer_id'] != $installer['installer_id']) {
            $this->error = lang('NO_OPERATE_PERMISSION');
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['work_order_status']) {
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
        $result = $this->save([
            'work_order_status' => 3,
            'sign_time'         => time(),
            'sign_address'      => $address,
        ], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $this->worderLog($worder, $user, $installer['installer_id'], '工程师签到【'.$address.'】,服务开始');
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
        switch ($worder['work_order_status']) {
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
        $result = $this->save(['work_order_status' => 4, 'finish_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //2019-04-17 只有电商客服下的安装工单有服务费
            if ($worder['work_order_type'] == 1 && $worder['carry_goods'] == 0) {
                //确认完成，服务商服务费入账(只有安装工单)
                $where = [
                    'is_del'    => 0,
                    'worder_id' => $worder['worder_id'],
                    'order_sn'  => $worder['order_sn'],
                    'osku_id'   => $worder['osku_id'],
                ];
                $incomeModel = db('store_service_income');
                $exist = $incomeModel->where($where)->find();
                if (!$exist) {
                    $config = get_store_config($worder['factory_id'], TRUE, 'default');
//                     $returnRatio = isset($config['servicer_return_ratio']) ? floatval($config['servicer_return_ratio']) : 0;
                    $returnRatio = 100;
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
                        'return_ratio'  => $returnRatio > 0 ? $returnRatio : 0,
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
            }
            $field = $worder['work_order_type'] == 1 ? 'install_count' : 'repair_count';
            //增加工程师服务次数
            model('user_installer')->save([
                'service_count' =>	\Think\Db::raw('service_count+1'),
                $field		    =>	\Think\Db::raw($field.'+1'),
            ],['installer_id'=>$worder['installer_id']]);
            //操作日志记录
            $this->worderLog($worder, $user, $worder['installer_id'], '确认完成');
            return TRUE;
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    public function serviceSettlement($worder, $assessId, $user, $score = 0)
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
            $returnRatio = $exist['return_ratio']/100;
            //根据评价数据计算得分
            $installAmount = $exist['install_amount'];
            $totalScore = 5;
            //@update_at 20190328 modified by Jinzhou
            //消费者的评价打分，不会对服务商的安装费产生影响, 相当于取消服务商考核
            $score=5;
            //绩效考核百分比
            $baseAmount = $installAmount * (1 - $returnRatio);//基本服务金额
            $otherAmount = $installAmount * $returnRatio;
            $amount = round($baseAmount + $otherAmount * $score/$totalScore, 2);
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
    public function worderCancel($worder = [], $user = [], $remark = '')
    {
        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }
        $type = $worder['work_order_type'];
        //只有厂商和服务商有维修工单的取消权限
        if ($type == 2 && isset($user['admin_type']) && $user['admin_type']>0 && !in_array($user['admin_type'], [ADMIN_FACTORY, ADMIN_SERVICE])) {
            $this->error = lang('NO_OPERATE_PERMISSION');
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['work_order_status']) {
            case -1:
                $this->error = '工单已取消';
                return FALSE;
            case 3:
                $this->error = '工程师服务中';
                return FALSE;
            case 4:
                $this->error = '服务已完成';
                return FALSE;
            default:
                ;
                break;
        }
        $result = $this->save(['work_order_status' => -1, 'cancel_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $this->worderLog($worder, $user, 0, '取消工单', $remark);
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    public function worderDrop($worder = [], $user = [], $remark = '')
    {
        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['work_order_status']) {
            case 0:
                $this->error = '工单待分派,不允许删除';
                return FALSE;
            case 1:
                $this->error = '工单待接单,不允许删除';
                return FALSE;
            case 2:
                $this->error = '工单待上门,不允许删除';
                return FALSE;
            case 3:
                $this->error = '工程师服务中,不允许删除';
                return FALSE;
            default:
                break;
        }
        $result = '';
        if ($result !== FALSE) {
            //操作日志记录
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }


    /**
     * 追加评价
     */
    public function workAssessAppend($worder,$user,$param)
    {
        $status = $worder['work_order_status'];
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($status) {
            case -1:
                $this->error = '工单已取消,不允许评价';
                return false;
            case 0:
                $this->error = '工单待分派,不允许评价';
                return false;
            case 1:
                $this->error = '工单待接单,不允许评价';
                return false;
            case 2:
                $this->error = '工单待上门,不允许评价';
                return false;
            case 3:
                $this->error = '工程师服务中,不允许评价';
                return false;
            default:
                break;
        }
        $first= db('work_order_assess')->where([
            'worder_id' => $worder['worder_id'],
            'worder_sn' => $worder['worder_sn'],
            'type'      => 1,
        ])->find();
        if (empty($first)) {
            $this->error = '您之前未评价过,不允追加评价';
            return false;
        }
        $append= db('work_order_assess')->where([
            'worder_id' => $worder['worder_id'],
            'worder_sn' => $worder['worder_sn'],
            'type'      => 2,
        ])->find();
        if (!empty($append)) {
            $this->error = '一个工单只能追加一次评价';
            return false;
        }
        if (!isset($param['msg']) && empty($param['msg'])) {
            $this->error = '追加评价内容不能为空';
            return false;
        }

        $nickname = isset($user['realname']) && $user['realname'] ? $user['realname'] : (isset($user['nickname']) && $user['nickname'] ? $user['nickname'] : (isset($user['username']) && $user['username'] ? $user['username'] : ''));
        $data = [
            'worder_id'     =>  $worder['worder_id'],
            'worder_sn'     =>  $worder['worder_sn'],
            'installer_id'  =>  $worder['installer_id'],
            'post_user_id'  =>  $user ? $user['user_id'] : 0,
            'nickname'      =>  $user['user_id'] ? ($nickname ? $nickname : '客户') : '系统',
            'type'          =>  2,//1 首次评价 2 追加评价(追加评价只有评价内容,没有评分)
            'msg'           =>  $param['msg'],
            'add_time'      =>  time(),
        ];
        $assessId = db('work_order_assess')->insertGetId($data);//添加评价记录
        if (!$assessId) {
            $this->error = '系统故障，操作失败';
            return false;
        }
        $action =  '追加评价';
        //操作日志记录
        $this->worderLog($worder, $user, 0, $action, $param['msg']);
        return true;
    }



    /**
     * 首次评价
     * @param $worder 工单信息
     * @param $user   提交的用户
     * @param $assessConfig 评价配置
     * @param $scoreConfig  评分配置
     * @param $assess       评价信息
     * @param $score        评分信息
     * @return bool
     */
    public function workAssessFirst($worder,$user,$assessConfig,$scoreConfig,$assess,$score)
    {
        if (!$worder) {
            $this->error = '参数错误';
            return false;
        }

        if (empty($assess) || empty($score)) {
            $this->error = '请先完善全部评价信息再提交';
        }

        $assessKey='';
        $msg='';
        foreach ($assessConfig as $k=>$v) {
            if ($v['is_required']  && (!isset($assess[$v['id']])) || $assess[$v['id']]==='' || $assess[$v['id']]===null ) {
                $this->error = $v['name'].'不能为空';
                return false;
            }
            $assessKey=$v['key'];
            if ($v['type']==6) {
                $msg=isset($assess[$v['id']]) && is_string($assess[$v['id']]) ? $assess[$v['id']]:'';
            }
        }
        $scoreKey='';
        foreach ($scoreConfig as $k=>$v) {
            if ($v['is_required']  && (!isset($score[$v['id']])) || $score[$v['id']]==='' || $score[$v['id']]===null ) {
                $this->error = $v['name'].'不能为空';
                return false;
            }
            if ($score[$v['id']]>5 ||$score[$v['id']]<=0) {
                $this->error = $v['name'].'得分只能在1~5之间';
                return false;
            }
            $scoreKey=$v['key'];
        }
        $status = $worder['work_order_status'];
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($status) {
            case -1:
                $this->error = '工单已取消,不允许评价';
                return false;
            case 0:
                $this->error = '工单待分派,不允许评价';
                return false;
            case 1:
                $this->error = '工单待接单,不允许评价';
                return false;
            case 2:
                $this->error = '工单待上门,不允许评价';
                return false;
            case 3:
                $this->error = '工程师服务中,不允许评价';
                return false;
            default:
                break;
        }
        //是否已经评价过
        $exit = db('config_form_logs')
            ->alias('p1')
            ->join([
                ['config_form p2', 'p2.id=p1.config_form_id'],
            ])->where([
                ['p1.worder_id', '=', $worder['worder_id']],
                ['p1.type', '=', 0],
                ['p1.post_user_id', '=', $user['user_id']],
                ['p1.is_del', '=', 0,],
                ['p2.is_del', '=', 0,],
                ['p2.key', 'IN', [$assessKey, $scoreKey]],
            ])->find();
        if (!empty($exit)) {
            $this->error = '用户已经评价过';
            return false;
        }
        //写入评价数据
        $postData = [];
        foreach ($assess as $k => $v) {
            $postData[] = [
                'config_form_id' => $k,
                'worder_id'      => $worder['worder_id'],
                'store_id'       => $user['factory_id'],
                'post_store_id'  => $user['store_id'],
                'post_user_id'   => $user['user_id'],
                'config_value'   => $v,
            ];
        }
        $sum=0;
        foreach ($score as $k => $v) {
            $postData[] = [
                'config_form_id' => $k,
                'worder_id'      => $worder['worder_id'],
                'store_id'       => $user['factory_id'],
                'post_store_id'  => $user['store_id'],
                'post_user_id'   => $user['user_id'],
                'config_value'   => $v,
            ];
            $sum+=$v;
            //评份日志，对应表：user_installer_score
            model('user_installer')->assessAdd($worder['installer_id'],$k,$v);
        }
        $nickname = isset($user['realname']) && $user['realname'] ? $user['realname'] : (isset($user['nickname']) && $user['nickname'] ? $user['nickname'] : (isset($user['username']) && $user['username'] ? $user['username'] : ''));
        $data = [
            'worder_id'    => $worder['worder_id'],
            'worder_sn'    => $worder['worder_sn'],
            'installer_id' => $worder['installer_id'],
            'post_user_id' => $user ? $user['user_id'] : 0,
            'nickname'     => $user['user_id'] ? ($nickname ? $nickname : '客户') : '系统',
            'type'         => 1,//1 首次评价 2 追加评价(追加评价只有评价内容,没有评分)
            'msg'          => $msg,
            'add_time'     => time(),
        ];
        $assessId = db('work_order_assess')->insertGetId($data);//添加评价记录
        if (!$assessId) {
            $this->error = '系统故障，操作失败';
            return false;
        }
        $model = new ConfigFormLogs;
        $result = $model->saveAll($postData);
        if ($result->isEmpty()) {
            $this->error = '操作失败';
            return false;
        }
        $avgScore = round($sum/count($score),1);
        //安装工单
        if ($worder['work_order_type'] == 1 && $worder['carry_goods'] == 0) {
            //首次评价,处理安装服务费发放结算
            $this->serviceSettlement($worder, $assessId, $user, $avgScore);
        }
        $action ='首次评价';
        //操作日志记录
        $this->worderLog($worder, $user, 0, $action, $msg);
        return true;
    }
    
    /**
     * 工单评价操作
     * @param array $worder
     * @param array $user
     * @param array $assessData 用户提交评价信息
     * @deprecated 2019/05/08 JINZHOU
     */
    public function worderAssess($worder = [], $user = [], $assessData = []){
        if (!$worder) {
            $this->error = '参数错误';
            return FALSE;
        }
        
        $status = $worder['work_order_status'];
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($status) {
            case -1:
                $this->error = '工单已取消,不允许评价';
                return FALSE;
            case 0:
                $this->error = '工单待分派,不允许评价';
                return FALSE;
            case 1:
                $this->error = '工单待接单,不允许评价';
                return FALSE;
            case 2:
                $this->error = '工单待上门,不允许评价';
                return FALSE;
            case 3:
                $this->error = '工程师服务中,不允许评价';
                return FALSE;
            default:
                break;
        }
        if (!$user) {
            $assessData = [
                'type'  => 1,
                'msg'   => '默认好评',
            ];
            $assessData['score'] = db('config')->where(['config_key' => CONFIG_WORKORDER_ASSESS, 'status' => 1, 'is_del' => 0])->column('config_id, 5 as config_value');
        }
        if (!$assessData) {
            $this->error = '参数错误';
            return FALSE;
        }
        //判断评价是否存在
        $log = db('work_order_assess')->where(['worder_id' => $worder['worder_id'], 'type' => $assessData['type']])->find();
        if ($log) {
            $this->error = '不能重复评价';
            return FALSE;
        }
        /* //判断当前工单是否存在首次评价
        if ($assessData['type'] == 1) {
            //判断当前工单是否存在首次评价
            $log = db('work_order_assess')->where(['worder_id' => $worder['worder_id'], 'type' => 1])->find();
            if ($log) {
                $this->error = '工单已评价';
                return FALSE;
            }
        } */
        $nickname = isset($user['realname']) && $user['realname'] ? $user['realname'] : (isset($user['nickname']) && $user['nickname'] ? $user['nickname'] : (isset($user['username']) && $user['username'] ? $user['username'] : ''));
        $data = [
            'worder_id'     =>  $worder['worder_id'],
            'worder_sn'     =>  $worder['worder_sn'],
            'installer_id'  =>  $worder['installer_id'],
            'post_user_id'  =>  $user ? $user['user_id'] : 0,
            'nickname'      =>  $user['user_id'] ? ($nickname ? $nickname : '客户') : '系统',
            'type'          =>  $assessData['type'],//1 首次评价 2 追加评价(追加评价只有评价内容,没有评分)
            'msg'           =>  $assessData['msg'],
            'add_time'      =>  time(),
        ];
        $assessId = db('work_order_assess')->insertGetId($data);//添加评价记录
        if($assessId){
            $action = $assessData['type'] ? '首次评价': '追加评价';
            //操作日志记录
            $this->worderLog($worder, $user, 0, $action, $assessData['msg']);
            switch ($assessData['type']){
                case 1://首次评价带评分,记录评分信息
                    $scoreData = $assessData['score'];
                    if($scoreData && is_array($scoreData)){
                        $score = 0;
                        $len = count($scoreData);
                        foreach ($scoreData as $k=>$v){
                            $score += $v;
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
                        $score = round($score/$len,1);
                        //更新工程师综合得分
                        model('user_installer')->scoreUpdate($worder['installer_id'],$score);
                        //安装工单
                        if ($worder['work_order_type'] == 1 && $worder['carry_goods'] == 0) {
                            //首次评价,处理安装服务费发放结算
                            $this->serviceSettlement($worder, $assessId, $user, $score);
                        }
                        return $assessId;
                    }else{
                        $this->error = '没有评分项';
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
    public function worderLog($worder, $user, $installerId = 0, $action = '', $msg = '')
    {
        //$nickname = isset($user['realname']) && $user['realname'] ? $user['realname'] : (isset($user['nickname']) && $user['nickname'] ? $user['nickname'] : (isset($user['username']) && $user['username'] ? $user['username'] : ''));
        $username = '';
        if (isset($user['realname']) && $user['realname']) {
            $username = $user['realname'];
        } elseif (isset($user['nickname']) && $user['nickname']) {
            $username = $user['nickname'];
        } elseif (isset($user['username']) && $user['username']) {
            $username = $user['username'];
        }
        $data = [
            'worder_id'    => $worder['worder_id'],
            'worder_sn'    => $worder['worder_sn'],
            'installer_id' => $installerId,
            'user_id'      => isset($user['user_id']) ? $user['user_id'] : 0,
            'udata_id'     => isset($user['udata_id']) ? $user['udata_id'] : 0,
            'nickname'     => $user ? $username : '系统',
            'action'       => $action,
            'msg'          => $msg,
            'add_time'     => time(),
        ];
        return $result = db('work_order_log')->insertGetId($data);
    }
    private function _worderInstallerLog($worder, $installerId, $action = "dispatch_other", $status = 1)
    {
        $logModel = db('work_order_installer_record');
        
        $exist = $logModel->where(['worder_id' => $worder['worder_id'], 'installer_id' => $installerId, 'is_del' => 0])->find();
        if ($exist) {
            $result = $logModel->where(['log_id' => $exist['log_id']])->update(['is_del' => 1, 'update_time' => time()]);
        }
        if ($action == 'dispatch') {
            return FALSE;
        }
        $data = [
            'worder_id'     => $worder['worder_id'],
            'worder_sn'     => $worder['worder_sn'],
            'installer_id'  => $installerId,
            'action'        => $action,
            'status'        => $status,//状态(1已拒绝   2分派转移)
            'add_time'      => time(),
            'update_time'   => time(),
        ];
        return $result = db('work_order_installer_record')->insertGetId($data);
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