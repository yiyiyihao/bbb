<?php
namespace app\common\service;
use GatewayClient\Gateway;

//消息推送底层控制器
class PushBase extends Gateway
{
    // 设置GatewayWorker服务的Register服务ip和端口，请根据实际情况改成实际值(ip不能是0.0.0.0)
    static $registerAddress = '127.0.0.1:1236';
    
    /**
     * 绑定用户
     */
    public function bind(){
        // 假设用户已经登录，用户uid和群组id在session中
        $uid      = $_SESSION['uid'];
        $group_id = $_SESSION['group'];
        $client_id = '';
        // client_id与uid绑定
        Gateway::bindUid($client_id, $uid);
        // 加入某个群组（可调用多次加入多个群组）
        Gateway::joinGroup($client_id, $group_id);
    }
    
    /**
     * 发送消息
     */
    public function sendMessage(){        
        // 向任意uid的网站页面发送数据
        //Gateway::sendToUid($uid, $message);
        // 向任意群组的网站页面发送数据
        //Gateway::sendToGroup($group, $message);
    }
}