<?php
namespace app\factory\controller;
use app\common\controller\Installer as CommonInstaller;
//售后工程师管理
class Installer extends CommonInstaller
{
    public function __construct()
    {
        parent::__construct();
    }
    function _getData()
    {
        $data = parent::_getData();
        $params = $this->request->param();
        if($this->checkStatus($data['store_id'])){
            $data['status']=-3;
        }else{
            if($this->checkStatus($data['factory_id'])){
                $data['status']=-1;
            }else{
                $data['status']=1;
            }
        }
        return $data;
    }
    //审核
    function check(){
        $info = $this->_assignInfo();
        $adminUser = $this->adminUser;
        //dump($adminUser);exit;
        //当需要服务商审核，并且是服务商帐号登录
        if($info['status']==-3 && $adminUser['group_id']==4){
            if(IS_POST){
                //获取提交信息
                $params = $this->request->param();
                if($params['check']=='1'){
                    $con_status = $this->checkStatus($info['factory_id']);
                    if($con_status == 1){
                        $this->updateCheck($info['installer_id'],-1);//状态改为-1
                    }else{
                        $this->updateCheck($info['installer_id'],1);//状态改为1
                    }
                }else{
                    $this->setRemark($adminUser,$params,$info['installer_id']);
                    $this->updateCheck($info['installer_id'],0);//状态改为0
                }
            }
            return $this->fetch('checkInfo');
        }
        //当需要厂商审核，并且厂商帐号登录
        elseif($info['status']==-1 && $adminUser['group_id']==1){
            if(IS_POST){
            //获取提交信息
                $params = $this->request->param();
                //提交如果为1，审核同意，否则status为0
                if($params['check']=='1'){
                    $this->updateCheck($info['installer_id'],1); //状态改为1
                }else{
                    $this->setRemark($adminUser,$params,$info['installer_id']);
                    $this->updateCheck($info['installer_id'],0);//状态改为0
                }
            }
            return $this->fetch('checkInfo');
        }
        else{
            $this->error('不需要审核','index');
        }
    }
    
    //更新
    function updateCheck($installer_id,$status){
        $where=['installer_id'=>$installer_id];
        $update=['status'=>$status];
        $result = $this->model->where($where)->update($update);
        if($result){
            $this->success('审核完成','index');
        }else{
            $this->error('失败','index');
        }
    }
    function setRemark($adminUser,$params,$installer_id){
        //remark入库
        $remark=[
            'store_id' =>  $adminUser['store_id'],
            'remark'   =>  $params['remark']
        ];
        $remark=json_encode($remark);  
        $this->model->where(['installer_id'=>$installer_id])->update(['remark'=>$remark]);
    }
    //审核状态
    function checkStatus($id){
        //获取当前服务商的厂商的是否审核
        $status = db('store')->field('config_json')->find($id);
        $status = json_decode($status['config_json'],true);
        return $status['installer_check'];
    } 

}