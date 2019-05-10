<?php
namespace app\factory\controller;
//售后工单管理
use app\common\model\ConfigForm;
use app\common\model\ConfigFormLogs;
use app\common\model\GoodsCate;
use think\Request;

class Workorder extends FactoryForm
{
    var $types;
    var $type = 1;
    var $statusList;
    var $orderTypes;
    private $orgInfo;
    private $workAddConf;
    public function __construct()
    {
        $this->modelName = 'work_order';
        $this->model = new \app\common\model\WorkOrder();
        $this->orderTypes = get_work_order_type();
        parent::__construct();
        if (strtolower($this->request->action()) != 'index') {
            $this->type = 2;
            $this->subMenu['menu']['0'] = [
                'name' => '全部',
                'url' => url('lists'),
            ];
            $action = 'lists';
        }else{
            $this->subMenu['menu']['0']['name'] = '全部';
            $action = 'index';
        }
        $this->subMenu['showmenu'] = true;
        $this->statusList = get_work_order_status();
        foreach ($this->statusList as $key => $value) {
            $this->subMenu['menu'][] = ['name'  => lang($value),'url'   => url($action, ['status' => $key])];
        }
        unset($this->subMenu['add']);
        $this->assign('orderTypes', $this->orderTypes);
        $this->assign('type', $this->type);
        
        if (in_array($this->adminUser['group_id'],[GROUP_E_CHANGSHANG_KEFU,GROUP_E_COMMERCE_KEFU])) {
            $this->subMenu['add'] = [
                'name' => '新增工单',
                'url' => url("kefu_order"),
            ];
        }
    }
    //维修工单
    public function lists()
    {
        $this->indextempfile = 'index';
        if (in_array($this->adminUser['group_id'],[GROUP_E_CHANGSHANG_KEFU,GROUP_E_COMMERCE_KEFU])) {
            $this->assign('add_url',url('kefu_order',['type'=>2]));
        }
        return $this->index();
    }


    private function getCate()
    {
        //商品分类
        $storeId = $this->adminStore['store_id'];
        $treeService = new \app\common\service\Tree();
        $where = ['is_del' => 0, 'store_id' => $storeId];
        $categorys = db('goods_cate')->field("cate_id, name, parent_id, sort_order,name as cname, status")->where($where)->order("sort_order ASC, parent_id")->select();
        if ($categorys) {
            $categorys = $treeService->getTree($categorys);
        }
        $this->assign('cates', $categorys);
    }

    /**
     * 安装工单配置
     */
    public function install_config()
    {
        $this->getCate();
        $this->subMenu['showmenu'] = false;
        return $this->fetch();
    }

    /**
     * 维修工单配置
     */
    public function repair_config()
    {
        $this->getCate();
        $this->subMenu['showmenu'] = false;
        return $this->fetch();
    }


    public function config_handle(Request $request)
    {
        if (!$request->isPost()) {
            return json(dataFormat(1, '非法请求'));
        }
        $this->installAddConfig();
        $this->installerConfirm();
        $this->installUserConfirm();
        $this->installerAssess();
        $this->repairmanConfirm();
        $this->repairUserConfirm();
        $this->repairAssess();
        $this->success('配置成功');
        //return json(dataFormat(0, '配置保存成功'));

    }

