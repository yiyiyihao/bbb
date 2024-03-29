<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/1/14 0014
 * Time: 12:13
 */

namespace app\api\controller;


use app\api\behavior\PayNotify;
use app\common\api\WechatApi;
use app\common\model\Goods;
use app\common\model\Order;
use think\facade\Hook;
use think\facade\Log;


class Activity extends BaseApi
{
    private $storeId = 1;
    private $factoryId = 1;
    private $activityId = 1;

    public function initialize()
    {
        //放过所有跨域
        $origin = isset($_SERVER['HTTP_ORIGIN']) ? $_SERVER['HTTP_ORIGIN'] : '';
        header('Access-Control-Allow-Origin:' . $origin);
        header('Access-Control-Allow-Methods:POST');
        header('Access-Control-Allow-Headers:x-requested-with,content-type');

    }

    private function checkActInfo()
    {
        $actInfo=db('activity')->where([
            'is_del'=>0,
            'status'=>1,
            'store_id'=>$this->factoryId,
            'start_time'=>['<=',time()],
            'end_time'=>['>=',time()],
        ])->find();
        if (empty($actInfo)) {
            return returnMsg(110, '活动未始或已过期');
        }
        return $actInfo;
    }

    //授权-第1步
    public function getScope()
    {
        $wechatApi = new WechatApi(0, 'wechat_h5');
        $appid = $wechatApi->config['appid'];
        $appsecret = $wechatApi->config['appsecret'];

        //$appid = 'wxd3bbb9c41f285e8d';
        //$appsecret = '0aa9afd28b6140cd97abf6fe47dc7082';
        $uri = urlEncode('http://m.smarlife.cn');
        $scopeUrl = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' . $appid . '&redirect_uri=' . $uri . '&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect';
        return returnMsg(0, 'ok', ['url' => $scopeUrl]);
    }

    //授权-第2步，返回微信Openid
    public function getOpenid()
    {
        $wechatApi = new WechatApi(0, 'wechat_h5');;
        $code = input('code');
        if (empty($code)) {
            return returnMsg(1, lang('PARAM_ERROR'));
        }
        $result = $wechatApi->getOauthOpenid($code, TRUE);
        if ($result === FALSE) {
            return returnMsg(2, $wechatApi->error);
        }
        $userModel = new \app\common\model\User();
        $params = [
            'user_type' => 'user',
            'appid' => $result['appid'],
            'third_openid' => $result['openid'],
            'nickname' => isset($result['nickname']) ? trim($result['nickname']) : '',
            'avatar' => isset($result['headimgurl']) ? trim($result['headimgurl']) : '',
            'gender' => isset($result['sex']) ? intval($result['sex']) : 0,
            'unionid' => isset($result['unionid']) ? trim($result['unionid']) : '',
            'third_type' => 'wechat_h5',
        ];
        $oauth = $userModel->authorized($this->factoryId, $params);
        if ($oauth === false) {
            return returnMsg(3, $userModel->error);
        }
        $oauth['third_openid'] = $result['openid'];
        session('act_udata_id',$oauth['udata_id']);
        session('act_third_open_id',$result['openid']);
        return returnMsg(0, 'ok', $oauth);
    }


    private function getUdataId()
    {
        return session('act_udata_id');
    }

    //商品列表
    public function getGoodsList()
    {
        $actInfo=$this->checkActInfo();
        $field = 'goods_id, name, goods_sn, thumb, (min_price + install_price) as min_price, (max_price + install_price) as max_price, goods_stock, sales';
        $where=[
            'is_del'=>0,
            'status'=>1,
        ];
        $list = db('goods')->where($where)->whereIn('goods_id',$actInfo['goods_id'])->field($field)->order('sort_order DESC, add_time DESC')->select();
        return returnMsg(0, 'ok', $list);
    }

