<?php
namespace app\admin\controller;
use app\common\controller\FormBase;
use think\Request;
//商品管理
class Goods extends FormBase
{
    public function __construct()
    {
        $this->modelName = 'goods';
        $this->model = new \app\common\model\Goods();
        parent::__construct();
    }
    //商品属性管理
    public function spec()
    {
        $params = $this->request->param();
        $id = intval($params['id']);
        $this->subMenu['menu'][] = [
            'name'  => lang('规格属性管理'),
            'url'   => url('spec', ['id' => $id]),
        ];
        if($id){
            //取得商品详情
            $map = $this->_checkStoreVisit();
            $where = ['goods_id' => $id, 'is_del' => 0];
            if (is_array($map)) {
                $where['store_id'] = ['IN', $map];
            }
            $goodsInfo = $this->model->where($where)->find();
            if (!$goodsInfo) {
                $this->error('商品不存在或删除');
            }
            $name = '编辑商品规格属性';
            $skuMod = db('goods_sku');
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
                    //清空当前商品属性
                    $where = ['goods_id' => $id, 'is_del' => 0];
                    if ($skuIds) {
                        $where['sku_id'] = ['NOT IN', $skuIds];
                    }
                    $skuMod->where($where)->update(['is_del' => 1, 'update_time' => time()]);
                    foreach ($specSns as $k => $v){
                        $price = floatval($specPrice[$k]);
                        $stock = intval($specSku[$k]);
                        $minPrice = !$minPrice ? $price : min($minPrice, $price);
                        $maxPrice = !$maxPrice ? $price : max($maxPrice, $price);
                        if ($price < 0) {
                            $this->error('第'.($k+1).'行,商品价格小于0');
                        }
                        if ($stock < 0) {
                            $this->error('第'.($k+1).'行,商品库存小于0');
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
                            'sku_name'      => $specName[$k],
                            'sku_sn'        => trim($v),
                            'spec_json'     => $specJson[$k],
                            'sku_stock'     => $stock,
                            'spec_value'    => $specValue ? implode(';', $specValue) : '',
                            'price'         => $price,
                            'update_time'   => time(),
                        ];
                        if ($skuIds) {
                            $skuMod->where(['sku_id' => $skuIds[$k]])->update($data);
                        }else{
                            $data['store_id'] = $this->storeId;
                            $data['goods_id'] = $id;
                            $data['add_time'] = time();
                            $dataSet[] = $data;
                        }
                        $goodsStock += $stock;
                    }
                    if ($dataSet && !$skuIds) {
                        $result = $skuMod->insertAll($dataSet);
                        if ($result === false) {
                            $this->error('系统错误');
                        }
                    }
                    //更新商品属性
                    $goodsData = array(
                        'specs_json'    => trim($params['specs_json']),
                        'min_price'     => $minPrice,
                        'max_price'     => $maxPrice,
                        'goods_stock'   => $goodsStock,
                        'update_time'   => time(),
                    );
                    $this->model->where(['goods_id' => $id])->update($goodsData);
                    $this->success("商品属性修改成功!", url("index"), TRUE);
                }else{
                    //更新商品属性
                    $goodsData = array(
                        'specs_json'    => '',
                        'max_price'     => $goodsInfo['min_price'],
                        'update_time'   => time(),
                    );
                    $this->model->where(['goods_id' => $id])->update($goodsData);
                    $skuMod->where(['goods_id' => $id, 'is_del' => 0])->where(['spec_json' => ['neq', ""]])->update(['is_del' => 1, 'update_time' => time()]);
                    $update = [
                        'is_del'        => 0, 
                        'update_time'   => time(), 
                        'sku_stock'     => $goodsInfo['goods_stock'],
                        'price'         => $goodsInfo['min_price'],
                    ];
                    $skuMod->where(['goods_id' => $id, 'is_del' => 1])->where(['spec_json' => ['eq', ""]])->update($update);
                    $this->success("商品属性修改成功!", url("index"), TRUE);
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
                $skuList = $skuMod->where(['goods_id' => $id, 'is_del' => 0, 'status' => 1, 'store_id' => $goodsInfo['store_id']])->where(['spec_json' => ['neq', ""]])->order("sku_id")->select();
                $this->assign("skuList",$skuList);
                return $this->fetch();
            }
        }else{
            $this->error("参数错误");
        }
    }
    
    function _getField(){
        $field = 'G.*, C.name as cate_name';
//         if ($this->showOther) {
//             $field .= ', S.name as sname';
//         }
        return $field;
    }
    function _getAlias(){
        return 'G';
    }
    function _getJoin(){
        $join[] = ['goods_cate C', 'C.cate_id = G.cate_id', 'INNER'];
//         if ($this->showOther) {
//             $join[] = ['store S', 'S.store_id = G.store_id', 'INNER'];
//         }
        return $join;
    }
    function _getWhere(){
        $params = $this->request->param();
        $other = isset($params['other']) ? intval($params['other']) : '';
        $where = ['G.is_del' => 0];
//         if ($this->showOther) {
//             $where['G.store_id'] = ['<>', $this->storeId];
//             $sname = isset($params['sname']) ? trim($params['sname']) : '';
//             if($sname){
//                 $where['S.name'] = ['like','%'.$sname.'%'];
//             }
//         }else{
            $where['G.store_id'] = $this->storeId;
//         }
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if($name){
                $where['G.name'] = ['like','%'.$name.'%'];
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
        $skuinfo = db('goods_sku')->where(['goods_id' => $id, 'is_del' => 0, 'status' => 1])->where(['spec_json' => ['neq', ""]])->find();
        $info['skuinfo'] = $skuinfo;
        $info['imgnum'] = isset($info['imgs']) && $info['imgs'] ? count($info['imgs']) : 0;
        $info['imgs'] = isset($info['imgs']) && $info['imgs'] ? json_decode($info['imgs'], TRUE) : [];
        $this->assign('info', $info);
        return $info;
    }
    function _getData()
    {
        $data = parent::_getData();
        $goodsSn = $data['goods_sn'];
//         if (!$goodsSn) {
//             $this->error('商品货号不能为空');
//         }
        $params = $this->request->param();
        $pkId = isset($params['id']) ? intval($params['id']): 0;
//         $where = ['is_del' => 0, 'store_id' => $this->storeId];
//         if ($goodsSn) {
//             $where['goods_sn'] = $goodsSn;
//         }
//         if($pkId){
//             $where['goods_id'] = ['neq', $pkId];
//         }
//         $exist = $this->model->where($where)->find();
//         if ($exist) {
//             $this->error('商品货号已存在，请重新填写');
//         }
        if ($pkId) {
            $skuinfo = db('goods_sku')->where(['goods_id' => $pkId, 'is_del' => 0, 'status' => 1])->where(['spec_json' => ['neq', ""]])->find();
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
    function _addAfter($pkId = 0, $data = []){
        if ($pkId) {
            //添加商品属性
            $skuData = array(
                'goods_id'      => $pkId,
                'sku_sn'        => $data['goods_sn'],
                'sku_name'      => '',
                'spec_json'     => '',
                'sku_stock'     => $data['goods_stock'],
                'price'         => $data['min_price'],
                'add_time'      => time(),
                'update_time'   => time(),
                'store_id'      => $this->storeId,
            );
            $skuId = db('goods_sku')->insertGetId($skuData);
        }
        return TRUE;
    }
    function _editAfter($pkId = 0, $data = []){
        if ($pkId) {
            //修改商品属性
            $data = array(
                'sku_sn'        => $data['goods_sn'],
                'sku_stock'     => $data['goods_stock'],
                'price'         => $data['min_price'],
                'update_time'   => time(),
            );
            $result = db('goods_sku')->where(['goods_id' => $pkId, 'is_del' => 0, 'status' => 1, 'spec_json' => ['eq', ""]])->update($data);
        }
        return TRUE;
    }
    
    private function _getCategorys($sid = 0)
    {
        $treeService = new \app\common\service\Tree();
        $sid = $sid ? $sid : $this->storeId;
        $where = ['is_del' => 0, 'store_id' => $sid];
        $categorys = db('goods_cate')->field("cate_id, name, parent_id, sort_order,name as cname, thumb, status")->where($where)->order("sort_order ASC, parent_id")->select();
        if ($categorys) {
            $categorys = $treeService->getTree($categorys);
        }
        $this->assign('cates', $categorys);
        return $categorys;
    }
}
