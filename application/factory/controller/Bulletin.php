<?php
namespace app\factory\controller;
//公告管理
class Bulletin extends FactoryForm
{
    public function __construct()
    {
        $this->modelName = 'bulletin';
        $this->model = db($this->modelName);
        parent::__construct();
        if (!in_array($this->adminUser['admin_type'], [ADMIN_FACTORY, ADMIN_CHANNEL, ADMIN_DEALER, ADMIN_SERVICE])){
            $this->error(lang('NO ACCESS'));
        }
    }
    public function _afterList($list){
        if ($list && $this->adminUser['admin_type'] != ADMIN_FACTORY) {
            foreach ($list as $key => $value) {
                //判断当前登录用户是否已读
                $exist = db('bulletin_log')->where(['bulletin_id' => $value['bulletin_id'], 'user_id' => ADMIN_ID, 'is_read' => 1])->find();
                $list[$key]['is_read'] = $exist ? 1: 0;
            }
        }
        return $list;
    }
    
    /**
     * 设置公告已读
     */
    public function read()
    {
        $info = $this->_assignInfo();
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
            #TODO 根据公告是否发送给该用户判断是否可读
            //判断公告是否已读 未读添加已读日志
            $logModel = new \app\common\model\BulletinLog();
            $result = $logModel->read($info, $this->adminUser);
            if ($result === FALSE) {
                $this->error($logModel->error);
            }else{
                $this->success('已读完成~');
            }
        }else{
            $this->error('无已读权限');
        }
    }
    /**
     * 公告详情
     */
    public function detail()
    {
        $info = $this->_assignInfo();
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
            //判断公告是否已读 未读添加已读日志
            $logModel = new \app\common\model\BulletinLog();
            $logModel->read($info, $this->adminUser);
        }
        $this->assign('info', $info);
        return $this->fetch();
    }
    public function edit()
    {
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $this->error(lang('NO ACCESS'));
        }
        $info = $this->_assignInfo();
        if ($info['publish_status'] != 0) {
            $this->error('公告已发布，不允许编辑');
        }
        return parent::edit();
    }
    public function del()
    {
        $info = $this->_assignInfo();
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $logModel = new \app\common\model\BulletinLog();
            $result = $logModel->drop($info, $this->adminUser);
            if ($result === FALSE) {
                $this->error($logModel->error);
            }else{
                $this->success('删除成功', url('index'));
            }
        }else{
            if ($info['publish_status'] != 0) {
                $this->error('公告已发布，不允许删除');
            }
            return parent::del();
        }
    }
    //发布
    public function publish(){
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY){
            $this->error(lang('NO ACCESS'));
        }
    	$info = $this->_assignInfo();
    	//判断是否已经发布
    	if ($info['publish_status'] > 0) {
    	    $this->error('公告已经发布，不能重复操作');
    	}
        $result = $this->model->where(['bulletin_id' => $info['bulletin_id']])->update(['publish_status' => 1, 'publish_time' => time(), 'update_time' => time()]);
        if($result){
            $push = new \app\common\service\PushBase();
            $data = [
                'type'  => 'notice',
                'title' => $info['name'],
                'desc'  => $info['description'],
                'content'=>$info['content'],
                'id'    => $info['bulletin_id'],
                'time'  => date('Y-m-d',time()),
            ];
            //发送给群组内在线的人,如果store_type == 0 代表发给所有角色
            $group = $info['store_type'] == 0 ? 'factory'.$info['store_id'] : $info['store_type'];
            $push->sendToGroup($group , json_encode($data));
            $this->success('公告发布成功','index');
        }else{
            $this->error('发布失败');
        }
    }
    function _assignInfo($pkId = 0)
    {
        $info = parent::_assignInfo($pkId);
        $storeTypes = get_store_type();
        unset($storeTypes[STORE_FACTORY]);
        $this->assign('types', $storeTypes);
        if ($info) {
            if ($info['to_store_ids']) {
                $stores = db('store')->field('store_id as id, name')->where(['store_id' => ['IN', $info['to_store_ids']]])->select();
                $info['stores'] = $stores ? json_encode($stores) : '';
            }else{
                $info['stores'] = '';
            }
        }
        $this->assign('info', $info);
        return $info;
    }
    function _getData()
    {
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $this->error(lang('NO ACCESS'));
        }
        $params = parent::_getData();
        $info = $this->_assignInfo();
        $visibleRange = isset($params['visible_range'])  ? intval($params['visible_range']): 1;
        $storeIds = isset($params['store_id'])  ? $params['store_id']: [];
        if ($visibleRange == 0 && !$storeIds) {
            $this->error('请选择公告可见商户');
        }
        $name = isset($params['name']) ? trim($params['name']) : '';
        $content = isset($params['content']) ? trim($params['content']) : '';
        if (!$name) {
            $this->error('请填写公告标题');
        }
        if (!$content) {
            $this->error('请填写公告内容');
        }
        $params['to_store_ids'] = $visibleRange ? '' : implode(',', $storeIds);
        if (!$info) {
            $params['post_user_id'] = ADMIN_ID;
            $params['store_id'] = $this->adminUser['store_id'];
        }
        return $params;
    }
    function _getOrder()
    {
        return 'is_top DESC, sort_order ASC, add_time DESC';
    }
    function _getAlias()
    {
        return 'B';
    }
    function _getWhere(){
        $params = $this->request->param();
        $where = [
            'B.is_del' => 0,
        ];
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $where['B.store_id'] = $this->adminUser['factory_id'];
            $where['B.publish_status'] = 1;
            $where[] = 'B.visible_range = 1 OR (visible_range = 0 AND find_in_set('.$this->adminUser['store_id'].', B.to_store_ids))';
            $where[] = 'B.store_type = 0 OR B.store_type = '.$this->adminUser['store_type'];
        }else{
            $where['B.store_id'] = $this->adminUser['store_id'];
        }
        if ($params) {
            $status = isset($params['status']) ? intval($params['status']) : -1;
            if($status > -1){
                $where['B.publish_status'] = $status;
            }
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['B.name'] = ['like','%'.$name.'%'];
            }
        }
        return $where;
    }
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $status = get_publish_status();
        $this->assign('status', $status);
        $search = [
            ['type' => 'input', 'name' =>  'name', 'value' => '公告标题', 'width' => '30'],
        ];
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $search[] = ['type' => 'select', 'name' => 'status', 'options'=>'status', 'default'=>'-1', 'default_option' => '==发布状态=='];
        }
        return $search;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = parent::_tableData();
        if ($table && $this->adminUser['admin_type'] != ADMIN_FACTORY) {
            foreach ($table as $key => $value) {
                if (isset($value['value']) && $value['value'] == 'is_top') {
                    $table[$key]['value'] = 'is_read';
                    $table[$key]['title'] = '是否已读';
                }
                if(isset($value['value']) && !in_array($value['value'], ['is_top','name','publish_time','bulletin_id'])){
                    unset($table[$key]);
                }
            }
        }
        $table['actions']['button'] = [];
        $table['actions']['button'][] = ['text'  => '编辑', 'action'=> 'condition', 'icon'  => 'edit','bgClass'=> 'bg-main','condition'=>['action'=>'edit','rule'=>'$vo["publish_status"] == 0']];
        $table['actions']['button'][] = ['text'  => '删除', 'action'=> 'condition', 'icon'  => 'delete','bgClass'=> 'bg-red','condition'=>['action'=>'del','rule'=>'$vo["publish_status"] == 0']];
        $table['actions']['button'][] = ['text'  => '查看公告', 'action'=> 'condition', 'icon'  => 'chart-line','bgClass'=> 'bg-blue','condition'=>['action'=>'detail','rule'=>'$vo["publish_status"] == 1']];
        $table['actions']['button'][] = ['text'  => '发布', 'action'=> 'condition','js-action' => true, 'icon'  => 'check','bgClass'=> 'bg-dot','condition'=>['action'=>'publish','rule'=>'$vo["publish_status"] == 0']];
        
//         $table['actions']['button'][] = ['text'  => '公告发布',  'action'=> 'publish', 'icon'  => 'check','bgClass'=> 'bg-dot'];
        $table['actions']['width']  = '*';
        return $table;
    }
}