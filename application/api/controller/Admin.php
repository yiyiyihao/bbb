<?php
namespace app\api\controller;

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
            'factory_id'=> $user['factory_id'],
            'store_id'  => $user['store_id'],
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
        switch ($user['admin_type']) {
            case ADMIN_FACTORY:
                //厂商首页显示数据
                //1.今日支付订单数量
                break;
            case ADMIN_FACTORY:
                //厂商首页显示数据
                //1.今日支付订单数量
                break;
            default:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
                break;
                
        }
        $this->_returnMsg(['detail' => $detail]);
    }
    //获取工单列表(厂商/渠道商/零售商/服务商)
    protected function getWorkOrderList()
    {
        $user = $this->_checkUser();
        $where=[
            'WO.is_del'=>0,
            'WO.status'=>1,
            'U.is_del'=>0,
            'U.status'=>1,
        ];
        $workOrderType = isset($this->postParams['work_order_type']) ? intval($this->postParams['work_order_type']) : '';
        $workOrderStatus = isset($this->postParams['work_order_status']) ? intval($this->postParams['work_order_status']) : '';
        $page = isset($this->postParams['page']) && $this->postParams['page'] ? intval($this->postParams['page']) : 1;
        $page_size = isset($this->postParams['page_size']) && $this->postParams['page_size'] ? intval($this->postParams['page_size']) : 10;
        if (''!==$workOrderType && in_array($workOrderType,[1,2])) {
            $where['WO.work_order_type']=$workOrderType;
        }
        if ( ''!==$workOrderStatus &&in_array($workOrderStatus, [-1,0,1,2,3,4])) {
            $where['WO.work_order_status']=$workOrderStatus;
        }
        switch ($user['admin_type']) {
            case ADMIN_FACTORY://厂商
                $where['WO.factory_id']=$user['store_id'];
                break;
            case ADMIN_SERVICE://服务商
                $where['WO.store_id'] = $user['store_id'];
                break;
            case ADMIN_CHANNEL://渠道商
                $where['WO.post_store_id'] = $user['store_id'];
                break;
            case ADMIN_DEALER://零售商
                $where['WO.post_store_id'] = $user['store_id'];
                break;
            default:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
                break;
        }
        $field='WO.order_sn,WO.work_order_type,WO.work_order_status,WO.worder_sn,WO.region_name,WO.address,WO.phone,WO.user_name';
        $list=db('work_order')->alias('WO')
            ->field($field)
            ->join('user U','WO.post_user_id = U.user_id')
            ->where($where)
            ->page($page)
            ->limit($page_size)
            ->order('WO.worder_id desc')
            ->select();
        //pre($list);
        $this->_returnMsg(['msg' => 'ok', 'list' => $list]);
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
//         $userId = 3;//渠道商
//         $userId = 4;//零售商
//         $userId = 5;//服务商
        $this->loginUser = db('user')->field('user_id, factory_id, store_id, admin_type, is_admin, username, realname, nickname, phone, status')->find($userId);
        return $this->loginUser ? $this->loginUser : [];
        
        $userModel = new \app\common\model\User();
        $this->loginUser = session('api_admin_user');
        if (!$this->loginUser) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请登录后操作']);
        }
        return $this->loginUser;
    }
}