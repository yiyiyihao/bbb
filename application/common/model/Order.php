<?php
namespace app\common\model;
use think\Model;

class Order extends Model
{
	public $error;
	protected $fields;
	protected $pk = 'order_id';

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
    /**
     * 获取购物车数据
     * @param array $user
     * @param array|int $skuIds
     * @param bool $incart
     * @param int $num
     * @return array
     */
    private function _getCartDatas($user = [], $incart = FALSE, $skuIds = [], $num = 0)
    {
        $userId = $user['user_id'];
        if ($incart) {
        }else{
            $where = [
                'sku_id' => intval($skuIds),
            ];
            $join = [['goods G', 'G.goods_id = S.goods_id', 'INNER']];
            $field = 'S.store_id, S.sku_id, G.goods_id, G.name, S.sku_name, S.price, S.install_price, '.$num.' as num, S.sku_thumb, G.thumb, S.sku_stock, S.spec_value, G.is_del as gdel, G.status as gstatus, S.status as sstatus, S.is_del as sdel';
            $list = db('GoodsSku')->alias('S')->join($join)->field($field)->where($where)->limit(1)->select();
            if (!$list) {
                $this->error = '产品不存在或已删除';
                return FALSE;
            }
        }
        $carts = $datas = $storeIds = [];
        $skuCount = $skuTotal = $deliveryAmount = $skuAmount = $payAmount = 0;
        if ($list) {
            $storeModel = db('store');
            $skuList = $skus = $storeAmounts = [];
            foreach ($list as $key => $value) {
                $storeIds[$value['store_id']] = $storeId = $value['store_id'];
                $skuList[] = $skuId = $value['sku_id'];
                $num = intval($value['num']);
                //商品库存为0/已删除/已禁用 则为 已失效
                $amount = 0;
                $disable = $unsale = 0;
                //判断购买数量是否大于库存数量
                if ($value['sku_stock'] <= 0 || $value['sku_stock'] < $num) {
                    $disable = 1; //库存不足
                }elseif($value['sdel'] || $value['gdel']|| !$value['gstatus']|| !$value['sstatus']){
                    $unsale = 1; //已下架
                }else{
                    $amount = $num * ($value['price'] + $value['install_price']);
                    $skuCount++;
                    $skuTotal = $skuTotal + $num;
                    $skuAmount = $skuAmount + $amount;
                }
                $value['pay_price'] = $value['price'] + $value['install_price'];
                if (isset($value['sku_thumb']) && $value['sku_thumb']) {
                    $value['sku_thumb'] = trim($value['sku_thumb']);
                }elseif (isset($value['thumb']) && $value['thumb']){
                    $value['sku_thumb'] = trim($value['thumb']);
                }else{
                    $value['sku_thumb'] = '';
                }
                $value['disable'] = $disable;
                $value['unsale'] = $unsale;
                unset($value['gdel'], $value['gstatus'],$value['sstatus'], $value['sdel'], $value['thumb']);
                $skus[$skuId] = $value;
            }
            $store = $storeModel->field('store_id, name')->where(['store_id' => $storeId])->find();
            $skuIds = !empty($skuIds) ? $skuIds : implode(',', $skuList);
            if (count($storeIds) > 1) {
                $this->error = '不允许跨厂商购买产品';
                return FALSE;
            }
            if (!$skus || !$storeIds) {
                $this->error = '请选择购买产品';
                return FALSE;
            }
        }
        $payAmount = $skuAmount;
        $allAmount = $skuAmount + $deliveryAmount;
        $return = [
            'list'      => $skus,                  //商品列表
            'sku_total' => intval($skuTotal),       //商品总数量
            'sku_count' => intval($skuCount),       //商品种类数量(不重复)
            'all_amount'        => sprintf("%.2f",$allAmount),      //商品总金额
            'delivery_amount'   => sprintf("%.2f",$deliveryAmount), //物流费用
            'sku_amount'        => sprintf("%.2f",$skuAmount),      //商品总金额
            'pay_amount'        => sprintf("%.2f",$payAmount),      //需支付金额
            'sku_ids'           => $skuIds,
            'store_id'          => $storeId,
        ];
        return $return;
    }
    
