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
    //修改用户密码
    protected function updatePassword()
    {
        $user = $this->_checkUser();
        $password = isset($this->postParams['password']) && $this->postParams['password'] ? trim($this->postParams['password']) : '';
        $newPwd = isset($this->postParams['new_pwd']) && $this->postParams['new_pwd'] ? trim($this->postParams['new_pwd']) : '';
        $rePwd = isset($this->postParams['re_pwd']) && $this->postParams['re_pwd'] ? trim($this->postParams['re_pwd']) : '';
        if (!$password) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '原始密码不能为空']);
        }
        if (!$newPwd) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '新密码不能为空']);
        }
        if (!$rePwd) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '确认密码不能为空']);
        }
        if ($password == $newPwd) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '新密码不能与原密码一致']);
        }
        if ($newPwd != $rePwd) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '新密码与确认密码不一致']);
        }
        $userModel = new \app\common\model\User();
        $result = $userModel->checkFormat($user['factory_id'], ['password' => $newPwd]);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }
        $user = db('user')->find($user['user_id']);
        //判断原密码是否正确
        if ($user['password'] <> $userModel->pwdEncryption($password)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '原始密码错误']);
        }
        $data = ['password' => $userModel->pwdEncryption($newPwd)];
        $result = $userModel->save($data, ['user_id' => $user['user_id']]);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }else{
            $this->_returnMsg(['msg' => '修改密码成功']);
        }
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
    //获取公告列表
    protected function getBulletinList()
    {
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
    //获取未读公告数量
    protected function getUnreadBulletinCount(){
        $user = $this->_checkUser();
        $unReadCount = 0;
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_SERVICE])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $unread = isset($this->postParams['unread']) ? intval($this->postParams['unread']) : 0;
        $where = [
            'B.publish_status' => 1,
            'B.visible_range = 1 OR (visible_range = 0 AND find_in_set('.$user['store_id'].', B.to_store_ids))',
            'B.store_type IN(0, '.$user['store_type'].')',
            '(BR.bulletin_id IS NULL OR BR.is_read = 0)',
        ];
        if ($unread) {
            $where[] = '(BR.bulletin_id IS NULL OR BR.is_read = 0)';
        }
        $join = [
            ['bulletin_log BR', 'B.bulletin_id = BR.bulletin_id AND BR.user_id = '.$user['user_id'], 'LEFT']
        ];
        $field = 'B.bulletin_id, B.name, B.special_display, B.content, B.publish_time, B.is_top, IFNULL(BR.is_read, 0) as is_read';
        $order = 'is_top DESC, publish_time DESC';
        $unReadCount    = db('bulletin')->join($join)->field($field)->alias('B')->where($where)->count();
        $this->_returnMsg(['count' => $unReadCount]);
    }
    //获取商品列表
    protected function getGoodsList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $where = [
            'is_del' => 0,
            'status' => 1,
            'store_id' => $user['factory_id'],
        ];
        $order = 'sort_order ASC, add_time desc';
        $field = 'goods_id, goods_sn, thumb, (min_price + install_price) as min_price, (max_price + install_price) as max_price, goods_stock, sales';
        $list = $this->_getModelList(db('goods'), $where, $field, $order);
        $this->_returnMsg(['list' => $list]);
    }
    protected function getGoodsDetail()
    {
        $goodsId = isset($this->postParams['goods_id']) ? intval($this->postParams['goods_id']) : 0;
        if (!$goodsId){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品ID不能为空']);
        }
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $field = 'goods_id, goods_sn, thumb, imgs, (min_price + install_price) as min_price, (max_price + install_price) as max_price, goods_stock, sales, content';
        $where = [
            'goods_id'  => $goodsId,
            'is_del'    => 0,
            'status'    => 1,
            'store_id'  => $user['factory_id'],
        ];
        $detail = db('goods')->where($where)->field($field)->find();
        if (!$detail) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品不存在或已删除']);
        }
        $detail['imgs'] = $detail['imgs'] ? json_decode($detail['imgs'], 1) : [];
        $goodsModel = new \app\common\model\Goods();
        $skus = $goodsModel->getGoodsSkus($goodsId);
        $detail['sku_id'] = 0;
        $detail['skus'] = [];
        if ($skus) {
            if (is_array($skus)) {
                foreach ($skus as $key => $value) {
                    $skus[$key]['price'] = $value['price'] + $value['install_price'];
                    $skus[$key]['sku_thumb'] = $value['sku_thumb'] ? $value['sku_thumb'] : $detail['thumb'];
                    unset($skus[$key]['install_price']);
                }
                $detail['skus'] = $skus;
            }elseif (is_int($skus)){
                $detail['sku_id'] = $skus;
            }
        }
        $this->_returnMsg(['detail' => $detail]);
    }
    //获取商品规格列表
    protected function getGoodsSkus()
    {
        $goodsId = isset($this->postParams['goods_id']) ? intval($this->postParams['goods_id']) : 0;
        if (!$goodsId){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品ID不能为空']);
        }
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $field = 'goods_id, goods_sn, thumb, imgs, (min_price + install_price) as min_price, (max_price + install_price) as max_price, goods_stock, sales, content';
        $where = [
            'goods_id'  => $goodsId,
            'is_del'    => 0,
            'status'    => 1,
            'store_id'  => $user['factory_id'],
        ];
        $detail = db('goods')->where($where)->find();
        if (!$detail) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品不存在或已删除']);
        }
        $goodsModel = new \app\common\model\Goods();
        $skus = $goodsModel->getGoodsSkus($goodsId);
        if ($skus && is_array($skus)) {
            foreach ($skus as $key => $value) {
                $skus[$key]['price'] = $value['price'] + $value['install_price'];
                $skus[$key]['sku_thumb'] = $value['sku_thumb'] ? $value['sku_thumb'] : $detail['thumb'];
                unset($skus[$key]['install_price']);
            }
            $detail['skus'] = $skus;
            $this->_returnMsg(['skus' => $skus]);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品无对应规格信息']);
        }
    }
    //创建订单
    protected function createOrder()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $skuId = isset($this->postParams['sku_id']) ? intval($this->postParams['sku_id']) : 0;
        if (!$skuId){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品规格ID不能为空']);
        }
        $num = isset($this->postParams['num']) ? intval($this->postParams['num']) : 0;
        if ($num <= 0){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '购买商品数量必须大于0']);
        }
        $remark = isset($this->postParams['remark']) ? trim($this->postParams['remark']) : '';
        $orderModel = new \app\common\model\Order();
        $submit = isset($this->postParams['submit']) && $this->postParams['submit'] ? TRUE : FALSE;
        $result = $orderModel->createOrder($user, 'goods', $skuId, $num, $submit, [], $remark);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $orderModel->error]);
        }
        if ($submit) {
            $this->_returnMsg(['order_sn' => $result['order_sn']]);
        }else{
            $this->_returnMsg(['datas' => $result]);
        }
    }
    
    //获取订单列表
    protected function getOrderList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $status = isset($this->postParams['status']) ? intval($this->postParams['status']) : 0;
        $where = [
            'order_type' => 1,
        ];
        if ($status > 0) {
            switch ($status) {
                case 1://待支付
                    $where['order_status'] = 1;
                    $where['pay_status'] = 0;
                break;
                case 2://已完成
                    $where['finish_status'] = 2;
                    $where['order_status'] = 1;
                break;
                case 3://已关闭(取消或已关闭)
                    $map['order_status'] = ['<>', 1];
                break;
                default:
                break;
            }
        }
        if ($user['admin_type'] == ADMIN_FACTORY) {
            $where['store_id'] = $user['user_id'];
            $flag = FALSE;
        }else{
            $where['user_id'] = $user['user_id'];
            $where['user_store_id'] = $user['store_id'];
            $where['user_store_type'] = $user['store_type'];
            $flag = TRUE;
        }
        $field = '*';
        $order = 'add_time DESC';
        $field = 'order_id, store_id, order_type, order_sn, real_amount, pay_code, order_status, pay_status, delivery_status, finish_status, add_time, close_refund_status';
        $list = $this->_getModelList(db('order'), $where, $field, $order);
        if ($list) {
            $orderModel = new \app\common\model\Order();
            $list = $orderModel->getOrderList($list, $flag);
            if ($list) {
                foreach ($list as $key => $value) {
                    $list[$key]['pay_name'] = isset($value['pay_name']) ? $value['pay_name'] : '';
                    $list[$key]['skus'] = $skus = db('order_sku')->field('sku_name, sku_thumb, sku_spec, num, price ')->where(['order_id' => $value['order_id']])->select();
                    unset($list[$key]['order_id'], $list[$key]['pay_code'], $list[$key]['order_status'], $list[$key]['pay_status'], $list[$key]['delivery_status'], $list[$key]['finish_status']);
                    unset($list[$key]['close_refund_status'], $list[$key]['store_id'], $list[$key]['order_type']);
                }
            }
        }
        $this->_returnMsg(['list' => $list]);
    }
    //获取订单详情
    protected function getOrderDetail()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $orderSn = isset($this->postParams['order_sn']) ? trim($this->postParams['order_sn']) : '';
        if (!$orderSn){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单编号不能为空']);
        }
        $orderModel = new \app\common\model\Order();
        $field = 'order_id, order_type, order_sn, goods_amount, delivery_amount, install_amount, real_amount, paid_amount, order_status, pay_status, delivery_status, finish_status';
        $field .= 'add_time';
        $result = $orderModel->getOrderDetail($orderSn, $user, FALSE, FALSE, $field);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $orderModel->error]);
        }
        $detail = $result['order'];
        $this->_returnMsg(['detail' => $detail]);
    }
    
    //获取工单列表(厂商/渠道商/零售商/服务商)
    protected function getWorkOrderList()
    {
        $user = $this->_checkUser();
        $where = [
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
    protected function getWorkOrderDetail($return=false)
    {
        $user = $this->_checkUser();
        $worderSn = isset($this->postParams['worder_sn']) ? trim($this->postParams['worder_sn']) : '';
        if (empty($worderSn)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单号不能为空']);
        }
        $where = [
            'worder_sn' => $worderSn,
            'is_del' => 0,
            'status' => 1,
        ];
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
        $field='worder_id,goods_id,worder_sn,order_sn,ossub_id,work_order_type,work_order_status,user_name,phone,appointment,finish_time,region_name,address,fault_desc,images';
        $workOrderModel=new WorkOrder;
        $info = $workOrderModel->field($field)->where($where)->find();
        if (empty($info)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单信息不存在']);
        }
        $info['images']=explode(',',$info['images']);
        $regionName=str_replace(' ','',$info['region_name']);
        $info['address']=$regionName.$info['address'];

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

        //获取工单日志
        //$info['logs'] = db('work_order_log')->order('add_time DESC')->where(['worder_id' => $info['worder_id']])->select();
        //获取工单评价记录
        $info['assess_list']=[];
        $assessList = $workOrderModel->getWorderAssess($info);
        //pre($assessList);
        if (!empty($assessList)) {
            $info['assess_list']=[
                'msg'=>$assessList[0]['msg'],
                'detail'=>$assessList[0]['configs'],
                'add_time'=>$assessList[0]['add_time'],
            ];
        }
        unset($info['region_name'],$info['worder_id'],$info['goods_id'],$info['ossub_id']);
        $this->_returnMsg(['detail' => $info]);
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
        //$userId =4;//渠道商
        //$userId = 5;//零售商
        //$userId = 6;//服务商
        $this->loginUser = db('user')->alias('U')->join('store S', 'S.store_id = U.store_id', 'INNER')->field('user_id, U.factory_id, U.store_id, store_type, admin_type, is_admin, username, realname, nickname, phone, U.status')->find($userId);
        return $this->loginUser ? $this->loginUser : [];
        
        $userModel = new \app\common\model\User();
        $this->loginUser = session('api_admin_user');
        if (!$this->loginUser) {
            $this->_returnMsg(['errCode' => -1, 'errMsg' => '请登录后操作']);
        }
        if (!$this->loginUser['admin_type']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '登录用户信息错误']);
        }
        return $this->loginUser;
    }
}