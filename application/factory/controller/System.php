<?php
namespace app\factory\controller;
use app\admin\controller\System as adminSystem;

//系统管理
class System extends adminSystem
{
    public function __construct()
    {
        $this->modelName = 'system';
        $this->model = db('config');
        parent::__construct();
    }
    /**
     * 厂商权限配置
     */
    public function factory(){
        if (!$this->adminFactory || $this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $this->error(lang('NO ACCESS'));
        }
        $params = [];
        if (IS_POST) {
            $params = $this->request->param();
            if (!$params) {
                $this->error('参数异常');
            }
            $orderCancelMinute = $params['order_cancel_minute'] = isset($params['order_cancel_minute']) ? intval($params['order_cancel_minute']) : 0;
            if ($orderCancelMinute < 1) {
                $this->error('待支付订单取消时间必须大于0');
            }
            
            $orderReturnDay = $params['order_return_day'] = isset($params['order_return_day']) ? intval($params['order_return_day']) : 0;
            if ($orderReturnDay < 1) {
                $this->error('支付成功后的退款退货时间必须大于0');
            }
            
            $channelCommissionRatio  = $params['channel_commission_ratio'] = isset($params['channel_commission_ratio']) ? round(floatval($params['channel_commission_ratio']), 2) : 0;
            if ($channelCommissionRatio < 0) {
                $this->error('渠道佣金比例必须大于0');
            }
            
            $installerReturnRatio = $params['installer_return_ratio'] =  isset($params['installer_return_ratio']) ? round(floatval($params['installer_return_ratio']), 2) : 0;
            if ($installerReturnRatio < 0) {
                $this->error('工程师安装服务费百分比必须大于0');
            }
            
            $workorderAutoAssessDay = $params['workorder_auto_assess_day'] = isset($params['workorder_auto_assess_day']) ? intval($params['workorder_auto_assess_day']) : 0;
            if ($workorderAutoAssessDay < 0) {
                $this->error('工单自动评价时间必须大于0');
            }
            $params['installer_check'] = isset($params['installer_check']) && intval($params['installer_check']) ? 1 : 0;
            
            $params['monthly_withdraw_start_date'] = isset($params['monthly_withdraw_start_date']) ? intval($params['monthly_withdraw_start_date']) : 0;
            if ($params['monthly_withdraw_start_date'] < 1 || $params['monthly_withdraw_start_date'] > 28) {
                $this->error('每月提现开始日期必须大于1号小于28号');
            }
            $params['monthly_withdraw_end_date'] = isset($params['monthly_withdraw_end_date']) ? intval($params['monthly_withdraw_end_date']) : 0;
            if ($params['monthly_withdraw_start_date'] >= $params['monthly_withdraw_end_date'] || $params['monthly_withdraw_end_date'] < 1 || $params['monthly_withdraw_end_date'] > 28) {
                $this->error('每月提现结束日期必须大于1号小于28号(且必须大于开始日期)');
            }
            
            $params['consumer_hotline'] = isset($params['consumer_hotline']) ? trim($params['consumer_hotline']) : 0;
            if (!$params['consumer_hotline']) {
                $this->error('厂商客服电话不能为空');
            }
        }
        return $this->_storeConfig($params);
    }
    public function servicer()
    {
        if (!$this->adminFactory || $this->adminUser['admin_type'] != ADMIN_SERVICE) {
            $this->error(lang('NO ACCESS'));
        }
        return $this->_storeConfig();
    }
    
    private function _storeConfig($params = [])
    {
        $storeModel = model('store');
        if (IS_POST) {
            $config = $this->initStoreConfig($this->adminStore['store_id']);
            $params = $params ? $params : $this->request->param();
            if ($params) {
                foreach ($params as $key => $value) {
                    $config[$key] = trim($value);
                }
                $configJson = $config ? json_encode($config): '';
                $result = $storeModel->save(['config_json' => $configJson], ['store_id' => $this->adminStore['store_id']]);
                if ($result === FALSE) {
                    $this->error($storeModel->error);
                }
            }
            $this->success('配置成功');
        }else{
            $config = $this->initStoreConfig($this->adminStore['store_id'], TRUE);
            $this->assign('config', $config);
            return $this->fetch();
        }
    }
}
