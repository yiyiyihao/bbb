<?php
namespace app\common\model;
use think\Model;

class UserWithdraw extends Model
{
	public $error;
	protected $fields;
	protected $pk = 'log_id';
	public $arrivalTypes = [
	    'bank' => '银行卡',
	    'wechat_wallet' => '微信零钱',
	];

	//自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
    public function getTradeNo()
    {
        $no = 'TX'.date('YmdHis').substr(implode(NULL, array_map('ord', str_split(substr(uniqid(), 7, 13), 1))), 0, 6).get_nonce_str(2, 2);
        $exist = $this->where(['trade_no' => $no])->find();
        if ($exist) {
            return $this->getTradeNo();
        }else{
            return $no;
        }
    }
}