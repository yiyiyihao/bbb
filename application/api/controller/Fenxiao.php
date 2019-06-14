<?php
namespace app\api\controller;
use think\Db;
class Fenxiao extends Admin
{
    private $factoryId;
    private $promotType = 'fenxiao';
    private $shareType = 2;//分享
    private $visitType = 1;//访问
    public function __construct(){
        $origin = isset($_SERVER['HTTP_ORIGIN']) ? $_SERVER['HTTP_ORIGIN'] : '*';
        header('Access-Control-Allow-Origin:'.$origin);
        header('Access-Control-Allow-Methods:POST');
        header('Access-Control-Allow-Headers:x-requested-with,content-type');
        header('Access-Control-Allow-Credentials:true');
        $this->mchKey = '1458745225';
        parent::__construct();
        $this->factoryId = $this->factory['store_id'];
    }
    protected function logout(){
        session('api_wechat_oauth', []);
        session('api_fenxiao_login', []);
        $this->_returnMsg(['msg' => 'ok']);
    }
    protected function getRegions($field = "region_id, region_name, parent_id")
    {
        $this->returnLogin = FALSE;
        $getall = isset($this->postParams['getall']) ? intval($this->postParams['getall']) : 0;
        if (!$getall) {
            return parent::getRegions($field);
        }else{
            $where = [
                ['is_del', '=', 0],
                ['status', '=', 1],
                ['region_id', '>', 1],
            ];
            $regions = model('region')->where($where)->order('region_id ASC')->cache('region_all', 60*60*24)->column($field);
            if ($regions) {
                $lists = $this->_region($regions);
            }else{
                $lists = [];
            }
            $this->_returnMsg(['list' => $lists]);
        }
    }
    /**
     * 获取首页分销列表
     */
    protected function getHomeList()
    {
        $promotionModel = new \app\common\model\Promotion();
        $where = [
            ['store_id', '=', $this->factoryId],
            ['is_del', '=', 0],
            ['status', '=', 1],
            ['start_time', '<=', time()],
            ['end_time', '>', time()],
            #TODO DELETE
            ['promot_id', '<>', 1],
        ];
        $order = 'add_time DESC';
        $field = 'promot_id, promot_type, name, cover_img, start_time, end_time, status';
        $result = $this->_getModelList($promotionModel, $where, $field, $order);
        if ($result && isset($result)) {
            foreach ($result as $key => $value) {
                $result[$key]['_status'] = get_promotion_status($value);
                $result[$key]['start_time_text'] = $value['start_time'] ? date('Y-m-d', $value['start_time']) : '';
                $result[$key]['start_time'] = $value['start_time'] ? date('Y-m-d H:i:s', $value['start_time']) : '';
                $result[$key]['end_time'] = $value['end_time'] ? date('Y-m-d H:i:s', $value['end_time']) : '';
                unset($result[$key]['status']);
            }
        }
        $this->_returnMsg(['list' => $result]);
    }
    /**
     * 获取商品详情
     */
    protected function getGoodsDetail()
    {
        $user = $this->_checkUser();
        $goodsId = isset($this->postParams['goods_id']) ? intval($this->postParams['goods_id']) : 0;
        if (!$goodsId){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品ID不能为空']);
        }
        $info = $this->_verifyPromot(false, false, TRUE, FALSE);
        $field = 'goods_id, goods_sn, thumb, name, specs_json, min_price, content';
        $where = [
            ['is_del', '=', 0],
            ['status', '=', 1],
            ['goods_id', '=', $goodsId],
            ['store_id', '=', $this->factoryId],
        ];
        $detail = model('goods')->where($where)->field($field)->find();
        if (!$detail) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品不存在或已删除']);
        }
        $detail['specs_json'] = $detail['specs_json'] ? json_decode($detail['specs_json'], 1) : [];
        
