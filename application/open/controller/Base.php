<?php

namespace app\open\controller;

use think\Controller;
use think\facade\Response;
use think\Request;

class Base extends \app\common\controller\Base

{
    protected $pageSize;
    protected $page;
    protected $paginate = true;
    protected $factory;
    protected $factoryId = 1;

    public function initialize()
    {
        $this->pageSize = input('page_size', 10, 'intval');
        $this->page = input('page', 1, 'intval');
        $this->factory = db('store')->where(['is_del' => 0, 'status' => 1])->find($this->factoryId);
    }


    public function dataReturn(...$code)
    {
        $args = [];
        if (func_num_args() == 1 && is_array(func_get_arg(0))) {
            $args = func_get_arg(0);
        } else {
            $args = func_get_args();
        }
        $code = array_shift($args);
        $msg = array_shift($args);
        $data = array_shift($args);
        $result = dataFormat($code, $msg, $data);
        if ($result['code'] == '404404') {//适配前端
            $result['code'] = '0';
        }
        return json($result);
    }


    protected function getModelList($model, $where = [], $field = '*', $order = false, $alias = false, $join = [], $group = false, $having = false)
    {
        if ($alias) $model->alias($alias);
        if ($join) $model->join($join);
        if ($where) $model->where($where);
        if ($having) $model->having($having);
        if ($order) $model->order($order);
        if ($group) $model->group($group);

        $code = 0;
        $msg = 'ok';
        $data = [];
        if ($this->paginate && $this->pageSize > 0 && $this->page > 0) {
            $query = $model->field($field)->paginate($this->pageSize, false, ['page' => $this->page]);
            $data = [
                'total'      => $query->total(),
                'page'       => $query->currentPage(),
                'page_size'  => $query->listRows(),
                'page_count' => $query->lastPage(),
                'list'       => $query->items(),
            ];
        } else {
            $data = $model->field($field)->select();
        }
        if (isset($data['list']) && empty($data['list']) || empty($data)) {
            $code = '404404';
            $msg = '暂无数据';
        }
        return dataFormat($code, $msg, $data);
    }


}
