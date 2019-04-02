<?php
namespace app\factory\controller;
//财务管理
class Finance extends FactoryForm
{
    public $config;
    public $finance;
    public $apply = 0;
    public function __construct()
    {
        $this->modelName = 'finance';
        $this->model = db('store_withdraw');
        parent::__construct();
        unset($this->subMenu['add']);
        if (!in_array($this->adminUser['admin_type'], [ADMIN_FACTORY, ADMIN_CHANNEL, ADMIN_SERVICE,ADMIN_SERVICE_NEW])) {
            $this->error('NO ACCESS');
        }
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $this->config = get_store_config($this->adminFactory['store_id'], TRUE, 'default');
            $this->assign('config', $this->config);
            //判断商户是否可提现
            if ($this->config && isset($this->config['monthly_withdraw_start_date']) && isset($this->config['monthly_withdraw_end_date'])) {
                $min = intval($this->config['monthly_withdraw_start_date']);
                $max = intval($this->config['monthly_withdraw_end_date']);
                $day = intval(date('d'));
                if ($day >= $min && $day <= $max) {
                    $this->apply = 1;
                }
            }
            $this->_getStoreFinanceData();
            $this->indextempfile = 'index_withdraw';
            $this->assign('apply', $this->apply);
        }
        $this->assign('wstatusList', get_withdraw_status());
    }
    public function detail()
    {
        $info = $this->_assignInfo();
        //获取提现商户名称
        $info['name'] = db('store')->where(['store_id' => $info['from_store_id']])->value('name');
        $this->assign('info', $info);
        return $this->fetch();
    }
    /**
     * 厂商审核操作
     */
    public function check()
    {
        //提现审核
        $info = $this->_assignInfo();
        if ($info['withdraw_status'] != 0) {
            $this->error('审核已处理');
        }
        if (IS_POST) {
            $params = $this->request->param();
            $checkStatus = isset($params['check_status']) && intval($params['check_status']) ? 1 : 0;
            $transferNo = isset($params['transfer_no']) ? trim($params['transfer_no']) : '';
            $remark = isset($params['remark']) ? trim($params['remark']) : '';
            if (!$checkStatus && !$remark) {
                $this->error('拒绝操作备注不能为空');
            }
            if ($checkStatus && !$transferNo) {
                $this->error('第三方流水号不能为空');
            }
            $withdrawStatus = $checkStatus ? 2 : -1;
            $data = [
                'update_time' => time(), 
                'remark' => $remark, 
                'check_time' => time(), 
                'withdraw_status' => $withdrawStatus,
                'transfer_no' => $checkStatus ? $transferNo : '',
                'remark' => $remark,
                'img' => (isset($params['img']) ? trim($params['img']) : ''),
            ];
            $result = $this->model->update($data);
            if ($result) {
                //审核不通过退还提现金额
                $financeModel = new \app\common\model\StoreFinance();
                if ($checkStatus) {
                    $params = ['withdraw_amount' => $info['amount']];
                    $action = '提现审核成功';
                    $remark = '转账流水号 : '.$transferNo.'<br>'.$remark;
                }else{
                    $params = ['amount' => $info['amount']];
                    $action = '提现被拒绝';
                }
                $result = $financeModel->financeChange($info['from_store_id'], $params, $action, $remark);
                if ($result === FALSE) {
                    $this->model->where(['log_id' => $info['log_id']])->update(['withdraw_status' => 0]);
                    $this->error('操作失败');
                }
                $this->success('操作成功', url('index'));
            }else{
                $this->error('操作失败');
            }
        }else{
            //获取提现商户名称
            $info['name'] = db('store')->where(['store_id' => $info['from_store_id']])->value('name');
            $this->assign('info', $info);
            return $this->fetch();
        }
    }
    private function _getStoreFinanceData()
    {
        $financeModel = new \app\common\model\StoreFinance();
        $this->finance = $financeModel->financeDetail($this->adminUser['store_id']);
        $this->assign('info', $this->finance);
    }
    /**
     * 商户申请提现功能
     */
    public function apply()
    {
        if (!in_array($this->adminUser['admin_type'], [ADMIN_CHANNEL, ADMIN_SERVICE])) {
            $this->error('NO ACCESS');
        }
        if (!$this->apply) {
            $min = intval($this->config['monthly_withdraw_start_date']);
            $max = intval($this->config['monthly_withdraw_end_date']);
            $this->error('每月提现时间：'.$min.'日-'.$max.'日');
        }
        //获取当前商户提现信息
        $bankModel = db('store_bank');
        $bankType = 1;//银行卡
        $bank = $bankModel->where(['is_del' => 0, 'bank_type' => $bankType, 'store_id' => $this->adminUser['store_id']])->find();
        if (!$bank) {
            $this->error('请先绑定银行卡号', url('setting'));
        }
        if ($this->finance['amount'] <= 0) {
            $this->error('可提现金额为0');
        }
        $minAmount = isset($this->config['withdraw_min_amount']) && $this->config['withdraw_min_amount'] ? $this->config['withdraw_min_amount'] : 100;
        if ($this->finance['amount'] < $minAmount) {
            $this->error('单笔最低提现金额为'.$minAmount.'元，暂不允许提现');
        }
        if (IS_POST) {
            $params = $this->request->param();
            $amount = isset($params['amount']) && $params['amount'] ? floatval($params['amount']) : 0;
            if (!$amount) {
                $this->error('请填写提现金额');
            }
            if ($amount < $minAmount) {
                $this->error('单笔最低提现金额为'.$minAmount.'元');
            }
            if ($amount>$this->finance['amount']) {
                $this->error('最多可提现'.$this->finance['amount'].'元');
            }

            $data = [
                'store_id'  => $this->adminFactory['store_id'],
                'user_id'   => ADMIN_ID,
                'amount'    => $amount,
                'add_time'  => time(),
                
                'bank_id'   => $bank['bank_id'],
                'realname'  => $bank['realname'],
                'bank_name' => $bank['bank_name'],
                'bank_no'   => $bank['bank_no'],
                'bank_detail'       => json_encode($bank),
                
                'update_time'       => time(),
                'from_store_id'     => $this->adminUser['store_id'],
                'from_store_type'   => $this->adminUser['store_type'],
                'withdraw_status'   => 0,
            ];
            $logId = $this->model->insertGetId($data);
            if ($logId) {
                //记录成功后减少可提现金额
//                 $result = db('store_finance')->where(['store_id' => $this->finance['store_id']])->dec('amount', $amount)->update();
                $financeModel = new \app\common\model\StoreFinance();
                $result = $financeModel->financeChange($this->finance['store_id'], ['amount' => -$amount], '申请提现', '');
                if (!$result) {
                    $this->model->where(['log_id' => $logId])->update(['status' => 0, 'is_del' => 1]);
                }
                $this->success('提现申请提交,请耐心等待审核通过', url('index'));
            }else{
                $this->error('申请提交异常');
            }
        }else{
            $this->assign('bank', $bank);
            return $this->fetch();
        }
    }
    /**
     * 配置提现银行卡
     */
    public function setting()
    {
        $bankModel = db('store_bank');
        $bankType = 1;//银行卡
        $info = $bankModel->where(['is_del' => 0, 'bank_type' => $bankType, 'store_id' => $this->adminUser['store_id']])->find();
        $update = TRUE;
        $day = 30;
        if ($info && $info['update_time']) {
            $startDay = mktime(0,0,0,date('m', $info['update_time']),date('d', $info['update_time']),date('Y', $info['update_time']));
            if ($startDay + $day*24*60*60 >= mktime(0,0,0,date('m'),date('d'),date('Y'))) {
                $update = FALSE;
            }
        }
        if (IS_POST) {
            if (!$update) {
                $this->error($day.'天内仅允许修改一次');
            }
            $params = $this->request->param();
            $realname = isset($params['realname']) ? trim($params['realname']) : '';
            $idCard = isset($params['id_card']) ? trim($params['id_card']) : '';
            $bankName = isset($params['bank_name']) ? trim($params['bank_name']) : '';
            $bankBranch = isset($params['bank_branch']) ? trim($params['bank_branch']) : '';
            $bankNo = isset($params['bank_no']) ? trim($params['bank_no']) : '';
            $regionName = isset($params['region_name']) ? trim($params['region_name']) : '';
            $regionId = isset($params['region_id']) ? intval($params['region_id']) : 0;
            if (!$realname) {
                $this->error('请填写持卡人姓名');
            }
            if (!$idCard) {
                $this->error('请填写持卡人身份证号');
            }
            if (!$bankName) {
                $this->error('请填写银行卡名称');
            }
            if (!$bankBranch) {
                $this->error('请填写开户行支行信息');
            }
            if (!$bankNo) {
                $this->error('请填写银行卡号');
            }
            if (empty($regionName) || $regionId<=0 ) {
                $this->error('请选择开户行所在地');
            }

            $data = [
                'realname'  => $realname,
                'id_card'   => $idCard,
                'bank_name' => $bankName,
                'bank_no'   => $bankNo,
                'bank_branch' => $bankBranch,
                'region_name' => $regionName,
                'region_id' => $regionId,
                'update_time' => time(),
            ];
            if ($info) {
                $result = $bankModel->where(['bank_id' => $info['bank_id']])->update($data);
            }else{
                $data['bank_type']  = $bankType;
                $data['store_id']   = $this->adminUser['store_id'];
                $data['add_time']   = time();
                $data['post_user_id'] = ADMIN_ID;
                $result = $bankModel->insertGetId($data);
            }
            if ($result !== FALSE) {
                $this->success('提现银行卡设置成功');
            }else{
                $this->error('操作错误');
            }
        }else{
            $this->assign('day', $day);
            $this->assign('update', $update);
            $this->assign('info', $info);
            return $this->fetch();
        }
    }
    
    function _getAlias()
    {
        return 'SW';
    }
    function _getField(){
        $field = 'SW.*, U.username, (if(U.realname != "", U.realname, U.nickname)) as nickname';
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $field .= ',S.name as sname';
        }
        return $field;
    }
    function _getJoin()
    {
        $join[] = ['user U', 'U.user_id = SW.user_id', 'LEFT'];;
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $join[] = ['store S', 'S.store_id = SW.store_id', 'LEFT'];
        }
        return $join;
    }
    function  _getOrder()
    {
        return 'SW.add_time DESC';
    }
    function _getWhere(){
        $where = [
            'SW.is_del' => 0,
        ];
        if($this->adminUser['admin_type'] == ADMIN_FACTORY){
            $where['SW.store_id'] = $this->adminUser['store_id'];
        }else{
            $where['SW.from_store_id'] = $this->adminUser['store_id'];
        }
        $params = $this->request->param();
        if ($params) {
            if ($this->adminUser['admin_type'] == ADMIN_FACTORY){
                $name = isset($params['sname']) ? trim($params['sname']) : '';
                if($name){
                    $where['S.name'] = ['like','%'.$name.'%'];
                }
                $sType = isset($params['stype']) ? intval($params['stype']) : '';
                if($sType){
                    $where['from_store_type'] = $sType;
                }
            }
            $wstatus = isset($params['wstatus']) ? intval($params['wstatus']) : -5;
            if($wstatus > -5){
                $where['withdraw_status'] = $wstatus;
            }
        }
        return $where;
    }
    function _getData()
    {
        $this->error('NO ACCESS');
    }
}