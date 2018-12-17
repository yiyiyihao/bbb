<?php
namespace app\common\model;
use think\Model;

class BulletinLog extends Model
{
	public $error;
	protected $pk = 'log_id';
	protected $table;
	
	protected $field = true;
	protected $bulletinModel;
	//自定义初始化
	protected function initialize()
	{
	    $this->table = $this->config['prefix'].'bulletin_log';
	    $this->bulletinModel = db('bulletin');
	    parent::initialize();
	}
	public function getBulletinDetail($bulletin, $user)
	{
	    if (!$bulletin || !$user) {
	        $this->error = lang('param_error');
	        return FALSE;
	    }
	    if($user['admin_type'] == ADMIN_FACTORY){
	        $this->error = lang('NO ACCESS');
	        return FALSE;
	    }
	    $where = [
	        'store_type' => $user['store_type'],
	        'publish_status' => 1,
	        'visible_range = 1 OR (visible_range = 0 AND find_in_set('.$user['store_id'].', to_store_ids))',
	    ];
	    //判断当前用户是否有当前公告的阅读权限
	    $bulletin = $this->bulletinModel->where($where)->find();
	    if(!$bulletin){
	        $this->error = lang('param_error');
	        return FALSE;
	    }
	    return $bulletin;
	}
	/**
	 * 公告阅读
	 * @param array $bulletin
	 * @param array $user
	 * @param array $extra
	 * @return boolean
	 */
	public function read($bulletin, $user, $extra = [])
	{
	    $bulletin = $this->getBulletinDetail($bulletin, $user);
	    if ($bulletin === FALSE) {
	        return FALSE;
	    }
	    $hasDisplay = isset($extra['special_display']) ? intval($extra['special_display']) : 0;
	    //判断当前公告是否已阅读
	    $exist = $this->where(['bulletin_id' => $bulletin['bulletin_id'], 'user_id' => $user['user_id'], 'store_id' => $user['store_id']])->find();
	    if (!$exist){
	        $data = [
	            'bulletin_id' => $bulletin['bulletin_id'],
	            'user_id' => $user['user_id'], 
	            'store_id' => $user['store_id'],
	            'is_read' => 1,
	            'has_display' => $hasDisplay,
	        ];
	        $logId = $this->save($data);
	    }
	    return TRUE;
	}
	/**
	 * 删除公告[删除后不显示]
	 * @param array $bulletin
	 * @param array $user
	 * @return boolean
	 */
	public function drop($bulletin, $user)
	{
	    $bulletin = $this->getBulletinDetail($bulletin, $user);
	    if ($bulletin === FALSE) {
	        return FALSE;
	    }
	    //判断当前公告是否已阅读
	    $exist = $this->where(['bulletin_id' => $bulletin['bulletin_id'], 'user_id' => $user['user_id'], 'store_id' => $user['store_id'], 'is_read' => 1])->find();
	    if (!$exist){
	        $data = [
	            'bulletin_id' => $bulletin['bulletin_id'],
	            'user_id' => $user['user_id'],
	            'store_id' => $user['store_id'],
	            'is_del' => 1,
	        ];
	        $result = $this->save($data);
	    }else{
	        $result = $this->save(['is_del' => 1], ['log_id' => $bulletin['log_id']]);
	    }
	    return TRUE;
	}
	
	
}