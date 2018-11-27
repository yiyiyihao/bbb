<?php
namespace app\admin\controller;
use app\common\controller\FormBase;

//渠道等级管理
class Cgrade extends FormBase
{
    public function __construct()
    {
        $this->modelName = 'channel_grade';
        $this->model = db($this->modelName);
        parent::__construct();
    }
    function _afterList($list)
    {
        if ($list) {
            $treeService = new \app\common\service\Tree('cgrade_id');
            $list = $treeService->getTree($list, 0, 'cgrade_id');
        }
        return $list;
    }
    function _getAlias()
    {
        return 'CG';
    }
    function _getField(){
        return 'CG.*, F.name as sname';
    }
    function _getJoin()
    {
        return [
            ['factory F', 'F.factory_id = CG.factory_id', 'LEFT'],
        ];
    }
    function  _getOrder()
    {
        return 'CG.sort_order ASC, CG.add_time DESC';
    }
    function _getWhere(){
        $where = [
            'CG.is_del'     => 0,
//             'F.store_type'  => 1,
        ];
//         $where = [
//             'is_del'     => 0,
// //             'F.store_type'  => 1,
//         ];
//         if ($this->adminUser['store_type'] == 1) {
//             $where['F.factory_id'] = $this->storeId;
//         }
        $params = $this->request->param();
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['CG.name'] = ['like','%'.$name.'%'];
            }
        }
        return $where;
    }
    function _getGrades($factoryId = 0, $cgradeId = 0)
    {
        $factoryId = $factoryId ? $factoryId : $this->storeId;
        $where = ['is_del' => 0, 'status' => 1, 'factory_id' => $factoryId];
        if ($cgradeId) {
            $where['cgrade_id'] = ['neq', $cgradeId];
        }
        $grades = $this->model->where($where)->select();
        if ($grades) {
            $treeService = new \app\common\service\Tree('cgrade_id');
            $grades = $treeService->getTree($grades, 0, 'cgrade_id');
        }
        $this->assign('grades', $grades);
        return $grades;
    }
    function _getData()
    {
        $data = parent::_getData();
        $params = $this->request->param();
        $name = trim($data['name']);
        $pkId = $params && isset($params['id']) ? intval($params['id']) : 0;
        $factoryId = $params && isset($params['factory_id']) ? intval($params['factory_id']) : 0;
        if (!$name) {
            $this->error('等级名称不能为空');
        }
//         if ($this->adminUser['store_type'] == 1) {
//             $data['factory_id'] = $factoryId = $this->adminUser['factory']['factory_id'];
//         }
        if (!$factoryId) {
            $this->error('请选择关联厂商');
        }
        $where = [
            'name' => $name, 
            'is_del' => 0,
            'factory_id' => $factoryId,
        ];
        if($pkId){
            $where['cgrade_id'] = ['neq', $pkId];
        }
        $exist = $this->model->where($where)->find();
        if($exist){
            $this->error('当前等级名称已存在');
        }
        $data['name'] = $name;
        return $data;
    }
    function _assignInfo($pkId = 0){
        $info = parent::_assignInfo($pkId);
        $this->_getFactorys();
        return $info;
    }
    function del(){
        $params = $this->request->param();
        $pkId = intval($params['id']);
        $info = parent::_assignInfo($pkId);
        if ($this->adminUser['admin_type'] != 1 && $info['store_id'] != $this->adminUser['store_id']) {
            $this->error('NO ACCESS');
        }
        //判断当前等级下是否存在下级
        $exist = $this->model->where(['parent_id' => $pkId, 'is_del' => 0])->find();
        if ($exist) {
            $this->error('等级下存在下级，不允许删除');
        }
        #TODO 判断等级下是否存在渠道商
        parent::del();
    }
    function _getFactorys()
    {
        //获取关联厂商列表
        $stores = db('factory')->where(['is_del' => 0, 'status' => 1])->column('factory_id, name');
        $this->assign('factorys', $stores);
    }
}