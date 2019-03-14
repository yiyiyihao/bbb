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
        'remark.require'      => '备注信息不能为空',
        'remark.max'          => '备注信息最多80个字符',
        'remark.chsAlphaNum'  => '备注信息只能汉字、字母和数字',
        'msg.max'             => '评价内容不能超过100个字符',
        'score.number'        => '非法请求',
    ];

    protected function num_code($value, $rule, $data = [])
    {
        $rule = preg_match('/^\d{8,50}$/', $value) ? true : false;
        return $rule;
    }

    protected function user_name($value, $rule, $data = [])
    {
        $pattern = '/^[^0-9][\x{4e00}-\x{9fa5}a-zA-Z0-9_]+$/u';
        $rule = preg_match($pattern, $value) ? true : false;
        return $rule;
    }

    protected function chs_space($value, $rule, $data = [])
    {
        $pattern = '/[\x{4e00}-\x{9fa5}\s]+$/u';
        $rule = preg_match($pattern, $value) ? true : false;
        return $rule;
    }


    //工单列表
    public function sceneList()
    {
        return $this->only(['phone', 'type', 'status', 'job_no', 'keyword'])
            ->append('phone', 'mobile|require')
            ->append('type', 'number|in:0,1,2')
            ->append('status', 'number|between:-1,4')
            ->append('job_no', 'num_code')
            ->append('keyword', 'chsAlphaNum');

    }


    //工单详情 验证场景定义
    public function sceneDetail()
    {
        return $this->only(['phone', 'worder_sn'])
            ->append('phone', 'mobile|require')
            ->append('worder_sn', 'require|num_code');
    }

    //取消工单
    public function sceneCancel()
    {
        return $this->only(['phone', 'worder_sn', 'remark'])
            ->append('phone', 'mobile|require')
            ->append('worder_sn', 'require|num_code')
            ->append('remark', 'require|chsAlphaNum|max:80');
    }

    //工单评价
    public function sceneAssess()
    {
        return $this->only(['phone', 'type', 'msg', 'score'])
            ->append('phone', 'mobile|require')
            ->append('worder_sn', 'require|num_code')
            ->append('type', 'require|in:1,2')
            ->append('msg', 'max:100');
    }

    //工单评分配置
    public function sceneAssessConfig()
    {
        return $this->only(['phone'])
            ->append('phone', 'mobile|require');
    }

    //提交维修工单
    public function sceneAdd()
    {
        return $this->only(['phone','goods_id','user_name','user_mobile','region_id','region_name','address','appointment','fault_desc'])
            ->append('phone', 'mobile|require')
            ->append('goods_id|商品ID', 'require|integer')
            ->append('user_name|客户姓名', 'require|chsAlpha|min:2|max:20')
            ->append('user_mobile|客户手机号', 'require|mobile')
            ->append('region_id|服务区域编号', 'require|integer')
            ->append('region_name|服务区域名', 'require|chs_space')
            ->append('address|安装地址', 'require|chsDash')
            ->append('appointment|预约时间', 'require|date|after:' . date('Y-m-d'))
            ->append('fault_desc|故障描述信息', 'require|max:120');
    }

    //获取可维修商列表
    public function sceneGoods()
    {
        return $this->only(['phone'])
            ->append('phone', 'mobile|require');
    }

}
