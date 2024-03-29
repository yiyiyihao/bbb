<?php
use think\Facade;

// 应用公共文件
function get_tpl_type($type = '')
{
    $types = [
        'wechat_notice' => '微信模板通知',
    ];
    if ($type === FALSE) {
        return $types;
    }
    if (isset($types[$type])) {
        return $types[$type];
    }else{
        return '';
    }
}
function get_user_orderfrom($user = [])
{
    if ($user) {
        if (isset($user['store_type'])) {
            switch ($user['store_type']) {
                case STORE_SERVICE_NEW:
                    $orderFrom = 1;//服务商订单
                    break;
                case STORE_DEALER:
                    $orderFrom = 2;//零售商订单
                    break;
                case STORE_FACTORY:
                    $orderFrom = 3;//电商客服
                    break;
                default:
                    $orderFrom = 1;
                    break;
            }
        }else{
            $orderFrom = 4;//自有电商
        }
    }else{
        $orderFrom = 0;
    }
    return $orderFrom;
}

function get_order_from($from = FALSE)
{
    $fromTxts = [
        1  => '服务商订单',
        2  => '零售商订单',
        3  => '电商客服订单',
        4  => '自有电商订单',
    ];
    if ($from === FALSE) {
        return $fromTxts;
    }
    if (isset($fromTxts[$from])) {
        return $fromTxts[$from];
    }else{
        return '';
    }
}

function get_order_from_type($from = FALSE)
{
    $fromTxts = [
        1  => '渠道订单',
        2  => '渠道订单',
        3  => '电商订单',
        4  => '电商订单',
    ];
    if ($from === FALSE) {
        return $fromTxts;
    }
    if (isset($fromTxts[$from])) {
        return $fromTxts[$from];
    }else{
        return '';
    }
}




function get_order_source($source = FALSE)
{
    $fromTxts = [
        'fenxiao'         => '分销活动',
        'every_nine_free' => '逢九免单',
        'mall'            => '自有商城',
        'tmall'           => '天猫商城',
        'jd'              => '京东商城',
        'suning'          => '苏宁易购',
        'pinduoduo'       => '拼多多',
    ];
    if ($source === FALSE) {
        return $fromTxts;
    }
    if (isset($fromTxts[$source])) {
        return $fromTxts[$source];
    }else{
        return '';
    }
}

/**
 * 获取活动状态信息
 * @param array $info
 * @return array
 */
function get_promotion_status($info = [])
{
    if(!$info){
        return [
            0 => '已禁用',
            -1 => '未开始',
            -2 => '已结束',
            1 => '进行中',
        ];
    }
    if ($info['status'] != 1){
        return [
            'status' => 0,
            'text' => '已禁用',
        ];
    }else{
        if ($info['start_time'] > time()) {
            return [
                'status' => -1,
                'text' => '未开始',
                'start_time' => $info['start_time'],
                'end_time' => $info['end_time'],
            ];
        }elseif ($info['end_time'] <= time()){
            return [
                'status' => -2,
                'text' => '已结束',
                'start_time' => $info['start_time'],
                'end_time' => $info['end_time'],
            ];
        }else{
            return [
                'status' => 1,
                'text' => '进行中',
                'start_time' => $info['start_time'],
                'end_time' => $info['end_time'],
            ];
        }
    }
}
function time_to_date($time = 0, $format = 'Y-m-d H:i:s')
{
    if ($time<=0) {
        return '';
    }
    $time = $time ? $time : time();
    return date($format, $time);
}
/**
 * 审核状态
 */
function get_check_status($status = FALSE){
    $statusList = [
        0  => '待审核',
        1  => '审核通过',
        2  => '已拒绝',
    ];
    if ($status === FALSE) {
        return $statusList;
    }
    if (isset($statusList[$status])) {
        return $statusList[$status];
    }else{
        return '';
    }
}

function get_order_type($type = FALSE){
    $typeList = [
        1   =>  '批发订单',
        2   =>  '零售订单',
    ];
    if ($type === FALSE) {
        return $typeList;
    }
    if (isset($typeList[$type])) {
        return $typeList[$type];
    }else{
        return '';
    }
}
/**
 * 操作类型
 */
function get_action_type($status = FALSE){
    $statusList = [
        'add'  => '新增',
        'edit' => '编辑',
        'del'  => '删除',
    ];
    if ($status === FALSE) {
        return $statusList;
    }
    if (isset($statusList[$status])) {
        return $statusList[$status];
    }else{
        return '';
    }
}
/**
 * 获取订单安装状态
 */
function get_order_apply_status($status = FALSE){
    $list = [
        0   => '未申请',
        1   => '部分申请',
        2   => '已申请',
    ];
    if ($status === FALSE) {
        return $list;
    }
    if (isset($list[$status])) {
        return $list[$status];
    }else{
        return '';
    }
}
/**
 * 发布状态
 */
