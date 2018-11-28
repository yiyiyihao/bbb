<?php
namespace app\admin\controller;
use app\common\controller\FormBase;
use think\Db;

//数据表字段管理
class Field extends FormBase
{
    var $pid;
    var $pModel;
    public function __construct()
    {
        $this->modelName = 'field';
        $this->model = model('field');
        parent::__construct();
        $this->subMenu['add'] = [];
        $this->perPage = 100;
        $params = $this->request->param();
        $this->pid = $params['pid'];
//         $this->subMenu['add']['url'] = url("add",['pid'=>$pid]);
    }
    
    /**
     * 获取提交数据
     */
    function _getData(){
        $data = parent::_getData();
        $data['model_id'] = $this->pid;
        return $data;
    }
    
    /**
     * 忽略数据字段操作
     * @author chany
     * @date 2018-11-28
     */
    function ignore(){
        $params = $this->request->param();
        $name = trim($params['name']);
        $msg = lang('IGNORE').lang($name);
        if($name){
            //检查是否有记录存在
            $info = $this->model->where(array('field' => $name))->find();
            if($info){
                $result = $this->model->where(array('field' => $name))->update(array('is_del' => 1, 'update_time' => time()));
            }else{
                $data = [
                    'field'      => $name,
                    'is_del'    => 1,
                    'add_time'  => time(),
                    'update_time'   => time(),
                ];
                $pid = $params['pid'];
                $data['model_id']  = $pid;
                if (method_exists($this->model, 'save')) {
                    $result = $this->model->save($data);
                }else{
                    $result = $this->model->insertGetId($data);
                }
            }
            if($result){
                $msg .= lang('success');
                $this->success($msg);
            }else{
                $this->error($this->model->getError());
            }
        }else{
            $this->error(lang('param_error'));
        }
    }
    
    /**
     * 取得列表后的字段值处理
     */
    function _afterList($list){
        $list = parent::_afterList($list);
        $where = [
            'model_id'      =>  $this->pid,
            'is_del'        =>  0
        ];
        $info = db('model')->where($where)->find();
        if($info && $info['name']){
            //取得现有数据表结构
            $sql = "SHOW COLUMNS FROM ".config('database.prefix').$info['name'];
            $fields = Db::query($sql);
            $fieldList = [];
            foreach ($fields as $k=>$v){
                $fieldList[]['field'] = $v['Field'];
            }
            foreach ($fieldList as $k=>$v){
                foreach ($list as $key=>$val){
                    if($list[$key]['field'] == $fieldList[$k]['field']){
                        $fieldList[$k] = $val;
                    }
                }
            }
            foreach ($fieldList as $k=>$v){
                if(isset($v['is_del']) && $v['is_del'] == 1){
                    unset($fieldList[$k]);
                }
            }
        }else{
            $fieldList = $list;
        }
        return $fieldList;
    }
    
    /**
     * 列表查询条件
     */
    function _getWhere(){
//         $where = parent::_getWhere();
        $where['model_id']  = $this->pid;
        return $where;
    }
}