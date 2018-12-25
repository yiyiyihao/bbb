<?php
namespace app\factory\controller;

//支付方式管理
class Payment extends FactoryForm
{
    var $storeId;
    var $payments;
    public function __construct()
    {
        $this->modelName = 'payment';
        $this->model = db($this->modelName);
        parent::__construct();
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $this->error(lang('NO ACCESS'));
        }
        $paymentService = new \app\common\api\PaymentApi();
        $this->payments = $paymentService->payments;
        $this->assign('payments', $this->payments);
        unset($this->subMenu['add']);
    }
    public function config()
    {
        $params = $this->request->param();
        $code = isset($params['code']) ? $params['code'] : '';
        if (!$code || !isset($this->payments[$code])){
            $this->error('参数错误,不允许配置');
        }
        $payment = isset($this->payments[$code]) ? $this->payments[$code] : '';
        if (!$payment) {
            $this->error('参数异常');
        }
        $this->subMenu['menu'][] = [
            'name'  => $payment['name'] .lang(' 支付配置'),
            'url'   => url('config', ['code' => $code]),
        ];
        $info = $this->model->where(['store_id' => $this->adminUser['store_id'], 'is_del' => 0, 'pay_code' => $code])->find();
        if (IS_POST) {
            $data = [
                'name'          => isset($params['name']) ? trim($params['name']) : '',
                'config_json'   => isset($params['config']) && $params['config'] ? json_encode($params['config']) : '',
                'description'   => isset($params['description']) ? trim($params['description']) : '',
                'status'        => isset($params['status']) ? intval($params['status']) : '',
                'sort_order'    => isset($params['sort_order']) ? trim($params['sort_order']) : '',
                'display_type'  => $payment['display_type'],
                'api_type'      => $payment['api_type'],
            ];
            if ($info) {
                $result = $this->model->where(['pay_id' => $info['pay_id']])->update($data);
            }else{
                $data['pay_code'] = $code;
                $data['store_id'] = $this->adminUser['store_id'];
                $result = $this->model->insertGetId($data);
            }
            if ($result === FALSE) {
                $this->error('支付方式配置错误');
            }else{
                $this->success('支付方式配置成功', url('index'));
            }
        }else{
            $info['config'] = $info['config_json'] ? json_decode($info['config_json'], TRUE) : [];
            $this->assign('payment', $payment);
            $this->assign('info', $info);
            return $this->fetch();
        }
    }
    function _getWhere(){
        $where = ['is_del' => 0, 'store_id' => $this->adminUser['store_id']];
        $params = $this->request->param();
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['name'] = ['like','%'.$name.'%'];
            }
        }
        return $where;
    }
    function _afterList($list){
        $displayTypes = [
            1 => 'PC端',
            2 => '微信小程序端',
            3 => 'APP客户端',
        ];
        if ($list) {
            foreach ($list as $key => $value) {
                $code = $value['pay_code'];
                if ($this->payments && isset($this->payments[$code])) {
                    $this->payments[$code] = $value + $this->payments[$code];
                }
            }
        }
        $this->assign('displayTypes', $displayTypes);
        $list = $this->payments;
        return $list;
    }
    function _assignInfo($pkId = 0)
    {
        $info = parent::_assignInfo();
        if ($info['store_id'] != $this->adminUser['store_id']) {
            $this->error(lang('NO_OPERATE_PERMISSION'));
        }
        return $info;
    }
}
