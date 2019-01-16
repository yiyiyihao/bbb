<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/1/9 0009
 * Time: 18:18
 */

namespace app\api\controller;

use app\common\model\LogCode;
use app\common\model\Store;
use app\common\model\User;
use app\common\model\WebArticle;
use app\common\model\WebBanner;
use app\common\model\WebConfig;
use app\common\model\WebMenu;
use app\common\model\WebPage;
use app\factory\controller\Service;
use think\facade\Request;


class Web extends BaseApi
{
    private $store_id;
    private $factory_id;

    public function initialize()
    {
        //放过所有跨域
        $origin = isset($_SERVER['HTTP_ORIGIN']) ? $_SERVER['HTTP_ORIGIN'] : '';
        header('Access-Control-Allow-Origin:' . $origin);
        header('Access-Control-Allow-Methods:POST');
        header('Access-Control-Allow-Headers:x-requested-with,content-type');

        $this->factory_id = 1;
        $this->store_id = 1;
        //$domain = Request::subDomain();
        //if ($domain === 'www') {
        //    //www绑定到 万家安
        //    $this->factory_id = 1;
        //    $this->store_id = 1;
        //}
    }


    //公司动态
    public function company_dynamic()
    {
        $page = input('page', 1, 'intval');
        $limit = input('limit', 10, 'intval');
        $data = WebArticle::field('id,title,update_time,summary,cover_img')->where([
            'store_id' => $this->store_id,
            'is_del' => 0,
            'status' => 1,
            'sys_menu_id' => 2,
        ])->page($page)->limit($limit)->select();
        return returnMsg(0, 'ok', $data);
    }


    //轮播图
    public function banner()
    {
        $banner = WebBanner::field('id,img_url,link_url')->where([
            'type' => 0,
            'store_id' => $this->store_id
        ])->limit(8)->select();
        return returnMsg(0, 'ok', $banner);
    }


    //顶部导航
    public function nav_top()
    {
        $data = WebMenu::alias('m')
            ->field('m.id,m.page_id,m.url,m.sort,m.name,p.title,m.page_type')
            ->join('web_page p', 'm.page_id = p.id', 'left')
            ->where([
                'm.parent_id' => 0,
                'm.is_del' => 0,
                'm.store_id' => $this->store_id,
                'm.type' => 0,
            ])->order('sort')->select();
        $menu = $data->map(function ($item) {
            $arr['name'] = $item['name'];
            $arr['url'] = $item['url'];
            $arr['page_type'] = $item['page_type'];
            if ($item['page_type'] == 0) {
                //$arr['url'] = url('page/index', ['id' => $item['page_id']]);
                $arr['url'] = '/page?id=' . $item['page_id'];
            }
            return $arr;
        })->toArray();
        $sysMenu = config('sysmenu.');
        $sysMenu = array_map(function ($item) {
            return [
                'name' => $item['name'],
                'url' => $item['url'],
                'page_type' => 0,
            ];
        }, $sysMenu);
        return returnMsg(0, 'ok', array_merge($sysMenu, $menu));
    }

    //底部导航
    public function nav_bottom()
    {
        $data = WebMenu::alias('m')
            ->field('m.id,m.parent_id,m.page_id,m.url,m.sort,m.name,p.title,m.page_type')
            ->join('web_page p', 'm.page_id = p.id', 'left')
            ->where([
                'm.is_del' => 0,
                'm.store_id' => $this->store_id,
                'm.type' => 1,
            ])->order('sort')->select()->toArray();
        $data = array_map(function ($item) {
            $arr['id'] = $item['id'];
            $arr['name'] = $item['name'];
            $arr['parent_id'] = $item['parent_id'];
            $arr['url'] = $item['url'];
            $arr['page_type'] = $item['page_type'];
            if ($item['page_type'] == 0) {
                //$arr['url'] = url('page/index', ['id' => $item['page_id']]);
                $arr['url'] = '/page?id=' . $item['page_id'];
            }
            return $arr;
        }, $data);
        $result['list'] = getTree($data);
        $config = WebConfig::where('store_id', $this->store_id)->value('value');
        $config = json_decode($config, true);
        //unset($config['logo'], $config['login_bg']);
        return returnMsg(0, 'ok', array_merge($config, $result));
    }

    //获取首页新闻
    public function getTopNews()
    {
        $data = WebArticle::field('id,title,cover_img,summary,update_time')->where([
            'is_del' => 0,
            'store_id' => $this->store_id,
            'status' => 1,
            'is_top' => 1,
        ])->order('update_time desc')->limit(3)->select();
        $data = $data->map(function ($item) {
            $arr = $item;
            if (mb_strlen($arr['summary']) > 120) {
                $arr['summary'] = mb_substr($arr['summary'], 0, 120) . '...';
            }
            $arr['url'] = url('article/index', ['id' => $item['id']], false, true);
            return $arr;
        });
        return returnMsg(0, 'ok', $data);
    }

