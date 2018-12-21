<?php
namespace app\factory\controller;
use app\common\controller\Index as CommonIndex;
use app\common\service\Chart;

class Index extends CommonIndex
{
    function __construct(){
        parent::__construct();
    }
    public function index()
    {
        //获取登录商家类型
        $storeType = $this->adminUser['store_type'];
        //判断当前登录用户是否存在未查看的公告信息
        $bulletinModel = db('bulletin');
        $where = [
            'B.store_type' => $this->adminUser['store_type'], 
            'B.publish_status' => 1,
            'B.visible_range = 1 OR (visible_range = 0 AND find_in_set('.$this->adminUser['store_id'].', B.to_store_ids))',
            'BR.bulletin_id IS NULL',
        ];
        $join = [
            ['bulletin_log BR', 'B.bulletin_id = BR.bulletin_id ', 'LEFT']
        ];
        $field  = "B.*";
        //未读公告列表
        $bulletins      = $bulletinModel->field($field)->alias('B')->join($join)->where($where)->whereNull('BR.bulletin_id')->select();
        $unReadCount    = count($bulletins);
        $unReadCount    = $unReadCount > 0 ? $unReadCount : '';
        $this->assign("unread",$unReadCount);
        $this->assign('bulletins', $bulletins);
        
        //获取需要开屏展示的公告列表
        #TODO 登录展示特效未处理
        $where['B.special_display'] = 1;
        $specialBulletins = $bulletinModel->field($field)->where($where)->whereNull('BR.bulletin_id')->select();
        if(count($specialBulletins) > 0 && count($specialBulletins) == 1){
            $this->assign('specialBulletin', $specialBulletins[0]);
        }
//         pre($specialBulletins);
        $this->assign('specialBulletins', $specialBulletins);
        
        return parent::index();
    }
    public function home()
    {
        $adminType = $this->adminUser['admin_type'];
        if (!$adminType) {
            $this->error(lang('NO ACCESS'));
        }
        $storeId = $this->adminUser['store_id'];
        $orderModel = new \app\common\model\Order();
        $storeModel = new \app\common\model\Store();
        $workOrderModel = new \app\common\model\WorkOrder();
        $userInstallerModel = new \app\common\model\UserInstaller();
        $today = $total = [];
        $beginToday = mktime(0,0,0,date('m'),date('d'),date('Y')); //今日开始时间戳
        switch ($adminType) {
            case ADMIN_FACTORY:
                $tpl = 'factory';
                //今日订单数据统计
                $where = [
                    'store_id' => $storeId,
                    'add_time' => ['>=', $beginToday],
                ];
                $todayOrder = $orderModel->field('count(*) as order_count, sum(real_amount) as order_amount')->where($where)->find();
                //今日订单数
                $today['order_count'] = $todayOrder && isset($todayOrder['order_count']) ? intval($todayOrder['order_count']) : 0;
                //今日订单金额
                $today['order_amount'] = $todayOrder && isset($todayOrder['order_amount']) ? sprintf("%.2f",($todayOrder['order_amount'])) : 0;
                
                //累计订单数据统计
                $where = [
                    'store_id' => $storeId,
                ];
                $totalOrder = $orderModel->field('count(*) as order_count, sum(real_amount) as order_amount')->where($where)->find();
                //累计订单数
                $total['order_count'] = $totalOrder && isset($totalOrder['order_count']) ? intval($totalOrder['order_count']) : 0;
                //累计订单金额
                $total['order_amount'] = $totalOrder && isset($totalOrder['order_amount']) ? sprintf("%.2f",($totalOrder['order_amount'])) : 0;
               
                //今日新增零售商数量
                $where = [
                    'factory_id'=> $storeId,
                    'add_time'  => ['>=', $beginToday],
                    'store_type'=> STORE_DEALER,
                    'is_del'    => 0,
                ];
                $today['dealer_count'] = $storeModel->where($where)->count();
                
                //累计商户数据统计
                $where = [
                    'factory_id' => $storeId,
                ];
                $field = 'count(if(store_type = '.STORE_CHANNEL.', true, NULL)) as channel_count';
                $field .= ', count(if(store_type = '.STORE_DEALER.', true, NULL)) as dealer_count';
                $field .= ', count(if(store_type = '.STORE_SERVICE.', true, NULL)) as service_count';
                $field .= ', sum(if(store_type = '.STORE_CHANNEL.' OR store_type = '.STORE_SERVICE.', security_money, 0)) as security_money_total';
                $totalStore = $storeModel->field($field)->where($where)->find();
                //累计渠道商数量
                $total['channel_count'] = $totalStore && isset($totalStore['channel_count']) ? intval($totalStore['channel_count']) : 0;
                //累计零售商数量
                $total['dealer_count'] = $totalStore && isset($totalStore['dealer_count']) ? intval($totalStore['dealer_count']) : 0;
                //累计服务商数量
                $total['service_count'] = $totalStore && isset($totalStore['service_count']) ? intval($totalStore['service_count']) : 0;
                //累计保证金金额(渠道商+服务商)
                $total['security_money_total'] = $totalStore && isset($totalStore['security_money_total']) ? floatval($totalStore['security_money_total']) : 0;
                
                //工单数量统计
                $where = [
                    'factory_id' => $storeId,
                    'is_del' => 0,
                ];
                $field = 'count(if(add_time >= '.$beginToday.', true, NULL)) as today_count, count(*) as total_count';
                $field .= ',count(if(work_order_type = 1 , true, NULL)) as workorder_1_count, count(if(work_order_type = 2 , true, NULL)) as workorder_2_count';
                $workOrderData = $workOrderModel->field($field)->where($where)->find();
                //今日售后工单数量
                $today['workorder_count'] = $workOrderData && isset($workOrderData['today_count']) ? intval($workOrderData['today_count']) : 0;
                //累计售后工单数量
                $total['workorder_count'] = $workOrderData && isset($workOrderData['total_count']) ? intval($workOrderData['total_count']) : 0;
                //累计安装工单数量
                $total['workorder_1_count'] = $workOrderData && isset($workOrderData['workorder_1_count']) ? intval($workOrderData['workorder_1_count']) : 0;
                //累计维修工单数量
                $total['workorder_2_count'] = $workOrderData && isset($workOrderData['workorder_2_count']) ? intval($workOrderData['workorder_2_count']) : 0;
                //累计工程师数量
                $where = [
                    'factory_id' => $storeId,
                    'is_del' => 0
                ];
                $totalInstaller = $userInstallerModel->where($where)->count();
                $total['installer_count'] = intval($totalInstaller);
                
                $join = [
                    ['store_finance SF', 'S.store_id = SF.store_id', 'INNER'],
                ];
                $where = [
                    'S.factory_id' => $storeId,
                    'S.is_del'    => 0,
                    'S.store_type' => ['IN', [STORE_CHANNEL, STORE_SERVICE]],
                ];
                $field = ' sum(if(store_type = '.STORE_CHANNEL.', withdraw_amount, 0)) as channel_withdraw_amount';
                $field .= ', sum(if(store_type = '.STORE_SERVICE.', withdraw_amount, 0)) as servicer_withdraw_amount';
                $totalStore = $storeModel->alias('S')->field($field)->join($join)->where($where)->find();
                //渠道商累计提现金额
                $total['channel_withdraw_amount'] = $totalStore && isset($totalStore['channel_withdraw_amount']) ? floatval($totalStore['channel_withdraw_amount']) : 0;
                //服务商累计提现金额
                $total['servicer_withdraw_amount'] = $totalStore && isset($totalStore['servicer_withdraw_amount']) ? floatval($totalStore['servicer_withdraw_amount']) : 0;
            break;
            case ADMIN_CHANNEL:
                $tpl = 'channel';
                //今日佣金收益
                $commissionModel=new \app\common\model\StoreCommission();
                $join=[
                    ['store S','C.store_id = S.store_id','INNER'],
                ];
                $where=[
                    'S.store_id'=>$storeId,
                    'C.commission_status'=>['IN',[0,1]],
                    'C.add_time'=>['>=',$beginToday],
                ];
                $today['commission_amount']=$commissionModel->alias('C')->join($join)->where($where)->sum('C.income_amount');
                //累计佣金收益
                unset($where['C.add_time']);
                $total['commission_amount']=$commissionModel->alias('C')->join($join)->where($where)->sum('C.income_amount');
                
                //今日订单数(渠道下的零售商订单数量)
                //累计订单数(渠道下的零售商订单数量)
                $where = [
                    'S.is_del' => 0,
                    'S.store_type'=> 3,
                    'SD.ostore_id'=> $storeId,
                    'O.add_time' => ['>=', $beginToday],
                ];
                $join=[
                    ['store_dealer SD','SD.store_id = O.user_store_id'],
                    ['store S','S.store_id = SD.store_id'],
                ];
                $field='count(*) as order_count, sum(real_amount) as order_amount';
                $todayOrder = $orderModel->alias('O')->field($field)->join($join)->where($where)->find();
                //今日订单数
                $today['order_count'] = $todayOrder && isset($todayOrder['order_count']) ? intval($todayOrder['order_count']) : 0;
                //今日订单金额
                $today['order_amount'] = $todayOrder && isset($todayOrder['order_amount']) ? sprintf("%.2f",($todayOrder['order_amount'])) : 0;
                
                //累计订单数据统计
                unset($where['O.add_time']);
                $totalOrder = $orderModel->alias('O')->field($field)->join($join)->where($where)->find();
                //累计订单数
                $total['order_count'] = $totalOrder && isset($totalOrder['order_count']) ? intval($totalOrder['order_count']) : 0;
                //累计订单金额
                $total['order_amount'] = $totalOrder && isset($totalOrder['order_amount']) ? sprintf("%.2f",($totalOrder['order_amount'])) : 0;
                
                //今日新增零售商数量
                $where = [
                    'factory_id'=> $storeId,
                    'add_time'  => ['>=', $beginToday],
                    'store_type'=> STORE_DEALER,
                    'is_del'    => 0,
                ];
                $today['dealer_count'] = $storeModel->where($where)->count();
                
                //累计商户数据统计
                $where = [
                    'factory_id' => $storeId,
                ];
                $field = 'count(if(store_type = '.STORE_CHANNEL.', true, NULL)) as channel_count';
                $field .= ', count(if(store_type = '.STORE_DEALER.', true, NULL)) as dealer_count';
                $field .= ', count(if(store_type = '.STORE_SERVICE.', true, NULL)) as service_count';
                $field .= ', sum(if(store_type = '.STORE_CHANNEL.' OR store_type = '.STORE_SERVICE.', security_money, 0)) as security_money_total';
                $totalStore = $storeModel->field($field)->where($where)->find();
                //累计渠道商数量
                $total['channel_count'] = $totalStore && isset($totalStore['channel_count']) ? intval($totalStore['channel_count']) : 0;
                //累计零售商数量
                $total['dealer_count'] = $totalStore && isset($totalStore['dealer_count']) ? intval($totalStore['dealer_count']) : 0;
                //累计服务商数量
                $total['service_count'] = $totalStore && isset($totalStore['service_count']) ? intval($totalStore['service_count']) : 0;
                
                //今日订单金额(渠道下的零售商订单金额)
                //累计订单金额(渠道下的零售商订单金额)
                
                //今日新增零售商数量
                $where = [
                    'factory_id' => $storeId,
                    'store_type' => STORE_DEALER,
                    'add_time' => ['>=',$beginToday],
                    'is_del'=> 0,
                ];
                $today['channel_count']=$storeModel->where($where)->count();
                //累计新增零售商数量

            break;
            case ADMIN_DEALER:
                $tpl = 'dealer';
                //今日订单数据统计
                $where = [
                    'store_id' => $storeId,
                    'add_time' => ['>=', $beginToday],
                ];
                $todayOrder = $orderModel->field('count(*) as order_count, sum(real_amount) as order_amount')->where($where)->find();
                //今日订单数
                $today['order_count'] = $todayOrder && isset($todayOrder['order_count']) ? intval($todayOrder['order_count']) : 0;
                //今日订单金额
                $today['order_amount'] = $todayOrder && isset($todayOrder['order_amount']) ? sprintf("%.2f",($todayOrder['order_amount'])) : 0;

                //累计订单数据统计
                $where = [
                    'store_id' => $storeId,
                ];
                $totalOrder = $orderModel->field('count(*) as order_count, sum(real_amount) as order_amount')->where($where)->find();
                //累计订单数
                $total['order_count'] = $totalOrder && isset($totalOrder['order_count']) ? intval($totalOrder['order_count']) : 0;
                //累计订单金额
                $total['order_amount'] = $totalOrder && isset($totalOrder['order_amount']) ? sprintf("%.2f",($totalOrder['order_amount'])) : 0;

            break;
            case ADMIN_SERVICE:
                $tpl = 'servicer';
                //今日佣金收益
                $commissionModel=new \app\common\model\StoreCommission();
                $join=[
                    ['store S','C.store_id = S.store_id','INNER'],
                ];
                $where=[
                    'S.store_id'=>$storeId,
                    'C.commission_status'=>['IN',[0,1]],
                    'C.add_time'=>['>=',$beginToday],
                ];
                $today['commission_amount']=$commissionModel->alias('C')->join($join)->where($where)->sum('C.income_amount');
                //累计佣金收益
                unset($where['C.add_time']);
                $total['commission_amount']=$commissionModel->alias('C')->join($join)->where($where)->sum('C.income_amount');


                $where = [
                    'factory_id' => $storeId,
                    'is_del' => 0,
                    'work_order_type' => 1,
                    'add_time'=>['>=',$beginToday],
                ];
                //今日安装工单数量
                $today['workorder_count_1']=$workOrderModel->where($where)->count();
                $where = [
                    'factory_id' => $storeId,
                    'is_del' => 0,
                    'work_order_type' => 1,
                ];
                //累计安装工单数量
                $total['workorder_count_1']=$workOrderModel->where($where)->count();
                $where = [
                    'factory_id' => $storeId,
                    'is_del' => 0,
                    'work_order_type' => 2,
                    'add_time'=>['>=',$beginToday],
                ];
                //今日维修工单数量
                $today['workorder_count_2']=$workOrderModel->where($where)->count();
                $where = [
                    'factory_id' => $storeId,
                    'is_del' => 0,
                    'work_order_type' => 2,
                ];
                //累计维修工单数量
                $total['workorder_count_2']=$workOrderModel->where($where)->count();
                break;
            default:
                $this->error(lang('NO ACCESS'));
            break;
        }
        $this->assign('today', $today);
        $this->assign('total', $total);
        //$this->assign('chart', $this->chart_data());
        $hometpl = 'home_'.$tpl;

        //$hometpl = 'home';
        return $this->fetch($hometpl);
    }