function get_publish_status($status = FALSE){
    $list = [
        0   => '未发布',
        1   => '已发布',
    ];
    if ($status === FALSE) {
        return $list;
    }
    if (isset($list[$status])) {
        return $list[$status];
    }else{
        return '';
    }
}
/**
 * 显示是/否
 */
function get_status($status = FALSE){
    $list = [
        0   => '否',
        1   => '是',
    ];
    if ($status === FALSE) {
        return $list;
    }
    if ($status > 1) {
        $status = 1;
    }
    if (isset($list[$status])) {
        return $list[$status];
    }else{
        return '';
    }
}
/**
 * 商户类型
 */
function get_store_type($type = FALSE){
    $types = [
        STORE_FACTORY   => '厂商',
//         STORE_CHANNEL   => '渠道商',
        STORE_DEALER    => '零售商',
//         STORE_SERVICE   => '服务商',
        STORE_ECHODATA=>'电商',
        STORE_SERVICE_NEW=>'服务商',
    ];
    if ($type === FALSE) {
        return $types;
    }
    if (isset($types[$type])) {
        return $types[$type];
    }else if($type === 0){
        return '全部商户';
    }else{
        return '';
    }
}
/**
 * 提现状态
 */
function get_withdraw_status($status = FALSE){
    $statusList = [
        -1 => '已拒绝',
//         -2 => '提现失败',
        0  => '申请中',
//         1  => '提现中',
        2  => '提现成功',
    ];
    if ($status === FALSE) {
        return $statusList;
    }
    if (isset($statusList[$status])) {
        return $statusList[$status];
    }else{
        return '';
    }
}
/**
 * 佣金状态
 */
function get_commission_status($status = FALSE){
    $statusList = [
        0 => '待结算',
        1 => '已结算',
        2 => '已退还',
    ];
    if ($status === FALSE) {
        return $statusList;
    }
    if (isset($statusList[$status])) {
        return $statusList[$status];
    }else{
        return '';
    }
}
/**
 * 产品类别名称
 */
function get_goods_cate($cate = FALSE){
    $cates = [
        1 => '标准产品',
        2 => '产品配件',
    ];
    if ($cate === FALSE) {
        return $cates;
    }
    if (isset($cates[$cate])) {
        return $cates[$cate];
    }else{
        return '';
    }
}
/**
 * 产品类型名称
 */
function goodstype($type = FALSE){
    $types = [
        1 => '普通产品',
        2 => '样品',
    ];
    if ($type === FALSE) {
        return $types;
    }
    if (isset($types[$type])) {
        return $types[$type];
    }else{
        return '';
    }
}

/**
 * 角色分组名称
 */
function get_group_type($type = FALSE){
    $types = [
        1 => '平台角色',
        2 => '商户角色',
    ];
    if ($type === FALSE) {
        return $types;
    }
    if (isset($types[$type])) {
        return $types[$type];
    }else{
        return '';
    }
}

function get_group_name($group_id){
    $name='';
    switch ($group_id) {
        case GROUP_FACTORY:
            $name='厂商';
            break;
        case GROUP_CHANNEL:
            $name='渠道商';
            break;
        case GROUP_DEALER:
            $name = '零售商';
            break;
        case GROUP_SERVICE:
            $name = '服务商';
            break;
        case GROUP_SERVICE_NEW:
            $name = '服务商';
            break;
        case GROUP_E_COMMERCE_KEFU:
            $name = '电商客服';
            break;
        case GROUP_E_CHANGSHANG_KEFU:
            $name = '厂商客服';
            break;
        default:
            $name = '用户';
            break;
    }
    return $name;
}

function getTime($time=0){
    $time = $time ? $time : time();
    $todayStart=strtotime(date('Y-m-d'));
    if ($time >= $todayStart) {
        return '今天'.date('H:i',$time);
    }
    if ($time >= $todayStart-86400) {
        return '昨天'.date('H:i',$time);
    }
    return date('Y-m-d',$time);

}

/**
 * 开启/关闭状态文字格式化
 */
function openorclose($status = 0){
    return $status == 1 ? '<span class="tag bg-green">开启</span>' : '<span class="tag bg-gray">关闭</span>';
}

/**
 * 启用/禁用状态文字格式化
 */
function yesorno($status = 0){
    return $status == 1 ? '<span class="tag bg-green">启用</span>' : '<span class="tag bg-gray">禁用</span>';
}
/**
 * 是/否状态文字格式化
 */
function yorn($status = 0){
    return $status == 1 ? '<span class="tag bg-green">是</span>' : '<span class="tag bg-gray">否</span>';
}

/**
 * 快递信息
 */
