<?php
namespace app\open\controller\v10\goods;

use app\open\controller\Base;
use think\Request;

class Goods extends Base
{
    private $goodsModel;
    
    public function __construct(Request $request)
    {
        parent::__construct();
        $this->goodsModel = model('goods');
        $this->postParams = $request->param();
        /**
         * Error 开头:002000
         */
    }
    /**
     * 获取当前应用可购买商品列表
     * @return \think\response\Json
     */
    public function index()
    {
        $result = $this->checkStoreManager(FALSE);
        if ($this->error) {
            return $result;
        }
        $openAppid = $this->user['open_appid'];
        $where = [
            ['open_appid', '=', $openAppid],
            ['factory_id', '<>', 0],
            ['is_del',          '=', 0],
            ['third_type',      '=', 'echodata'],
            ['user_type',       '=', 'open'],
        ];
        $user = model('user_data')->where($where)->column('udata_id');
        if ($user) {
            $where = [
                ['udata_id', 'IN', $user],
                ['is_del', '=', 0],
            ];
        }else{
            $where = [
                ['udata_id', '<', 0],
            ];
        }
        $field = 'goods_id, cate_id, name, goods_sn, thumb, min_price, max_price, install_price, goods_stock, sales';
        $result = $this->getModelList($this->goodsModel, $where, $field, 'add_time ASC');
        return $this->dataReturn(0, 'ok', $result);
    }
    
