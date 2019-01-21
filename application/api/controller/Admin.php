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
    
    protected function getStoreList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $where = [
            'S.is_del' => 0,
            'S.status' => 1,
            'S.check_status'=> 1,
            'S.factory_id'  => $user['factory_id'],
        ];
        $field = 'S.store_id, S.store_no, S.store_no, S.name, S.store_type, S.region_name';
        if ($user['admin_type'] == ADMIN_FACTORY) {
            $storeType = isset($this->postParams['store_type']) ? intval($this->postParams['store_type']) : 0;
            if (!$storeType){
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户类型不能为空']);
            }
            $channelNo = isset($this->postParams['channel_no']) ? trim($this->postParams['channel_no']) : '';
            if ($channelNo){
                $channel = db('store')->where(['store_type' => STORE_CHANNEL, 'is_del' => 0, 'store_no' => $channelNo, 'factory_id' => $user['factory_id']])->find();
                if (!$channel) {
                    $this->_returnMsg(['errCode' => 1, 'errMsg' => '渠道商不存在或已删除']);
                }
            }
            $join = [];
            switch ($storeType){
                case STORE_CHANNEL:
                    $join[] = ['store_channel OS', 'S.store_id = OS.store_id', 'INNER'];
                    $join[] = ['store_finance SF', 'S.store_id = SF.store_id', 'INNER'];
                    $field .= ', total_amount';
                    break;
                case STORE_DEALER:
                    $field .= ', sample_amount';
                    $join[] = ['store_dealer OS', 'S.store_id = OS.store_id', 'INNER'];
                    break;
                case STORE_SERVICE:
                    $join[] = ['store_servicer OS', 'S.store_id = OS.store_id', 'INNER'];
                    $join[] = ['store_finance SF', 'S.store_id = SF.store_id', 'INNER'];
                    $field .= ', total_amount';
                    break;
                default:
                    $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户类型错误']);
                    break;
            }
            $where['S.factory_id'] = $user['factory_id'];
        }else{
            $storeType = STORE_DEALER;
            $where['OS.ostore_id'] = $user['store_id'];
            $join[] = ['store_dealer OS', 'S.store_id = OS.store_id', 'INNER'];
            $field .= ', sample_amount, address';
        }
        $order = 'S.sort_order ASC, S.add_time desc';
        $list = $this->_getModelList(db('store'), $where, $field, $order, 'S', $join);
        if ($list) {
            foreach ($list as $key => $value) {
                switch ($storeType) {
                    case STORE_DEALER:
                        //计算订单金额 订单数量
                        $order = db('order')->field('count(order_id) as num, sum(real_amount) as amount')->where(['user_store_id' => $value['store_id'], 'pay_status' => 1])->find();
                        $list[$key]['order_num'] = $order ? intval($order['num']) : 0;
                        if ($user['admin_type'] == ADMIN_CHANNEL) {
                            $list[$key]['address'] = $value['region_name'].' '.$value['address'];
                        }
                        break;
                    case STORE_CHANNEL:
                        //所属零售商数量
                        $where = [
                            'S.store_type'  => STORE_DEALER,
                            'S.is_del'      => 0,
                            'S.check_status'=> 1,
                            'SD.ostore_id'  => $value['store_id'],
                        ];
                        $join = [
                            ['store_dealer SD', 'S.store_id = SD.store_id', 'INNER'],
                        ];
                        $list[$key]['dealer_count'] = db('store')->alias('S')->join($join)->where($where)->count();
                        break;
                    case STORE_SERVICE:
                        //服务次数
                        $list[$key]['service_count'] = db('work_order')->where(['store_id' => $value['store_id'], 'sign_time' => ['>', 0]])->count();
                        break;
                    default:
                        ;
                        break;
                }
                $list[$key]['store_type_name'] = get_store_type($value['store_type']);
                unset($list[$key]['store_id'], $list[$key]['store_type']);
            }
        }
        $this->_returnMsg(['list' => $list]);
    }
    //获取商户详情
    protected function getStoreDetail()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $storeNo = isset($this->postParams['store_no']) ?trim($this->postParams['store_no']) : '';
        if (!$storeNo) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户编号不能为空']);
        }
        $where = [
            'is_del' => 0, 
            'store_no' => $storeNo,
            'factory_id' => $user['factory_id'],
        ];
        $field = 'store_id, store_type, store_no, name, user_name, mobile, security_money, region_name, idcard_font_img, idcard_back_img, signing_contract_img, license_img, group_photo, status';
        $info = db('store')->field($field)->where($where)->find();
        if (!$info) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户不存在或已删除']);
        }
        switch ($info['store_type']) {
            case STORE_CHANNEL:
                $model = 'channel';
                break;
            case STORE_DEALER:
                $model = 'dealer';
                break;
            case STORE_SERVICE:
                $model = 'servicer';
                break;
            default:
                return FALSE;
                break;
        }
        $finance = $account = [];
        $detail = model($model)->where(['store_id' => $info['store_id']])->find();
        if ($user['admin_type'] == ADMIN_CHANNEL && $user['store_id'] != $detail['ostore_id']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商户不存在或已删除']);
        }
        if ($detail) {
            $info = array_merge($info, $detail->toArray());
        }
        if ($info['store_type'] != STORE_DEALER) {
            $finance = db('store_finance')->field('amount, withdraw_amount, pending_amount, total_amount')->find($info['store_id']);
            $account = db('store_bank')->field('id_card, realname, bank_name, bank_branch, bank_no')->where(['store_id' => $info['store_id'], 'is_del' => 0])->find();
        }
        if ($info['store_type'] != STORE_SERVICE) {
            //计算订单金额 订单数量
            $order = db('order')->field('count(order_id) as num, sum(real_amount) as amount')->where(['user_store_id' => $info['store_id'], 'pay_status' => 1])->find();
            $info['order_num'] = $order ? intval($order['num']) : 0;
            $info['order_amount'] = $order ? floatval($order['amount']) : 0;
            //计算 退款订单数 退款订单金额
            $orderService = db('order_sku_service');
            $where = [
                'store_id' => $detail['store_id'],
                'service_status' => 3,
            ];
            $field = 'count(distinct(order_id)) count,sum(refund_amount) amount';
            $refund = $orderService->field($field)->where($where)->find();
            //累计退款订单数
            $info['refund_count'] = $refund ? intval($refund['count']) : 0;
            //累计退款金额
            $info['refund_amount'] = $refund? floatval($refund['amount']): 0;
        }else{
            //服务工单数
            $info['service_count'] = db('work_order')->where(['store_id' => $info['store_id'], 'sign_time' => ['>', 0]])->count();
        }
        $info['store_type_name'] = get_store_type($info['store_type']);
        unset($info['store_id'], $info['store_type']);
        $this->_returnMsg(['detail' => $info, 'finance' => $finance, 'account' => $account]);
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
                    $where['order_status'] = ['<>', 1];
                break;
                default:
                break;
            }
        }
        if ($user['admin_type'] == ADMIN_FACTORY) {
            $where['store_id'] = $user['store_id'];
            $flag = FALSE;
        }else{
            $where['user_id'] = $user['user_id'];
            $where['user_store_id'] = $user['store_id'];
            $where['user_store_type'] = $user['store_type'];
            $flag = TRUE;
        }
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
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $orderSn = isset($this->postParams['order_sn']) ? trim($this->postParams['order_sn']) : '';
        if (!$orderSn){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单编号不能为空']);
        }
        $orderModel = new \app\common\model\Order();
        $orderField = 'order_id, order_type, order_sn, real_amount, order_status, pay_status, delivery_status, finish_status';
        $orderField .= ', pay_code, store_id, pay_time, close_refund_status, add_time, remark';
        $skuField = 'sku_name, sku_thumb, sku_spec, num, price';
        $result = $orderModel->getOrderDetail($orderSn, $user, FALSE, FALSE, $orderField, $skuField);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $orderModel->error]);
        }
        $detail = $result['order'];
        unset($detail['order_id'], $detail['pay_time'],$detail['pay_type'], $detail['pay_code'], $detail['order_status'], $detail['pay_status'], $detail['delivery_status'], $detail['finish_status']);
        unset($detail['close_refund_status'], $detail['store_id'], $detail['order_type']);
        $this->_returnMsg(['detail' => $detail]);
    }
    
    //获取售后订单列表
    protected function getServiceOrderList()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $where = [
            'S.is_del' => 0,
        ];
        $serviceStatus = isset($this->postParams['status']) ? $this->postParams['status'] : '';
        if (''!==$serviceStatus && in_array($serviceStatus,[-2,-1,0,1,2,3])) {
            $where['S.service_status']=$serviceStatus;
        }

        if ($user['admin_type'] == ADMIN_FACTORY) {
            $where['S.store_id'] = $user['store_id'];
        }else{
            $where['S.user_store_id'] = $user['store_id'];
        }
        $field='S.service_sn,S.order_sn,S.service_status,S.refund_amount,S.update_time,S1.name store_name,S1.mobile';
        $join=[
            ['store S1', 'S1.store_id = S.user_store_id', 'LEFT'],
        ];
        $order='S.update_time DESC';
        $list = $this->_getModelList(db('order_sku_service'), $where, $field, $order,'S',$join);
        $this->_returnMsg(compact('list'));
        
    }
    //获取售后订单详情
    protected function getServiceOrderDetail()
    {
        $user = $this->_checkUser();
        if (!in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_FACTORY])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $serviceSn = isset($this->postParams['service_sn']) ? trim($this->postParams['service_sn']) : '';
        if (!$serviceSn){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后单号不能为空']);
        }
        $where = ['S.service_sn' => $serviceSn];
        if ($user && isset($user['store_id']) && $user['store_id'] > 0) {
            if ($user['admin_type'] == ADMIN_FACTORY) {
                $where['S.store_id'] = $user['store_id'];
            }elseif (in_array($user['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER])){
                $storeIds = [$user['store_id']];
                if ($user['admin_type'] == ADMIN_CHANNEL) {
                    //获取零售商的下级经销商
                    $ids = db('store')->alias('S')->join([['store_dealer SD', 'S.store_id = SD.store_id', 'INNER']])->where(['S.is_del' => 0, 'SD.ostore_id' => $user['store_id']])->column('S.store_id');
                    $storeIds = $ids ? array_merge($ids, $storeIds) : $storeIds;
                }
                $where['S.user_store_id'] = ['IN', $storeIds];
            }
        }
        $field='OS.sku_name,OS.sku_spec,OS.price,OS.install_price,S.order_sn,S.num,OS.sku_thumb,O.paid_amount,S.imgs,S.remark,S.add_time,S.refund_amount,S.service_status';
        $join=[
            ['order_sku_sub OSS', 'OSS.ossub_id = S.ossub_id', 'INNER'],
            ['order_sku OS', 'OS.osku_id = OSS.osku_id', 'INNER'],
            ['order O', 'O.order_id = OSS.order_id', 'INNER'],
        ];
        $service = db('order_sku_service')->alias('S')->join($join)->field($field)->where($where)/*->fetchSql(true)*/->find();
        if (!$service) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '售后服务单号不正确']);
        }




        pre($service);


        
    }
    //取消售后订单
    protected function cancelServiceOrder()
    {
        
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
        $assessList = $workOrderModel->getWorderAssess($info,'assess_id,msg,add_time,type');
        //pre($assessList);
        if (!empty($assessList)) {
            $assessList=array_map(function ($item) {
                unset($item['assess_id']);
                return $item;
            },$assessList);
            $info['assess_list']=$assessList;
        }
        unset($info['region_name'],$info['worder_id'],$info['goods_id'],$info['ossub_id']);
        $this->_returnMsg(['detail' => $info]);
    }
    //获取工程师列表
    protected function getInstallerList()
    {
        
    }
    //获取工程师详情
    protected function getInstallerDetail()
    {
        
    }
    //编辑工程师信息
    protected function editInstaller()
    {
        
    }
    //设置工程师状态
    protected function setInstallerStatus()
    {
        
    }
    //删除工程师
    protected function delInstaller()
    {
        
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
//         $userId =4;//渠道商
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