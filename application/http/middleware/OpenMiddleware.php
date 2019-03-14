<?php

namespace app\http\middleware;

use think\Request;

class OpenMiddleware
{
    public function handle(Request $request, \Closure $next)
    {
        $addData = [
            'controller'     => $request->controller(),
            'request_time'   => microtime(true),
            'request_source' => 'open',
            'return_time'    => time(),
            'method'         => $request->method(),
            'request_params' => json_encode($request->param()),
            'return_params'  => '',
            'response_time'  => 0,
            'error'          => 0,
        ];
        log_msg($request->param(), 'start');
        $addData['response_time'] = microtime(true) - $addData['request_time'];
        //log_msg($response->getData(), 'end');
        //$addData['return_params'] = $response->getData();
        //db('apilog_app')->insertGetId($addData);
        $response = $next($request);
        return $response;
    }
}
