<?php
namespace app\common\controller;

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
    function _afterAjaxList($list)
    {
        if ($list) {
            $treeService = new \app\common\service\Tree();
            $list = $treeService->getTree($list);
            if ($list) {
                foreach ($list as $key => $value) {
                    $list[$key]['name'] = $value['cname'];
                }
            }
        }
        return $list;
    }
    function _getAjaxField($field = ''){
        $field .= ', cate_id, parent_id';
        return $field;
    }
    
    function _getWhere(){
        $params = $this->request->param();
        $where = ['C.is_del' => 0];
        if ($this->adminUser['store_id']) {
            $where['C.store_id'] = $this->adminUser['store_id'];
        }
        if ($params) {
            $sname = isset($params['sname']) ? trim($params['sname']) : '';
            if($sname){
                $where['S.name'] = ['like','%'.$sname.'%'];
            }
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['C.name'] = ['like','%'.$name.'%'];
            }
        }
        return $where;
    }
    function _getField(){
        $field = 'C.*';
        $field .= ', S.name as sname';
        return $field;
    }
    function _getAlias(){
        return 'C';
    }
    function _getOrder(){
        return 'C.sort_order ASC, C.add_time DESC';
    }
    function _getJoin(){
        $join[] = ['store S', 'S.store_id = C.store_id', 'INNER'];
        return $join;
    }
    function del(){
        $params = $this->request->param();
        $pkId = intval($params['id']);
        $info = parent::_assignInfo($pkId);
        //判断当前分类下是否存在产品
        $block = db('goods')->where(['cate_id' => $pkId, 'is_del' => 0, 'store_id' => $info['store_id']])->find();
        if ($block) {
            $this->error('分类下存在产品，不允许删除');
        }
        parent::del();
    }
    function _getData()
    {
        $data = parent::_getData();
        $params = $this->request->param();
        $pkId = $params && isset($params['id']) ? intval($params['id']) : 0;
        $factoryId = $params && isset($params['store_id']) ? intval($params['store_id']) : 0;
        
        $name = trim($data['name']);
        if (!$name) {
            $this->error('分类名称不能为空');
        }
        $where = ['name' => $name, 'is_del' => 0, 'store_id' => $factoryId];
        if($pkId){
            $where['cate_id'] = ['neq', $pkId];
        }
        $exist = $this->model->where($where)->find();
        if($exist){
            $this->error('当前分类名称已存在');
        }
        if ($this->adminUser['store_id']) {
            $data['store_id'] = $this->adminUser['store_id'];
        }
        $data['name'] = $name;
        return $data;
    }
    function _assignInfo($id = 0)
    {
        $info = parent::_assignInfo($id);
        $cateId = $info && isset($info['cate_id']) ? $info['cate_id'] : 0;
        $sid = $info && isset($info['store_id']) ? $info['store_id'] : 0;
        $this->_getParents($cateId, $sid);
        
        $store = new \app\common\controller\Store();
        $store->_getFactorys();
        
        $this->assign('info', $info);
        return $info;
    }
    private function _getParents($cateId = 0, $sid = 0)
    {
        $sid = $sid ? $sid : $this->adminUser['store_id'];
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
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $search = [
            ['type' => 'input', 'name' =>  'name', 'value' => lang($this->modelName).'名称', 'width' => '20'],
        ];
        return $search;
    }
    /**
     * 列表项配置
     */
    /* function _tableData(){
        $table = [
            ['title'     => '编号','width'    => '60','value'      => 'cate_id','type'      => 'index'],
            ['title'     => '厂商名称','width'  => '*','value'   => 'sname','type'      => 'text'],
            ['title'     => lang($this->modelName).'名称','width'  => '*','value'   => 'name','type'      => 'text'],
            ['title'     => '状态','width'    => '80','value'      => 'status','type'      => 'yesOrNo', 'yes'       => '可用','no'        => '禁用'],
            ['title'     => '排序','width'    => '80','value'      => 'sort_order','type'      => 'text'],
            ['title'     => '操作','width'    => '*','value'   => 'cate_id','type'      => 'button','button'    =>
                [
                    ['text'  => '编辑','action'=> 'edit','icon'  => 'edit','bgClass'=> 'bg-main'],
                    ['text'  => '删除','action'=> 'del','icon'  => 'delete','bgClass'=> 'bg-red']
                ]
            ]
        ];
        return array_filter($table);
    } */
    /**
     * 详情字段配置
     */
    function _fieldData(){
        $array = [];
        if ($this->adminUser['admin_type'] == 2) {
            $array = ['title'=>'厂商名称','type'=>'text','name'=>'','size'=>'40','default'=> $this->adminStore['name'], 'disabled' => 'disabled'];
        }else{
            $array = ['title'=>'所属厂商','type'=>'select','options'=>'factorys','name' => 'store_id', 'size'=>'40' , 'datatype'=>'', 'default'=>'','default_option'=>'==所属厂商==','notetext'=>'请选择所属厂商'];
        }
        $field = [
            $array,
            ['title'=>lang($this->modelName).'名称','type'=>'text','name'=>'name','size'=>'40','datatype'=>'*','default'=>'','notetext'=>lang($this->modelName).'名称请不要填写特殊字符'],
            ['title'=>'显示状态','type'=>'radio','name'=>'status','size'=>'20','datatype'=>'','default'=>'1','notetext'=>'','radioList'=>[
                ['text'=>'可用','value'=>'1'],
                ['text'=>'禁用','value'=>'0'],
            ]],
            ['title'=>'排序','type'=>'text','name'=>'sort_order','size'=>'20','datatype'=>'','default'=>'1','notetext'=>''],
        ];
        return $field;
    }
}