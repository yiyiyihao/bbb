<?php
namespace app\admin\controller;
use app\common\controller\Store;

//厂商管理
class Factory extends Store
{
    var $storeType;
    var $parent;
    var $groupId;
    public function __construct()
    {
        $this->modelName = 'factory';
        $this->model = model('store');
        $this->storeType = 1;//厂商
        $this->groupId = 2;
        parent::__construct();
        $this->table = self::_tableData();
        $this->field = self::_fieldData();
    }
    /**
     * 列表项配置
     */
    private function _tableData(){
        $table = [
            ['title'     => '编号','width'     => '60','value'      => 'factory_id','type'      => 'index'],
            ['title'     => '厂商名称','width'  => '200','value'     => 'name','type'      => 'text'],
            ['title'     => '二级域名','width'  => '100','value'     => 'domain','type'      => 'text'],
            ['title'     => '登录用户名','width' => '120','value'     => 'username','type'      => 'text'],
            ['title'     => '联系电话','width'  => '120','value'     => 'mobile','type'      => 'text'],
            ['title'     => '厂商地址','width'  => '*','value'       => 'address','type'      => 'text'],
            ['title'     => '状态','width'     => '60','value'      => 'status','type'      => 'yesOrNo','yes'       => '可用','no'        => '禁用'],
            ['title'     => '排序','width'     => '60','value'      => 'sort_order','type'      => 'text'],
            ['title'     => '操作','width'     => '160','value'   => 'store_id','type'      => 'button','button'    =>  [['text'  => '编辑','action'=> 'edit','icon'  => 'edit','bgClass'=> 'bg-main'],['text'  => '删除','action'=> 'del','icon'  => 'delete','bgClass'=> 'bg-red']]]
        ];
        return $table;
    }
    /**
     * 详情字段配置
     */
    private function _fieldData(){
        $field = [
            ['title'=>'厂商名称','type'=>'text','name'=>'name','size'=>'40','datatype'=>'*','default'=>'','notetext'=>'厂商名称请不要填写特殊字符'],
            ['title'=>'二级域名','type'=>'text','name'=>'domain','size'=>'20','datatype'=>'','default'=>'','notetext'=>'厂商二级域名不能重复'],
            ['title'=>'厂商Logo','type'=>'uploadImg','name'=>'logo','size'=>'20','datatype'=>'','default'=>'','notetext'=>''],
            ['title'=>'厂商地址','type'=>'text','name'=>'address','size'=>'60','datatype'=>'','default'=>'','notetext'=>'请填写厂商地址'],
            ['title'=>'显示状态','type'=>'radio','name'=>'status','size'=>'20','datatype'=>'','default'=>'1','notetext'=>'','radioList'=>[
                ['text'=>'可用','value'=>'1'],
                ['text'=>'禁用','value'=>'0'],
            ]],
            ['title'=>'排序','type'=>'text','name'=>'sort_order','size'=>'20','datatype'=>'','default'=>'255','notetext'=>''],
        ];
        return $field;
    }
}