    //获得地区列表
    public function getRegion()
    {
        $id = input('id', 1, 'intval');
        $model = db('region');
        $data = $model->field('region_id id,region_name name')->where([
            'is_del' => 0,
            'parent_id' => $id,
        ])->order('sort_order')->select();
        return returnMsg(0, 'ok', $data);
    }

    //零售商查询
    public function getRetailer()
    {
        $where = [
            'is_del' => 0,
            'check_status'    => 1,
            'store_type'    => STORE_DEALER,
            'factory_id' => $this->store_id,];
        $region_id = input('region_id', 0, 'intval');
        $type = input('region_type', 0, 'intval');
        $region = db('region');
        if ($type == 3) {//区/县
            $where['region_id'] = $region_id;
        } else if ($type == 2) {//市
            $region_arr = $region->where([
                'parent_id' => $region_id
            ])->column('region_id');
            array_push($region_arr, $region_id);
            $where['region_id'] = ['in', $region_arr];
        } else if ($type == 1) {//省
            //市
            $region_arr = $region->alias('p')
                ->field('c.region_id c_id,d.region_id d_id')
                ->join([
                    ['region c', 'p.region_id = c.parent_id'],
                    ['region d', 'd.parent_id = c.region_id'],
                ])->where([
                    'p.region_id' => $region_id,
                    'p.is_del' => 0,
                    'c.is_del' => 0,
                    'd.is_del' => 0
                ])->select();
            $arr_1 = array_unique(array_column($region_arr, 'c_id'));//市
            $arr_2 = array_column($region_arr, 'd_id');//区/县
            $region_arr = array_merge($arr_1, $arr_2);
            $where['region_id'] = ['in', $region_arr];
        }

        $result = Store::field('name as region_name,address,mobile')->where($where)->select();
        //$result = $data->map(function ($item) {
        //    $item['region_name'] = str_replace(' ', '', $item['region_name']);
        //    return $item;
        //});
        return returnMsg(0, 'ok', $result);
    }

    //发送信息
    public function sendCode()
    {
        $phone = input('phone');
        if (empty($phone)) {
            return returnMsg(1, '手机号不能为空');
        }
        if (!preg_match('/^1[0-9]{10}$/', $phone)) {
            return returnMsg(1, '手机码码格式不正确');
        }

        $userModel = new User;
        $result = $userModel->checkPhone($this->factory_id, $phone, TRUE);
        if ($result===false){
            return returnMsg(1, $userModel->error);
        }

        $codeModel = new \app\common\model\LogCode();

        $result = $codeModel->sendSmsCode($this->store_id, $phone, 'register');
        if (!$result['status']) {
            return returnMsg(1, $result['result']);
        } else {
            return returnMsg(0, '验证码发送成功,请注意留意短信');
        }
    }

    //商户注册
    public function applyStepOne()
    {
        $storeModel = new Store();
        $factory = $storeModel->alias('S')
            ->join('store_factory SF', 'SF.store_id = S.store_id', 'INNER')
            ->where(['S.store_id' => $this->store_id, 'store_type' => STORE_FACTORY, 'is_del' => 0, 'status' => 1])
            ->find();
        if (empty($factory)) {
            return returnMsg(1, lang('param_error'));
        }
        $factoryId = $factory['store_id'];
        $allow = input('allow', '');
        $phone = input('phone', '', 'trim');
        $password = input('password', '', 'trim');
        $rePassword = input('repassword', '', 'trim');
        if (!$phone) {
            return returnMsg(1, '请填写手机号码');
        }
        $code = input('code', '');
        if (!$code) {
            return returnMsg(1, '验证码不能为空');
        }
        if (empty($password) || empty($rePassword)) {
            return returnMsg(1, '密码及确认密码不能为空');
        }
        if ($password != $rePassword) {
            return returnMsg(1, '两次输入密码不一致');
        }
        if (!$allow) {
            return returnMsg(1, '请先同意用户协议');
        }

        $userModel = new User;
        $result = $userModel->checkPhone($factoryId, $phone, TRUE);
        if ($result === FALSE) {
            //补充资料applyStepTwo时是否中断，是则跳过applyStepOne
            if ($userModel->error == '手机号已存在') {
                $user = $userModel->where([
                    'username' => $phone,
                    'is_del' => 0,
                    'status' => 1,
                    'store_id' => 0,
                    'admin_type' => 0,
                    'group_id' => 0,
                ])->find();
                if (!empty($user)) {
                    return returnMsg(100, '请继续完善资料', ['user_id' => $user['user_id']]);
                }
            }
            return returnMsg(1, $userModel->error);
        }
        $extra = [
            'password' => $password,
        ];
        $result = $userModel->checkFormat($factoryId, $extra);
        if ($result === FALSE) {
            return returnMsg(1, $userModel->error);
        }
        $codeModel = new LogCode;
        $params['type'] = 'register';
        $params['code'] = $code;
        $params['phone'] = $phone;
        $result = $codeModel->verifyCode($params);
        $result = TRUE;
        if ($result === FALSE) {
            return returnMsg(1, $codeModel->error);
        } else {
            //新增账号
            $param['phone'] = $phone;
            $param['username'] = $phone;
            $param['admin_type'] = 0;
            $param['factory_id'] = $factoryId;
            $param['store_id'] = 0;
            $param['is_admin'] = 1;
            $param['password'] = $userModel->pwdEncryption($password);
            $param['group_id'] = 0;
            $userId = $userModel->save($param);
            if ($userId === FALSE) {
                return returnMsg(1, '系统异常，请重新提交');
            } else {
                return returnMsg(0, '注册成功,请完善资料', ['user_id' => $userId]);
                //$this->success('注册成功,请完善资料', url('apply', ['store_no' => $storeNo, 'step' => 2, 'user_id' => $userId]));
            }
        }
    }