function get_delivery($identif = FALSE)
{
    $deliverys = [
        'shunfeng' => [
            'identif' => 'shunfeng',
            'name' => '顺丰快递',
        ],
        'ems' => [
            'identif' => 'ems',
            'name' => 'EMS邮政',
        ],
        'debang' => [
            'identif' => 'debang',
            'name' => '德邦快递',
        ],
        'yuantong' => [
            'identif' => 'yuantong',
            'name' => '圆通快递',
        ],
        'zhongtong' => [
            'identif' => 'zhongtong',
            'name' => '中通快递',
        ],
        'yunda' => [
            'identif' => 'yunda',
            'name' => '韵达快递',
        ],
        'tiantian' => [
            'identif' => 'tiantian',
            'name' => '天天快递',
        ],
        'shentong' => [
            'identif' => 'shentong',
            'name' => '申通快递',
        ],
        'huitongkuaidi' => [
            'identif' => 'huitongkuaidi',
            'name' => '百世汇通',
        ],
    ];
    if ($identif === FALSE) {
        return $deliverys;
    }
    if (isset($deliverys[$identif])) {
        return $deliverys[$identif];
    }else{
        return '';
    }
}

/**
 * 售后订单类型
 */
function get_service_type($type = FALSE){
    $types = [
        1 => '退货退款',
    ];
    if ($type === FALSE) {
        return $types;
    }
    if (isset($types[$type])) {
        return $types[$type];
    }else{
        return '';
    }
}
/**
 * 售后订单状态
 */
function get_service_status($status = FALSE)
{
    //售后状态(-1拒绝申请 0申请中 1等待买家退货 2等待买家退款 3退款成功 4已取消)
    $list = [
        -1 => '已拒绝',
        0 => '申请中',
        1 => '待退货',
        2 => '待退款',
        3 => '已完成',
        -2 => '已取消',
    ];
    if ($status === FALSE) {
        return $list;
    }
    if (isset($list[$status])) {
        return $list[$status];
    }else{
        return '';
    }
}


function get_order_status($order=[]){
    $arr=[
        'status_text'=>'',
        'status'=>'',
    ];
    if (!isset($order['pay_type'])) {
        $order['pay_type'] = 1;
    }
    if ($order['order_status']==2) {
        $arr['status_text'] = '已取消';
        $arr['status'] = 5;
        return $arr;
    }
    if ($order['order_status']==3) {
        $arr['status_text'] = '已关闭';
        $arr['status'] = 6;
        return $arr;
    }
    if ($order['order_status']==4) {
        $arr['status_text'] = '已删除';
        $arr['status'] = 7;
        return $arr;
    }
    //历史数据
    if ($order['order_type'] == 1 && in_array($order['user_store_type'],[STORE_DEALER,STORE_SERVICE,STORE_SERVICE_NEW]) ) {
        $order['order_type']=2;
    }

    /*******未付款*******************************************************/
    if ($order['pay_status'] == 0) {
        //货到付款以后再处理【pay_type=3】
        $arr['status_text'] = $order['pay_type'] == 1?  '待付款':'待确认收款';
        $arr['status'] = 1;
        return $arr;
    }
    /*******已付款***********************************************************/
    //批发订单，不用发货-新需求没有这个要求

    //正常完成
    if ($order['delivery_status']==2 && $order['finish_status']==2) {
        $arr['status_text'] = '已完成';
        $arr['status'] = 4;
        return $arr;
    }

    //正常完成
    //if ($order['pay_status']==1) {
    //    $arr['status_text'] = '已完成';
    //    $arr['status'] = 4;
    //    return $arr;
    //}

    //电商订单不需要发货
    if ($order['pay_status']==1 && $order['order_status']==1 && $order['user_store_type']==STORE_FACTORY) {
        $arr['status_text'] = '已完成';
        $arr['status'] = 4;
        return $arr;
    }
    //零售店内提货，不发货
    if ($order['order_type'] == 2 && $order['delivery_type'] == 1) {
        $arr['status_text'] = '已完成';
        $arr['status'] = 4;
        return $arr;
    }
    if ($order['delivery_status'] == 0) {
        $arr['status_text'] = '待发货';
        $arr['status'] = 2;
        return $arr;
    }
    if ($order['delivery_status'] == 1 && $order['finish_status'] == 0) {
        $arr['status_text'] = '部分发货';
        $arr['status'] = 30;
        return $arr;
    }
    if ($order['delivery_status'] == 2 && $order['finish_status'] == 0) {
        $arr['status_text'] = '待收货';
        $arr['status'] = 3;
        return $arr;
    }
    if ($order['delivery_status'] != 0 && $order['finish_status'] == 1) {
        $arr['status_text'] = '部分完成';
        $arr['status'] = 40;
        return $arr;
    }
    if ($order['delivery_status'] == 2 && $order['finish_status'] == 2) {
        $arr['status_text'] = '已完成';
        $arr['status'] = 4;
        return $arr;
    }
    return $arr;
}


/**
 * 获取订单状态
 * @param  $order    : 订单信息
 * @return [string]
 */
