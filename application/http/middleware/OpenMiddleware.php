<?php

namespace app\http\middleware;

use think\Request;

class OpenMiddleware
{
    public function handle(Request $request, \Closure $next)
    {
        $start = microtime(true);
        $addData = [
            'controller'     => $request->controller(),
            'request_time'   => microtime(true),
            'request_source' => 'open_api',
            'return_time'    => time(),
            'method'         => $request->method(),
            'request_params' => json_encode($request->param()),
            'return_params'  => '',
            'response_time'  => 0,
            'error'          => 0,
        ];
        $response = $next($request);
        $end = microtime(true);
        $data = $response->getData();
        $addData['error'] = isset($data['code']) ? $data['code'] : 0;
        $addData['msg'] = isset($data['msg']) ? $data['msg'] : '';
        $addData['response_time'] = $end - $start;
        $addData['return_params'] = json_encode($data);
        db('apilog_app')->insertGetId($addData);
        return $response;
    }
}
