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
            ];
            //发送给群组内在线的人
            $push->sendToGroup($info['store_type'], json_encode($data));
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
        $params['to_store_ids'] = $visibleRange ? '' : implode(',', $storeIds);
        if (!$info) {
            $params['post_user_id'] = ADMIN_ID;
            $params['store_id'] = $this->adminUser['admin_type'];
        }
        return $params;
    }
    function _getOrder()
    {
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
            return 'is_top DESC, is_read ASC, sort_order ASC, add_time DESC';
        }else{
            return 'is_top DESC, sort_order ASC, add_time DESC';
        }
    }
    function _getField()
    {
        $field = 'B.*';
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $field .= ', ifnull(BR.bulletin_id, 0) is_read';
        }
        return $field;
    }
    function _getJoin()
    {
        $join = [];
        if ($this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $join[] = ['bulletin_log BR', 'B.bulletin_id = BR.bulletin_id ', 'LEFT'];
        }
        return $join;
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
            $where['B.publish_status'] = 1;
            $where['B.store_type'] = $this->adminUser['store_type'];
            $where[] = 'B.visible_range = 1 OR (visible_range = 0 AND find_in_set('.$this->adminUser['store_id'].', B.to_store_ids))';
            $where[] = 'BR.is_del IS NULL OR BR.is_del = 0';
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