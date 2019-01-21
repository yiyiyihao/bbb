<?php
namespace app\api\controller;

use app\common\model\WorkOrder;

class Admin extends Index
{
    private $loginUser;
    private $visitIp;
    public function __construct(){
        $origin = isset($_SERVER['HTTP_ORIGIN']) ? $_SERVER['HTTP_ORIGIN'] : '*';
        header('Access-Control-Allow-Origin:'.$origin);
        header('Access-Control-Allow-Methods:POST');
        header('Access-Control-Allow-Headers:x-requested-with,content-type');
        header('Access-Control-Allow-Credentials:true');
        parent::__construct();
    }
    //登录
    protected function login()
    {
        $user = $this->_checkUser();
        if ($user) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '您已经登录']);
        }
        $username = isset($this->postParams['username']) ? trim($this->postParams['username']) : '';
        $password = isset($this->postParams['password']) ? trim($this->postParams['password']) : '';
        if (!$username) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户名不能为空']);
        }
        if (!$password) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '密码不能为空']);
        }
        $userModel = new \app\common\model\User();
        //检查登录用户名/密码格式
        $extra = [
            'username' => $username,
            'password' => $password,
        ];
        $result = $userModel->checkFormat($this->factory['store_id'], $extra, FALSE);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }
        //判断登录用户名是否存在
        $where = [
            'factory_id'=> $this->factory['store_id'],
            'is_del'    => 0,
            'username'  => $username,
            'group_id'  => ['>', 0],
            'admin_type'=> ['IN', [ADMIN_FACTORY, ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_SERVICE]],
            'is_admin'  => ['>', 0],
        ];
        $user = $userModel->where($where)->find();
        if (!$user) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('USERNOTEXIST')]);
        }
        if ($userModel->pwdEncryption($password) != $user['password']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('PSW_ERROR')]);
        }
        //执行登录操作
        if(!$user['status']){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('LOGIN_FORBIDDEN')]);
        }
        $result = $userModel->setLogin($user, $user['user_id'], 'api_admin');
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }
        $user = [
            'admin_type'=> $user['admin_type'],
            'username'  => $user['username'],
            'realname'  => $user['realname'],
            'nickname'  => $user['nickname'],
            'phone'     => $user['phone'],
            'status'    => $user['status'],
        ];
        $this->_returnMsg(['msg' => '登录成功', 'user' => $user]);
    }
    //获取首页信息
    protected function getHomeDetail()
    {
        $user = $this->_checkUser();
        $indexController = new \app\common\controller\Index();
        $result = $indexController->getStoreHome($user);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $indexController->error]);
        }
        $this->_returnMsg(['detail' => $result]);
    }
    //获取用户公告列表(全部/未读)
    protected function getBulletinList()
    {
        $user = $this->_checkUser();
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $unread = isset($this->postParams['unread']) ? intval($this->postParams['unread']) : 0;
        $where = [
            'B.publish_status' => 1,
            'B.visible_range = 1 OR (visible_range = 0 AND find_in_set('.$user['store_id'].', B.to_store_ids))',
            'B.store_type IN(0, '.$user['store_type'].')',
        ];
        if ($unread) {
            $where[] = '(BR.bulletin_id IS NULL OR BR.is_read = 0)';
        }
        $join = [
            ['bulletin_log BR', 'B.bulletin_id = BR.bulletin_id AND BR.user_id = '.$user['user_id'], 'LEFT']
        ];
        $field = 'B.bulletin_id, B.name, B.special_display, B.content, B.publish_time, B.is_top, IFNULL(BR.is_read, 0) as is_read';
        $order = 'is_top DESC, publish_time DESC';
        $list = $this->_getModelList(db('bulletin'), $where, $field, $order, 'B', $join);
        $this->_returnMsg(['list' => $list]);
    }
    //获取公告详情
    protected function getBulletinDetail($return = FALSE)
    {
        $bulletinId = isset($this->postParams['bulletin_id']) ? intval($this->postParams['bulletin_id']) : 0;
        if (!$bulletinId){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '公告ID不能为空']);
        }
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $join = [
            ['bulletin_log BR', 'B.bulletin_id = BR.bulletin_id AND BR.user_id = '.$user['user_id'], 'LEFT']
        ];
        $field = 'B.bulletin_id, B.name, B.special_display, B.content, B.publish_time, B.is_top, IFNULL(BR.is_read, 0) as is_read, IFNULL(BR.is_del, 0) as is_del';
        $where = [
            'B.publish_status' => 1,
            'B.visible_range = 1 OR (visible_range = 0 AND find_in_set('.$user['store_id'].', B.to_store_ids))',
            'B.store_type IN(0, '.$user['store_type'].')',
            'B.bulletin_id' => $bulletinId,
            '(BR.bulletin_id IS NULL OR BR.is_del = 0)',
        ];
        $detail = db('bulletin')->alias('B')->join($join)->where($where)->field($field)->find();
        if (!$detail || $detail['is_del']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '公告不存在或已删除']);
        }
        if ($return) {
            return $detail;
        }
        if (!$detail['is_read']) {
            $detail = $this->setBulletinRead($detail);
        }
        $this->_returnMsg(['detail' => $detail]);
    }
    //设置公告已读
    protected function setBulletinRead($detail = [])
    {
        $user = $this->_checkUser();
        $detail = $this->getBulletinDetail(TRUE);
        if (!$detail || $detail['is_del']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '公告不存在或已删除']);
        }
        if ($detail['is_read'] > 0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '公告已读,不允许重复操作']);
        }
        $logModel = new \app\common\model\BulletinLog();
        $result = $logModel->read($detail, $user);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $logModel->error]);
        }
        if ($detail) {
            $detail['is_read'] = 1;
            return $detail;
        }
        $this->_returnMsg(['msg' => '已读操作成功']);
    }
    //获取工单列表(厂商/渠道商/零售商/服务商)
    protected function getWorkOrderList()
    {
        $user = $this->_checkUser();
        $where=[
            'is_del' => 0,
            'status' => 1,
        ];
        $workOrderType = isset($this->postParams['type']) ? intval($this->postParams['type']) : '';
        $workOrderStatus = isset($this->postParams['status']) ? intval($this->postParams['status']) : '';
        if (''!==$workOrderType && in_array($workOrderType,[1,2])) {
            $where['work_order_type']=$workOrderType;
        }
        if ( ''!==$workOrderStatus &&in_array($workOrderStatus, [-1,0,1,2,3,4])) {
            $where['work_order_status']=$workOrderStatus;
        }
        switch ($user['admin_type']) {
            case ADMIN_FACTORY://厂商
                $where['factory_id']=$user['store_id'];
                break;
            case ADMIN_SERVICE://服务商
                $where['store_id'] = $user['store_id'];
                break;
            case ADMIN_CHANNEL://渠道商
                $where['post_store_id'] = $user['store_id'];
                break;
            case ADMIN_DEALER://零售商
                $where['post_store_id'] = $user['store_id'];
                break;
            default:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
                break;
        }
        $order = 'worder_id desc';
        $field = 'worder_sn, order_sn, work_order_type, work_order_status, region_name, address, phone, user_name';
        $list = $this->_getModelList(db('work_order'), $where, $field, $order);
        
        $this->_returnMsg(['list' => $list]);
    }
    //获取工单详情
    protected function getWorkOrderDetails()
    {
        $worderSn = isset($this->postParams['worder_sn']) ? trim($this->postParams['worder_sn']) : '';
        if (empty($worderSn)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => lang('PARAM_ERROR')]);
        }
        $where = [
            'worder_sn' => $worderSn,
            'is_del' => 0,
        ];
        $field='worder_id,worder_sn,order_sn,ossub_id,work_order_type,work_order_status,user_name,phone,appointment,finish_time,region_name,address,fault_desc,images';
        $workOrderModel=new WorkOrder;
        $info = $workOrderModel->field($field)->where($where)->find();
        if (empty($info)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单信息不存在']);
        }
        $info['images']=explode(',',$info['images']);
        $region_name=str_replace(' ','',$info['region_name']);
        $info['address']=$region_name.$info['address'];

        if ($info['ossub_id']) {
            $join = [
                ['order_sku OS', 'OS.osku_id = OSS.osku_id', 'INNER'],
            ];
            $field =  'OS.sku_name, OS.sku_spec';
            $where = [
                'ossub_id' => $info['ossub_id'],
            ];
            $ossub = db('order_sku_sub')->field($field)->alias('OSS')->join($join)->where($where)->find();
            $info['goods_name']=$ossub['sku_name']?$ossub['sku_name']:$ossub['sku_spec'];
        }else{
            $infoSub = db('goods')->find($info['goods_id']);
            $info['goods_name']=$infoSub['name'];
        }
        unset($info['region_name']);
        //获取工单日志
        //$info['logs'] = db('work_order_log')->order('add_time DESC')->where(['worder_id' => $info['worder_id']])->select();
        //获取工单评价记录
        $info['assess_list']=[];
        $assess_list = $workOrderModel->getWorderAssess($info);
        if (!empty($assess_list)) {
            $info['assess_list']=[
                'msg'=>$assess_list[0]['msg'],
                'detail'=>$assess_list[0]['configs'],
            ];
        }
        $this->_returnMsg(['details' => $info]);
        //pre($info);
    }
    
    
    
    
    
    protected function _checkPostParams()
    {
        if (!isset($_SERVER['HTTP_ORIGIN'])) {
            return parent::_checkPostParams();
        }

        $this->requestTime = time();
        $this->visitMicroTime = $this->_getMillisecond();//会员访问时间(精确到毫秒)
        $this->postParams = $this->request->param();
        if (!$this->postParams) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请求参数异常']);
        }
        unset($this->postParams['callback']);
        unset($this->postParams['_']);
    }
    private function _checkUser($openid = '')
    {
        $userId = 2;//厂商
        $userId =4;//渠道商
//         $userId = 5;//零售商
//         $userId = 6;//服务商
        $this->loginUser = db('user')->alias('U')->join('store S', 'S.store_id = U.store_id', 'INNER')->field('user_id, U.factory_id, U.store_id, store_type, admin_type, is_admin, username, realname, nickname, phone, U.status')->find($userId);
        return $this->loginUser ? $this->loginUser : [];
        
        $userModel = new \app\common\model\User();
        $this->loginUser = session('api_admin_user');
        if (!$this->loginUser) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请登录后操作']);
        }
        if (!$this->loginUser['admin_type']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '登录用户信息错误']);
        }
        return $this->loginUser;
    }
}