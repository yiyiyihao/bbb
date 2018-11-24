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
    }
    private function _tableData(){
        $table = [
            [
                'title'     => '编号',
                'width'     => '60',
                'value'     => 'id',
                'type'      => 'index',
            ],
            [
                'title'     => '厂商名称',
                'width'     => '200',
                'value'     => 'name',
                'type'      => 'text',
            ],
            [
                'title'     => '二级域名',
                'width'     => '100',
                'value'     => 'domain',
                'type'      => 'text',
            ],
            [
                'title'     => '登录用户名',
                'width'     => '120',
                'value'     => 'username',
                'type'      => 'text',
            ],
            [
                'title'     => '联系电话',
                'width'     => '120',
                'value'     => 'mobile',
                'type'      => 'text',
            ],
            [
                'title'     => '厂商地址',
                'width'     => '*',
                'value'     => 'address',
                'type'      => 'text',
            ],
            [
                'title'     => '状态',
                'width'     => '60',
                'value'     => 'status',
                'type'      => 'yesOrNo',
                'yes'       => '可用',
                'no'        => '禁用',
            ],
            [
                'title'     => '排序',
                'width'     => '60',
                'value'     => 'sort_order',
                'type'      => 'text',
            ],
            [
                'title'     => '操作',
                'width'     => '160',
                'type'      => 'button',
                'button'    =>  [
                    [
                        'text'  => '编辑',
                        'action'=> 'edit',
                        'icon'  => 'edit',
                        'bgClass'=> 'bg-main',
                    ],
                    [
                        'text'  => '删除',
                        'action'=> 'del',
                        'icon'  => 'delete',
                        'bgClass'=> 'bg-red',
                    ],
                ]
            ],
        ];
        return $table;
    }
}