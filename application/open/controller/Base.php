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
    protected $params;
    
    protected $error = FALSE;
    protected $postParams = [];
    protected $user;

    public function initialize()
    {
        $this->pageSize = input('page_size', 10, 'intval');
        $this->page = input('page', 1, 'intval');
        $this->postParams = $this->request->param();
        $this->user = $this->postParams['user'];
        if ($this->user) {
            if ($this->user['factory_id'] > 0) {
                $this->factoryId = $this->user['factory_id'];
            }else{
                $appid = isset($this->postParams['appid']) ? trim($this->postParams['appid']) : '';
                if ($appid){
                    $storeId = db('store_factory')->where('open_appid', $appid)->value('store_id');
                    if (!$storeId){
                        return $this->dataReturn('000005', 'invalid appid');
                    }
                    $this->factoryId = $storeId;
                }
            }
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
        $result = dataFormat($code, $msg, $data);
        if ($code !== 0) {
            $this->error = TRUE;
        }
        return json($result);
    }


    protected function getModelList($model, $where = [], $field = '*', $order = false, $alias = false, $join = [], $group = false, $having = false)
    {
        $data = [];
        if ($this->paginate && $this->pageSize > 0 && $this->page > 0) {
            $query = $model->alias($alias)->join($join)->where($where)->field($field)->paginate($this->pageSize, false, ['page' => $this->page]);
            $data = [
                'total'      => $query->total(),
                'page'       => $query->currentPage(),
                'page_size'  => $query->listRows(),
                'page_count' => $query->lastPage(),
                'list'       => $query->items(),
            ];
        } else {
            $data = $model->alias($alias)->join($join)->where($where)->select();
        }
        return $data;
    }
    
    /**
     * 验证用户是否是商户管理员
     * @param string $manager
     * @return \think\response\Json
     */
    protected function checkStoreManager($manager = TRUE)
    {
        if (!$this->user) {
            return $this->dataReturn('001002', 'user not exist');
        }
        if ($manager) {
            if ($this->user['factory_id'] <= 0) {
                return $this->dataReturn('001900', 'current user is not business manager');
            }
        }else{
            if ($this->user['factory_id'] > 0) {
                return $this->dataReturn('001901', 'current user is business manager');
            }
        }
        return TRUE;
    }
    /**
     * 验证用户是否是分销员
     * @param string $distributor
     * @return \think\response\Json|boolean
     */
    protected function checkStoreDistributor($distributor = TRUE)
    {
        if (!$this->user) {
            return $this->dataReturn('001002', 'user not exist');
        }
        //判断当前用户是否是分销员
        $where = [
            ['is_del', '=', 0],
            ['status', '=', 1],
            ['check_status', '=', 1],
            ['udata_id', '=', $this->user['udata_id']],
            ['factory_id', '=', $this->factoryId],
        ];
        $exist = model('UserDistributor')->where($where)->find();
        if ($distributor) {
            if (!$exist) {
                return $this->dataReturn('001700', 'current user is not distributor');
            }
            return $exist;
        }else{
            if ($exist) {
                return $this->dataReturn('001701', 'current user is distributor');
            }
        }
        return TRUE;
    }
}