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
        if(parent::checkStatus($data['store_id'])){
            $data['status']=-3;
        }else{
            if(parent::checkStatus($data['factory_id'])){
                $data['status']=-1;
            }else{
                $data['status']=1;
            }
        }
        return $data;
    }
    
}