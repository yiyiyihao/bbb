<?php
namespace app\common\controller;

//售后工程师管理
class Installer extends FormBase
{
    var $adminType;
    public function __construct()
    {
        $this->modelName = 'user_installer';
        $this->model = db($this->modelName);
        parent::__construct();
        
        if (!in_array($this->adminUser['admin_type'], [ADMIN_SYSTEM, ADMIN_FACTORY])) {
            if ($this->adminUser['admin_type'] != ADMIN_SERVICE) {
                $this->error('NO ACCESS');
            }
        }
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY){
            $this->_getFactorys();
        }
        $this->search= self::_searchData();
        $this->table = self::_tableData();
        $this->field = self::_fieldData();
//         $this->breadCrumb[] = [
//             'name' => '待审核',
//             'url' => url('checklist'),
//         ];
        $this->uploadUrl = url('Upload/upload', ['prex' => 'store_logo_', 'thumb_type' => 'logo_thumb']);
    }
    function _getData()
    {
        $info = $this->_assignInfo();
        $params = parent::_getData();
        $storeId = isset($params['store_id']) ? intval($params['store_id']) : '';
        $realname = isset($params['realname']) ? trim($params['realname']) : '';
        $phone = isset($params['phone']) ? trim($params['phone']) : '';
        $regionId = isset($params['region_id']) ? intval($params['region_id']) : '';
        $regionName = isset($params['region_name']) ? trim($params['region_name']) : '';
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
        if (!$regionId || !$regionName) {
            $this->error('请选择服务区域');
        }
        if (!$avatar) {
            $this->error('请上传工程师头像');
        }
        if (!$fontimg) {
            $this->error('请上传身份证正面图片');
        }
        if (!$backimg) {
            $this->error('请上传身份证反面图片');
        }
        if (!$info) {
            if ($this->adminUser['admin_type'] == ADMIN_SERVICE) {
                $params['store_id'] = $this->adminStore['store_id'];
                $params['factory_id'] = $this->adminStore['factory_id'];
            }elseif ($this->adminUser['admin_type'] == ADMIN_FACTORY){
                $params['store_id'] = $storeId;
                $params['factory_id'] = $this->adminStore['store_id'];
            }
        }
        return $params;
    }
    function _getAlias()
    {
        return 'UI';
    }
    function _getField(){
        return 'UI.*, U.username, S.name as sname, SF.name as fname';
    }
    function _getJoin()
    {
        return [
            ['user U', 'U.user_id = UI.user_id', 'LEFT'],
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
//             'UI.admin_type' => ['>', 0],
            'UI.user_id' => ['>', 1],
        ];
        $params = $this->request->param();
        if ($params) {
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
            ['type' => 'input', 'name' =>  'name', 'value' => '真实姓名', 'width' => '30'],
            ['type' => 'input', 'name' =>  'phone', 'value' => '联系电话', 'width' => '30'],
        ];
        return $search;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = [
            ['title'     => '编号','width'    => '60','value'      => 'user_id','type'      => 'index'],
            ['title'     => '所属厂商','width' => '*','value'     => 'fname','type'      => 'text'],
            ['title'     => '所属服务商','width' => '*','value'     => 'sname','type'      => 'text'],
            ['title'     => '真实姓名','width'  => '*','value'      => 'realname','type'      => 'text'],
            ['title'     => '登录用户名','width'  => '*','value'     => 'username','type'      => 'text'],
            ['title'     => '联系电话','width'  => '*','value'      => 'phone','type'      => 'text'],
            ['title'     => '状态','width'    => '80','value'      => 'status','type'      => 'yesOrNo', 'yes'       => '可用','no'        => '禁用'],
            ['title'     => '排序','width'    => '80','value'      => 'sort_order','type'      => 'text'],
            ['title'     => '操作','width'    => '*','value'      => 'installer_id','type'      => 'button','button'    =>
                [
                    ['text'  => '审核','action'=> 'check','icon'  => 'edit','bgClass'=> 'bg-yellow'],
                    ['text'  => '编辑','action'=> 'edit','icon'  => 'edit','bgClass'=> 'bg-main'],
                    ['text'  => '删除','action'=> 'del','icon'  => 'delete','bgClass'=> 'bg-red']
                ]
            ]
        ];
        return array_filter($table);
    }
    /**
     * 详情字段配置
     */
    function _fieldData(){
        $array = [];
        if ($this->adminUser['admin_type'] == ADMIN_SERVICE){
            $array = ['title'=>'服务商名称','type'=>'text','name'=>'','size'=>'40','default'=> $this->adminStore['name'], 'disabled' => 'disabled'];
        }else{
            $servicers = db('store')->field('store_id as id, name as cname')->where(['is_del' => 0, 'status' => 1, 'store_type' => STORE_SERVICE, 'factory_id' => $this->adminUser['store_id']])->select();
            $this->assign('servicers', $servicers);
            $array = ['title'=>'选择服务商','type'=>'select','options'=>'servicers','name' => 'store_id', 'size'=>'40' , 'datatype'=>'*', 'default'=>'','default_option'=>'==选择服务商==','notetext'=>'请选择服务商'];
        }
        $field = [
            ['title'=>'厂商名称','type'=>'text','name'=>'','size'=>'40','default'=> $this->adminFactory['name'], 'disabled' => 'disabled'],
            $array,
            ['title'=>'真实姓名','type'=>'text','name'=>'realname','size'=>'30','datatype'=>'*','default'=>'','notetext'=>'真实姓名'],
            ['title'=>'头像','type'=>'uploadImg','name'=>'avatar', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>''],
            ['title'=>'联系电话','type'=>'text','name'=>'phone','size'=>'30','datatype'=>'*','default'=>'','notetext'=>'联系电话'],
            ['title'=>'服务区域','type'=>'region','name'=>'region_id','size'=>'30','datatype'=>'*','default'=>'','notetext'=>'请选择工程师服务区域'],
            ['title'=>'从业时间','type'=>'datetime', 'class' => 'js-date', 'name'=>'work_time','size'=>'20','datatype'=>'*','default'=>'','notetext'=>'工程师从业时间'],
            ['title'=>'身份证正面','type'=>'uploadImg','name'=>'idcard_font_img', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>''],
            ['title'=>'身份证反面','type'=>'uploadImg','name'=>'idcard_back_img', 'width'=>'20', 'datatype'=>'','default'=>'','notetext'=>''],
            ['title'=>'显示状态','type'=>'radio','name'=>'status','size'=>'20','datatype'=>'','default'=>'1','notetext'=>'','radioList'=>[
                ['text'=>'可用','value'=>'1'],
                ['text'=>'禁用','value'=>'0'],
            ]],
            ['title'=>'排序','type'=>'text','name'=>'sort_order','size'=>'20','datatype'=>'','default'=>'1','notetext'=>''],
        ];
        return array_filter($field);
    }
}