    /**
     * 工程师安装前填写安装确认表单
     */
    private function installerConfirm()
    {
        $item=2;
        $cateId=$this->request->param('cate_id'.$item,0,'intval');
        $factoryId = $this->adminUser['factory_id'];
        if (!$cateId) {
            return false;
        }
        $cate=GoodsCate::where([
            'store_id'=> $factoryId,
            'is_del'=>0,
        ])->find($cateId);
        if (empty($cate)) {
            $this->error('该商品分类不存在或已删除');
        }
        $key = 'installer_confirm_' . $cateId;
        $configId=$this->request->param('config_id'.$item,[],'intval');
        $configIdExist=array_unique(array_filter($configId));
        //删除冗余的字段
        ConfigForm::where([
            'id'       => ['NOT IN', $configIdExist],
            'is_del'   => 0,
            'store_id' => $factoryId,
            'key'      => $key,
        ])->update(['is_del' => 1]);
        $names=$this->request->param('name'.$item);
        $isRequired=$this->request->param('is_required'.$item,1,'intval');
        $types=$this->request->param('type'.$item,1,'intval');
        $sortOrders=$this->request->param('sort_order'.$item,1,'intval');
        $optValues=$this->request->param('value'.$item);
        if (!empty($names)) {
            foreach ($names as $k=>$name ) {
                $data = [];
                $where = [];
                if (isset($types[$k]) && in_array($types[$k],[2,3,4]) && (!isset($optValues[$k]) ||empty($optValues[$k]))) {
                    return $this->error('第'.($k+1).'行<b class="text-red">"'.$name.'"</b>类型为<b class="text-red">列表</b>时，列表选项不能为空');
                }
                if (isset($configId[$k]) && $configId[$k]) {//配置已存在则更新
                    $data = [
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                    $where = [
                        'key'      => $key,
                        'is_del'   => 0,
                        'store_id' => $factoryId,
                        'id'       => $configId[$k]
                    ];
                } else {//配置不存在则直接新增
                    $data = [
                        'store_id'    => $factoryId,
                        'key'         => $key,
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                }
                $result = (new ConfigForm())->save($data, $where);
            }
        }
    }

    /**
     * 用户填写安装确认表单
     */
    private function installUserConfirm()
    {
        $item=3;
        $cateId=$this->request->param('cate_id'.$item,0,'intval');
        $factoryId = $this->adminUser['factory_id'];
        if (!$cateId) {
            return false;
        }
        $cate=GoodsCate::where([
            'store_id'=> $factoryId,
            'is_del'=>0,
        ])->find($cateId);
        if (empty($cate)) {
            $this->error('该商品分类不存在或已删除');
        }
        $key = 'install_user_confirm_' . $cateId;
        $configId=$this->request->param('config_id'.$item,[],'intval');
        $configIdExist=array_unique(array_filter($configId));
        //删除冗余的字段
        ConfigForm::where([
            'id'       => ['NOT IN', $configIdExist],
            'is_del'   => 0,
            'store_id' => $factoryId,
            'key'      => $key,
        ])->update(['is_del' => 1]);
        $names=$this->request->param('name'.$item);
        $isRequired=$this->request->param('is_required'.$item,1,'intval');
        $types=$this->request->param('type'.$item,1,'intval');
        $sortOrders=$this->request->param('sort_order'.$item,1,'intval');
        $optValues=$this->request->param('value'.$item);
        if (!empty($names)) {
            foreach ($names as $k=>$name ) {
                $data = [];
                $where = [];
                if (isset($types[$k]) && in_array($types[$k],[2,3,4]) && (!isset($optValues[$k]) ||empty($optValues[$k]))) {
                    return $this->error('第'.($k+1).'行<b class="text-red">"'.$name.'"</b>类型为<b class="text-red">列表</b>时，列表选项不能为空');
                }
                if (isset($configId[$k]) && $configId[$k]) {//配置已存在则更新
                    $data = [
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                    $where = [
                        'key'      => $key,
                        'is_del'   => 0,
                        'store_id' => $factoryId,
                        'id'       => $configId[$k]
                    ];
                } else {//配置不存在则直接新增
                    $data = [
                        'store_id'    => $factoryId,
                        'key'         => $key,
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                }
                $result = (new ConfigForm())->save($data, $where);
            }
        }
    }

    /**
     * 工程师安装评价
     */
    private function installerAssess()
    {
        $item=4;
        $cateId=$this->request->param('cate_id'.$item,0,'intval');
        $factoryId = $this->adminUser['factory_id'];
        if (!$cateId) {
            return false;
        }
        $cate=GoodsCate::where([
            'store_id'=> $factoryId,
            'is_del'=>0,
        ])->find($cateId);
        if (empty($cate)) {
            $this->error('该商品分类不存在或已删除');
        }
        $key = 'installer_assess_' . $cateId;
        $configId=$this->request->param('config_id'.$item,[],'intval');
        $configIdExist=array_unique(array_filter($configId));
        //删除冗余的字段
        ConfigForm::where([
            'id'       => ['NOT IN', $configIdExist],
            'is_del'   => 0,
            'store_id' => $factoryId,
            'key'      => $key,
        ])->update(['is_del' => 1]);
        $names=$this->request->param('name'.$item);
        $isRequired=$this->request->param('is_required'.$item,1,'intval');
        $types=$this->request->param('type'.$item,1,'intval');
        $sortOrders=$this->request->param('sort_order'.$item,1,'intval');
        $optValues=$this->request->param('value'.$item);
        if (!empty($names)) {
            foreach ($names as $k=>$name ) {
                $data = [];
                $where = [];
                if (isset($types[$k]) && in_array($types[$k],[2,3,4]) && (!isset($optValues[$k]) ||empty($optValues[$k]))) {
                    return $this->error('第'.($k+1).'行<b class="text-red">"'.$name.'"</b>类型为<b class="text-red">列表</b>时，列表选项不能为空');
                }
                if (isset($configId[$k]) && $configId[$k]) {//配置已存在则更新
                    $data = [
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                    $where = [
                        'key'      => $key,
                        'is_del'   => 0,
                        'store_id' => $factoryId,
                        'id'       => $configId[$k]
                    ];
                } else {//配置不存在则直接新增
                    $data = [
                        'store_id'    => $factoryId,
                        'key'         => $key,
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                }
                $result = (new ConfigForm())->save($data, $where);
            }
        }
    }

    /**
     * 工程师维修确认表单
     */
    private function repairmanConfirm()
    {
        $item=21;
        $cateId=$this->request->param('cate_id'.$item,0,'intval');
        $factoryId = $this->adminUser['factory_id'];
        if (!$cateId) {
            return false;
        }
        $cate=GoodsCate::where([
            'store_id'=> $factoryId,
            'is_del'=>0,
        ])->find($cateId);
        if (empty($cate)) {
            $this->error('该商品分类不存在或已删除');
        }
        $key = 'repairman_confirm_' . $cateId;
        $configId=$this->request->param('config_id'.$item,[],'intval');
        $configIdExist=array_unique(array_filter($configId));
        //删除冗余的字段
        ConfigForm::where([
            'id'       => ['NOT IN', $configIdExist],
            'is_del'   => 0,
            'store_id' => $factoryId,
            'key'      => $key,
        ])->update(['is_del' => 1]);
        $names=$this->request->param('name'.$item);
        $isRequired=$this->request->param('is_required'.$item,1,'intval');
        $types=$this->request->param('type'.$item,1,'intval');
        $sortOrders=$this->request->param('sort_order'.$item,1,'intval');
        $optValues=$this->request->param('value'.$item);
        if (!empty($names)) {
            foreach ($names as $k=>$name ) {
                $data = [];
                $where = [];
                if (isset($types[$k]) && in_array($types[$k],[2,3,4]) && (!isset($optValues[$k]) ||empty($optValues[$k]))) {
                    return $this->error('第'.($k+1).'行<b class="text-red">"'.$name.'"</b>类型为<b class="text-red">列表</b>时，列表选项不能为空');
                }
                if (isset($configId[$k]) && $configId[$k]) {//配置已存在则更新
                    $data = [
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                    $where = [
                        'key'      => $key,
                        'is_del'   => 0,
                        'store_id' => $factoryId,
                        'id'       => $configId[$k]
                    ];
                } else {//配置不存在则直接新增
                    $data = [
                        'store_id'    => $factoryId,
                        'key'         => $key,
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                }
                $result = (new ConfigForm())->save($data, $where);
            }
        }
    }

    /**
     * 用户维修确认表单
     */
    private function repairUserConfirm()
    {
        $item=22;
        $cateId=$this->request->param('cate_id'.$item,0,'intval');
        $factoryId = $this->adminUser['factory_id'];
        if (!$cateId) {
            return false;
        }
        $cate=GoodsCate::where([
            'store_id'=> $factoryId,
            'is_del'=>0,
        ])->find($cateId);
        if (empty($cate)) {
            $this->error('该商品分类不存在或已删除');
        }
        $key = 'repair_user_confirm_' . $cateId;
        $configId=$this->request->param('config_id'.$item,[],'intval');
        $configIdExist=array_unique(array_filter($configId));
        //删除冗余的字段
        ConfigForm::where([
            'id'       => ['NOT IN', $configIdExist],
            'is_del'   => 0,
            'store_id' => $factoryId,
            'key'      => $key,
        ])->update(['is_del' => 1]);
        $names=$this->request->param('name'.$item);
        $isRequired=$this->request->param('is_required'.$item,1,'intval');
        $types=$this->request->param('type'.$item,1,'intval');
        $sortOrders=$this->request->param('sort_order'.$item,1,'intval');
        $optValues=$this->request->param('value'.$item);
        if (!empty($names)) {
            foreach ($names as $k=>$name ) {
                $data = [];
                $where = [];
                if (isset($types[$k]) && in_array($types[$k],[2,3,4]) && (!isset($optValues[$k]) ||empty($optValues[$k]))) {
                    return $this->error('第'.($k+1).'行<b class="text-red">"'.$name.'"</b>类型为<b class="text-red">列表</b>时，列表选项不能为空');
                }
                if (isset($configId[$k]) && $configId[$k]) {//配置已存在则更新
                    $data = [
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                    $where = [
                        'key'      => $key,
                        'is_del'   => 0,
                        'store_id' => $factoryId,
                        'id'       => $configId[$k]
                    ];
                } else {//配置不存在则直接新增
                    $data = [
                        'store_id'    => $factoryId,
                        'key'         => $key,
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                }
                $result = (new ConfigForm())->save($data, $where);
            }
        }
    }

    /**
     * 用户维修评价表单
     */
    private function repairAssess()
    {
        $item=23;
        $cateId=$this->request->param('cate_id'.$item,0,'intval');
        $factoryId = $this->adminUser['factory_id'];
        if (!$cateId) {
            return false;
        }
        $cate=GoodsCate::where([
            'store_id'=> $factoryId,
            'is_del'=>0,
        ])->find($cateId);
        if (empty($cate)) {
            $this->error('该商品分类不存在或已删除');
        }
        $key = 'repair_assess_' . $cateId;
        $configId=$this->request->param('config_id'.$item,[],'intval');
        $configIdExist=array_unique(array_filter($configId));
        //删除冗余的字段
        ConfigForm::where([
            'id'       => ['NOT IN', $configIdExist],
            'is_del'   => 0,
            'store_id' => $factoryId,
            'key'      => $key,
        ])->update(['is_del' => 1]);
        $names=$this->request->param('name'.$item);
        $isRequired=$this->request->param('is_required'.$item,1,'intval');
        $types=$this->request->param('type'.$item,1,'intval');
        $sortOrders=$this->request->param('sort_order'.$item,1,'intval');
        $optValues=$this->request->param('value'.$item);
        if (!empty($names)) {
            foreach ($names as $k=>$name ) {
                $data = [];
                $where = [];
                if (isset($types[$k]) && in_array($types[$k],[2,3,4]) && (!isset($optValues[$k]) ||empty($optValues[$k]))) {
                    return $this->error('第'.($k+1).'行<b class="text-red">"'.$name.'"</b>类型为<b class="text-red">列表</b>时，列表选项不能为空');
                }
                if (isset($configId[$k]) && $configId[$k]) {//配置已存在则更新
                    $data = [
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                    $where = [
                        'key'      => $key,
                        'is_del'   => 0,
                        'store_id' => $factoryId,
                        'id'       => $configId[$k]
                    ];
                } else {//配置不存在则直接新增
                    $data = [
                        'store_id'    => $factoryId,
                        'key'         => $key,
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                }
                $result = (new ConfigForm())->save($data, $where);
            }
        }
    }


    /**
     * 安装工单添加时配置
     */
    private function installAddConfig()
    {
        $item=1;
        $cateId=$this->request->param('cate_id'.$item,0,'intval');
        $factoryId = $this->adminUser['factory_id'];
        if (!$cateId) {
            return false;
        }
        $cate=GoodsCate::where([
            'store_id'=> $factoryId,
            'is_del'=>0,
        ])->find($cateId);
        if (empty($cate)) {
            $this->error('该商品分类不存在或已删除');
        }
        $key = 'work_order_install_add_' . $cateId;
        $configId=$this->request->param('config_id'.$item,[],'intval');
        $configIdExist=array_unique(array_filter($configId));
        //删除冗余的字段
        ConfigForm::where([
            'id'       => ['NOT IN', $configIdExist],
            'is_del'   => 0,
            'store_id' => $factoryId,
            'key'      => $key,
        ])->update(['is_del' => 1]);
        $names=$this->request->param('name'.$item);
        $isRequired=$this->request->param('is_required'.$item,1,'intval');
        $types=$this->request->param('type'.$item,1,'intval');
        $sortOrders=$this->request->param('sort_order'.$item,1,'intval');
        $optValues=$this->request->param('value'.$item);
        if (!empty($names)) {
            foreach ($names as $k=>$name ) {
                $data = [];
                $where = [];
                if (isset($types[$k]) && in_array($types[$k],[2,3,4]) && (!isset($optValues[$k]) ||empty($optValues[$k]))) {
                    return $this->error('第'.($k+1).'行<b class="text-red">"'.$name.'"</b>类型为<b class="text-red">列表</b>时，列表选项不能为空');
                }
                if (isset($configId[$k]) && $configId[$k]) {//配置已存在则更新
                    $data = [
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                    $where = [
                        'key'      => $key,
                        'is_del'   => 0,
                        'store_id' => $factoryId,
                        'id'       => $configId[$k]
                    ];
                } else {//配置不存在则直接新增
                    $data = [
                        'store_id'    => $factoryId,
                        'key'         => $key,
                        'name'        => $name,
                        'is_required' => isset($isRequired[$k]) ? intval($isRequired[$k]) : 0,
                        'type'        => isset($types[$k]) ? intval($types[$k]) : 0,
                        'value'       => isset($optValues[$k]) ? json_encode($optValues[$k]) : '',
                        'sort_order'  => isset($sortOrders[$k]) ? intval($sortOrders[$k]) : 0,
                    ];
                }
                $result = (new ConfigForm())->save($data, $where);
            }
        }
        
    }





    public function getCateConf()
    {
        $key=$this->request->param('key');
        $cateId=$this->request->param('cate_id');
        if (empty($key) || empty($cateId)) {
            return json(dataFormat(1, '请选择商品分类'));
        }
        $result = ConfigForm::where([
            'store_id' => $this->adminUser['factory_id'],
            'key'      => $key.'_'.$cateId,
            'is_del'   => 0,
        ])->order('sort_order ASC,id ASC')->select();
        if ($result->isEmpty()) {
            return json(dataFormat(2, '暂无数据'));
        }
        return json(dataFormat(0, 'ok', $result));
    }
    
    public function _afterList($list){
        if ($list && $this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $now=time();
            foreach ($list as $key => $value) {
                $exist = [];
                if ($value['work_order_type'] == 1 && $value['work_order_status'] == 4) {
                    //判断安装工单是否存在维修中的记录
                    $exist = $this->model->where(['parent_id' => $value['worder_id'], 'work_order_type' => 2, 'work_order_status' => ['<>', -1]])->find();
                }
                $list[$key]['fix_id'] = isset($exist) && $exist ? $exist['worder_id']: 0;
                //判断当前工单是否有首次评价和追加评价
                $exist = db('work_order_assess')->field('count(if(type = 1, true, NULL)) as type1, count(if(type = 2, true, NULL)) as type2')->where(['worder_id' => $value['worder_id']])->find();
                $list[$key]['first_assess'] = $exist && isset($exist['type1']) && $exist['type1'] > 0  ? 1 : 0;
                $list[$key]['append_assess'] = $exist && isset($exist['type2']) && $exist['type2'] > 0  ? 1 : 0;
            }
        }
        return $list;
    }

    //客服工单
    public function kefu_order(Request $request)
    {
        $this->subMenu['showmenu'] = false;
        $step = $this->request->param('step',1,'intval');
        if ($step == 1) {//显示商品列表
            $where = [
                'is_del'   => 0,
                'status'   => 1,
                'store_id' => $this->adminUser['factory_id'],
            ];
            $order = 'G.add_time DESC';
            $list = db('goods')
                ->alias('G')
                ->where($where)
                ->order($order)
                ->paginate($this->perPage, false, ['query' => input('param.')]);
            $page = $list->render();
            $list = $list->toArray()['data'];
            $this->assign('page', $page);
            $this->assign('list', $list);
            return $this->fetch('goods');
        }
        if ($step == 2) {//选择商品规格
            $goodsId=$this->request->param('id',0,'intval');
            if (empty($goodsId)) {
                $this->error('请选选择商品');
            }
            $info = db('goods')->where([
                'is_del'   => 0,
                'status'   => 1,
                'store_id' => $this->adminUser['factory_id'],
            ])->find($goodsId);
            $skuinfo = db('goods_sku')->where(['goods_id' => $goodsId, 'is_del' => 0, 'status' => 1, 'spec_json' => ['neq', ""]])->find();
            $info['skuinfo'] = $skuinfo;
            $info['imgnum'] = isset($info['imgs']) && $info['imgs'] ? count(json_decode($info['imgs'])) : 0;
            $info['imgs'] = isset($info['imgs']) && $info['imgs'] ? json_decode($info['imgs'], TRUE) : [];
            $skus =model('goods')->getGoodsSkus($goodsId,$this->adminStore,false);
            $price=array_column($skus,'price_total');
            $min=min($price);
            $max=max($price);
            $priceTotal=$min;
            if ($max > $min) {
                $priceTotal.='~'.$max;
            }
            $this->assign('price_total',$priceTotal);
            $this->assign('skus', is_array($skus) ? $skus : []);
            $info['default_sku_id'] = isset($skus[0]['sku_id'])? $skus[0]['sku_id']:0;
            $info['specs'] = json_decode($info['specs_json'],true);
            $this->assign('info', $info);
            $this->import_resource(array(
                //'script'=> 'jquery.jqzoom-core.js',
                'style' => 'goods.css,jquery.jqzoom.css',
            ));
            $this->view->engine->layout(false);
            return $this->fetch('goods_spec');
        }
        $data['sku_id'] = $request->param('sku_id', '0', 'intval');
        if (empty($data['sku_id'])) {
            $this->error('请选择需要提交工单的商品！');
        }
        $where = [
            'sku_id' => $data['sku_id'],
            'is_del'   => 0,
        ];
        $sku = db('goods_sku')->where($where)->find();
        if (empty($sku)) {
            $this->error('查无该商品信息');
        }
        $data['goods_id']=$sku['goods_id'];
        $orderType= $request->param('work_type',1,'intval');
        $config=$this->getPostConf($data['sku_id'],$orderType);

        if (IS_POST) {
            $data['user_name'] = $request->param('user_name');
            $data['phone'] = $request->param('phone');
            $data['region_id'] = $request->param('region_id');
            $data['region_name'] = $request->param('region_name');
            $data['address'] = $request->param('address');
            $data['appointment'] = $request->param('appointment', '', 'trim,strtotime');

            $data['fault_desc'] = $request->param('fault_desc','');
            //$data['goods_id'] = $request->param('goods_id', '0', 'intval');
            $data['work_order_type'] = $orderType;
            if (!in_array($data['work_order_type'],[1,2])) {
                $this->error('请选择工单的类型！');
            }
            $data['images'] = $request->param('images','');

            if (empty($data['user_name'])) {
                $this->error('客户姓名不能为空！');
            }
            if (empty($data['phone'])) {
                $this->error('客户联系方式不能为空！');
            }
            if (empty($data['appointment'])) {
                $this->error('请选择预约的时间！');
            }
            if (empty($data['address'])) {
                $this->error('客户地址不能为空！');
            }
            if ($data['appointment']<time()) {
                $this->error('预约时间不能小于当前时间！');
            }
            $storeModel = new \app\common\model\Store();
            //根据安装地址分配服务商
            $storeId = $storeModel->getStoreFromRegion($data['region_id']);
            if (!$storeId) {
                //获取当前地址的parent_id
                $parentId = db('region')->where(['region_id' => $data['region_id']])->value('parent_id');
                if ($parentId) {
                    $storeId = $storeModel->getStoreFromRegion($parentId);
                }
                if (!$storeId) {
                    $this->error('抱歉，您选择的区域暂无服务商');
                }
            }
            $where[]=['sku_id','=',$data['sku_id']];
            $where[]=['user_name','=',$data['user_name']];
            $where[]=['phone','=',$data['phone']];
            $where[]=['work_order_type','=',$data['work_order_type']];
            $where[]=['work_order_status','>',-1];
            $where[]=['post_user_id','=',$this->adminUser['user_id']];
            $order=model('work_order')->where($where)->order('worder_id DESC')->find();
            if (!empty($order) && (time()- strtotime($order['add_time'])<60) ) {
                $this->error('操作频繁！');
            }
            $postConf=$this->request->param('post_conf');
            if ($config && empty($postConf)) {
                $this->error('请先完善表单信息');
            }
            if ($config) {
                foreach ($config as $k=>$v) {
                    if ($v['is_required']  && (!isset($postConf[$v['id']])) || $postConf[$v['id']]==='' || $postConf[$v['id']]===null ) {
                        $this->error($v['name'].'不能为空');
                        return false;
                    }
                }
            }
            $data['post_user_id'] = $this->adminUser['user_id'];
            $data['install_price'] = 0;
            $data['user_id'] = $this->adminUser['user_id'];
            $data['factory_id'] = $this->adminUser['factory_id'];
            $data['post_store_id'] = $this->adminUser['store_id'];
            $data['store_id'] = $storeId;
            if ($data['work_order_type'] == 1 && $this->adminUser['group_id'] == GROUP_E_COMMERCE_KEFU) {//电商客服提交的工单有安装费
                $data['install_price'] = $sku['install_price'];
            }
            $workOrderModel = model('work_order');
            $sn = $workOrderModel->save($data);
            if ($sn) {
                $workId = db('work_order')->where(['worder_sn' => $sn])->value('worder_id');
                if ($postConf) {
                    $postData = [];
                    foreach ($postConf as $k => $v) {
                        $postData[] = [
                            'config_form_id' => $k,
                            'worder_id'      => $workId,
                            'store_id'       => $this->adminUser['factory_id'],
                            'post_store_id'  => $this->adminUser['store_id'],
                            'post_user_id'   => $this->adminUser['user_id'],
                            'config_value'   => $v,
                        ];
                    }
                    $model = new ConfigFormLogs;
                    $result = $model->saveAll($postData);
                }
                $this->success('工单提交成功', 'index');
            } else {
                $this->error('系统错误,请稍后重试！');
            }
        }else{
            $this->subMenu['menu']=[];
            $this->assign('work_type', $orderType);
            $sku_id=$request->param('sku_id');
            $this->assign('sku_id', $sku_id);
            $this->assign('postConfig',$config);
            return $this->fetch('kefu_order');
        }
    }

    /**
     * @param $skuId
     * @param int $type
     * @return array|bool
     */
    private function getPostConf($skuId,$type=1)
    {
        $key=$type==1?'work_order_install_add_':'';
        if (empty($key)) {
            return false;
        }
        $cateId = db('goods_sku')->alias('sku')->join([
            ['goods G', 'G.goods_id=sku.goods_id'],
        ])->where([
            'sku.is_del' => 0,
            'sku.sku_id' => $skuId,
            'G.is_del'   => 0,
        ])->value('cate_id');
        if (empty($cateId)) {
            $this->error("商品规格不存在或已被删除");
        }
        $key .= $cateId;
        $config = ConfigForm::where([
            'store_id' => $this->adminUser['factory_id'],
            'key'      => $key,
            'is_del'   => 0,
        ])->order('sort_order ASC')->select();
        return $config->toArray();
    }
    
    public function edit()
    {
        $this->subMenu['showmenu'] = false;
        $info = parent::_assignInfo();
        if ($info) {
            //派单之后不允许编辑
            if ($info['work_order_status'] != 0) {
                $this->error(lang('不允许编辑'));
            }
        }
        $type = isset($info['work_order_type']) ? intval($info['work_order_type']) : 0;
        //只有渠道和零售商可以编辑安装工单
        //@updated at 04/22 2019 新服务商可以编辑预约时间
        if ($type == 1 && !in_array($this->adminUser['admin_type'], [ADMIN_CHANNEL, ADMIN_DEALER,ADMIN_SERVICE_NEW])) {
            $this->error(lang('NO ACCESS'));
        }
        //只有厂商可以编辑维修工单
        if ($type == 2 && !in_array($this->adminUser['admin_type'], [ADMIN_FACTORY,ADMIN_SERVICE_NEW])) {
            $this->error(lang('NO ACCESS'));
        }
        $this->orgInfo=$info;
        return parent::edit();
    }

    public function _afterEdit($id=0,$data=[])
    {
        $info = $this->orgInfo;
        $map = [
            'user_name'   => '客户名称',
            'phone'       => '客户电话',
            'region_name' => '客户地址',
            'address'     => '客户地址',
            'appointment' => '预约时间',
            'fault_desc'  => '备注',
            'images'      => '图片',
        ];
        $arr=[];
        foreach ($map as $k=>$v) {
            if ($data[$k] != $info[$k]) {
                if ($k=='appointment') {
                    $info[$k]=time_to_date($info[$k]);
                    $data[$k]=time_to_date($data[$k]);
                }
                $arr[]=$v.':'.$info[$k].'，修改为:'.$data[$k];
            }
        }
        $msg=implode(',',$arr);
        $this->model->worderLog($info,$this->adminUser,0,'编辑工单',$msg);
    }
    
    public function add()
    {
        $this->subMenu['showmenu'] = false;
        $params = $this->request->param();
        $type = isset($params['type']) ? intval($params['type']) : 0;
        //只有渠道、零售商、服务商,厂商客服，电商客服可以新增安装工单
        if ($type == 1 && !in_array($this->adminUser['admin_type'], [ADMIN_FACTORY,ADMIN_CHANNEL,ADMIN_SERVICE_NEW, ADMIN_DEALER])) {
            $this->error(lang('NO ACCESS'));
        }
        //只有厂商可以新增维修工单
        if ($type == 2 && !in_array($this->adminUser['admin_type'], [ADMIN_FACTORY])) {
            $this->error(lang('NO ACCESS'));
        }
        $name=$type==1?"新增安装工单":"新增维修工单";
        $this->assign('workOrderName',$name);
        return parent::add();
    }

    function _afterAdd($pkId = 0, $data = [])
    {
        $postConf=$this->request->param('post_conf');
        $config=$this->workAddConf;
        if ($config && !empty($postConf)) {
            $postData = [];
            foreach ($postConf as $k => $v) {
                $postData[] = [
                    'config_form_id' => $k,
                    'worder_id'      => $pkId,
                    'store_id'       => $this->adminUser['factory_id'],
                    'post_store_id'  => $this->adminUser['store_id'],
                    'post_user_id'   => $this->adminUser['user_id'],
                    'config_value'   => $v,
                ];
            }
            $model = new ConfigFormLogs;
            $result = $model->saveAll($postData);
        }
    }
    //指派售后工程师
    public function dispatch()
    {
        $this->subMenu['showmenu'] = false;
        if (!in_array($this->adminUser['admin_type'],[ADMIN_SERVICE,ADMIN_SERVICE_NEW])) {
            $this->error(lang('NO ACCESS'));
        }
        $info = $this->_assignInfo();
        if (IS_POST) {
            $params = $this->request->param();
            $installerId = isset($params['installer_id']) ? intval($params['installer_id']) : 0;
            if (!$installerId) {
                $this->error('请选择售后工程师');
            }
            $result = $this->model->worderDispatch($info, $this->adminUser, $installerId);
            if ($result !== FALSE) {
                //发送派单通知给工程师
                $push = new \app\common\service\PushBase();
                $sendData = [
                    'type'         => 'worker',
                    'worder_sn'    => $info['worder_sn'],
                    'worder_id'    => $info['worder_id'],
                ];
                //发送给服务商在线管理员
                $push->sendToUid(md5($installerId), json_encode($sendData));
                #TODO 发送服务通知/短信给工程师
                $this->success('售后工程师指派成功', url('index', ['type' => $info['work_order_type']]));
            }else{
                $this->error('操作失败:'.$this->model->error);
            }
        }else{
            $this->assign('info', $info);
            return $this->fetch();
        }
    }
    /**
     * 评价工单
     */
    public function assess(){
        $this->subMenu['showmenu'] = false;
        $info = $this->_assignInfo();
        if ($info['work_order_status'] != 4) {
            $this->error(lang('NO ACCESS'));
        }
        $assessType=$this->request->param('type',1,'intval');//1首次评价，2追加评价
        $scoreConfig=[];
        $assessConfig=[];
        if ($assessType == 1) {
            $ret = $this->model->getGoodsCateId($info);
            $cateId = $ret['data']['cate_id'];
            $type = $info['work_order_type'] == 1 ? 2 : 5;
            $factoryId = $this->adminUser['factory_id'];
            $assessConfig = $this->model->getWorkOrderConfig($cateId, $type, $factoryId);
            $assessConfig = $assessConfig['data'] ?? [];
            $type = $info['work_order_type'] == 1 ? 3 : 6;
            $scoreConfig = $this->model->getWorkOrderConfig($cateId, $type, $factoryId);
            $scoreConfig = $scoreConfig['data'] ?? [];
            $workTypeMsg=$info['work_order_type']==1?"安装":"维修";
            if (empty($assessConfig)) {
                $this->error(lang('厂商未为当前商品类型设置'.$workTypeMsg.'评价信息'));
            }
            if (empty($scoreConfig)) {
                $this->error(lang('厂商未为当前商品类型设置'.$workTypeMsg.'评分信息'));
            }
        }
        //检查工单是否评论过
        $where = [
            'worder_id' => $info['worder_id'],
            'is_del'    => 0,
            'type'      => $assessType == 1 ? 1 : 2,
        ];
        $assessInfo = db('work_order_assess')->where($where)->find();
        if (!empty($assessInfo)) {
            $this->error('已经评价过，请查看详情');
        }
        if (IS_POST) {
            $url=$info['work_order_type']==1? url('index'):url('lists');
            if ($assessType == 2) {//追加评价
                $params = $this->request->param();
                $bool=$this->model->workAssessAppend($info,$this->adminUser,$params);
                if ($bool) {
                    $this->success('追加评价完成',$url);
                }
                $this->error($this->model->error,$url);
                return ;
            }
            //首次评价
            $assess=$this->request->param('post_conf');
            $score=$this->request->param('score',[],'intval');
            if (empty($assess) || empty($score)) {
                $this->error('请完善表单信息后再提交');
            }
            $bool=$this->model->workAssessFirst($info,$this->adminUser,$assessConfig,$scoreConfig,$assess,$score);
            if ($bool) {
                $this->success('评价完成',$url);
            }
            $this->error($this->model->error,$url);
            //$data = [
            //    'type'      =>  $params['type'],//1 首次评论 2 追加评论
            //    'msg'       =>  $params['msg'],
            //];
            //if(isset($params['score'])){
            //    $data['score'] = $params['score'];
            //}
            //$assessId = $this->model->worderAssess($info,$this->adminUser,$data);
            //if ($assessId === FALSE) {
            //    $this->error($this->model->error);
            //}else{
            //    $this->success('工单评价成功', url('index', ['type' => $info['work_order_type']]));
            //}
        }else{
            $this->assign('postConfig', $assessConfig);
            $this->assign('score_config', $scoreConfig);
            $this->assign('access_type', $assessType);
            $this->assign('info', $info);
            return $this->fetch();
        }
    }
    /**
     * 工单详情
     */
    public function detail()
    {
        $this->subMenu['showmenu'] = false;
        $info = $this->_assignInfo();
        $type = $info['work_order_type'];
        //只有厂商、服务商、零售商有维修工单的查看权限
        if ($type == 2 && !in_array($this->adminUser['admin_type'], [ADMIN_FACTORY,ADMIN_DEALER,ADMIN_SERVICE,ADMIN_SERVICE_NEW])) {
            $this->error(lang('NO_OPERATE_PERMISSION'));
        }
        $info = $this->model->getWorderDetail($info['worder_sn'], $this->adminUser);
        $cateId=isset($info['sub']['cate_id'])? $info['sub']['cate_id']:'';
        if (empty($cateId)) {
            $cateId = db('goods')->where([
                'is_del'   => 0,
                'goods_id' => $info['goods_id'],
            ])->value('cate_id');
        }
        $data=$this->model->getConfigLogDetail([
            'worder_id'=>$info['worder_id'],
            'cate_id'=>$cateId,
            'work_order_type'=>$info['work_order_type'],
            'factory_id'=>$this->adminUser['factory_id'],
        ]);

        $this->assign('postConfig',$data);
        if ($info === FALSE) {
            $this->error($this->model->error);
        }
        $this->assign('info', $info);
        return $this->fetch();
    }
    /**
     * 取消工单
     */
    public function cancel()
    {
        $info = $this->_assignInfo();
        $result = $this->model->worderCancel($info, $this->adminUser);
        if ($result === FALSE) {
            $this->error($this->model->error);
        }else{
            $this->success('取消售后工单成功');
        }
    }
    public function getAjaxList($where = [], $field = '')
    {
        $this->model=db('user_installer');
        $keyword = $this->request->param('word','','trim');
        if ($keyword) {
            $where['realname'] = ['like', '%'.$keyword.'%'];
        }
        $this->request->word=null;
        parent::getAjaxList($where, ['installer_id'=>'id','concat(realname," 【", phone,"】")'=>'name']);
    }
    public function del()
    {
        $this->error(lang('NO ACCESS'));
    }
    function _getAlias()
    {
        return 'WO';
    }
    function _getField(){
        $now=time();
        $field = 'I.*, WO.*, G.name as gname, GS.sku_name, I.phone as installer_phone,CASE when WO.work_order_status IN (0,1,2) AND WO.appointment<'.$now.' THEN 1 ELSE 0  END is_overtime';
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $field .= ',S.name';
        }
//         状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)
//         $field .= ', if(work_order_status >= 0, work_order_status, 5) as order_status';
        return $field;
    }
    function _getJoin()
    {
        $join[] = ['user_installer I', 'I.installer_id = WO.installer_id', 'LEFT'];
        $join[] = ['goods G', 'WO.goods_id = G.goods_id', 'LEFT'];
        $join[] = ['goods_sku GS', 'WO.sku_id = GS.sku_id', 'LEFT'];
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $join[] = ['store S', 'S.store_id = WO.store_id', 'LEFT'];
        }
        return $join;
    }
    function  _getOrder()
    {
        //return 'order_status ASC, WO.add_time DESC';
        return 'is_overtime DESC,WO.add_time DESC';
    }
    function _getWhere(){
        $params = $this->request->param();
        $status = isset($params['status']) ? intval($params['status']) : 0;
        if (!isset($this->statusList[$status])) {
            $status = 0;
        }
        $where = [
            'WO.is_del' => 0,
            'work_order_type' => $this->type,
        ];
        //电商客服只能看到自己创建的工单
        if ($this->adminUser['group_id']==GROUP_E_COMMERCE_KEFU){
            $where['WO.post_user_id']=$this->adminUser['user_id'];
        }
        
        if (isset($params['status'])) {
            $where['WO.work_order_status'] = $status;
        }
        if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
            $where['WO.factory_id'] = $this->adminUser['store_id'];
        }elseif(in_array($this->adminUser['admin_type'],[ADMIN_SERVICE_NEW,ADMIN_SERVICE]) ){
            $where['WO.store_id'] = $this->adminUser['store_id'];
        }else {
            $where['WO.post_store_id'] = $this->adminUser['store_id'];
        }
        if ($params) {
            $sn = isset($params['sn']) ? trim($params['sn']) : '';
            if($sn){
                $where['WO.worder_sn'] = ['like','%'.$sn.'%'];
            }
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['WO.user_name|WO.phone'] = ['like','%'.$name.'%'];
            }
            $installerName = isset($params['installer_name']) ? trim($params['installer_name']) : '';
            if($installerName){
                $where['I.realname|I.phone'] = ['like','%'.$installerName.'%'];
            }
            $address=isset($params['address']) ? trim($params['address']) : '';
            if(''!==$address){
                $where['WO.address'] = ['like','%'.$address.'%'];
            }
            $regionLen=isset($params['region_len']) ? intval($params['region_len']) : '';
            $regionId=isset($params['region_id']) ? intval($params['region_id']) : '';
            $region_name=isset($params['region_name']) ? trim($params['region_name']) : '';
            if ($regionId>0){
                switch ($regionLen) {
                    case 3:
                        $where['WO.region_id']=$regionId;
                        break;
                    case 2:
                    case 1:
                        $where['WO.region_name'] = ['like',''.$region_name.'%'];
                        break;
                }
            }
            if ($this->adminUser['admin_type'] == ADMIN_FACTORY) {
                $sname = isset($params['sname']) ? trim($params['sname']) : '';
                if($sname){
                    $where['S.name'] = ['like','%'.$sname.'%'];
                }
            }
        }
        return $where;
    }
    
    private function _getSkuSub($info = [])
    {
        //判断是否有新增权限
        if (!in_array($this->adminUser['admin_type'], [ADMIN_FACTORY, ADMIN_CHANNEL, ADMIN_DEALER]))
        {
            $this->error(lang('NO ACCESS'));
        }
        $params = $this->request->param();
        if (!$info) {
            $type = isset($params['type']) ? intval($params['type']) : 0;
            if (!isset($this->orderTypes[$type])) {
                $this->error('工单类型错误');
            }
        }else{
            $type = $info['type'];
        }
        //零售商和渠道商只允许添加安装工单 厂商客服仅允许添加维修工单
        if ($type == 1 && !in_array($this->adminUser['admin_type'], [ADMIN_FACTORY,ADMIN_CHANNEL, ADMIN_DEALER])) {
            $this->error(lang('NO ACCESS'));
        }elseif ($type == 2 && !in_array($this->adminUser['admin_type'], [ADMIN_FACTORY])){
            $this->error(lang('NO ACCESS'));
        }
        $ossubId = isset($params['ossub_id']) ? intval($params['ossub_id']) : 0;
        $wid = isset($params['wid']) ? intval($params['wid']) : 0;
        $name = $this->modelName = $this->orderTypes[$type];
        $ossub = [];
        if ($wid) {
            $exist = $this->model->find($wid);//安装工单
            if ($exist) {
                $exist['appointment'] = date('Y-m-d H:i', time());
                $exist['work_order_type'] = 2;
                $this->assign('info', $exist);
            }
            $ossub = $exist;
        }else{
            if (!$ossubId) {
                $this->error(lang('param_error'));
            }
            $orderSkuSubModel = db('order_sku_sub');
            $join = [];
            $skuModel = new \app\common\model\OrderSku();
            $ossub = $skuModel->getSubDetail($ossubId, FALSE, TRUE);
            if (!$ossub) {
                $this->error('参数错误');
            }
            if ($ossub['goods_type'] == 2) {
                $this->error('样品不允许安装/维修');
            }
            if ($ossub['order_status'] != 1) {
                $this->error('订单已取消或关闭，不允许添加工单');
            }
            if (!$ossub['pay_status']) {
                $this->error('订单未支付，不允许添加工单');
            }
            if($ossub['service'] && ($ossub['service']['service_status'] != -1 && $ossub['service']['service_status'] != -2)){
                $this->error('产品存在退款申请，不允许提交工单');
            }
            $this->assign('ossub', $ossub);
        }
        //创建工单时自定义的表单字段
        $config=$this->getPostConf($ossub['sku_id'],$type);
        $this->assign('postConfig',$config);

        if ($type == 1) {
            //判断当前产品对应工单数量
            $exist = $this->model->where(['ossub_id' => $ossub['ossub_id'], 'work_order_type' => 1, 'work_order_status' => ['<>', -1]])->find();
            if ($exist) {
                $this->error('当前产品已申请安装工单', url('workorder/index'));
            }
        }
        if ($type == 2) {
            $wid = isset($params['wid']) ? intval($params['wid']) : 0;
            $info = $this->model->where(['worder_id' => $wid, 'work_order_type' => 1, 'work_order_status' => 4])->find();
            if (!$info) {
                $this->error(lang('param_error'));
            }
            //判断当前是否存在正在进行中的维修工单
            $exist = $this->model->where(['parent_id' => $wid, 'work_order_type' => 2, 'work_order_status' => ['<>', -1]])->find();
            if ($exist) {
                $this->error('当前工单存在维修中的工单，不允许添加');
            }
        }
        return $ossub;
    }
    function _getData($ossub = [])
    {
        $data = parent::_getData();
        $params = $this->request->param();
        $info = parent::_assignInfo();
        if (!$info) {
            $ossub = $this->_getSkuSub($info);
        }
        if ($ossub) {
            $postConf= $this->request->param('post_conf',[]);
            $orderType= $this->request->param('work_type',1,'intval');
            $config=$this->getPostConf($ossub['sku_id'],$orderType);
            if ($config && empty($postConf)) {
                $this->error('请先完善表单信息');
            }
            if ($config) {
                foreach ($config as $k=>$v) {
                    if ($v['is_required']  && (!isset($postConf[$v['id']])) || $postConf[$v['id']]==='' || $postConf[$v['id']]===null ) {
                        $this->error($v['name'].'不能为空');
                        return false;
                    }
                }
                $this->workAddConf=$config;
            }
        }
        $type = isset($params['type']) ? intval($params['type']) : '';
        $userName = isset($data['user_name']) ? trim($data['user_name']) : '';
        $phone = isset($data['phone']) ? trim($data['phone']) : '';
        $regionId = isset($data['region_id']) ? intval($data['region_id']) : '';
        $regionName = isset($data['region_name']) ? trim($data['region_name']) : '';
        $address = isset($data['address']) ? trim($data['address']) : '';
        $appointment = isset($data['appointment']) ? trim($data['appointment']) : '';
        $faultDesc = isset($data['fault_desc']) ? trim($data['fault_desc']) : '';
        if ($info && in_array($info['work_order_status'], [-1, 3, 4])) {
            $this->error('工单当前状态不允许编辑');
        }
        if (!$info || $info['region_id'] != $regionId) {
            $storeId=0;
            //@updated_at 2018/03/29 By Jinzhou
            //零售商提交安装工单分配到所属上级，不再按地区分配服务商
            if ($type==1 && ($this->adminStore['store_type']==STORE_DEALER || (isset($ossub['user_store_type']) && $ossub['user_store_type']==STORE_DEALER))) {
                $where=[
                    'S.is_del'=>0,
                    'SD.store_id'=>$ossub['user_store_id'] ?? $this->adminStore['store_id'],
                ];
                $store=db('store_dealer')->alias('SD')->field('S.store_id,S.status')
                    ->join('store S','SD.ostore_id=S.store_id')
                    ->where($where)->find();
                if (empty($store)) {
                    $this->error('工单提交失败，查无所属服务商');
                }
                if ($store['status']==0) {
                    $this->error('工单提交失败，所属服务商已被禁用');
                }
                $storeId=$store['store_id'];
            }else{
                if (in_array($this->adminUser['group_id'], [GROUP_E_COMMERCE_KEFU])) {
                    $serviceId = isset($data['service_id']) ? intval($data['service_id']) : 0;
                    if (!$serviceId) {
                        $this->error('请选择工单服务商');
                    }
                    $where = [
                        ['is_del', '=', 0],
                        ['store_type', '=', STORE_SERVICE_NEW],
                        ['factory_id', '=', $this->adminFactory['store_id']],
                        ['store_id', '=', $serviceId],
                    ];
                    $service = model('store')->where($where)->find();
                    if (!$service) {
                        $this->error('选择的服务商不存在或已删除');
                    }
                    if (!$service['status']) {
                        $this->error('选择的服务商已禁用');
                    }
                    $storeId = $serviceId;
                }else{
                    $storeModel = new \app\common\model\Store();
                    //根据安装地址分配服务商
                    $storeId = $storeModel->getStoreFromRegion($regionId);
                    if(!$storeId){
                        $this->error('该区域暂无服务商');
                    }
                }
            }
            $data['store_id'] = $storeId;
        }
        if (!$info && !$type) {
            $this->error('请选择工单类型');
        }
        if ($type && !isset($this->orderTypes[$type])) {
            $this->error('工单类型错误');
        }
        if (!$info) {
            $data['factory_id']     = $this->adminFactory['store_id'];
            $data['post_user_id']   = ADMIN_ID;
            $data['work_order_type']= $type;
            $data['osku_id']        = $ossub && isset($ossub['osku_id']) ? $ossub['osku_id'] : 0;
            $data['ossub_id']       = $ossub && isset($ossub['ossub_id']) ? $ossub['ossub_id'] : 0;
            $data['order_sn']       = $ossub['order_sn'];
            $data['goods_id']       = $ossub['goods_id'];
            $data['sku_id']         = $ossub['sku_id'];
            $data['post_store_id']  = $this->adminUser['store_id'];
        }
        if ($ossub) {
            $data['install_price'] = $ossub['install_price'];
        }
        if (!$userName || !$phone || !$regionId || !$regionName) {
            $this->error('请完善客户信息');
        }
        if (!$appointment) {
            $this->error('请选择客户预约时间');
        }
        if (!$appointment) {
            $this->error('请填写客户预约服务时间');
        }
        if ($type == 2) {
            $parentId = isset($params['wid']) ? intval($params['wid']) : '';
            if ($parentId <= 0) {
                $this->error(lang('PARAM_ERROR'));
            }
            if (!$faultDesc) {
                $this->error('请简要描述故障信息');
            }
            $data['parent_id'] = $parentId;
        }
        if ($type == 1) {
            $data['fault_desc'] = '';
        }
        if (isset($data['imgs'])) {
            $data['images'] = $data['imgs'] ? implode(',', $data['imgs']) :'';
        }else {
            $data['images'] = '';
        }
        $data['appointment'] = $appointment ? strtotime($appointment) : 0;
        if ($data['appointment'] <= time()) {
            $this->error('预约服务时间必须大于当前时间');
        }
        if (!$info) {
            if ($this->adminUser['group_id'] == GROUP_E_COMMERCE_KEFU) {
                $data['carry_goods'] = 0;
            }else{
                $data['carry_goods'] = $type == 1 ? 1 : 0;
            }
        }
        return $data;
    }
    function _assignAdd(){
        parent::_assignAdd();
        $this->_getSkuSub();
    }
    function _assignInfo($pkId = 0)
    {
        $info = parent::_assignInfo();
        if ($info) {
            $info['images'] = $info['images'] ? explode(',', $info['images']) : [];
        }
        if (in_array($this->adminUser['group_id'], [GROUP_E_COMMERCE_KEFU])) {
            $where = [
                ['is_del', '=', 0],
                ['status', '=', 1],
                ['check_status', '=', 1],
                ['store_type', '=', STORE_SERVICE_NEW],
                ['factory_id', '=', $this->adminFactory['store_id']],
            ];
            $services = model('store')->where($where)->column('store_id,  name');
            if ($services) {
                $this->assign('services',$services);
            }
        }
        return $info;
    }
}