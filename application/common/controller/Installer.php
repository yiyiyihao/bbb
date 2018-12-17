<?php
namespace app\common\controller;

//售后工程师管理
class Installer extends FormBase
{
    var $adminType;
    public function __construct()
    {
        $this->infotempfile = 'checkInfo';
        $this->modelName = 'user_installer';
        $this->model = model($this->modelName);
        parent::__construct();
        
        if (!in_array($this->adminUser['admin_type'], [ADMIN_SYSTEM, ADMIN_FACTORY])) {
            if ($this->adminUser['admin_type'] != ADMIN_SERVICE) {
                $this->error('NO ACCESS');
            }
        }
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY){
            $this->_getFactorys();
        }
        $this->uploadUrl = url('Upload/upload', ['prex' => 'store_logo_', 'thumb_type' => 'logo_thumb']);
    }
    
    /**
     * 售后工程师详情
     */
    public function detail(){
        $info = $this->_assignInfo();
        //取得工程师所属服务商
        $storeInfo = model('store')->where(['store_id'=>$info['store_id']])->find();
        $info['store_name'] =   $storeInfo['name'];
        //取得评分项分数
        $scoreModel = db('user_installer_score');
        $where = [
            'S.installer_id'    => $info['installer_id'],
        ];
        $scoreList  = $scoreModel->alias("S")->field("C.name,S.value")->join("config C","S.config_id = C.config_id")->where($where)->select();
        /* $len = count($scoreList);
        $totalScore = 0;
        foreach ($scoreList as $k=>$v){
            $totalScore += $v['value'];
        }
        $scoreList[] = [
            'name'  =>  '综合评分',
            'value' =>  round($totalScore/$len,1)
        ]; */
        $this->assign("scorelist",$scoreList);
        $this->assign("info",$info);
        //取得工程师服务工单列表
        $workModel = model("work_order");
        $alias = 'WO';
        $join[] = ['user U', 'U.user_id = WO.post_user_id', 'LEFT'];
        $join[] = ['goods G', 'WO.goods_id = G.goods_id', 'LEFT'];
        $join[] = ['goods_sku GS', 'WO.sku_id = GS.sku_id', 'LEFT'];
        $field  = 'U.username,WO.*, G.name as gname, GS.sku_name';
        $where = [
            'WO.is_del'         =>  0,
            'WO.installer_id'   =>  $info['installer_id'],
        ];
        $order = 'WO.add_time DESC';
        $count = $workModel->alias($alias)->join($join)->field($field)->where($where)->count();
        $list  = $workModel->alias($alias)->join($join)->field($field)->where($where)->order($order)->paginate($this->perPage,$count);
        // 获取分页显示
        $page   = $list->render();
        $list   = $list->toArray()['data'];
        $this->assign('list',$list);// 赋值数据集
        $this->assign('page', $page);
        $orderTypes = [
            1 => '安装',
            2 => '维修'
        ];
        $this->assign('orderTypes', $orderTypes);
        return $this->fetch();
    }
    
    public function check()
    {
        $info = $this->_assignInfo();
        if (!$info || $info['is_del']) {
            $this->error('安装工程师不存在或已删除');
        }
        $checkStatus = $info['check_status'];
        if (!in_array($checkStatus, [-1, -3])) {
            $this->error('操作已审核');
        }
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY && $checkStatus != -1) {
            $this->error('无操作权限');
        }
        if ($this->adminUser['admin_type'] == ADMIN_SERVICE && $checkStatus != -3) {
            $this->error('无操作权限');
        }
        $params = $this->request->param();
        if (IS_POST) {
            $remark = isset($params['remark']) ? trim($params['remark']) : '';
            $checkStatus = isset($params['check_status']) ? intval($params['check_status']) : 0;
            if (!$checkStatus && !$remark) {
                $this->error('清填写拒绝理由');
            }
            //状态(0待审核 1审核成功 -1厂商审核中 -2厂商拒绝 -3服务商审核中 -4服务商拒绝)
            if ($checkStatus > 0) {
                $status = $this->adminUser['admin_type'] == ADMIN_FACTORY ? 1: $this->getConfigStatus(0, $this->adminStore['factory_id']);
            }else{
                $status = $this->adminUser['admin_type'] == ADMIN_FACTORY ? -2: -4;
            }
            $data = [
                'update_time' => time(),
                'check_status' => $status,
            ];
            $result = $this->model->where(['installer_id' => $info['installer_id']])->update($data);
            if ($result !== FALSE) {
                $this->success('操作成功', url('index'));
            }else{
                $this->error('操作失败');
            }
        }else{
            $this->assign('info', $info);
            return $this->fetch();
        }
    }
    
    /**
     * 工程师绑定小程序二维码
     */
    public function wxacode()
    {
        $info = $this->_assignInfo();
        if (!$info || $info['is_del']) {
            $this->error('安装工程师不存在或已删除');
        }
        //远程判断图片是否存在
        $qiniuApi = new \app\common\api\QiniuApi();
        $config = $qiniuApi->config;
        $domain = $config ? 'http://'.$config['domain'].'/': '';
        $filename = 'installer_wxacode_'.$info['store_id'].'.png';
        $result = curl_post($domain.$filename, []);
        $page = 'pages/index/index';//二维码扫码打开页面
        $scene = 'type=installer&id='.$info['installer_id'];//最大32个可见字符，只支持数字，大小写英文以及部分特殊字符：!#$&'()*+,/:;=?@-._~，其它字符请自行编码为合法字符（因不支持%，中文无法使用 urlencode 处理，请使用其他编码方式）
        if (isset($result['error'])) {
            $wechatApi = new \app\common\api\WechatApi('wechat_applet');
            $data = $wechatApi->getWXACodeUnlimit($scene, $page);
            if ($wechatApi->error) {
                $this->error($wechatApi->error);
            }else{
                $result = $qiniuApi->uploadFileData($data, $filename);
                if (isset($result['error']) && $result['error'] > 0) {
                    $this->error($result['msg']);
                }
                $result = $this->model->where(['installer_id' => $info['installer_id']])->update(['update_time' => time(), 'wxacode' => $domain.$filename]);
            }
        }
        echo '<img src="'.$domain.$filename.'">';
    }
    function del(){
        $info = $this->_assignInfo();
        //判断工程师是否有对应的工单记录
        $exist = db('work_order')->where(['installer_id' => $info['installer_id']])->find();
        if ($exist) {
            $this->error('工程师存在工单记录,不允许删除');
        }
        parent::del();
    }
    function _assignInfo($pkId = 0)
    {
        $info = parent::_assignInfo();
        if (!in_array($this->adminUser['admin_type'], [ADMIN_FACTORY, ADMIN_SERVICE])) {
            $this->error(lang('NO_OPERATE_PERMISSION'));
        }
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY && $info['factory_id'] != $this->adminUser['store_id']) {
            $this->error(lang('NO_OPERATE_PERMISSION'));
        }
        if ($this->adminUser['admin_type'] == ADMIN_SERVICE && $info['store_id'] != $this->adminUser['store_id']) {
            $this->error(lang('NO_OPERATE_PERMISSION'));
        }
        return $info;
    }
    function _getData()
    {
        $info = $this->_assignInfo();
        $params = parent::_getData();
        $storeId = isset($params['store_id']) ? intval($params['store_id']) : '';
        $realname = isset($params['realname']) ? trim($params['realname']) : '';
        $phone = isset($params['phone']) ? trim($params['phone']) : '';
        $avatar = isset($params['avatar']) ? trim($params['avatar']) : '';
        $fontimg = isset($params['idcard_font_img']) ? trim($params['idcard_font_img']) : '';
        $backimg = isset($params['idcard_back_img']) ? trim($params['idcard_back_img']) : '';
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY && !$storeId){
            $this->error('请选择服务商');
        }
        if (!$realname) {
            $this->error('真实姓名不能为空');
        }
        if (!$phone) {
            $this->error('联系电话不能为空');
        }
