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
    }
    public function detail()
    {
        $info = $this->_assignInfo();
        $this->assign('info',$info);
        return $this->detail();
    }
    //发布
    public function publish(){
    	$info = $this->_assignInfo();
    	//判断是否已经发布
    	if ($info['publish_status'] > 0) {
    	    $this->error('公告已经发布，不能重复操作');
    	}
        $result = $this->model->where(['bulletin_id' => $info['bulletin_id']])->update(['publish_status' => 1, 'publish_time' => time(), 'update_time' => time()]);
        if($result){
            $this->success('公告发布成功','index');
        }else{
            $this->error('发布失败');
        }
    }
    function _getData()
    {
        $params = $this->request->param();
        $info = $this->_assignInfo();
        $params['region_ids'] = isset($params['region_id']) && $params['region_id'] ? json_encode($params['region_id'], 1): '';
        unset($params['region_id']);
        unset($params['region_name']);
        unset($params['id']);
        if (!$info) {
            $params['post_user_id'] = ADMIN_ID;
            $params['store_id'] = $this->adminUser['admin_type'];
        }
        return $params;
    }
    function _getOrder()
    {
        return 'is_top DESC, sort_order ASC, add_time DESC';
    }
    function _assignInfo($pkId = 0)
    {
        $info = parent::_assignInfo($pkId);
        $storeTypes = get_store_type();
        unset($storeTypes[STORE_FACTORY]);
        $this->assign('types', $storeTypes);
        return $info;
    }
    function _getWhere(){
        $params = $this->request->param();
        $where = [
            'is_del' => 0,
        ];
        if ($params) {
            if(isset($params['status'])){
                $where['publish_status'] = intval($params['status']);
            }
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['name'] = ['like','%'.$name.'%'];
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
            ['type' => 'select', 'name' => 'status', 'options'=>'status', 'default_option' => '==发布状态=='],
        ];
        return $search;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = parent::_tableData();
        $table['actions']['button'][] = ['text'  => '公告查看', 'action'=> 'detail', 'icon'  => '','bgClass'=> 'bg-main'];
        $table['actions']['button'][] = ['text'  => '公告发布', 'class' => 'js-action', 'action'=> 'publish', 'icon'  => 'bell','bgClass'=> 'bg-yellow'];
        $table['actions']['width']  = '*';
        return $table;
    }
}