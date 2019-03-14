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
        if ($this->pageSize > 50) {
            echo json_encode(dataFormat(100100, '单页显示数量不能大于50'));
            exit();
        }
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
        return json(dataFormat($code, $msg, $data));
    }


    protected function getModelList($model, $where = [], $field = '*', $order = false, $alias = false, $join = [], $group = false, $having = false)
    {
        if ($alias) $model->alias($alias);
        if ($join) $model->join($join);
        if ($where) $model->where($where);
        if ($having) $model->having($having);
        if ($order) $model->order($order);
        if ($group) $model->group($group);
        $result = [];
        if ($this->paginate && $this->pageSize > 0 && $this->page > 0) {
            $data = $model->field($field)->paginate($this->pageSize, false, ['page' => $this->page]);
            if (!$data->isEmpty()) {
                $result = [
                    'total'      => $data->total(),
                    'page'       => $data->currentPage(),
                    'page_size'  => $data->listRows(),
                    'page_count' => $data->lastPage(),
                    'list'       => $data->items(),
                ];
            }
        } else {
            $result = $model->field($field)->select();
        }
        if (empty($result)) {
            return dataFormat(404, '暂无数据!');
        }
        return dataFormat(0, 'ok', $result);
    }


}
