<?php
/**
 * This file is part of workerman.
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the MIT-LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author walkor<walkor@workerman.net>
 * @copyright walkor<walkor@workerman.net>
 * @link http://www.workerman.net/
 * @license http://www.opensource.org/licenses/mit-license.php MIT License
 */

/**
 * 用于检测业务代码死循环或者长时间阻塞等问题
 * 如果发现业务卡死，可以将下面declare打开（去掉//注释），并执行php start.php reload
 * 然后观察一段时间workerman.log看是否有process_timeout异常
 */
//declare(ticks=1);

use \GatewayWorker\Lib\Gateway;

/**
 * 主逻辑
 * 主要是处理 onConnect onMessage onClose 三个方法
 * onConnect 和 onClose 如果不需要可以不用实现并删除
 */
class Events
{
    /**
     * 当客户端连接时触发
     * 如果业务不需此回调可以删除onConnect
     * 
     * @param int $client_id 连接id
     */
    public static function onConnect($client_id)
    {
        // 向当前client_id发送数据 
//         Gateway::sendToClient($client_id, "Hello $client_id\r\n");
        // 向所有人发送
//         Gateway::sendToAll("$client_id login\r\n");
    }
    
   /**
    * 当客户端发来消息时触发
    * @param int $client_id 连接id
    * @param mixed $message 具体消息
    */
   public static function onMessage($client_id, $message)
   {
       // 客户端传递的是json数据
       $messageData = json_decode($message, true);
       if(!$messageData)
       {
           return ;
       }
       // 根据类型执行不同的业务
       switch($messageData['type'])
       {
           case 'sysPush':
               break;
           case 'pong':
               break;
           case 'login':
               // uid
               $uid = $messageData['id'];
               // 将当前链接与uid绑定
               Gateway::bindUid($client_id, $uid);
               // 判断是否有房间号
               if(!isset($messageData['room_id']))
               {
                   throw new \Exception("\$message_data['room_id'] not set. client_ip:{$_SERVER['REMOTE_ADDR']} \$message:$message");
               }
               
               // 把房间号昵称放到session中
               $room_id = $messageData['room_id'];
               $client_name = htmlspecialchars($messageData['client_name']);
               $_SESSION['room_id'] = $room_id;
               $_SESSION['client_name'] = $client_name;
               $_SESSION['uid'] = $uid;
               
               // 获取房间内所有用户列表
               /* $clients_list = Gateway::getClientSessionsByGroup($room_id);
               foreach($clients_list as $tmp_client_id=>$item)
               {
                   $clients_list[$tmp_client_id] = $item['client_name'];
               }
               $clients_list[$client_id] = $client_name; */
               
               // 转播给当前房间的所有客户端，xx进入聊天室 message {type:login, client_id:xx, name:xx}
               $returnMessage = array('type'=>$messageData['type'],'uid'=>$uid, 'client_id'=>$client_id, 'client_name'=>htmlspecialchars($client_name), 'time'=>date('Y-m-d H:i:s'));
//                Gateway::sendToGroup($room_id, json_encode($returnMessage));
               Gateway::joinGroup($client_id, $room_id);
               
               // 给当前用户发送用户列表
//                $returnMessage['client_list'] = $clients_list;
               Gateway::sendToCurrentClient(json_encode($returnMessage));
               break;
           case 'chatMessage':
               break;
           case 'message':
               break;
       }
        // 向所有人发送 
        //Gateway::sendToAll("$client_id said $message\r\n");
   }
   
   /**
    * 当用户断开连接时触发
    * @param int $client_id 连接id
    */
   public static function onClose($client_id)
   {
       // 向所有人发送 
       //GateWay::sendToAll("$client_id logout\r\n");
   }
}
