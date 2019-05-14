<?php
namespace app\common\model;
use think\Model;

class UserData extends Model
{
	public $error;
	protected $fields;
	protected $pk = 'udata_id';

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
    public function phoneExist($fatoryId, $phone, $userType = 'user')
    {
        $map = [
            ['phone',       '=', $phone],
            ['factory_id',  '=', $fatoryId],
            ['user_type',   '=', $userType],
            ['is_del',      '=', 0],
        ];
        $exist = $this->where($map)->find();
        if ($exist) {
            $this->error = '当前手机号已注册';
            return FALSE;
        }
        return TRUE;
    }
}