    public function chart_data()
    {
        $from=$this->request->param("start",null,'trim');
        $to=$this->request->param("end",null,'trim');
        $startTime=strtotime($from.' 00:00:00');
        $endTime=strtotime($to.' 23:59:59');
        $adminType = $this->adminUser['admin_type'];
        $storeId = $this->adminUser['store_id'];
        $chart_type=$this->request->param("type",0,'intval');

        $startTime=0;
        $endTime=9999999999999;

        if (!$adminType) {
            $this->error(lang('NO ACCESS'));
        }
        $orderModel = new \app\common\model\Order();
        $data=[];
        $lable=[];
        $dataset[0] = [
            'name'     =>'访问人次666',
            'type'     =>'line',
            'itemStyle'=>[],
            'smooth'   => 0
        ];
        switch ($adminType){
            case ADMIN_FACTORY://厂商
                //订单概况
                //订单金额统计
                //break;
            case ADMIN_CHANNEL://渠道商
                //订单概况
                //订单金额统计
                //break;
            case ADMIN_DEALER://零售商
                //订单概况
                //订单金额统计
                $where=[
                    ['add_time','>=',$startTime],
                    ['add_time','<=',$endTime],
                    ['store_id','=',$storeId],
                ];
                if ($chart_type){
                    $field='FROM_UNIXTIME(add_time, "%Y-%m-%d") time,count(1) value';
                    //订单概况
                    $data=$orderModel->field($field)->where($where)->group('time')->order('add_time')->select()->toArray();
                }else{
                    $field='FROM_UNIXTIME(add_time, "%Y-%m-%d") time,sum(real_amount) value';
                    //订单金额统计
                    $data=$orderModel->field($field)->where($where)->group('time')->order('add_time')->select()->toArray();
                }
                break;
            case ADMIN_SERVICE://服务商
                $workOrder=new \app\common\model\WorkOrder();
                $where=[
                    ['add_time','>=',$startTime],
                    ['add_time','<=',$endTime],
                    ['store_id','=',$storeId],
                ];
                if($chart_type){
                    $field='FROM_UNIXTIME(add_time, "%Y-%m-%d") time,count(1) value';
                    //工单概况
                    $data=$workOrder->field($field)->where($where)->group('time')->order('add_time')->select()->toArray();
                }else{
                    //工单佣金统计
                    $model=db('store_service_income');
                    $field='FROM_UNIXTIME(add_time, "%Y-%m-%d") time,sum(income_amount) value';
                    $data['workorder_amount']=$model->field($field)->where($where)->group('time')->order('add_time')->select();
                }
                break;
            default:
                $this->error(lang('NO ACCESS'));
                break;
        }

        foreach ($data as $item) {
            $lable[]=$item['time'];
            $dataset[0]['data'][] = $item['value'];
        }
        $color=['#33ccff'];
        $chart=new Chart('group',['测试'],$lable,$dataset,$color,false);
        $result=$chart->getOption();
        return json_encode($result);
    }

    //订单概况
    private function orderOverView($startTime,$endTime,$storeId)
    {        
        $orderModel=new \app\common\model\Order();
        $where=[
            ['add_time','>=',$startTime],
            ['add_time','<=',$endTime],
            ['store_id','=',$storeId],
        ];
        $field='FROM_UNIXTIME(add_time, "%Y-%m-%d") time,count(1) value';
        $data=$orderModel->field($field)->where($where)->group('time')->order('add_time')->select()->toArray();
        return $data;
    }

    //订单金额统计
    private function orderAmount($startTime,$endTime,$storeId)
    {
        $field='FROM_UNIXTIME(add_time, "%Y-%m-%d") time,sum(real_amount) value';
        $orderModel=new \app\common\model\Order();
        $where=[
            ['add_time','>=',$startTime],
            ['add_time','<=',$endTime],
            ['store_id','=',$storeId],
        ];
        $data=$orderModel->field($field)->where($where)->group('time')->order('add_time')->select()->toArray();
        return $data;
    }
    //
    private function workOrderOverView()
    {

    }


}
