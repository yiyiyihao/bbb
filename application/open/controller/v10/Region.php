<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/3/14 0014
 * Time: 19:26
 */

namespace app\open\controller\v10;


use app\open\controller\Base;
use app\open\validate\WorkOrderVal;
use think\Request;

class Region extends Base
{
    //获得地区列表
    public function index(Request $request)
    {
        $check = new WorkOrderVal();
        if (!$check->scene('region')->check($request->param())) {
            return $this->dataReturn(100100, $check->getError());
        }
        $id = $request->param('id', 1, 'intval');
        $model = db('region');
        $data = $model->field('region_id id,region_name name')->where([
            'is_del'    => 0,
            'parent_id' => $id > 0 ? $id : 1,
        ])->order('sort_order')->select();
        return $this->dataReturn(0, 'ok', $data);
    }

}