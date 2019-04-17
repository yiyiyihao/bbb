<?php

namespace app\factory\controller;

use think\Controller;
use think\Request;

class Cart extends FactoryForm
{
    public function __construct()
    {
        $this->modelName = 'cart';
        $this->model = db($this->modelName);
        parent::__construct();
        if (!in_array($this->adminUser['admin_type'], [ADMIN_SERVICE_NEW, ADMIN_DEALER,ADMIN_FACTORY])) {
            $this->error(lang('NO ACCESS'));
        }

    }

    public function num()
    {
        if ($this->request->isAjax()) {
            $id = $this->request->post('id', 0, 'intval');
            $num = $this->request->param('num', 0, 'intval');
            if ($id > 0 && $num > 0) {
                $result = $this->model->update([
                    'cart_id'     => $id,
                    'num'         => $num,
                    'update_time' => time(),
                ]);
                if ($result !== false) {
                    $this->success('操作成功');
                }
            }
        }
        $this->error('操作失败');
    }

    function _getAlias()
    {
        return 'C';
    }

    function _getField()
    {
        //GS.price, GS.install_price, GS.price as price_service,  GS.install_price as install_price_service,
        $field = 'C.cart_id,C.store_id,C.sku_id,C.goods_id,C.num,G.`name`,GS.sku_name,GS.spec_value,GS.sku_sn,GS.sku_thumb,C.add_time,G.thumb,GS.spec_json';
        if ($this->adminStore['store_type'] == STORE_DEALER) {//零售商
            $field.=',(GSS.price_service+GSS.install_price_service) price';
        }elseif ($this->adminStore['store_type'] == STORE_SERVICE_NEW) {//服务商
            $field.=',GS.price';
        }elseif (in_array($this->adminUser['group_id'], [GROUP_E_COMMERCE_KEFU, GROUP_E_CHANGSHANG_KEFU])) {//客服
            $field.=',(GS.price+GS.install_price) price';
        }
        return $field;
    }

    function _getJoin()
    {
        $join = [
            ['goods_sku GS', 'GS.sku_id= C.sku_id', 'INNER'],
            ['goods G', 'C.goods_id=G.goods_id', 'INNER'],
        ];
        if ($this->adminStore['store_type'] == STORE_DEALER) {
            $where=[
                ['SD.store_id','=',$this->adminStore['store_id']],
                ['S.status', '=', 1],
                ['S.is_del', '=', 0],
                ['S.store_type', '=', STORE_SERVICE_NEW],
            ];
            $channel=db('store_dealer')
                ->alias('SD')
                ->field('S.store_id,S.store_type')
                ->join('store S','S.store_id=SD.ostore_id')
                ->where($where)
                ->find();
            if (empty($channel)) {
                $this->error('服务商不存或已被禁用');
            }
            $join[] = ['goods_sku_service GSS', 'GSS.sku_id=GS.sku_id AND GSS.is_del= 0 AND GSS.store_id='.$channel['store_id'], 'LEFT'];
        }
        return $join;
    }


    function _getWhere()
    {
        $where = [
            'C.is_del'   => 0,
            'C.status'   => 1,
            'C.store_id' => $this->adminStore['store_id'],
        ];
        return $where;
    }

    public function _getOrder()
    {
        return 'C.update_time DESC,C.cart_id DESC';
    }

    public function _afterList($list = [])
    {
        //p($list);
        return $list;
    }
}