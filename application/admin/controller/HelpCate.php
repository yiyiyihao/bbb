<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/1/29 0029
 * Time: 14:17
 */

namespace app\admin\controller;


class HelpCate extends AdminForm
{
    public function __construct()
    {
        $this->modelName = '问题分类';
        $this->model = model('helpCate');
        parent::__construct();

    }


    //删除下级元素
    public function _afterDel($info = [])
    {
        model('help')->where([
            'cate_id' => $info['id'],
            'is_del' => 0,
        ])->update(['is_del' => 1, 'update_time' => time()]);
    }

    public function _afterAdd($pkId=0, $data=[])
    {
        $this->success('分类添加成功', url("help/index"));

    }

}