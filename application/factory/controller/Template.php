<?php
namespace app\factory\controller;
class Template extends FactoryForm
{
    public function __construct()
    {
        $this->modelName = 'template_config';
        $this->model = model($this->modelName);
        parent::__construct();
        if (!in_array($this->adminUser['admin_type'], [ADMIN_FACTORY])){
            $this->error(lang('NO ACCESS'));
        }
    }
    public function index(){
        $where = [
            ['action_type', '=', 'pay_success'],
            ['tpl_type', '=', 'wechat_notice'],
            ['is_del', '=', 0],
            ['store_id', '=', $this->adminFactory['store_id']],
        ];
        $info = $this->model->where($where)->find();
        if (!$info) {
            $this->error('数据库参数错误');
        }
        if (IS_POST) {
            $params = $this->request->post();
            if (!$params) {
                $this->error('参数异常');
            }
            $code = isset($params['tpl_code']) ? trim($params['tpl_code']) : '';
            $title = isset($params['title']) ? trim($params['title']) : '';
            $description = isset($params['description']) ? trim($params['description']) : '';
            if (!$code) {
                $this->error('模板ID不能为空');
            }
            if (!$title) {
                $this->error('通知标题不能为空');
            }
            if (!$description) {
                $this->error('通知描述不能为空');
            }
            $data = [
                'tpl_code' => $code,
                'title' => $title,
                'description' => $description,
            ];
            $result = $this->model->save($data, ['config_id' => $info['config_id']]);
            if ($result === FALSE) {
                $this->error($this->model->error);
            }
            $this->success('模板配置成功');
        }else{
            $this->assign('info', $info);
        }
        return $this->fetch();
    }
}