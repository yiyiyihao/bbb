<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------
// $header = [
//     'Access-Control-Allow-Origin'       => '*',
//     'Access-Control-Allow-Methods'      => 'POST,GET,OPTIONS',
//     'Access-Control-Allow-Headers'      => 'x-requested-with,echodata-token,content-type',
//     'Access-Control-Allow-Credentials'  => 'true',
//     'Access-Control-Expose-Headers'     => 'echodata-token',
// ];
// $origin = isset($_SERVER['HTTP_ORIGIN']) ? $_SERVER['HTTP_ORIGIN'] : '*';
// header('Access-Control-Allow-Origin:'.$origin);
// header('Access-Control-Allow-Methods:POST');
// header('Access-Control-Allow-Headers:x-requested-with,content-type');
// header('Access-Control-Allow-Credentials:true');
// echo 1;
// print_r($header);
Route::domain('www', 'index');
Route::domain('admin', 'admin');
Route::domain('api', 'api');
// ->header('Access-Control-Allow-Origin:'.'*')
// ->header('Access-Control-Allow-Methods:POST,GET,OPTIONS')
// ->header('Access-Control-Allow-Headers:x-requested-with,content-type')
// ->header('Access-Control-Allow-Credentials:true')
// ->allowCrossDomain();
Route::domain('ws', 'worker');
Route::domain('open', 'open');
Route::domain('dev', 'factory');
return [];
