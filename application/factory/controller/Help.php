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

    public function getList()
    {
        $field='H.title,H.id';
        $alias=$this->_getAlias();
        $join=$this->_getJoin();
        $where=$this->_getWhere();
        $order=$this->_getOrder();
        $count =$this->model->alias($alias)->field($field)->where($where)->join($join)->count();
        $list=$this->model->alias($alias)
            ->field($field)
            ->where($where)
            ->join($join)
            ->order($order)
            ->paginate($this->perPage,$count, ['query' => input('param.'),'path'=>url('help/index')]);
        $result=[
            'page'=>$list->render(),
            'list'=>$list->toArray()['data']
        ];
        $this->ajaxJsonReturn($result);
    }



    public function _afterList($list)
    {
        $where=$this->_getWhere();
        $join=$this->_getJoin();
        $alias=$this->_getAlias();
        $order=$this->_getOrder();
        $field='H.cate_id,C.`name`';
        unset($where['C.id']);
        $result=$this->model->alias($alias)->field($field)->where($where)->join($join)->order($order)->group('H.cate_id')->select();
        //dump($this->model->getLastSql());
        //pre($result);
        $this->assign('cates',$result);
        //pre($list);
        return $list;
    }


    public function _getWhere()
    {
        $where['H.is_del']=0;
        $where['C.is_del']=0;
        $where[]=['','EXP',Db::raw('FIND_IN_SET('.$this->adminStore['store_type'].',H.visible_store_type)')];
        $cateId=$this->request->param('cate_id',0,'intval');
        if ($cateId == 0) {//默认打开第一个分类菜单
            $join=$this->_getJoin();
            $alias=$this->_getAlias();
            $order=$this->_getOrder();
            $field='H.cate_id,C.`name`';
            $cate=$this->model->alias($alias)->field($field)->where($where)->join($join)->order($order)->group('H.cate_id')->find();
            $cateId=$cate['cate_id'];
            $this->assign('cate_name',$cate['name']);
        }
        $title=$this->request->param('title','','trim');
        if ($cateId>0) {
            $where['C.id']=$cateId;
        }
        if ($title) {
            $where['H.title']=['like','%'.$title.'%'];
        }
        return $where;
    }

}