    //完善资料
    public function applyStepTwo()
    {
        $storeModel = new Store();
        $factory = $storeModel->alias('S')
            ->join('store_factory SF', 'SF.store_id = S.store_id', 'INNER')
            ->where(['S.store_id' => $this->store_id, 'store_type' => STORE_FACTORY, 'is_del' => 0, 'status' => 1])
            ->find();
        if (empty($factory)) {
            return returnMsg(1, lang('param_error'));
        }
        $factoryId = $factory['store_id'];
        $type = input('type', 0, 'intval');
        if (!in_array($type, [2, 3, 4])) {
            return returnMsg(1, '商户类型不正确，请重新选择');
        }
        $channelNo = input('channel_no', 0, 'trim');
        $name = input('name', 0, 'trim');
        $userName = input('user_name', 0, 'trim');
        if (empty($name)) {
            return returnMsg(1, '商户名称不能为空');
        }
        if (empty($userName)) {
            return returnMsg(1, '联系人姓名不能为空');
        }

        $userId = input('user_id', 0, 'intval');
        if (!$userId) {
            return returnMsg(11, lang('param_error'));
        }
        //判断用户是否已绑定商户账号
        $userModel = new User;
        $user = $userModel->where([
            'user_id' => $userId,
            'is_del' => 0,
            'status' => 1,
        ])->find();
        if (empty($user)) {
            return returnMsg(1, '商户不存在或已被删除');
        }
        if ($user['store_id'] > 0) {
            $check_status = Store::where([
                'store_id' => $user['store_id'],
                'is_del' => 0,
                'status' => 1,
            ])->value('check_status');
            if ($check_status == 1) {
                return returnMsg(1, '该商户已经通过审核');
            }
        }
        //if ($user['admin_type'] > 0 || $user['store_id'] > 0) {
        //    return returnMsg(1, '该商户已经提交过资料');
        //}

        if ($user['factory_id'] != $factory['store_id']) {
            return returnMsg(1, '商户与厂商对应关系不正确');
        }

        //$where = ['name' => $name, 'is_del' => 0, 'factory_id' => $factoryId, 'store_type' => $type];
        //$exist = $storeModel->where($where)->count();
        $types = [
            STORE_DEALER => [
                'name' => '零售商',
                'desc' => '适合拥有线下或线上销售渠道的商户',
                'admin_type' => ADMIN_DEALER,
                'group_id' => GROUP_DEALER,
            ],
            STORE_CHANNEL => [
                'name' => '渠道商',
                'desc' => '拥有一定的市场资源，有能力发展零售商的商户',
                'admin_type' => ADMIN_CHANNEL,
                'group_id' => GROUP_CHANNEL,
            ],
            STORE_SERVICE => [
                'name' => '服务商',
                'desc' => '拥有售后安装，维修能力或资源，能够提供售后服务的商户',
                'admin_type' => ADMIN_SERVICE,
                'group_id' => GROUP_SERVICE,
            ],
        ];
        //if ($exist > 0) {
        //    return returnMsg(1, $types[$type]['name'] . '名称已存在');
        //}

        $ostore_id = 0;
        if ($type == STORE_DEALER) {
            if (!$channelNo) {
                return returnMsg(1, '请填写渠道商编号');
            }
            $channel = $storeModel->where(['store_no' => $channelNo, 'store_type' => STORE_CHANNEL, 'is_del' => 0, 'status' => 1])->find();
            if (!$channel) {
                return returnMsg(1, '渠道商不存在或已删除');
            }
            $ostore_id = $channel['store_id'];
        }

        $sample_amount = input('sample_amount', 0);
        if (Request::has('sample_amount')) {
            $sample_amount = sprintf('%.2f', floatval($sample_amount));
            if (strlen($sample_amount) > 11) {
                $array = explode('.', $sample_amount);
                $sample_amount = substr($array[0], 0, 8);
                $sample_amount = $sample_amount . '.' . $array[1];
            }
        }
        $security_money = input('security_money', 0);
        if (Request::has('security_money')) {
            $security_money = sprintf('%.2f', floatval($security_money));
            if (strlen($security_money) > 11) {
                $array = explode('.', $security_money);
                $security_money = substr($array[0], 0, 8);
                $security_money = $security_money . '.' . $array[1];
            }
        }
        $where = [];
        if ($user['admin_type'] > 0 || $user['store_id'] > 0) {
            //存在商户审核信息则更新厂商申请资料，否则新增
            $where['store_id'] = $user['store_id'];
        }
        $data = [
            'name' => $name,
            'user_name' => $userName,
            'store_type' => $type,
            'factory_id' => $factoryId,
            'mobile' => $user['phone'],
            'config_json' => '',
            'check_status' => 0,
            'admin_remark' => '',
            'security_money' => $security_money,
            'idcard_font_img' => input('idcard_font_img', '', 'trim'),
            'idcard_back_img' => input('idcard_back_img', '', 'trim'),
            'signing_contract_img' => input('signing_contract_img', '', 'trim'),
            'license_img' => input('license_img', '', 'trim'),
            'group_photo' => input('group_photo', '', 'trim'),
            'address' => input('address', '', 'trim'),
            'region_id' => input('region_id', 0, 'intval'),
            'region_name' => input('region_name', '', 'trim'),
            'enter_type' => 1,
            'sample_amount' => $sample_amount,
            'ostore_id' => $ostore_id,
        ];
        $storeId = $storeModel->save($data, $where);
        if ($storeId === FALSE) {
            return returnMsg(1, '资料更新失败,请登陆后操作');
        } else {
            $data = [
                'admin_type' => $types[$type]['admin_type'],
                'group_id' => $types[$type]['group_id'],
                'store_id' => $storeModel->store_id,
            ];
            if (!$user['realname']) {
                $data['realname'] = $userName;
            }
            $userModel->save($data, ['user_id' => $userId]);
            return returnMsg(0, '入驻申请成功,请登录后台查看审核进度');
        }
    }

