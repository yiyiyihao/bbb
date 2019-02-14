<?php
namespace app\factory\controller;


class Activity extends FactoryForm
{
    public function __construct()
    {
        $this->modelName = 'activity';
        $this->model = db($this->modelName);
        parent::__construct();
    }
    public function index()
    {
        $this->request->id = 1;
        return $this->edit();
    }
    public function _getData()
    {
        $data = parent::_getData();
        $goodsId=explode(',',trim(str_replace('，',',',$data['goods_id'])));
        $goodsId=array_map(function ($item){
            $v=intval(trim($item));
            if ($v>0){
                return $v;
            }
        },$goodsId);
        $goodsId=array_unique(array_filter($goodsId));
        $data['goods_id']=implode(',',$goodsId);
        $data['start_time'] = strtotime($data['start_time']);
        $data['end_time'] = strtotime($data['end_time']);
        return $data;
    }
}