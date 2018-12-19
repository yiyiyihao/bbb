<?php
namespace app\admin\controller;
use app\common\controller\Index as CommonIndex;
use app\common\service\PushBase;
/**
 * @author chany
 * @date 2018-11-08
 */
class Index extends CommonIndex
{
    public function test(){
        $push = new PushBase;
        $data = [
            'type'  => 'notice',
            'message'   => '测试消息'
        ];
        //发送给指定的人
        $push->sendToUid(md5(2), json_encode($data));
        //发送给群组内在线的人
        $push->sendToGroup(1, json_encode($data));
    }
}
