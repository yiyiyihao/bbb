<?php
namespace app\factory\controller;
use app\admin\controller\System as adminSystem;
use app\common\model\ConfigForm;
use app\common\model\GoodsCate;
use think\Request;

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
            $field = [
                'order_cancel_minute',
                'order_return_day',
                'channel_commission_ratio',
                'servicer_return_ratio',
                'workorder_auto_assess_day',
                'monthly_withdraw_start_date',
                'monthly_withdraw_end_date',
                'consumer_hotline',
            ];
            $params=$this->request->only($field);
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
                //【工程师】安装确认单 @author Joe 04/24 2019
                $this->workOrderInstallerConfirmConfig();
                //【用户】安装确认单 @author Joe 04/25 2019
                $this->workOrderUserConfirmConfig();
                //【工程师】维修确认单  @author Joe 04/29 2019
                $this->workOrderRepairConfirmConfig();
                //【用户】维修确认单  @author Joe 04/29 2019
                $this->workOrderRepairUserConfirmConfig();

            }
            $this->success('配置成功');
        }else{
            $storeId = $this->adminStore['store_id'];
            $config = get_store_config($storeId, TRUE);
            $config['wechat_applet'] = get_store_config($storeId, FALSE, 'wechat_applet');

            //商品分类
            $treeService = new \app\common\service\Tree();
            $where = ['is_del' => 0, 'store_id' => $storeId];
            $categorys = db('goods_cate')->field("cate_id, name, parent_id, sort_order,name as cname, status")->where($where)->order("sort_order ASC, parent_id")->select();
            if ($categorys) {
                $categorys = $treeService->getTree($categorys);
            }
            $this->assign('cates', $categorys);
            //客户安装确认配置
            $key = 'work_order_assess';
            $userConfirm = ConfigForm::where([
                'store_id' => $this->adminUser['factory_id'],
                'key'      => $key,
                'is_del'   => 0,
            ])->order('sort_order ASC,id ASC')->select();

            $this->assign('userConfirm',$userConfirm);
            $this->assign('config', $config);

            //工程师维修确认配置
            $key = 'work_order_repair';
            $userConfirm = ConfigForm::where([
                'store_id' => $this->adminUser['factory_id'],
                'key'      => $key,
                'is_del'   => 0,
            ])->order('sort_order ASC,id ASC')->select();
            $this->assign('repairConfirm',$userConfirm);

            //用户维修确认配置
            $key = 'work_order_repair_user';
            $userConfirm = ConfigForm::where([
                'store_id' => $this->adminUser['factory_id'],
                'key'      => $key,
                'is_del'   => 0,
            ])->order('sort_order ASC,id ASC')->select();
            $this->assign('repairUserConfirm',$userConfirm);
            return $this->fetch();
        }
    }


    private function workOrderInstallerConfirmConfig()
    {
        $cateId=$this->request->param('cate_id',0,'intval');
        $factoryId = $this->adminUser['factory_id'];
        if ($cateId) {
            $cate=GoodsCate::where([
                'store_id'=> $factoryId,
                'is_del'=>0,
            ])->find($cateId);
            if (empty($cate)) {
                $this->error('该商品分类不存在或已删除');
            }
            $key = 'installer_confirm_cate_' . $cateId;
            $configId=$this->request->param('config_id',[],'intval');
            $configIdExist=array_unique(array_filter($configId));
            //删除冗余的字段
            ConfigForm::where([
                'id'       => ['NOT IN', $configIdExist],
                'is_del'   => 0,
                'store_id' => $factoryId,
                'key'      => $key,
            ])->update(['is_del' => 1]);
            $names=$this->request->param('name');
            $isRequired=$this->request->param('is_required',1,'intval');
            $types=$this->request->param('type',1,'intval');
            $sortOrders=$this->request->param('sort_order',1,'intval');
            $optValues=$this->request->param('value');
            if (!empty($names)) {
                foreach ($names as $k=>$name ) {
                    $data = [];
                    $where = [];
                    if (isset($configId[$k]) && $configId[$k]) {//配置已存在则更新
                        $data = [
                            'name'        => $name,
                            'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                            'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                            'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                            'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                        ];
                        $where = [
                            'key'      => $key,
                            'is_del'   => 0,
                            'store_id' => $factoryId,
                            'id'       => $configId[$k]
                        ];
                    } else {//配置不存在则直接新增
                        $data = [
                            'store_id'    => $factoryId,
                            'key'         => $key,
                            'name'        => $name,
                            'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                            'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                            'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                            'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                        ];
                    }
                    $result = (new ConfigForm())->save($data, $where);
                }
            }
        }
    }

    private function workOrderUserConfirmConfig()
    {
        $factoryId = $this->adminUser['factory_id'];
        $key = 'work_order_assess';
        $configId=$this->request->param('config_id2',[],'intval');
        $configIdExist=array_unique(array_filter($configId));
        //删除冗余的字段
        ConfigForm::where([
            'id'       => ['NOT IN', $configIdExist],
            'is_del'   => 0,
            'store_id' => $factoryId,
            'key'      => $key,
        ])->update(['is_del' => 1]);
        $names=$this->request->param('name2');
        $isRequired=$this->request->param('is_required2',1,'intval');
        $types=$this->request->param('type2',1,'intval');
        $sortOrders=$this->request->param('sort_order2',1,'intval');
        $optValues=$this->request->param('value2');
        if (!empty($names)) {
            foreach ($names as $k=>$name ) {
                $data = [];
                $where = [];
                if (isset($configId[$k]) && $configId[$k]) {//配置已存在则更新
                    $data = [
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                    $where = [
                        'key'      => $key,
                        'is_del'   => 0,
                        'store_id' => $factoryId,
                        'id'       => $configId[$k]
                    ];
                } else {//配置不存在则直接新增:$where=[]; $model->save($data,$where);
                    $data = [
                        'store_id'    => $factoryId,
                        'key'         => $key,
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                }
                $result = (new ConfigForm())->save($data, $where);
            }
        }
    }

    private function workOrderRepairConfirmConfig()
    {
        $factoryId = $this->adminUser['factory_id'];
        $key = 'work_order_repair';
        $configId=$this->request->param('config_id3',[],'intval');
        $configIdExist=array_unique(array_filter($configId));
        //删除冗余的字段
        ConfigForm::where([
            'id'       => ['NOT IN', $configIdExist],
            'is_del'   => 0,
            'store_id' => $factoryId,
            'key'      => $key,
        ])->update(['is_del' => 1]);
        $names=$this->request->param('name3');
        $isRequired=$this->request->param('is_required3',1,'intval');
        $types=$this->request->param('type3',1,'intval');
        $sortOrders=$this->request->param('sort_order3',1,'intval');
        $optValues=$this->request->param('value3');
        if (!empty($names)) {
            foreach ($names as $k=>$name ) {
                $data = [];
                $where = [];
                if (isset($configId[$k]) && $configId[$k]) {//配置已存在则更新
                    $data = [
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                    $where = [
                        'key'      => $key,
                        'is_del'   => 0,
                        'store_id' => $factoryId,
                        'id'       => $configId[$k]
                    ];
                } else {//配置不存在则直接新增:$where=[]; $model->save($data,$where);
                    $data = [
                        'store_id'    => $factoryId,
                        'key'         => $key,
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                }
                $result = (new ConfigForm())->save($data, $where);
            }
        }

    }

    private function workOrderRepairUserConfirmConfig()
    {
        $factoryId = $this->adminUser['factory_id'];
        $key = 'work_order_repair_user';
        $configId=$this->request->param('config_id4',[],'intval');
        $configIdExist=array_unique(array_filter($configId));
        //删除冗余的字段
        ConfigForm::where([
            'id'       => ['NOT IN', $configIdExist],
            'is_del'   => 0,
            'store_id' => $factoryId,
            'key'      => $key,
        ])->update(['is_del' => 1]);
        $names=$this->request->param('name4');
        $isRequired=$this->request->param('is_required4',1,'intval');
        $types=$this->request->param('type4',1,'intval');
        $sortOrders=$this->request->param('sort_order4',1,'intval');
        $optValues=$this->request->param('value4');
        if (!empty($names)) {
            foreach ($names as $k=>$name ) {
                $data = [];
                $where = [];
                if (isset($configId[$k]) && $configId[$k]) {//配置已存在则更新
                    $data = [
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                    if (in_array($data['type'],[2,3,4]) && (!isset($optValues[$k]) ||empty($optValues[$k]))) {
                       return $this->error('第'.($k+1).'行<b class="text-red">"'.$name.'"</b>类型为<b class="text-red">列表</b>时，列表选项不能为空');
                    }
                    $where = [
                        'key'      => $key,
                        'is_del'   => 0,
                        'store_id' => $factoryId,
                        'id'       => $configId[$k]
                    ];
                } else {//配置不存在则直接新增:$where=[]; $model->save($data,$where);
                    $data = [
                        'store_id'    => $factoryId,
                        'key'         => $key,
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                }
                $result = (new ConfigForm())->save($data, $where);
            }
        }

    }

    public function getCateConf(Request $request)
    {
        $cateId = $request->param('cate_id', 0, 'intval');
        if (empty($cateId)) {
            return json(dataFormat(1, '请选择商品分类'));
        }
        $key = 'installer_confirm_cate_' . $cateId;
        $result = ConfigForm::where([
            'store_id' => $this->adminUser['factory_id'],
            'key'      => $key,
            'is_del'   => 0,
        ])->order('sort_order ASC,id ASC')->select();
        if ($result->isEmpty()) {
            return json(dataFormat(2, '暂无数据'));
        }
        return json(dataFormat(0, 'ok', $result));
    }
}