<?php

namespace app\http\middleware;

use think\Request;

class OpenMiddleware
{
    public function handle(Request $request, \Closure $next)
    {
        $start = microtime(true);
        $addData = [
            'module'         => $request->module(),
            'controller'     => $request->controller(),
            'action'         => $request->action(),
            'request_time'   => microtime(true),
            'request_source' => 'open_api',
            'return_time'    => time(),
            'method'         => $request->method(),
            'request_params' => json_encode($request->param()),
            'return_params'  => '',
            'response_time'  => 0,
            'error'          => 0,
        ];
        $pageSize = $request->param('page_size', '10', 'intval');
        if ($pageSize > 50) {
            $response = json(dataFormat(100100, '单页显示数量不能大于50'));
        } else {
            $response = $next($request);
        }
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
