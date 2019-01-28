<?php
/**
 * 帮助中心
 * User: Administrator
 * Date: 2019/1/28 0028
 * Time: 11:32
 */

namespace app\factory\controller;


class Help extends FactoryForm
{
    public function __construct()
    {
        $this->modelName = 'help';
        $this->model = db('help');
        parent::__construct();
    }


    public function _getField()
    {
        return 'H.title,H.add_time,H.status,H.sort_order';
    }

    public function _getWhere()
    {

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
    function _tableData(){
        $table = parent::_tableData();
        //if ($table['actions']['button']) {
        //    $table['actions']['button'][] =  ['text'  => '查看详情','action'=> 'edit', 'icon'  => 'detail','bgClass'=> 'bg-green'];
        //    $table['actions']['width']  = '*';
        //}
        return $table;
    }

}