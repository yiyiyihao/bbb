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
        if (!in_array($this->adminUser['admin_type'], [ADMIN_SERVICE_NEW, ADMIN_DEALER])) {
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
        $field = 'C.cart_id,C.store_id,C.sku_id,C.goods_id,C.num,G.`name`,GS.price as price_service,  GS.install_price as install_price_service,GS.sku_name,GS.spec_value,GS.sku_sn,GS.sku_thumb,C.add_time,G.thumb,GS.spec_json';
        if ($this->adminStore['store_type'] == ADMIN_DEALER) {
            $field .= ',GSS.price_service, GSS.install_price_service, GSS.`status`';
        }
        return $field;
    }

    function _getJoin()
    {
        $join = [
            ['goods_sku GS', 'GS.sku_id= C.sku_id', 'INNER'],
            ['goods G', 'C.goods_id=G.goods_id', 'INNER'],
        ];
        if ($this->adminStore['store_type'] == ADMIN_DEALER) {
            $join[] = ['goods_sku_service GSS', 'GSS.sku_id=GS.sku_id AND GSS.is_del= 0 AND GSS.store_id=' . $this->adminStore['store_id'], 'INNER'];
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
