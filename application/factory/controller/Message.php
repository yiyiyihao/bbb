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
        $sentMsg=$this->sendMsgToStore();
        $result = $this->model->where($where)->update($update);
        
        if($result&&$sentMsg){
            $this->success('公告发布成功','index');
        }else{
            $this->error('发布失败','index');
        }

    }
    //发布公告入信息库
    function sendMsgToStore(){
        //获取当前公告信息
        /*$info = $this->_assignInfo();
        //dump($info);exit;
        $msg_id=isset($info['msg_id']) ? intval($info['msg_id']) : '';
        $post_store_id=isset($info['store_id']) ? intval($info['store_id']) : '';
        $to_store_ids=[];
        //如果to_store_ids为0，为全站发布
        if($info['to_store_ids']){

        }else{
            $store_id=db('store')->field('store_id')->select();
            foreach ($store_id as $k => $v) {
                $to_store_ids[$v['store_id']]=$v['store_id'];
            }
        }
        //dump($to_store_ids);exit;
        foreach ($to_store_ids as $k => $v) {
            # code...
        }*/
        return true;
    }

    //查看已发布的消息
    function read(){
        $info = $this->_assignInfo();
        dump(123);exit;
        return $this->fetch();

    }

}