    //商品详情
    public function getGoodsDetail()
    {
        $actInfo=$this->checkActInfo();
        $id = input('goods_id', 0, 'intval');
        if ($id <= 0) {
            return returnMsg(1, lang('PARAM_ERROR'));
        }

        $where = [
            ['status', '=', 1],
            ['is_del', '=', 0],
            ['goods_id', 'in', explode(',',$actInfo['goods_id'])],
        ];
        $field = 'goods_id,name,thumb,content,min_price,install_price,imgs';
        $goods = Goods::where($where)->field($field)->find();
        if (empty($goods)) {
            return returnMsg(1, '没能找到您要的商品，或许已下架');
        }
        $goods['activity_price'] = $actInfo['activity_price'];
        $where = ['goods_id' => $id, 'is_del' => 0, 'status' => 1];
        $field = 'sku_id,sku_name,sku_thumb,sku_stock,price,install_price,sales,spec_json';
        $skuList = db('goods_sku')->field($field)->where($where)->order("sku_id")->select();
        $where = [
            'status' => 1,
            'is_del' => 0,
            'store_id' => $this->storeId,
        ];
        $specList = db('goods_spec')->field('name,value')->where($where)->order("sort_order")->select();
        if ($specList) {
            foreach ($specList as $k => $v) {
                $specList[$k]['value'] = explode(',', $v['value']);
            }
        }
        $result = [
            'goods' => $goods,
            'sku' => $skuList,
            'specal' => $specList,
        ];
        return returnMsg(0, 'ok', $result);
    }


    //订单列表
    public function orderList()
    {
        $udata_id = input('udata_id', $this->getUdataId(), 'intval');
        if (empty($udata_id)) {
            return returnMsg(2, lang('PARAM_ERROR'));
        }

        //0全部，1待付款，2待发货，3已发货，4交易完成
        $page = input('page', 1, 'intval');
        $limit = input('limit', 10, 'intval');
        $status = input('status', 0, 'intval');
        $where['O.udata_id'] = $udata_id;
        $where['O.order_type'] = 2;
        $where['O.status'] = 1;

        $order_status = '';
        $status_des = '';
        switch ($status) {
            case 1://待付款
                $where['O.pay_status'] = 0;
                $order_status = 1;
                $status_des = '待付款';
                break;
            case 2://待发货
                $where['O.pay_status'] = 1;
                $where['O.delivery_status'] = 0;
                $where['O.finish_status'] = 0;
                $order_status = 2;
                $status_des = '待发货';
                break;
            case 3://已发货
                $where['O.pay_status'] = 1;
                $where['O.delivery_status'] = ['IN', [1, 2]];
                $where['O.finish_status'] = 0;
                $order_status = 3;
                $status_des = '已发货';
                break;
            case 4://交易完成
                $where['O.finish_status'] = 2;
                $order_status = 4;
                $status_des = '已完成';
                break;
            default://全部
                break;
        }
        $field = 'O.order_type, O.order_sn,G.name as goods_name,OS.sku_name,O.real_amount, O.real_amount as total_amount, O.order_status,O.pay_status,O.delivery_status,O.finish_status';
        $join = [
            ['store S', 'S.store_id=O.store_id'],
            ['order_sku OS', 'OS.order_sn=O.order_sn'],
            ['goods G', 'OS.goods_id = G.goods_id'],
        ];
        $order = Order::alias('O')
            ->field($field)
            ->join($join)
            ->where($where)
            ->order('O.order_id desc')
            ->limit($limit)
            ->page($page)
            ->select();
        if (empty($order)) {
            return returnMsg(1, '暂无数据');
        }
        if ($order) {
            foreach ($order as $key => $value) {
                //订单状态(1：正常，2：全部取消，3：全部关闭，4：全部删除)
                switch ($value['order_status']) {
                    case 1:
                        $_status = 1;
                        if ($value['pay_status'] == 0) {
                            $_status = 1;//待付款
                            $status_des = '待付款';
                        }elseif ($value['pay_status'] == 1 && $value['delivery_status'] == 0){
                            $_status = 2;//待发货
                            $status_des = '待发货';
                        }elseif ($value['delivery_status']!= 0 && $value['finish_status'] == 0){
                            $_status = 3;//已发货
                            $status_des = '已发货';
                        }elseif ($value['finish_status'] != 0 ){
                            $_status = 4;//已完成
                            $status_des = '已完成';
                        }
                    break;
                    case 2://已取消
                        $_status = 5;
                        $status_des = '已取消';
                    break;
                    case 3://已关闭
                        $_status = 6;
                        $status_des = '已关闭';
                    break;
                    default:
                    break;
                }
                $order[$key]['status'] = $_status;
                $data = get_order_status($value);
                $order[$key]['status_des'] = $data['status_text'];
            }
        }

        return returnMsg(0, 'ok', $order);
    }

