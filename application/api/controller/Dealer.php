<?php
/**
 * 零售商接口
 */

namespace app\api\controller;


use app\common\model\GoodsDealer;
use app\common\model\GoodsSkuDealer;
use app\common\model\WorkOrder;
use app\common\model\WorkOrderLog;

trait Dealer
{

    private $service;
    private $user;

    private function init()
    {
        $user = $this->_checkUser();
        if ($user['store_type'] !== STORE_DEALER) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $this->user = $user;
        $service = db('store')
            ->alias('p1')
            ->field('p1.store_id,p1.`name`,p1.status,p1.check_status')
            ->join('store_dealer p2', 'p2.ostore_id=p1.store_id')
            ->where([
                'p2.store_id' => $user['store_id'],
                'p1.is_del'   => 0,
            ])->find();
        if (empty($service)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务商不存在或已删除']);
        }
        if ($service['status'] == 0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务商已被禁用']);
        }
        if ($service['check_status'] !== 1) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '服务商审核未通过']);
        }
        $this->service = $service;
        return $service;
    }

    private function getModelList($model, $where = [], $field = '*', $order = false, $alias = false, $join = [], $group = false, $having = false)
    {
        if ($alias) $model->alias($alias);
        if ($field) $model->field($field);
        if ($join) $model->join($join);
        if ($where) $model->where($where);
        if ($having) $model->having($having);
        if ($order) $model->order($order);
        if ($group) $model->group($group);
        $data = [];
        if ($this->paginate && $this->pageSize > 0 && $this->page > 0) {
            $query = $model->paginate($this->pageSize, false, ['page' => $this->page]);
            $data = [
                'total'      => $query->total(),
                'page'       => $query->currentPage(),
                'page_size'  => $query->listRows(),
                'page_count' => $query->lastPage(),
                'list'       => $query->items(),
            ];
        } else {
            $data = $model->select();
        }
        return $data;
    }


    //门店商品列表
    public function getDealerGoodsList()
    {
        $this->init();
        $user = $this->user;
        $service = $this->service;
        $field = 'p2.goods_id,p2.`name`,p4.`name` cate_name,p2.goods_sn,p2.thumb,p3.stock_dealer,p3.sales_dealer,p3.status';
        $join = [
            ['goods p2', 'p1.goods_id = p2.goods_id'],
            ['goods_dealer p3', 'p3.goods_id = p2.goods_id'],
            ['goods_cate p4', 'p4.cate_id = p2.cate_id'],
        ];
        $where = [
            'p1.store_id' => $service['store_id'],
            'p1.is_del'   => 0,
            'p1.status'   => 1,
        ];
        $order = 'p1.sort_order ASC';
        $result = $this->getModelList(db('goods_service'), $where, $field, $order, 'p1', $join);

        if (empty($result['list'])) {
            $this->_returnMsg($result);
        }
        $result['stock_sum'] = db('goods_sku_dealer')->where([
            'store_id' => $user['store_id'],
            'is_del'   => 0,
        ])->sum('stock_dealer');
        $field = 'p2.sku_id,p3.sku_sn,p3.spec_value,p2.sales_dealer,p2.stock_dealer';
        $join = [
            ['goods_sku_dealer p2', 'p1.sku_id = p2.sku_id AND p2.service_id = p1.store_id'],
            ['goods_sku p3', 'p3.sku_id = p1.sku_id', 'LEFT'],
        ];
        $where = [
            'p1.is_del'   => 0,
            'p2.is_del'   => 0,
            'p3.is_del'   => 0,
            'p1.status'   => 1,
            'p2.status'   => 1,
            'p1.store_id' => $service['store_id'],
            'p2.store_id' => $user['store_id'],
        ];
        foreach ($result['list'] as $key => $value) {
            $where['p1.goods_id'] = $value['goods_id'];
            $detail = db('goods_sku_service')
                ->alias('p1')
                ->field($field)
                ->join($join)
                ->where($where)
                ->order('p1.sort_order ASC')
                ->select();
            unset($result['list'][$key]['goods_id']);
            $result['list'][$key]['detail'] = $detail;
        }
        $this->_returnMsg(recursion($result));
    }

    //采购列表
    public function getPurchaseList()
    {
        $this->init();
        $user = $this->user;
        if ($user['store_type'] !== STORE_DEALER) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $keyword = isset($this->postParams['keyword']) && $this->postParams['keyword'] ? trim($this->postParams['keyword']) : '';
        //0 最新，1售量，2价格
        $sort = isset($this->postParams['sort']) && $this->postParams['sort'] ? intval($this->postParams['sort']) : 0;
        //0升序，1倒序
        $order = isset($this->postParams['order']) && $this->postParams['order'] ? intval($this->postParams['order']) : 1;

        if (!in_array($sort, [0, 1, 2])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请求参数错误[SORT]']);
        }
        if (!in_array($order, [0, 1])) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请求参数错误[ORDER]']);
        }
        if ($sort == 0) {
            $orderBy = 'p1.update_time DESC';
        } elseif ($sort == 1) {
            $orderBy = 'p2.sales ' . ($order == 1 ? "DESC" : "ASC");
        } elseif ($sort == 2 && $order == 0) {
            $orderBy = 'p1.min_price_service ASC';
        } elseif ($sort == 2 && $order == 1) {
            $orderBy = 'p1.max_price_service DESC';
        }
        $service = $this->init();
        $field = 'p2.goods_id,p2.goods_sn,p2.`name`,p3.`name` AS cate_name,p2.thumb,p1.sales_service,p1.stock_service,p4.status,p1.specs_json_service specs_json';
        $join = [
            ['goods p2', 'p1.goods_id=p2.goods_id'],
            ['goods_cate p3', 'p2.cate_id=p3.cate_id'],
            ['goods_dealer p4', 'p4.goods_id=p1.goods_id AND p4.service_id=p1.store_id AND p4.is_del=0 AND p4.store_id=' . $user['store_id'], 'LEFT'],
        ];
        $where = [
            'p1.is_del'   => 0,
            'p2.is_del'   => 0,
            'p3.is_del'   => 0,
            'p1.status'   => 1,
            'p2.status'   => 1,
            'p1.store_id' => $service['store_id'],
        ];
        if ($keyword !== '') {
            $where['p2.name'] = ['like', '%' . $keyword . '%'];
        }
        $order = 'p1.sort_order ASC';
        $result = $this->getModelList(db('goods_service'), $where, $field, $order, 'p1', $join);
        if (empty($result['list'])) {
            $this->_returnMsg(recursion($result));
        }
        foreach ($result['list'] as $key => $value) {
            $result['list'][$key]['specs_json'] = json_decode($value['specs_json'], true);
        }
        $this->_returnMsg(recursion($result));
    }

    public function getSpecDetail()
    {
        $this->init();
        $user = $this->user;
        $service = $this->service;
        $specs = isset($this->postParams['specs']) && $this->postParams['specs'] ? trim($this->postParams['specs']) : '';
        $id = isset($this->postParams['goods_id']) && $this->postParams['goods_id'] ? trim($this->postParams['goods_id']) : '';
        //0：客户下单，1:门店进货
        $type = isset($this->postParams['type']) && $this->postParams['type'] ? intval($this->postParams['type']) : 0;
        $result = [
            'stock' => 0,
            'sales' => 0,
        ];
        $skuId = db('goods_sku')->where([
            'goods_id'  => $id,
            'is_del'    => 0,
            'status'    => 1,
            'store_id'  => $user['factory_id'],
            'spec_json' => $specs,
        ])->value('sku_id');
        if (empty($skuId)) {
            $this->_returnMsg(recursion($result));
        }
        switch ($type) {
            case 0://客户下单
                $data = db('goods_sku_dealer')
                    ->field('stock_dealer stock,sales_dealer sales')
                    ->where([
                        'sku_id'     => $skuId,
                        'is_del'     => 0,
                        'status'     => 1,
                        'service_id' => $service['store_id'],
                        'store_id'   => $user['store_id'],
                    ])->find();
                break;
            case 1://门店进货
                $data = db('goods_sku_service')
                    ->field('stock_service stock,sales_service sales')
                    ->where([
                        'sku_id'   => $skuId,
                        'is_del'   => 0,
                        'status'   => 1,
                        'store_id' => $service['store_id'],
                    ])->find();
                break;
        }
        $result = $data ? $data : $result;
        $result['stock'] = $result['stock'] > 0 ? $result['stock'] : 0;
        $this->_returnMsg(recursion($result));
    }

    //零售商商品上架-基于商品goods_id全部上架
    public function dealerGoodsOnSale()
    {
        $this->init();
        $user = $this->user;
        $service = $this->service;
        $goodsId = isset($this->postParams['goods_id']) ? $this->postParams['goods_id'] : '';
        if ($goodsId < 0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请求参数错误']);
        }
        $goodServiceSku = db('goods_sku_service')->where([
            'store_id' => $service['store_id'],
            'goods_id' => $goodsId,
            'is_del'   => 0,
            'status'   => 1,
        ])->select();
        if (empty($goodServiceSku)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品不存在或已经下架，请联系服务商']);
        }
        $max = 0;
        $min = 0;
        foreach ($goodServiceSku as $value) {
            $price = $value['price_service'] + $value['install_price_service'];
            if ($price > $max) {
                $max = $price;
            }
            if ($min == 0) {
                $min = $price;
            }
            if ($price < $min) {
                $min = $price;
            }
            $goodsDealerSku = GoodsSkuDealer::where([
                'service_id' => $service['store_id'],
                'store_id'   => $user['store_id'],
                'sku_id'     => $value['sku_id'],
                'goods_id'   => $value['goods_id'],
                'is_del'     => 0,
            ])->find();
            $where = [];
            if (!empty($goodsDealerSku)) {
                $where = ['id' => $goodsDealerSku['id']];
            }
            $data = [
                'factory_id'   => $user['factory_id'],
                'service_id'   => $service['store_id'],
                'store_id'     => $user['store_id'],
                'goods_id'     => $value['goods_id'],
                'sku_id'       => $value['sku_id'],
                'price_dealer' => $price,
                'status'       => 1,
                'is_del'       => 0,
            ];
            $result = (new GoodsSkuDealer)->save($data, $where);
            if ($result === false) {
                $this->_returnMsg(['errCode' => 1, 'errMsg' => '系统故障，上架失败']);
            }
        }
        $goodsDealer = GoodsDealer::where([
            'factory_id' => $user['factory_id'],
            'service_id' => $service['store_id'],
            'store_id'   => $user['store_id'],
            'goods_id'   => $goodsId,
            'is_del'     => 0,
        ])->find();
        $where = [];
        if (!empty($goodsDealer)) {
            $where = ['id' => $goodsDealer['id']];
        }
        $data = [
            'factory_id'       => $user['factory_id'],
            'service_id'       => $service['store_id'],
            'store_id'         => $user['store_id'],
            'goods_id'         => $goodsId,
            'min_price_dealer' => $min,
            'max_price_dealer' => $max,
            'is_del'           => 0,
            'status'           => 1,
            'is_del'           => 0,
        ];
        $result = (new GoodsDealer())->save($data, $where);
        if ($result === false) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '系统故障，上架失败']);
        }
        $this->_returnMsg(['msg' => '上架成功']);
    }

    //更新库存
    public function dealerUpdateStock()
    {
        $this->init();
        $user = $this->user;
        $service = $this->service;
        $skuId = isset($this->postParams['sku_id']) ? $this->postParams['sku_id'] : [];
        $stock = isset($this->postParams['stock']) ? $this->postParams['stock'] : [];
        if (empty($skuId)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品规格不能空']);
        }

        if (empty($stock)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '库存数量不能空']);
        }

        if (count($skuId) != count($stock)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品规格与库存对应不正确']);
        }
        foreach ($skuId as $k => $v) {
            if ($v < 0) {
                continue;
            }
            $result = GoodsSkuDealer::where([
                'service_id' => $service['store_id'],
                'store_id'   => $user['store_id'],
                'sku_id'     => $v,
                'is_del'     => 0,
            ])->find();
            if (empty($result)) {
                continue;
            }
            $result->stock_dealer = isset($stock[$k]) && $stock[$k] > 0 ? $stock[$k] : 0;
            $result->save();
        }
        $this->_returnMsg(['msg' => '更新成功']);
    }

    //零售商商品下架-基于商品goods_id全部下架
    public function dealerGoodsOffSale()
    {
        $this->init();
        $user = $this->user;
        $service = $this->service;
        $goodsId = isset($this->postParams['goods_id']) ? $this->postParams['goods_id'] : '';
        if ($goodsId < 0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '请求参数错误']);
        }
        $goodsDealer = GoodsDealer::where([
            'factory_id' => $user['factory_id'],
            'service_id' => $service['store_id'],
            'store_id'   => $user['store_id'],
            'goods_id'   => $goodsId,
            'is_del'     => 0,
        ])->find();
        if (empty($goodsDealer)) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品不存在或已删除']);
        }
        if ($goodsDealer->status == 0) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '商品已下架']);
        }
        $goodsDealer->status = 0;
        if ($goodsDealer->save() === false) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '系统故障，下架失败']);
        }
        $result = GoodsSkuDealer::where([
            'service_id' => $service['store_id'],
            'store_id'   => $user['store_id'],
            'goods_id'   => $goodsId,
            'is_del'     => 0,
        ])->update([
            'status'      => 0,
            'update_time' => time(),
        ]);
        if ($result === false) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '系统故障，下架失败']);
        }
        $this->_returnMsg(['msg' => '下架成功']);
    }


    //工单列表
    public function getDealerWorkOrderList()
    {
        $this->init();
        $user = $this->user;
        $status = isset($this->postParams['status']) ? $this->postParams['status'] : '';
        $where = [
            'p1.is_del'        => 0,
            'p1.status'        => 1,
            'p1.post_store_id' => $user['store_id'],
        ];
        if ($status !== '' && in_array($status, [-1, 0, 1, 2, 3, 4])) {
            $where['p1.work_order_status'] = $status;
        }
        $field = 'p1.worder_sn,p1.work_order_status,p2.thumb,p3.`name` cate_name,p2.`name` goods_name,p2.goods_sn,p1.user_name';
        $field .= ',p1.phone,p1.region_name,p1.address,p1.appointment,p1.appointment_confirm,p4.mobile store_phone';
        $join = [
            ['goods p2', 'p1.goods_id = p2.goods_id'],
            ['goods_cate p3', 'p3.cate_id = p2.cate_id'],
            ['store p4', 'p4.store_id = p1.store_id'],
        ];
        $order = 'p1.add_time ASC';
        $result = $this->getModelList(db('work_order'), $where, $field, $order, 'p1', $join);
        foreach ($result['list'] as $k => $v) {
            $appointment = $v['appointment_confirm'] ? $v['appointment_confirm'] : $v['appointment'];
            $result['list'][$k]['appointment'] = time_to_date($appointment);
            $result['list'][$k]['address'] = str_replace(' ', '', $v['region_name']) . $v['address'];
            $result['list'][$k]['status'] = get_work_order_status($v['work_order_status']);
            unset($result['list'][$k]['appointment_confirm'], $result['list'][$k]['region_name'], $result['list'][$k]['work_order_status']);
        }
        $this->_returnMsg(recursion($result));
    }

    //工单详情
    public function getDealerWorkOrderDetail()
    {
        $this->init();
        $user = $this->user;
        $service = $this->service;
        $worderSn = isset($this->postParams['worder_sn']) ? $this->postParams['worder_sn'] : '';
        $field = 'p1.worder_id,p1.worder_sn,p1.goods_id,p1.sku_id,p1.work_order_type,p1.work_order_status,p1.user_name,p1.phone,p1.appointment,p1.appointment_confirm,p1.region_name,p1.address,p2.cate_id';
        $workOrder = new WorkOrder;
        $result['work_info'] = $workOrder
            ->alias('p1')
            ->field($field)
            ->join([
                ['goods p2', 'p2.goods_id=p1.goods_id'],
                ['goods_sku p3', 'p3.sku_id=p1.sku_id', 'LEFT'],
            ])
            ->where([
                'p1.worder_sn'     => $worderSn,
                'p1.is_del'        => 0,
                'p1.status'        => 1,
                'p1.post_store_id' => $user['store_id'],
            ])->find();
        if (!$result['work_info']) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '工单不存在']);
        }
        $config = $workOrder->getConfigLogDetail([
            'work_order_type' => $result['work_info']['work_order_type'],
            'worder_id'       => $result['work_info']['worder_id'],
            'cate_id'         => $result['work_info']['cate_id'],
            'factory_id'      => $user['factory_id'],
        ]);
        $result['work_info']['appointment']=time_to_date($result['work_info']['appointment'],'Y-m-d H:i');
        $result['work_info']['appointment_confirm']=time_to_date($result['work_info']['appointment_confirm'],'Y-m-d H:i');
        unset($result['work_info']['worder_id']);
        unset($result['work_info']['goods_id']);
        unset($result['work_info']['sku_id']);
        unset($result['work_info']['cate_id']);
        $addInfo = array_shift($config);
        $result['work_info']['add_info'] = $addInfo;
        $result['worker_post_info'] = array_shift($config);
        $result['assess_info'] = array_shift($config);
        $result['score_info'] = array_shift($config);

        $field = 'p1.name,p4.sku_sn,p4.spec_value,p3.real_price,p5.delivery_type,p1.thumb';
        $join = [
            ['work_order p2', 'p1.goods_id = p2.goods_id'],
            ['order_sku p3', 'p3.order_sn = p2.order_sn AND p2.sku_id = p3.sku_id', 'LEFT'],
            ['goods_sku p4', 'p2.sku_id = p4.sku_id', 'LEFT'],
            ['order p5', 'p5.order_sn = p2.order_sn', 'LEFT'],
        ];
        $goods = db('goods')->alias('p1')->field($field)->join($join)->where([
            'p2.worder_sn'=>$worderSn
        ])->find();
        $result['goods_info'] = $goods;
        $log= WorkOrderLog::field('add_time,nickname,action,msg')->where(['worder_sn'=>$worderSn])->order('add_time DESC')->select();
        $result['work_log'] =$log;
        $this->_returnMsg(recursion($result));

    }


}