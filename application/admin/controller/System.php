<?php
namespace app\admin\controller;

//系统管理
class System extends AdminForm
{
    public function __construct()
    {
        $this->modelName = 'system';
        $this->model = db('config');
        parent::__construct();
        unset($this->subMenu['add']);
    }
    /**
     * 系统默认配置
     */
    public function default(){
        $configKey = 'system_default';
        $info = $this->model->where(['config_key' => $configKey, 'is_del' => 0, 'status' => 1])->find();
        $config = $info && $info['config_value'] ? json_decode($info['config_value'], 1) : [];
        if (IS_POST) {
            $params = $this->request->param();
            $data = [];
            if (!$params) {
                $this->error('参数异常');
            }
            $data['order_cancel_minute'] = isset($params['order_cancel_minute']) ? intval($params['order_cancel_minute']) : 0;
            if ($data['order_cancel_minute'] < 1) {
                $this->error('待支付订单取消时间必须大于0');
            }
            $data['order_return_day'] = isset($params['order_return_day']) ? intval($params['order_return_day']) : 0;
            if ($data['order_return_day'] < 1) {
                $this->error('支付成功后的退款退货时间必须大于0');
            }
            $data['workorder_auto_assess_day'] = isset($params['workorder_auto_assess_day']) ? intval($params['workorder_auto_assess_day']) : 0;
            if ($data['workorder_auto_assess_day'] < 0) {
                $this->error('工单自动评价天数必须大于0');
            }
            $data['monthly_withdraw_start_date'] = isset($params['monthly_withdraw_start_date']) ? intval($params['monthly_withdraw_start_date']) : 0;
            if ($data['monthly_withdraw_start_date'] < 1 || $params['monthly_withdraw_start_date'] > 28) {
                $this->error('每月提现开始日期必须大于1号小于28号');
            }
            $data['monthly_withdraw_end_date'] = isset($params['monthly_withdraw_end_date']) ? intval($params['monthly_withdraw_end_date']) : 0;
            if ($data['monthly_withdraw_start_date'] >= $params['monthly_withdraw_end_date'] || $params['monthly_withdraw_end_date'] < 1 || $params['monthly_withdraw_end_date'] > 28) {
                $this->error('每月提现结束日期必须大于1号小于28号(且必须大于开始日期)');
            }
            if ($data) {
                foreach ($data as $key => $value) {
                    $config[$key] = trim($value);
                }
                $configJson = $config ? json_encode($config): '';
                $data = [
                    'config_value' => $configJson,
                    'update_time' => time(),
                ];
                if ($info) {
                    $result = $this->model->where(['config_id' => $info['config_id']])->update($data);
                }else{
                    $data['name'] = '系统默认配置';
                    $data['config_key'] = $configKey;
                    $data['post_user_id'] = ADMIN_ID;
                    $data['add_time'] = time();
                    $result = $this->model->insertGetId($data);
                }
                if ($result === FALSE) {
                    $this->error($this->model->error);
                }
            }
            $this->success('配置成功');
        }else{
            $this->assign('config', $config);
            return $this->fetch();
        }
    }
    public function _getData()
    {
        $this->error('NO ACCESS');
    }
    public function _assignInfo($pkId = 0)
    {
        $this->error('NO ACCESS');
    }
}