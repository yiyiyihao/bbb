<?php
namespace app\common\model;
use think\Model;

class LogInform extends Model
{
	protected $fields;
	protected $pk = 'inform_id';
	public $error;
	private $tplTypes = [
	    'resetPwd' => '重置密码',
	];

	//自定义初始化
    protected function initialize()
    {
        //需要调用`Model`的`initialize`方法
        parent::initialize();
        //TODO:自定义的初始化
    }
    public function sendInform($storeId, $informType, $toUser, $templateType, $extra = [])
    {
        switch ($informType) {
            case 'sms': //短信通知
            case 'all': //全部通知
                $result = $this->sendSmsInform($storeId, $informType, $toUser, $templateType, $extra);
                if ($informType != 'all') {
                    break;
                }
            case 'wechat_applet'://微信小程序通知
                $result = $this->sendSmsInform($storeId, $informType, $toUser, $templateType, $extra);
                if ($informType != 'all') {
                    break;
                }
            break;
            case 'wechat'://微信模板通知
                $result = $this->sendSmsInform($storeId, $informType, $toUser, $templateType, $extra);
                if ($informType != 'all') {
                    break;
                }
            default:
                ;
            break;
        }
        if ($result === FALSE) {
            return FALSE;
        }
        return TRUE;
    }
    private function sendSmsInform($storeId, $informType, $toUser, $templateType, $extra = [])
    {
        // 获取短信验证配置
        $config = get_store_config($storeId, TRUE, 'sms');
        $templateCode = isset($config[$templateType]['template_code']) ? trim($config[$templateType]['template_code']) : '';
        if (!$templateCode) {
            $this->error = '短信模版CODE配置错误';
            return FALSE;
        }
        $userCode = '';
        $templateContent = isset($config[$templateType]['template_content']) ? trim($config[$templateType]['template_content']) : '';
        switch ($templateType) {
            case 'reset_pwd':
                $userCode = $toUser['phone'];
                $password = isset($extra['password']) && $extra['password'] ? trim($extra['password']) : '用户';
                if (!$userCode) {
                    $this->error = '当前用户未绑定手机号';
                    return FALSE;
                }
                if (!$password) {
                    $this->error = '重置的密码不能为空';
                    return FALSE;
                }
                $name = isset($extra['name']) && $extra['name'] ? trim($extra['name']) : '用户';
                $content = $templateContent ? str_replace('${name}', $name, $templateContent) : '';
                $content = $content ? str_replace('${password}', $password, $content) : '';
                $param = [
                    'name' => $name,
                    'password' => $password,
                ];
            break;
            default:
                $this->error = lang('PARAM_ERROR');
                return FALSE;
            break;
        }
        $data = [
            'inform_type'   => $informType,
            'store_id'      => $storeId,
            'to_user_id'    => $toUser['user_id'],
            'to_user'       => $userCode,
            'template_type' => $templateType,
            'template_code' => $templateCode,
            'content'       => $content,
            'status'        => 0,
            'result'        => '',
        ];
        $informId = $this->save($data);
        if ($informId) {
            $smsApi = new \app\common\api\SmsApi($config);
            $result = $smsApi->send($userCode, $templateCode, $param);
            $data = [];
            if ($result && isset($result['Code']) && $result['Code'] == 'OK' && $result['BizId']) {
                $data['status'] = 1;
                $data['result'] = $result['BizId'];
            }else{
                $this->error = isset($result['Message']) ? $result['Message'] : '';
                $data['status'] = 0;
                $data['result'] = $this->error = trim($result['Message']);
            }
            $this->save($data, ['inform_id' => $informId]);
            if ($this->error) {
                return FALSE;
            }else{
                return TRUE;
            }
        }else{
            $this->error = lang('SYSTEM_ERROR');
            return false;
        }
    }
}