    //查询商户信息
    public function getStoreInfo()
    {
        $user_id = input('user_id', 0, 'intval');
        if ($user_id <= 0) {
            return returnMsg(0, lang('param_error'));
        }
        $storeModel = new Store();
        //$field = 'U.user_id,S.*,S.store_type type';
        $field = 'U.user_id,S.store_type type,S.`name`,S.user_name,S.mobile,S.address,S.idcard_font_img,S.idcard_back_img,S.license_img,S.signing_contract_img,S.security_money,S.group_photo,S.admin_remark,S.region_id,S.region_name,S.check_status,U.store_id';
        $where = [
            'U.is_del' => 0,
            'U.status' => 1,
            'S.is_del' => 0,
            'S.status' => 1,
            'U.user_id' => $user_id,
        ];
        $store = $storeModel->alias('S')
            ->field($field)
            ->join('user U', 'U.store_id = S.store_id')
            ->where($where)
            ->find();
        if (empty($store)) {
            return returnMsg(101, '商户不存在，请新重新注册');
        }
        if ($store['check_status'] == 1) {
            return returnMsg(102, '商户已通过审核');
        }
        $store['channel_no'] = 0;
        $store['sample_amount'] = 0;
        if ($store['type'] == STORE_DEALER) {
            $field = 'SD.sample_amount,S.store_no channel_no';
            $arr = Dealer::alias('SD')->field($field)
                ->join('store S', 'SD.ostore_id=S.store_id')
                ->where('SD.store_id', $store['store_id'])
                ->find();
            $store['channel_no'] = isset($arr['channel_no']) ? $arr['channel_no'] : 0;
            $store['sample_amount'] = isset($arr['sample_amount']) ? $arr['sample_amount'] : 0;
        }
        unset($store['check_status'], $store['store_id']);
        return returnMsg(0, 'ok', $store);
    }

    //新闻详情
    public function newsInfo()
    {
        $id = input('id', '', 'intval');
        $data = WebArticle::field('title,summary,content,cover_img,update_time')->where(['is_del' => 0])->get($id);
        return returnMsg(0, 'ok', $data);
    }

    //页面详情
    public function getPageInfo()
    {
        $id = input('id', '', 'intval');
        $data = WebPage::field('title,content,update_time')->where(['is_del' => 0])->get($id);
        return returnMsg(0, 'ok', $data);
    }


}