    public function createOrder($userId, $from, $skuId, $num, $submit = FALSE, $addr = [])
    {
        $userModel = new \app\common\model\User();
        $user = $userModel->_checkUser($userId);
        if ($user === FALSE) {
            $this->error = $userModel->error;
            return FALSE;
        }
        if ($from == 'goods') {
            $goodsModel = new \app\common\model\Goods();
            $sku = $goodsModel->_checkSku($skuId);
            if ($sku === FALSE) {
                $this->error = $goodsModel->error;
                return FALSE;
            }
            if ($num <= 0) {
                $this->error = '产品购买数量必须大于0';
                return FALSE;
            }
            //判断产品库存
            if ($sku['sku_stock'] < $num) {
                $this->error = '产品库存限制('.$sku['sku_stock'].')';
                return FALSE;
            }
            $incart = FALSE;
        }else{
            $this->error = '订单来源错误';
            return FALSE;
        }
        $list = $this->_getCartDatas($user, $incart, $skuId, $num);
        if ($list === FALSE) {
            return FALSE;
        }
        if (!$submit) {
            return $list;
        }else{
            $storeId = $list['store_id'];
            //收货地址
            $addrName = isset($addr['name']) && $addr['name'] ? trim($addr['name']) : '';
            $addrPhone = isset($addr['phone']) && $addr['phone'] ? trim($addr['phone']) : '';
            $addrRegion = isset($addr['region_name']) && $addr['region_name'] ? trim($addr['region_name']) : '';
            $addrDetail = isset($addr['address']) && $addr['address'] ? trim($addr['address']) : '';
            if (!$addrName || !$addrPhone || !$addrRegion || !$addrDetail) {
                $this->error = '收货人姓名/电话/地址 不能为空';
                return FALSE;
            }
            if ($list['all_amount'] <= 0) {
                $this->error = '订单支付金额不能小于等于0';
                return FALSE;
            }
            //创建订单
            $orderSn = $this->_getOrderSn();
            $data = [
                'order_sn'      => $orderSn,
                'store_id'      => $storeId,
                'user_id'       => $user['user_id'],
                'user_store_id' => $user['store_id'] && isset($user['store']) ? $user['store']['store_id'] : 0,
                'goods_amount'  => $list['all_amount'],
                'delivery_amount'=> $list['delivery_amount'],
                'real_amount'   => $list['pay_amount'],
                'address_name'  => $addr['name'],
                'address_phone' => $addr['phone'],
                'address_detail'=> $addr['region_name'].' '.$addr['address'],
                'add_time'      => time(),
                'update_time'   => time(),
                'extra'         => '',
            ];
            pre($data);
            $orderModel = db('order');
            $orderSubModel = db('order_sub');
            $orderSkuModel = db('order_sku');
            $orderLogModel = db('order_log');
            $database = new \think\Db;
            $database::startTrans();
            try{
                $skus = $storeIdArray = $cartIds = [];
                $orderId = $orderModel->insertGetId($data);
                if ($orderId === false) {
                    $this->_returnMsg(['errCode' => 1, 'errMsg' =>  '订单创建失败']);
                }
                foreach ($carts['list'] as $key => $value) {
                    $storeId = $key;
                    $storeIdArray[$storeId] = $storeId;
                    $subSn = $this->_buildOrderSn(TRUE);
                    $subData = [
                        'sub_sn'        => $subSn,
                        'user_id'       => $user['user_id'],
                        'order_id'      => $orderId,
                        'order_sn'      => $orderSn,
                        'store_id'      => $storeId,
                        'goods_amount'  => $value['detail']['sku_amount'],
                        'delivery_amount' => $value['detail']['delivery_amount'],
                        'real_amount'   => $value['detail']['pay_amount'],
                        'add_time'      => time(),
                        'update_time'   => time(),
                    ];
                    $subId = $orderSubModel->insertGetId($subData);
                    if (!$subId) {
                        break;
                    }
                    if ($value) {
                        foreach ($value['skus'] as $k1 => $v1) {
                            $goodsAmount = $v1['num']*$v1['price'];
                            $deliveryAmount = isset($v1['delivery_amount']) ? $v1['delivery_amount'] : 0;
                            $skuInfo = $this->getGoodsDetail($v1['goods_id']);
                            $skuData = [
                                'sub_id'        => $subId,
                                'sub_sn'        => $subSn,
                                'user_id'       => $user['user_id'],
                                'store_id'      => $storeId,
                                'order_id'      => $orderId,
                                'order_sn'      => $orderSn,
                                
                                'goods_id'      => $v1['goods_id'],
                                'sku_id'        => $v1['sku_id'],
                                'sku_name'      => $v1['name'],
                                'sku_thumb'     => $skuInfo['thumb'] ? $skuInfo['thumb'] : '',
                                //                                 'sku_spec'      => $v1['sku_name'],
                                'sku_spec'      => $v1['spec_value'],
                                'sku_info'      => $skuInfo ? json_encode($skuInfo) : '',
                                'num'           => $v1['num'],
                                'price'         => $v1['price'],
                                'pay_price'     => $v1['pay_price'],
                                'delivery_amount' => $deliveryAmount,
                                'real_amount'   => $goodsAmount+$deliveryAmount,
                                
                                'add_time'      => time(),
                                'update_time'   => time(),
                            ];
                            $oskuId = $orderSkuModel->insertGetId($skuData);
                            if (!$oskuId) {
                                break;
                            }
                            $skus[$k1] = [
                                'sku_id'    => $v1['sku_id'],
                                'goods_id'  => $v1['goods_id'],
                                'num'       => $v1['num'],
                            ];
                            if (isset($v1['cart_id']) && $v1['cart_id']) {
                                $cartIds[] = $v1['cart_id'];
                            }
                        }
                        $logId = $orderService->orderLog($subData, $user, '创建订单', '提交购买商品并生成订单');
                        $trackId = $orderService->orderTrack($subData, 0, '订单已提交, 系统正在等待付款');
                    }
                }
                $storeIdArray = $storeIdArray ? array_filter($storeIdArray) : [];
                $storeIds = $storeIdArray ? implode(',', $storeIdArray) : '';
                if ($storeIds) {
                    $result = $orderModel->where(['order_id' => $orderId])->update(['store_ids' => $storeIds]);
                }
                $database::commit();
                if ($from == 'goods' || ($this->reduceStock == 2 && $skus)) {
                    $goodsModel = new \app\common\model\Goods();
                    foreach ($skus as $key => $value) {
                        $result = $goodsModel->_setGoodsStock($value, -$value['num']);
                    }
                }
                if ($from == 'cart' && $skus && $cartIds) {
                    //清理购物车商品
                    $cartIds = implode(',', $cartIds);
                    $result = $this->delCartSku($cartIds, true);
                }
                $this->_returnMsg(['order_sn' => $orderSn, 'msg' => '订单创建成功']);
            }catch(\Exception $e){
                $error = $e->getMessage();
                $database::rollback();
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '订单创建失败 '.$error]);
            }
        }
    }
    
    /**
     * 订单日志记录操作
     * @param array $order
     * @param array $user
     * @param string $action
     * @param string $msg
     * @return number|string
     */
    public function _orderLog($order, $user, $action = '', $msg = '')
    {
        $nickname = isset($user['realname']) && $user['realname'] ? $user['realname'] : (isset($user['nickname']) && $user['nickname'] ? $user['nickname'] : (isset($user['username']) && $user['username'] ? $user['username'] : ''));
        $data = [
            'order_id' => $order['order_id'],
            'order_sn' => $order['order_sn'],
            'user_id'   => $user['user_id'],
            'nickname'  => $nickname,
            'action'    => $action,
            'msg'       => $msg,
            'add_time'  => time(),
        ];
        return $result = db('work_order_log')->insertGetId($data);
    }
    private function _getOrderSn($sn = '')
    {
        $sn = $sn ? $sn : date('YmdHis').get_nonce_str(6, 2);
        //判断订单号是否存在
        $info = $this->where(['order_sn' => $sn])->find();
        if ($info){
            return $this->_getOrderSn();
        }else{
            return $sn;
        }
    }
    private function _checkorder($orderId = 0, $userId = 0)
    {
        if (!$orderId) {
            $this->error = '参数错误';
            return FALSE;
        }
        $info = $this->where(['order_id' => $orderId, 'is_del' => 0])->find();
        if(!$info){
            $this->error = '订单不存在或已删除';
            return FALSE;
        }
        if ($userId > 0) {
            $user = db('user')->where(['user_id' => $userId, 'is_del' => 0])->find();
            if (!$user) {
                $this->error = '操作用户不存在或已删除';
                return FALSE;
            }
            if ($user['status'] != 1) {
                $this->error = '操作用户已禁用';
                return FALSE;
            }
        }else{
            $user = [
                'user_id' => 0,
                'nickname' => '系统',
            ];
        }
        #TODO判断用户是否有操作权限
        return [
            'order' => $info,
            'user' => $user,
        ];
    }
}