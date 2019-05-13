<?php
namespace app\factory\controller;
use app\common\controller\FormBase;
//分销员管理
class Distributor extends FormBase
{
    public function __construct()
    {
        $this->modelName = 'user_distributor';
        $this->model = model('user_distributor');
        parent::__construct();
    }
    public function check()
    {
        $info = $this->_assignInfo();
        $checkStatus = $info['check_status'];
        //已拒绝不允许审核
        if (in_array($checkStatus, [1, 2])) {
            $this->error('操作已审核');
        }
        if ($info['factory_id'] != $this->adminUser['factory_id']) {
            $this->error(lang('NO_OPERATE_PERMISSION'));
        }
        $params = $this->request->param();
        if (IS_POST) {
            $remark = isset($params['remark']) ? trim($params['remark']) : '';
            $checkStatus = isset($params['check_status']) ? intval($params['check_status']) : 0;
            if (!$checkStatus && !$remark) {
                $this->error('请填写备注（不通过原因）');
            }
            $status = $checkStatus > 0 ? 1: 2;
            $data = [
                'check_status' => $status,
                'check_remark' => $remark,
                'check_time' => time(),
            ];
            $result = $this->model->save($data, ['distrt_id' => $info['distrt_id']]);
            if ($result !== FALSE) {
                $informModel = new \app\common\model\LogInform();
                $info['check_status_text'] = $checkStatus > 0 ? '已通过': '未通过';
                $informModel->sendInform($info['factory_id'], 'wechat', ['udata_id' => $info['udata_id']], 'user_check_result', $info);
                if ($checkStatus > 0 && $info['parent_id']) {
                    $where = [
                        ['distrt_id', '=', $info['parent_id']],
                        ['is_del', '=', 0],
                    ];
                    $parentUdataId = $this->model->where($where)->value('udata_id');
                    if ($parentUdataId) {
                        $informModel->sendInform($info['factory_id'], 'wechat', ['udata_id' => $parentUdataId], 'user_check_parent_result', $info);
                    }
                }
                $this->success('操作成功', url('index', ['status' => $status]));
            }else{
                $this->error('操作失败');
            }
        }else{
            $this->assign('info', $info);
            return $this->fetch();
        }
    }
    function _afterList($list)
    {
        if ($list) {
            foreach ($list as $key => $value) {
                if ($value['parent_id']) {
                    $where = [
                        ['distrt_id', '=', $value['parent_id']],
                        ['is_del', '=', 0],
                    ];
                    $list[$key]['parent_name'] = $this->model->where($where)->value('realname');
                }else{
                    $list[$key]['parent_name'] = '-';
                }
                
            }
        }
        return $list;
    }
    function _afterDel($info = [])
    {
        if ($info) {
            $result = $this->model->save(['parent_id' => 0], ['parent_id' => $info['distrt_id']]);
        }
        return TRUE;
    }
    
    function _assignInfo($pkId = 0)
    {
        $info = parent::_assignInfo($pkId);
        if ($info && $info['factory_id'] != $this->adminFactory['store_id']){
            $this->error('NO ACCESS');
        }
        return $info;
    }
    
    function _getWhere()
    {
        $where = parent::_getWhere();
        $where[] = ['factory_id', '=', $this->adminFactory['store_id']];
        return $where;
    }
    function _getData()
    {
        $data = parent::_getData();
        $realname = isset($data['realname']) ?trim($data['realname']) : '';
        $phone = isset($data['phone']) ?trim($data['phone']) : '';
        if (!$realname) {
            $this->error('分销员姓名不能为空');
        }
        if (!$phone) {
            $this->error('分销员手机号码不能为空');
        }
        if (!check_mobile($phone)) {
            $this->error('手机号格式错误');
        }
        //判断手机号是否已存在
        $where = [
            ['is_del', '=', 0],
            ['phone', '=', $phone],
            ['factory_id', '=', $this->adminFactory['store_id']],
        ];
        $id = $this->request->param('id', 0, 'intval');
        if ($id) {
            $where[] = ['distrt_id', '<>', $id];
        }
        $exist = $this->model->where($where)->find();
        if ($exist) {
            $this->error('手机号已存在');
        }
        return $data;
    }
    function _getOrder()
    {
        return 'add_time DESC';
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = parent::_tableData();
        if ($table['actions']['button']) {
            $table['actions']['button'][] = ['text'  => '审核','action'=> 'condition', 'icon'  => 'check','bgClass'=> 'bg-yellow','condition'=>['action'=>'check','rule'=>' $vo["check_status"] == 0']];
            $table['actions']['width']  = '*';
        }
        return $table;
    }
}