    //订单详情
    public function orderDetail()
    {
        $order_sn = input('order_sn', 0, 'trim');
        if (empty($order_sn)) {
            return returnMsg(1, lang('PARAM_ERROR'));
        }
        $udata_id = input('udata_id', $this->getUdataId(), 'intval');
        if (empty($udata_id)) {
            return returnMsg(2, lang('PARAM_ERROR'));
        }

        $where['O.order_type'] = 2;
        $where['O.status'] = 1;
        $where['O.order_sn'] = strval($order_sn);
        $where['O.udata_id'] = $udata_id;

        $field = 'O.order_id,O.order_sn,G.name,OS.sku_name,O.real_amount,O.address_name,O.address_phone,O.address_detail,O.remark,O.order_status,O.pay_status,O.delivery_status,O.finish_status';
        $join = [
            ['store S', 'S.store_id=O.store_id'],
            ['order_sku OS', 'OS.order_sn=O.order_sn'],
            ['goods G', 'OS.goods_id = G.goods_id'],
        ];
        $order = Order::alias('O')
            ->field($field)
            ->join($join)
            ->where($where)
            ->find();

        if (empty($order)) {
            return returnMsg(1, '暂无数据');
        }
        $order_status = '';
        $status_des = '';
        if ($order['order_status'] == 2) {
            $order_status = 5;
            $status_des = '已取消';
        } elseif ($order['order_status'] == 3) {
            $order_status = 6;
            $status_des = '已关闭';
        } elseif ($order['pay_status'] == 0) {
            $time = ($order['add_time'] + 1800 - time()) / 60;
            $time = $time > 0 ? $time : 0;
            $order_status = 1;
            $status_des = '等待付款<br>剩余' . ceil($time) . '分钟自动关闭';
            $status_des = '待支付';
        } elseif ($order['pay_status'] == 1 && $order['delivery_status'] == 0 && $order['finish_status'] == 0) {
            $order_status = 2;
            $status_des = '付款成功<br>等待厂家发货';
            $status_des = '待发货';
        } elseif ($order['pay_status'] == 1 && in_array($order['delivery_status'], [1, 2]) && $order['finish_status'] == 0) {
            $order_status = 3;
            $status_des = '付款成功<br>厂家已发货';
            $status_des = '已发货';
        } elseif ($order['finish_status'] == 2) {
            $order_status = 4;
            $status_des = '已收到<br>交易完成';
            $status_des = '已完成';
        }
        unset($order['order_status'], $order['pay_status'], $order['delivery_status'], $order['finish_status']);
        $order['status'] = $order_status;
        $order['status_des'] = $status_des;
        return returnMsg(0, 'ok', $order);
    }

    //取消订单
    public function cancelOrder()
    {
        $order_sn = input('order_sn', 0, 'trim');
        if (empty($order_sn)) {
            return returnMsg(1, lang('PARAM_ERROR'));
        }
        $udata_id = input('udata_id', $this->getUdataId(), 'intval');
        if (empty($udata_id)) {
            return returnMsg(2, lang('PARAM_ERROR'));
        }
        $user = [
            'udata_id' => $udata_id,
        ];
        $orderModel = new Order();
        $result = $orderModel->orderCancel($order_sn, $user);
        if ($result === false) {
            return returnMsg(3, $orderModel->error);
        }
        return returnMsg(0, 'ok');
    }

    //修改地址
    public function updateAddr()
    {

    }


    //确认收货
    public function orderFinish()
    {
        $order_sn = input('order_sn', 0, 'trim');
        if (empty($order_sn)) {
            return returnMsg(1, lang('PARAM_ERROR'));
        }
        $udata_id = input('udata_id', $this->getUdataId(), 'intval');
        if (empty($udata_id)) {
            return returnMsg(2, lang('PARAM_ERROR'));
        }
        $user = [
            'udata_id' => $udata_id,
        ];
        $orderModel = new Order();
        $result = $orderModel->orderFinish($order_sn, $user);
        if ($result === false) {
            return returnMsg(3, $orderModel->error);
        }
        return returnMsg(0, 'ok');
    }

