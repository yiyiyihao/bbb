<?php
namespace app\factory\controller;
use app\common\controller\FormBase;
//分销活动管理
class Promotion extends FormBase
{
    private $promTypes;
    public function __construct()
    {
        $this->modelName = 'promotion';
        $this->model = model('promotion');
        parent::__construct();
        $this->promTypes = $this->model->promTypes;
        $this->assign('promTypes', $this->promTypes);
    }
    public function getAjaxList($where = [], $field = '')
    {
        $info = $this->_assignInfo();
        $params = $this->request->param();
        unset($params['_']);
        $keyword = isset($params['word']) ? trim($params['word']) : '';
        $isPage = isset($params['isPage']) ? intval($params['isPage']) : 0;
        $currectPage   = isset($params['page']) ? intval($params['page']) : 0;
        unset($params['word'], $params['isPage'], $params['page']);
        $this->model = new \app\common\model\PromotionSku();
        $pk = $this->model->getPk();
        $where = [
            ['PSK.is_del', '=', 0],
            ['PSK.status', '=', 1],
            ['PSK.promot_id', '=', $info['promot_id']],
        ];
        if ($keyword) {
            $where[] = ['name', 'like', '%'.$keyword.'%'];
        }
        $alias = 'PSK';
        $join = [
            ['goods G', 'G.goods_id = PSK.goods_id', 'INNER'],
        ];
        $count =  $this->model->where($where)->alias($alias)->join($join)->count();
        $field = 'PSK.goods_id as id, G.name';
        $list = $this->model->field($field)->alias($alias)->join($join)->where($where)->order('PSK.add_time DESC')->paginate($this->perPage, $count, ['page' => $currectPage, 'ajax' => TRUE]);
        $page = '';
        if ($list) {
            $page = $list->render();
            $list = $list->toArray()['data'];
        }
        $data = array(
            'data'  => $list,
            'page' => $page,
        );
        $this->ajaxJsonReturn($data);
    }
    public function config(){
        if (!$this->adminFactory || $this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $this->error(lang('NO ACCESS'));
        }
        $config = get_store_config($this->adminStore['store_id'], TRUE);
        $params = [];
        if (IS_POST) {
            $storeModel = model('store');
            $params = $this->request->post();
            if (!$params) {
                $this->error('参数异常');
            }
            $configKey = 'default';
            foreach ($params as $key => $value) {
                if (!is_array($value)) {
                    $config[$configKey][$key] = trim($value);
                }else{
                    $config[$key]=isset($config[$key])? $config[$key]:[];
                    $config[$key] =array_merge($config[$key],$value);
                }
            }
            $configJson = $config ? json_encode($config): '';
            $result = $storeModel->save(['config_json' => $configJson], ['store_id' => $this->adminStore['store_id']]);
            if ($result === FALSE) {
                $this->error($storeModel->error);
            }
            $this->success('编辑成功');
        }else{
            $this->assign('config', $config);
        }
        return $this->fetch();
    }
    public function setting(){
        if (!$this->adminFactory || $this->adminUser['admin_type'] != ADMIN_FACTORY) {
            $this->error(lang('NO ACCESS'));
        }
        $info = $this->_assignInfo();
        $config = $info['config'] ? json_decode($info['config'], TRUE):[];
        $params = [];
        if (IS_POST) {
            $params = $this->request->post();
            if (!$params) {
                $this->error('参数异常');
            }
            foreach ($params as $key => $value) {
                if (!is_array($value)) {
                    $config[$key] = trim($value);
                }else{
                    $config[$key]=isset($config[$key])? $config[$key]:[];
                    $config[$key] =array_merge($config[$key],$value);
                }
            }
            $configJson = $config ? json_encode($config): '';
            $result = $this->model->save(['config' => $configJson], ['promot_id' => $info['promot_id']]);
            if ($result === FALSE) {
                $this->error($this->model->error);
            }
            $this->success('配置成功', url('index'));
        }else{
            $this->assign('config', $config);
        }
        return $this->fetch();
    }
    public function joins()
    {
        $info = parent::_assignInfo();
        $where = [
            'PU.store_id' => $this->adminFactory['store_id'],
            'PU.promot_id' => $info['promot_id'],
            'PU.is_del' => 0,
            'UD.is_del' => 0,
        ];
        $params = $this->request->param();
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where[] = ['realname|phone', 'like', '%'.$name.'%'];
            }
        }
        $join = [
            ['user_distributor UD', 'UD.distrt_id = PU.distrt_id', 'INNER'],
        ];
        $alias = 'PU';
        $field = '*';
        $order = 'PU.add_time DESC';
        $model = model('promotion_join');
        $count  = $model->alias($alias)->join($join)->field($field)->where($where)->count();
        $list   = $model->alias($alias)->join($join)->field($field)->where($where)->order($order)->paginate($this->perPage,$count, ['query' => input('param.')]);
        // 获取分页显示
        $page   = $list->render();
        $list   = $list->toArray()['data'];
        $this->assign('list',$list);// 赋值数据集
        $this->assign('page', $page);
        return $this->fetch('joins');
    }
    
    public function edit()
    {
        $params = $this->request->param();
        $detail = isset($params['detail']) ? $params['detail']: 0;
        if ($detail > 0) {
            $this->infotempfile = 'detail';
        }
        return parent::edit();
    }
    
    
    function _assignInfo($pkId = 0)
    {
        $info = parent::_assignInfo($pkId);
        if ($info && $info['store_id'] != $this->adminFactory['store_id']){
            $this->error('NO ACCESS');
        }
        //获取可参与分销的商品列表
        $where = [
            ['is_del', '=', 0],
            ['status', '=', 1],
            ['store_id', '=', $this->adminFactory['store_id']],
        ];
        $goods = model('goods')->where($where)->column('goods_id, name');
        $this->assign('goods', $goods);
        $datas = [];
        if ($info) {
            $where = [
                ['is_del', '=', 0],
                ['status', '=', 1],
                ['store_id', '=', $this->adminFactory['store_id']],
                ['promot_id', '=', $info['promot_id']],
            ];
            $datas = model('promotion_sku')->where($where)->select();
            if ($datas) {
                foreach ($datas as $key => $value) {
                    $datas[$key]['sale_commission'] = $value['sale_commission'] ? json_decode($value['sale_commission'], 1) : [];
                    $datas[$key]['manage_commission'] = $value['manage_commission'] ? json_decode($value['manage_commission'], 1) : [];
                }
            }
        }
        $this->assign('datas', $datas);
        return $info;
    }
    
    function _getWhere()
    {
        $where = parent::_getWhere();
        $params = $this->request->param();
        $where[] = ['store_id', '=', $this->adminFactory['store_id']];
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where[] = ['name', 'like', '%'.$name.'%'];
            }
            if (isset($params['status'])) {
                $status = intval($params['status']);
                switch ($status) {
                    case 0:
                        $where[] = ['status', '=', 0];
                    break;
                    case -1:
                        $where[] = ['status', '=', 1];
                        $where[] = ['add_time', '>', time()];
                        break;
                    case -2:
                        $where[] = ['status', '=', 1];
                        $where[] = ['add_time', '<=', time()];
                        $where[] = ['end_time', '<=', time()];
                        break;
                    case 1:
                        $where[] = ['status', '=', 1];
                        $where[] = ['add_time', '<=', time()];
                        $where[] = ['end_time', '>', time()];
                        break;
                    default:
                    break;
                }
            }
        }
        return $where;
    }
    function _getData()
    {
        $data = parent::_getData();
        $name = isset($data['name']) ?trim($data['name']) : '';
        $coverImg = isset($data['cover_img']) ?trim($data['cover_img']) : '';
        $startTime = isset($data['start_time']) ? strtotime($data['start_time']) : '';
        $endTime = isset($data['end_time']) ?strtotime($data['end_time']) : '';
        $detail = $this->request->param('detail');
        $id = $this->request->param('id', 0, 'intval');
        if (!$detail) {
            $data['start_time'] = $startTime;
            $data['end_time'] = $endTime;
            if (!$name) {
                $this->error('活动名称不能为空');
            }
            if (!$coverImg) {
                $this->error('请上传活动封面图片');
            }
            if (!$startTime) {
                $this->error('活动开始时间错误');
            }
            if (!$endTime) {
                $this->error('活动结束时间错误');
            }
            if ($endTime <= $startTime) {
                $this->error('活动结束时间必须大于开始时间');
            }
            if ($endTime <= time()) {
                $this->error('活动结束时间必须大于当前时间');
            }
            //判断活动名称是否已存在
            $where = [
                ['is_del', '=', 0],
                ['name', '=', $name],
                ['store_id', '=', $this->adminFactory['store_id']],
            ];
            if ($id) {
                $where[] = ['promot_id', '<>', $id];
            }else{
                $data['store_id'] = $this->adminFactory['store_id'];
                $data['content'] = '';
            }
            $exist = $this->model->where($where)->find();
            if ($exist) {
                $this->error('活动名称已存在');
            }
            $goodsIds = isset($data['goods_id']) ? $data['goods_id'] : [];
            if (!$goodsIds || !is_array($goodsIds)) {
                $this->error('活动选择商品不能为空');
            }
            $goodsArr = $skus = [];
            $goodsModel = model('goods');
            foreach ($goodsIds as $key => $value) {
                $goodsId = intval($value);
                if ($goodsId > 0) {
                    $where = [
                        ['is_del', '=', 0],
                        ['goods_id', '=', $goodsId],
                        ['store_id', '=', $this->adminFactory['store_id']],
                    ];
                    $exist = $goodsModel->where($where)->find();
                    if (!$exist) {
                        $this->error('选择商品不存在');
                    }
                    $i = array_search($goodsId, $goodsArr);
                    if ($i !== FALSE) {
                        $this->error('第'.($key+1).'行商品 与 第'.($i+1).'行商品重复');
                    }
                    $saleType = isset($data['sale_type'][$key]) ? trim($data['sale_type'][$key]):'';
                    if (!$saleType || !isset($this->promTypes[$saleType])) {
                        $this->error('第'.($key+1).'行商品 佣金结算类型错误');
                    }
                    $name = $this->promTypes[$saleType];
                    $saleValue = isset($data['sale_value'][$key]) ? sprintf("%0.2f", $data['sale_value'][$key]):'';
                    if ($saleValue <= 0) {
                        $this->error('第'.($key+1).'行商品 销售佣金 '.$name.' 错误');
                    }
                    if ($saleType == 'ratio') {
                        if ($saleValue >= 100) {
                            $this->error('第'.($key+1).'行商品 销售佣金 '.$name.' 不允许超过100');
                        }
                    }else{
                        $maxPrice = $exist['max_price'] > 0 ? $exist['max_price'] : $exist['min_price'];
                        if ($saleValue > $maxPrice) {
                            $this->error('第'.($key+1).'行商品 销售佣金 '.$name.' 不允许超过'.$maxPrice);
                        }
                    }
                    $manageType = isset($data['manage_type'][$key]) ? trim($data['manage_type'][$key]):'';
                    if (!$manageType || !isset($this->promTypes[$manageType])) {
                        $this->error('第'.($key+1).'行商品 佣金结算类型错误');
                    }
                    $name = $this->promTypes[$manageType];
                    $manageValue = isset($data['manage_value'][$key]) ? sprintf("%0.2f", $data['manage_value'][$key]):'';
                    if ($manageValue <= 0) {
                        $this->error('第'.($key+1).'行商品 管理佣金 '.$name.' 错误');
                    }
                    if ($manageType == 'ratio') {
                        if ($manageValue >= 100) {
                            $this->error('第'.($key+1).'行商品 管理佣金 '.$name.' 不允许超过100');
                        }
                    }else{
                        if ($manageValue > $exist['max_price']) {
                            $this->error('第'.($key+1).'行商品 管理佣金 '.$name.' 不允许超过'.$exist['max_price']);
                        }
                    }
                    
                    $goodsArr[$key] = $goodsId;
                    
                    $skus[] = [
                        'goods_id' => $goodsId,
                        'sku_id' => 0,
                        'store_id' => $this->adminFactory['store_id'],
                        'sale_commission' => json_encode([
                            'type' => $saleType,
                            'value' => $saleValue,
                        ]),
                        'manage_commission' => json_encode([
                            'type' => $manageType,
                            'value' => $manageValue,
                        ]),
                    ];
                }
            }
            $data['skus'] = $skus;
            $data['promot_type'] = 'fenxiao';
        }
        if (!$id) {
            $data['config'] = '';
        }
        return $data;
    }
    function _getOrder()
    {
        return 'sort_order ASC, add_time DESC';
    }
    function _afterList($list)
    {
        if ($list) {
            foreach ($list as $key => $value) {
                $list[$key]['status'] = get_promotion_status($value)['text'];
            }
        }
        return $list;
    }
    /**
     * 列表搜索配置
     */
    function _searchData(){
        $status = get_promotion_status();
        $this->assign('status', $status);
        $search = [
            ['type' => 'input', 'name' =>  'name', 'value' => '活动名称', 'width' => '30'],
            ['type' => 'select', 'name' => 'status', 'options'=>'status', 'default_option' => '==选择状态==', 'default' => '-5'],
        ];
        return $search;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = parent::_tableData();
        if ($table['actions']['button']) {
            $table['actions']['button'][] = ['text'  => '参与用户','action'=> 'condition', 'icon'  => 'list','bgClass'=> 'bg-yellow','condition'=>['action'=>'joins','rule'=>' $vo["status"]']];
            $table['actions']['button'][] = ['text'  => ' 推广文案配置','action'=> 'condition', 'icon'  => 'setting','bgClass'=> 'bg-main','condition'=>['action'=>'setting','rule'=>' $vo["status"]']];
            $table['actions']['width']  = '*';
        }
        return $table;
    }
}