//function get_order_status2($order = array(),$flag=false) {
//    $arr = array();
//    switch ($order['order_status']) {
//        case 2: // 已取消
//            $arr['now'] = 'cancel';
//            $arr['wait'] = 'cancel';
//            $arr['status_text'] = ch_order_status($arr['wait']);
//            $arr['status'] = 5;
//            break;
//        case 3: // 已关闭
//            $arr['now'] = 'recycle';
//            $arr['wait'] = 'recycle';
//            $arr['status_text'] = ch_order_status($arr['wait']);
//            $arr['status'] = 6;
//            break;
//        case 4: // 前台用户已删除
//            $arr['now'] = 'delete';
//            $arr['status'] = 7;
//            break;
//        default:    // 正常状态
//            if (!isset($order['pay_type'])) {
//                $order['pay_type'] = 1;
//            }
//            if ($order['order_type']==1 && $flag==FALSE) {//批发
//                if (($order['pay_type'] == 1 || $order['pay_type'] == 2) && $order['pay_status'] == 0) {
//                   $arr['now'] = 'create'; // 创建订单
//                   $arr['wait'] = ($order['pay_type'] == 1) ? 'load_pay' : 'load_pay_confirm';
//                   $arr['status'] = 1;
//                }elseif (($order['pay_type'] == 1 || $order['pay_type'] == 2) && $order['pay_status'] == 1) {
//                   $arr['now'] = 'pay';    // 已支付
//                   $arr['wait'] = 'all_finish';
//                   $arr['status'] = 2;
//               }
//            }else{//零售
//               if ($order['pay_status'] == 0) {
//                   $arr['now'] = 'create'; // 创建订单
//                   $arr['wait'] = ($order['pay_type'] == 1) ? 'load_pay' : 'load_delivery';
//                   $arr['status'] = 1;
//               }elseif ($order['pay_status'] == 1 && $order['delivery_status'] == 0) {
//                   $arr['now'] = 'pay';    // 已支付
//                   $arr['wait'] = 'load_delivery';
//                   $arr['status'] = 2;
//               }elseif ($order['delivery_status'] == 1 && $order['finish_status'] == 0) {
//                   $arr['now'] = 'part_delivery';   // 部分发货
//                   $arr['wait'] = 'part_delivery';
//                   $arr['status'] = 30;
//               }elseif ($order['delivery_status'] == 2 && $order['finish_status'] == 0) {
//                   $arr['now'] = 'all_delivery';   // 已发货
//                   $arr['wait'] = 'load_finish';
//                   $arr['status'] = 3;
//               }elseif ($order['delivery_status'] != 0 && $order['finish_status'] == 1) {
//                   $arr['now'] = 'part_finish';   // 部分完成
//                   $arr['wait'] = 'part_delivery';
//                   $arr['status'] = 40;
//               }elseif ($order['delivery_status'] == 2 && $order['finish_status'] == 2) {
//                   $arr['now'] = 'all_finish';   // 已完成
//                   $arr['wait'] = 'all_finish';
//                   $arr['status'] = 4;
//               }
//            }
//            $arr['status_text'] = ch_order_status($arr['wait']);
//            break;
//    }
//    unset($arr['now'], $arr['wait']);
//    return $arr;
//}

/**
 * 获取状态中文信息
 * @param  string $ident 标识
 * @return [string]
 */
function ch_order_status($ident) {
    $arr = array(
        'cancel'        => '已取消',
        'recycle'       => '已关闭',
        'delete'        => '已删除',
        'create'        => '创建订单',
        'load_pay'      => '待付款',
        'load_pay_confirm'=>'待确认收款',
        'load_delivery' => '待发货',
        'pay'           => '已付款',
        'part_delivery' => '部分发货',
        'all_delivery'  => '已发货',
        'load_finish'   => '待收货',
        'part_finish'   => '部分完成',
        'all_finish'    => '已完成',
        'receive'       => '已收货',

        // 前台时间轴
        'time_cancel'   => '取消订单',
        'time_recycle'  => '回收订单',
        'time_create'   => '提交订单',
        'time_pay'      => '确认付款',
        'time_delivery' => '产品发货',
        'time_finish'   => '确认收货',
    );
    return isset($arr[$ident]) ? $arr[$ident] : '';
}
function get_work_order_type($type = FALSE)
{
    $list = [
        1 => '安装工单',
        2 => '维修工单',
    ];
    if ($type === FALSE) {
        return $list;
    }
    if (isset($list[$type])) {
        return $list[$type];
    }else{
        return '';
    }
}
function get_work_order_status($status = FALSE)
{
    $list = [
        0 => '待分派',
        1 => '待接单',
        2 => '待上门',
        3 => '服务中',
        4 => '已完成',
        -1 => '已取消',
    ];
    if ($status === FALSE) {
        return $list;
    }
    if (isset($list[$status])) {
        return $list[$status];
    }else{
        return '';
    }
}
function get_work_order_installer_status($status = FALSE)
{
    $list = [
        0 => '待分派',
        1 => '待接单',
        2 => '待上门',
        3 => '服务中',
        4 => '已完成',
        -1 => '已取消',
        -2 => '已拒绝',
        -3 => '已转移',
    ];
    if ($status === FALSE) {
        return $list;
    }
    if (isset($list[$status])) {
        return $list[$status];
    }else{
        return '';
    }
}

