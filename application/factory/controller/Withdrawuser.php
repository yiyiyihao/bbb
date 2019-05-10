<?php
namespace app\factory\controller;
//财务管理
class Withdrawuser extends FactoryForm
{
    public $config;
    public $finance;
    public $apply = 0;
    public function __construct()
    {
        $this->modelName = 'finance';
        $this->model = new \app\common\model\UserWithdraw();
        parent::__construct();
        unset($this->subMenu['add']);
        if (!in_array($this->adminUser['admin_type'], [ADMIN_FACTORY])) {
            $this->error('NO ACCESS');
        }
        $this->assign('wstatusList', get_withdraw_status());
        $this->assign('arrivalTypes', $this->model->arrivalTypes);
    }
    public function detail()
    {
        $info = $this->_assignInfo();
        return $this->fetch();
    }
    function _assignInfo($pkId = 0)
    {
        $info = parent::_assignInfo($pkId);
        $info['user'] = model('user')->where('user_id', $info['user_id'])->find();
        $types = $this->model->arrivalTypes;
        $info['arrival_type_txt'] = isset($types[$info['arrival_type']]) ? $types[$info['arrival_type']] : '';
        $this->assign('info', $info);
        return $info;
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
            $transferNo = isset($params['transfer_no']) ? trim($params['transfer_no']) : '';//转账流水号
            $img = isset($params['img']) ? trim($params['img']) : ''; //转账凭证
            $remark = isset($params['remark']) ? trim($params['remark']) : '';
            
            if (!$checkStatus && !$remark) {
                $this->error('拒绝操作备注不能为空');
            }
            if ($checkStatus) {
                switch ($info['arrival_type']) {
                    case 'bank':
                        if (!$transferNo) {
                            $this->error('第三方流水号不能为空');
                        }
                    break;
                    case 'wechat_wallet':
                        $wechatApi = new \app\common\api\WechatPayApi($info['store_id'], 'wechat_js');
                        $appid = $wechatApi->config ? $wechatApi->config['app_id'] : '';
                        $where = [
                            ['is_del', '=', 0],
                            ['user_id', '=', $info['user_id']],
                            ['third_type', '=', 'wechat_h5'],
                            ['appid', '=', $appid],
                        ];
                        $udata = model('UserData')->where($where)->find();
                        if (!$udata) {
                            $this->error('用户不存在,无法支付至零钱');
                        }
                        $result = $wechatApi->withdrawWallet($udata['third_openid'], $info['trade_no'], $info['amount'], '转账至零钱[提现]');
                        if ($result === FALSE) {
                            $this->error($wechatApi->error);
                        }
                    break;
                    default:
                        $this->error('到账类型错误');
                    break;
                }
            }
            $withdrawStatus = $checkStatus ? 2 : -1;
            $data = [
                'update_time'   => time(), 
                'remark'        => $remark, 
                'check_time'    => time(), 
                'withdraw_status'=> $withdrawStatus,
                'transfer_no'   => $checkStatus ? $transferNo : '',
                'img'           => $img,
            ];
            $result = $this->model->save($data, ['log_id' => $info['log_id']]);
            if ($result) {
                //审核不通过退还提现金额
                $financeModel = new \app\common\model\StoreFinance();
                if ($checkStatus > 0) {
                    $templateType = 'withdraw_user_success';
                }else{
                    $templateType = 'withdraw_user_fail';
                    $params = [
                        'msg' => '提现失败'.($remark ? ':'.$remark: ''),
                        'extra_id' => $info['log_id'],
                    ];
                    //记录成功后减少可提现金额
                    $userLogModel = new \app\common\model\UserLog();
                    $result = $userLogModel->record($info['user_id'], 'amount', $info['amount'], 'withdraw_return', $params);
                    if ($result !== FALSE) {
                        model('User')->where('user_id', $info['user_id'])->setDec('withdraw_amount', $info['amount']);
                    }
                    $info['remark'] = $remark;
                }
                $informModel = new \app\common\model\LogInform();
                if ($checkStatus > 0) {
                    $templateType = 'withdraw_user_success';
                    if ($info['arrival_type'] == 'bank') {
                        $info['arrival_type_txt'] = $info['bank_name'].' ('.str_encode($info['bank_no'],0,4).') '.$info['realname'];
                    }
                }else{
                    $templateType = 'withdraw_user_fail';
                    $info['remark'] = $remark;
                }
                $informModel->sendInform($info['store_id'], 'wechat', ['udata_id' => $info['udata_id']], $templateType, $info);
                $this->success('操作成功', url('index'));
            }else{
                $this->error('操作失败');
            }
        }else{
            return $this->fetch();
        }
    }
    function _getAlias()
    {
        return 'UW';
    }
    function _getField(){
        $field = 'UW.*, U.username, (if(U.realname != "", U.realname, U.nickname)) as realname';
        return $field;
    }
    function _getJoin()
    {
        $join[] = ['user U', 'U.user_id = UW.user_id', 'LEFT'];;
        return $join;
    }
    function  _getOrder()
    {
        return 'UW.add_time DESC';
    }
    function _getWhere(){
        $where = [
            'UW.is_del' => 0,
        ];
        if($this->adminUser['admin_type'] == ADMIN_FACTORY){
            $where['UW.store_id'] = $this->adminUser['store_id'];
        }else{
            $where['UW.from_store_id'] = $this->adminUser['store_id'];
        }
        $params = $this->request->param();
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['username|realname'] = ['like','%'.$name.'%'];
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