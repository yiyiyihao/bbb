<?php
namespace app\admin\controller;
use think\Db;

//数据表管理
class Database extends AdminForm
{
    public function __construct()
    {
        $this->modelName = 'form_model';
        $this->model = db('form_model');
        parent::__construct();
        $this->subMenu['add'] = [];
        $this->perPage = 100;
    }
    
    /**
     * 忽略数据表操作
     * @author chany
     * @date 2018-11-27
     */
    function ignore(){
        $params = $this->request->param();
        $name = trim($params['name']);
        $msg = lang('IGNORE').lang($name);
        if($name){
            //检查是否有记录存在
            $info = $this->model->where(array('name' => $name))->find();
            if($info){
                $result = $this->model->where(array('name' => $name))->update(array('is_del' => 1, 'update_time' => time()));
            }else{
                $data = [
                    'name'      => $name,
                    'is_del'    => 1,
                    'add_time'  => time(),
                    'update_time'   => time(),
                ];
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
     * 取得列表后的列表值处理
     */
    function _afterList($list){
        $list = parent::_afterList($list);
        //取得现有数据表结构
        $sql = "SHOW TABLES";
        $tables = Db::query($sql);
        $tableList = [];
        foreach ($tables as $k=>$v){
            foreach ($v as $key=>$v){
                $mName = str_replace("wja_", "", $v);
                $tableList[]['name'] = $mName;
            }
        }
        foreach ($tableList as $k=>$v){
            foreach ($list as $key=>$val){
                if($list[$key]['name'] == $tableList[$k]['name']){
                    $tableList[$k] = $val;
                }
            }
        }
        foreach ($tableList as $k=>$v){
            if(isset($v['is_del']) && $v['is_del'] == 1){
                unset($tableList[$k]);
            }
        }
        return $tableList;
    }
    
    /**
     * 取得查询条件
     */
    function _getWhere(){
        $where = $this->where;
        return $where;
    }
}