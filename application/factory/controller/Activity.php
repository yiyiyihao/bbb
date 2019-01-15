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
        $data['start_time'] = strtotime($data['start_time']);
        $data['end_time'] = strtotime($data['end_time']);
        return $data;
    }
}