function get_installer_status($status = FALSE)
{
    $list = [
        -4 => '服务商拒绝申请',
        -3 => '等待服务商审核',
        -2 => '厂商拒绝申请',
        -1 => '等待厂商审核',
        0  => '待审核',
        1  => '正常',
    ];
    if ($status === FALSE) {
        return $list;
    }
    if (isset($list[$status])) {
        return $list[$status];
    }else{
        return '';
    }
}

function get_admin_type($type = FALSE){
    $storeTypes = [
        1 => '平台',
        2 => '厂商',
        3 => '渠道商',
        4 => '零售商',
        5 => '服务商',
        6 => '服务商',
    ];
    if ($type === FALSE) {
        return $storeTypes;
    }
    if ($type && isset($storeTypes[$type])) {
        return $storeTypes[$type];
    }else{
        return '-';
    }
}

function get_store_config($storeId = 0, $merge = FALSE, $defaultKey = FALSE)
{
    $factory = db('store')->where(['store_id' => $storeId, 'is_del' => 0])->find();
    $config = $factory['config_json'] ? json_decode($factory['config_json'], 1) : [];
    $configKey = $defaultKey ? $defaultKey : 'default';

    if ($merge) {
        //获取系统默认配置
        $systemKey = 'system_'.$configKey;
        $default = get_system_config($systemKey);
        $sysConfig = $default['config_value'];
        if ($sysConfig) {
            foreach ($sysConfig as $key => $value) {
                if (!isset($config[$configKey][$key])) {
                    $config[$configKey][$key] = $value;
                }
            }
        }
    }
    if ($defaultKey && $configKey == 'default') {
        if (!isset($config[$configKey]['servicer_return_ratio'])) {
            $config[$configKey]['servicer_return_ratio'] = 100;
        }
        if (!isset($config[$configKey]['channel_operate_check'])) {
            $config[$configKey]['channel_operate_check'] = 1;
        }
    }
    if ($defaultKey === FALSE) {
        return $config;
    }
    return isset($config[$configKey]) ? $config[$configKey] : [];
}
function get_system_config($key = '')
{
    //获取系统默认配置
    $where = [
        'is_del' => 0,
        'status' => 1,
    ];
    if ($key) {
        $where['config_key'] = trim($key);
    }
    $info = db('config')->where($where)->find();
    $info['config_value'] = $info && $info['config_value'] ? json_decode($info['config_value'], 1) : [];
    return $info;
}

/**
 * 删除目录下的所有文件和目录
 * @param string $dir
 */
function del_file_by_dir($dir) {
    //1、将目录内容全部获取出
    $list = scandir($dir);
    //2、遍历目录
    foreach($list as $f){
        //3、将 .  .. 排除在外
        if($f != '.' && $f != '..'){
            //4、如果内容文件 unlink
            if(is_file($dir."/".$f)){
                unlink($dir."/".$f);
            }else{
                //5、目录   递归
                del_file_by_dir($dir."/".$f);
            }
        }
    }
    //6、循环外删除目录!!
    rmdir($dir);
}

function array_implode($array = [])
{
    $array = $array ? array_filter($array) : [];
    $array = $array ? array_unique($array) : [];
    $implode = $array ? implode(',', $array) : '';
    return $implode;
}

/**
 *
 * 拼接签名字符串
 * @param array $urlObj
 *
 * @return 返回已经拼接好的字符串
 */
function to_url_params($urlObj)
{
    $buff = "";
    foreach ($urlObj as $k => $v)
    {
        if($k != "sign"){
            $buff .= $k . "=" . $v . "&";
        }
    }
    $buff = trim($buff, "&");
    return $buff;
}
/*
 *xml to array
 */
function xml_to_array($xml)
{
    $array_data = json_decode(json_encode(simplexml_load_string($xml, 'SimpleXMLElement', LIBXML_NOCDATA)), true);
    return $array_data;
}
/*
 *array to xml
 */
function array_to_xml($arr)
{
    $xml = "<xml>";
    foreach ($arr as $key=>$val)
    {
        $xml.="<".$key.">".$val."</".$key.">";
    }
    $xml.="</xml>";
    return $xml;
}

/**
 *   将数组转换为xml
 *    @param array $data    要转换的数组
 *   @param bool $root     是否要根节点
 *   @return string         xml字符串
 *    @author Dragondean
 *    @url    http://www.cnblogs.com/dragondean
 */
function arr2xml($data, $root = true){
    $str='';
    if($root)$str .= '<xml>';
    foreach($data as $key => $val){
        //去掉key中的数字下标
        is_numeric($key) && $key = "item id=\"$key\"";
        if(is_array($val)){
            $child = arr2xml($val, false);
            $str .= "<$key>$child</$key>";
        }else{
            $str.= "<$key><![CDATA[$val]]></$key>";
        }
    }
    if($root)$str .= "</xml>";
    return $str;
}