//         if (!$avatar) {
//             $this->error('请上传工程师头像');
//         }
//         if (!$fontimg) {
//             $this->error('请上传身份证正面图片');
//         }
//         if (!$backimg) {
//             $this->error('请上传身份证反面图片');
//         }
        if (!$info) {
            if ($this->adminUser['admin_type'] == ADMIN_SERVICE) {
                $params['store_id'] = $this->adminStore['store_id'];
                $params['factory_id'] = $this->adminStore['factory_id'];
            }elseif ($this->adminUser['admin_type'] == ADMIN_FACTORY){
                $params['store_id'] = $storeId;
                $params['factory_id'] = $this->adminStore['store_id'];
            }
        }
        $params['check_status'] = $this->getConfigStatus($params['store_id'], $params['factory_id']);
        return $params;
    }
    private function getConfigStatus($storeId = 0, $factoryId = 0)
    {
        $flag = TRUE; //默认需要厂商审核
        //状态(0待审核 1审核成功 -1厂商审核中 -2厂商拒绝 -3服务商审核中 -4服务商拒绝)
        if ($storeId > 0) {
            $config = get_store_config($storeId);
            //默认需要服务商审核
            if (!isset($config['installer_check']) || $config['installer_check'] > 0) {
                $checkStatus = -3;
                $flag = FALSE;
            }
        }
        if ($flag && $factoryId) {
            //不需要服务商审核,判断是否需要厂商审核
            $config = get_store_config($factoryId);
            //默认需要厂商审核
            if (!isset($config['installer_check']) || $config['installer_check'] > 0) {
                $checkStatus = -1;
            }else {
                //服务商和厂商都不审核,直接通过
                $checkStatus = 1;
            }
        }
        return $checkStatus;
    }
    function _getAlias()
    {
        return 'UI';
    }
    function _getField(){
        return 'UI.*, S.name as sname, SF.name as fname, UD.udata_id';
    }
    function _getJoin()
    {
        return [
            ['user_data UD', 'UD.user_id = UI.user_id AND UD.third_type = "wechat_applet" AND UD.is_del = 0', 'LEFT'],
            ['store SF', 'SF.store_id = UI.factory_id', 'LEFT'],
            ['store S', 'S.store_id = UI.store_id', 'LEFT'],
        ];
    }
    function _getOrder()
    {
        return 'UI.sort_order ASC, UI.add_time DESC';
    }
    function _getWhere(){
        $where = [
            'UI.is_del'     => 0,
        ];
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $where['UI.factory_id'] = $this->adminUser['store_id'];
        }elseif ($this->adminUser['admin_type'] == ADMIN_SERVICE){
            $where['UI.store_id'] = $this->adminUser['store_id'];
        }
        $params = $this->request->param();
        if ($params) {
            $rname = isset($params['rname']) ? trim($params['rname']) : '';
            if($rname){
                $where['UI.region_name'] = ['like','%'.$rname.'%'];
            }
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['UI.realname'] = ['like','%'.$name.'%'];
            }
            $phone = isset($params['phone']) ? trim($params['phone']) : '';
            if($phone){
                $where['UI.phone'] = ['like','%'.$phone.'%'];
            }
        }
        return $where;
    }
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $search = [
            ['type' => 'input', 'name' =>  'rname', 'value' => '服务区域', 'width' => '30'],
            ['type' => 'input', 'name' =>  'name', 'value' => '工程师姓名', 'width' => '30'],
            ['type' => 'input', 'name' =>  'phone', 'value' => '联系电话', 'width' => '30'],
        ];
        return $search;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = parent::_tableData();
        $btnArray = [];
        $btnArray = [
            ['text'  => '审核', 'action'=> 'check','icon'  => 'pay-setting','bgClass'=> 'bg-yellow'],
            ['text'  => '详情', 'action'=> 'detail','icon'  => 'detail','bgClass'=> 'bg-green'],
        ];
        $table['actions']['button'] = array_merge($table['actions']['button'],$btnArray);
        $table['actions']['width']  = '260';
        return $table;
    }
    /**
     * 详情字段配置
     */
    function _fieldData(){
        $array = [];
        if ($this->adminUser['admin_type'] == ADMIN_SERVICE){
            $array = ['title'=>'服务商名称','type'=>'text','name'=>' ','size'=>'40','default'=> $this->adminStore['name'], 'disabled' => 'disabled'];
        }else{
            $servicers = db('store')->field('store_id as id, name as cname')->where(['is_del' => 0, 'status' => 1, 'store_type' => STORE_SERVICE, 'factory_id' => $this->adminUser['store_id']])->select();
            $this->assign('servicers', $servicers);
            $array = [      'title'=>'选择服务商',
                            'type'=>'select',
                            'options'=>'servicers',
                            'name' => 'store_id', 
                            'size'=>'40' , 
                            'datatype'=>'*', 
                            'default'=>'',
                            'default_option'=>'==选择服务商==',
                            'notetext'=>'请选择服务商'];
        }
        if($this->request->action()!='check'){
            $sort=['title'=>'排序','type'=>'text','name'=>'sort_order','size'=>'20','datatype'=>'','default'=>'1','notetext'=>''];
        }else{
            $check=['title'=>'显示状态','type'=>'radio','name'=>'status','size'=>'20','datatype'=>'','default'=>'1','notetext'=>'','radioList'=>[
                ['text'=>'审核通过','value'=>'1'],
                ['text'=>'拒绝','value'=>'0'],
            ]];
            $textarea=['title'=>'拒绝理由','type'=>'textarea','name'=>'remark','size'=>'30','datatype'=>'*','default'=>'','notetext'=>'如果拒绝，请填写拒绝理由'];
        }
        $field = [
            ['title'=>'厂商名称','type'=>'text','name'=>' ','size'=>'40','default'=> $this->adminFactory['name'], 'disabled' => 'disabled'],
            $array,
            ['title'=>'真实姓名','type'=>'text','name'=>'realname','size'=>'30','datatype'=>'*','default'=>'','notetext'=>'真实姓名'],
            ['title'=>'公安机关备案号','type'=>'text','name'=>'security_record_num', 'size'=>'30', 'datatype'=>'','default'=>'','notetext'=>'请填写公安机关备案号'],
            ['title'=>'联系电话','type'=>'text','name'=>'phone','size'=>'30','datatype'=>'*','default'=>'','notetext'=>'联系电话'],
            ['title'=>'从业时间','type'=>'datetime', 'class' => 'js-date', 'name'=>'work_time','size'=>'20','datatype'=>'*','default'=>'','notetext'=>'工程师从业时间'],
            ['title'=>'身份证正面','type'=>'uploadImg','name'=>'idcard_font_img', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>''],
            ['title'=>'身份证反面','type'=>'uploadImg','name'=>'idcard_back_img', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>''],
            $check??'',
            $textarea??'',
            $sort??''
        ];
        return array_filter($field);
    }
}


