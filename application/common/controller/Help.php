<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/1/30 0030
 * Time: 11:27
 */

namespace app\common\controller;


class Help extends FormBase
{
    protected $storeType = [];

    public function __construct()
    {
        $this->modelName = 'help';
        $this->model = model('help');
        parent::__construct();
        $this->init();
    }

    private function init()
    {
        $this->storeType = [
            STORE_FACTORY => '厂商',
            STORE_CHANNEL => '渠道商',
            STORE_DEALER => '零售商',
            STORE_SERVICE => '服务商',
            STORE_SERVICE_NEW => '新服务商',
        ];
        //$this->subMenu['add'] = [
        //    'name' => '新增问题',
        //    'url' => url('add'),
        //];
        $this->assign('storeType', $this->storeType);
        $helpCateModel = model('HelpCate');
        $cates = $helpCateModel->field('id,name')->where(['is_del' => 0])->select();
        $this->assign('cates', $cates);
    }

    public function detail()
    {
        $info=$this->_assignInfo();
        $info['name']=model('HelpCate')->where(['id'=>$info['cate_id']])->value('name');
        $info['visible']=$this->getStoreName($info['visible_store_type']);
        return $this->fetch();
    }


    public function add()
    {
        $parentId = $this->request->param('parent_id', 0, 'intval');
        if ($parentId > 0) {
            $id = db('help')->where(['is_del' => 0, 'status' => 1])->value('id');
            if ($id) {
                $this->assign('pid', $parentId);
            }
        }
        return parent::add();
    }


    public function _getField()
    {
        return 'H.id,H.cate_id,C.status cate_status,C.name,H.title,H.answer,H.add_time,H.status,H.sort_order,C.sort_order cate_order,H.visible_store_type';
    }

    public function _getWhere()
    {
        $where = [
            'H.is_del' => 0,
            'C.is_del' => 0,
        ];
        return $where;
    }

    public function _getAlias()
    {
        return 'H';

    }

    public function _getJoin()
    {
        return [
            ['help_cate C', 'H.cate_id=C.id']
        ];

    }

    public function _getOrder()
    {
        return 'C.sort_order ASC,H.sort_order ASC';
    }

    private function getStoreName($storeType)
    {
        $store = $this->storeType;
        //pre($storeType);
        $tem = array_map(function ($item) use ($store) {
            if (isset($store[$item])) {
                return $store[$item];
            }
        }, $storeType);
        $result=implode('、',$tem);
        return $result;
    }

    public function _afterList($list)
    {
        $arr = [];
        foreach ($list as $key => $value) {
            if (isset($value['visible_store_type'])) {
                $value['visible_store_type'] =$this->getStoreName($value['visible_store_type']);
            }
            $arr[] = $value;
        }
        $list = array_merge($arr);
        //pre($list);
        return $list;
    }


    /**
     * 列表搜索配置
     */
    function _searchData()
    {
        //$search = [
        //    ['type' => 'input', 'name' => 'phone', 'value' => '手机号', 'width' => '30'],
        //];
        //return $search;
    }

    /**
     * 列表项配置
     */
    function _tableData()
    {
        $table = parent::_tableData();
        if ($table['actions']['button']) {
            $preview = ['text'  => '详情', 'action'=> 'detail','icon'  => 'detail','bgClass'=> 'bg-green'];
            array_unshift($table['actions']['button'], $preview);
            $table['actions']['width'] = '210';
        }
        return $table;
    }

}