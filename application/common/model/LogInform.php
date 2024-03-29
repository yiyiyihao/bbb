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
                $result = $this->sendWechatInform($storeId, $informType, $toUser, $templateType, $extra);
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
            case 'service_work_order_add':
                $type=$toUser['workOrderType']==1?"安装":"维修";
                $content = $templateContent ? str_replace('${workOrderType}', $type, $templateContent) : '';
                $content = $content ? str_replace('${worderSn}', $toUser['worderSn'], $content) : '';
                $param = [
                    'workOrderType' => $type,
                    'worderSn' => $toUser['worderSn'],
                ];
                break;
            case 'service_work_order_refuse':
                $content = $templateContent ? str_replace('${workOrderType}', get_work_order_type($toUser['workOrderType']), $templateContent) : '';
                $content = $content ? str_replace('${worderSn}', $toUser['worderSn'], $content) : '';
                $content = $content ? str_replace('${installerName}', $toUser['installerName'], $content) : '';
                $param = [
                    'worderSn'      => $toUser['worderSn'],
                    'workOrderType' => get_work_order_type($toUser['workOrderType']),
                    'installerName' => $toUser['installerName'],
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
    private function sendWechatInform($storeId, $informType, $toUser, $templateType, $extra = [])
    {
        $wechatApi = new \app\common\api\WechatApi(0, 'wechat_h5');
        $appid = isset($wechatApi->config['appid']) ? trim($wechatApi->config['appid']) : '';
        if (!$appid) {
            $this->error = '未配置微信appid';
            return FALSE;
        }
        //判断模板配置里面是否存在配置信息
        $where = [
            ['action_type', '=', $templateType],
            ['tpl_type', '=', 'wechat_notice'],
            ['is_del', '=', 0],
            ['store_id', '=', $storeId],
        ];
        $config = model('TemplateConfig')->where($where)->find();
        if (!$config) {
            $this->error = '未配置微信模板消息';
            return FALSE;
        }
        $templateCode = isset($config['tpl_code']) ? trim($config['tpl_code']) : '';
        if (!$templateCode) {
            $this->error = '微信模板ID不能为空';
            return FALSE;
        }
        $userId = isset($toUser['user_id']) ? intval($toUser['user_id']) : 0;
        $udataId = isset($toUser['udata_id']) ? intval($toUser['udata_id']) : 0;
        $openid = isset($toUser['openid']) ? trim($toUser['openid']) : '';
        if (!$openid) {
            if (!$udataId && !$userId) {
                $this->error = '用户openid为空';
                return FALSE;
            }else{
                if ($udataId){
                    $where = [
                        ['udata_id', '=', $udataId],
                        ['third_type', '=', 'wechat_h5'],
                        ['is_del', '=', 0],
                        ['appid', '=', $appid],
                    ];
                    $udata = model('UserData')->where($where)->find();
                    if (!$udata && !$userId) {
                        $this->error = '用户不存在';
                        return FALSE;
                    }
                    $openid = $udata ? $udata['third_openid'] : '';
                    if ($udata['user_id']) {
                        $userId = $udata['user_id'];
                    }
                }
                if (!$openid && $userId){
                    $where = [
                        ['user_id', '=', $userId],
                        ['third_type', '=', 'wechat_h5'],
                        ['is_del', '=', 0],
                        ['appid', '=', $appid],
                    ];
                    $udata = model('UserData')->where($where)->find();
                    if (!$udata) {
                        $this->error = '用户不存在';
                        return FALSE;
                    }
                    $openid = $udata['third_openid'];
                    $udataId = $udata['udata_id'];
                }
            }
        }
        
        $title = trim($config['title']);
        switch ($templateType) {
            case 'order_pay_success':
                //直接发送会员通知
                $keywords = [
                    'keyword1' => [
                        'value' => $extra['order_sn'],
                        'color' => '#173177',
                    ],
                    'keyword2' => [
                        'value' => $extra['goods_name'],
                        'color' => '#173177',
                    ],
                    'keyword3' => [
                        'value' => $extra['paid_amount'].'元',
                        'color' => '#173177',
                    ],
                    'keyword4' => [
                        'value' => '待发货',
                        'color' => '#173177',
                    ],
                    'keyword5' => [
                        'value' => $extra['add_time'],
                        'color' => '#173177',
                    ],
                ];
                break;
            case 'order_pay_manager':
                $keywords = [
                    'keyword1' => [
                        'value' => $extra['order_sn'],
                        'color' => '#173177',
                    ],
                    'keyword2' => [
                        'value' => $extra['goods_name'],
                        'color' => '#173177',
                    ],
                    'keyword3' => [
                        'value' => $extra['paid_amount'].'元',
                        'color' => '#173177',
                    ],
                    'keyword4' => [
                        'value' => '在线支付',
                        'color' => '#173177',
                    ],
                    'keyword5' => [
                        'value' => $extra['address_name'].', '.$extra['address_phone'].', '.$extra['address_detail'],
                        'color' => '#173177',
                    ],
                ];
                break;
            case 'order_delivery_express'://订单发货
                $keywords = [
                    'keyword1' => [
                        'value' => $extra['order_sn'],
                        'color' => '#173177',
                    ],
                    'keyword2' => [
                        'value' => $extra['goods_name'],
                        'color' => '#173177',
                    ],
                    'keyword3' => [
                        'value' => $extra['delivery_name'],
                        'color' => '#173177',
                    ],
                    'keyword4' => [
                        'value' => $extra['delivery_sn'],
                        'color' => '#173177',
                    ],
                    'keyword5' => [
                        'value' => time_to_date(time()),
                        'color' => '#173177',
                    ],
                ];
                break;
            case 'order_finish'://订单签收
                $keywords = [
                    'keyword1' => [
                        'value' => $extra['order_sn'],
                        'color' => '#173177',
                    ],
                    'keyword2' => [
                        'value' => time_to_date(time()),
                        'color' => '#173177',
                    ],
                ];
                break;
            case 'commission_record'://佣金记录
                $keywords = [
                    'keyword1' => [
                        'value' => $extra['order_sn'],
                        'color' => '#173177',
                    ],
                    'keyword2' => [
                        'value' => time_to_date(time()),
                        'color' => '#173177',
                    ],
                ];
                break;
            case 'withdraw_user_apply'://申请提现
                $keywords = [
                    'keyword1' => [
                        'value' => $extra['amount'].'元',
                        'color' => '#173177',
                    ],
                    'keyword2' => [
                        'value' => time_to_date(time()),
                        'color' => '#173177',
                    ],
                    'keyword3' => [
                        'value' => $extra['arrival_type'],
                        'color' => '#173177',
                    ],
                ];
                break;
            case 'withdraw_user_success'://提现成功
                $keywords = [
                    'keyword1' => [
                        'value' => $extra['arrival_type_txt'],
                        'color' => '#173177',
                    ],
                    'keyword2' => [
                        'value' => $extra['amount'].'元',
                        'color' => '#173177',
                    ],
                    'keyword3' => [
                        'value' => $extra['add_time'],
                        'color' => '#173177',
                    ],
                ];
                break;
            case 'withdraw_user_fail'://提现失败
                $keywords = [
                    'keyword1' => [
                        'value' => $extra['amount'].'元',
                        'color' => '#173177',
                    ],
                    'keyword2' => [
                        'value' => $extra['add_time'],
                        'color' => '#173177',
                    ],
                    'keyword3' => [
                        'value' => '已退回',
                        'color' => '#173177',
                    ],
                    'keyword4' => [
                        'value' => $extra['remark'],
                        'color' => '#173177',
                    ],
                ];
                break;
            case 'sale_income_receipt'://收益到账
            case 'manage_income_receipt'://收益到账
                $username = isset($extra['username']) && trim($extra['username']) ? trim($extra['username']) : '用户';
                $goodsname = isset($extra['goods_name']) && trim($extra['goods_name']) ? trim($extra['goods_name']) : '商品';
                //替换{{username}}{{goodsname}}
                $title = $username ? str_ireplace('{{username}}', $username, $title) : $title;
                $title = $goodsname ? str_ireplace('{{goodsname}}', $goodsname, $title): $title;
                $title = str_ireplace('{{amount}}', $extra['amount'], $title);
                $keywords = [
                    'keyword1' => [
                        'value' => $extra['amount'].'元',
                        'color' => '#173177',
                    ],
                    'keyword2' => [
                        'value' => time_to_date(time()),
                        'color' => '#173177',
                    ],
                ];
                break;
            case 'withdraw_manager_apply'://提醒管理员审核通知
                $username = isset($extra['realname']) && trim($extra['realname']) ? trim($extra['realname']) : '用户';
                //替换{{username}}
                $title = $username ? str_ireplace('{{username}}', $username, $title) : $title;
                $keywords = [
                    'keyword1' => [
                        'value' => $username,
                        'color' => '#173177',
                    ],
                    'keyword2' => [
                        'value' => time_to_date(time()),
                        'color' => '#173177',
                    ],
                    'keyword3' => [
                        'value' => $extra['amount'].'元',
                        'color' => '#173177',
                    ],
                ];
                break;
            case 'user_check_result'://代言人审核结果
            case 'user_check_parent_result'://代言人审核结果
                $username = isset($extra['realname']) && trim($extra['realname']) ? trim($extra['realname']) : '用户';
                //替换{{username}}
                $title = $username ? str_ireplace('{{username}}', $username, $title) : $title;
                $keywords = [
                    'keyword1' => [
                        'value' => $extra['realname'],
                        'color' => '#173177',
                    ],
                    'keyword2' => [
                        'value' => $extra['check_status_text'],
                        'color' => '#173177',
                    ],
                    'keyword3' => [
                        'value' => time_to_date(time()),
                        'color' => '#173177',
                    ],
                ];
                break;
            case 'user_apply_manager'://提醒管理员审核通知
                $keywords = [
                    'keyword1' => [
                        'value' => '代言人审核',
                        'color' => '#173177',
                    ],
                    'keyword2' => [
                        'value' => $extra['realname'],
                        'color' => '#173177',
                    ],
                    'keyword3' => [
                        'value' => time_to_date(time()),
                        'color' => '#173177',
                    ],
                ];
                break;
            default:
                $this->error = lang('PARAM_ERROR');
                return FALSE;
                break;
        }
        $title = $title ? $title: $config['title'];
        $params = $keywords + [
            'first' => [
                'value' => $title,
                'color' => '#173177',
            ],
            'remark' => [
                'value' => $config['description'],
                'color' => '#173177',
            ],
        ];
        $data = [
            'inform_type'   => $informType,
            'store_id'      => $storeId,
            'to_user_id'    => $userId,
            'to_udata_id'   => $udataId,
            'to_user'       => $openid,
            'template_type' => $templateType,
            'template_code' => $templateCode,
            'content'       => json_encode($params),
            'status'        => 0,
            'result'        => '',
            'add_time'      => time(),
        ];
        $informId = $this->insertGetId($data);
        if ($informId !== FALSE) {
            $url = $config['is_click'] && $config['url'] ? trim($config['url']) : '';
            $post = [
                'touser'        => $openid,
                'template_id'   => $templateCode,
                'data'          => $params,
            ];
            if ($url) {
                $post['url'] = $url;//模板跳转链接
            }
            $result = $wechatApi->sendTemplateMessage($post);
            $data = [];
            if ($result && isset($result['errcode']) && !$result['errcode']) {
                $data['status'] = 1;
                $data['result'] = $result['msgid'];
            }else{
                $data['status'] = 0;
                $data['result'] = $this->error = '微信模板消息发送失败('.$wechatApi->error.')';
            }
            $this->where(['inform_id' => $informId])->update($data);
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