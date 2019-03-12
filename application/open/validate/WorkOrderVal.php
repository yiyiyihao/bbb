<?php

namespace app\open\validate;

use think\Validate;

class WorkOrderVal extends Validate
{
    /**
     * 定义验证规则
     * 格式：'字段名'    =>    ['规则1','规则2'...]
     *
     * @var array
     */
    protected $rule = [
        'store_no'  => 'require|num_code',
        'worder_sn' => 'num_code',
    ];

    /**
     * 定义错误信息
     * 格式：'字段名.规则名'    =>    '错误信息'
     *
     * @var array
     */
    protected $message = [
        'store_no.require'    => '商户编号不能为空',
        'store_no.num_code'   => '商户编号不正确',
        'worder_sn.require'   => '工单号不能为空',
        'worder_sn.num_code'  => '工单号不正确',
        'type.number'         => '非法参数请求',
        'type.in'             => '请求参数无数',
        'status.number'       => '非法参数请求',
        'status.in'           => '请求参数无数',
        'job_no.num_code'     => '工程师工号错误',
        'keyword.chsAlphaNum' => '请输入汉字、英文或数字',
        'phone.require'       => '手机号码不能为空',
        'phone.mobile'        => '手机号码格式不正确',
    ];

    protected function num_code($value, $rule, $data = [])
    {
        $rule = preg_match('/^\d{4,}$/', $value) ? true : false;
        return $rule;
    }

    public function sceneList()
    {
        return $this->only(['phone', 'type', 'status', 'job_no', 'keyword'])
            ->append('phone', 'mobile|require')
            ->append('type', 'number|in:0,1,2')
            ->append('status', 'number|between:-1,4')
            ->append('job_no', 'num_code')
            ->append('keyword', 'chsAlphaNum');

    }


    // 详情 验证场景定义
    public function sceneDetail()
    {
        return $this->only(['phone', 'worder_sn'])
            ->append('phone', 'mobile|require')
            ->append('worder_sn', 'require|num_code');
    }

}
