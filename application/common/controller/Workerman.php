<?php
namespace app\common\controller;
use think\worker\Server;

//workerman消息服务管理
class Workerman extends Server
{
    protected $socket = 'http://0.0.0.0:8383';
    
    /**
     * 监听收到消息
     * @param $connection
     * @param $data
     */
    public function onMessage($connection,$data)
    {
        $connection->send(json_encode($data));
    }
}