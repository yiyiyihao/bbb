<?php


namespace app\common\model;


use think\Model;

class Todo extends Model
{
    protected $createTime = 'add_time';
    protected $updateTime = 'update_time';
    protected $autoWriteTimestamp = 'int';

    //待办事件已完成
    public function finish($id)
    {
        if (empty($id)) {
            return dataFormat(1,'无待办事件');
        }
        $todo = $this->where(['is_del' => 0, 'id' => $id])->find();
        if (empty($todo)) {
            return dataFormat(2,'无待办事件');
        }
        $storeId = $todo->store_id;
        $todo->status = 1;
        if ($todo->save() === false) {
            return dataFormat(3,'待办事件更新失败');
        }
        //发送工单通知给商户
        $push = new \app\common\service\PushBase();
        $sendData = [
            'type'    => 'todo_done',
            'todo_id' => $id,
        ];
        //在线推送
        $push->sendToGroup('store' . $storeId, json_encode($sendData));
        return dataFormat(0,'推送成功');
    }

}