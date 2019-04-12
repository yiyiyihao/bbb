<?php
namespace app\common\controller;
use think\Request;

//基本数据增删改查管理公共处理
class FormBase extends CommonBase
{
    var $model;
    var $modelName;
    var $where;
    var $infotempfile;
    var $indextempfile;
    var $perPage;
    var $uploadUrl;
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
        $this->subMenu['showmenu'] = false;
        $this->subMenu['add'] = [
            'name' => lang('ADD').lang($this->modelName),
            'url' => url("add"),
        ];
        $this->infotempfile = 'info';
        $this->indextempfile = '';
        $this->perPage = 10;
        $this->uploadUrl = url('Upload/upload');
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
        $sort   = $this->_getSort();
        $order  = $sort ? $sort : $order;
        //页面
        /* $this->assign('userrule',$this->adminUser['rule']);
        $action=strtolower($this->request->module().'/'.$this->request->controller().'/'.$this->request->action());
        $this->assign('action',$action); */

        if (method_exists($this->model, 'save')) {
            //取得内容列表
            $count  = $this->model->alias($alias)->join($join)->field($field)->where($where)->count();
            $list   = $this->model->alias($alias)->join($join)->field($field)->where($where)->order($order)->paginate($this->perPage,$count, ['query' => input('param.')]);
        }else{
            if($alias) $this->model->alias($alias);
            if($join) $this->model->join($join);
            if($field) $this->model->field($field);
            //取得内容列表
            //$count  = $this->model->where($where)->count();
            
            if($field) $this->model->field($field);
            $list   = $this->model->where($where)->order($order)->paginate($this->perPage,false, ['query' => input('param.')]);
        }
        // 获取分页显示
        $page   = $list->render();
        $list   = $list->toArray()['data'];
        //初始化列表元素
        $this->_initList();
        
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
        if ($keyword) {
            $where['name'] = ['like', '%'.$keyword.'%'];
        }
        if (isset($params['neq'])) {
            if ($params['neq']) {
                $where[$pk] = ['<>', $params['neq']];
            }
            unset($params['neq']);
        }
        
        if ($params) {
            $params = array_filter($params);
            $where = array_merge($params,$where);
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
                $this->success($msg, url("index", $routes), $pkId);
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
                    $result = db($this->modelName)->where($where)->update($data);
                }
                if($result){
                    $this->_afterEdit($pkId, $data);
                    $msg .= lang('SUCCESS');
                    unset($routes['id']);
                    $this->success($msg, url("index", $routes), $pkId);
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
        $tableList = $this->_tableData();
        if(isset($tableList[0]['sort'])){
        $tableList = array_order($tableList,'sort');
        //处理列表操作权限
        $adminUser = $this->adminUser;
        if($adminUser['user_id'] > 1 && !empty($adminUser['groupPurview'])){
            $groupPurview = $adminUser['groupPurview'];
            $purviewList  = json_decode($groupPurview,1);
            $last = end($tableList);
            if(isset($last['button'])){
                $list = $last['button'];
                $module             = strtolower($this->request->module());
                $controller         = strtolower($this->request->controller());
                $action             = strtolower($this->request->action());
                foreach ($list as $k=>$btn){
                    $flag = false;
                    if($btn['action'] == 'condition') $btn['action'] = $btn['condition']['action'];
                    $tempStr = url($module.'/'.$controller.'/'.$btn['action']);
                    foreach ($purviewList as $key=>$v){
                        $pstr = url($v['module'].'/'.$v['controller'].'/'.$v['action']);
                        if($pstr == $tempStr){
                            $flag = true;
                        }
                        if($flag) continue;
                    }
                    if(!$flag){
                        unset($tableList[count($tableList)]['button'][$k]);
                    }
                }
            }
        }
        }
        $this->assign('table', $tableList);
        $this->assign('search', $this->_searchData());
    }
    //获取列表序列化数据
    function _searchData(){
        return [];
    }
    //获取列表序列化数据
    function _tableData(){
        $tableModel = model("table");
        $tableList  = $tableModel->getTableList($this->modelName,$this->model->getPK());
        return $tableList;
    }
    //获取详情序列化数据
    function _fieldData(){
        $fieldModel = model("field");
        $fieldList  = $fieldModel->getFieldList($this->modelName);
        return $fieldList;
    }
    function _afterList($list)
    {
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
        $where[] = ['is_del','=',0];
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
     * 取得排序条件
     */
    function _getOrder(){
        return 'sort_order ASC, add_time DESC';
    }
    /**
     * 取得url排序条件
     */
    function _getSort(){
        $sort = input('get.sort');
        if($sort){
            $sortArr = explode(',', $sort);
        }else{
            return;
        }
        $return = [];
        foreach ($sortArr as $k=>$v){
            $valArr = explode('|',$v);
            $return[$valArr[0]] =  $valArr[1];
        }
        return $return;
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
        $this->assign("name", lang('ADD').lang($this->modelName));
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
        $this->assign("name",       lang('EDIT').lang($this->modelName));
        $this->assign("field",      $this->_fieldData());
        $this->assign("uploadUrl", $this->uploadUrl);
        
        if($pkId > 0){
            $info = $this->model->get($pkId);
            if (!$info || (isset($info['is_del']) && $info['is_del'] > 0)) {
                $this->error(lang('PARAM_ERROR'));
            }
            $this->assign("info",   $info);
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
    
    protected function actionLog($title = '', $user = [])
    {
        $request = $this->request;
        
        $action = strtolower($request->action());
        $title = $title ? $title : lang($this->modelName).lang($action);
        
        $params = $request->param();
        $data = [
            'user_id'   => ADMIN_ID,
            'user_name' => trim($this->adminUser['realname'] ? $this->adminUser['realname'] : ($this->adminUser['nickname'] ? $this->adminUser['nickname'] : $this->adminUser['username'])),
            'admin_type'=> $this->adminUser['admin_type'],
            'store_id'  => $this->adminUser['store_id'],
            'module'    => strtolower($request->module()),
            'controller'=> strtolower($request->controller()),
            'action'    => $action,
            'url'       => $request->host().$request->url(),
            'add_time'  => time(),
            
            'request_method' => $request->method(),
            'request_params' => $params ? json_encode($params) : '',
            
            'title' => $title,
        ];
        db('apilog_action')->insertGetId($data);
    }
}