<?php
namespace app\common\controller;
use think\Request;

//基本数据增删改查管理公共处理
class FormBase extends AdminBase
{
    var $model;
    var $modelName;
    var $where;
    var $infotempfile;
    var $indextempfile;
    var $perPage;
    var $table;
    public function __construct()
    {
        parent::__construct();
        $this->subMenu['info'] = [
            'name'         => lang($this->modelName.'_name'),
            'description'  => lang($this->modelName.'_desc'),
        ];
        $this->subMenu['menu'] = [
            [
                'name'  => lang($this->modelName).lang('LIST'),
                'url'   => url('index'),
            ],
        ];
        $this->subMenu['add'] = [
            'name' => lang('ADD').lang($this->modelName),
            'url' => url("add"),
        ];
        $this->infotempfile = 'info';
        $this->indextempfile = '';
        $this->perPage = 10;
    }
    /**
     * 内容列表
     */
    public function index(){
        $field  = $this->_getField();
        $where  = $this->_getWhere();
        $alias  = $this->_getAlias();
        $join   = $this->_getJoin();
        $order  = $this->_getOrder();
        if (method_exists($this->model, 'save')) {
            //取得内容列表
            $count  = $this->model->alias($alias)->join($join)->field($field)->where($where)->count();
            $list   = $this->model->alias($alias)->join($join)->field($field)->where($where)->order($order)->paginate($this->perPage,$count, ['query' => input('param.')]);
        }else{
            if($alias) $this->model->alias($alias);
            if($join) $this->model->join($join);
            if($field) $this->model->field($field);
            //取得内容列表
            $count  = $this->model->where($where)->count();
            
            if($field) $this->model->field($field);
            $list   = $this->model->where($where)->order($order)->paginate($this->perPage,$count, ['query' => input('param.')]);
        }
        // 获取分页显示
        $page   = $list->render();
        $list   = $list->toArray()['data'];
        $list = $this->_afterList($list);
        $this->assign('list',$list);// 赋值数据集
        $this->assign('page', $page);
        return $this->fetch($this->indextempfile);
    }
    public function getAjaxList($where = [], $field = '')
    {
        $params = $this->request->param();
        $keyword = isset($params['word']) ? trim($params['word']) : '';
        $isPage = isset($params['isPage']) ? intval($params['isPage']) : 0;
        $currectPage   = isset($params['page']) ? intval($params['page']) : 0;
        unset($params['word'], $params['isPage'], $params['page']);
        
        $pk = $this->model->getPk();
        
        $where = $where ? $where : ['is_del' => 0, 'status' => 1];
        if (!$where && $keyword) {
            $where['name'] = ['like', '%'.$keyword.'%'];
        }
        if (isset($params['neq'])) {
            if ($params['neq']) {
                $where[$pk] = ['<>', $params['neq']];
            }
            unset($params['neq']);
        }
        
        if ($params) {
            $where = array_merge($where, $params);
        }
        $count =  $this->model->where($where)->count();
        if (!$field) {
            $field = $pk.' as id, name';
        }
        $field = $this->_getAjaxField($field);
        $list = $this->model->field($field)->where($where)->order('add_time DESC')->paginate($this->perPage, $count, ['page' => $currectPage, 'ajax' => TRUE]);
        $page = '';
        if ($list) {
            $page = $list->render();
            $list = $list->toArray()['data'];
        }
        $list = $this->_afterAjaxList($list);
        $data = array(
            'data'  => $list,
            'page' => $page,
        );
        $this->ajaxJsonReturn($data);
    }
    /**
     * 新增内容
     */
    public function add() {
        $msg = lang('ADD').lang($this->modelName);
        $params = $this->request->param();
        if(IS_POST){
            $data = $this->_getData();
            if (method_exists($this->model, 'save')) {
                $pkId = $this->model->save($data);
            }else{
                $pkId = $this->model->insertGetId($data);
            }
            if($pkId){
                $this->_afterAdd($pkId, $data);
                $msg .= lang('SUCCESS');
                $routes = $this->request->route();
                $this->success($msg, url("index", $routes), TRUE);
            }else{
                $msg .= lang('FAIL');
                $this->error($msg);
            }
        }else{
            $routes = $this->request->route();
            $this->subMenu['menu'][] = [
                'name'  => $msg,
                'url'   => url('add', $routes),
            ];
            $this->_assignInfo();
            $this->_assignAdd();
            return $this->fetch($this->infotempfile);
        }
    }
    
