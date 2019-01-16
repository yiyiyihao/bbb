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
            $data['wechat_js_appid'] = isset($params['wechat_js_appid']) ? trim($params['wechat_js_appid']) : '';
            if (!$data['wechat_js_appid']) {
                $this->error('智享家微信公众账号的APPID不能为空');
            }
            $data['wechat_js_appsecret'] = isset($params['wechat_js_appsecret']) ? trim($params['wechat_js_appsecret']) : '';
            if (!$data['wechat_js_appsecret']) {
                $this->error('智享家微信公众账号的AppSecret不能为空');
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
            $data['withdraw_min_amount'] = isset($params['withdraw_min_amount']) ? floatval($params['withdraw_min_amount']) : 0;
            if ($data['withdraw_min_amount'] <= 0) {
                $this->error('单笔提现最小金额必须大于0');
            }
            $data['monthly_withdraw_start_date'] = isset($params['monthly_withdraw_start_date']) ? intval($params['monthly_withdraw_start_date']) : 0;
            if ($data['monthly_withdraw_start_date'] < 1 || $params['monthly_withdraw_start_date'] > 28) {
                $this->error('每月提现开始日期必须大于1号小于28号');
            }
            $data['monthly_withdraw_end_date'] = isset($params['monthly_withdraw_end_date']) ? intval($params['monthly_withdraw_end_date']) : 0;
            if ($data['monthly_withdraw_start_date'] >= $params['monthly_withdraw_end_date'] || $params['monthly_withdraw_end_date'] < 1 || $params['monthly_withdraw_end_date'] > 28) {
                $this->error('每月提现结束日期必须大于1号小于28号(且必须大于开始日期)');
            }
            $data['withdrawal_work_day'] = isset($params['withdrawal_work_day']) ? intval($params['withdrawal_work_day']) : 0;
            if ($data['withdrawal_work_day'] <= 0){
                $this->error('提现到账工作日必须大于0');
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
    public function sms(){
        $templates = [
            'send_code' => [
                'name'      => '验证码模版CODE',
                'content'   => '您的验证码为：${code}，该验证码 5 分钟内有效，请勿泄漏于他人',
            ], 
            'reset_pwd' => [
                'name'      => '重置密码模版CODE',
                'content'   => '您好，您的密码已经重置为${password}，请及时登录并修改密码。',
            ], 
            'worder_dispatch_installer' => [
                'name'      => '服务工程师被分派工单模版CODE',
                'content'   => '收到新的服务工单，请进入智享家师傅端小程序接单。',
            ], 
            'installer_check_fail' => [
                'name'      => '注册服务工程师审核失败模版CODE',
                'content'   => '尊敬的${name}：您好，非常抱歉，您申请的智享家服务工程师未通过审核，请进入智享家师傅端小程序查看详情。',
            ], 
            'installer_check_success' => [
                'name'      => '注册服务工程师审核通过模版模版CODE',
                'content'   => '尊敬的${name}：您好，恭喜您已通过智享家服务工程师的注册审核，请等待系统分派工单吧。',
            ], 
            
        ];
        $configKey = 'system_sms';
        $info = $this->model->where(['config_key' => $configKey, 'is_del' => 0, 'status' => 1])->find();
        $config = $info && $info['config_value'] ? json_decode($info['config_value'], 1) : [];
        if (IS_POST) {
            $data = $this->request->param();
            if (!$data) {
                $this->error('参数异常');
            }
            if ($data) {
                foreach ($data as $key => $value) {
                    if (is_array($value)) {
                        foreach ($value as $k => $v) {
                            $config[$key][$k] = trim($v);
                        }
                    }else{
                        $config[$key] = trim($value);
                    }
                    if (isset($templates[$key])) {
                        $config[$key]['template_content'] = $templates[$key]['content'];
                    }
                }
                $configJson = $config ? json_encode($config): '';
                $data = [
                    'config_value' => $configJson,
                    'update_time' => time(),
                ];
                if ($info) {
                    $result = $this->model->where(['config_id' => $info['config_id']])->update($data);
                }else{
                    $data['name'] = '系统短信模版配置';
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
            $this->assign('templates', $templates);
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