        $where = [
            ['is_del', '=', 0],
            ['status', '=', 1],
            ['promot_id', '=', $info['promot_id']],
            ['goods_id', '=', $goodsId],
            ['sku_id', '=', 0],
        ];
        $promotSku = model('PromotionSku')->field('*')->where($where)->order('sort_order ASC')->find();
        if (!$promotSku) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品不存在或已删除']);
        }
        $detail['min_price'] = $promotSku['promot_price'];
        $detail['unlink_price'] = $promotSku['unlink_price'];
        $goodsModel = new \app\common\model\Goods();
        $skus = $goodsModel->getGoodsSkus($goodsId);
        $detail['sku_id'] = 0;
        $detail['skus'] = [];
        if ($skus) {
            if (is_array($skus)) {
                foreach ($skus as $key => $value) {
                     $skus[$key]['price_total'] = $skus[$key]['price'] = $promotSku['promot_price'];
                    $skus[$key]['sku_thumb'] = $value['sku_thumb'] ? $value['sku_thumb'] : $detail['thumb'];
                    unset($skus[$key]['install_price']);
                }
                $detail['skus'] = $skus;
            }elseif (is_int($skus)){
                $detail['sku_id'] = $skus;
            }
        }
        $detail['promot_status'] = get_promotion_status($info);
        $this->_returnMsg(['detail' => $detail]);
    }
    /**
     * 最新活动列表
     */
    protected function getPromotList()
    {
        $loginUser = $this->_checkUser();
        $this->_checkDistributor();
        $where = [
            ['P.store_id', '=', $this->factoryId],
            ['P.is_del', '=', 0],
            #TODO DELETE
            ['P.promot_id', '<>', 1],
        ];
        $alias = 'P';
        $join = [
            ['promotion_join PJ', 'PJ.promot_id = P.promot_id AND PJ.is_del=0 AND distrt_id = '.$loginUser['distributor']['distrt_id'], 'LEFT'],
        ];
        $order = 'P.add_time DESC';
        
        $field = 'P.promot_id, P.name, P.cover_img, P.start_time, P.end_time, P.add_time, P.status, PJ.join_id';
        $result = $this->_getModelList(model('Promotion'), $where, $field, $order, $alias, $join);
        if ($result) {
            foreach ($result as $key => $value) {
                $result[$key]['_status'] = get_promotion_status($value);
                $result[$key]['start_time'] = $value['start_time'] ? date('Y-m-d H:i:s', $value['start_time']) : '';
                $result[$key]['end_time'] = $value['end_time'] ? date('Y-m-d H:i:s', $value['end_time']) : '';
                $result[$key]['has_join'] = $value['join_id'] ? 1: 0;
                $result[$key]['join_id'] = intval($value['join_id']);
                unset($result[$key]['status']);
            }
        }
        $this->_returnMsg(['list' => $result]);
    }
    /**
     * 加入推广活动/我要推广
     */
    protected function promotJoin()
    {
        $loginUser = $this->_checkUser();
        $this->_checkDistributor();
        $promot = $this->_verifyPromot(false, false, TRUE, TRUE);
        //判断当前用户是否已领取当前活动
        $where = [
            ['is_del', '=', 0],
            ['store_id', '=', $this->factoryId],
            ['promot_id', '=', $promot['promot_id']],
            ['udata_id', '=', $loginUser['udata_id']],
            ['distrt_id', '=', $loginUser['distributor']['distrt_id']]
        ];
        $promotionJoinModel = model('PromotionJoin');
        $exist = $promotionJoinModel->where($where)->find();
        if ($exist) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '您已参与当前活动']);
        }
        $data = [
            'store_id'  => $this->factoryId,
            'promot_id' => $promot['promot_id'],
            'promot_type' => $promot['promot_type'],
            'udata_id'  => $loginUser['udata_id'],
            'user_id'   => $loginUser['user_id'],
            'distrt_id' => $loginUser['distributor']['distrt_id'],
        ];
        $result = $promotionJoinModel->isUpdate(FALSE)->save($data);
        $this->_returnMsg(['join_id' => $promotionJoinModel->join_id]);
    }
    /**
     * 获取我的推广分享数据(分享微信jssdk)
     */
    protected function getPromotShare()
    {
        $user = $this->_checkUser();
        $this->_checkDistributor();
        $joinId = isset($this->postParams['join_id']) ? intval($this->postParams['join_id']) : 0;
        if (!$joinId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'join_id不能为空']);
        }
        $url = isset($this->postParams['share_url']) ? $this->postParams['share_url'] : '';
        if (!$url) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'share_url不能为空']);
        }
        $where = [
            ['PJ.join_id', '=', $joinId],
            ['PJ.is_del', '=', 0],
            ['PJ.store_id', '=', $this->factoryId],
            ['P.is_del', '=', 0],
            ['P.status', '=', 1],
        ];
        $join = [
            ['promotion P', 'P.promot_id = PJ.promot_id', 'INNER'],
        ];
        $promotionJoinModel = model('PromotionJoin');
        $join = $promotionJoinModel->alias('PJ')->join($join)->where($where)->find();
        if (!$join){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '对应活动不存在']);
        }
        $wechatApi = new \app\common\api\WechatApi(0, $this->thirdType);
        $appid = $wechatApi ? $wechatApi->config['appid'] : '';
        if (!$appid) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '微信配置错误']);
        }
        $jsapiTicket = $wechatApi->getWechatJsApiTicket();
        if ($jsapiTicket === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $wechatApi->error]);
        }
        $url = urldecode($url);
        $timestamp = time();
        $nonceStr = get_nonce_str(16, 1);
        // 这里参数的顺序要按照 key 值 ASCII 码升序排序
        $rawString = "jsapi_ticket=$jsapiTicket&noncestr=$nonceStr&timestamp=$timestamp&url=$url";
        $urlArray = explode('#', $url);
        $string = "jsapi_ticket=$jsapiTicket&noncestr=$nonceStr&timestamp=$timestamp&url=".$urlArray[0];
        $signature = sha1($string);
        $config = isset($join['config']) ? json_decode($join['config'], 1) : [];
        $detail = [
            "title"     => $config && isset($config['share']['title']) ? $config['share']['title'] :$join['name'],
            "description"=> $config && isset($config['share']['description']) ? $config['share']['description']:$join['name'],
            "img_url"   => $config && isset($config['share']['img_url']) ? $config['share']['img_url']:$join['cover_img']
        ];
        $detail['sign_package'] = array(
            "appId"     => $appid,
            "nonceStr"  => $nonceStr,
            "timestamp" => $timestamp,
            "url"       => $url,
            "signature" => $signature,
            "rawString" => $rawString
        );
        $this->_returnMsg(['detail' => $detail]);
    }
    /**
     * 获取页面分享微信jssdk数据
     */
    protected function getWechatJssdk()
    {
        $url = isset($this->postParams['share_url']) ? $this->postParams['share_url'] : '';
        if (!$url) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'share_url不能为空']);
        }
        $shareType = isset($this->postParams['share_type']) ? trim($this->postParams['share_type']) : '';
        $wechatApi = new \app\common\api\WechatApi(0, $this->thirdType);
        $appid = $wechatApi ? $wechatApi->config['appid'] : '';
        if (!$appid) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '微信配置错误']);
        }
        $jsapiTicket = $wechatApi->getWechatJsApiTicket();
        if ($jsapiTicket === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $wechatApi->error]);
        }
        $url = urldecode($url);
        $timestamp = time();
        $nonceStr = get_nonce_str(16, 1);
        // 这里参数的顺序要按照 key 值 ASCII 码升序排序
        $rawString = "jsapi_ticket=$jsapiTicket&noncestr=$nonceStr&timestamp=$timestamp&url=$url";
        $urlArray = explode('#', $url);
        $string = "jsapi_ticket=$jsapiTicket&noncestr=$nonceStr&timestamp=$timestamp&url=".$urlArray[0];
        $signature = sha1($string);
        $sign = array(
            "appId"     => $appid,
            "nonceStr"  => $nonceStr,
            "timestamp" => $timestamp,
            "url"       => $url,
            "signature" => $signature,
            "rawString" => $rawString
        );
        if ($shareType) {
            $config = get_store_config($this->factoryId, TRUE, 'invite_share');
            $distributorPromot = isset($config[$shareType]) ? $config[$shareType] : [];
            $detail = [
                "title"     => $distributorPromot && isset($distributorPromot['title']) ? $distributorPromot['title'] : '',
                "description"=> $distributorPromot&& isset($distributorPromot['description']) ? $distributorPromot['description'] :'',
                "img_url"   => $distributorPromot&& isset($distributorPromot['img_url']) ? $distributorPromot['img_url'] :'',
            ];
        }else{
            $detail = [];
        }
        $this->_returnMsg(['sign_package' => $sign, 'detail' => $detail]);
    }
    /**
     * 我的推广活动
     */
    protected function getMyJoins()
    {
        $loginUser = $this->_checkUser();
        $this->_checkDistributor();
        $where = [
            ['PJ.store_id', '=', $this->factoryId],
            ['PJ.distrt_id', '=' ,$loginUser['distributor']['distrt_id']],
            ['PJ.is_del',   '=', 0],
            ['P.is_del',   '=', 0],
        ];
        $alias = 'PJ';
        $join = [
            ['promotion P', 'P.promot_id = PJ.promot_id', 'INNER'],
        ];
        $order = 'PJ.add_time ASC';
        $field = 'PJ.promot_id, PJ.join_id,P.name, P.cover_img, P.start_time, P.end_time, P.status, PJ.share_count, PJ.click_count,  PJ.order_pay_count as order_count, PJ.add_time as join_time';
        $result = $this->_getModelList(model('PromotionJoin'), $where, $field, $order, $alias, $join);
        if ($result) {
            foreach ($result as $key => $value) {
                $result[$key]['_status'] = get_promotion_status($value);
                $result[$key]['start_time'] = $value['start_time'] ? date('Y-m-d H:i:s', $value['start_time']) : '';
                $result[$key]['end_time'] = $value['end_time'] ? date('Y-m-d H:i:s', $value['end_time']) : '';
                $result[$key]['join_time'] = $value['join_time'] ? date('Y-m-d H:i:s', $value['join_time']) : '';
                unset($result[$key]['status']);
            }
        }
        $this->_returnMsg(['list' => $result]);
    }
    /**
     * 关闭分享页面/去往其它页面
     */
    protected function closeSharePage()
    {
        $loginUser = $this->_checkUser();
        $joinId = isset($this->postParams['join_id']) ? intval($this->postParams['join_id']) : 0;
        if (!$joinId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'join_id不能为空']);
        }
        $visitModel = model('PromotionJoinVisit');
        $where = [
            ['udata_id','=', $loginUser['udata_id']],
            ['join_id', '=', $joinId],
            ['leave_time', '=', 0],
            ['type', '=', $this->visitType],
        ];
        $exist = $visitModel->where($where)->order('add_time DESC')->find();
        if ($exist) {
            $stayLength = (time() - strtotime($exist['add_time']));
            $data = [
                'leave_time'  => time(),
                'stay_length' => $stayLength,
            ];
            $result = $visitModel->save($data, ['visit_id' => $exist['visit_id']]);
            if ($result === FALSE) {
                $this->_returnMsg(['errCode' => -1, 'errMsg' => 'system_error']);
            }
        }
        $this->_returnMsg(['errMsg' => 'ok']);
    }
    /**
     * 我的访客列表
     */
    protected function getPromotVisits()
    {
        $loginUser = $this->_checkUser();
        $this->_checkDistributor();
        
        $where = [
            ['P.store_id', '=', $this->factoryId],
            ['P.is_del', '=', 0],
            ['PJV.distrt_id', '=' ,$loginUser['distributor']['distrt_id']],
            ['PJV.udata_id', '<>' ,$loginUser['udata_id']],
            ['PJV.type', '=', $this->visitType],
        ];
        $alias = 'PJV';
        $join = [
            ['promotion P', 'P.promot_id = PJV.promot_id', 'LEFT'],
            ['user_data UD', 'PJV.udata_id = UD.udata_id', 'LEFT'],
        ];
        $order = 'PJV.add_time DESC';
        $field = 'PJV.visit_id, UD.nickname, UD.avatar, P.promot_id, P.name, P.cover_img, PJV.visit_num, PJV.add_time as visit_time, PJV.stay_length';
        $field .= ',PJV.order_sn, PJV.order_status, PJV.share_id';
        $result = $this->_getModelList(model('PromotionJoinVisit'), $where, $field, $order, $alias, $join);
        if ($result) {
            foreach ($result as $key => $value) {
                $result[$key]['stay_length'] = $value['stay_length'].' S';
                $action = '访问';
                if ($value['share_id'] > 0) {
                    $action.= '-分享';
                }
                if ($value['order_sn']) {
                    $action.= '-下单';
                    if ($value['order_status'] == 2) {
                        $action.= '-支付';
                    }
                }
                $result[$key]['action_text'] = $action;
                unset($result[$key]['order_sn'], $result[$key]['order_status']);
            }
        }
        $this->_returnMsg(['list' => $result]);
    }
    /**
     * 获取分销订单列表
     */
    protected function getOrderList()
    {
        $loginUser = $this->_checkUser();
        $this->_checkDistributor();
        $level = isset($this->postParams['level']) ? intval($this->postParams['level']) : 0;
        $where = [
            ['UDC.user_id', '=', $loginUser['user_id']],
        ];
        if ($level > 0) {
            switch ($level) {
                case 1://销售佣金
                    $where[] = ['comm_type', '=', 1];
                break;
                case 2://管理佣金
                    $where[] = ['comm_type', '=', 2];
                break;
                default:
                    $this->_returnMsg(['errCode' => 1, 'errMsg' => 'level错误']);
                break;
            }
        }
        $order = 'UDC.add_time DESC';
        $field = 'UD.nickname, UD.avatar';
        $field .= ', O.order_sn, real_amount';
        $field .= ', O.order_type, O.pay_type, O.order_sn, O.real_amount, O.order_status, O.pay_status, O.delivery_status, O.finish_status';
        $field .= ', sku_name, sku_thumb, sku_spec, num, real_price';
        $field .= ', UDC.value as commission_amount, UDC.commission_status, O.add_time';
        $alias = 'UDC';
        $join = [
            ['order O', 'O.order_sn = UDC.order_sn', 'INNER'],
            ['order_sku OS', 'O.order_id = OS.order_id', 'INNER'],
            ['user_data UD', 'UD.udata_id = UDC.post_udata_id', 'INNER'],
        ];
        $result = $this->_getModelList(model('user_distributor_commission'), $where, $field, $order, $alias, $join);
        if ($result && isset($result)) {
            foreach ($result as $key => $value) {
                if ($value['commission_status'] !== 0) {
                    $text = get_commission_status($value['commission_status']);
                }else{
                    $text = get_order_status($value)['status_text'];
                }
                $result[$key]['_status'] = [
                    'commission_status' => $value['commission_status'],
                    'status_text' => $text,
                ];
                unset($result[$key]['commission_status'], $result[$key]['order_type'], $result[$key]['pay_type'], $result[$key]['commission_status']);
            }
        }
        $this->_returnMsg(['list' => $result]);
    }
    /**
     * 访客详情(获取当前用户访问当前分销员所有活动的记录)
     */
    protected function getPromotVisitList()
    {
        $loginUser = $this->_checkUser();
        $this->_checkDistributor();
        $visitId = isset($this->postParams['visit_id']) ? intval($this->postParams['visit_id']) : 0;
        if (!$visitId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'visit_id 不能为空']);
        }
        $where = [
            ['visit_id', '=', $visitId],
            ['distrt_id', '=' ,$loginUser['distributor']['distrt_id']],
        ];
        $visit = model('PromotionJoinVisit')->where($where)->find();
        if (!$visit) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '访客不存在']);
        }
        $user = model('UserData')->where('udata_id', $visit['udata_id'])->field('nickname, avatar')->find();
        if (!$user) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '访客不存在']);
        }
        $where = [
            ['P.store_id', '=', $this->factoryId],
            ['P.is_del', '=', 0],
            ['P.is_del', '=', 0],
            ['PJV.udata_id', '=', $visit['udata_id']],
            ['PJV.distrt_id', '=' ,$loginUser['distributor']['distrt_id']],
            ['PJV.type', '=' ,$this->visitType],
        ];
        $alias = 'PJV';
        $join = [
            ['promotion P', 'P.promot_id = PJV.promot_id', 'LEFT'],
        ];
        $order = 'PJV.add_time DESC';
        $field = 'P.promot_id, P.name, P.cover_img, PJV.visit_num, PJV.add_time as visit_time, PJV.stay_length';
        $result = $this->_getModelList(model('PromotionJoinVisit'), $where, $field, $order, $alias, $join);
        if ($result) {
            foreach ($result as $key => $value) {
                $result[$key]['stay_length'] = $value['stay_length'].' S';
                $result[$key]['visit_time'] = time_to_date($value['visit_time']);
            }
        }
        //计算分享次数 打开次数 下单次数
        $map = [
            ['udata_id', '=', $visit['udata_id']],
            ['distrt_id', '=', $loginUser['distributor']['distrt_id']],
        ];
        $static = model('PromotionJoinVisit')->field('count(IF(type = '.$this->shareType.', true, null)) as share_count, count(IF(type = '.$this->visitType.', true, null)) as click_count')->where($map)->find();
        $where = [
            ['post_udata_id', '=', $visit['udata_id']],
            ['distrt_id', '=', $loginUser['distributor']['distrt_id']],
            ['comm_type', '=', 1],
        ];
        //获取用户对应分销员信息
        $orderCount = model('UserDistributorCommission')->where($where)->count();
        $return = [
            'user'  => $user,
            'static'=> [
                'share_count' => $static ? $static['share_count'] : 0,
                'click_count' => $static ? $static['click_count'] : 0,
                'order_count' => $orderCount,
            ],
            'list'  => $result,
        ];
        $this->_returnMsg($return);
    }
    /**
     * 获取分销详情
     */
    protected function getPromotDetail()
    {
        $loginUser = $this->_checkUser();
        $field = 'promot_id, promot_type, name, cover_img, start_time, end_time, add_time, status, content';
        $info = $this->_verifyPromot(false, $field, TRUE, FALSE);
        $joinId = isset($this->postParams['join_id']) ? intval($this->postParams['join_id']) : '';
        $info['_status'] = get_promotion_status($info);
        $info['start_time'] = $info['start_time'] ? date('Y-m-d H:i:s', $info['start_time']) : '';
        $info['end_time'] = $info['end_time'] ? date('Y-m-d H:i:s', $info['end_time']) : '';
        if($joinId && $info['_status']['status'] == 1){
            //打开分享页面
            $this->_countShare();
        }
        //判断当前用户是否存在已支付的订单
        $where = [
            ['udata_id', '=', $loginUser['udata_id']],
            ['factory_id', '=', $this->factoryId],
            ['pay_status', '=', 1],
        ];
        $order = model('Order')->where($where)->find();
        $this->_returnMsg(['detail' => $info, 'order_pay' => $order ? "1" : "0"]);
    }
    /**
     * 分享统计
     */
    protected function shareCount()
    {
        $loginUser = $this->_checkUser();
        $joinId = isset($this->postParams['join_id']) ? intval($this->postParams['join_id']) : 0;
        if (!$joinId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'join_id不能为空']);
        }
        $where = [
            ['PJ.join_id', '=', $joinId],
            ['PJ.is_del', '=', 0],
            ['PJ.store_id', '=', $this->factoryId],
            ['UD.is_del', '=', 0],
            ['UD.factory_id', '=', $this->factoryId],
            ['P.is_del', '=', 0],
            ['P.status', '=', 1],
        ];
        $join = [
            ['promotion P', 'P.promot_id = PJ.promot_id', 'INNER'],
            ['user_distributor UD', 'UD.udata_id = PJ.udata_id', 'INNER'],
        ];
        $promotionJoinModel = model('PromotionJoin');
        $join = $promotionJoinModel->alias('PJ')->join($join)->where($where)->find();
        if ($join){
            if($join['start_time'] <= time() && $join['end_time'] > time()){
                $visitModel = model('PromotionJoinVisit');
                $data = [
                    'type'      => $this->shareType,//分享
                    'store_id'  => $this->factoryId,
                    'promot_id' => $join['promot_id'],
                    'join_id'   => $join['udata_id'],
                    'distrt_id' => $join['distrt_id'],
                    'udata_id'  => $loginUser['udata_id'],
                    'user_id'   => $loginUser['user_id'],
                    'join_id'   => $joinId,
                ];
                $result = $visitModel->save($data);
                if ($result !== FALSE) {
                    $promotionJoinModel->where('join_id', $joinId)->setInc('share_count', 1);
                }
                $where = [
                    ['udata_id','=', $loginUser['udata_id']],
                    ['store_id', '=', $this->factoryId],
                    ['join_id', '=', $joinId],
                    ['type', '=', $this->visitType],
                ];
//                 pre($where, 1);
                $exist = $visitModel->where($where)->order('add_time DESC')->find();
                pre($exist, 1);
                if ($exist) {
//                     $visitModel->save(['share_id' => $visitModel->visit_id], ['visit_id' => $exist['visit_id']]);
                    $result = $visitModel->where('visit_id', $exist['visit_id'])->update(['share_id' => $visitModel->visit_id]);
//                     pre($result);
                }
            }
            $this->_returnMsg(['msg' => 'success']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '活动不存在或已删除']);
        }
    }
    /**
     * 我的活动分享列表
     */
    protected function getPromotShares()
    {
        $loginUser = $this->_checkUser();
        $this->_checkDistributor();
        $where = [
            ['PJ.store_id', '=', $this->factoryId],
            ['PJ.distrt_id', '=', $loginUser['distributor']['distrt_id']],
            ['PJ.is_del', '=', 0],
            ['PJ.share_count', '>', 0],
        ];
        $alias = 'PJ';
        $join = [
            ['promotion P', 'P.promot_id = PJ.promot_id', 'INNER'],
        ];
        $order = 'PJ.add_time ASC';
        $field = 'PJ.promot_id, PJ.join_id,P.name, P.cover_img, P.start_time, P.end_time, P.status, PJ.share_count, PJ.click_count, PJ.order_count, PJ.add_time as join_time';
        $result = $this->_getModelList(model('PromotionJoin'), $where, $field, $order, $alias, $join);
        if ($result) {
            $visitModel = model('PromotionJoinVisit');
            foreach ($result as $key => $value) {
                //获取活动被分享用户信息
                $map = [
                    ['store_id', '=' ,$this->factoryId],
                    ['join_id', '=' ,$value['join_id']],
                    ['type', '=' , $this->shareType],
                ];
                $join = [
                    ['user_data UD', 'UD.udata_id = PJV.udata_id', 'INNER'],
                ];
                $users = $visitModel->alias('PJV')->field('UD.avatar')->join($join)->where($map)->group('UD.udata_id')->select();
                $users = $users ? $users->toArray() : [];
                $result[$key]['_status'] = get_promotion_status($value);
                $result[$key]['start_time'] = $value['start_time'] ? date('Y-m-d H:i:s', $value['start_time']) : '';
                $result[$key]['end_time'] = $value['end_time'] ? date('Y-m-d H:i:s', $value['end_time']) : '';
                unset($result[$key]['status']);
                $result[$key]['users'] = $users;
            }
        }
        $this->_returnMsg(['list' => $result]);
    }
    /**
     * 创建订单
     */
    protected function createOrder()
    {
        $loginUser = $this->_checkUser();
        $loginUser['factory_id'] = $this->factoryId;
        $promot = $this->_verifyPromot(FALSE, FALSE);
        $sku = $this->_verifySku();
        $submit = isset($this->postParams['submit']) && $this->postParams['submit'] ? TRUE : FALSE;
        $remark = isset($this->postParams['remark']) ? trim($this->postParams['remark']) : '';
        $addressId = isset($this->postParams['address_id']) ? trim($this->postParams['address_id']) : '';
        $joinId = isset($this->postParams['join_id']) ? intval($this->postParams['join_id']) : '';
        //判断当前规格商品是否在分销活动里面
        $goodsId = $sku['goods_id'];
        $where = [
            ['promot_id', '=', $promot['promot_id']],
            ['is_del', '=', 0],
            ['goods_id', '=', $goodsId],
            ['store_id', '=', $this->factoryId],
        ];
        $promotSku = model('PromotionSku')->where($where)->find();
        if (!$promotSku) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品与活动不匹配']);
        }
        $num = isset($this->postParams['num']) ? intval($this->postParams['num']) : 0;
        if ($num <= 0){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '购买商品数量必须大于0']);
        }
        if (!isset($this->postParams['submit'])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'submit不能为空']);
        }
        $join = [];
        if ($promot['start_time'] <= time() && $promot['end_time'] > time()) {
            if($joinId){
                $where = [
                    ['is_del', '=', 0],
                    ['join_id', '=', $joinId],
                    ['promot_id', '=', $promot['promot_id']],
                    ['store_id', '=', $this->factoryId],
                    ['udata_id', '<>', $loginUser['udata_id']],
                ];
                $join = model('PromotionJoin')->where($where)->find();
            }
            $promotSku = $promotSku->toArray();
        }else{
            $promotSku = [];
        }
        /* if($joinId && $promot['start_time'] <= time() && $promot['end_time'] > time()){
            $where = [
                ['is_del', '=', 0],
                ['join_id', '=', $joinId],
                ['promot_id', '=', $promot['promot_id']],
                ['store_id', '=', $this->factoryId],
                ['udata_id', '<>', $loginUser['udata_id']],
            ];
            $join = model('PromotionJoin')->where($where)->find();
        } */
        $params = [
            'order_from'    => 4,//自有电商订单
            'order_source'  => 'fenxiao',//自有订单:自有商城 mall/分销活动 fenxiao
            'promotion'     => $promot,//分销数据详情
            'promotionsku'  => $promotSku,//分销数据详情
            'join'          => $join ? $join: 0,//分销员参与分销活动
        ];
        if ($submit) {
            $address = $this->_verifyAddress(FALSE, FALSE, $loginUser);
            $params['address_name'] = $address['name'];
            $params['address_phone']= $address['phone'];
            $params['region_id']    = $address['region_id'];
            $params['region_name']  = $address['region_name'];
            $params['address']      = $address['address'];
        }
        $orderModel = new \app\common\model\Order();
        $result = $orderModel->createOrder($loginUser, 'goods', $sku['sku_id'], $num, $submit, $params, $remark, 2);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $orderModel->error]);
        }
        if ($submit) {
            if ($promot && $join && $promot['add_time'] <= time() && $promot['end_time'] >= time()) {
                model('PromotionJoin')->where('join_id', $join['join_id'])->setInc('order_count', 1);
            }
            $visitModel = model('PromotionJoinVisit');
            $where = [
                ['udata_id','=', $loginUser['udata_id']],
                ['join_id', '=', $joinId],
                ['type', '=', $this->visitType],
            ];
            $exist = $visitModel->where($where)->order('add_time DESC')->find();
            if ($exist) {
                $visitModel->save(['order_sn' => $result['order_sn'], 'order_status' => 1], ['visit_id' => $exist['visit_id']]);
                //有客户通过分享下单通知
                $informModel = new \app\common\model\LogInform();
                $informModel->sendInform($this->factoryId, 'wechat', ['udata_id' => $loginUser['udata_id']], 'create_order_by_share', $result);
            }
            $this->_returnMsg(['order_sn' => $result['order_sn']]);
        }else{
            $result['first'] = $result['skus'] ? reset($result['skus']) : [];
            $this->_returnMsg(['datas' => $result]);
        }
    }
    /**
     * 获取订单支付配置(微信)
     */
    protected function getOrderPayPredata()
    {
        $loginUser = $this->_checkUser('udata_id, user_id, openid, third_openid');
        $order = $this->_verifyOrder(FALSE, FALSE, $loginUser);
        $order = [
            'openid'    => $loginUser['third_openid'],
            'order_sn'  => $order['order_sn'],
            'real_amount' => $order['real_amount'],
            'store_id'  => $this->factoryId,
        ];
        $paymentApi = new \app\common\api\PaymentApi($this->factoryId, 'wechat_js');
        $result = $paymentApi->init($order);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $paymentApi->error]);
        }else{
            model('Order')->save(['pay_code' => 'wechat_js'], ['order_sn' => $order['order_sn']]);
            $this->_returnMsg(['predata' => $result]);
        }
    }
    /**
     * 分销员个人中心
     */
    protected function getUserCenter()
    {
        $loginUser = $this->_checkUser();
        $map = [
            ['udata_id', '=', $loginUser['udata_id']],
            ['factory_id', '=', $this->factoryId],
        ];
        $field = 'count(IF((order_status = 1 AND pay_status = 0), 1, null)) as status1';
        $field .= ',count(IF((order_status = 1 AND pay_status = 1 AND delivery_status != 2), 1, null)) as status2';
        $field .= ',count(IF((order_status = 1 AND pay_status = 1 AND delivery_status = 2 AND finish_status != 2), 1, null)) as status3';
        $field .= ',count(IF((order_status = 1 AND pay_status = 1 AND delivery_status = 2 AND finish_status = 2), 1, null)) as status4';
        
        $order = model('order')->field($field)->where($map)->find();
        $this->_returnMsg(['order_data' => $order]);
    }
    /**
     * 我的订单列表
     */
    protected function getMyOrderList()
    {
        $loginUser = $this->_checkUser();
        $status = isset($this->postParams['status']) ? intval($this->postParams['status']) : 0;
        $where = [
            ['udata_id', '=', $loginUser['udata_id']],
            ['factory_id', '=', $this->factoryId],
        ];
        if ($status) {
            switch ($status) {
                case 1://待付款
                    $where[] = ['order_status', '=', 1];
                    $where[] = ['pay_status', '=', 0];
                break;
                case 2://已支付待发货
                    $where[] = ['order_status', '=', 1];
                    $where[] = ['pay_status', '=', 1];
                    $where[] = ['delivery_status', '<>', 2];
                    break;
                case 3://已发货待签收
                    $where[] = ['order_status', '=', 1];
                    $where[] = ['pay_status', '=', 1];
                    $where[] = ['delivery_status', '=', 2];
                    $where[] = ['finish_status', '<>', 2];
                    break;
                case 4://待完成/签收
                    $where[] = ['order_status', '=', 1];
                    $where[] = ['pay_status', '=', 1];
                    $where[] = ['delivery_status', '=', 2];
                    $where[] = ['finish_status', '=', 2];
                    break;
                case 5://已取消
                    $where[] = ['order_status', '<>', 1];
                    break;
                default:
                    
                break;
            }
        }else{
            $where[] = ['order_status', '=', 1];
        }
        $order = 'add_time DESC';
        $field = 'order_id, order_type, pay_type, order_sn, real_amount, order_status, user_store_type, delivery_type,  pay_status, delivery_status, finish_status';
        $result = $this->_getModelList(model('order'), $where, $field, $order);
        if ($result && isset($result)) {
            $orderSkuModel = model('OrderSku');
            foreach ($result as $key => $value) {
                //获取订单商品列表
                $map = [
                    ['order_id', '=', $value['order_id']],
                ];
                $result[$key]['skus'] = $orderSkuModel->where($map)->field('goods_id, sku_name, sku_thumb, sku_spec, num, real_price')->select();
                $result[$key]['_status'] = get_order_status($value);
                unset($result[$key]['order_id'], $result[$key]['order_type'], $result[$key]['user_store_type'], $result[$key]['delivery_type']);
            }
        }
        $this->_returnMsg(['list' => $result]);
    }
    /**
     * 获取订单详情
     */
    protected function getOrderDetail()
    {
        parent::getOrderDetail();
    }
    /**
     * 签收/确认完成订单
     */
    protected function finishOrder()
    {
        $loginUser = $this->_checkUser();
        $orderSn = isset($this->postParams['order_sn']) ? trim($this->postParams['order_sn']) : '';
        if (!$orderSn){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单编号不能为空']);
        }
        $orderModel = new \app\common\model\Order();
        $result = $orderModel->orderFinish($orderSn, $loginUser);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $orderModel->error]);
        }else{
            $this->_returnMsg(['msg' => '订单签收成功']);
        }
    }
    /**
     * 获取微信网页授权地址
     */
    protected function getWechatScope()
    {
        $wechatApi = new \app\common\api\WechatApi(0, $this->thirdType);
        $state = isset($this->postParams['state']) && trim($this->postParams['state']) ? trim($this->postParams['state']) : 'STATE';
        $appid = isset($wechatApi->config['appid']) ? trim($wechatApi->config['appid']) : '';
        $appsecret = isset($wechatApi->config['appsecret']) ? trim($wechatApi->config['appsecret']) : '';
        $url = isset($this->postParams['url']) ? trim($this->postParams['url']) : '';
        if (!$appid || !$appsecret) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'Appid/AppSecret配置不能为空']);
        }
        $url = $url ? $url : 'http://h5.imliuchang.cn/everyone';
        $url = $url ? $url : 'http://m.smarlife.cn/everyone';
        $uri = urlEncode($url);
        $scopeUrl = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' . $appid . '&redirect_uri=' . $uri . '&response_type=code&scope=snsapi_userinfo&state='.$state.'#wechat_redirect';
        $this->_returnMsg(['scopeUrl' => $scopeUrl, 'errLogin' => 1]);
    }
    /**
     * 获取微信授权信息
     */
    protected function getWechatOpenid()
    {
        $sessionWechat = session('api_wechat_oauth');
        $wechatApi = new \app\common\api\WechatApi(0, $this->thirdType);
        if (!$sessionWechat) {
            $code = isset($this->postParams['code']) ? trim($this->postParams['code']) : '';
            if (!$code) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => 'code不能为空']);
            }
            $result = $wechatApi->getOauthOpenid($code, TRUE);
            if ($result === FALSE) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => $wechatApi->error]);
            }
            session('api_wechat_oauth', $result);
        }else{
            $result = $sessionWechat;
        }
        $userModel = new \app\common\model\User();
        $params = [
            'user_type'     => 'fenxiao',
            'appid'         => $result['appid'],
            'third_openid'  => $result['openid'],
            'nickname'      => isset($result['nickname']) ? trim($result['nickname']) : '',
            'avatar'        => isset($result['headimgurl']) ? trim($result['headimgurl']) : '',
            'gender'        => isset($result['sex']) ? intval($result['sex']) : 0,
            'unionid'       => isset($result['unionid']) ? trim($result['unionid']) : '',
            'third_type'    => $this->thirdType,
        ];
        $oauth = $userModel->authorized($this->factoryId, $params);
        if ($oauth === FALSE) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => $userModel->error]);
        }
        //记录登陆信息
        session('api_fenxiao_login', $oauth);
        $user = $this->_checkUser('udata_id, openid, nickname, avatar, gender');
        unset($user['udata_id']);
        $this->_returnMsg(['msg' => '授权登录成功', 'errLogin' => 0, 'loginUser' => $user]);
    }
    /**
     * 根据openid更新登录信息
     */
    protected function refresh()
    {
        $openid = isset($this->postParams['openid']) ? trim($this->postParams['openid']) : '';
        if (!$openid){
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'openid不能为空']);
        }
        $udata = model('UserData')->where('openid', $openid)->find();
        if (!$udata) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '用户不存在', 'errLogin' => 1]);
        }
        $user = $oauth = [
            'openid' => $udata['openid'],
            'nickname' => $udata['nickname'],
            'avatar' => $udata['avatar'],
            'gender' => $udata['gender'],
        ];
        session('api_fenxiao_login', $oauth);
        $where = [
            ['udata_id', '=', $udata['udata_id']],
            ['is_del', '=', 0],
            ['factory_id', '=', $this->factoryId],
        ];
        //获取用户对应分销员信息
        $exist = model('UserDistributor')->field('distrt_id, distrt_code, realname, phone, check_status, check_remark, status')->where($where)->find();
        $user['distributor'] = $exist ? $exist->toArray() : [];
        $this->_returnMsg(['errLogin' => 0, 'loginUser' => $user]);
    }
    /**
     * 申请成为分销员
     */
    protected function applyBeDistributor()
    {
        $loginUser = $this->_checkUser('*');
        if ($loginUser['distributor'] && $loginUser['distributor']['check_status'] === 0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商家审核中,请耐心等待']);
        }
        $faceAvatar = isset($this->postParams['face_avatar']) ? trim($this->postParams['face_avatar']) : '';
        $parentCode = isset($this->postParams['parent_code']) ? trim($this->postParams['parent_code']) : '';
        $realname = isset($this->postParams['realname']) ? trim($this->postParams['realname']) : '';
        $phone = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        $password = isset($this->postParams['password']) ? trim($this->postParams['password']) : '';
        $rePwd = isset($this->postParams['re_pwd']) ? trim($this->postParams['re_pwd']) : '';
        if (!$faceAvatar) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请上传头像']);
        }
        if (!$realname) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '真实姓名不能为空']);
        }
        if (!$phone) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '手机号不能为空']);
        }
        //验证手机号格式
        if (!check_mobile($phone)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '手机号格式错误']);
        }
        if (!$password) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '账户密码不能为空']);
        }
        if (strlen($password) < 6 || strlen($password) > 16) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请输入(6-16)位密码']);
        }
        if (!$rePwd) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '重复密码不能为空']);
        }
        if ($password != $rePwd) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '输入密码不一致']);
        }
        $distributorModel = model('UserDistributor');
        $parentId = 0;
        if ($parentCode) {
            $where = [
                ['distrt_code', '=', $parentCode],
                ['is_del',      '=', 0],
                ['check_status','=', 1],
                ['factory_id',  '=', $this->factoryId],
            ];
            $parent = $distributorModel->where($where)->find();
            $parentId = $parent ? $parent['distrt_id'] : 0;
        }
        if (!$parentId) {
            //申请的时候 默认绑定最后一次成功支付的订单的推荐人(如果有)
            $map = [
                ['O.udata_id', '=', $loginUser['udata_id']],
                ['O.order_status', '=', 1],
                ['O.pay_status', '=', 1],
                ['O.order_source', '=', 'fenxiao'],
                ['O.promot_type', '=', 'fenxiao'],
                ['O.promot_id', '>', 0],
                ['O.promot_join_id', '>', 0],
            ];
            $join = [
                ['promotion_join PJ', 'PJ.join_id= O.promot_join_id', 'INNER'],
            ];
            $parentId = model('Order')->alias('O')->join($join)->where($map)->order('pay_time DESC')->value('PJ.distrt_id');
        }
        //判断当前用户是否已经成为分销员
        $where = [
            ['udata_id',    '=', $loginUser['udata_id']],
            ['is_del',      '=', 0],
            ['factory_id',  '=', $this->factoryId],
        ];
        $exist = $distributorModel->where($where)->find();
        if ($exist) {
            if ($exist['check_status'] == 1) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '您已经是分销员']);
            }
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '不能重复申请']);
        }
        //判断手机号对应用户是否存在
        $where = [
            ['phone', '=', $phone],
            ['is_del', '=', 0],
            ['factory_id', '=', $this->factoryId],
        ];
        $userModel = new \app\common\model\User();
        $user = $userModel->where($where)->find();
        if ($user) {
            $userId = $user['user_id'];
            $data = [
                'password'  => $userModel->pwdEncryption($password),
            ];
            $result = $userModel->save($data, ['user_id' => $userId]);
        }else{
            $data = [
                'factory_id' => $this->factoryId,
                'face_avatar'=> $faceAvatar,
                'username' => $phone,
                'phone'    => $phone,
                'password' => $userModel->pwdEncryption($password),
                'nickname' => $loginUser['nickname'],
                'realname' => $realname,
                'avatar' => $loginUser['avatar'],
                'gender' => $loginUser['gender'],
                'source' => 'wechat_fenxiao',
            ];
            $result = $userModel->save($data);
            $userId = $userModel->user_id;
        }
        $result = model('UserData')->save(['user_id' => $userId, 'phone' => $phone], ['udata_id' => $loginUser['udata_id']]);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => -1, 'errMsg' => 'system_error']);
        }
        $where = [
            ['udata_id',    '=', $loginUser['udata_id']],
            ['factory_id',  '=', $this->factoryId],
        ];
        $exist = $distributorModel->where($where)->find();
        if ($exist) {
            $data = [
                'user_id' => $userId,
                'realname'  => $realname,
                'phone'     => $phone,
                'face_avatar'=> $faceAvatar,
                'is_del'    => 0,
                'check_status' => 0,
                'add_time'  => time(),
                'parent_id'  => intval($parentId),
            ];
            $result = $distributorModel->save($data, ['distrt_id' => $exist['distrt_id']]);
        }else{
            $data = [
                'udata_id'  => $loginUser['udata_id'],
                'user_id'   => $userId,
                'factory_id'=> $this->factoryId,
                'realname'  => $realname,
                'phone'     => $phone,
                'face_avatar'=> $faceAvatar,
                'parent_id'  => intval($parentId),
            ];
            $result = $distributorModel->save($data);
        }
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => -1, 'errMsg' => 'system_error']);
        }
        //发送给管理员:提醒审核
        $wechatApi = new \app\common\api\WechatApi(0, 'wechat_h5');
        $appid = isset($wechatApi->config['appid']) ? trim($wechatApi->config['appid']) : '';
        if ($appid) {
            $informModel = new \app\common\model\LogInform();
            $where = [
                ['U.factory_id', '=', $this->factoryId],
                ['U.is_admin', '=', 1],
                ['U.group_id', '=', GROUP_FACTORY],
                ['UD.third_type', '=', 'wechat_h5'],
                ['UD.appid', '=', $appid],
            ];
            $join = [
                ['user_data UD', 'U.user_id = UD.user_id', 'INNER'],
            ];
            $udata = model('User')->field('UD.udata_id, UD.third_openid as openid, UD.user_id')->alias('U')->group('U.group_id')->join($join)->where($where)->find();
            if ($udata) {
                $informModel->sendInform($this->factoryId, 'wechat', $udata, 'user_apply_manager', ['realname' => $realname]);
            }
        }
        $this->_returnMsg(['msg' => '提交申请成功,请耐心等待商家审核']);
    }
    /**
     * 获取分销员详情
     */
    protected function getDistributorDetail()
    {
        $loginUser = $this->_checkUser('*');
        if (!$loginUser['distributor']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '您还未提交申请']);
        }
        $detail = $loginUser['distributor'];
        $config = get_store_config($this->factoryId, TRUE, 'distributor_card');
        $detail['card'] = $config ? $config : [
            'description' => ''
        ];
        $this->_returnMsg(['detail' => $detail]);
    }
    /**
     * 获取下级分销员列表
     */
    protected function getSubDistributors()
    {
        $loginUser = $this->_checkUser();
        $this->_checkDistributor();
        $where = [
            ['UDR.parent_id',   '=', $loginUser['distributor']['distrt_id']],
            ['UDR.is_del',      '=', 0],
            ['UDR.check_status','=', 1],
            ['UDR.factory_id',  '=', $this->factoryId],
        ];
        $alias = 'UDR';
        $join = [
            ['user_data UD', 'UDR.udata_id = UD.udata_id', 'LEFT'],
        ];
        $order = 'UDR.add_time DESC';
        $field = 'UDR.distrt_id, UDR.realname, distrt_code, UDR.phone, UD.nickname, UD.avatar, UDR.add_time, UDR.status';
        $result = $this->_getModelList(model('UserDistributor'), $where, $field, $order, $alias, $join);
        if ($result) {
            foreach ($result as $key => $value) {
                //获取分销员最新一次代言活动
                $where = [
                    ['PJ.store_id', '=', $this->factoryId],
                    ['PJ.promot_type', '=', 'fenxiao'],
                    ['PJ.distrt_id', '=', $value['distrt_id']],
                    ['P.is_del', '=', 0],
                    ['P.status', '=', 1],
                ];
                $field = 'PJ.join_id, PJ.promot_id, share_count, click_count, order_pay_count as order_count';
                $field .= ', name, cover_img, start_time, end_time, P.status';
                $promot = model('promotion_join')->field($field)->alias('PJ')->join('promotion P', 'P.promot_id = PJ.promot_id', 'INNER')->order('PJ.add_time DESC')->where($where)->find();
                if ($promot) {
                    $promot['_status'] = get_promotion_status($promot);
                    $promot['start_time'] = $promot['start_time'] ? date('Y-m-d H:i:s', $promot['start_time']) : '';
                    $promot['end_time'] = $promot['end_time'] ? date('Y-m-d H:i:s', $promot['end_time']) : '';
                }
                $result[$key]['promotion'] = $promot ? $promot : [];
            }
        }
        $this->_returnMsg(['list' => $result]);
    }
    protected function getSubDistributorDetail()
    {
        $loginUser = $this->_checkUser();
        $this->_checkDistributor();
        $distrtId = isset($this->postParams['distrt_id']) ? intval($this->postParams['distrt_id']) : '';
        if (!$distrtId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'distrt_id不能为空']);
        }
        $where = [
            ['UDR.distrt_id',   '=', $distrtId],
            ['UDR.parent_id',   '=', $loginUser['distributor']['distrt_id']],
            ['UDR.is_del',      '=', 0],
            ['UDR.check_status','=', 1],
            ['UDR.factory_id',  '=', $this->factoryId],
        ];
        $alias = 'UDR';
        $join = [
            ['user_data UD', 'UDR.udata_id = UD.udata_id', 'LEFT'],
        ];
        $order = 'UDR.add_time DESC';
        $field = 'UDR.distrt_id, UDR.realname, distrt_code, UDR.phone, UD.nickname, UD.avatar, UDR.add_time';
        $info = model('UserDistributor')->field($field)->alias($alias)->join($join)->where($where)->find();
        if (!$info) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '代言人不存在']);
        }
        
        //获取分销员最新一次代言活动
        $where = [
            ['PJ.store_id', '=', $this->factoryId],
            ['PJ.promot_type', '=', 'fenxiao'],
            ['PJ.distrt_id', '=', $distrtId],
            ['P.is_del', '=', 0],
            ['P.status', '=', 1],
        ];
        $field = 'PJ.join_id, PJ.promot_id, share_count, click_count, order_pay_count as order_count';
        $field .= ', name, cover_img, start_time, end_time, P.status';
        $promots = model('promotion_join')->field($field)->alias('PJ')->join('promotion P', 'P.promot_id = PJ.promot_id', 'INNER')->order('PJ.add_time DESC')->where($where)->select();
        if ($promots) {
            foreach ($promots as $key => $promot) {
                $promots[$key]['_status'] = get_promotion_status($promot);
                $promots[$key]['start_time'] = $promot['start_time'] ? date('Y-m-d H:i:s', $promot['start_time']) : '';
                $promots[$key]['end_time'] = $promot['end_time'] ? date('Y-m-d H:i:s', $promot['end_time']) : '';
            }
        }
        
        $this->_returnMsg(['detail' => $info, 'promots' => $promots]);
    }
    /**
     * 获取地址列表
     */
    protected function getUserAddressList()
    {
        $loginUser = $this->_checkUser();
        $field = 'address_id, name, phone, region_name, address as detail, isdefault';
        $where = [
            ['udata_id', '=', $loginUser['udata_id']],
            ['is_del', '=', 0],
            ['status', '=', 1],
        ];
        $result = $this->_getModelList(model('UserAddress'), $where, $field, 'add_time ASC');
        $this->_returnMsg(['list' => $result,'session_id' => session_id()]);
    }
    /**
     * 获取地址详情
     */
    protected function getUserAddressDetail()
    {
        $loginUser = $this->_checkUser();
        $field = 'address_id, name, phone, region_name, address as detail, isdefault';
        $info = $this->_verifyAddress(FALSE, $field, $loginUser);
        $this->_returnMsg(['detail' => $info]);
    }
    /**
     * 设置默认地址
     */
    protected function setDefaultUserAddress()
    {
        $loginUser = $this->_checkUser();
        $field = 'address_id, name, phone, region_name, address as detail, isdefault';
        $info = $this->_verifyAddress(FALSE, $field, $loginUser);
        $model = model('UserAddress');
        $result = $model->isUpdate(TRUE)->save(['isdefault' => 0], ['udata_id' => $loginUser['udata_id'], 'is_del' => 0]);
        $result = $model->isUpdate(TRUE)->save(['isdefault' => 1], ['address_id' => $info['address_id']]);
        $this->_returnMsg(['msg' => '设置默认地址成功']);
    }
    /**
     * 获取默认地址
     */
    protected function getDefaultUserAddress()
    {
        $loginUser = $this->_checkUser();
        $field = 'address_id, name, phone, region_name, address as detail, isdefault';
        $where = [
            ['is_del', '=', 0],
            ['status', '=', 1],
            ['isdefault', '=', 1],
            ['udata_id', '=', $loginUser['udata_id']]
        ];
        $info = model('UserAddress')->field($field)->where($where)->find();
        if (!$info) {
            $where = [
                ['is_del', '=', 0],
                ['status', '=', 1],
                ['udata_id', '=', $loginUser['udata_id']],
            ];
            $info = model('UserAddress')->field($field)->where($where)->find();
        }
        if (!$info) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '地址不存在或已删除']);
        }
        $this->_returnMsg(['detail' => $info]);
    }
    /**
     * 新增地址
     */
    protected function addUserAddress()
    {
        $loginUser = $this->_checkUser();
        $data = $this->_checkAddressField(FALSE, $loginUser);
        $data['udata_id'] = $loginUser['udata_id'];
        $data['user_id'] = $loginUser['user_id'];
        $addressModel = model('UserAddress');
        if ($data['isdefault'] > 0) {
            $result = $addressModel->save(['isdefault' => 0], ['udata_id' => $loginUser['udata_id'], 'is_del' => 0]);
        }
        $result = $addressModel->isUpdate(FALSE)->save($data);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => -1, 'errMsg' => 'system_error']);
        }
        $this->_returnMsg(['address_id' => $addressModel->address_id]);
    }
    /**
     * 编辑地址
     */
    protected function editUserAddress()
    {
        $loginUser = $this->_checkUser();
        $info = $this->_verifyAddress(FALSE, FALSE, $loginUser);
        $data = $this->_checkAddressField($info, $loginUser);
        $addressModel = model('UserAddress');
        if ($data['isdefault'] > 0) {
            $result = $addressModel->isUpdate(TRUE)->save(['isdefault' => 0], ['udata_id' => $info['udata_id'], 'is_del' => 0]);
        }
        $data['user_id'] = $loginUser['user_id'];
        $result = $addressModel->isUpdate(TRUE)->save($data, ['address_id' => $info['address_id']]);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => -1, 'errMsg' => 'system_error']);
        }
        $this->_returnMsg(['msg' => '地址编辑成功']);
    }
    /**
     * 删除地址
     */
    protected function delUserAddress()
    {
        $loginUser = $this->_checkUser();
        $info = $this->_verifyAddress(FALSE, FALSE, $loginUser);
        $addressModel = model('UserAddress');
        $result = $addressModel->save(['is_del' => 1], ['address_id' => $info['address_id']]);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => -1, 'errMsg' => 'system_error']);
        }
        $this->_returnMsg(['msg' => '地址删除成功']);
    }
    /**
     * 获取银行类型列表
     * @param array $code
     * @return string
     */
    protected function getBankTypeList($code = [])
    {
        $list = [
            [
                'type' => 'CMB',
                'name' => '招商银行',
            ],
            [
                'type' => 'CCB',
                'name' => '建设银行',
            ],
            [
                'type' => 'COM',
                'name' => '交通银行',
            ],
            [
                'type' => 'CPG',
                'name' => '邮政储蓄银行',
            ],
            [
                'type' => 'ICBC',
                'name' => '工商银行',
            ],
            [
                'type' => 'ABC',
                'name' => '农业银行',
            ],
            [
                'type' => 'BOC',
                'name' => '中国银行',
            ],
        ];
        if ($code) {
            $return = '';
            foreach ($list as $key => $value) {
                if ($code == $value['type']) {
                    $return = $value['name'];
                    break;
                }
            }
            return $return;
        }
        $this->_returnMsg(['list' => $list]);
    }
    /**
     * 银行卡列表
     */
    protected function getUserBanklist()
    {
        $loginUser = $this->_checkUser();
        $field = 'bank_id, realname, bank_type, bank_name, bank_no, phone';
        $where = [
            ['udata_id', '=', $loginUser['udata_id']],
            ['is_del', '=', 0],
        ];
        $result = $this->_getModelList(model('UserBank'), $where, $field, 'add_time ASC');
        if ($result) {
            $domian = 'http://'.$_SERVER['HTTP_HOST'];
            foreach ($result as $key => $value) {
                $result[$key]['logo'] = $domian.'/static/base/images/banks/'.strtolower($value['bank_type']).'.jpg';
                unset($result[$key]['bank_type']);
            }
        }
        $this->_returnMsg(['list' => $result]);
    }
    /**
     * 获取银行卡详情
     */
    protected function getUserBankDetail()
    {
        $loginUser = $this->_checkUser();
        $field = 'bank_id, realname, bank_name, bank_no, phone';
        $info = $this->_verifyBank(FALSE, $field, $loginUser);
        $this->_returnMsg(['detail' => $info]);
    }
    /**
     * 新增银行卡
     */
    protected function addUserBank()
    {
        $loginUser = $this->_checkUser();
        $data = $this->_checkBankField(FALSE, $loginUser);
        $data['udata_id'] = $loginUser['udata_id'];
        $data['user_id'] = $loginUser['user_id'];
        $bankModel = model('UserBank');
        $result = $bankModel->isUpdate(FALSE)->save($data);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => -1, 'errMsg' => 'system_error']);
        }
        $this->_returnMsg(['bank_id' => $bankModel->bank_id]);
    }
    /**
     * 编辑银行卡
     */
    protected function editUserBank()
    {
        $loginUser = $this->_checkUser();
        $info = $this->_verifyBank(FALSE, FALSE, $loginUser);
        $data = $this->_checkBankField($info, $loginUser);
        $data['user_id'] = $loginUser['user_id'];
        $result = model('UserBank')->isUpdate(TRUE)->save($data, ['bank_id' => $info['bank_id']]);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => -1, 'errMsg' => 'system_error']);
        }
        $this->_returnMsg(['msg' => '银行卡编辑成功']);
    }
    /**
     * 删除银行卡
     */
    protected function delUserBank()
    {
        $loginUser = $this->_checkUser();
        $info = $this->_verifyBank(FALSE, FALSE, $loginUser);
        $result = model('UserBank')->save(['is_del' => 1], ['bank_id' => $info['bank_id']]);
        if ($result === FALSE) {
            $this->_returnMsg(['errCode' => -1, 'errMsg' => 'system_error']);
        }
        $this->_returnMsg(['msg' => '银行卡删除成功']);
    }
    /**
     * 获取账户信息
     */
    protected function getUserAccount()
    {
        $loginUser = $this->_checkUser();
        $this->_checkDistributor();
        if (!$loginUser['user_id']) {
            $this->_returnMsg(['errCode' => -1, 'errMsg' => 'no data']);
        }
        $user = model('User')->where('user_id', $loginUser['user_id'])->find();
        if (!$user) {
            $this->_returnMsg(['errCode' => -1, 'errMsg' => 'no data']);
        }
        //今日开始时间
        $beginToday = mktime(0,0,0,date('m'),date('d'),date('Y'));
        $where = [
            ['store_id', '=' ,$this->factoryId],
            ['distrt_id', '=' ,$loginUser['distributor']['distrt_id']],
            ['udata_id', '<>' ,$loginUser['udata_id']],
            ['add_time', '>=' ,$beginToday],
            ['type', '=' , $this->visitType],//1打开 2分享
        ];
        $todayVisit = model('PromotionJoinVisit')->where($where)->count();
        
        $where = [
            ['store_id', '=' ,$this->factoryId],
            ['distrt_id', '=' ,$loginUser['distributor']['distrt_id']],
            ['add_time', '>=' ,$beginToday],
            ['type', '=' ,$this->shareType],
        ];
        $todayShare = model('PromotionJoinVisit')->where($where)->count();
        
        $where = [
            ['user_id', '=' ,$loginUser['user_id']],
            ['add_time', '>=' ,$beginToday],
        ];
        $todayCommissionAmount = model('UserDistributorCommission')->where($where)->sum('value');
        $return = [
            'amount'            => $user['amount'],
            'withdraw_amount'   => $user['withdraw_amount'],
            'pending_amount'    => $user['pending_amount'],
            'total_amount'      => $user['total_amount'],
            'today_visit'       => $todayVisit,
            'today_share_count' => $todayShare,
            'today_commission_amount'  => $todayCommissionAmount,
        ];
        //获取推广打开次数和订单总数
        $where = [
            'user_id'   => $loginUser['user_id'],
            'is_del'    => 0,
            'status'    => 1,
            'store_id'  => $this->factoryId,
        ];
        $joins = model('PromotionJoin')->where($where)->field('sum(click_count) as click_count, sum(order_pay_count) as order_count')->find();
        $return['my_promotion']['click_count'] = $joins ? intval($joins['click_count']) : 0;
        $return['my_promotion']['order_count'] = $joins ? intval($joins['order_count']) : 0;
        //计算下级分销员数量
        $where = [
            ['is_del', '=', 0],
            ['parent_id', '=', $loginUser['distributor']['distrt_id']],
        ];
        $count = model('UserDistributor')->where($where)->count();
        $return['sub_distributor'] = $count;
        $this->_returnMsg(['account' => $return]);
    }
    /**
     * 申请提现
     */
    protected function applyWithdraw()
    {
        $loginUser = $this->_checkUser();
        $this->_checkDistributor();
        if (!$loginUser['user_id']) {
            $this->_returnMsg(['errCode' => -1, 'errMsg' => 'no data']);
        }
        $user = model('User')->where('user_id', $loginUser['user_id'])->find();
        if (!$user) {
            $this->_returnMsg(['errCode' => -1, 'errMsg' => 'no data']);
        }
        $withdrawModel = new \app\common\model\UserWithdraw();
        $amount = isset($this->postParams['amount']) && $this->postParams['amount'] ? floatval($this->postParams['amount']) : 0;
        $arrivalType = isset($this->postParams['arrival_type'])? trim($this->postParams['arrival_type']) : 'bank';
        $tradeNo = '';
        $bank = [];
        switch ($arrivalType) {
            case 'bank':
                $bank = $this->_verifyBank(FALSE, FALSE, $loginUser);
            break;
            case 'wechat_wallet':
                $tradeNo = $withdrawModel->getTradeNo();
            break;
            default:
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '参数错误']);
            break;
        }
        
        if ($amount <= 0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '提现金额有误，请重新输入，确认无误后再提交']);
        }
        if ($user['amount'] <= 0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '没有可提现额度']);
        }
        if ($amount > $user['amount']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '最大提现金额为'.$user['amount'].'元']);
        }
        $config = get_store_config($this->factoryId, TRUE, 'default');
        //判断商户是否可提现
        if ($config && isset($config['monthly_withdraw_start_date']) && isset($config['monthly_withdraw_end_date'])) {
            $setting['withdraw_start_date']=$min = intval($config['monthly_withdraw_start_date']);
            $setting['withdraw_end_date']=$max = intval($config['monthly_withdraw_end_date']);
            $day = intval(date('d'));
            if ($day < $min || $day > $max) {
                $this->_returnMsg(['errCode' => 2, 'errMsg' => '每月提现时间：'.$min.'日-'.$max.'日']);
            }
        }
        $data = [
            'store_id'  => $this->factoryId,
            'user_id'   => $user['user_id'],
            'udata_id'  => $loginUser['udata_id'],
            'amount'    => $amount,
            'arrival_type' => $arrivalType,
            'trade_no'  => $tradeNo,
            
            'bank_id'   => $bank ? $bank['bank_id'] : 0,
            'realname'  => $bank ? $bank['realname'] : '',
            'bank_name' => $bank ? $bank['bank_name'] : '',
            'bank_no'   => $bank ? $bank['bank_no'] : '',
            'bank_detail' => $bank ? json_encode($bank) : '',
            
            'withdraw_status'=> 0,
        ];
        $result = $withdrawModel->save($data);
        if ($result !== FALSE) {
            $params = [
                'msg' => '提现',
                'extra_id' => $withdrawModel->log_id,
            ];
            //记录成功后减少可提现金额
            $userLogModel = new \app\common\model\UserLog();
            $result = $userLogModel->record($user['user_id'], 'amount', -$amount, 'withdraw', $params);
            if ($result !== FALSE) {
                model('User')->where('user_id', $loginUser['user_id'])->setInc('withdraw_amount', $amount);
            }
            $informModel = new \app\common\model\LogInform();
            $data['arrival_type'] = isset($withdrawModel->arrivalTypes[$arrivalType]) ? $withdrawModel->arrivalTypes[$arrivalType] : '银行卡';
            $informModel->sendInform($this->factoryId, 'wechat', ['udata_id' => $loginUser['udata_id']], 'withdraw_user_apply', $data);
            
            //发送给管理员:提醒审核
            $wechatApi = new \app\common\api\WechatApi(0, 'wechat_h5');
            $appid = isset($wechatApi->config['appid']) ? trim($wechatApi->config['appid']) : '';
            if ($appid) {
                $where = [
                    ['U.factory_id', '=', $this->factoryId],
                    ['U.is_admin', '=', 1],
                    ['U.group_id', '=', GROUP_FACTORY],
                    ['UD.third_type', '=', 'wechat_h5'],
                    ['UD.appid', '=', $appid],
                ];
                $join = [
                    ['user_data UD', 'U.user_id = UD.user_id', 'INNER'],
                ];
                $udata = model('User')->field('UD.udata_id, UD.third_openid as openid, UD.user_id')->alias('U')->group('U.group_id')->join($join)->where($where)->find();
                if ($udata) {
                    $informModel->sendInform($this->factoryId, 'wechat', $udata, 'withdraw_manager_apply', $data);
                }
            }
            $this->_returnMsg(['msg' => '提现申请成功,请耐心等待审核']);
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '申请提交异常']);
        }
    }
    /**
     * 获取提现记录
     */
    protected function getWithdrawList()
    {
        $loginUser = $this->_checkUser();
        $this->_checkDistributor();        
        $where = [
            ['user_id', '=', $loginUser['user_id']],
            ['is_del', '=', 0],
        ];
        $field = 'log_id, add_time, amount, withdraw_status';
        $order = 'add_time DESC';
        $list = $this->_getModelList(model('UserWithdraw'), $where, $field, $order);
        if ($list) {
            foreach ($list as $key => $value) {
                $list[$key]['_status']= [
                    'withdraw_status' => $value['withdraw_status'],
                    'status_text' => get_withdraw_status($value['withdraw_status']),
                ];
                unset($list[$key]['withdraw_status']);
            }
        }
        $this->_returnMsg(['list' => $list]);
    }
    
    private function _countShare()
    {
        $loginUser = $this->_checkUser();
        $joinId = isset($this->postParams['join_id']) ? intval($this->postParams['join_id']) : 0;
        if (!$joinId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'join_id不能为空']);
        }
        $where = [
            ['PJ.join_id', '=', $joinId],
            ['PJ.is_del', '=', 0],
            ['PJ.store_id', '=', $this->factoryId],
            ['UD.is_del', '=', 0],
            ['UD.factory_id', '=', $this->factoryId],
            ['PJ.udata_id', '<>', $loginUser['udata_id']],
            ['P.is_del', '=', 0],
            ['P.status', '=', 1],
            ['P.start_time', '<=', time()],
            ['P.end_time', '>', time()],
        ];
        $join = [
            ['promotion P', 'P.promot_id = PJ.promot_id', 'INNER'],
            ['user_distributor UD', 'UD.distrt_id = PJ.distrt_id', 'INNER'],
        ];
        $promotionJoinModel = model('PromotionJoin');
        $join = $promotionJoinModel->alias('PJ')->join($join)->where($where)->find();
        if ($join){
            $field = 'click_count';
            $joinData = [
                $field => Db::raw($field.'+1'),
            ];
            $visitModel = model('PromotionJoinVisit');
            $where = [
                ['udata_id','=', $loginUser['udata_id']],
                ['join_id', '=', $joinId],
                ['type', '=', $this->visitType],
            ];
            $exist = $visitModel->where($where)->order('add_time DESC')->find();
            if (!$exist) {
                $field = 'click_user_count';
                $joinData[$field] = Db::raw($field.'+1');
                $visitNum = 1;
            }else{
                $visitNum = $exist['visit_num'] + 1;
            }
            $data = [
                'store_id'  => $this->factoryId,
                'promot_id' => $join['promot_id'],
                'join_id'   => $join['udata_id'],
                'distrt_id' => $join['distrt_id'],
                'udata_id'  => $loginUser['udata_id'],
                'user_id'   => $loginUser['user_id'],
                'join_id'   => $joinId,
                'visit_num' => $visitNum,
            ];
            $result = $visitModel->save($data);
            if ($result === FALSE) {
                $this->_returnMsg(['errCode' => -1, 'errMsg' => 'system_error']);
            }
            $result = $promotionJoinModel->save($joinData, ['join_id' => $joinId]);
        }
    }
    /**
     * 验证表单信息
     * @param int $orderSn
     * @param string $field
     */
    private function _verifyOrder($orderSn = '', $field = '', $user = [])
    {
        if (!$orderSn) {
            $orderSn = isset($this->postParams['order_sn']) ? trim($this->postParams['order_sn']) : '';
        }
        if (!$orderSn) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'order_sn不能为空']);
        }
        $field = $field ? $field : '*';
        $info = model('order')->field($field)->where('order_sn', $orderSn)->where('udata_id', $user['udata_id'])->find();
        if (!$info) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单不存在']);
        }
        return $info->toArray();
    }
    /**
     * 验证表单信息
     * @param int $bankId
     * @param string $field
     */
    private function _verifyBank($bankId = 0, $field = '', $user = [])
    {
        if (!$bankId) {
            $bankId = isset($this->postParams['bank_id']) ? intval($this->postParams['bank_id']) : '';
        }
        if (!$bankId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'bank_id不能为空']);
        }
        $field = $field ? $field : '*';
        $info = model('UserBank')->field($field)->where('bank_id', $bankId)->where('udata_id', $user['udata_id'])->where('is_del', 0)->find();
        if (!$info) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '银行卡不存在']);
        }
        return $info->toArray();
    }
    /**
     * 检查并处理add/edit对应的请求参数
     * @param array $info
     * @return array
     */
    private function _checkBankField($info = [], $user = [])
    {
        $realname = isset($this->postParams['realname']) ? trim($this->postParams['realname']) : '';
        $bankType = isset($this->postParams['bank_type']) ? trim($this->postParams['bank_type']) : '';
        $bankName = isset($this->postParams['bank_name']) ? trim($this->postParams['bank_name']) : '';
        $bankNo = isset($this->postParams['bank_no']) ? trim($this->postParams['bank_no']) : '';
        $phone = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        if (!$realname) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '持卡人姓名不能为空']);
        }
        if (!$bankType) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '开户行不能为空']);
        }
        $bankName = $this->getBankTypeList($bankType);
        if (!$bankName) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '开户行不存在']);
        }
        if (!$bankNo) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '银行卡号不能为空']);
        }
        if (!$phone) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '手机号不能为空']);
        }
        //判断银行卡号是否存在
        $where = [
            ['bank_type', '=', $bankType],
            ['bank_no', '=', $bankNo],
            ['is_del', '=', 0],
            ['udata_id', '=', $user['udata_id']],
        ];
        if ($info) {
            $where[] = ['bank_id', '<>', $info['bank_id']];
        }
        $exist = model('UserBank')->where($where)->find();
        if ($exist) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '银行卡号已存在']);
        }
        $return =  [
            'realname'      => $realname,
            'bank_type'     => $bankType,
            'bank_name'     => $bankName,
            'bank_no'   => $bankNo,
            'phone'     => $phone,
        ];
        return $return;
    }
    /**
     * 检查并处理地址add/edit对应的请求参数
     * @param array $info
     * @param array $user
     * @return array
     */
    private function _checkAddressField($info = [], $user = [])
    {
        $name = isset($this->postParams['name']) ? trim($this->postParams['name']) : '';
        $phone = isset($this->postParams['phone']) ? trim($this->postParams['phone']) : '';
        $regionId = isset($this->postParams['region_id']) ? intval($this->postParams['region_id']) : '';
        $regionName = isset($this->postParams['region_name']) ? trim($this->postParams['region_name']) : '';
        $address = isset($this->postParams['detail']) ? trim($this->postParams['detail']) : '';
        $isdefault = isset($this->postParams['isdefault']) ? intval($this->postParams['isdefault']) : 0;
        if (!$name) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '姓名不能为空']);
        }
        if (!$phone) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '手机号不能为空']);
        }
        if (!$regionId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'region_id不能为空']);
        }
        if (!$regionName) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '区域名称不能为空']);
        }
        if (!$address) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '详细地址不能为空']);
        }
        if (!check_mobile($phone)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '手机号格式错误']);
        }
        $return =  [
            'name'      => $name,
            'phone'     => $phone,
            'region_id' => $regionId,
            'region_name'  => $regionName,
            'address'   => $address,
            'isdefault' => $isdefault ? 1: 0,
        ];
        return $return;
    }
    private function _verifyAddress($addressId = '', $field = '', $user = [])
    {
        if (!$addressId) {
            $addressId = isset($this->postParams['address_id']) ? intval($this->postParams['address_id']) : '';
        }
        if (!$addressId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'address_id不能为空']);
        }
        $field = $field ? $field : '*';
        $where = [
            ['address_id', '=', $addressId],
            ['is_del', '=', 0],
            ['status', '=', 1],
            ['udata_id', '=', $user['udata_id']]
        ];
        $info = model('UserAddress')->field($field)->where($where)->find();
        if (!$info) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '地址不存在或已删除']);
        }
        return $info->toArray();
    }
    private function _verifySku($skuId = '', $field = '')
    {
        if (!$skuId) {
            $skuId = isset($this->postParams['sku_id']) ? intval($this->postParams['sku_id']) : '';
        }
        if (!$skuId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => 'sku_id不能为空']);
        }
        $field = $field ? $field : '*';
        $where = [
            ['sku_id', '=', $skuId],
            ['is_del', '=', 0],
            ['status', '=', 1],
            ['store_id', '=', $this->factoryId]
        ];
        $info = model('GoodsSku')->field($field)->where($where)->find();
        if (!$info) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品已下架']);
        }
        return $info->toArray();
    }
    private function _verifyPromot($promotId = '', $field = '', $required = TRUE, $valid = TRUE)
    {
        if (!$promotId) {
            $promotId = isset($this->postParams['promot_id']) ? intval($this->postParams['promot_id']) : '';
        }
        if (!$promotId) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '活动ID不能为空']);
        }
        $field = $field ? $field : '*';
        $where = [
            ['promot_id', '=', $promotId],
            ['promot_type', '=', $this->promotType],
            ['is_del', '=', 0],
            ['store_id', '=', $this->factoryId],
        ];
        $promotionModel = new \app\common\model\Promotion();
        $info = $promotionModel->field($field)->where($where)->find();
        if (!$info['status']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '活动已禁用']);
        }
        if ($required && !$info) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '活动不存在或已删除']);
        }
        if ($valid) {
            if ($info['start_time'] > time()) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '活动未开始']);
            }
            if ($info['end_time'] < time()) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '活动已结束']);
            }
        }
        return $info ? $info->toArray() : [];
    }
    /**
     * 验证分销员身份
     */
    private function _checkDistributor($flag = TRUE)
    {
        $loginUser = $this->_checkUser();
        if ($flag) {
            if (!$loginUser['distributor']) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '不是分销员,无操作权限']);
            }
            if (!$loginUser['distributor']['check_status']) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '审核中,无操作权限']);
            }
            if ($loginUser['distributor']['check_status'] == 2) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '申请已拒绝,无操作权限']);
            }
            if (!$loginUser['distributor']['status']) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '已禁用,无操作权限']);
            }
        }else{
            if ($loginUser['distributor']) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '分销员,无操作权限']);
            }
        }
    }
    /**
     * 将数据格式化成树形结构
     * @param array $items
     * @return array
     */
    private function _region($items) {
        $tree = array(); //格式化好的树
        foreach ($items as $item){
            if (isset($items[$item['parent_id']])){
                $items[$item['parent_id']]['child'][] = &$items[$item['region_id']];
            }else{
                $tree[] = &$items[$item['region_id']];
            }
        }
        return $tree;
    }
    /**
     * 获取当前用户登录信息
     * @return array
     */
    protected function _checkUser($field = FALSE)
    {
        $loginUser = session('api_fenxiao_login');
        if ($loginUser) {
            $where = [
                ['openid', '=', $loginUser['openid']],
                ['factory_id', '=', $this->factoryId],
            ];
            $field = $field ? $field : 'udata_id, user_id, openid';
            $user = model('UserData')->field($field)->where($where)->find();
            if (!$user) {
                session('api_wechat_oauth', []);
                session('api_fenxiao_login', []);
                $this->_returnMsg(['msg' => '前往授权页面', 'errLogin' => 1]);
            }
            $where = [
                ['udata_id', '=', $user['udata_id']],
                ['is_del', '=', 0],
                ['factory_id', '=', $this->factoryId],
            ];
            $user = $user->toArray();
            //获取用户对应分销员信息
            $exist = model('UserDistributor')->field('distrt_id, face_avatar, distrt_code, realname, phone, check_status, check_remark, status')->where($where)->find();
            $user['distributor'] = $exist ? $exist->toArray() : [];
            return $user;
        }else{
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '未登录', 'errLogin' => 1]);
        }
    }
    protected function _checkPostParams()
    {
        if ($_SERVER['SERVER_ADDR'] != '127.0.0.1' && $_SERVER['SERVER_ADDR'] != '172.18.11.74') {
            parent::_checkPostParams();
            return ;
        }
        $this->requestTime = time();
        $this->visitMicroTime = $this->_getMillisecond();//会员访问时间(精确到毫秒)
        if (!$this->postParams) {
            $signKey = '0X65M8ixVmwq';
            $this->postParams = $this->request->param();
            
            $this->postParams['timestamp'] = time();
            $this->postParams['version'] = '1.0';
            $this->postParams['signkey'] = $signKey;
            $sign = $this->getSign($this->postParams, $signKey);
            $this->postParams['sign'] = $sign;
//             pre($this->postParams, 1);
        }
        if (!$this->postParams) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请求参数异常']);
        }
    }
}