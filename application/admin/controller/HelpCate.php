<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/1/29 0029
 * Time: 14:17
 */

namespace app\admin\controller;


class HelpCate extends AdminForm
{
    public function __construct()
    {
        $this->modelName = 'help_cate';
        $this->model = model('helpCate');
        parent::__construct();
    }


    //删除下级元素
    public function _afterDel($info = [])
    {
        model('help')->where([
            'cate_id' => $info['id'],
            'is_del' => 0,
        ])->update(['is_del' => 1, 'update_time' => time()]);
    }

    public function _afterList($list){
        //pre($list);
        return $list;
    }

    //public function _afterAdd($pkId=0, $data=[])
    //{
    //    $this->success('分类添加成功', url("help/index"));
    //}


    public function _getField()
    {
        return 'C.id,C.name,C.sort_order,C.status';
    }

    public function _getWhere()
    {
        $where=[
            'C.is_del'=>0,
        ];
        return $where;
    }

    public function _getAlias()
    {
        return 'C';
    }
    public function _getOrder()
    {
        return 'C.sort_order ASC';
    }

    /**
     * 列表项配置
     */
    function _tableData()
    {
        $table = parent::_tableData();
        $table['actions']['button'][1]['title']='删除后，该分类下的所有问题，都将会被删除，确定要删除吗？';
        //pre($table);
        return $table;
    }

}