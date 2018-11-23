<?php
namespace app\common\controller;

//商户管理
class Store extends FormBase
{
    var $storeType;
    var $parent;
    var $groupId;
    public function __construct()
    {
        $this->modelName = $this->modelName ? $this->modelName : 'store';
        $this->model = $this->model ? $this->model : model($this->modelName);
        parent::__construct();
        if ($this->adminUser['group_id'] != 1) {
            if ($this->storeType == 1) {
                $this->error(lang('NO ACCESS'));
            }elseif ($this->storeType != 1 && $this->adminUser['store_type'] != 1) {
                $this->error(lang('NO ACCESS'));
            }
        }
        if ($this->storeType != 1){
            $this->_getFactorys();
        }
    }
    /**
     * 删除
     */
    function del(){
        $params = $this->request->param();
        $pkId = intval($params['id']);
        $info = parent::_assignInfo($pkId);
        //判断商户类型
        $storeType = $info['store_type'];
        if ($this->adminUser['group_id'] != 1) {
            if ($storeType == 1) {
                $this->error(lang('NO ACCESS'));
            }elseif ($storeType != 1 && $this->adminUser['store_type'] != 1) {
                $this->error(lang('NO ACCESS'));
            }elseif ($info['factory_id'] != $this->adminUser['factory']['store_id']){
                $this->error(lang('NO ACCESS'));
            }
        }
        if ($storeType == 1) {
            //判断厂商下是否存在其它商户
            $exist = $this->model->where(['factory_id' => $pkId, 'is_del' => 0])->find();
            $msg = '厂商下存在其它商户，不允许删除';
        }else{
            $exist = [];
            #TODO 判断渠道商 经销商 服务商不能删除条件
            $msg = '';
        }
        if ($exist) {
            $this->error($msg);
        }
        parent::del();
    }
    function _afterDel($info = [])
    {
        if ($info) {
            //删除关联用户
            $user = db('user')->where(['store_id' => $info['store_id'], 'is_del' => 0])->update(['update_time' => time(), 'is_del' => 1]);
        }
        return TRUE;
    }
    function _assignInfo($pkId = 0){
        $info = parent::_assignInfo();
        if ($info) {
            switch ($info['store_type']) {
                case 1:
                    $model = 'factory';
                    break;
                case 2:
                    $model = 'channel';
                    break;
                case 3:
                    $model = 'dealer';
                    break;
                case 4:
                    $model = 'servicer';
                    break;
                default:
                    return FALSE;
                    break;
            }
            $detail = model($model)->where(['store_id' => $info['store_id']])->find();
            if ($detail) {
                $info = $info->toArray();
                $detail = $detail->toArray();
                $info = array_merge($info, $detail);
            }
            $user = db('user')->where(['store_id' => $info['store_id'], 'is_del' => 0, 'group_id' => $this->groupId])->find();
            $this->assign('user', $user);
        }
        $this->assign('info', $info);
        return $info;
    }
    function _getData()
    {
        $data = parent::_getData();
        $params = $this->request->param();
        $pkId = $params && isset($params['id']) ? intval($params['id']) : 0;
        $factoryId = $params && isset($params['factory_id']) ? intval($params['factory_id']) : 0;
        $address = $data && isset($data['address']) ? trim($data['address']) : '';
        $name = $data && isset($data['name']) ? trim($data['name']) : '';
        $domain = $data && isset($data['domain']) ? trim($data['domain']) : '';
        $username = $data && isset($data['username']) ? trim($data['username']) : '';
        $password = isset($data['password']) ?trim($data['password']) : '';
        if ($this->storeType != 1) {
            if ($this->adminUser['store_type'] == 1) {
                $data['factory_id'] = $factoryId = $this->adminUser['factory']['store_id'];
            }
            if (!$factoryId) {
                $this->error('请选择关联厂商');
            }
        }
        if (!$name) {
            $this->error(lang($this->modelName).'名称不能为空');
        }
        $where = ['name' => $name, 'is_del' => 0, 'store_type' => $this->storeType];
        if ($this->storeType != 1) {
            $where['factory_id'] = $factoryId;
        }
        if($pkId){
            $where['store_id'] = ['neq', $pkId];
        }
        $exist = $this->model->where($where)->find();
        if($exist){
            $this->error('当前'.lang($this->modelName).'名称已存在');
        }
        if ($this->storeType == 1) {
            if (!$domain) {
                $this->error(lang($this->modelName).'二级域名不能为空');
            }
            //验证二级域名是否唯一
            $where = ['SF.domain' => $domain, 'S.is_del' => 0];
            if($pkId){
                $where['S.store_id'] = ['neq', $pkId];
            }
            $exist = db('store_factory')->alias('SF')->join([['store S', 'S.store_id = SF.store_id', 'INNER']])->where($where)->find();
            if($exist){
                $this->error('二级域名已存在');
            }
        }
        if (!$pkId || $password) {
            if (!$pkId && !$username) {
                $this->error('请输入'.lang($this->modelName).'登录用户名');
            }
            if (!$password) {
                $this->error('请输入'.lang($this->modelName).'登录密码');
            }
            //检查用户名密码格式
            $userModel = new \app\common\model\User();
            $result = $userModel->_checkFormat($data);
            if ($result === FALSE) {
                $this->error($userModel->error);
            }
        }
        $data['name'] = $name;
        if (isset($data['store_id'])) {
            unset($data['store_id']);
        }
        $data['config_json'] = '';
        $data['group_id'] = $this->groupId;
        $data['store_type'] = $this->storeType;
        return $data;
    }
    function _getAlias()
    {
        return 'S';
    }
    function _getField(){
        $field = 'S.name, S.*, U.*, AS.*';
        if ($this->storeType != 1) {
            $field .= ', S1.name as sname';
            if ($this->storeType == 2) {
                $field .= ', CG.name as gname';
            }
        }
        return $field;
    }
    function _getJoin()
    {
        $join[] = ['user U', 'S.store_id = U.store_id', 'LEFT'];
        switch ($this->storeType) {
            case 1://厂商
                $tabel = 'store_factory AS';
                break;
            case 2://渠道商
                $tabel = 'store_channel AS';
                break;
            case 3://经销商
                $tabel = 'store_dealer AS';
                break;
            case 4://服务商
                $tabel = 'store_servicer AS';
                break;
            default:
                $this->error(lang('PARAM_ERROR'));
                return FALSE;
                break;
        }
        $join[] = [$tabel, 'S.store_id = AS.store_id', 'INNER'];
        $join[] = ['store S1', 'S.factory_id = S1.store_id', 'LEFT'];
        if ($this->storeType == 2) {
            $join[] = ['channel_grade CG', 'CG.cgrade_id = AS.cgrade_id', 'LEFT'];
        }
        return $join;
    }
    function  _getOrder()
    {
        return 'S.sort_order ASC, S.add_time DESC';   
    }
    function _getWhere(){
        $where = [
            'S.is_del'      => 0,
            'S.store_type'  => $this->storeType,
        ];
        if ($this->storeType != 1 && $this->adminUser['store_type'] == 1) {
            $where['S.factory_id'] = $this->storeId;
        }
        $params = $this->request->param();
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['S.name'] = ['like','%'.$name.'%'];
            }
        }
        return $where;
    }
    function _getFactorys()
    {
        //获取关联厂商列表
        $stores = $this->model->where(['store_type' => 1, 'is_del' => 0, 'status' => 1])->column('store_id, name');
        $this->assign('factorys', $stores);
    }
}