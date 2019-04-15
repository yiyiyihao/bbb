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
            $params = $this->request->post();
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
                $this->error('渠道佣金比例必须大于等于0');
            }
            $installerReturnRatio = $params['servicer_return_ratio'] =  isset($params['servicer_return_ratio']) ? round(floatval($params['servicer_return_ratio']), 2) : 0;
            if ($installerReturnRatio < 0) {
                $this->error('工程师安装服务费百分比必须大于等于0');
            }
            $workorderAutoAssessDay = $params['workorder_auto_assess_day'] = isset($params['workorder_auto_assess_day']) ? intval($params['workorder_auto_assess_day']) : 0;
            if ($workorderAutoAssessDay < 0) {
                $this->error('工单自动评价时间必须大于等于0');
            }
            $params['installer_check'] = isset($params['installer_check']) && intval($params['installer_check']) ? 1 : 0;
            $params['channel_operate_check'] = isset($params['channel_operate_check']) && intval($params['channel_operate_check']) ? 1 : 0;
            
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
    
    public function share(){
        if (!$this->adminFactory || $this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $this->error(lang('NO ACCESS'));
        }
        $params = [];
        if (IS_POST) {
            $params = $this->request->post();
            if (!$params) {
                $this->error('参数异常');
            }
            foreach ($params as $key => $value) {
                if (is_array($value)) {
                    foreach ($value as $k => $v) {
                        $content = isset($v['description']) ? trim($v['description']) : '';
                        if ($content) {
                            $content = str_replace("\r", " ", $content);
                            $content = str_replace("\n", " ", $content);
                            $params[$key][$k]['description'] = $content;
                            continue;
                        }
                    }
                }
            }
        }
        return $this->_storeConfig($params);
    }
    public function servicer()
    {
        $this->error(lang('NO ACCESS'));
        if (!$this->adminFactory || !in_array($this->adminUser['admin_type'],[ADMIN_SERVICE,ADMIN_SERVICE_NEW])) {
            $this->error(lang('NO ACCESS'));
        }
        return $this->_storeConfig();
    }
    
    /**
     * 商户二维码
     */
    public function wxacode()
    {
        if (!in_array($this->adminUser['admin_type'],[ADMIN_SERVICE,ADMIN_SERVICE_NEW])) {
            $this->error(lang('NO ACCESS'));
        }
        $platType = 1;
        $storeModel = new \app\common\model\Store();
        //商户的小程序基于厂商APPID
        $info = $storeModel->where(['store_id' => $this->adminUser['store_id'], 'is_del' => 0])->find();
        if (!$info) {
            $this->error('商户不存在或已删除');
        }
        $wxacode = $info['wxacode'] ? json_decode($info['wxacode'], 1) : [];
        $name = $platType == 1? 'installer' : 'user';
        $codeUrl = isset($wxacode[$name]) ?trim($wxacode[$name]) : '';
        if (!$codeUrl) {
            $wxcodeService = new \app\common\service\Wxcode(); 
            $codeUrl = $wxcodeService->getStoreAppletCode($info, $name);
            if ($codeUrl === FALSE) {
                $this->error($wxcodeService->error);
            }
            /* //远程判断图片是否存在
            $qiniuApi = new \app\common\api\QiniuApi();
            $config = $qiniuApi->config;
            $domain = $config ? 'http://'.$config['domain'].'/': '';
            $filename = 'wxacode_'.$info['store_no'].'_'.$name.'.png';
            $page = 'pages/index/index';//二维码扫码打开页面
            $page = '';
            $scene = 'store_no='.$info['store_no'];//最大32个可见字符，只支持数字，大小写英文以及部分特殊字符：!#$&'()*+,/:;=?@-._~，其它字符请自行编码为合法字符（因不支持%，中文无法使用 urlencode 处理，请使用其他编码方式）
            $wechatApi = new \app\common\api\WechatApi($this->adminUser['factory_id'], 'wechat_applet');
            $data = $wechatApi->getWXACodeUnlimit($scene, $page);
            if ($wechatApi->error) {
                $this->error($wechatApi->error);
            }else{
                $result = $qiniuApi->uploadFileData($data, $filename);
                if (isset($result['error']) && $result['error'] > 0) {
                    $this->error($result['msg']);
                }
//                 $codeUrl = $wxacode[$name] = $domain.$filename = 'http://pimvhcf3v.bkt.clouddn.com/wxacode_5121288100_installer.png';
                $codeUrl = $wxacode[$name] = $domain.$filename;
                $data = [
                    'wxacode' => json_encode($wxacode),
                ];
                $result = $storeModel->save($data, ['store_id' => $info['store_id']]);
            } */
        }
        $this->assign('info', $info);
        $this->assign('codeUrl', $codeUrl);
        return $this->fetch();
    }
    
    private function _storeConfig($params = [])
    {
        $storeModel = model('store');
        if (IS_POST) {
            $config = get_store_config($this->adminStore['store_id']);
            $params = $params ? $params : $this->request->post();
            if ($params) {
                $configKey = 'default';
                foreach ($params as $key => $value) {
                    if (!is_array($value)) {
                        $config[$configKey][$key] = trim($value);
                    }else{
                        $config[$key]=isset($config[$key])? $config[$key]:[];
                        $config[$key] =array_merge($config[$key],$value);
                    }
                }
                $configJson = $config ? json_encode($config): '';
                $result = $storeModel->save(['config_json' => $configJson], ['store_id' => $this->adminStore['store_id']]);
                if ($result === FALSE) {
                    $this->error($storeModel->error);
                }
            }
            $this->success('配置成功');
        }else{
            $config = get_store_config($this->adminStore['store_id'], TRUE);
            $config['wechat_applet'] = get_store_config($this->adminStore['store_id'], FALSE, 'wechat_applet');
            $this->assign('config', $config);
            return $this->fetch();
        }
    }
}