<?php
namespace app\factory\controller;
use app\common\controller\Index as CommonIndex;

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
                //累计佣金收益
                
                //今日订单数(渠道下的零售商订单数量)
                //累计订单数(渠道下的零售商订单数量)
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
                
                //今日订单金额(渠道下的零售商订单金额)
                //累计订单金额(渠道下的零售商订单金额)
                
                //今日新增零售商数量
                //累计新增零售商数量
            break;
            case ADMIN_DEALER:
                $tpl = 'dealer';
                //今日订单数
                //累计订单数
                
                //今日订单金额
                //累计订单金额
            break;
            case ADMIN_SERVICE:
                $tpl = 'servicer';
                //今日佣金收益
                //累计佣金收益
                //今日安装工单数量
                //累计安装工单数量
                //今日维修工单数量
                //累计维修工单数量
            break;
            default:
                $this->error(lang('NO ACCESS'));
            break;
        }
        $this->assign('today', $today);
        $this->assign('total', $total);
        
        $hometpl = 'home_'.$tpl;
//         $hometpl = 'home';
        return $this->fetch($hometpl);
    }
}