/**
 *
 * 产生随机字符串，不长于32位
 * @param int $length
 * @return 产生的随机字符串
 */
function get_nonce_str($length = 32, $type = 1)
{
    if ($type == 1) {
        $chars = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    }else{
        $chars = "0123456789";
    }

    $str ="";
    for ( $i = 0; $i < $length; $i++ )  {
        $str .= substr($chars, mt_rand(0, strlen($chars)-1), 1);
    }
    return $str;
}
function object_array($array) {
    if(is_object($array)) {
        $array = (array)$array;
    } if(is_array($array)) {
        foreach($array as $key=>$value) {
            $array[$key] = object_array($value);
        }
    }
    return $array;
}
/**
 * 二维数组排序
 * @param array $array 排序的数组
 * @param string $key 排序主键
 * @param string $type 排序类型 asc|desc
 * @param bool $reset 是否返回原始主键
 * @return array
 */
function array_order($array, $key, $type = 'asc', $reset = false)
{
    if (empty($array) || !is_array($array)) {
        return $array;
    }
    foreach ($array as $k => $v) {
        $keysvalue[$k] = $v[$key];
    }
    if ($type == 'asc') {
        asort($keysvalue);
    } else {
        arsort($keysvalue);
    }
    $i = 0;
    foreach ($keysvalue as $k => $v) {
        $i++;
        if ($reset) {
            $new_array[$k] = $array[$k];
        } else {
            $new_array[$i] = $array[$k];
        }
    }
    return $new_array;
}

function array_trim($array)
{
    foreach ($array as $key => &$value) {
        $value = trim($value);
    }
    return $array;
}

/**
 * 系统断点调试方法
 */
function pre($array, $undie = 0)
{
    echo '<pre>';
    print_r($array);
    echo '</pre>';
    if($undie){
        return ;
    }
    exit();
}

/**
 * 打印数据
 * @param $var
 * @param bool $flag
 */
function p($var,$flag=false){
    $debugInfo = debug_backtrace();
    $message= $debugInfo[0]['file']. ':'.$debugInfo[0]['line'];
    $len=(mb_strlen($message)-6)/2;
    $len=$len>0 && $len<=100 ? ceil($len):10;
    echo '<p>[file path]: '.$message.'</p>';
    echo '<p>[var type]:  '.gettype($var).'</p>';
    echo '<pre>';
    var_export($var);
    echo '</pre>';
    echo '<p>'.str_pad('',$len,'=').'华丽的分割线'.str_pad('',$len,'=').'</p>';
    if(!$flag){
        exit();
    }
}

function pr($var,$flag=false){
    $debugInfo = debug_backtrace();
    $message= $debugInfo[0]['file']. ':'.$debugInfo[0]['line'];
    $len=(mb_strlen($message)-6)/2;
    $len=$len>0 && $len<=100 ? ceil($len):10;
    echo '<p>[file path]: '.$message.'</p>';
    echo '<p>[var type]:  '.gettype($var).'</p>';
    echo '<pre>';
    print_r($var);
    echo '</pre>';
    echo '<p>'.str_pad('',$len,'=').'华丽的分割线'.str_pad('',$len,'=').'</p>';
    if(!$flag){
        exit();
    }
}


//实时写入日志
function log_msg($message='',$type='debug'){
    $msg=var_export($message,true);
    \think\facade\Log::write($msg,$type);
}
/**
 * 格式化时间戳
 * @param int $timediff 时间戳
 * @param number $return_type 返回数据类型 1：带单位字符串 2：返回分钟数 3： 数组
 */
function timediff($timediff, $return_type = 1)
{
    //计算天数
    $days = trim(intval($timediff/86400));
    //计算小时数
    $remain = $timediff%86400;
    $hours = trim(intval($remain/3600));
    //计算分钟数
    $remain = $remain%3600;
    $mins = trim(intval($remain/60));
    //计算秒数
    $secs = trim($remain%60);
    $return = '';
    if ($return_type == 1) {
        if($days){
            $return = $days.'天';
        }
        if($hours){
            $return .= $return ? ''.$hours.'时' : $hours.'时';
        }
        if($mins){
            $return .= $return ? ''.$mins.'分' : $mins.'分';
        }
        if($secs){
            $return .= $return ? ''.$secs.'秒' : $secs.'秒';
        }
    }elseif($return_type == 2){//返回分钟数
        $return = round($timediff%86400/60, 2);
    }else{
        $return = ["day" => $days,"hour" => $hours,"min" => $mins,"sec" => $secs];
    }
    return $return;
}
/**
 * curl函数
 * @url :请求的url
 * @post_data : 请求数组
 **/
