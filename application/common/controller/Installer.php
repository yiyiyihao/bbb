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
        if (!in_array($this->adminUser['admin_type'], [1,2])) {
            if ($this->adminUser['admin_type'] != 5) {
                $this->error('NO ACCESS');
            }
        }
        if (!$this->adminUser['store_id']){
            $store = new \app\common\controller\Store();
            $store->_getFactorys();
        }
        $this->search= self::_searchData();
        $this->table = self::_tableData();
        $this->field = self::_fieldData();
        $this->breadCrumb[] = [
            'name' => '待审核',
            'url' => url('checklist'),
        ];
        unset($this->subMenu['add']);
    }
    function _getData()
    {
        $info = $this->_assignInfo();
        if (!$info) {
            $this->error(lang('NO ACCESS'));
        }
        $params = parent::_getData();
        $realname = isset($params['realname']) ? trim($params['realname']) : '';
        if (!$realname) {
            $this->error('售后工程师真实姓名不能为空');
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
    function _assignInfo($pkId = 0){
        $info = parent::_assignInfo($pkId);
        $this->_getUgroup();
        return $info;
    }
    function _getUgroup()
    {
        $groups = db('user_group')->where(['is_del' => 0, 'status' =>1,  'store_id' => ['IN', [0, $this->adminUser['store_id']]]])->select();
        $this->assign('groups', $groups);
        return $groups;
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
        $field = [
            ['title'=>lang($this->modelName).'真实姓名','type'=>'text','name'=>'realname','size'=>'30','datatype'=>'*','default'=>'','notetext'=>lang($this->modelName).'真实姓名'],
            ['title'=>lang($this->modelName).'联系电话','type'=>'text','name'=>'phone','size'=>'30','datatype'=>'*','default'=>'','notetext'=>lang($this->modelName).'联系电话'],
            ['title'=>'显示状态','type'=>'radio','name'=>'status','size'=>'20','datatype'=>'','default'=>'1','notetext'=>'','radioList'=>[
                ['text'=>'可用','value'=>'1'],
                ['text'=>'禁用','value'=>'0'],
            ]],
            ['title'=>'排序','type'=>'text','name'=>'sort_order','size'=>'20','datatype'=>'','default'=>'1','notetext'=>''],
        ];
        return array_filter($field);
    }
}