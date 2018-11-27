<?php
namespace app\admin\controller;
use app\common\controller\FormBase;
use think\Request;

//用户分组管理
class Ugroup extends FormBase
{
    var $storeId;
    public function __construct()
    {
        $this->modelName = 'user_group';
        $this->model = db($this->modelName);
        parent::__construct();
    }
    
    /**
     * 用户组授权
     */
    public function purview(){
        $params = $this->request->param();
        $pkId = intval($params['id']);
        if($pkId){
            if(IS_POST){
                $msg = lang($this->modelName.'_purview');
                $grouppurview = json_encode($params['grouppurview']);
                $data['menu_json'] = $grouppurview;
                $pk   =   $this->model->getPk();
                $where[$pk] = $pkId;
                $rs = $this->model->where($where)->update($data);
                if($rs){
                    $msg .= lang('success');
                    $this->success($msg, url("index"), TRUE);
                }else{
                    $msg .= lang('fail');
                    $this->error($msg);
                }
            }else{
                //取得当前用户组详情
                $info = parent::_assignInfo($pkId);
                $grouppurview = $info['menu_json'];
                if($grouppurview != 'all' && $grouppurview != ''){
//                     $grouppurview = json_decode($grouppurview,true);
                }
//                 $grouppurview = 'all';
                //取得当前用户组授权树
                $purviewvList = controller("purview","service")->getGroupPurview($info['menu_json']);
                $this->assign('purviewvList', $purviewvList);
                $this->assign('grouppurview', $grouppurview);
                return $this->fetch();
            }
        }else{
            $this->error(lang('param_error'));
        }
    }
    
    function _getWhere(){
        $where = ['is_del' => 0];
        $params = $this->request->param();
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['name'] = ['like','%'.$name.'%'];
            }
        }
        return $where;
    }
    function _getData()
    {
        $data = parent::_getData();
        $name = trim($data['name']);
        if (!$name) {
            $this->error('分组名称不能为空');
        }
        $where = ['name' => $name, 'is_del' => 0];
        $params = $this->request->param();
        $pkId = $params && isset($params['id']) ? intval($params['id']) : 0;
        if($pkId){
            $where['group_id'] = ['neq', $pkId];
        }
        $exist = $this->model->where($where)->find();
        if($exist){
            $this->error('当前分组名称已存在');
        }
        $data['name'] = $name;
        $data['menu_json'] = '';
        return $data;
    }
    function del(){
        $params = $this->request->param();
        $pkId = intval($params['id']);
        if ($pkId <= USER) {
            $this->error('系统分组，不允许删除');
        }
        $info = parent::_assignInfo($pkId);
        //判断当前分组下是否存在用户
        $device = db('user')->where(['group_id' => $pkId, 'is_del' => 0])->find();
        if ($device) {
            $this->error('分组下存在用户，不允许删除');
        }
        parent::del();
    }
}
