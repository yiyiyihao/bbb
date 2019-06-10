<?php
/**
 * 零售商接口
 */

namespace app\api\controller;


trait Dealer
{


    public function getService()
    {
        $user = $this->_checkUser();
        if ($user['store_type'] !== STORE_DEALER) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $service = db('store')
            ->alias('p1')
            ->field('p1.store_id,p1.name,p1.status,p1.check_status')
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
        return $service;
    }

    protected function _getModelList($model, $where = [], $field = '*', $order = false, $alias = false, $join = [], $group = false, $having = false)
    {
        if ($alias) $model->alias($alias);
        if ($join) $model->join($join);
        if ($where) $model->where($where);
        if ($having) $model->having($having);
        if ($order) $model->order($order);
        if ($group) $model->group($group);
        $data = [];
        if ($this->paginate && $this->pageSize > 0 && $this->page > 0) {
            $query = $model->where($where)->field($field)->paginate($this->pageSize, false, ['page' => $this->page]);
            $data = [
                'total'      => $query->total(),
                'page'       => $query->currentPage(),
                'page_size'  => $query->listRows(),
                'page_count' => $query->lastPage(),
                'list'       => $query->items(),
            ];
        } else {
            $data = $model->field($field)->select();
        }
        return $data;
    }


    //商品列表
    public function getDealerGoodsList()
    {
        $user = $this->_checkUser();
        if ($user['store_type'] !== STORE_DEALER) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '管理员类型错误']);
        }
        $service = $this->getService();
        $field = 'p2.goods_id,p2.name,p4.name cate_name,p2.goods_sn,p2.thumb,p3.stock_dealer,p3.sales_dealer,p3.status';
        $join = [
            ['goods p2', 'p1.goods_id = p2.goods_id'],
            ['goods_dealer p3', 'p3.goods_id = p2.goods_id', 'LEFT'],
            ['goods_cate p4', 'p4.cate_id = p2.cate_id', 'LEFT'],
        ];
        $where = [
            'p1.store_id' => $service['store_id'],
            'p1.is_del'   => 0,
            'p1.status'   => 1,
        ];
        $order = 'p1.sort_order ASC';
        $result = $this->_getModelList(db('goods_service'), $where, $field, $order, 'p1', $join);

        if (empty($result['list'])) {
            $this->_returnMsg($result);
        }
        $result['stock_sum'] = db('goods_sku_dealer')->where([
            'store_id' => $user['store_id'],
            'is_del'   => 0,
        ])->sum('stock');
        $field = 'p3.sku_sn,p3.spec_value,p2.sales,p2.stock';
        $join = [
            ['goods_sku_dealer p2', 'p1.sku_id = p2.sku_id AND p2.is_del = 0 AND p2.service_id = p1.store_id AND p2.store_id=' . $user['store_id']],
            ['goods_sku p3', 'p3.sku_id = p1.sku_id', 'LEFT'],
        ];
        $where = [
            'p1.is_del'   => 0,
            'p1.status'   => 1,
            'p1.store_id' => $service['store_id'],
            'p3.is_del'   => 0,
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
        $user = $this->_checkUser();
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
        $service = $this->getService();
        $field = 'p2.goods_id,p2.goods_sn,p2.name,p3.name AS cate_name,p2.thumb,p2.sales,p2.goods_stock stock,p4.status,p1.specs_json_service specs_json';
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
        $result = $this->_getModelList(db('goods_service'), $where, $field, $order, 'p1', $join);
        if (empty($result['list'])) {
            $this->_returnMsg(recursion($result));
        }
        foreach ($result['list'] as $key => $value) {
            $result['list'][$key]['specs_json'] = json_decode($value['specs_json'], true);
        }
        $this->_returnMsg(recursion($result));
    }


}