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
            'type'  => 'say',
            'message'   => '测试消息'
        ];
        $push->sendToUid(2, json_encode($data));
    }
}
