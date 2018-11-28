<?php
namespace app\factory\controller;
use app\admin\controller\System as adminSystem;

//系统管理
class System extends adminSystem
{
    public function __construct()
    {
        $this->modelName = 'system';
        $this->model = db('config');
        parent::__construct();
    }
    /**
     * 厂商权限配置
     * @return mixed|string
     */
    public function factory(){
        if (!$this->adminFactory || $this->adminUser['admin_type'] != 2) {
            $this->error(lang('NO ACCESS'));
        }
        $params = $this->request->param();
        $adminType = isset($params['type']) ? $params['type'] : 1;
        $configName = 'admin_type_'.$adminType;
        if($adminType){
            $name = get_admin_type($adminType).'授权配置';
            $info = $this->model->where(['name' => $configName, 'is_del' => 0])->find();
            $configValue = $info? json_decode($info['config_value'], TRUE) : [];
            if(IS_POST){
                
            }else{
                $this->assign('name', $name);
                $this->assign('config', $configValue);
                return $this->fetch();
            }
        }else{
            $this->error(lang('param_error'));
        }
    }
}
