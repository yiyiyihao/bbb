<?php
namespace app\factory\controller;
use app\common\controller\Message as CommonMessage;
//售后工程师管理
class Message extends CommonMessage
{
    public function __construct()
    {
        parent::__construct();
       
    }
    //发布
    function publish(){
    	$info = $this->_assignInfo();
    	//dump($info);
    	$where=['msg_id'=>$info['msg_id']];
        $update=['status'=>2,'publish_time' => time()];
        $result = $this->model->where($where)->update($update);
        if($result){
            $this->success('公告发布成功','index');
        }else{
            $this->error('发布失败','index');
        }

    }

}