    //用户下单
    public function order()
    {
        $actInfo=$this->checkActInfo();
        $sku_id = input('sku_id', 0, 'intval');
        if (empty($sku_id)) {
            return returnMsg(1, lang('PARAM_ERROR'));
        }
        $udata_id = input('udata_id', $this->getUdataId(), 'intval');
        if (empty($udata_id)) {
            return returnMsg(2, lang('PARAM_ERROR'));
        }
        $consignee = input('consignee', '', 'trim');//收货人姓名
        $phone = input('phone', '', 'trim');//收货人手机号码
        $region_name = input('region_name', '', 'trim');//收货人的地区
        $region_id = input('region_id', '', 'intval');//收货人的地区ID
        $address = input('address', '', 'trim');//收货人详细地址
        $remark = input('remark', '', 'trim');//买家备注
        if (empty($consignee)) {
            return returnMsg(1, '收货人信息不能为空');
        }
        if (empty($phone)) {
            return returnMsg(1, '收货人信息手机号码不能空');
        }
        $pattern = '/^(13[0-9]|14[0|9]|15[0-9]|167[0-9]|17[0-9]|18[0-9]|19[0-9])\d{8}$/';
        if (!preg_match($pattern, $phone)) {
            return returnMsg(1, '收货人信息手机号码不正确');
        }
        if ($region_id <= 0) {
            return returnMsg(1, '请选择收货人地区');
        }
        if (empty($address)) {
            return returnMsg(1, '请填写收货人详细地址');
        }
        if (empty($region_name)) {
            return returnMsg(2, lang('PARAM_ERROR'));
        }

        $orderModel = new Order();
        $count = $orderModel->alias('O')
            ->join('order_sku OS', 'O.order_sn=OS.order_sn')
            ->where([
                ['O.udata_id', '=', $udata_id],
                ['O.pay_status', '=', 1],
                ['OS.add_time', '>=', $actInfo['start_time']],
                ['OS.add_time', '<=', $actInfo['end_time']],
            ])->count();
        if ($count > 0) {
            return returnMsg(1, '活动期内每位用户只能购买1单');
        }

        $num = 1;//商品数量
        $submit = TRUE;//是否提交订单
        $params = [
            'address_name' => $consignee,
            'address_phone' => $phone,
            'region_id' => $region_id,
            'region_name' => $region_name,
            'address' => $address,
            'order_from'    => 4,//自有电商订单
            'order_source'  => 'every_nine_free',//自有订单:自有商城 mall/分销活动 fenxiao 逢九免单every_nine_free
        ];
        $orderType = 2;
        $user = [
            'udata_id' => $udata_id,
        ];
        $result = $orderModel->createOrder($user, 'goods', $sku_id, $num, $submit, $params, $remark, $orderType);
        if ($result === false) {
            return returnMsg(3, $orderModel->error);
        }
        return returnMsg(0, '下单成功，请完成微信支付', ['order_sn' => $result['order_sn']]);
    }


    //生成JSPay微信付款请求数据
    public function pay()
    {
        $actInfo=$this->checkActInfo();
        $order_sn = input('order_sn', '', 'trim');
        if (empty($order_sn)) {
            return returnMsg(1, lang('PARAM_ERROR'));
        }
        $orderInfo = Order::where(['order_sn' => $order_sn])->find();
        if (empty($orderInfo)) {
            return returnMsg(0, '订单信息不存在');
        }
        $udata_id = input('udata_id', $this->getUdataId(), 'intval');
        if (empty($udata_id)) {
            return returnMsg(2, lang('PARAM_ERROR'));
        }
        $thirdOpenid = db('user_data')->where(['udata_id' => $udata_id, 'third_type' => 'wechat_h5'])->value('third_openid');
        if (empty($thirdOpenid)) {
            return returnMsg(3, lang('wechat openid missing'));
        }
        $return = [
            'errCode' => 0,
            'errMsg' => 'ok',
        ];
        $factoryId = $this->factoryId;
        $order = [
            'openid' => $thirdOpenid,
            'order_sn' => $order_sn,
            'real_amount' => $orderInfo['real_amount'],
            'store_id' => $factoryId,
        ];
        $paymentApi = new \app\common\api\PaymentApi($factoryId, 'wechat_js');
        $result = $paymentApi->init($order);
        if ($result) {
            $return['data'] = $result;
        } else {
            $return['errCode'] = 1;
            $return['errMsg'] = $paymentApi->error;
        }
        return json($return);
    }


}