<?php
namespace app\factory\controller;
use app\common\controller\CommonBase;
use think\facade\Request;

class Apply extends CommonBase
{
    function __construct(){
        parent::__construct();
    }
    public function index()
    {
        $userModel = new \app\common\model\User();
        $storeModel = new \app\common\model\Store();
        $store = [];
        $user = $userModel->checkUser(ADMIN_ID, TRUE);
        $factoryId = $user['factory_id'];
        if ($user['store_id']) {
            $store = $storeModel->where(['store_id' => $user['store_id'], 'is_del' => 0])->find();
            $store = $storeModel->getStoreDetail($user['store_id']);
            if (!$store) {
                $this->error(lang('param_error'));
            }
        }
        $checkStatus = $store ? intval($store['check_status']) : 2;
        if ($checkStatus == 1) {
            $this->error('商户审核已通过', url('index/index'));
        }
        $this->assign('checkStatus', $checkStatus);
        $types = [
            STORE_DEALER => [
                'name' => '零售商',
                'desc' => '适合拥有线下或线上销售渠道的商户',
                'admin_type' => ADMIN_DEALER,
                'group_id'   => GROUP_DEALER,
            ],
            STORE_CHANNEL => [
                'name' => '渠道商',
                'desc' => '拥有一定的市场资源，有能力发展零售商的商户',
                'admin_type' => ADMIN_CHANNEL,
                'group_id'   => GROUP_CHANNEL,
            ],
            STORE_SERVICE => [
                'name' => '服务商',
                'desc' => '拥有售后安装，维修能力或资源，能够提供售后服务的商户',
                'admin_type' => ADMIN_SERVICE,
                'group_id'   => GROUP_SERVICE,
            ],
            STORE_SERVICE_NEW => [
                'name' => '服务商',
                'desc' => '拥有售后安装，维修能力或资源，能够提供售后服务的商户,拥有一定的市场资源，有能力发展零售商的商户',
                'admin_type' => ADMIN_SERVICE_NEW,
                'group_id'   => GROUP_SERVICE_NEW,
            ],
        ];
        if (IS_POST){
            if ($store && $store['check_status'] == 1) {
                $this->error('审核已通过');
            }
            $params = $this->request->param();
            if ($checkStatus == 0) {
                $this->error('厂商审核中,请耐心等待');
            }
            $type = isset($params['type']) ? intval($params['type']) : 0;
            $channelNo = isset($params['channel_no']) ? trim($params['channel_no']) : '';
            $name = $params && isset($params['name']) ? trim($params['name']) : '';
            $userName = $params && isset($params['user_name']) ? trim($params['user_name']) : '';
            if (!$name) {
                $this->error(lang('商户名称不能为空'));
            }
            if (!$userName) {
                $this->error(lang('联系人姓名不能为空'));
            }
            $where = ['name' => $name, 'is_del' => 0, 'factory_id' => $factoryId, 'store_type' => $type];
            if ($store) {
                $where['store_id'] = ['<>', $store['store_id']];
            }
            $exist = $storeModel->where($where)->find();
            if($exist){
                $this->error('当前'.$types[$type]['name'].'名称已存在');
            }
            if ($type == STORE_DEALER) {
                if (!$channelNo) {
                    $this->error(lang('请填写渠道商编号'));
                }
                $channel = $storeModel->where(['store_no' => $channelNo, 'store_type' => STORE_CHANNEL, 'is_del' => 0, 'status' => 1])->find();
                if (!$channel) {
                    $this->error(lang('渠道商不存在或已删除'));
                }
                if ($type == STORE_DEALER) {
                    $params['ostore_id'] = $channel['store_id'];
                }
            }
            $params['store_type'] = $type;
            $params['factory_id'] = $factoryId;
            $params['mobile']     = $user['phone'];
            unset($params['store_no']);
            $params['config_json'] = '';
            $params['check_status'] = 0;
            $where = [];
            if ($store) {
                $where['store_id'] = $store['store_id'];
            }
            if (isset($params['sample_amount'])) {
                $amount = floatval($params['sample_amount']);
                $amount = sprintf('%.2f', $amount);
                if (strlen($amount) > 11) {
                    $array = explode('.', $amount);
                    $amount = substr($array[0], 0, 8);
                    $amount = $amount.'.'.$array[1];
                    $params['sample_amount'] = $amount;
                }
            }
            if (isset($params['security_money'])) {
                $amount = floatval($params['security_money']);
                $amount = sprintf('%.2f', $amount);
                if (strlen($amount) > 11) {
                    $array = explode('.', $amount);
                    $amount = substr($array[0], 0, 8);
                    $amount = $amount.'.'.$array[1];
                    $params['security_money'] = $amount;
                }
            }
            $params['enter_type'] = 1;
            if ($store && $store['store_type'] != $type) {
                $params['last_type'] = $store['store_type'];
            }
            $storeId = $storeModel->save($params, $where);
            if ($storeId === FALSE) {
                $this->error('系统异常');
            }else{
                if ($store) {
                    $storeId = $store['store_id'];
                    $this->adminUser['store_id'] = $storeId;
                }
                $adminStore = db('store')->field('store_id, name, factory_id, store_type, store_no, check_status, status')->where(['store_id' => $storeId, 'is_del' => 0])->find();
                session('admin_store', $adminStore);
                $data = [
                    'admin_type'    => $types[$type]['admin_type'],
                    'group_id'      => $types[$type]['group_id'],
                    'store_id'      => $storeId,
                ];
                if (!$user['realname']) {
                    $data['realname'] = $userName;
                }
                $result = $userModel->save($data, ['user_id' => ADMIN_ID]);
                $domain = Request::panDomain();
                $this->adminUser = array_merge($this->adminUser, $data);
                $userModel->setSession($domain, $this->adminUser);
                $this->success('资料审核中');
            }
        }else{
            $this->assign('types', $types);
            $this->assign('store_type', ($store ? $store['store_type'] : 3));
            $this->assign('store', $store);
            $this->assign('user', $user);
            $domain_repost=str_replace($this->request->subDomain(),'www',$this->request->domain());
            $url_repost=$domain_repost.'#/JoinInvestment/FillInformation?user_id='.$user['user_id'];
            $this->assign('url_repost',$url_repost);
            return $this->fetch();
        }
    }
}
