<?php
namespace app\common\model;
use think\Model;

class LogCode extends Model
{
	protected $fields;
	protected $pk = 'code_id';
	public $error;
	private $codeTypes = [
	    'register'     => '注册',
	    'bind_phone'   => '绑定手机号',
	    'change_phone' => '更换手机号',
	];
	//自定义初始化
    protected function initialize()
    {
        //需要调用`Model`的`initialize`方法
        parent::initialize();
        //TODO:自定义的初始化
    }
    /**
     * 发送短信验证码 
     * @param int $storeId
     * @param string $phone
     * @param string $codeType
     * @return boolean|array
     */
    public function sendSmsCode($storeId, $phone, $codeType = 'bind_phone')
    {
        // 获取短信验证配置
        $config = get_store_config($storeId, TRUE, 'sms');
        if (!$phone) {
            $this->error = '手机号不能为空';
            return FALSE;
        }
        if (!$codeType) {
            $this->error = '验证码类型不能为空';
            return FALSE;
        }
        if(!isset($this->codeTypes[$codeType])){
            $this->error = '验证码类型错误';
            return FALSE;
        }
        $templateCode = isset($config['send_code']['template_code']) ? trim($config['send_code']['template_code']) : '';
        if (!$templateCode) {
            $this->error = '短信配置错误';
            return FALSE;
        }
        //判断短信验证码发送时间间隔
        $exist = $this->where(['phone' => $phone])->order('add_time DESC')->find();
        if ($exist && $exist['add_time'] + 60 >= time()) {
            $this->error = '验证码发送太频繁，请稍后再试';
            return FALSE;
        }
        $code = $this->_getCode();
        $templateContent = isset($config['send_code']['template_content']) ? trim($config['send_code']['template_content']) : '';
        $content = $templateContent ? str_replace('${code}', $code, $templateContent) : '';
        $data = [
            'store_id'  => $storeId,
            'phone'     => $phone,
            'code_type' => $codeType,
            'code'      => $code,
            'status'    => 0,//默认发送失败
            'result'    => '',
            'content'   => $content,
        ];
        $codeId = $this->save($data);
        if ($codeId){
            $smsApi = new \app\common\api\SmsApi($config);
            $param = ['code' => $code];
            $result = $smsApi->send($phone, $templateCode, $param);
            $data = [];
            if ($result && isset($result['Code']) && $result['Code'] == 'OK' && $result['BizId']) {
                $data['status'] = 1;
                $data['result'] = $result['BizId'];
            }else{
                $this->error = isset($result['Message']) ? $result['Message'] : '';
                $data['status'] = 0;
                $data['result'] = '验证码发送失败('.trim($result['Message']).')';
            }
            $this->save($data, ['code_id' => $codeId]);
            return $data;
        }
        $this->error = lang('system_error');
        return FALSE;
    }
    
    /**
     * 验证短信验证码
     * @param array $params
     * @return boolean
     */
    public function verifyCode($params = [])
    {
        $phone      = isset($params['phone']) ? trim($params['phone']) : '';
        $code       = isset($params['code']) ? trim($params['code']) : '';
        $codeType   = isset($params['type']) ? trim($params['type']) : 'bind_phone';
        if (!$phone) {
            $this->error = '手机号不能为空';
            return FALSE;
        }
        if (!$code) {
            $this->error = '验证码不能为空';
            return FALSE;
        }
        if (strlen($code) != 6) {
            $this->error = '验证码长度错误';
            return FALSE;
        }
        if (!$codeType) {
            $this->error = '参数错误';
            return FALSE;
        }
        if(!isset($this->codeTypes[$codeType])){
            $this->error = '验证码类型错误';
            return FALSE;
        }
        //判断短信验证码是否存在
        $exist = $this->where(['phone' => $phone, 'status' => 1, 'code' => $code, 'code_type' => $codeType])->order('add_time DESC')->find();
        if (!$exist) {
            $this->error = '验证码错误';
            return FALSE;
        }
        $addTime = is_int($exist['add_time']) ?$exist['add_time'] : strtotime($exist['add_time']);
        
        $this->where(['phone' => $phone, 'code_type' => $codeType])->delete();
        if ($addTime + 5*60 < time()) {
            $this->error = '验证码已失效';
            return FALSE;
        }
        //删除当前手机号已失效的验证码
        $this->where(['phone' => $phone, 'add_time' => ['<=', time()-5*60]])->delete();
        return TRUE;
    }
    /**
     * 获取短信验证码
     * @return 产生的随机字符串
     */
    private function _getCode()
    {
        $code = get_nonce_str(6, 2);
        $exist = db('log_code')->where(['code' => $code])->find();
        if ($exist){
            return $this->_getCode();
        }else{
            return $code;
        }
    }
}