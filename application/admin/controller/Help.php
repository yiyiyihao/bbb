<?php
/**
 * 帮助中心
 * User: Administrator
 * Date: 2019/1/28 0028
 * Time: 11:32
 */

namespace app\admin\controller;


use app\common\controller\FormBase;

class Help extends AdminForm
{
    protected $storeType=[];

    public function __construct()
    {
        $this->modelName = 'help';
        $this->model = model('help');
        parent::__construct();
        $this->storeType=[
            STORE_CHANNEL => '渠道商',
            STORE_DEALER => '零售商',
            STORE_SERVICE => '服务商',
        ];
        $this->assign('storeType',$this->storeType);
    }

    public function add()
    {
        $parentId=$this->request->param('parent_id',0,'intval');
        if ($parentId>0){
            $id=db('help')->where(['is_del'=>0,'status'=>1])->value('id');
            if ($id) {
                $this->assign('pid',$parentId);
            }
        }
        return parent::add();

    }


    public function _getField()
    {
        return 'H.id,H.parent_id,H.title,H.answer,H.add_time,H.status,H.sort_order,H.visible_store_type';
    }

    public function _getWhere()
    {
        $where=['H.is_del'=>0];
        return $where;
    }

    public function _getAlias()
    {
        return 'H';

    }

    public function _getJoin()
    {

    }

    public function _getOrder()
    {

    }

    public function _afterList($list)
    {
        $store = $this->storeType;
        foreach ($list as $key => &$value) {
            if (isset($value['visible_store_type'])){
                $storeType=$value['visible_store_type'];
                $arr=array_map(function ($item) use ($store) {
                    if (isset($store[$item])) {
                        return $store[$item];
                    }
                },$storeType);
                $value['visible_store_type']=implode('、',$arr);
            }
        }
        $treeService = new \app\common\service\Tree('id',['2'=>'title']);
        $list = $treeService->getTree($list, 0, 'id');
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
            $preview=['text'  => '预览','action'=> 'edit', 'icon'  => 'detail','bgClass'=> 'bg-blue'];
            array_unshift($table['actions']['button'],$preview);
            $table['actions']['width']  = '210';
        }
        return $table;
    }

}