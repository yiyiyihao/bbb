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
     */
    public function factory(){
        if (!$this->adminFactory || $this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $this->error(lang('NO ACCESS'));
        }
        return $this->_storeConfig($this->adminStore['store_id']);
    }
    public function servicer()
    {
        if (!$this->adminFactory || $this->adminUser['admin_type'] != ADMIN_SERVICE) {
            $this->error(lang('NO ACCESS'));
        }
        return $this->_storeConfig($this->adminStore['store_id']);
    }
    
    private function _storeConfig($storeId)
    {
        $storeModel = model('store');
        $store = $storeModel->where(['store_id' => $storeId, 'is_del' => 0])->find();
        if (!$store) {
            $this->error(lang('NO ACCESS'));
        }
        $config = $store['config_json'] ? json_decode($store['config_json'], 1) : [];
        if (IS_POST) {
            $params = $this->request->param();
            if ($params) {
                foreach ($params as $key => $value) {
                    $config[$key] = $value;
                }
                $configJson = $config ? json_encode($config): '';
                
                $result = $storeModel->save(['config_json' => $configJson], ['store_id' => $storeId]);
                if ($result === FALSE) {
                    $this->error($storeModel->error);
                }
            }
            $this->success('配置成功');
        }else{
            $this->assign('config', $config);
            return $this->fetch();
        }
    }
}
