<?php
namespace app\admin\controller;
use app\admin\controller\AdminForm;
use think\Db;

//数据表列表字段管理
class Table extends AdminForm
{
    var $pid;
    var $pModel;
    public function __construct()
    {
        $this->modelName = 'form_table';
        $this->model = model('table');
        $this->pModel= db('form_model');
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
        $info = $this->pModel->where($where)->find();
        if($info && $info['name']){
            //取得现有数据表结构
            $sql = "SHOW COLUMNS FROM ".config('database.prefix').$info['name'];
            $fields = Db::query($sql);
            $tableList = [];
            foreach ($fields as $k=>$v){
                $tableList[]['field'] = $v['Field'];
            }
            foreach ($tableList as $k=>$v){
                foreach ($list as $key=>$val){
                    if($list[$key]['field'] == $tableList[$k]['field']){
                        $tableList[$k] = $val;
                    }
                }
            }
            foreach ($tableList as $k=>$v){
                if(isset($v['is_del']) && $v['is_del'] == 1){
                    unset($tableList[$k]);
                }
            }
        }else{
            $tableList = $list;
        }
        return $tableList;
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