<?php

namespace app\api\controller;

/**
 * 定时器定时执行模拟数据
 * @author xiaojun
 */
class Screen extends Timer
{
    private $goodslist;
    private $configKey;
    private $factoryId;

    private $thisTime;
    private $beginToday;
    private $endTodayTime;
    private $beginYesterday;
    private $adminUser;

    public function __construct()
    {
        $origin = isset($_SERVER['HTTP_ORIGIN']) ? $_SERVER['HTTP_ORIGIN'] : '*';
        header('Access-Control-Allow-Origin:' . $origin);
        header('Access-Control-Allow-Methods:POST');
        header('Access-Control-Allow-Headers:x-requested-with,content-type');
        header('Access-Control-Allow-Credentials:true');
        parent::__construct();
        date_default_timezone_set('PRC');
        $this->thisTime = time();
        $this->configKey = '';
        $this->beginYesterday = strtotime(date('Y-m-d') . ' -1 day');
        $this->beginToday = strtotime(date('Y-m-d'));
        $this->endTodayTime = strtotime(date('Y-m-d') . ' +1 day');
        $domain=db('store_factory')->where(['store_id'=>1])->value('domain');
        $adminUser = session($domain.'_user');

        $this->adminUser = $adminUser;
        $this->factoryId = isset($adminUser['factory_id']) ? $adminUser['factory_id'] : 0;
    }

