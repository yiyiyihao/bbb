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
        $this->modelName = '帮助';
        $this->model = model('help');
        parent::__construct();
        $this->init();

    }

    private function init()
    {
        $this->storeType=[
            STORE_CHANNEL => '渠道商',
            STORE_DEALER => '零售商',
            STORE_SERVICE => '服务商',
        ];
        //$this->subMenu['add'] = [
        //    'name' => '新增问题',
        //    'url' => url('add'),
        //];
        $this->assign('storeType',$this->storeType);
        $helpCateModel=model('HelpCate');
        $cates=$helpCateModel->field('id,name')->where(['is_del'=>0])->select();
        $this->assign('cates',$cates);
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

    public function _afterDel($info=[])
    {

    }


    public function _getField()
    {
        return 'H.id,H.cate_id,C.status cate_status,C.name,H.title,H.answer,H.add_time,H.status,H.sort_order,C.sort_order cate_order,H.visible_store_type';
    }

    public function _getWhere()
    {
        $where=[
            'H.is_del'=>0,
            'C.is_del'=>0,
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
            ['help_cate C','H.cate_id=C.id']
        ];

    }

    public function _getOrder()
    {
        return 'C.sort_order ASC,H.sort_order ASC';
    }

    public function _afterList($list)
    {
        $store = $this->storeType;
        $arr=[];
        foreach ($list as $key=>$value) {
            if (isset($value['visible_store_type'])){
                $storeType=$value['visible_store_type'];
                $tem=array_map(function ($item) use ($store) {
                    if (isset($store[$item])) {
                        return $store[$item];
                    }
                },$storeType);
                $value['visible_store_type']=implode('、',$tem);
            }
            $arr[]=$value;
            //$arr[$value['cate_id']]=isset($arr[$value['cate_id']])?$arr[$value['cate_id']]:[];
            //$arr[$value['cate_id']]['cate_id']=$value['cate_id'];
            //$arr[$value['cate_id']]['cate_name']=$value['name'];
            //$arr[$value['cate_id']]['cate_status']=$value['cate_status'];
            //$arr[$value['cate_id']]['cate_order']=$value['cate_order'];
            //$arr[$value['cate_id']]['sub'][]=$value;
        }
        $list=array_merge($arr);
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
            $preview=['text'  => '预览','action'=> 'edit', 'icon'  => 'detail','bgClass'=> 'bg-blue'];
            array_unshift($table['actions']['button'],$preview);
            $table['actions']['width']  = '210';
        }
        return $table;
    }

}