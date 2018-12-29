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
                if ($informType != 'all') {
                    break;
                }
            break;
            case 'wechat'://微信模板通知
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
        $userCode = $toUser['phone'];
        if (!$userCode) {
            $this->error = '手机号码为空';
            return FALSE;
        }
        $templateContent = isset($config[$templateType]['template_content']) ? trim($config[$templateType]['template_content']) : '';
        switch ($templateType) {
            case 'reset_pwd':
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
            case 'worder_dispatch_installer':
                $content = $templateContent;
                $param = [];
            break;
            case 'installer_check_fail':
            case 'installer_check_success':
                $name = isset($toUser['realname']) && $toUser['realname'] ? trim($toUser['realname']) : '';
                if ($name) {
                    $name = $this->_splitName($name, TRUE);
                }
                $name .= '师傅';
                $content = $templateContent ? str_replace('${name}', $name, $templateContent) : '';
                $param = [
                    'name' => $name,
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
                $data['result'] = $this->error = '短信通知失败('.trim($result['Message']).')';
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
    function _splitName($fullname, $returnFirst = FALSE){
        $hyphenated = array('欧阳','太史','端木','上官','司马','东方','独孤','南宫','万俟','闻人','夏侯','诸葛','尉迟','公羊','赫连','澹台','皇甫',
            '宗政','濮阳','公冶','太叔','申屠','公孙','慕容','仲孙','钟离','长孙','宇文','城池','司徒','鲜于','司空','汝嫣','闾丘','子车','亓官',
            '司寇','巫马','公西','颛孙','壤驷','公良','漆雕','乐正','宰父','谷梁','拓跋','夹谷','轩辕','令狐','段干','百里','呼延','东郭','南门',
            '羊舌','微生','公户','公玉','公仪','梁丘','公仲','公上','公门','公山','公坚','左丘','公伯','西门','公祖','第五','公乘','贯丘','公皙',
            '南荣','东里','东宫','仲长','子书','子桑','即墨','达奚','褚师');
        $vLength = mb_strlen($fullname, 'utf-8');
        $lastname = '';
        $firstname = '';//前为姓,后为名
        if($vLength > 2){
            $preTwoWords = mb_substr($fullname, 0, 2, 'utf-8');//取命名的前两个字,看是否在复姓库中
            if(in_array($preTwoWords, $hyphenated)){
                $lastname = $preTwoWords;
                $firstname = mb_substr($fullname, 2, 10, 'utf-8');
            }else{
                $lastname = mb_substr($fullname, 0, 1, 'utf-8');
                $firstname = mb_substr($fullname, 1, 10, 'utf-8');
            }
        }else if($vLength == 2){//全名只有两个字时,以前一个为姓,后一下为名
            $lastname = mb_substr($fullname ,0, 1, 'utf-8');
            $firstname = mb_substr($fullname, 1, 10, 'utf-8');
        }else{
            $lastname = $fullname;
        }
        if ($returnFirst !== FALSE) {
            return $lastname;
        }
        return array($lastname, $firstname);
    }
    /*
     * 作用：用*号替代姓名除第一个字之外的字符
     * 参数：
     *
     *
     * 返回值：string
     */
    function _starReplace($name, $num = 0)
    {
        if ($num && mb_strlen($name, 'UTF-8') > $num) {
            return mb_substr($name, 0, 4) . '*';
        }
        
        if ($num && mb_strlen($name, 'UTF-8') <= $num) {
            return $name;
        }
        
        $doubleSurname = [
            '欧阳', '太史', '端木', '上官', '司马', '东方', '独孤', '南宫',
            '万俟', '闻人', '夏侯', '诸葛', '尉迟', '公羊', '赫连', '澹台', '皇甫', '宗政', '濮阳',
            '公冶', '太叔', '申屠', '公孙', '慕容', '仲孙', '钟离', '长孙', '宇文', '司徒', '鲜于',
            '司空', '闾丘', '子车', '亓官', '司寇', '巫马', '公西', '颛孙', '壤驷', '公良', '漆雕', '乐正',
            '宰父', '谷梁', '拓跋', '夹谷', '轩辕', '令狐', '段干', '百里', '呼延', '东郭', '南门', '羊舌',
            '微生', '公户', '公玉', '公仪', '梁丘', '公仲', '公上', '公门', '公山', '公坚', '左丘', '公伯',
            '西门', '公祖', '第五', '公乘', '贯丘', '公皙', '南荣', '东里', '东宫', '仲长', '子书', '子桑',
            '即墨', '达奚', '褚师', '吴铭'
        ];
        
        $surname = mb_substr($name, 0, 2);
        if (in_array($surname, $doubleSurname)) {
            $name = mb_substr($name, 0, 2) . str_repeat('*', (mb_strlen($name, 'UTF-8') - 2));
        } else {
            $name = mb_substr($name, 0, 1) . str_repeat('*', (mb_strlen($name, 'UTF-8') - 1));
        }
        
        
        return $name;
    }
    
}