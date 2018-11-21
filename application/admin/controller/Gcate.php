<?php
namespace app\admin\controller;
use app\common\controller\FormBase;

//分类管理
class Gcate extends FormBase
{
    public function __construct()
    {
        $this->modelName = 'goods_cate';
        $this->model = db($this->modelName);
        parent::__construct();
    }
    function _afterList($list)
    {
        if ($list) {
            $treeService = new \app\common\service\Tree();
            $list = $treeService->getTree($list);
        }
        return $list;
    }
    
    function _getWhere(){
        $params = $this->request->param();
        $other = isset($params['other']) ? intval($params['other']) : '';
        $where = ['C.is_del' => 0];
//         if ($this->showOther) {
            $where['C.store_id'] = ['<>', $this->storeId];
            $sname = isset($params['sname']) ? trim($params['sname']) : '';
            if($sname){
                $where['S.name'] = ['like','%'.$sname.'%'];
            }
//         }else{
//             $where['C.store_id'] = $this->storeId;
//         }
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['C.name'] = ['like','%'.$name.'%'];
            }
        }
        return $where;
    }
    function _getField(){
        $field = 'C.cate_id, C.name, C.parent_id, C.sort_order, C.name as cname, C.thumb, C.status';
//         if ($this->showOther) {
//             $field .= ', S.name as sname';
//         }
        return $field;
    }
    function _getAlias(){
        return 'C';
    }
    function _getOrder(){
        return 'C.sort_order ASC, C.add_time DESC';
    }
    function _getJoin(){
        $join = [];
//         if ($this->showOther) {
//             $join[] = ['store S', 'S.store_id = C.store_id', 'INNER'];
//         }
        return $join;
    }
    function del(){
        $params = $this->request->param();
        $pkId = intval($params['id']);
        $info = parent::_assignInfo($pkId);
        //判断当前分类下是否存在商品
        $block = db('goods')->where(['cate_id' => $pkId, 'is_del' => 0, 'store_id' => $this->storeId])->find();
        if ($block) {
            $this->error('分类下存在商品，不允许删除');
        }
        parent::del();
    }
    function _getData()
    {
        $data = parent::_getData();
        $params = $this->request->param();
        $pkId = $params && isset($params['id']) ? intval($params['id']) : 0;
        
        $name = trim($data['name']);
        if (!$name) {
            $this->error('分类名称不能为空');
        }
        $where = ['name' => $name, 'is_del' => 0, 'store_id' => $this->storeId];
        if($pkId){
            $where['cate_id'] = ['neq', $pkId];
        }
        $exist = $this->model->where($where)->find();
        if($exist){
            $this->error('当前分类名称已存在');
        }
        $data['name'] = $name;
        return $data;
    }
    function _assignAdd()
    {
        $this->_getParents();
    }
    function _assignInfo($id = 0)
    {
        $info = parent::_assignInfo($id);
        $cateId = $info && isset($info['cate_id']) ? $info['cate_id'] : 0;
        $sid = $info && isset($info['store_id']) ? $info['store_id'] : 0;
        $this->_getParents($cateId, $sid);
        return $info;
    }
    private function _getParents($cateId = 0, $sid = 0)
    {
        $sid = $sid ? $sid : $this->storeId;
        $where = ['is_del' => 0, 'status' => 1, 'store_id' => $sid];
        if ($cateId) {
            $where['cate_id'] = ['neq', $cateId];
        }
        $categorys = $this->model->where($where)->select();
        if ($categorys) {
            $treeService = new \app\common\service\Tree();
            $categorys = $treeService->getTree($categorys);
        }
        $this->assign('cates', $categorys);
        return $categorys;
    }
}