    public function index()
    {
        if (empty($this->adminUser)) {
            $this->_returnMsg(['errCode' => 400, 'errMsg' => '请先登陆']);
        }
        if (!in_array($this->adminUser['group_id'], [GROUP_FACTORY, GROUP_SERVICE, GROUP_SERVICE_NEW])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '非法访问']);
        }
        $isFactory = $this->adminUser['group_id'] == GROUP_FACTORY ? true : false;
        $lastOrderId = $this->request->param('last_order_id');
        $result = [];
        //今日服务人数
        $where = [
            ['sign_time', '>=', $this->beginToday],
            ['sign_time', '<', $this->endTodayTime],
            ['work_order_status', '>=', 0],
            ['factory_id', '=', $this->factoryId],
        ];
        if (!$isFactory) {
            $where[] = ['store_id', '=', $this->adminUser['store_id']];
        }
        $result['work_order']['today_count'] = db('work_order')->where($where)->count();

        //累计服务(人次)
        unset($where[0], $where[1]);//累计服务人次
        $where[] = ['sign_time', '>', 0];
        $result['work_order']['total_count'] = db('work_order')->where($where)->count();
        //待分派工单【今天】
        $where = [
            ['add_time', '>=', $this->beginToday],
            ['add_time', '<', $this->endTodayTime],
            ['work_order_status', '=', 0],
            ['is_del', '=', 0],
            ['factory_id', '=', $this->factoryId],
        ];
        if (!$isFactory) {
            $where[] = ['store_id', '=', $this->adminUser['store_id']];
        }
        $result['work_order']['pendding_count'] = db('work_order')->where($where)->count();
        //服务中工单【今天】
        $where[2] = ['work_order_status', '=', 3];
        $result['work_order']['service_count'] = db('work_order')->where($where)->count();
        //已完成工单【今天】
        $where[2] = ['work_order_status', '=', 4];
        $result['work_order']['finish_count'] = db('work_order')->where($where)->count();
        //工单完成率【今天】
        $countPercent = $result['work_order']['finish_count'] > 0 ? $result['work_order']['finish_count'] / $result['work_order']['today_count'] * 100 : 0;
        $result['work_order']['finish_percent'] = intval($countPercent) . '%';
        $where[2] = ['work_order_status', '>=', 0];
        $result['work_order']['allserv_count'] = db('work_order')->where($where)->count();

        //今日交易额
        $where = [
            ['add_time', '>=', $this->beginToday],
            ['add_time', '<', $this->endTodayTime],
            ['order_status', '<>', 2],
            ['pay_status', '=', 1],
            ['factory_id', '=', $this->factoryId],
        ];
        //分销数据
        $whereFenxiao='';
        if ($isFactory) {
            $whereFenxiao='add_time>='.$this->beginToday.' AND add_time<'.$this->endTodayTime.'  AND  store_id='.$this->adminUser['store_id'].' AND order_type=2 AND pay_status=1 AND order_status<>2 AND udata_id>0 AND factory_id='.$this->adminUser['factory_id'];
            $where[] = ['user_store_type', 'IN',[STORE_SERVICE,STORE_SERVICE_NEW]];//厂商只统计服务商数据
        }else{
            $where[] = ['store_id', '=', $this->adminUser['store_id']];
        }
        $query=db('order')->where($where);
        if ($whereFenxiao) {
            $query->whereOrRaw($whereFenxiao);
        }
        $result['order']['today_amount'] =$query->sum('real_amount');

        //总交易额
        unset($where[0], $where[1]);
        //分销数据
        $whereFenxiao='';
        if ($isFactory) {
            $whereFenxiao='store_id='.$this->adminUser['store_id'].' AND order_type=2 AND pay_status=1 AND order_status<>2 AND udata_id>0'.$this->adminUser['factory_id'];
        }
        $query=db('order')->where($where);
        if ($whereFenxiao) {
            $query->whereOrRaw($whereFenxiao);
        }
        $result['order']['total_amount'] = (int)$query->sum('real_amount');
        //今日交易笔数
        $where = [
            ['add_time', '>=', $this->beginToday],
            ['add_time', '<', $this->endTodayTime],
            ['order_status', '<>', 2],
            ['pay_status', '=', 1],
            ['factory_id', '=', $this->factoryId],
        ];
        if ($isFactory) {
            $where[] = ['user_store_type', 'IN',[STORE_SERVICE,STORE_SERVICE_NEW]];//厂商只统计服务商数据
        }else{
            $where[] = ['store_id', '=', $this->adminUser['store_id']];
        }
        $result['order']['today_count'] = db('order')->where($where)->count();

        //总交易笔数
        unset($where[0], $where[1]);
        $result['order']['total_count'] = db('order')->where($where)->count();

        //服务商数量
        $servicerCount = 1;
        if ($isFactory) {
            $servicerCount = db('store')->where([
                ['is_del', '=', 0],
                ['store_type', 'IN', [ADMIN_SERVICE, ADMIN_SERVICE_NEW]],
            ])->count();
        }
        $result['store']['servicer_count'] = $servicerCount;
        //零售商数量
        $where = [
            ['p1.is_del', '=', 0],
            ['p1.store_type', '=', STORE_DEALER],
            ['p1.factory_id', '=', $this->factoryId],
        ];
        $join = [];
        if (!$isFactory) {
            $where[] = ['p2.ostore_id', '=', $this->adminUser['store_id']];
            $join[] = ['store_dealer p2', 'p1.store_id = p2.store_id'];
        }
        $result['store']['dealer_count'] = db('store')->alias('p1')->join($join)->where($where)->count();

        //待发货订单【今天】
        $where = [
            ['add_time', '>=', $this->beginToday],
            ['add_time', '<', $this->endTodayTime],
            ['finish_status', '<', 2],
            ['delivery_status', '<', 2],
            ['factory_id', '=', $this->factoryId],
        ];
        if (!$isFactory) {
            $where[] = ['store_id', '=', $this->adminUser['store_id']];
        }
        $result['order']['pendding_count'] = db('order')->where($where)->count();
        //已发货【今天】
        $where[3] = ['delivery_status', '=', 2];
        $result['order']['delivery_count'] = db('order')->where($where)->count();
        //已完成订单【今天】
        $where[2] = ['finish_status', '=', 2];
        unset($where[3]);
        $result['order']['finish_count'] = db('order')->where($where)->count();
        //订单完成率【今天】
        $countPercent = $result['order']['finish_count'] > 0 ? $result['order']['finish_count'] / $result['order']['today_count'] * 100 : 0;
        $result['order']['finish_percent'] = intval($countPercent) . '%';

        //实时订单列表
        $where = [
            ['p2.factory_id', '=', $this->factoryId],
        ];
        if (!$isFactory) {
            $where[] = ['p1.store_id', '=', $this->adminUser['store_id']];
        }
        $orders = db('order_sku')
            ->field('p1.order_id,p1.sku_name,p1.price AS real_amount,p1.add_time')
            ->alias('p1')
            ->join('order p2', 'p1.order_id=p2.order_id')
            ->where($where)
            ->limit(7)
            ->order('p1.add_time DESC')
            ->select();
        foreach ($orders as $key => $value) {
            $orders[$key]['add_time'] = date('H:i:s', $value['add_time']);
            $orders[$key]['is_new'] = $value['order_id'] > $lastOrderId ? 1 : 0;
        }
        $result['orders'] = $orders;
        //近七日工单

        $where = [
            ['factory_id', '=', $this->factoryId],
        ];
        if (!$isFactory) {
            $where[] = ['store_id', '=', $this->adminUser['store_id']];
        }
        $start=$this->beginYesterday;
        $end=$this->beginToday;
        for ($i=0;$i<=6;$i++) {
            $whereTemp = [
                ['add_time', '>=', $start],
                ['add_time', '<', $end],
            ];
            $field = 'count(IF(work_order_type = 1, true, null)) as install_count, count(IF(work_order_type = 2, true, null)) as repair_count';
            $countWorkOrder = db('work_order')->field($field)->where($where)->where($whereTemp)->find();
            $result['work_order_lines']['day'][] = date('m-d',$start);
            $result['work_order_lines']['install_count'][] = (int)$countWorkOrder['install_count'];
            $result['work_order_lines']['repair_count'][] = (int)$countWorkOrder['repair_count'];
            $end=$start;
            $start-=86400;
        }
        //热销产品
        if ($isFactory) {
            $where = [
                ['store_id', '=', $this->factoryId],
            ];
            $result['goods'] = db('goods')->where($where)->field('name,sales')->order('sales DESC')->limit(0,20)->select();
        }else{
            $where = [
                ['store_id', '=', $this->adminUser['store_id']],
            ];
            $result['goods'] = db('order_sku')->where($where)->fieldRaw('sku_name `name`,SUM(`num`) `sales`')->group('sku_id')->order('sales DESC')->limit(10)->select();
        }
        //售后工程师
        $where = [
            ['factory_id', '=', $this->factoryId],
        ];
        if (!$isFactory) {
            $where[] = ['store_id', '=', $this->adminUser['store_id']];
        }
        $count = db('user_installer')->where($where)->count();
        $result['user_installer']['installer_count'] = $count;
        $this->_returnMsg(['return' => $result]);
        return false;
    }

    /**
     * 中断并返回数据,后面程序继续执行,避免用户等待(immediate)
     * 可用于返回值后,继续执行程序,但程序占得所以资源没有释放,一直占用,务必注意,最好给单独脚本执行
     * @param string|array $data 字符串或数组,数组将被转换成json字符串
     * @param intval $set_time_limit 设置后面程序最大执行时间,0不限制,但web页面设置最大执行时间不一定靠谱,可改用脚本或单独开子进程
     * @return
     */
    function returnAndContinue($data = '', $set_time_limit = 10)
    {
        $str = is_string($data) ? $data : json_encode($data, JSON_UNESCAPED_UNICODE);
        header('Content-Type:application/json');
        echo $str;
        if (function_exists('fastcgi_finish_request')) {            //Nginx使用
            fastcgi_finish_request();        //后面输出客户端获取不到
        } else {            //apache 使用
            $size = ob_get_length();
            header("Content-length: $size");
            header('Connection:close');
            ob_end_flush();
            //ob_flush();       //加了没效果
            flush();
        }
        ignore_user_abort(true);
        set_time_limit($set_time_limit);
        return $str;
    }

    /**
     * 处理接口返回信息
     */
    protected function _returnScreenMsg($data, $echo = TRUE)
    {
        $result = self::returnAndContinue($data);
        $responseTime = $this->_getMillisecond() - $this->visitMicroTime;//响应时间(毫秒)
        $addData = [
            'request_time'  => $this->requestTime,
            'return_time'   => $this->thisTime,
            'method'        => $this->method ? $this->method : '',
            'return_params' => $result,
            'response_time' => $responseTime,
            'error'         => isset($data['errCode']) ? intval($data['errCode']) : 0,
            'errmsg'        => json_encode($this->errorArray),
            'show_time'     => date('Y-m-d H:i:s'),
        ];
        $apiLogId = db('apilog_timer', $this->configKey)->insertGetId($addData);
        sleep(1);//休眠1秒后,再次执行刷数据任务
        $url = "http://" . $this->request->host() . $this->request->url();
        curl_request($url);
        exit();
    }

    /**
     * 处理接口返回信息
     */
    protected function _returnMsg($data, $echo = TRUE)
    {
        if (!isset($data['errCode']) || !$data['errCode']) {
            $tempArr = ['errCode' => 0, 'errMsg' => 'ok'];
            $data = $data ? ($tempArr + $data) : $data;
        }
        $result = json_encode($data);
        if ($echo) {
            header('Content-Type:application/json');
            echo $result;
        }
        $responseTime = $this->_getMillisecond() - $this->visitMicroTime;//响应时间(毫秒)
        $addData = [
            'module'         => $this->request->module(),
            'controller'     => strtolower($this->request->controller()),
            'action'         => $this->request->action(),
            'request_time'   => $this->requestTime,
            'request_source' => 'screen',
            'return_time'    => time(),
            'method'         => $this->method ? $this->method : '',
            'request_params' => json_encode($this->request->param()),
            'return_params'  => $result,
            'response_time'  => $responseTime,
            'error'          => isset($data['errCode']) ? intval($data['errCode']) : 0,
            'msg'            => isset($data['errMsg']) ? $data['errMsg'] : '',
        ];
        $apiLogId = db('apilog_app', $this->configKey)->insertGetId($addData);
        exit();
    }
}