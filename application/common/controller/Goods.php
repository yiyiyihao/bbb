<?php
namespace app\common\controller;
use think\Request;
//产品管理
class Goods extends FormBase
{
    public $goodsTypes;
    public $goodsCates;
    public $stockReduces;
    public function __construct()
    {
        $this->modelName = 'goods';
        $this->model = new \app\common\model\Goods();
        parent::__construct();
        $this->goodsCates = [
            1 => '标准产品',
            2 => '产品零配件',
        ];
        $this->goodsTypes = [
            1 => '普通商品',
            2 => '样品',
        ];
        $this->stockReduces = [
            1 => '买家下单时减少库存',
            2 => '买家付款成功后减少库存',
        ];
        $this->assign('goodsCates', get_goods_cate());
        $this->assign('goodsTypes', goodstype());
        $this->assign('stockReduces', $this->stockReduces);
    }
    //产品属性管理
    public function spec()
    {
        $params = $this->request->param();
        $id = intval($params['id']);
        $this->subMenu['menu'][] = [
            'name'  => lang('规格属性管理'),
            'url'   => url('spec', ['id' => $id]),
        ];
        if($id){
            //取得产品详情
            $where = ['goods_id' => $id, 'is_del' => 0];
            if ($this->adminUser['store_id']) {
                $where['store_id'] = $this->adminUser['store_id'];
            }
            $goodsInfo = $this->model->where($where)->find();
            if (!$goodsInfo) {
                $this->error('产品不存在或删除');
            }
            $name = '编辑产品规格属性';
            if(IS_POST){
                $dataSet    = [];
                $specSns    = isset($params['sku_sn']) ? $params['sku_sn'] : [];
                $minPrice   = $maxPrice = $goodsStock = 0;
                $skuIds     = isset($params['skuid']) ? $params['skuid'] : [];
                if(!empty($specSns) && is_array($specSns)){
                    $specJson   = $params['spec_json'];
                    $specPrice  = $params['price'];
                    $specName   = $params['spec_name'];
                    $specSku    = $params['sku_stock'];
                    if (!$specJson) {
                        $this->error('规格异常');
                    }
                    //清空当前产品属性
                    $where = ['goods_id' => $id, 'is_del' => 0];
                    if ($skuIds) {
                        $where['sku_id'] = ['NOT IN', $skuIds];
                    }
                    db('goods_sku')->where($where)->update(['is_del' => 1, 'update_time' => time()]);
                    foreach ($specSns as $k => $v){
                        $price = floatval($specPrice[$k]);
                        $stock = intval($specSku[$k]);
                        $minPrice = !$minPrice ? $price : min($minPrice, $price);
                        $maxPrice = !$maxPrice ? $price : max($maxPrice, $price);
                        if ($price < 0) {
                            $this->error('第'.($k+1).'行,产品价格小于0');
                        }
                        if ($stock < 0) {
                            $this->error('第'.($k+1).'行,产品库存小于0');
                        }
                        $specValue = [];
                        if ($specJson[$k]) {
                            $spec = json_decode($specJson[$k], true);
                            if ($spec) {
                                foreach ($spec as $k1 => $v1) {
                                    $specValue[] = $v1;
                                }
                            }
                        }
                        $data = [
                            'goods_cate'    => intval($goodsInfo['goods_cate']),
                            'goods_type'    => $goodsInfo['goods_type'],
                            'sku_name'      => $specName[$k],
                            'sku_sn'        => trim($v),
                            'spec_json'     => $specJson[$k],
                            'sku_stock'     => $stock,
                            'spec_value'    => $specValue ? implode(';', $specValue) : '',
                            'price'         => $price,
                            'install_price' => floatval($goodsInfo['install_price']),
                            'stock_reduce_time'     => intval($goodsInfo['stock_reduce_time']),
                            'sample_purchase_limit' => intval($goodsInfo['sample_purchase_limit']),
                        ];
                        if ($skuIds) {
                            db('goods_sku')->where(['sku_id' => $skuIds[$k]])->update($data);
                        }else{
                            $data['store_id'] = $goodsInfo['store_id'];
                            $data['goods_id'] = $id;
                            $dataSet[] = $data;
                        }
                        $goodsStock += $stock;
                    }
                    if ($dataSet && !$skuIds) {
                        $result = db('goods_sku')->insertAll($dataSet);
                        if ($result === false) {
                            $this->error('系统错误');
                        }
                    }
                    //更新产品属性
                    $goodsData = array(
                        'specs_json'    => trim($params['specs_json']),
                        'min_price'     => $minPrice,
                        'max_price'     => $maxPrice,
                        'goods_stock'   => $goodsStock,
                    );
                    $this->model->where(['goods_id' => $id])->update($goodsData);
                    $this->success("产品属性修改成功!", url("index"), TRUE);
                }else{
                    //更新产品属性
                    $goodsData = array(
                        'specs_json'    => '',
                        'max_price'     => $goodsInfo['min_price'],
                    );
                    $this->model->where(['goods_id' => $id])->update($goodsData);
                    db('goods_sku')->where(['goods_id' => $id, 'is_del' => 0, 'spec_json' => ['neq', ""]])->update(['is_del' => 1, 'update_time' => time()]);
                    $update = [
                        'is_del'        => 0, 
                        'sku_stock'     => $goodsInfo['goods_stock'],
                        'price'         => $goodsInfo['min_price'],
                    ];
                    db('goods_sku')->where(['goods_id' => $id, 'is_del' => 1, 'spec_json' => ['eq', ""]])->update($update);
                    $this->success("产品属性修改成功!", url("index"), TRUE);
                }
            }else{
                $this->assign("goods", $goodsInfo);
                //取得规格参数表
                $specList = db('goods_spec')->where(array('status' => 1, 'is_del' => 0, 'store_id' => $goodsInfo['store_id']))->order("sort_order")->select();
                if ($specList) {
                    foreach ($specList as $k=>$v){
                        $specList[$k]['spec_value'] = explode(',', $v['value']);
                    }
                }
                $this->assign("specList",$specList);
                //取得属性详情
                $where = ['goods_id' => $id, 'is_del' => 0, 'status' => 1, 'store_id' => $goodsInfo['store_id'] ,'spec_json' => ['neq', ""]];
                $skuList = db('goods_sku')->where($where)->order("sku_id")->select();
                $this->assign("skuList",$skuList);
                return $this->fetch();
            }
        }else{
            $this->error("参数错误");
        }
    }
    public function getSkuList()
    {
        $params = $this->request->param();
        $goodsId = isset($params['goods_id']) ? intval($params['goods_id']) : 0;
        if(!$goodsId){
            $this->error('参数错误');
        }
        $where = [
            'is_del' => 0,
            'status' => 1,
            'goods_id' => $goodsId,
        ];
        $this->model = db('goods_sku');
        $this->getAjaxList($where, 'sku_id as id, sku_name as name');
    }
    function _getField(){
        $field = 'G.*, C.name as cate_name';
        return $field;
    }
    function _getAlias(){
        return 'G';
    }
    function _getJoin(){
        $join[] = ['goods_cate C', 'C.cate_id = G.cate_id', 'INNER'];
        return $join;
    }
    function _getWhere(){
        $params = $this->request->param();
        $where = ['G.is_del' => 0];
        if ($this->adminUser['store_id']) {
            $where['G.store_id'] = $this->adminUser['store_id'];
        }
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['G.name'] = ['like','%'.$name.'%'];
            }
            $sn = isset($params['sn']) ? trim($params['sn']) : '';
            if($sn){
                $where['G.goods_sn'] = ['like','%'.$sn.'%'];
            }
            $goodsType = isset($params['goods_type']) ? intval($params['goods_type']) : '';
            if($goodsType){
                $where['G.goods_type'] = $goodsType;
            }
        }
        return $where;
    }
    function _assignAdd()
    {
        $this->_getCategorys();
        parent::_assignAdd();
    }
    function _assignInfo($id = 0){
        $info = parent::_assignInfo($id);
        $sid = $info && $info['store_id'] ? $info['store_id'] : 0;
        $this->_getCategorys($sid);
        $skuinfo = db('goods_sku')->where(['goods_id' => $id, 'is_del' => 0, 'status' => 1, 'spec_json' => ['neq', ""]])->find();
        $info['skuinfo'] = $skuinfo;
        $info['imgnum'] = isset($info['imgs']) && $info['imgs'] ? count($info['imgs']) : 0;
        $info['imgs'] = isset($info['imgs']) && $info['imgs'] ? json_decode($info['imgs'], TRUE) : [];
        $this->assign('info', $info);
        $store = new \app\common\controller\Store();
        $store->_getFactorys();
        return $info;
    }
    function _getData()
    {
        $data = parent::_getData();
        $goodsSn = $data['goods_sn'];
//         if (!$goodsSn) {
//             $this->error('产品编码不能为空');
//         }
        $params = $this->request->param();
        $pkId = isset($params['id']) ? intval($params['id']): 0;
        $cateId = isset($params['cate_id']) ? intval($params['cate_id']): 0;
        $name = isset($params['name']) ? trim($params['name']): '';
        $goodsCate = isset($params['goods_cate']) ? intval($params['goods_cate']): 0;
        $goodsType = isset($params['goods_type']) ? intval($params['goods_type']): 0;
        $installPrice = isset($params['install_price']) ? floatval($params['install_price']): 0;
        $samplePurchaseLimit = isset($params['sample_purchase_limit']) ? intval($params['sample_purchase_limit']): 0;
        $stockReduceTime = isset($params['stock_reduce_time']) ? intval($params['stock_reduce_time']): 0;
        if (!$cateId) {
            $this->error('请选择产品分类');
        }
        if ($this->adminUser['store_id']) {
            $data['store_id'] = $this->adminUser['store_id'];
        }else{
            $storeId = isset($params['store_id']) && $params['store_id'] ? intval($params['store_id']) : 0;
            if (!$storeId) {
                $this->error('请选择厂商');
            }
            $data['store_id'] = $storeId;
        }
        if ($goodsSn) {
            $where = ['is_del' => 0];
            $where['goods_sn'] = $goodsSn;
            if($pkId){
                $where['goods_id'] = ['neq', $pkId];
            }
            $where['store_id'] = $data['store_id'];
            $exist = $this->model->where($where)->find();
            if ($exist) {
                $this->error('产品编码已存在，请重新填写');
            }
        }
        if (!$name) {
            $this->error('请输入产品名称');
        }
        if (!$goodsCate || !isset($this->goodsCates[$goodsCate])) {
            $this->error('请选择产品类别');
        }
        if (!$goodsType || !isset($this->goodsTypes[$goodsType])) {
            $this->error('请选择产品类型');
        }
        if ($goodsType == 1) {
            if ($installPrice <= 0) {
                $this->error('请填写安装费用');
            }
            $data['sample_purchase_limit'] = 0;
        }elseif ($goodsType == 2) {
            if ($samplePurchaseLimit <= 0) {
                $this->error('请填写样品限购数量');
            }
            $data['install_price'] = 0;
        }
        if (!$stockReduceTime || !isset($this->stockReduces[$stockReduceTime])) {
            $this->error('请选择库存计数类型');
        }
        if ($pkId) {
            $skuinfo = db('goods_sku')->where(['goods_id' => $pkId, 'is_del' => 0, 'status' => 1, 'spec_json' => ['neq', ""]])->find();
            if ($skuinfo) {
                unset($data['goods_stock']);
            }else{
                $data['max_price'] = $data['min_price'];
            }
        }
        $data['thumb'] = isset($data['thumb']) && $data['thumb'] ? $data['thumb'] : (isset($data['imgs']) && $data['imgs'] ? $data['imgs'][0] : '');
        if (isset($data['imgs']) && $data['imgs']) {
            $data['imgs'] = array_filter($data['imgs']);
            $data['imgs'] = $data['imgs'] ? array_unique($data['imgs']) : [];
            $data['imgs'] =  $data['imgs']? json_encode($data['imgs']) : '';
        }
        return $data;
    }
    function _afterAdd($pkId = 0, $data = []){
        if ($pkId) {
            //添加产品属性
            $skuData = [
                'goods_cate'    => intval($data['goods_cate']),
                'goods_type'    => intval($data['goods_type']),
                'goods_id'      => $pkId,
                'sku_sn'        => trim($data['goods_sn']),
                'sku_name'      => '',
                'spec_json'     => '',
                'sku_stock'     => intval($data['goods_stock']),
                'price'         => floatval($data['min_price']),
                'install_price' => floatval($data['install_price']),
                'store_id'      => intval($data['store_id']),
                'stock_reduce_time'     => intval($data['stock_reduce_time']),
                'sample_purchase_limit' => intval($data['sample_purchase_limit']),
            ];
            $skuId = db('goods_sku')->insertGetId($skuData);
        }
        return TRUE;
    }
    function _afterEdit($pkId = 0, $data = []){
        if ($pkId) {
            //修改产品属性
            $update = [
                'goods_cate'    => intval($data['goods_cate']),
                'goods_type'    => intval($data['goods_type']),
                'install_price' => floatval($data['install_price']),
                'stock_reduce_time'     => intval($data['stock_reduce_time']),
                'sample_purchase_limit' => intval($data['sample_purchase_limit']),
            ];
            $result = db('goods_sku')->where(['goods_id' => $pkId, 'is_del' => 0, 'status' => 1])->update($update);
            $update = [
                'sku_sn'    => $data['goods_sn'],
                'price'     => $data['min_price'],
            ];
            if (isset($data['goods_stock'])) {
                $update['sku_stock'] = trim($data['goods_stock']);
            }
            $result = db('goods_sku')->where(['goods_id' => $pkId, 'is_del' => 0, 'status' => 1, 'spec_json' => ['eq', ""]])->update($update);
        }
        return TRUE;
    }
    /**
     * 列表项配置
     */
    function _tableData(){
        $table = parent::_tableData();
        $btnArray = [];
        $btnArray = ['text'  => '产品规格','action'=> 'spec', 'icon'  => 'setting','bgClass'=> 'bg-yellow'];
        $table['actions']['button'][] = $btnArray;
        $table['actions']['width']  = '240';
        return $table;
    }
    
    private function _getCategorys($sid = 0)
    {
        $treeService = new \app\common\service\Tree();
        $sid = $sid ? $sid : $this->adminUser['store_id'];
        $where = ['is_del' => 0, 'store_id' => $sid];
        $categorys = db('goods_cate')->field("cate_id, name, parent_id, sort_order,name as cname, status")->where($where)->order("sort_order ASC, parent_id")->select();
        if ($categorys) {
            $categorys = $treeService->getTree($categorys);
        }
        $this->assign('cates', $categorys);
        return $categorys;
    }
}