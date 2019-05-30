<?php

namespace app\factory\controller;

use app\common\model\StoreUser as StoreUserModel;
use think\Request;

class StoreUser extends FactoryForm
{
    public function __construct()
    {
        $this->modelName = 'store_user';
        $this->model = new  StoreUserModel();
        parent::__construct();
    }

    function _getAlias()
    {
        return 'SU';
    }

    function _getField()
    {
        return 'SU.*';
    }

    function _getWhere()
    {
        $realname = $this->request->param('realname', '', 'trim');
        $mobile = $this->request->param('mobile', '', 'trim');
        $userType = $this->request->param('user_type', '-1', 'intval');
        $where = [
            'SU.store_id' => $this->adminUser['store_id']
        ];
        if ('' === $realname) {
            $where['SU.realname'] = ['LIKE', '%' . $realname . '%'];
        }
        if ('' !== $mobile) {
            if (check_mobile($mobile)) {
                $where['SU.mobile'] = $mobile;
            } else {
                $where['SU.mobile'] = ['LIKE', '%' . $mobile . '%'];
            }
        }
        if ($userType != -1 && in_array($userType, array_keys(get_user_type()))) {
            $where['SU.user_type'] = $userType;
        }
        return $where;
    }

    function _assignInfo($pkId = 0)
    {
        $info = parent::_assignInfo($pkId);
        if ($info) {
            $info['img_url'] = db('goods')->where('goods_id', $info['goods_id'])->value('thumb');
        }
        $this->assign("info", $info);
        return $info;
    }

    function _getJoin()
    {
        $where = [
            ['goods G', 'SU.goods_id=G.goods_id AND G.is_del=0', 'LEFT']
        ];
        return $where;
    }

    public function _getData()
    {
        $data = parent::_getData();
        if ($this->request->isPost()) {
            $dealCloseTime = $this->request->param('deal_close_time', '', 'strtotime');
            if ($dealCloseTime && $dealCloseTime < time()) {
                $this->error('预计成交时间不能早当前时间');
            }
            if ($dealCloseTime) {
                $data['deal_close_time'] = $dealCloseTime;
            }
            $mobile = $this->request->param('mobile', '', 'trim');
            $realname = $this->request->param('realname', '', 'trim');
            if (!$realname) {
                $this->error('用户名不能为空');
            }
            if (!$mobile) {
                $this->error('手机号不能为空');
            }
            if (!check_mobile($mobile)) {
                $this->error('用户手机号码格式不正确');
            }
            if ($this->request->action() == 'add') {
                $exist = $this->model->where([
                    'is_del' => 0,
                    'mobile' => $mobile,
                ])->find();
                if (!empty($exist)) {
                    $this->error('用户手机号码已经存在');
                }
            }
            //是否成交客户
            $exist = db('work_order')->where([
                'is_del'        => 0,
                'phone'         => $mobile,
                'post_store_id' => $this->adminUser['store_id'],
            ])->find();
            $data['user_type'] = 0;
            if ($exist) {
                $data['user_type'] = 1;
            }
        }
        $data['store_id'] = $this->adminUser['store_id'];
        return $data;
    }

    function _afterList($list)
    {
        foreach ($list as $k => $v) {
            $list[$k]['address'] = $v['region_name'] . $v['address'];
        }
        return $list;
    }

    public function detail(Request $request)
    {
        $id = $request->param('id');
        $result = $this->model->getStoreUser($id, $this->adminUser);
        if ($result['code'] !== '0') {
            $this->error($result);
        }
        //p($result);
        $this->assign('detail', $result['data']);
        return $this->fetch();
    }



    //function _fieldData(){
    //    $field = [
    //        ['title'=>lang($this->modelName).'名称','type'=>'text','name'=>'name','size'=>'40','datatype'=>'*','default'=>'','notetext'=>lang($this->modelName).'名称请不要填写特殊字符'],
    //        ['title'=>lang($this->modelName).'联系人姓名','type'=>'text','name'=>'user_name','size'=>'20','datatype'=>'*','default'=>'','notetext'=>'请填写'.lang($this->modelName).'联系人姓名'],
    //        ['title'=>lang($this->modelName).'联系电话','type'=>'text','name'=>'mobile','size'=>'20','datatype'=>'*','default'=>'','notetext'=>'请填写'.lang($this->modelName).'联系电话'],
    //    ];
    //    return array_filter($field);
    //}

    /**
     * 列表搜索配置
     */
    function _searchData()
    {
        $userType = get_user_type();
        $this->assign('user_type', $userType);
        $search = [
            ['type' => 'input', 'name' => 'realname', 'value' => '商户名称', 'width' => '30'],
            ['type' => 'input', 'name' => 'mobile', 'value' => '联系人电话', 'width' => '30'],
            ['type' => 'select', 'name' => 'user_type', 'options' => 'user_type', 'default_option' => '全部类型', 'default' => '-1'],
        ];
        return $search;
    }

    /**
     * 列表项配置
     */
    function _tableData()
    {
        $table = parent::_tableData();
        if ($table['actions']['button']) {
            array_unshift($table['actions']['button'],
                ['text' => '详情', 'action' => 'detail', 'icon' => 'detail', 'bgClass' => 'bg-green']
            );
            $table['actions']['width'] = '220';
        }
        return $table;
    }


}