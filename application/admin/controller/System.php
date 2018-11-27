<?php
namespace app\admin\controller;
use app\common\controller\FormBase;
use think\Request;

//系统管理
class System extends FormBase
{
    public function __construct()
    {
        $this->modelName = 'system';
        $this->model = db('config');
        parent::__construct();
        if ($this->adminUser['user_id'] != 1) {
            $this->error(lang('NO ACCESS'));
        }
    }
    public function grant(){
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