    /**
     * 编辑内容
     */
    public function edit() {
        $params = $this->request->param();
        $routes = $this->request->route();
        $pkId = intval($params['id']);
        $msg = lang('EDIT').lang($this->modelName);
        if($pkId){
            $this->subMenu['menu'][] = [
                'name'  => $msg,
                'url'   => url('edit', $routes),
            ];
            $info = $this->_assignInfo($pkId);
            if (!$info) {
                $this->error(lang('ERROR'));
            }
            if(IS_POST){
                $data = $this->_getData();
                $pk   =   $this->model->getPk();
                $where[$pk] = $pkId;
                if (method_exists($this->model, 'save')) {
                    $result = $this->model->save($data, $where);
                }else{
                    $result = $this->model->where($where)->update($data);
                }
                if($result){
                    $this->_afterEdit($pkId, $data);
                    $msg .= lang('SUCCESS');
                    unset($routes['id']);
                    $this->success($msg, url("index", $routes), TRUE);
                }else{
                    $msg .= lang('FAIL');
                    $this->error($msg);
                }
            }else{
                return $this->fetch($this->infotempfile);
            }
        }else{
            $this->error(lang('param_error'));
        }
    }
    
    /**
     * 删除内容
     */
    public function del() {
        $params = $this->request->param();
        $pkId = intval($params['id']);
        $msg = lang('DEL').lang($this->modelName);
        if($pkId){
            $info = $this->_assignInfo($pkId);
            $pk = $this->model->getPk();
            $result = $this->model->where(array($pk => $pkId))->update(array('is_del' => 1, 'update_time' => time()));
            if($result){
                $this->_afterDel($info);
                $msg .= lang('success');
                $this->success($msg);
            }else{
                $this->error($this->model->getError());
            }
        }else{
            $this->error(lang('param_error'));
        }
    }
    
    //以下为私有方法
    
    function _initList(){
        $this->assign('table', $this->table);
    }
    function _afterList($list)
    {
        //初始化列表元素
        $this->_initList();
        return $list;
    }
    function _afterAjaxList($list)
    {
        return $list;
    }
    
    /**
     * 取得查询字段
     */
    function _getField(){
        return;
    }
    /**
     * 取得Ajax查询字段
     */
    function _getAjaxField($field = ''){
        return $field;
    }
    /**
     * 取得查询条件
     */
    function _getWhere(){
        $where = $this->where;
        $where['is_del'] = 0;
        return $where;
    }
    /**
     * 取得查询条件
     */
    function _getAlias(){
        return;
    }
    /**
     * 取得查询条件
     */
    function _getJoin(){
        return;
    }
    /**
     * 取得查询条件
     */
    function _getOrder(){
        return 'sort_order ASC, add_time DESC';
    }
    /**
     * 获取提交数据
     */
    function _getData(){
        $params = $this->request->param();
        $pkId = $params && isset($params['id']) ? intval($params['id']) : 0;
        $data = input('post.');
        if (!$pkId) {
            $data['add_time'] = time();
        }
        $data['update_time'] = time();
        if (isset($data['keyword'])) {
            unset($data['keyword']);
        }
        return $data;
    }
    
    /**
     * 赋值新增时基础参数
     */
    function _assignAdd(){
        unset($this->subMenu['add']);
        $this->assign("name",lang($this->modelName."_add"));
        $this->assign('info', []);
    }
    /**
     * 取得并赋值info内容
     */
    function _assignInfo($pkId = 0){
        if(!$pkId){
            $params = $this->request->param();
            $pkId = isset($params['id']) ? intval($params['id']) : null;
        }
        unset($this->subMenu['add']);
        $this->assign("name",lang($this->modelName."_edit"));
        if($pkId > 0){
            $info = $this->model->get($pkId);
            if (!$info) {
                $this->error(lang('PARAM_ERROR'));
            }
            $this->assign("info",$info);
            return $info;
        }else{
            return [];
        }
    }
    function _afterAdd($pkId = 0, $data = [])
    {
        return FALSE;
    }
    function _afterEdit($pkId = 0, $data = [])
    {
        return FALSE;
    }
    function _afterDel($info = [])
    {
        return FALSE;
    }
}