function curl_post_https($url, $post_data, $header = []){
    if (empty($url)){
        return false;
    }
    //初始化
    $curl = curl_init();
    //设置抓取的url
    curl_setopt($curl, CURLOPT_URL, $url);
    curl_setopt($curl, CURLOPT_TIMEOUT, 0);
    //设置头文件的信息作为数据流输出
    curl_setopt($curl, CURLOPT_HEADER, 0);
    //设置获取的信息以文件流的形式返回，而不是直接输出。
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    if(!empty($header)){
        curl_setopt($curl, CURLOPT_HTTPHEADER, $header);
    }
    //设置post方式提交
    curl_setopt($curl, CURLOPT_POST, 1);
    curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "POST");
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0); // 信任任何证书
    curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 0); // 检查证书中是否设置域名（为0也可以，就是连域名存在与否都不验证了）
    //设置post数据
    curl_setopt($curl, CURLOPT_POSTFIELDS, $post_data);
    //执行命令
    $data = curl_exec($curl);
    $error = '';
    if($data === false){
        $error = curl_error($curl);
        echo 'Curl error: ' . $error;
    }
    //关闭URL请求
    curl_close($curl);
    $json = json_decode($data,true);
    if (empty($json)){
        return $data = $data ? $data : $url.':'.$error;
    }
    //显示获得的数据
    return $json;
}
/**
 * curl函数
 * @url :请求的url
 * @post_data : 请求数组
 **/
function curl_post($url, $post_data){
    if (empty($url)){
        return false;
    }
    $post_data = json_encode($post_data);
    //初始化
    $curl = curl_init();
    //设置抓取的url
    curl_setopt($curl, CURLOPT_URL, $url);
    //设置头文件的信息作为数据流输出
    curl_setopt($curl, CURLOPT_HEADER, 0);
    //设置获取的信息以文件流的形式返回，而不是直接输出。
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    //设置post方式提交
    curl_setopt($curl, CURLOPT_POST, 1);
    //设置post数据
    curl_setopt($curl, CURLOPT_POSTFIELDS, $post_data);
    //执行命令
    $data = curl_exec($curl);
    $error = '';
    if($data === false){
        $error = curl_error($curl);
        echo 'Curl error: ' . $error;
    }
    //关闭URL请求
    curl_close($curl);
    $json = json_decode($data,true);
    if (empty($json)){
        return $data = $data ? $data : $url.':'.$error;
    }
    //显示获得的数据
    return $json;
}


/**
 * 上面两个有异常BUG，功能也不齐全，故独立写一个,同时支持POST/GET，更多功能可随时扩展
 * @author  JINZHOU  2019/05/08
 * @param $url 访问的URL
 * @param string $post    表单数据(不填则为GET)
 * @return bool|string
 */
function curl_request($url,$post='',$param=[]){
    $curl = curl_init();
    curl_setopt($curl, CURLOPT_URL, $url);
    curl_setopt($curl, CURLOPT_USERAGENT, 'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)');
    curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($curl, CURLOPT_AUTOREFERER, 1);
    if (isset($param['CURLOPT_REFERER']) && $param['CURLOPT_REFERER']) {
        curl_setopt($curl, CURLOPT_REFERER,$param['CURLOPT_REFERER']);
    }else{
        curl_setopt($curl, CURLOPT_REFERER, 'http://shop.smarlife.cn');
    }
    if($post) {
        curl_setopt($curl, CURLOPT_POST, 1);
        curl_setopt($curl, CURLOPT_POSTFIELDS, http_build_query($post));
    }
    //提交的$cookies
    if (isset($param['CURLOPT_COOKIE']) && $param['CURLOPT_COOKIE']) {
        curl_setopt($curl, CURLOPT_COOKIE,$param['CURLOPT_COOKIE']);
    }
    //是否返回$cookies
    $returnCookie=isset($param['CURLOPT_HEADER'])? $param['CURLOPT_HEADER']:0;

    curl_setopt($curl, CURLOPT_HEADER, $returnCookie);
    curl_setopt($curl, CURLOPT_TIMEOUT, 10);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);

    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
    $data = curl_exec($curl);
    if (curl_errno($curl)) {
        return curl_error($curl);
    }
    curl_close($curl);
    if($returnCookie){
        list($header, $body) = explode("\r\n\r\n", $data, 2);
        preg_match_all("/Set\-Cookie:([^;]*);/", $header, $matches);
        $info['cookie']  = substr($matches[1][0], 1);
        $info['content'] = $body;
        return $info;
    }else{
        return $data;
    }
}


function getTree($data, $pid=0,$sub_name='sub',$parent_name='parent_id',$id_name='id'){
    $tree = [];
    foreach($data as $k => $v){
        if($v[$parent_name] == $pid){
            $v[$sub_name] = getTree($data, $v[$id_name],$sub_name,$parent_name,$id_name);
            $tree[] = $v;
            unset($data[$k]);//减少内存消耗
        }
    }
    return $tree;
}

function returnMsg($errCode = 0, $errMsg = 'ok', $data = [])
{
    $arr = compact('errCode', 'errMsg', 'data');
    if (empty($arr['data'])) {
        unset($arr['data']);
    }
    $result = json_encode($arr);
    header('Content-Type:application/json');
    echo $result;
    die();
}

