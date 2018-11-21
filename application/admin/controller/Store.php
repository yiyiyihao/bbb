<?php
namespace app\admin\controller;
use app\common\controller\FormBase;

//厂商管理
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
        $this->storeType = $this->storeType ? $this->storeType : 1;//厂商
        $this->groupId = 2;
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
        if ($pkId == 1) {
            $this->error('平台自营厂商不允许删除');
        }
        //判断当前用户是否存在删除权限
        if ($this->adminUser['group_id'] == STORE_MANAGER && $this->storeIds && in_array($pkId, $this->storeIds)) {
            $this->error(lang('NO ACCESS'));
        }
        //判断当前厂商下是否存在子
        $child = $this->model->where(['factory_id' => $pkId, 'is_del' => 0])->find();
        if ($child) {
            $this->error('厂商下存在子厂商，不允许删除');
        }
        //判断当前厂商下是否存在区域/设备
        $block = db('store_block')->where(['store_id' => $pkId, 'is_del' => 0])->find();
        if ($block) {
            $this->error('厂商下存在区域，不允许删除');
        }
        $device = db('device')->where(['store_id' => $pkId, 'is_del' => 0])->find();
        if ($device) {
            $this->error('厂商下存在授权设备，不允许删除');
        }
        parent::del();
    }
    function _assignInfo($pkId = 0){
        $info = parent::_assignInfo();
        if ($info) {
            $user = db('user')->where(['store_id' => $info['store_id'], 'is_del' => 0, 'group_id' => $this->groupId])->find();
            $this->assign('user', $user);
        }
        return $info;
    }
    function _getData()
    {
        $data = parent::_getData();
        $params = $this->request->param();
        $pkId = $params && isset($params['id']) ? intval($params['id']) : 0;
        $parentId = $params && isset($params['factory_id']) ? intval($params['factory_id']) : 0;
        $address = $data && isset($data['address']) ? trim($data['address']) : '';
        $name = $data && isset($data['name']) ? trim($data['name']) : '';
        $username = $data && isset($data['username']) ? trim($data['username']) : '';
        $password = isset($data['password']) ?trim($data['password']) : '';
        if ($this->storeType != 1 && !$parentId) {
            $this->error('请选择关联厂商');
        }
        if (!$name) {
            $this->error(lang($this->modelName).'名称不能为空');
        }
        if (!$pkId) {
            if (!$username) {
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
        $where = ['name' => $name, 'is_del' => 0];
        if($pkId){
            $where['store_id'] = ['neq', $pkId];
        }
        $exist = $this->model->where($where)->find();
        if($exist){
            $this->error('当前'.lang($this->modelName).'名称已存在');
        }
        $data['name'] = $name;
        if (!$pkId) {
            $data['store_type'] = $this->storeType;
        }
        if (isset($data['store_id'])) {
            unset($data['store_id']);
        }
        $data['config_json'] = '';
        return $data;
    }
    function _afterAdd($pkId = 0, $data = []){
        $this->_userUpdate($pkId, $data, TRUE);
//         $this->_storeRelated($pkId, $data, TRUE);
        return TRUE;
    }
//     function _storeRelated($pkId, $data, $addFlag = FALSE){
//         $parentId = $data && isset($data['factory_id']) ? intval($data['factory_id']) : 0;
//         if ($this->storeType != 1 && $parentId) {
//             switch ($this->storeType) {
//                 case 2://渠道商
//                     $model = db('store_channel');
//                     break;
//                 case 3://经销商
//                     $model = db('store_dealer');
//                     break;
//                 case 4://服务商
//                     $model = db('store_servicer');
//                     break;
//                 default:
//                     return FALSE;
//                 break;
//             }
//             if ($addFlag) {
//                 $model->insert(['store_id' => $pkId, 'factory_id' => $parentId]);
//             }else{
//                 $model->where(['store_id' => $pkId, 'factory_id' => ['<>', $parentId]])->update(['factory_id' => $parentId]);
//             }
//         }
//         return TRUE;
//     }
    function _userUpdate($pkId, $data, $addFlag = FALSE)
    {
        $password = isset($data['password']) ?trim($data['password']) : '';
        $userModel = new \app\common\model\User();
        $userTabel = db('user');
        if ($addFlag) {
            $update = [
                'username' => trim($data['username']),
                'password'  => $userModel->pwdEncryption($password),
                'store_id'  => $pkId,
                'group_id'  => $this->groupId,//厂商管理员
            ];
            $userTabel->insertGetId($update);
        }else{
            $update = [
                'password'  => $userModel->pwdEncryption($password),
            ];
            $userTabel->where(['store_id' => $pkId, 'group_id' => $this->groupId, 'is_del' => 0])->update($update);
        }
        return TRUE;
    }
    function _afterEdit($pkId = 0, $data = []){
        $this->_userUpdate($pkId, $data, FALSE);
//         $this->_storeRelated($pkId, $data, FALSE);
        return TRUE;
    }
    function _getAlias()
    {
        return 'S';
    }
    function _getField(){
        $field = 'S.*, U.*';
        if ($this->storeType != 1) {
            $field .= ', S1.name as sname';
        }
        return $field;
    }
    function _getJoin()
    {
        $join[] = ['user U', 'S.store_id = U.store_id', 'LEFT'];
        if ($this->storeType != 1) {
            switch ($this->storeType) {
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
                    return FALSE;
                    break;
            }
            $join[] = [$tabel, 'S.store_id = AS.store_id', 'LEFT'];
            $join[] = ['store S1', 'S.factory_id = S1.store_id', 'LEFT'];
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
        if ($this->storeId && $this->storeType != 1) {
            $where['S1.factory_id'] = $this->storeId;
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