<?php
namespace app\admin\controller;
use app\common\controller\FormBase;
use think\Request;

//渠道等级管理
class Cgrade extends FormBase
{
    public function __construct()
    {
        $this->modelName = 'channel_grade';
        $this->model = db($this->modelName);
        parent::__construct();
        if (ADMIN_ID != 1 && $this->adminUser['store_type'] != 1) {
            $this->error(lang('NO ACCESS'));
        }
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
        return 'CG.*, S.name as sname';
    }
    function _getJoin()
    {
        return [
            ['store S', 'S.store_id = CG.store_id', 'LEFT'],
        ];
    }
    function  _getOrder()
    {
        return 'CG.sort_order ASC, CG.add_time DESC';
    }
    function _getWhere(){
        $where = [
            'CG.is_del'     => 0,
            'S.store_type'  => 1,
        ];
//         $where = [
//             'is_del'     => 0,
// //             'S.store_type'  => 1,
//         ];
        if ($this->adminUser['store_type'] == 1) {
            $where['S.store_id'] = $this->storeId;
        }
        $params = $this->request->param();
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['CG.name'] = ['like','%'.$name.'%'];
            }
        }
        return $where;
    }
    function _getGrades($sid = 0, $cgradeId = 0)
    {
        $sid = $sid ? $sid : $this->storeId;
        $where = ['is_del' => 0, 'status' => 1, 'store_id' => $sid];
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
        $pkId = $params && isset($params['id']) ? intval($params['id']) : 0;
        if ($pkId == 1) {
            $this->error('系统等级，不允许编辑');
        }
        $name = trim($data['name']);
        if (!$name) {
            $this->error('等级名称不能为空');
        }
        $where = [
            'name' => $name, 
            'is_del' => 0,
            'store_id' => ['IN', [0, $this->storeId]],
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
        $storeId = $info ? $info['store_id'] : 0;
        $cgradeId = $info ? $info['cgrade_id'] : 0;
        $parents = $this->_getGrades($storeId, $cgradeId);
        return $info;
    }
    function del(){
        $params = $this->request->param();
        $pkId = intval($params['id']);
        if ($pkId == 1) {
            $this->error('系统等级，不允许删除');
        }
        $info = parent::_assignInfo($pkId);
        //判断当前等级下是否存在用户
        $exist = db('store_member')->where(['grade_id' => $pkId, 'is_del' => 0])->find();
        if ($exist) {
            $this->error('等级下存在渠道商，不允许删除');
        }
        parent::del();
    }
}
