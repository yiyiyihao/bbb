<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2018/12/24 0024
 * Time: 19:28
 */

namespace app\factory\controller;


use app\common\controller\FormBase;

class Content extends FormBase
{
    public function __construct()
    {
        $this->modelName = 'website_content';
        $this->model = db('website_content');
        parent::__construct();
        $this->subMenu['add'] = [
            'name' => '新增内容',
            'url' => url('add'),
        ];
    }

    public function add()
    {
        $this->subMenu['add'] = [
            'name' => '返回',
            'url' => url('index'),
        ];
        return $this->fetch();
    }


    public function _getField()
    {

    }

    public function _getWhere()
    {

    }

    public function _getAlias()
    {

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
    function _searchData(){
        $search = [
            ['type' => 'input', 'name' =>  'name', 'value' => '登录用户名', 'width' => '30'],
            ['type' => 'input', 'name' =>  'phone', 'value' => '手机号', 'width' => '30'],
        ];
        return $search;
    }



}