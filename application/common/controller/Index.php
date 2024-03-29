<?php
namespace app\common\controller;
use app\common\controller\CommonBase;
use app\common\model\WorkOrder;
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
            $code = isset($params['code']) && $params['code'] ? trim($params['code']) : '';
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
            if ($phone != $user['phone'] && !$code) {
                $this->error('验证码不能为空');
            }
            $params['user_id'] = $user['user_id'];
            $result = $userModel->checkFormat($this->adminUser['factory_id'], $params);
            if ($result === FALSE) {
                $this->error($userModel->error);
            }
            if ($phone != $user['phone']) {
                //判断验证码是否正确
                $codeModel = new \app\common\model\LogCode();
                $params['type'] = 'change_phone';
                $result = $codeModel->verifyCode($params);
                if ($result === FALSE){
                    $this->error($codeModel->error);
                }
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
    
    public function sendSmsCode()
    {
        $params = $this->request->param();
        $phone  = isset($params['phone']) ? trim($params['phone']) : '';
        $type   = isset($params['type']) ? trim($params['type']) : 'change_phone';
        if (!$phone) {
            $this->error('手机号不能为空');
        }
        if ($type != 'change_phone') {
            $this->error('参数错误');
        }
        if ($phone == $this->adminUser['phone']) {
            $this->error('手机号未修改');
        }
        //验证手机号格式
        $userModel = new \app\common\model\User();
        $result = $userModel->checkPhone($this->adminFactory['store_id'], $phone, TRUE, ['user_id' => $this->adminUser['user_id']]);
        if ($result === FALSE) {
            $this->error($userModel->error);
        }
        $codeModel = new \app\common\model\LogCode();
        $result = $codeModel->sendSmsCode($this->adminFactory['store_id'], $phone, $type);
        if ($result === FALSE){
            $this->error('验证码发送失败:'.$codeModel->error);
        }else{
            if ($result['status']) {
                $this->success('验证码发送成功,5分钟内有效');
            }else{
                $this->success('验证码发送失败:'.$result['result']);
            }
        }
    }
    
    //获取商户首页数据
    public function getStoreHome($user = [], $chart = TRUE,$isRaw=false, $adminUser = [])
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
        $today = $total = $orderOverview = $orderStatistics = $worderOverview = $worderStatistics =$worderAssess= [];
        $beginToday = mktime(0,0,0,date('m'),date('d'),date('Y')); //今日开始时间戳

        $channelId=0;
        switch ($adminType) {
            case ADMIN_FACTORY:
                $tpl = 'factory';
                //今日订单数据统计
                $where = [
                    ['add_time','>=',$beginToday],
                    ['store_id','=',$storeId],
                    ['order_status','<>',2],
                    ['pay_status','=',1],
                    ['user_store_type','IN',[STORE_SERVICE,STORE_SERVICE_NEW]],
                ];
                //电商
                $whereECommerce='add_time>='.$beginToday.' AND pay_status=1 AND order_status=1 AND user_store_type='.STORE_FACTORY.' AND factory_id='.$this->adminUser['factory_id'];
                $whereFenxiao='add_time>='.$beginToday.' AND  store_id='.$storeId.' AND order_type=2 AND pay_status=1 AND order_status<>2 AND udata_id>0 AND factory_id='.$this->adminUser['factory_id'];
                $todayOrder = db('order')
                    ->field('count(*) as order_count,sum(real_amount) as order_amount')
                    ->where($where)
                    ->whereOrRaw($whereFenxiao)
                    ->whereOrRaw($whereECommerce)
                    ->find();
                //p($todayOrder);
                //今日订单数
                $today['order_count'] = $todayOrder && isset($todayOrder['order_count']) ? intval($todayOrder['order_count']) : 0;
                //今日订单金额
                $today['order_amount'] = $todayOrder && isset($todayOrder['order_amount']) ? sprintf("%.2f",($todayOrder['order_amount'])) : 0;

                //累计订单数据统计
                $where = [
                    ['factory_id','=',$this->adminUser['factory_id']],
                    ['order_status','<>',2],
                    ['pay_status','=',1],
                    ['user_store_type','IN',[STORE_SERVICE,STORE_SERVICE_NEW]],
                ];
                //电商
                $whereECommerce='pay_status=1 AND order_status=1 AND user_store_type='.STORE_FACTORY.' AND factory_id='.$this->adminUser['factory_id'];
                //分销订单
                $whereFenxiao='store_id='.$storeId.' AND order_type=2 AND pay_status=1 AND order_status<>2 AND udata_id>0 AND factory_id='.$this->adminUser['factory_id'];
                $totalOrder = db('order')
                    ->field('count(*) as order_count,sum(real_amount) as order_amount')
                    ->where($where)
                    ->whereOrRaw($whereFenxiao)
                    ->whereOrRaw($whereECommerce)
                    ->find();
                //累计订单数
                $total['order_count'] = $totalOrder && isset($totalOrder['order_count']) ? intval($totalOrder['order_count']) : 0;
                //累计订单金额
                $total['order_amount'] = $totalOrder && isset($totalOrder['order_amount']) ? sprintf("%.2f",($totalOrder['order_amount'])) : 0;
                //p($total);

                //今日新增零售商数量
                $where = [
                    ['factory_id','=',$storeId],
                    ['add_time','>=',$beginToday],
                    ['store_type','=',STORE_DEALER],
                    ['is_del','=',0],
                ];
                $today['dealer_count'] = $storeModel->where($where)->count();
                
                //累计商户数据统计
                $where = [
                    ['factory_id','=',$storeId],
                    ['is_del','=',0],
                ];
                $field = 'count(if(store_type = '.STORE_CHANNEL.', true, NULL)) as channel_count';
                $field .= ', count(if(store_type = '.STORE_DEALER.', true, NULL)) as dealer_count';
                $field .= ', count(if(store_type in ('.STORE_SERVICE.','.STORE_SERVICE_NEW.'), true, NULL)) as service_count';
                $field .= ', sum(if(store_type IN('.STORE_CHANNEL.','.STORE_SERVICE_NEW.','.STORE_SERVICE.'), security_money, 0)) as security_money_total';
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
                    ['factory_id','=',$storeId],
                    ['is_del','=',0],
                ];
                $totalInstaller = $userInstallerModel->where($where)->count();
                $total['installer_count'] = intval($totalInstaller);
                
                $join = [
                    ['store_finance SF', 'S.store_id = SF.store_id', 'INNER'],
                ];
                $where = [
                    ['S.factory_id','=',$storeId],
                    ['S.is_del','=',0],
                    ['S.store_type','IN',[STORE_CHANNEL, STORE_SERVICE,STORE_SERVICE_NEW]],
                ];
                $field = ' sum(if(store_type = '.STORE_CHANNEL.', withdraw_amount, 0)) as channel_withdraw_amount';
                $field .= ', sum(if( store_type IN  ('.STORE_SERVICE.','.STORE_SERVICE_NEW.'), withdraw_amount, 0)) as servicer_withdraw_amount';
                $totalStore = $storeModel->alias('S')->field($field)->join($join)->where($where)->find();
                //渠道商累计提现金额
                $total['channel_withdraw_amount'] = $totalStore && isset($totalStore['channel_withdraw_amount']) ? floatval($totalStore['channel_withdraw_amount']) : 0;
                //服务商累计提现金额
                $total['servicer_withdraw_amount'] = $totalStore && isset($totalStore['servicer_withdraw_amount']) ? floatval($totalStore['servicer_withdraw_amount']) : 0;
                
                $orderSku=db('order_sku_service');
                $where = [
                    ['store_id','=',$storeId],
                    ['service_status','=',3],
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
                    ['factory_id','=',$storeId],
                    ['is_del','=',0],
                    ['add_time','>=',$beginToday],
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
                    ['factory_id','=',$storeId],
                    ['is_del','=',0],
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

                //服务商列表
                $store = db('store')->field('store_id,name')->where([
                    'factory_id'   => $this->adminUser['store_id'],
                    'store_type'   => ['IN',[STORE_SERVICE,STORE_SERVICE_NEW]],
                    'status'       => 1,
                    'is_del'       => 0,
                    'check_status' => 1,
                ])->select();
                $this->assign('service',$store);
                break;
            case ADMIN_CHANNEL:
                $tpl = 'channel';
                //今日佣金收益
                $commissionModel=new \app\common\model\StoreCommission();
                $join=[
                    ['store S','C.store_id = S.store_id','INNER'],
                ];
                $where=[
                    ['S.store_id','=',$storeId],
                    ['C.commission_status','IN',[0,1]],
                    ['C.add_time','>=',$beginToday],
                ];
                $today['commission_amount']=$commissionModel->alias('C')->join($join)->where($where)->sum('C.income_amount');
                //累计佣金收益
                unset($where['C.add_time']);
                $total['commission_amount']=$commissionModel->alias('C')->join($join)->where($where)->sum('C.income_amount');
                
                //今日订单数(渠道下的零售商订单数量)
                //累计订单数(渠道下的零售商订单数量)
                $where = [
                    ['S.is_del','=',0],
                    ['S.store_type','=',2],
                    ['S.store_id','=',$storeId],
                    ['O.add_time','>=',$beginToday],
                    ['O.order_status','<>',2],
                    ['O.pay_status','=',1],
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
                    ['add_time','>=',$beginToday],
                    ['store_type','=',STORE_DEALER],
                    ['S.is_del','=',0],
                    ['SD.ostore_id','=',$storeId],
                ];
                $today['dealer_count'] = $storeModel->alias('S')->join('store_dealer SD', 'SD.store_id = S.store_id', 'INNER')->where($where)->count();
                
                //累计零售商数量统计
                $where = [
                    ['S.is_del','=',0],
                    ['SD.ostore_id','=',$storeId],
                    ['store_type','=',STORE_DEALER]
                ];
                $total['dealer_count'] = $storeModel->alias('S')->join('store_dealer SD', 'SD.store_id = S.store_id', 'INNER')->where($where)->count();
                
                break;
            case ADMIN_DEALER:
                $tpl = 'dealer';
                //今日订单数据统计
                $where = [
                    ['user_store_id','=',$storeId],
                    ['add_time','>=',$beginToday],
                    ['order_status','<>',2],
                    ['pay_status','=',1],
                ];
                $todayOrder = $orderModel->field('count(*) as order_count, sum(real_amount) as order_amount')->where($where)->find();
                //今日订单数
                $today['order_count'] = $todayOrder && isset($todayOrder['order_count']) ? intval($todayOrder['order_count']) : 0;
                //今日订单金额
                $today['order_amount'] = $todayOrder && isset($todayOrder['order_amount']) ? sprintf("%.2f",($todayOrder['order_amount'])) : 0;
                
                //累计订单数据统计
                $where = [
                    ['user_store_id','=',$storeId],
                    ['order_status','<>',2],
                    ['pay_status','=',1],
                ];
                $totalOrder = $orderModel->field('count(*) as order_count, sum(real_amount) as order_amount')->where($where)->find();
                //累计订单数
                $total['order_count'] = $totalOrder && isset($totalOrder['order_count']) ? intval($totalOrder['order_count']) : 0;
                //累计订单金额
                $total['order_amount'] = $totalOrder && isset($totalOrder['order_amount']) ? sprintf("%.2f",($totalOrder['order_amount'])) : 0;
                
                break;
            case ADMIN_SERVICE:
                $tpl = 'servicer';
                $channelId=$storeId;
                //今日佣金收益
                $join=[
                    ['store S','C.store_id = S.store_id','INNER'],
                ];
                $where=[
                    ['C.is_del','=',0],
                    ['S.store_id','=',$storeId],
                    ['C.income_status','IN',[0,1]],
                    ['C.add_time','>=',$beginToday],
                ];
                $today['commission_amount']=db('store_service_income')->alias('C')->join($join)->where($where)->sum('C.install_amount');
                //累计佣金收益
                $total['commission_amount']=db('store_finance')->where(['store_id' => $storeId])->value('total_amount');
                
                $where = [
                    ['store_id','=',$storeId],
                    ['is_del','=',0],
                    ['add_time','>=',$beginToday],
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
                    ['store_id','=',$storeId],
                    ['is_del','=',0],
                    ['sign_time','>',0],
                ];
                $field = 'count(if(work_order_type = 1, true, NULL)) as workorder_count_1';
                $field .= ', count(if(work_order_type = 2, true, NULL)) as workorder_count_2';
                $workOrderData = $workOrderModel->field($field)->where($where)->find();
                
                //累计上门安装工单数量
                $total['workorder_count_1'] = $workOrderData ? intval($workOrderData['workorder_count_1']) : 0;
                //累计上门维修工单数量
                $total['workorder_count_2'] = $workOrderData ? intval($workOrderData['workorder_count_2']) : 0;
                break;
            case ADMIN_SERVICE_NEW:
                $tpl = 'servicer2';
                $channelId=$storeId;
                $where = [
                    ['store_id','=',$storeId],
                    ['is_del','=',0],
                    ['add_time','>=',$beginToday],
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
                    ['store_id','=',$storeId],
                    ['is_del','=',0],
                    ['sign_time','>',0],
                ];
                $field = 'count(if(work_order_type = 1, true, NULL)) as workorder_count_1';
                $field .= ', count(if(work_order_type = 2, true, NULL)) as workorder_count_2';
                $workOrderData = $workOrderModel->field($field)->where($where)->find();

                //累计上门安装工单数量
                $total['workorder_count_1'] = $workOrderData ? intval($workOrderData['workorder_count_1']) : 0;
                //累计上门维修工单数量
                $total['workorder_count_2'] = $workOrderData ? intval($workOrderData['workorder_count_2']) : 0;
                
                
                //今日订单数(渠道下的零售商订单数量)
                //累计订单数(渠道下的零售商订单数量)
                $where = [
                    ['S.is_del','=',0],
                    ['S.store_type','=', STORE_SERVICE_NEW],
                    ['S.store_id','=',$storeId],
                    ['O.add_time','>=',$beginToday],
                    ['O.order_status','<>',2],
                    ['O.pay_status','=',1],
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
                $where = [
                    ['S.is_del','=',0],
                    ['S.store_type','=', STORE_SERVICE_NEW],
                    ['S.store_id','=',$storeId],
                    ['O.order_status','<>',2],
                    ['O.pay_status','=',1],
                ];
                $totalOrder = $orderModel->alias('O')->field($field)->join($join)->where($where)->find();
                //累计订单数
                $total['order_count'] = $totalOrder && isset($totalOrder['order_count']) ? intval($totalOrder['order_count']) : 0;
                //累计订单金额
                $total['order_amount'] = $totalOrder && isset($totalOrder['order_amount']) ? sprintf("%.2f",($totalOrder['order_amount'])) : 0;
                
                //今日新增零售商数量
                $where = [
                    ['add_time','>=',$beginToday],
                    ['store_type','=',STORE_DEALER],
                    ['S.is_del','=',0],
                    ['SD.ostore_id','=',$storeId],
                ];
                $today['dealer_count'] = $storeModel->alias('S')->join('store_dealer SD', 'SD.store_id = S.store_id', 'INNER')->where($where)->count();
                
                //累计零售商数量统计
                $where = [
                    ['S.is_del','=',0],
                    ['SD.ostore_id','=',$storeId],
                    ['store_type','=',STORE_DEALER]
                ];
                $total['dealer_count'] = $storeModel->alias('S')->join('store_dealer SD', 'SD.store_id = S.store_id', 'INNER')->where($where)->count();
                break;
            default:
                break;
        }
        if ($chart) {
            $from = date('Y-m-d',$beginToday-86400*6);//图表统计开始时间
            $to = date('Y-m-d',$beginToday);//图表统计结束时间
            if ($adminType != ADMIN_SERVICE) {
                $orderOverview = $this->orderOverView($from, $to, $storeId,$isRaw, $adminUser);
                $orderStatistics = $this->orderAmount($from, $to, $storeId,$isRaw, $adminUser);
            }else{
                $worderOverview = $this->workOrderOverView($from, $to, $storeId,$isRaw);
                $worderStatistics = $this->workOrderIncome($from, $to, $storeId,$isRaw);
            }
        }
        $result=[
            'tpl'               => $tpl,
            'today'             => $today,
            'total'             => $total,
            'order_overview'    => $orderOverview,
            'order_statistics'  => $orderStatistics,
            'worder_overview'   => $worderOverview,
            'worder_statistics' => $worderStatistics,
        ];
        if (in_array($adminType, [ADMIN_SERVICE, ADMIN_SERVICE_NEW, ADMIN_FACTORY])) {
            $worderAssess=$this->work_order_assess($from, $to,$user, $channelId,$isRaw);
            $result['worder_assess']=json_encode($worderAssess['assess']);
            $result['worder_score']=json_encode($worderAssess['assess_score']);
        }
        return $result;
    }
    
    //订单概况
    protected function orderOverView($startTime,$endTime,$storeId,$isRaw=false, $adminUser = [])
    {
        $adminUser = $this->adminUser ? $this->adminUser : $adminUser;
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
                if ($adminUser['admin_type']==ADMIN_CHANNEL) {
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
                }else if ($adminUser['admin_type']==ADMIN_FACTORY){//厂商
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
                if ($adminUser['admin_type']==ADMIN_CHANNEL) {
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
                }else if ($adminUser['admin_type']==ADMIN_FACTORY){//厂商
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

        if ($isRaw) {
            return $this->rawSimple($data);
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

    private function rawSimple($data)
    {
        $result= array_map(function ($item) {
            $item['time']=date('n.j',strtotime($item['time']));
            return $item;
        },$data);
        return $result;
    }

    //订单金额统计
    protected function orderAmount($startTime,$endTime,$storeId,$isRaw=false, $adminUser = [])
    {
        $adminUser = $this->adminUser ? $this->adminUser : $adminUser;
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
                
                if ($adminUser['admin_type']==ADMIN_CHANNEL) {
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
                }else if ($adminUser['admin_type']==ADMIN_FACTORY){//厂商
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
                
                if ($adminUser['admin_type']==ADMIN_CHANNEL) {
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
                }else if ($adminUser['admin_type']==ADMIN_FACTORY){//厂商
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

        if ($isRaw) {
            return $this->rawSimple($data);
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
    protected function workOrderOverView($startTime,$endTime,$storeId,$isRaw=false)
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

        if ($isRaw) {
            return $this->rawSimple($data);
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
    protected function workOrderIncome($startTime,$endTime,$storeId,$isRaw=false)
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

        if ($isRaw) {
            return $this->rawSimple($data);
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

    //工单评价统计
    public function work_order_assess($from,$to,$user,$storeId,$isRaw=false)
    {
        $result=[
            'assess'=>[],
            'assess_score'=>[],
        ];
        if (!in_array($user['admin_type'],[ADMIN_SERVICE,ADMIN_SERVICE_NEW,ADMIN_FACTORY])) {
            return $result;
        }
        $from=strtotime($from);
        $to=strtotime($to);
        $where=[
            ['p1.is_del','=',0],
            ['p1.work_order_status','=',4],
            ['p1.add_time','>=',$from],
            ['p1.add_time','<=',$to],
        ];
        if (in_array($user['admin_type'],[ADMIN_SERVICE,ADMIN_SERVICE_NEW])) {
            $where[]=['p1.store_id','=',$user['store_id']];
        } elseif ($user['admin_type']==ADMIN_FACTORY) {
            $where[]=['p1.factory_id','=',$user['store_id']];
        }
        $data=db('work_order')
            ->alias('p1')
            ->fieldRaw('COUNT(*) worder_total, COUNT(p2.assess_id) worder_assess')
            ->join('work_order_assess p2','p1.worder_id = p2.worder_id AND p2.is_del = 0 AND p2.type = 1','LEFT')
            ->where($where)
            ->find();
        $perent = $data['worder_total'] > 0 ? round($data['worder_assess'] / $data['worder_total'],2) * 100 : 0;
        $chartData=[
            ['name'=>'已评价工单','value'=>$data['worder_assess']],
            ['name'=>'未评价工单','value'=>$data['worder_total']-$data['worder_assess']],
        ];
        if ($isRaw) {
            $result['assess']=$chartData;
        }else{
            $color=['#009688','#2db2ea'];
            $label='工单评价';
            $chart=new\app\common\service\Chart('pie',[''],$label,$chartData,$color,false);
            $result['assess']=$chart->getOption();

            //补充参数
            $result['assess']['title']=[
                'text'=>'已评价工单'.$perent.'%('.$data['worder_assess'].'/'.$data['worder_total'].')',
                'subtext'=>'',
                'left'=>'left',
            ];
            //说明
            $result['assess']['legend']=[
                'orient'=>'vertical',
                'left'=>'left',
                'padding'=>[50,0,0,0],
                'data'=>['已评价工单','未评价工单'],
            ];
            //中心圈
            //$result['assess']['series']['label']['emphasis'] = [
            //    'show'      => true,
            //    'textStyle' => [
            //        'fontSize'   => 30,
            //        'fontWeight' => 'bold',
            //    ],
            //];
        }
        $result['assess_score']=[];
        $workOrder=new WorkOrder;
        $ret=$workOrder->getServiceStaticsDuring($storeId,$user['factory_id'],$from,$to);
        if ($ret['code'] !== '0') {
            $ret['data']['score_overall']=0;
            $title=$workOrder->getAccessTitle($user['factory_id']);
            if ($title['code'] === '0') {
                $ret['data']['score_detail']=array_map(function ($item) {
                    return [
                        'name'  => $item,
                        'value' => 0,
                    ];
                },$title['data']);
                $ret['data']['score_detail'][]=['name'=>'解决率','value'=>0];
            }
        }

        if ($isRaw) {
            $result['assess_score']=$ret['data']?? [];
        }else{
            //评分统计
            $legend=[];//大标题
            $label='';
            $chartData=[];
            //大标题样式
            $chartData['radar']['name']['textStyle']=[
                'color'=>'#fff',
                'backgroundColor'=>'#999',
                'borderRadius'=>3,
                'padding'=> [3, 5],
            ];
            //小标题
            $chartData['radar']['indicator']=[];
            $arr=[];
            foreach ($ret['data']['score_detail'] as $value) {
                $val=round($value['value'],2);
                $arr[]=$val;
                $chartData['radar']['indicator'][]=[
                    'name'=>$value['name'],
                    'max'=>5
                ];
            }
            //雷达数据
            $chartData['series'] = [
                [
                    'name'  => '',
                    'value' => $arr,
                    'label'=>[
                        'normal'=>[
                            'show'=>true
                        ],
                    ],
                ],
            ];
            $chart2=new\app\common\service\Chart('radar',$legend,$label,$chartData,$color,false);
            $result['assess_score']=$chart2->getOption();
            //补充参数-大标题
            $result['assess_score']['title']=[
                'text'=>"综合评分".$ret['data']['score_overall'],
                'subtext'=>'',
                'left'=>'left',
            ];
        }
        if(IS_AJAX){
            return $this->ajaxJsonReturn($result);
        }else{
            return $result;
        }
    }
}