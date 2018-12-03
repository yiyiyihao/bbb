<?php
namespace app\common\model;
use think\Model;

class WorkOrder extends Model
{
	public $error;
	protected $fields;
	protected $pk = 'worder_id';

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
    public function save($data = [], $where = [], $sequence = null)
    {
        parent::checkBeforeSave($data, $where);
        if (!$this->checkBeforeSave($data, $where)) {
            return false;
        }
        $flag = $this->exists;
        $result = $worderId = parent::save($data, $where, $sequence);
        if (!$flag) {
            $sn = $this->_getWorderSn();
            $this->save(['worder_sn' => $sn], ['worder_id' => $worderId]);
            //工单创建成功后填写工单号
            $result = $this->_checkWorder($worderId, $data['post_user_id']);
            $worder = $result['worder'];
            $user = $result['user'];
            $this->_worderLog($worder, $user, '创建工单');
        }
        return $result;
    }
    /**
     * 分配安装员操作
     * @param int $worderId
     * @param int $userId
     * @param int $installerId
     * @return boolean
     */
    public function dispatchWorder($worderId = 0, $userId = 0, $installerId = 0)
    {
        $result = $this->_checkWorder($worderId, $userId);
        if ($result === FALSE) {
            return FALSE;
        }
        $worder = $result['worder'];
        $user = $result['user'];
        //判断用户是否有分派工程师权限(仅服务商有分派工程师权限)
        if ($user['admin_type'] == ADMIN_SERVICE && $user['store_id'] == $worder['store_id']) {
            $this->error = '当前账户无操作权限';
            return FALSE;
        }
        $installer = db('user_installer')->where(['installer_id' => $installerId, 'is_del' => 0, 'store_id' => $worder['store_id']])->find();
        if (!$installer) {
            $this->error = '售后工程师不存在或已删除';
            return FALSE;
        }
        if (!$installer['status']) {
            $this->error = '售后工程师已禁用，请启用后选择';
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['status']) {
            case -1:
                $this->error = '工单已取消,无操作权限';
                return FALSE;
            case 1:#TODO 指派后是否可另外指派
                $this->error = '工单已指派安装员,无操作权限';
                return FALSE;
            case 2:
                $this->error = '工单已接收,无操作权限';
                return FALSE;
            case 3:
                $this->error = '工程师服务中,无操作权限';
                return FALSE;
            case 4:
                $this->error = '服务已完成,无操作权限';
                return FALSE;
            default:
                ;
                break;
        }
        $result = $this->save(['status' => 1, 'installer_id' => $installerId, 'dispatch_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $msg = '工程师姓名:'.$installer['realname'].'<br>工程师电话:'.$installer['phone'];
            $this->_worderLog($worder, $user, '分派售后工程师', $msg);
            return TRUE;
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    /**
     * 工程师接单操作
     * @param array $worder
     * @param array $user
     * @param array $installer
     * @return boolean
     */
    public function receiveWorder($worder, $user, $installer)
    {
        if ($worder['installer_id'] != $installer['installer_id']) {
            $this->error = '无操作权限';
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['status']) {
            case -1:
                $this->error = '工单已取消,无操作权限';
                return FALSE;
            case 0:
                $this->error = '工单待分派工程师,无操作权限';
                return FALSE;
            case 2:
                $this->error = '工单已接收,无操作权限';
                return FALSE;
            case 3:
                $this->error = '工程师服务中,无操作权限';
                return FALSE;
            case 4:
                $this->error = '服务已完成,无操作权限';
                return FALSE;
            default:
                ;
                break;
        }
        $result = $this->save(['status' => 2, 'receive_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $this->_worderLog($worder, $user, '工程师接单');
            return TRUE;
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    /**
     * 工程师签到操作
     * @param array $worder
     * @param array $user
     * @param array $installer
     * @return boolean
     */
    public function signWorder($worder, $user, $installer)
    {
        if ($worder['installer_id'] != $installer['installer_id']) {
            $this->error = '无操作权限';
            return FALSE;
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['status']) {
            case -1:
                $this->error = '工单已取消,无操作权限';
                return FALSE;
            case 0:
                $this->error = '工单待分派工程师,无操作权限';
                return FALSE;
            case 1:
                $this->error = '工单待接单,无操作权限';
                return FALSE;
            case 3:
                $this->error = '工程师服务中,无操作权限';
                return FALSE;
            case 4:
                $this->error = '服务已完成,无操作权限';
                return FALSE;
            default:
                ;
                break;
        }
        $result = $this->save(['status' => 3, 'sign_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $this->_worderLog($worder, $user, '工程师签到,服务开始');
            return TRUE;
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    public function finishWorder($worder, $user)
    {
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['status']) {
            case -1:
                $this->error = '工单已取消,无操作权限';
                return FALSE;
            case 0:
                $this->error = '待分派工程师,无操作权限';
                return FALSE;
            case 1:
                $this->error = '待接单,无操作权限';
                return FALSE;
            case 2:
                $this->error = '待上门,无操作权限';
                return FALSE;
            case 4:
                $this->error = '服务已完成,无操作权限';
                return FALSE;
        }
        $result = $this->save(['status' => 4, 'finish_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $this->_worderLog($worder, $user, '确认完成');
            return TRUE;
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
        
    /**
     * 取消工单操作
     * @param int $worderId
     * @param int $userId
     * @return boolean
     */
    public function cancelWorder($worderId = 0, $userId = 0)
    {
        if (is_array($worderId) && is_array($worderId)) {
            $worder = $worderId;
            $user = $userId;
        }else{
            $result = $this->_checkWorder($worderId, $userId);
            if ($result === FALSE) {
                return FALSE;
            }
            $worder = $result['worder'];
            $user = $result['user'];
        }
        //状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
        switch ($worder['status']) {
            case -1:
                $this->error = '工单已取消,无操作权限';
                return FALSE;
            case 3:
                $this->error = '工程师服务中,无操作权限';
                return FALSE;
            case 4:
                $this->error = '服务已完成,无操作权限';
                return FALSE;
            default:
                ;
                break;
        }
        #TODO 判断用户是否有取消权限
        $result = $this->save(['status' => -1, 'cancel_time' => time()], ['worder_id' => $worder['worder_id']]);
        if ($result !== FALSE) {
            //操作日志记录
            $this->_worderLog($worder, $user, '取消工单', '');
        }else{
            $this->error = '系统异常';
            return FALSE;
        }
    }
    /**
     * 工单日志记录操作
     * @param array $worder
     * @param array $user
     * @param string $action
     * @param string $msg
     * @return number|string
     */
    public function _worderLog($worder, $user, $action = '', $msg = '')
    {
        $nickname = isset($user['realname']) && $user['realname'] ? $user['realname'] : (isset($user['nickname']) && $user['nickname'] ? $user['nickname'] : (isset($user['username']) && $user['username'] ? $user['username'] : ''));
        $data = [
            'worder_id' => $worder['worder_id'],
            'worder_sn' => $worder['worder_sn'],
            'user_id'   => $user['user_id'],
            'nickname'  => $nickname,
            'action'    => $action,
            'msg'       => $msg,
            'add_time'  => time(),
        ];
        return $result = db('work_order_log')->insertGetId($data);
    }
    private function _getWorderSn($sn = '')
    {
        $sn = $sn ? $sn : date('YmdHis').get_nonce_str(6, 2);
        //判断售后工单号是否存在
        $info = $this->where(['worder_sn' => $sn])->find();
        if ($info){
            return $this->_getWorderSn();
        }else{
            return $sn;
        }
    }
    private function _checkWorder($worderId = 0, $userId = 0)
    {
        if (!$worderId) {
            $this->error = '参数错误';
            return FALSE;
        }
        $info = $this->where(['worder_id' => $worderId, 'is_del' => 0])->find();
        if(!$info){
            $this->error = '售后工单不存在或已删除';
            return FALSE;
        }
        if ($userId > 0) {
            $user = db('user')->where(['user_id' => $userId, 'is_del' => 0])->find();
            if (!$user) {
                $this->error = '操作用户不存在或已删除';
                return FALSE;
            }
            if ($user['status'] != 1) {
                $this->error = '操作用户已禁用';
                return FALSE;
            }
        }else{
            $user = [
                'user_id' => 0,
                'nickname' => '系统',
            ];
        }
        #TODO判断用户是否有操作权限
        return [
            'worder' => $info,
            'user' => $user,
        ];
    }
}