<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/1/30 0030
 * Time: 11:16
 */

namespace app\factory\controller;
use app\common\controller\Help as CommonHelp;
use think\Db;

class Help extends CommonHelp
{
    public function __construct()
    {
        parent::__construct();
        //dump($this->adminStore);
    }

    private function query($param=[])
    {
        $alias=isset($param['alias'])?$param['alias']:$this->_getAlias();
        $query=$this->model;
        if ($alias) {
            $query->alias($alias);
        }
        $field=isset($param['field'])?$param['field']:$this->_getField();
        if ($field) {
            $query->field($field);
        }
        $join=isset($param['join'])?$param['join']:$this->_getJoin();
        if ($join) {
            $query->join($join);
        }
        $where=isset($param['where'])?$param['where']:$this->_getWhere();
        if ($where) {
            $query->where($where);
        }
        $order=isset($param['order'])?$param['order']:$this->_getOrder();
        if ($order) {
            $query->order($order);
        }
        $data=$query->select();
        return $data;
    }


    public function getList()
    {
        //$data=$this->query(['field'=>'H.title,H.answer']);
        //$this->ajaxJsonReturn($data);
        //return;

        $where=$this->_getWhere();
        $join=$this->_getJoin();
        $alias=$this->_getAlias();
        $order=$this->_getOrder();
        $field='H.title,H.answer';
        $data=$this->model->alias($alias)->field($field)->where($where)->join($join)->order($order)->select();
        $this->ajaxJsonReturn($data);
    }



    public function _afterList($list)
    {
        $where=$this->_getWhere();
        $join=$this->_getJoin();
        $alias=$this->_getAlias();
        $order=$this->_getOrder();
        $field='H.cate_id,C.`name`';
        $result=$this->model->alias($alias)->field($field)->where($where)->join($join)->order($order)->group('H.cate_id')->select();
        //dump($this->model->getLastSql());
        //pre($result);
        $this->assign('cates',$result);
        //pre($list);
        return $list;
    }


    public function _getWhere()
    {

        $where=[
            ['H.is_del','=',0],
            ['C.is_del','=',0],
        ];
        $where[]=['','EXP',Db::raw('FIND_IN_SET('.$this->adminStore['store_type'].',H.visible_store_type)')];
        $cateId=$this->request->param('cate_id',0,'intval');
        $title=$this->request->param('title','','trim');
        if ($cateId>0) {
            $where[]=['C.id','=',$cateId];
        }
        if ($title) {
            $where[]=['H.title','like','%'.$title.'%'];
        }
        return $where;
    }

}