    public function beforeAdd()
    {
        $result = $this->checkStoreManager();
        if ($this->error) {
            return $result;
        }
        $where = [
            ['is_del', '=', 0],
            ['status', '=', 1],
            ['udata_id', '=', $this->user['udata_id']],
        ];
        $cates = model('goods_cate')->field('cate_id, name, parent_id')->where($where)->select();
        $field = 'spec_id as specid, name as specname, value as list';
        
        $specs = model('goods_spec')->field($field)->where($where)->select();
        if ($specs) {
            foreach ($specs as $key => $value) {
                $specs[$key]['list'] = $value ? explode(',', $value['list']) : [];
            }
        }
        $result = [
            'cates' => $cates ? $cates->toArray() : [],
            'specs' => $specs ? $specs->toArray() : [],
        ];
        return $this->dataReturn(0, 'ok', $result);
    }
    public function list()
    {
        $result = $this->checkStoreManager();
        if ($this->error) {
            return $result;
        }
        $field = 'goods_id, cate_id, name, goods_sn, thumb, min_price, max_price, install_price, goods_stock, sales';
        $where = [
            ['udata_id', '=', $this->user['udata_id']],
            ['is_del', '=', 0],
        ];
        $result = $this->getModelList($this->goodsModel, $where, $field, 'add_time ASC');
        return $this->dataReturn(0, 'ok', $result);
    }
    public function info()
    {
        $field = 'goods_id, cate_id, name, goods_sn, thumb, imgs, params_img, min_price, max_price, install_price, goods_stock, sales, description, content, specs_json';
        $info = $this->_verifyGoods(FALSE, $field);
        if ($this->error) {
            return $info;
        }
        $info['imgs'] = $info['imgs'] ? json_decode($info['imgs'], 1) : [];
        $info['specs_json'] = $info['specs_json'] ? json_decode($info['specs_json'], 1) : [];
        $where = [
            ['goods_id', '=', $info['goods_id']],
            ['is_del', '=', 0],
            ['status', '=', 1],
            ['store_id', '=', $this->user['factory_id']],
            ['spec_json', '=', ""],
        ];
        $exist = model('goods_sku')->where($where)->find();
        $info['sku_id'] = $exist && $exist['sku_id'] ? $exist['sku_id'] : 0;
        return $this->dataReturn(0, 'ok', $info);
    }
    public function getskus()
    {
        $info = $this->_verifyGoods(0, FALSE, FALSE);
        if ($this->error) {
            return $info;
        }
        $where = [
            ['goods_id', '=', $info['goods_id']],
            ['is_del', '=', 0],
            ['status', '=', 1],
            ['spec_json', '<>', ""],
        ];
        $field = 'sku_id, sku_name, sku_sn, sku_thumb, sku_stock, spec_value, price, install_price, sales';
        $result = model('goods_sku')->field($field)->where($where)->select();
        if (!$result->toArray()) {
            return $this->dataReturn('002019', 'skus not exist');
        }
        if ($result) {
            foreach ($result as $key => $value) {
                $result[$key]['sku_thumb'] = $value['sku_thumb'] ? $value['sku_thumb'] : $info['thumb'];
            }
        }
        return $this->dataReturn(0, 'ok', $result);
    }
    public function add()
    {
        $data = $this->_checkField();
        if ($this->error) {
            return $data;
        }
        $data['udata_id'] = $this->user['udata_id'];
        $data['store_id'] = $this->user['factory_id'];
        $result = $this->goodsModel->save($data);
        if ($result === FALSE) {
            return $this->dataReturn(-1, 'system_error');
        }
        $goodsId = $this->goodsModel->goods_id;
        
        $goodsSkuModel = model('GoodsSku');
        if ($data && $data['skus']) {
            $dataSet = [];
            foreach ($data['skus'] as $key => $value) {
                unset($value['sku_id']);
                $value['goods_id'] = $goodsId;
                $value['udata_id'] = $this->user['udata_id'];
                $value['store_id'] = $this->user['factory_id'];
                $dataSet[] = $value;
            }
            $result = $goodsSkuModel->saveAll($dataSet);
            if ($result === FALSE) {
                return $this->dataReturn(-1, 'system_error');
            }
        }else{
            //添加默认商品属性
            $data = [
                'goods_id'      => $goodsId,
                'sku_sn'        => trim($data['goods_sn']),
                'sku_name'      => '',
                'spec_json'     => '',
                'sku_stock'     => intval($data['goods_stock']),
                'price'         => floatval($data['min_price']),
                'install_price' => floatval($data['install_price']),
                'udata_id'      => $this->user['udata_id'],
                'store_id'      => $this->user['factory_id'],
            ];
            $result = $goodsSkuModel->save($data);
            if ($result === FALSE) {
                return $this->dataReturn(-1, 'system_error');
            }
        }
        return $this->dataReturn(0, 'ok', ['goods_id' => $goodsId]);
    }
    public function edit()
    {
        $info = $this->_verifyGoods();
        if ($this->error) {
            return $info;
        }
        $parentId = isset($this->postParams['parent_id']) ? intval($this->postParams['parent_id']) : '';
        $data = $this->_checkField($info);
        if ($this->error) {
            return $data;
        }
        $result = $this->goodsModel->save($data, ['goods_id' => $info['goods_id']]);
        if ($result === FALSE) {
            return $this->dataReturn(-1, 'system_error');
        }
        $goodsSkuModel = new \app\common\model\GoodsSku();
        if ($data && $data['skus']) {
            $skuIds = $data['skuids'];
            //清空当前商品属性
            $where = [
                ['goods_id', '=', $info['goods_id']],
                ['is_del', '=', 0],
            ];
            if ($skuIds) {
                $where[] = ['sku_id', 'NOT IN', $skuIds];
            }
            $result = $goodsSkuModel->save(['is_del' => 1], $where);
            if ($result === FALSE) {
                return $this->dataReturn(-1, 'system_error');
            }
            $dataSet = $updataSet = [];
            foreach ($data['skus'] as $key => $value) {
                $skuId = intval($value['sku_id']);
                if (!$skuId) {
                    unset($value['sku_id']);
                    $value['goods_id'] = $info['goods_id'];
                    $value['udata_id'] = $this->user['udata_id'];
                    $value['store_id'] = $this->user['factory_id'];
                    $dataSet[] = $value;
                }else{
                    $updataSet[] = $value;
                }
            }
            if ($dataSet) {
                $result = $goodsSkuModel->isUpdate(false)->saveAll($dataSet);
                if ($result === FALSE) {
                    return $this->dataReturn(-1, 'system_error');
                }
            }
            if ($updataSet) {
                $result = $goodsSkuModel->saveAll($updataSet);
                if ($result === FALSE) {
                    return $this->dataReturn(-1, 'system_error');
                }
            }
        }else{
            $result = $goodsSkuModel->save(['is_del' => 1], ['goods_id' => $info['goods_id'], 'is_del' => 0, 'spec_json' => ['<>', ""]]);
            if ($result === FALSE) {
                return $this->dataReturn(-1, 'system_error');
            }
            $where = [
                ['goods_id', '=', $info['goods_id']],
                ['is_del', '=', 1],
                ['spec_json', '=', ""],
            ];
            $exist = $goodsSkuModel->where($where)->find();
            if ($exist) {
                $result = $goodsSkuModel->save(['is_del' => 0], ['sku_id' => $exist['sku_id']]);
                if ($result === FALSE) {
                    return $this->dataReturn(-1, 'system_error');
                }
            }else{
                //添加默认商品属性
                $data = [
                    'goods_id'      => $info['goods_id'],
                    'sku_sn'        => trim($data['goods_sn']),
                    'sku_name'      => '',
                    'spec_json'     => '',
                    'sku_stock'     => intval($data['goods_stock']),
                    'price'         => floatval($data['min_price']),
                    'install_price' => floatval($data['install_price']),
                    'udata_id'      => $this->user['udata_id'],
                    'store_id'      => $this->user['factory_id'],
                ];
                $result = $goodsSkuModel->save($data);
                if ($result === FALSE) {
                    return $this->dataReturn(-1, 'system_error');
                }
            }
        }
        return $this->dataReturn(0, 'ok');
    }
    public function del()
    {
        $info = $this->_verifyGoods();
        if ($this->error) {
            return $info;
        }
        $result = $this->goodsModel->save(['is_del' => 1], ['goods_id' => $info['goods_id']]);
        if ($result === FALSE) {
            return $this->dataReturn(-1, 'system_error');
        }
        return $this->dataReturn(0, 'ok');
    }
    
