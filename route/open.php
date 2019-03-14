<?php
/**
 *
 * User: Administrator
 * Date: 2019/3/11 0011
 * Time: 12:14
 */

Route::domain('open', function () {
    Route::group('v10', function () {
        //地区列表
        Route::any('region', 'v10.region/index');

        Route::get('demo', 'open/demo/index');
        //工单管理
        Route::group('work_order', function () {
            //工单列表
            Route::post('index', 'v10.work_order/index');
            //工单详情
            Route::post('detail', 'v10.work_order/detail');
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