<?php
/**
 *
 * User: Administrator
 * Date: 2019/3/11 0011
 * Time: 12:14
 */

Route::domain('open', function () {
    Route::group('v10', function () {
        Route::rule('/cart/list',   'open/v10.order.cart/list');
        Route::rule('/cart/preview',   'open/v10.order.cart/preview');
        Route::rule('/cart/add',   'open/v10.order.cart/add');
        Route::rule('/cart/edit',   'open/v10.order.cart/edit');
        Route::rule('/cart/del',   'open/v10.order.cart/del');
        Route::rule('/cart/clear',   'open/v10.order.cart/clear');
        
        Route::rule('/goods/index',   'open/v10.goods.goods/index');
        Route::rule('/goods/list',   'open/v10.goods.goods/list');
        Route::rule('/goods/info',   'open/v10.goods.goods/info');
        Route::rule('/goods/getskus',   'open/v10.goods.goods/getskus');
        Route::rule('/goods/before_add',   'open/v10.goods.goods/beforeAdd');
        Route::rule('/goods/add',    'open/v10.goods.goods/add');
        Route::rule('/goods/edit',   'open/v10.goods.goods/edit');
        Route::rule('/goods/del',    'open/v10.goods.goods/del');
        
        
        Route::rule('/gcate/list',   'open/v10.goods.cate/list');
        Route::rule('/gcate/info',   'open/v10.goods.cate/info');
        Route::rule('/gcate/add',    'open/v10.goods.cate/add');
        Route::rule('/gcate/edit',   'open/v10.goods.cate/edit');
        Route::rule('/gcate/del',    'open/v10.goods.cate/del');
        
        Route::rule('/gspec/list',   'open/v10.goods.spec/list');
        Route::rule('/gspec/info',   'open/v10.goods.spec/info');
        Route::rule('/gspec/add',    'open/v10.goods.spec/add');
        Route::rule('/gspec/edit',   'open/v10.goods.spec/edit');
        Route::rule('/gspec/del',    'open/v10.goods.spec/del');
        
        Route::rule('/order/index',   'open/v10.order.order/index');//卖家订单列表
        Route::rule('/order/pay',   'open/v10.order.order/pay');//订单支付(买家/卖家)
        Route::rule('/order/delivery', 'open/v10.order.order/delivery');//订单发货(卖家)
        Route::rule('/order/finish', 'open/v10.order.order/finish');//订单完成(买家/卖家)
        
        
        Route::rule('/order/list',   'open/v10.order.order/list');//买家订单列表
        Route::rule('/order/info',   'open/v10.order.order/info');//订单详情(买家/卖家)
        Route::rule('/order/goods_create', 'open/v10.order.order/goods_create');//创建订单-商品直接购买(买家)
        Route::rule('/order/cart_create', 'open/v10.order.order/cart_create');//创建订单-购物车创建订单(买家)
        Route::rule('/order/cancel', 'open/v10.order.order/cancel');//订单取消(买家/卖家)
        
        //地区列表
        Route::any('region', 'v10.region/index');

        Route::get('demo', 'open/demo/index');
        //工单管理
        Route::group('work_order', function () {
            //工单列表
            Route::post('list', 'v10.work_order/index');
            //工单详情
            Route::post('info', 'v10.work_order/detail');
            //取消工单
            Route::post('cancel', 'v10.work_order/cancel');
            //评价工单
            Route::post('assess', 'v10.work_order/assess');
            //评价配置
            Route::post('assess_config', 'v10.work_order/assessConfig');
            //提交维修工单
            Route::post('add', 'v10.work_order/add');
            //可维修产品列表
            Route::post('goods', 'v10.work_order/goods');
        });
    });
})->middleware('OpenMiddleware');