    /**
     * 验证分类信息
     * @param int $goodsId
     * @param string $field
     * @return \think\response\Json|array
     */
    public function _verifyGoods($goodsId = 0, $field = '', $verifyManager = TRUE)
    {
        if ($verifyManager) {
            $result = $this->checkStoreManager();
            if ($this->error) {
                return $result;
            }
        }
        
        if (!$goodsId) {
            $goodsId = isset($this->postParams['goods_id']) ? intval($this->postParams['goods_id']) : '';
        }
        if (!$goodsId) {
            return $this->dataReturn('002000', 'missing goods_id');
        }
        $field = $field ? $field : '*';
        $where = [
            ['goods_id', '=', $goodsId],
            ['is_del', '=', 0],
        ];
        if ($verifyManager) {
            $where[] = ['store_id', '=', $this->user['factory_id']];
            $where[] = ['udata_id', '=', $this->user['udata_id']];
        }
        $info = $this->goodsModel->field($field)->where($where)->find();
        if (!$info) {
            return $this->dataReturn('002001', 'goods not exist');
        }
        return $info->toArray();
    }
    /**
     * 检查并处理add/edit对应的请求参数
     * @param array $info
     * @return array
     */
    private function _checkField($info = [])
    {
        $result = $this->checkStoreManager();
        if ($this->error) {
            return $result;
        }
        $name = isset($this->postParams['name']) ? trim($this->postParams['name']) : '';
        $goodsSn = isset($this->postParams['goods_sn']) ? trim($this->postParams['goods_sn']) : '';
        $cateId = isset($this->postParams['cate_id']) ? intval($this->postParams['cate_id']) : '';
        $thumb = isset($this->postParams['thumb']) ? trim($this->postParams['thumb']) : '';
        $maxPrice = $minPrice = isset($this->postParams['price']) ? floatval($this->postParams['price']) : 0;
        $goodsStock = isset($this->postParams['goods_stock']) ? intval($this->postParams['goods_stock']) : 0;
        $installPrice = isset($this->postParams['install_price']) ? floatval($this->postParams['install_price']) : 0;
        $imgs = isset($this->postParams['imgs']) ? $this->postParams['imgs'] : [];
        $params = isset($this->postParams['params']) ? trim($this->postParams['params']) : '';
        $description = isset($this->postParams['description']) ? trim($this->postParams['description']) : '';
        $content = isset($this->postParams['content']) ? trim($this->postParams['content']) : '';
        $status = isset($this->postParams['status']) && intval($this->postParams['status']) ? 1 : 0;
        
        $specs = isset($this->postParams['specs'])  ? $this->postParams['specs'] : [];
        $specSkus = isset($this->postParams['spec_skus'])  ? $this->postParams['spec_skus'] : [];
        if (!$name) {
            return $this->dataReturn('002002', 'missing name');
        }
        if (!$cateId) {
            return $this->dataReturn('002003', 'missing cate_id');
        }
        //判断分类是否存在
        $where = [
            ['cate_id', '=', $cateId],
            ['status', '=', 1],
            ['is_del', '=', 0],
            ['udata_id', '=', $this->user['udata_id']],
        ];
        $cate = model('goods_cate')->where($where)->find();
        if (!$cate) {
            return $this->dataReturn('002005', 'cate not exist');
        }
        //判断商品名称是否存在
        $where = [
            ['name', '=', $name],
            ['status', '=', 1],
            ['is_del', '=', 0],
            ['udata_id', '=', $this->user['udata_id']],
        ];
        if ($info) {
            $where[] = ['goods_id', '<>', $info['goods_id']];
        }
        $exist = $this->goodsModel->where($where)->find();
        if ($exist) {
            return $this->dataReturn('002018', 'name exist');
        }
        if (!$thumb) {
            return $this->dataReturn('002004', 'missing thumb');
        }
        if (!isset($this->postParams['price'])) {
            return $this->dataReturn('002005', 'missing price');
        }
        if ($minPrice <= 0) {
            return $this->dataReturn('002006', 'invalid price');
        }
        if ($goodsStock <= 0) {
            return $this->dataReturn('002007', 'invalid goods_stock');
        }
        if (!$imgs) {
            return $this->dataReturn('002008', 'missing imgs');
        }
        if (!is_array($imgs)) {
            return $this->dataReturn('002009', 'invalid imgs');
        }
        if (!$params) {
            return $this->dataReturn('002010', 'missing params');
        }
        $skuData = $skuids = [];
        if ($specs) {
            if (!is_array($specs)) {
                return $this->dataReturn('002011', 'invalid specs');
            }
            $goodsSpecModel = model('goods_spec');
            foreach ($specs as $k => $v){
                $specid = isset($v['specid']) ? intval($v['specid']): 0;
                $specname = isset($v['specname']) ? trim($v['specname']): '';
                $list = isset($v['list']) ? $v['list']: [];
                if (!$specid || !$specname || !$list || !is_array($list)) {
                    return $this->dataReturn('002011', 'invalid specs');
                }
                $where = [
                    ['spec_id', '=', $specid],
                    ['is_del', '=', 0],
                    ['udata_id', '=', $this->user['udata_id']],
                ];
                //判断specid是否存在
                $exist = $goodsSpecModel->where($where)->find();
                if (!$exist) {
                    return $this->dataReturn('002012', 'specs not exist');
                }
            }
            if (!$specSkus) {
                return $this->dataReturn('002013', 'missing spec_skus');
            }
            if (!is_array($specSkus)) {
                return $this->dataReturn('002014', 'invalid spec_skus');
            }
            $goodsStock = $minPrice = $maxPrice = 0;
            foreach ($specSkus as $k => $v){
                $skuid = isset($v['sku_id']) ? intval($v['sku_id']): 0;
                $skuids[] = $skuid;
                $skuJson = isset($v['sku_json']) ? $v['sku_json']: '';
                $skuName = isset($v['sku_name']) ? trim($v['sku_name']): 0;
                $price = isset($v['price']) ? floatval($v['price']): 0;
                $stock = isset($v['stock']) ? intval($v['stock']): 0;
                $ssn = isset($v['sn']) ? trim($v['sn']): '';
                if (!$ssn && $goodsSn) {
                    $ssn = $goodsSn.'_'.($k+1);
                    $specSkus[$k]['sn'] = $ssn;
                }
                if (!$skuName || !$price || !$stock || !$ssn) {
                    return $this->dataReturn('002014', 'invalid spec_skus');
                }
                if ($price <= 0) {
                    return $this->dataReturn('002015', 'invalid specs price(must be greater than 0)');
                }
                if ($stock <= 0) {
                    return $this->dataReturn('002016', 'invalid specs stock(must be greater than 0)');
                }
                if (!$ssn) {
                    return $this->dataReturn('002017', 'missing specs sn');
                }
                $goodsStock = $stock + $goodsStock;
                $minPrice = !$minPrice ? $price : min($minPrice, $price);
                $maxPrice = !$maxPrice ? $price : max($maxPrice, $price);
                $spec = $skuJson ? json_decode(htmlspecialchars_decode($skuJson), true) : [];
                $specValue = [];
                if ($spec) {
                    foreach ($spec as $k1 => $v1) {
                        $specValue[] = $v1;
                    }
                }
                $skuData[] = [
                    'sku_id'        => $skuid,
                    'sku_name'      => $skuName,
                    'sku_sn'        => $ssn,
                    'spec_json'     => $spec ? json_encode($spec, JSON_UNESCAPED_UNICODE): '',
                    'sku_stock'     => $stock,
                    'spec_value'    => $specValue ? implode(';', $specValue) : '',
                    'price'         => $price,
                    'install_price' => $installPrice,
                ];
            }
        }
        if ($goodsSn) {
            $where = [
                ['goods_sn', '=', $goodsSn],
                ['status', '=', 1],
                ['is_del', '=', 0],
                ['udata_id', '=', $this->user['udata_id']],
            ];
            if ($info) {
                $where[] = ['goods_id', '<>', $info['goods_id']];
            }
            $exist = $this->goodsModel->where($where)->find();
            if ($exist) {
                return $this->dataReturn('002019', 'goods_sn exist');
            }
        }
        $return =  [
            'name'      => $name,
            'goods_sn'  => $goodsSn,
            'cate_id'   => $cateId,
            'thumb'     => $thumb,
            'imgs'      => $imgs ? json_encode($imgs) : '',
            'min_price' => $minPrice,
            'max_price' => $maxPrice,
            'install_price' => $installPrice,
            'description'   => $description,
            'content'   => $content,
            'params_img'=> $params,
            'status'    => $status,
            'specs_json' => $specs ? json_encode($specs, JSON_UNESCAPED_UNICODE) : '',
            'skus'      => $skuData,
            'goods_stock'=> $goodsStock,
            'skuids'    => $skuids,
        ];
        return $return;
    }
}