function sub_str($str, $length = 0, $append = '...') {
    $str = trim($str);
    $strlength = strlen($str);

    if ($length == 0 || $length >= $strlength) {
        return $str;
    } elseif ($length < 0) {
        $length = $strlength + $length;
        if ($length < 0) {
            $length = $strlength;
        }
    }

    if ( function_exists('mb_substr') ) {
        $newstr = mb_substr($str, 0, $length, 'utf-8');
    } elseif ( function_exists('iconv_substr') ) {
        $newstr = iconv_substr($str, 0, $length, 'utf-8');
    } else {
        $newstr = substr($str, 0, $length);
    }

    if ($append && $str != $newstr) {
        $newstr .= $append;
    }
    return $newstr;
}

/**
 * 字符串加密
 * @param $str
 * @param int $prefix 前面保留几位
 * @param int $suffix 后面保留几位
 * @return string
 */
function str_encode($str,$prefix=0,$suffix=0){
    if ($prefix<=0  && $suffix<=0) {
        return $str;
    }
    $_pre='';
    $_suf='';
    $len=mb_strlen($str);
    if ($prefix>=$len) {
        return $str;
    }
    if ($prefix>0){
        $_pre=mb_substr($str,0,$prefix);
    }
    if ($suffix>=$len) {
        return $str;
    }
    if ($suffix>0){
        $_suf=mb_substr($str,-$suffix);
    }
    $_len=$len-$prefix-$suffix;
    $_len=$_len>0?$_len:0;
    $_mid=str_pad('',$_len,'*');
    return $_pre.$_mid.$_suf;
}

/**
 * 根据分组名称获取分组权限
 * @param number $groupId
 */
function getGroupPurview($groupId = 0)
{
    $groupPurview = cache('groupPurview'.$groupId);
    if(!$groupPurview){
        //获取账户角色权限
        $groupPurview = db('user_group')->where(['group_id' => $groupId, 'is_del' => 0, 'status' => 1])->value('menu_json');
    }
    return $groupPurview;
}

//权限检测
function check_auth($controller='',$action='index'){
    $flag=false;
    $whiteList=[
        'upload','login','logout'
    ];
    $request=request();
    if ($request->isAjax() || in_array($action,$whiteList)) {
        $flag=true;
        return $flag;
    }
    $domain = $request->panDomain();
    if (!$domain) {
        $domain = $request->subDomain();
    }
    $adminUser = session($domain.'_user');
    //超级管理员
    if ($adminUser['user_id']==1){
        return true;
    }
    $groupPurview = getGroupPurview($adminUser['group_id']);
    $groupPurview   = $groupPurview ? json_decode($groupPurview,true) : [];
    foreach ($groupPurview as $item) {
        if ($item['module']==$request->module() && $item['controller']==$controller ) {
            $actName=empty($item['action'])? 'index':$item['action'];
            if ($actName=='*' ||$actName==$action ) {
                $flag=true;
                break;
            }
        }
    }
    return $flag;
}

function check_mobile($mobile){
    $pattern = '/^(13[0-9]|14[0|9]|15[0-9]|167[0-9]|17[0-9]|18[0-9]|19[0-9])\d{8}$/';
    $bool=false;
    if (preg_match($pattern,$mobile)) {
        $bool=true;
    }
    return $bool;
}

function dataFormat($code = 0, $msg = '', $data = [])
{
    if (func_num_args() == 1) {
        $args = func_get_arg(0);
        $code = (string)array_shift($args);
        $msg = (string)array_shift($args);
        $data = array_shift($args);
    }
    $result = [
        'code' => (string)$code,
        'msg'  => (string)$msg,
    ];
    if (empty($data)) {
        return $result;
    }
    if (is_array($data) || is_object($data)) {
        $data = recursion(json_decode(json_encode($data), true));
    } else {
        $data=strval($data);
    }
    //数据中如果有一层data,则不再添加一层data
    if (is_array($data) && count($data) == 1 && key_exists('data', $data)) {
        return array_merge($result, $data);
    } else {
        $result['data'] = $data;
        return $result;
    }
}

function recursion($arr = [])
{
    if (empty($arr)) {
        return [];
    }
    $arr = json_decode(json_encode($arr), true);
    foreach ($arr as $k => $v) {
        if (is_array($v)) {
            $arr[$k] = recursion($v);
        } else {
            $arr[$k] = strval($v);
        }
    }
    return $arr;
}

/**
 * 驼峰字符转下划线
 * @param string $str
 * @return string
 */
function camp2snake($str='')
{
    $pattern='/(?<=[a-z])([A-Z])/';
    $result=strtolower(preg_replace($pattern, '_$1', $str));
    return $result;
}

function get_user_type($userType = null)
{
    $arr = [
        0 => '意向用户',
        1 => '成交用户',
    ];
    if (isset($arr[$userType])) {
        return $arr[$userType];
    }
    return $arr;
}

function filter_request(){
    $param=array_filter(input('param.'), function ($item) {
        return $item!=='' && $item!==null;
    });
    return $param;
}