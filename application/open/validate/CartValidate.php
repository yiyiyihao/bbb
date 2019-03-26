<?php

namespace app\open\validate;

use think\Validate;

class CartValidate extends Validate
{
    /**
     * 定义验证规则
     * 格式：'字段名'    =>    ['规则1','规则2'...]
     *
     * @var array
     */
    protected $rule = [];

    /**
     * 定义错误信息
     * 格式：'字段名.规则名'    =>    '错误信息'
     *
     * @var array
     */
    protected $message = [];


    //添加到购物车
    public function sceneAdd()
    {
        return $this->only(['sku_id', 'num'])
            ->append('sku_id', 'require|number')
            ->append('num|购买数量', 'require|number');

    }

    //删除购物车商品
    public function sceneDel()
    {
        return $this->only(['cart_id'])
            ->append('cart_id', 'require');
    }

    //修改购物车商品
    public function sceneEdit()
    {
        return $this->only(['cart_id'])
            ->append('cart_id', 'require|number')
            ->append('num|购买数量', 'require|number');
    }

    //购物车商品预览
    public function scenePreview()
    {
        return $this->only(['sku_ids'])
            ->append('sku_ids', 'require');
    }

}
