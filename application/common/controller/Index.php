<?php
namespace app\common\controller;
use app\common\controller\CommonBase;
use think\facade\Env;
use think\facade\Request;
/**
 * @author chany
 * @date 2018-11-08
 */
class Index extends CommonBase
{
    public $error = '';
    /**
     * 框架首页
     */
    public function index($template = '',$url = '')
    {
        $menuList = $this->getMenu();
//         pre($menuList);
        $this->assign('menuList', $menuList);
        config('app_trace',false);
        return $this->fetch($template);
    }
    /**
     * 后台首页
     */
    public function home()
    {
        return $this->fetch();
    }
    /**
     * 清理缓存
     */
    public function clearcache()
    {
        if ($this->adminUser['user_id'] != 1) {
            $this->error(lang('NO ACCESS'));
        }
        $runtimePath = Env::get('RUNTIME_PATH');
        if (file_exists($runtimePath)) {
            //删除目录下的所有文件/目录
            del_file_by_dir($runtimePath);
        }
        $this->success('缓存清理成功', url('home'));
    }
    /**
     * 修改资料
     */
    public function profile()
    {
        $userModel = new \app\common\model\User();
        $user = $userModel->checkUser(ADMIN_ID, TRUE);
        if (IS_POST){
            $params = $this->request->param();
            $realname = isset($params['realname']) && $params['realname'] ? trim($params['realname']) : '';
            $nickname = isset($params['nickname']) && $params['nickname'] ? trim($params['nickname']) : '';
            $phone = isset($params['phone']) && $params['phone'] ? trim($params['phone']) : '';
            if (!$realname) {
                $this->error('真实姓名不能为空');
            }
            if (!$user['phone']) {
                if (!$phone) {
                    $this->error('联系电话不能为空');
                }
            }else{
                unset($params['phone']);
            }
            
            $params['user_id'] = $user['user_id'];
            $result = $userModel->checkFormat($this->adminUser['factory_id'], $params);
            if ($result === FALSE) {
                $this->error($userModel->error);
            }
            $result = $userModel->save($params, ['user_id' => ADMIN_ID]);
            if ($result === FALSE) {
                $this->error($userModel->error);
            }else{
                $flag = FALSE;
                if ($realname != $this->adminUser['realname']) {
                    $flag = TRUE;
                    $this->adminUser['realname'] = $realname;
                }
                if ($nickname != $this->adminUser['nickname']) {
                    $flag = TRUE;
                    $this->adminUser['nickname'] = $nickname;
                }
                if ($phone != $this->adminUser['phone']) {
                    $flag = TRUE;
                    $this->adminUser['phone'] = $phone;
                }
                if ($flag) {
                    //更新缓存信息
                    $domain = Request::panDomain();
                    $userModel->setSession($domain, $this->adminUser);
                }
                $this->success('修改资料成功');
            }
        }else{
            $this->assign('info', $user);
            return $this->fetch();
        }
    }
    /**
     * 修改密码
     */
    public function password()
    {
        $userModel = new \app\common\model\User();
        $user = $userModel->checkUser(ADMIN_ID, FALSE);
        if (IS_POST){
            $params = $this->request->param();
            $password = isset($params['password']) && $params['password'] ? trim($params['password']) : '';
            $newPwd = isset($params['new_pwd']) && $params['new_pwd'] ? trim($params['new_pwd']) : '';
            $rePwd = isset($params['re_pwd']) && $params['re_pwd'] ? trim($params['re_pwd']) : '';
            if (!$password) {
                $this->error('原密码不能为空');
            }
            if (!$newPwd) {
                $this->error('新密码不能为空');
            }
            if (!$rePwd) {
                $this->error('确认密码不能为空');
            }
            if ($password == $newPwd) {
                $this->error('新密码不能与原密码一致');
            }
            if ($newPwd != $rePwd) {
                $this->error('新密码与确认密码不一致');
            }
            $result = $userModel->checkFormat($this->adminUser['factory_id'], ['password' => $newPwd]);
            if ($result === FALSE) {
                $this->error($userModel->error);
            }
            //判断原密码是否正确
            if ($user['password'] <> $userModel->pwdEncryption($password)) {
                $this->error('原登录密码验证错误');
            }
            $data = ['password' => $userModel->pwdEncryption($newPwd)];
            if ($user['pwd_modify'] > 0) {
                $this->adminUser['pwd_modify'] = $data['pwd_modify'] = 0;
            }
            $result = $userModel->save($data, ['user_id' => ADMIN_ID]);
            if ($result === FALSE) {
                $this->error($userModel->error);
            }else{
                if ($user['pwd_modify'] > 0) {
                    //更新session
                    $domain = Request::panDomain();
                    $this->adminUser['pwd_modify'] = 0;
                    $userModel->setSession($domain, $this->adminUser);
                }
                $this->success('修改密码成功');
            }
        }else{
            $this->assign('info', $user);
            return $this->fetch();
        }
    }
    //获取商户首页数据
    public function getStoreHome($user = [], $chart = TRUE)
    {
        $user = $user ? $user : $this->adminUser;
        if (!$user) {
            $this->error = lang('NO ACCESS');
            return FALSE;
        }
        $adminType = $user['admin_type'];
        if (!$adminType) {
            $this->error = lang('NO ACCESS');
            return FALSE;
        }
        
        $storeId = $user['store_id'];
        $orderModel = new \app\common\model\Order();
        $storeModel = new \app\common\model\Store();
        $workOrderModel = new \app\common\model\WorkOrder();
        $userInstallerModel = new \app\common\model\UserInstaller();
        $today = $total = $orderOverview = $orderStatistics = $worderOverview = $worderStatistics = [];
        $beginToday = mktime(0,0,0,date('m'),date('d'),date('Y')); //今日开始时间戳
        
        switch ($adminType) {
            case ADMIN_FACTORY:
                $tpl = 'factory';
                //今日订单数据统计
                $where = [
                    'store_id' => $storeId,
                    'add_time' => ['>=', $beginToday],
                    'order_status'  => ['<>', 2],
                    'pay_status'    => 1,
                ];
                $todayOrder = $orderModel->field('count(*) as order_count, sum(real_amount) as order_amount')->where($where)->find();
                //今日订单数
                $today['order_count'] = $todayOrder && isset($todayOrder['order_count']) ? intval($todayOrder['order_count']) : 0;
                //今日订单金额
                $today['order_amount'] = $todayOrder && isset($todayOrder['order_amount']) ? sprintf("%.2f",($todayOrder['order_amount'])) : 0;
                
                //累计订单数据统计
                $where = [
                    'store_id' => $storeId,
                    'order_status'  => ['<>', 2],
                    'pay_status'    => 1,
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
                    'is_del'    => 0,
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
                
                $orderSku=db('order_sku_service');
                $where = [
                    'store_id' => $storeId,
                    'service_status' => 3,
                ];
                $field='count(distinct(order_id)) count,sum(refund_amount) amount';
                $refund=$orderSku->field($field)->where($where)->find();
                //累计退款订单数
                $total['refund_count']=$refund['count'];
                //累计退款金额
                $total['refund_amount']=$refund['amount'];
                
                //工单数量统计
                //1.今日提交安装工单数量
                //2.今日上门安装工单数量
                
                //3.今日提交维修工单数量
                //4.今日提交维修工单数量
                $where = [
                    'factory_id' => $storeId,
                    'is_del' => 0,
                    'add_time' => ['>=',$beginToday],
                ];
                $field = 'count(if(work_order_type = 1 && add_time >= '.$beginToday.', true, NULL)) as post_count_1';
                $field .= ', count(if(work_order_type = 1 && sign_time >= '.$beginToday.', true, NULL)) as sign_count_1';
                $field .= ', count(if(work_order_type = 2 && add_time >= '.$beginToday.', true, NULL)) as post_count_2';
                $field .= ', count(if(work_order_type = 2 && sign_time >= '.$beginToday.', true, NULL)) as sign_count_2';
                $workOrderData = $workOrderModel->field($field)->where($where)->find();
                
                $today['post_count_1'] = $workOrderData ? intval($workOrderData['post_count_1']) : 0;
                $today['sign_count_1'] = $workOrderData ? intval($workOrderData['sign_count_1']) : 0;
                $today['post_count_2'] = $workOrderData ? intval($workOrderData['post_count_2']) : 0;
                $today['sign_count_2'] = $workOrderData ? intval($workOrderData['sign_count_2']) : 0;
                
                $where = [
                    'factory_id' => $storeId,
                    'is_del' => 0,
                ];
                $field = 'count(if(work_order_type = 1, true, NULL)) as post_count_1';
                $field .= ', count(if(work_order_type = 1 && sign_time > 0, true, NULL)) as sign_count_1';
                $field .= ', count(if(work_order_type = 2, true, NULL)) as post_count_2';
                $field .= ', count(if(work_order_type = 2 && sign_time > 0, true, NULL)) as sign_count_2';
                $workOrderData = $workOrderModel->field($field)->where($where)->find();
                
                $total['post_count_1'] = $workOrderData ? intval($workOrderData['post_count_1']) : 0;
                $total['sign_count_1'] = $workOrderData ? intval($workOrderData['sign_count_1']) : 0;
                $total['post_count_2'] = $workOrderData ? intval($workOrderData['post_count_2']) : 0;
                $total['sign_count_2'] = $workOrderData ? intval($workOrderData['sign_count_2']) : 0;
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
                    'S.store_type'=> 2,
                    'S.store_id'=> $storeId,
                    'O.add_time' => ['>=', $beginToday],
                    'O.order_status'  => ['<>', 2],
                    'O.pay_status'    => 1,//已支付
                ];
                $join=[
                    ['store_dealer SD','O.user_store_id=SD.store_id'],
                    ['store S','SD.ostore_id=S.store_id'],
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
                    'add_time'  => ['>=', $beginToday],
                    'store_type'=> STORE_DEALER,
                    'S.is_del'    => 0,
                    'SD.ostore_id' => $storeId,
                ];
                $today['dealer_count'] = $storeModel->alias('S')->join('store_dealer SD', 'SD.store_id = S.store_id', 'INNER')->where($where)->count();
                
                //累计零售商数量统计
                $where = [
                    'S.is_del'     => 0,
                    'SD.ostore_id' => $storeId,
                    'store_type'=> STORE_DEALER,
                ];
                $total['dealer_count'] = $storeModel->alias('S')->join('store_dealer SD', 'SD.store_id = S.store_id', 'INNER')->where($where)->count();
                
                break;
            case ADMIN_DEALER:
                $tpl = 'dealer';
                //今日订单数据统计
                $where = [
                    'user_store_id' => $storeId,
                    'add_time' => ['>=', $beginToday],
                    'order_status'  => ['<>', 2],
                    'pay_status'    => 1,
                ];
                $todayOrder = $orderModel->field('count(*) as order_count, sum(real_amount) as order_amount')->where($where)->find();
                //今日订单数
                $today['order_count'] = $todayOrder && isset($todayOrder['order_count']) ? intval($todayOrder['order_count']) : 0;
                //今日订单金额
                $today['order_amount'] = $todayOrder && isset($todayOrder['order_amount']) ? sprintf("%.2f",($todayOrder['order_amount'])) : 0;
                
                //累计订单数据统计
                $where = [
                    'user_store_id' => $storeId,
                    'order_status'  => ['<>', 2],
                    'pay_status'    => 1,
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
                $join=[
                    ['store S','C.store_id = S.store_id','INNER'],
                ];
                $where=[
                    'C.is_del'  => 0,
                    'S.store_id'=>$storeId,
                    'C.income_status'=>['IN',[0,1]],
                    'C.add_time'=>['>=',$beginToday],
                ];
                $today['commission_amount']=db('store_service_income')->alias('C')->join($join)->where($where)->sum('C.install_amount');
                //累计佣金收益
                $total['commission_amount']=db('store_finance')->where(['store_id' => $storeId])->value('total_amount');
                
                $where = [
                    'store_id' => $storeId,
                    'is_del' => 0,
                    'add_time' => ['>=',$beginToday],
                ];
                $field = 'count(if(work_order_type = 1 && add_time >= '.$beginToday.', true, NULL)) as post_count_1';
                $field .= ', count(if(work_order_type = 1 && sign_time >= '.$beginToday.', true, NULL)) as sign_count_1';
                $field .= ', count(if(work_order_type = 2 && add_time >= '.$beginToday.', true, NULL)) as post_count_2';
                $field .= ', count(if(work_order_type = 2 && sign_time >= '.$beginToday.', true, NULL)) as sign_count_2';
                $workOrderData = $workOrderModel->field($field)->where($where)->find();
                
                $today['post_count_1'] = $workOrderData ? intval($workOrderData['post_count_1']) : 0;
                $today['sign_count_1'] = $workOrderData ? intval($workOrderData['sign_count_1']) : 0;
                $today['post_count_2'] = $workOrderData ? intval($workOrderData['post_count_2']) : 0;
                $today['sign_count_2'] = $workOrderData ? intval($workOrderData['sign_count_2']) : 0;
                
                $where = [
                    'store_id' => $storeId,
                    'is_del' => 0,
                    'sign_time > 0',
                ];
                $field = 'count(if(work_order_type = 1, true, NULL)) as workorder_count_1';
                $field .= ', count(if(work_order_type = 2, true, NULL)) as workorder_count_2';
                $workOrderData = $workOrderModel->field($field)->where($where)->find();
                
                //累计上门安装工单数量
                $total['workorder_count_1'] = $workOrderData ? intval($workOrderData['workorder_count_1']) : 0;
                //累计上门维修工单数量
                $total['workorder_count_2'] = $workOrderData ? intval($workOrderData['workorder_count_2']) : 0;
                
                
                break;
            default:
                break;
        }
        if ($chart) {
            $from = date('Y-m-d',$beginToday-86400*6);//图表统计开始时间
            $to = date('Y-m-d',$beginToday);//图表统计结束时间
            if ($adminType != ADMIN_SERVICE) {
                $orderOverview = $this->orderOverView($from, $to, $storeId);
                $orderStatistics = $this->orderAmount($from, $to, $storeId);
            }else{
                $worderOverview = $this->workOrderOverView($from, $to, $storeId);
                $worderStatistics = $this->workOrderIncome($from, $to, $storeId);
            }
        }
        return [
            'tpl'   => $tpl,
            'today' => $today, 
            'total' => $total, 
            'order_overview'    => $orderOverview, 
            'order_statistics'  => $orderStatistics, 
            'worder_overview'   => $worderOverview, 
            'worder_statistics' => $worderStatistics
        ];
    }
    
    //订单概况
    protected function orderOverView($startTime,$endTime,$storeId)
    {
        
        $data=[];
        $lable=[];
        $dataset[0] = [
            'name'     =>'',
            'type'     =>'line',
            'itemStyle'=>[],
            'smooth'   => 0.5
        ];
        $model = new \app\common\model\Order();
        
        if ($startTime==$endTime){//单日数据
            $begin=strtotime($startTime.' 00:00:00');
            $endTime=strtotime($endTime.' 23:59:59');
            $i=0;
            $now=date('Y-m-d H:00');
            while ($begin<=$endTime) {
                $data[$i]['time']=date('H:00',$begin);
                $end=$begin+3600;
                $where=[
                    ['add_time','>=',$begin],
                    ['add_time','<',$end],
                    ['order_status','<>',2],
                    ['pay_status','=',1],
                ];
                if ($this->adminUser['admin_type']==ADMIN_CHANNEL) {
                    //渠道商零售商数据据统计
                    $where=[
                        ['O.add_time','>=',$begin],
                        ['O.add_time','<',$end],
                        ['S.is_del','=',0],
                        ['S.store_type','=',2],
                        ['S.store_id','=',$storeId],
                        ['order_status','<>',2],
                        ['O.pay_status','=',1],
                    ];
                    $join=[
                        ['store_dealer SD','O.user_store_id=SD.store_id'],
                        ['store S','SD.ostore_id=S.store_id'],
                    ];
                    $query = $model->alias('O')->join($join)->where($where);
                }else if ($this->adminUser['admin_type']==ADMIN_FACTORY){//厂商
                    $where[]=['store_id','=',$storeId];
                    $query=$model->where($where);
                }else{
                    $where[]=['user_store_id','=',$storeId];
                    $query=$model->where($where);
                }
                $key='order_overview_'.$begin.'_'.$end.'_'.$storeId.'_'.$data[$i]['time'];
                
                //以前数据加缓存7天
                //if ($now != $data[$i]['time']) {
                //    $query->cache($key,86400*7);
                //}
                $data[$i]['value']=$query->count();
                
                $lable[$i]=$data[$i]['time'];//鼠标移动提示
                $dataset[0]['data'][$i]=$data[$i]['value'];//显示数据子元素值
                $i++;
                $begin=$end;
                if ($end>strtotime(date('Y-m-d H:00'))) {
                    break;
                }
                
            }
        }else{
            $begin=strtotime($startTime.' 00:00:00');
            $endTime=strtotime($endTime.' 23:59:59');
            $i=0;
            $today=date('Y-m-d');
            while($begin<=$endTime){
                $data[$i]['time']=date('Y-m-d',$begin);
                $end=$begin+86400;
                $where=[
                    ['add_time','>=',$begin],
                    ['add_time','<',$end],
                    ['order_status','<>',2],
                    ['pay_status','=',1],
                ];
                if ($this->adminUser['admin_type']==ADMIN_CHANNEL) {
                    //渠道商零售商数据据统计
                    $where=[
                        ['O.add_time','>=',$begin],
                        ['O.add_time','<',$end],
                        ['S.is_del','=',0],
                        ['S.store_type','=',2],
                        ['S.store_id','=',$storeId],
                        ['order_status','<>',2],
                        ['O.pay_status','=',1],
                    ];
                    $join=[
                        ['store_dealer SD','O.user_store_id=SD.store_id'],
                        ['store S','SD.ostore_id=S.store_id'],
                    ];
                    $query = $model->alias('O')->join($join)->where($where);
                }else if ($this->adminUser['admin_type']==ADMIN_FACTORY){//厂商
                    $where[]=['store_id','=',$storeId];
                    $query=$model->where($where);
                }else{
                    $where[]=['user_store_id','=',$storeId];
                    $query=$model->where($where);
                }
                $key='order_overview_'.$begin.'_'.$end.'_'.$storeId;
                //以前数据加缓存7天
                //if ($today != $data[$i]['time']) {
                //    $query->cache($key,86400*7);
                //}
                $data[$i]['value']=$query->count();
                
                $lable[$i]=$data[$i]['time'];//鼠标移动提示
                $dataset[0]['data'][$i]=$data[$i]['value'];//显示数据子元素值
                $i++;
                $begin=$end;
            }
        }
        
        $color=['#009688'];
        $chart=new\app\common\service\Chart('group',[''],$lable,$dataset,$color,false);
        $result=$chart->getOption();
        if(IS_AJAX){
            return $this->ajaxJsonReturn($result);
        }else{
            return json_encode($result);
        }
    }
    
    //订单金额统计
    protected function orderAmount($startTime,$endTime,$storeId)
    {
        $data=[];
        $lable=[];
        $dataset[0] = [
            'name'     =>'',
            'type'     =>'line',
            'itemStyle'=>[],
            'smooth'   => 0.5
        ];
        $model=new \app\common\model\Order();
        
        //$startTime='2018-12-14';
        //$endTime='2018-12-25';
        //$storeId=3;
        
        if ($startTime==$endTime){//单日数据
            $begin=strtotime($startTime.' 00:00:00');
            $endTime=strtotime($endTime.' 23:59:59');
            $i=0;
            $now=date('Y-m-d H:00');
            while ($begin<=$endTime) {
                $data[$i]['time']=date('H:00',$begin);
                $end=$begin+3600;
                $where=[
                    ['add_time','>=',$begin],
                    ['add_time','<',$end],
                    ['order_status','<>',2],
                    ['pay_status','=',1],
                ];
                
                if ($this->adminUser['admin_type']==ADMIN_CHANNEL) {
                    //渠道商零售商数据据统计
                    $where=[
                        ['O.add_time','>=',$begin],
                        ['O.add_time','<',$end],
                        ['S.is_del','=',0],
                        ['S.store_type','=',2],
                        ['S.store_id','=',$storeId],
                        ['order_status','<>',2],
                        ['O.pay_status','=',1],
                    ];
                    $join=[
                        ['store_dealer SD','O.user_store_id=SD.store_id'],
                        ['store S','SD.ostore_id=S.store_id'],
                    ];
                    $query = $model->alias('O')->join($join)->where($where);
                }else if ($this->adminUser['admin_type']==ADMIN_FACTORY){//厂商
                    $where[]=['store_id','=',$storeId];
                    $query=$model->where($where);
                }else{
                    $where[]=['user_store_id','=',$storeId];
                    $query=$model->where($where);
                }
                $key='order_overview_'.$begin.'_'.$end.'_'.$storeId.'_'.$data[$i]['time'];
                
                //以前数据加缓存7天
                //if ($now != $data[$i]['time']) {
                //    $query->cache($key,86400*7);
                //}
                $data[$i]['value']=$query->sum('real_amount');
                
                $lable[$i]=$data[$i]['time'];//鼠标移动提示
                $dataset[0]['data'][$i]=$data[$i]['value'];//显示数据子元素值
                $i++;
                $begin=$end;
                if ($end>strtotime(date('Y-m-d H:00'))) {
                    break;
                }
                
            }
        }else{
            $begin=strtotime($startTime.' 00:00:00');
            $endTime=strtotime($endTime.' 23:59:59');
            $i=0;
            
            $today=date('Y-m-d');
            while($begin<=$endTime){
                $data[$i]['time']=date('Y-m-d',$begin);
                $end=$begin+86400;
                $where=[
                    ['add_time','>=',$begin],
                    ['add_time','<',$end],
                    ['order_status','<>',2],
                    ['pay_status','=',1],
                ];
                
                if ($this->adminUser['admin_type']==ADMIN_CHANNEL) {
                    //渠道商零售商数据据统计
                    $where=[
                        ['O.add_time','>=',$begin],
                        ['O.add_time','<',$end],
                        ['S.is_del','=',0],
                        ['S.store_type','=',2],
                        ['S.store_id','=',$storeId],
                        ['O.order_status','=',1],
                        ['O.pay_status','=',1],
                    ];
                    $join=[
                        ['store_dealer SD','O.user_store_id=SD.store_id'],
                        ['store S','SD.ostore_id=S.store_id'],
                    ];
                    $query = $model->alias('O')->join($join)->where($where);
                }else if ($this->adminUser['admin_type']==ADMIN_FACTORY){//厂商
                    $where[]=['store_id','=',$storeId];
                    $query=$model->where($where);
                }else{
                    $where[]=['user_store_id','=',$storeId];
                    $query=$model->where($where);
                }
                $key='order_overview_'.$begin.'_'.$end.'_'.$storeId;
                //以前数据加缓存7天
                //if ($today != $data[$i]['time']) {
                //    $query->cache($key,86400*7);
                //}
                $data[$i]['value']=$query->sum('real_amount');
                
                $lable[$i]=$data[$i]['time'];//鼠标移动提示
                $dataset[0]['data'][$i]=$data[$i]['value'];//显示数据子元素值
                $i++;
                $begin=$end;
            }
        }
        
        $color=['#009688'];
        $chart=new\app\common\service\Chart('group',[''],$lable,$dataset,$color,false);
        $result=$chart->getOption();
        if(IS_AJAX){
            return $this->ajaxJsonReturn($result);
        }else{
            return json_encode($result);
        }
    }
    //工单概况
    protected function workOrderOverView($startTime,$endTime,$storeId)
    {
        $data=[];
        $lable=[];
        $dataset[0] = [
            'name'     =>'',
            'type'     =>'line',
            'itemStyle'=>[],
            'smooth'   => 0.5
        ];
        $workOrder=new \app\common\model\WorkOrder();
        
        //$startTime='2018-12-14';
        //$endTime='2018-12-25';
        //$storeId=3;
        
        if ($startTime==$endTime){//单日数据
            $begin=strtotime($startTime.' 00:00:00');
            $endTime=strtotime($endTime.' 23:59:59');
            $i=0;
            $now=date('Y-m-d H:00');
            while ($begin<=$endTime) {
                $data[$i]['time']=date('H:00',$begin);
                $end=$begin+3600;
                $where=[
                    ['add_time','>=',$begin],
                    ['add_time','<',$end],
                    ['store_id','=',$storeId],
                ];
                $key='work_order_overview_'.$begin.'_'.$end.'_'.$storeId.'_'.$data[$i]['time'];
                $query=$workOrder->where($where);
                //以前数据加缓存7天
                //if ($now != $data[$i]['time']) {
                //    $query->cache($key,86400*7);
                //}
                $data[$i]['value']=$query->count();
                
                $lable[$i]=$data[$i]['time'];//鼠标移动提示
                $dataset[0]['data'][$i]=$data[$i]['value'];//显示数据子元素值
                $i++;
                $begin=$end;
                if ($begin>strtotime(date('Y-m-d H:00'))) {
                    break;
                }
            }
        }else{
            $begin=strtotime($startTime.' 00:00:00');
            $endTime=strtotime($endTime.' 23:59:59');
            $i=0;
            
            $today=date('Y-m-d');
            while($begin<=$endTime){
                $data[$i]['time']=date('Y-m-d',$begin);
                $end=$begin+86400;
                $where=[
                    ['add_time','>=',$begin],
                    ['add_time','<',$end],
                    ['store_id','=',$storeId],
                ];
                $key='order_overview_'.$begin.'_'.$end.'_'.$storeId;
                $query=$workOrder->where($where);
                //以前数据加缓存7天
                //if ($today != $data[$i]['time']) {
                //    $query->cache($key,86400*7);
                //}
                $data[$i]['value']=$query->count();
                
                $lable[$i]=$data[$i]['time'];//鼠标移动提示
                $dataset[0]['data'][$i]=$data[$i]['value'];//显示数据子元素值
                $i++;
                $begin=$end;
            }
        }
        
        $color=['#009688'];
        $chart=new\app\common\service\Chart('group',[''],$lable,$dataset,$color,false);
        $result=$chart->getOption();
        if(IS_AJAX){
            return $this->ajaxJsonReturn($result);
        }else{
            return json_encode($result);
        }
    }
    
    //工单佣金统计
    protected function workOrderIncome($startTime,$endTime,$storeId)
    {
        
        $data=[];
        $lable=[];
        $dataset[0] = [
            'name'     =>'',
            'type'     =>'line',
            'itemStyle'=>[],
            'smooth'   => 0.5
        ];
        $model=db('store_service_income');
        
        //$startTime='2018-12-14';
        //$endTime='2018-12-25';
        //$storeId=3;
        
        if ($startTime==$endTime){//单日数据
            $begin=strtotime($startTime.' 00:00:00');
            $endTime=strtotime($endTime.' 23:59:59');
            $i=0;
            $now=date('Y-m-d H:00');
            while ($begin<=$endTime) {
                $data[$i]['time']=date('H:00',$begin);
                $end=$begin+3600;
                $where=[
                    ['add_time','>=',$begin],
                    ['add_time','<',$end],
                    ['store_id','=',$storeId],
                    ['income_status', '<>', 2],
                ];
                $key='work_order_income_'.$begin.'_'.$end.'_'.$storeId.'_'.$data[$i]['time'];
                $query=$model->where($where);
                //以前数据加缓存7天
                //if ($now != $data[$i]['time']) {
                //    $query->cache($key,86400*7);
                //}
                $data[$i]['value']=$query->sum('install_amount');
                
                $lable[$i]=$data[$i]['time'];//鼠标移动提示
                $dataset[0]['data'][$i]=$data[$i]['value'];//显示数据子元素值
                $i++;
                $begin=$end;
                if ($begin>strtotime(date('Y-m-d H:00'))) {
                    break;
                }
            }
        }else{
            $begin=strtotime($startTime.' 00:00:00');
            $endTime=strtotime($endTime.' 23:59:59');
            $i=0;
            
            $today=date('Y-m-d');
            while($begin<=$endTime){
                $data[$i]['time']=date('Y-m-d',$begin);
                $end=$begin+86400;
                $where=[
                    ['add_time','>=',$begin],
                    ['add_time','<',$end],
                    ['store_id','=',$storeId],
                    ['income_status', '<>', 2],
                ];
                $key='work_order_income_'.$begin.'_'.$end.'_'.$storeId;
                $query=$model->where($where);
                //以前数据加缓存7天
                //if ($today != $data[$i]['time']) {
                //    $query->cache($key,86400*7);
                //}
                $data[$i]['value']=$query->sum('install_amount');
                
                $lable[$i]=$data[$i]['time'];//鼠标移动提示
                $dataset[0]['data'][$i]=$data[$i]['value'];//显示数据子元素值
                $i++;
                $begin=$end;
            }
        }
        
        $color=['#009688'];
        $chart=new\app\common\service\Chart('group',[''],$lable,$dataset,$color,false);
        $result=$chart->getOption();
        if(IS_AJAX){
            return $this->ajaxJsonReturn($result);
        }else{
            return json_encode($result);
        }
    }
}