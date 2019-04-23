<?php
namespace app\common\model;
use think\Model;

class UserLog extends Model
{
	public $error;
	protected $fields;
	protected $pk = 'log_id';

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
    public function record($userId, $field = 'balance', $value = 0, $actionType = '', $extra = [])
    {
        $userModel = new \app\common\model\User();
        $user = $userModel->where('user_id', $userId)->find();
        if (!$user) {
            return FALSE;
        }
        if ($value != 0) {
            if ($value > 0) {
                $result = $userModel->where('user_id', $userId)->setInc($field, $value);
            }else{
                $result = $userModel->where('user_id', $userId)->setDec($field, abs($value));
            }
            if ($result === FALSE) {
                return FALSE;
            }
        }
        $detail = [
            'value' => $user[$field],//更新之前的数据
            'order_sn' => $extra && isset($extra['order_sn']) ? trim($extra['order_sn']) : '',
            'extra_id' => $extra && isset($extra['extra_id']) ? intval($extra['extra_id']) : '',
        ];
        $data = [
            'user_id'   => $userId,
            'type'      => $field,
            'value'     => $value,
            'action_type' => $actionType,
            'msg'       => $extra && isset($extra['msg']) ? trim($extra['msg']) : '',
            'detail'    => json_encode($detail),
        ];
        return $this->save($data);
    }
}