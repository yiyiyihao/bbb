<?php
namespace app\common\controller;
use app\common\model\GoodsSku;
use app\common\model\GoodsService;
use app\common\model\GoodsSkuService;
use think\Request;
//商品管理
class Goods extends FormBase
{
    public $goodsTypes;
    public $goodsCates;
    public $stockReduces;
    private $channelId=0;
    public function __construct()
    {
        $this->modelName = 'goods';
        $this->model = new \app\common\model\Goods();
        parent::__construct();
        $this->goodsCates = [
            1 => '标准商品',
            2 => '商品零配件',
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
        $this->init();
    }

    public function init()
    {
        if ($this->adminStore['store_type'] == STORE_DEALER) {
            $channelId = db('store_dealer')->alias('SD')
                ->join('store S', 'SD.ostore_id=S.store_id')
                ->where([
                    'SD.store_id'  => $this->adminStore['store_id'],
                    'S.status'     => 1,
                    'S.is_del'     => 0,
                    'S.store_type' => STORE_SERVICE_NEW,
                ])
                ->value('ostore_id');
            if (empty($channelId)) {
                $this->error('服务商不存在或已被禁用');
            }
            $this->channelId = $channelId;
        }
    }

    public function edit()
    {
        if ($this->request->isPost() && $this->adminStore['store_type'] == STORE_SERVICE_NEW) {//新服务商
            $skuIds = $this->request->param('skuid', 0, 'intval');
            $priceService = $this->request->param('price_service');
            $installService = $this->request->param('install_price_service',[],'intval');
            $status = $this->request->param('status');
            $sortOrder = $this->request->param('sort_order');
            $id = $this->request->param('id', 0, 'intval');
            if (!is_array($skuIds) && empty($skuIds)) {
                $this->error('未设置商品规格');
            }
            $skuIds = array_unique(array_filter($skuIds));
            if (empty($skuIds)) {
                $this->error('参数不正确');
            }
            $storeId = $this->adminStore['store_id'];

            foreach ($skuIds as $k => $skuId) {
                $goodSku = GoodsSkuService::where(['is_del' => 0, 'sku_id' => $skuId, 'store_id' => $storeId])->find();
                $where = [];
                if (!empty($goodSku)) {
                    $where = ['id' => $goodSku['id']];
                }
                $data = [
                    'store_id'              => $storeId,
                    'sku_id'                => $skuId,
                    'goods_id'              => $id,
                    'price_service'         => $priceService[$k],
                    'install_price_service' => isset($installService[$k]) && $installService[$k] ? $installService[$k] : 0,
                    'status'                => $status,
                    'sort_order'            => $sortOrder,
                ];
                $result = (new GoodsSkuService)->save($data, $where);
            }
            $maxMin=array_map(function ($price,$fee=0) {
                return bcadd(floatval($price),$fee,2);
            },$priceService,$installService);
            $max = max($maxMin);
            $min = min($maxMin);
            $ret = (new GoodsService)->save(['min_price_service' => $min, 'max_price_service' => $max,'status'=>$status], ['store_id' => $storeId, 'is_del' => 0, 'goods_id' => $id]);
            $this->success("操作成功！",url('index'));
        } else {
            return parent::edit();
        }
    }

    function _afterList($list)
    {
        if ($list) {
            foreach ($list as $key => $value) {
                if ($this->adminStore['store_type'] == STORE_SERVICE_NEW) {
                    $list[$key]['price_store'] = $value['min_price_service'] == $value['max_price_service'] ? $value['min_price_service'] : $value['min_price_service'] . '~' . $value['max_price_service'];
                    $list[$key]['status'] =$value['status_service'];
                }
                $price=$value['min_price'];
                if ($value['min_price'] != $value['max_price']) {
                    $price.='~'.$value['max_price'];
                }
                $list[$key]['price']=$price;

            }
        }
        if ($this->adminUser['store_type'] == STORE_SERVICE_NEW) {
            $this->subMenu['add'] = [
                'name' => '导入' . lang($this->modelName),
                'url'  => url("sync_goods"),
            ];
        }
        return $list;
    }
    
    //编辑器选择商品
    public function choose(){
        $this->subMenu = false;
        return $this->fetch();
    }

    //异步取得商品详情
    public function getAjaxInfo(){
        
    }
    
    //商品详情管理
    public function detail()
    {
        $params = $this->request->param();
        $id = intval($params['id']);
        if ($id) {
            if (IS_POST) {
                $cate_thumb = isset($params['cate_thumb']) ? trim($params['cate_thumb']) : '';
                $description = isset($params['description']) ? trim($params['description']) : '';
                $content = isset($params['content']) ? trim($params['content']) : '';
                $data = [
                    'cate_thumb'  => $cate_thumb,
                    'description' => $description,
                    'content'     => $content,
                    'update_time' => time(),
                ];
                $where['goods_id'] = $id;
                $result = $this->model->where($where)->update($data);
                $msg = lang('EDIT') . lang($this->modelName);
                if ($result) {
                    $msg .= lang('SUCCESS');
                    $this->success($msg, url("index"), $id);
                } else {
                    $msg .= lang('FAIL');
                    $this->error($msg);
                }
            } else {
                parent::_assignInfo();
                return $this->fetch();
            }
        } else {
            $this->error("参数错误");
        }
    }

    //商品属性管理
    public function spec()
    {
        $params = $this->request->param();
        $id = intval($params['id']);
        $this->subMenu['menu'][] = [
            'name' => lang('规格属性管理'),
            'url'  => url('spec', ['id' => $id]),
        ];
        if ($id) {
            //取得商品详情
            $where = ['goods_id' => $id, 'is_del' => 0];
            if ($this->adminUser['store_id']) {
                $where['store_id'] = $this->adminUser['store_id'];
            }
            $goodsInfo = $this->model->where($where)->find();
            if (!$goodsInfo) {
                $this->error('商品不存在或删除');
            }
            $name = '编辑商品规格属性';
            if (IS_POST) {
                $dataSet = [];
                $specSns = isset($params['sku_sn']) ? $params['sku_sn'] : [];
                $minPrice = $maxPrice = $goodsStock = 0;
                $skuIds = isset($params['skuid']) ? $params['skuid'] : [];
                if (!empty($specSns) && is_array($specSns)) {
                    $specJson = $params['spec_json'];
                    $specPrice = $params['price'];
                    $specName = $params['spec_name'];
                    $specSku = $params['sku_stock'];
                    if (!$specJson) {
                        $this->error('规格异常');
                    }
                    //清空当前商品属性
                    $where = ['goods_id' => $id, 'is_del' => 0];
                    if ($skuIds) {
                        $where['sku_id'] = ['NOT IN', $skuIds];
                    }
                    db('goods_sku')->where($where)->update(['is_del' => 1, 'update_time' => time()]);
                    foreach ($specSns as $k => $v) {
                        $price = floatval($specPrice[$k]);
                        $stock = intval($specSku[$k]);
                        $minPrice = !$minPrice ? $price : min($minPrice, $price);
                        $maxPrice = !$maxPrice ? $price : max($maxPrice, $price);
                        if ($price < 0) {
                            $this->error('第' . ($k + 1) . '行,商品价格小于0');
                        }
                        if ($stock < 0) {
                            $this->error('第' . ($k + 1) . '行,商品库存小于0');
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
                            'goods_cate'            => intval($goodsInfo['goods_cate']),
                            'goods_type'            => $goodsInfo['goods_type'],
                            'sku_name'              => $specName[$k],
                            'sku_sn'                => trim($v),
                            'spec_json'             => $specJson[$k],
                            'sku_stock'             => $stock,
                            'spec_value'            => $specValue ? implode(';', $specValue) : '',
                            'price'                 => $price,
                            'install_price'         => floatval($goodsInfo['install_price']),
                            'stock_reduce_time'     => intval($goodsInfo['stock_reduce_time']),
                            'sample_purchase_limit' => intval($goodsInfo['sample_purchase_limit']),
                        ];
                        if ($skuIds) {
                            db('goods_sku')->where(['sku_id' => $skuIds[$k]])->update($data);
                        } else {
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
                    //更新商品属性
                    $goodsData = array(
                        'specs_json'  => trim($params['specs_json']),
                        'min_price'   => $minPrice,
                        'max_price'   => $maxPrice,
                        'goods_stock' => $goodsStock,
                    );
                    $this->model->where(['goods_id' => $id])->update($goodsData);
                    $this->success("商品属性修改成功!", url("index"), TRUE);
                } else {
                    //更新商品属性
                    $goodsData = array(
                        'specs_json' => '',
                        'max_price'  => $goodsInfo['min_price'],
                    );
                    $this->model->where(['goods_id' => $id])->update($goodsData);
                    db('goods_sku')->where(['goods_id' => $id, 'is_del' => 0, 'spec_json' => ['neq', ""]])->update(['is_del' => 1, 'update_time' => time()]);
                    $update = [
                        'is_del'    => 0,
                        'sku_stock' => $goodsInfo['goods_stock'],
                        'price'     => $goodsInfo['min_price'],
                    ];
                    db('goods_sku')->where(['goods_id' => $id, 'is_del' => 1, 'spec_json' => ['eq', ""]])->update($update);
                    $this->success("商品属性修改成功!", url("index"), TRUE);
                }
            } else {
                $this->assign("goods", $goodsInfo);
                //取得规格参数表
                $specList = db('goods_spec')->where(array('status' => 1, 'is_del' => 0, 'store_id' => $goodsInfo['store_id']))->order("sort_order")->select();
                if ($specList) {
                    foreach ($specList as $k => $v) {
                        $specList[$k]['spec_value'] = explode(',', $v['value']);
                    }
                }
                $this->assign("specList", $specList);
                //取得属性详情
                $where = ['goods_id' => $id, 'is_del' => 0, 'status' => 1, 'store_id' => $goodsInfo['store_id'], 'spec_json' => ['neq', ""]];
                $skuList = db('goods_sku')->where($where)->order("sku_id")->select();
                $this->assign("skuList", $skuList);
                return $this->fetch();
            }
        } else {
            $this->error("参数错误");
        }
    }
    
    /**
     * 属性选择弹窗页面
     */
    public function choosespec(){
        $info = $this->_assignInfo();
        $skus = $this->model->getGoodsSkus($info['goods_id'],$this->adminStore,false);
        if ($this->adminStore['store_type'] == STORE_DEALER) {
            $minMax = db('goods_sku_service')->fieldRaw("max(price_service+install_price_service) as max,min(price_service+install_price_service) as min")->where([
                'store_id'=>$this->channelId,
                'goods_id'=>$info['goods_id'],
                'is_del'=>0,
            ])->find();
        } elseif ($this->adminStore['store_type'] == STORE_SERVICE_NEW) {
            $minMax = db('goods_sku')->fieldRaw("max(price) as max,min(price) as min")->where([
                'store_id'=>$this->adminUser['factory_id'],
                'goods_id'=>$info['goods_id'],
                'is_del'=>0,
            ])->find();
        }elseif(in_array($this->adminUser['group_id'],[GROUP_E_COMMERCE_KEFU,GROUP_E_CHANGSHANG_KEFU])){
            $minMax = db('goods_sku')->fieldRaw("max(price+install_price) as max,min(price+install_price) as min")->where([
                'store_id'=>$this->adminUser['factory_id'],
                'goods_id'=>$info['goods_id'],
                'is_del'=>0,
            ])->find();
        }
        $priceTotal=$minMax['min'];
        if ($minMax['max'] > $minMax['min']) {
            $priceTotal.='~'.$minMax['max'];
        }
        $this->assign('price_total',$priceTotal);
        $this->assign('skus', is_array($skus) ? $skus : []);
        $info['default_sku_id'] = isset($skus[0]['sku_id']) ? $skus[0]['sku_id'] : 0;
        $info['specs'] = json_decode($info['specs_json'],true);
        $this->assign('info', $info);
        $this->import_resource(array(
        //  'script'=> 'jquery.jqzoom-core.js',
            'style' => 'goods.css,jquery.jqzoom.css',
        ));
        $this->view->engine->layout(false);
        return $this->fetch();
    }

    public function getSkuList()
    {
        $params = $this->request->param();
        $goodsId = isset($params['goods_id']) ? intval($params['goods_id']) : 0;
        if (!$goodsId) {
            $this->error('参数错误');
        }
        $where = [
            'is_del'   => 0,
            'status'   => 1,
            'goods_id' => $goodsId,
        ];
        $this->model = db('goods_sku');
        $this->getAjaxList($where, 'sku_id as id, sku_name as name');
    }

    function _getOrder()
    {
        $order = 'G.sort_order ASC,G.add_time desc';
        if ($this->adminUser['store_type'] == STORE_SERVICE_NEW) {
            $order = 'GS.sort_order ASC,GS.add_time desc,G.sort_order ASC,G.add_time desc';
        }
        return $order;
    }

    function _getField()
    {
        $field = 'G.*, (CASE WHEN G.goods_stock <= G.stock_warning_num THEN 1 ELSE 0 END) as warning, C.name as cate_name';
        if ($this->adminUser['store_type'] == STORE_SERVICE_NEW) {
            $field .= ',GS.min_price_service,GS.max_price_service,GS.status status_service,GS.sales_service,GS.stock';
        }
        return $field;
    }

    function _getAlias()
    {
        return 'G';
    }

    function _getJoin()
    {
        $join[] = ['goods_cate C', 'C.cate_id = G.cate_id', 'INNER'];
        if ($this->adminUser['store_type'] == STORE_SERVICE_NEW) {
            $join[] = ['goods_service GS', 'GS.goods_id = G.goods_id', 'INNER'];
        }
        return $join;
    }

    function _getWhere()
    {
        $params = $this->request->param();
        $where = [
            ['G.is_del', '=', 0],
//             ['G.activity_id', '=', 0],
        ];

        if ($this->adminUser['store_type'] == STORE_SERVICE_NEW) {
            $where[] = ['GS.store_id', '=', $this->adminUser['store_id']];
        } else {
            $where[] = ['G.store_id', '=', $this->adminUser['store_id']];
        }
        if ($params) {
            $name = isset($params['name']) ? trim($params['name']) : '';
            if ($name) {
                $where[] = ['G.name', 'like', '%' . $name . '%'];
            }
            $sn = isset($params['sn']) ? trim($params['sn']) : '';
            if ($sn) {
                $where[] = ['G.goods_sn', 'like', '%' . $sn . '%'];
            }
            $goodsType = isset($params['goods_type']) ? intval($params['goods_type']) : '';
            if ($goodsType) {
                $where[] = ['G.goods_type', '=', $goodsType];
            }
        }
        return $where;
    }

    function _assignAdd()
    {
        $this->_getCategorys();
        parent::_assignAdd();
    }

    function _assignInfo($id = 0)
    {
        $info = parent::_assignInfo($id);
        $sid = $info && $info['store_id'] ? $info['store_id'] : 0;
        $this->assign('store_type', $this->adminStore['store_type']);
        $this->_getCategorys($sid);
        $skuinfo = db('goods_sku')->where(['goods_id' => $id, 'is_del' => 0, 'status' => 1])->find();
        $info['skuinfo'] = $skuinfo;
        $info['imgnum'] = isset($info['imgs']) && $info['imgs'] ? count(json_decode($info['imgs'])) : 0;
        $info['imgs'] = isset($info['imgs']) && $info['imgs'] ? json_decode($info['imgs'], TRUE) : [];
        $this->assign('info', $info);
        $store = new \app\common\controller\Store();
        $store->_getFactorys();
        $this->_assignSpec($id);
        if ($this->adminUser['store_type'] == STORE_SERVICE_NEW) {
            $info['status'] = GoodsService::where(['is_del'=>0,'goods_id'=>$id])->value('status');
        }
        return $info;
    }

    function _assignSpec($id = 0)
    {
        //取得规格参数表
        $where = [
            'G.status' => 1,
            'G.is_del' => 0,
        ];
        if ($this->adminStore['store_type'] == STORE_SERVICE_NEW) {
            $where['G.store_id'] = $this->adminStore['factory_id'];
        } else {
            $where['G.store_id'] = $this->adminStore['store_id'];
        }
        $specList = db('goods_spec')->alias('G')->where($where)->order("G.sort_order")->select();
        if ($specList) {
            foreach ($specList as $k => $v) {
                $specList[$k]['spec_value'] = explode(',', $v['value']);
            }
        }
        $this->assign("specList", $specList);
        //取得属性详情
        if ($id) {
            if ($this->adminStore['store_type'] == STORE_SERVICE_NEW) {//服务商
                $field = 'GS.sku_id,GS.sku_sn,GS.sku_name,GS.price,GSS.price_service,GSS.install_price_service,GSS.sort_order sort_order_service,GS.install_price,GS.sku_stock';
                $where = [
                    'GS.goods_id'  => $id,
                    'GS.is_del'    => 0,
                    'GS.status'    => 1,
                    'GS.store_id'  => $this->adminStore['factory_id'],
                    //'GS.spec_json' => ['NEQ', ''],
                ];
                $joinOn = 'GSS.sku_id = GS.sku_id AND GSS.is_del = 0 AND GSS.`status` = 1 AND GSS.store_id =' . $this->adminStore['store_id'];
                $skuList = db('goods_sku')->alias('GS')->field($field)->where($where)->join('goods_sku_service GSS', $joinOn, 'INNER')->select();
            } else {//厂商
                $where = [
                    'goods_id' => $id,
                    'is_del' => 0,
                    'status' => 1,
                    'store_id' => $this->adminStore['store_id'],
                    //'spec_json' => ['neq', ""]
                ];
                $skuList = db('goods_sku')->where($where)->order("sku_id")->select();
            }
            //p($skuList);
            $this->assign("skuList", $skuList);
        }
    }

    function _getData()
    {
        $data = parent::_getData();
        $params = $this->request->param();
        $pkId = isset($params['id']) ? intval($params['id']) : 0;
        $cateId = isset($params['cate_id']) ? intval($params['cate_id']) : 0;
        $name = isset($params['name']) ? trim($params['name']) : '';
        $goodsCate = isset($params['goods_cate']) ? intval($params['goods_cate']) : 0;
        $goodsType = isset($params['goods_type']) ? intval($params['goods_type']) : 0;
        $installPrice = isset($params['install_price']) ? floatval($params['install_price']) : 0;
        $samplePurchaseLimit = isset($params['sample_purchase_limit']) ? intval($params['sample_purchase_limit']) : 0;
        $stockReduceTime = isset($params['stock_reduce_time']) ? intval($params['stock_reduce_time']) : 0;

        $specJson = isset($params['spec_json']) ? $params['spec_json'] : [];
        $specPrice = isset($params['price']) ? $params['price'] : [];
        $skuSn = isset($params['sku_sn']) ? $params['sku_sn'] : [];
        $specName = isset($params['spec_name']) ? $params['spec_name'] : [];
        $specSku = isset($params['sku_stock']) ? $params['sku_stock'] : [];

        $goodsSn = $data['goods_sn'];
        $count = count($skuSn);
        if ($count == 0) {
            $this->error('请填写商品价格等信息');
        }
        $goodsSn = $goodsSn ? $goodsSn : ($count == 1 ? $skuSn[0] : '');
        if (!$goodsSn) {
            $this->error('商品编码不能为空');
        }

        if (!$cateId) {
            $this->error('请选择商品分类');
        }
        if ($this->adminUser['store_id']) {
            $data['store_id'] = $this->adminUser['store_id'];
        } else {
            $storeId = isset($params['store_id']) && $params['store_id'] ? intval($params['store_id']) : 0;
            if (!$storeId) {
                $this->error('请选择厂商');
            }
            $data['store_id'] = $storeId;
        }
        if ($goodsSn) {
            $where = ['is_del' => 0];
            $where['goods_sn'] = $goodsSn;
            if ($pkId) {
                $where['goods_id'] = ['neq', $pkId];
            }
            $where['store_id'] = $data['store_id'];
            $exist = $this->model->where($where)->find();
            if ($exist) {
                $this->error('商品编码已存在，请重新填写');
            }
        }
        if (!$name) {
            $this->error('请输入商品名称');
        }
        //         if (!$specJson) {
        //             $this->error('请选择商品规格');
        //         }
        //         if (!$goodsCate || !isset($this->goodsCates[$goodsCate])) {
        //             $this->error('请选择商品类别');
        //         }
        //         if (!$goodsType || !isset($this->goodsTypes[$goodsType])) {
        //             $this->error('请选择商品类型');
        //         }
        $goodsType = $data['goods_type'] = 1;
        $goodsCate = $data['goods_cate'] = 1;
        if ($goodsType == 1) {
            //             if ($installPrice <= 0) {
            //                 $this->error('请填写安装费用');
            //             }
            $data['sample_purchase_limit'] = 0;
        } elseif ($goodsType == 2) {
            if ($samplePurchaseLimit <= 0) {
                $this->error('请填写样品限购数量');
            }
            $data['install_price'] = 0;
        }
        if (!$stockReduceTime || !isset($this->stockReduces[$stockReduceTime])) {
            $this->error('请选择库存计数类型');
        }
        if (!empty($skuSn) && is_array($skuSn)) {
            foreach ($skuSn as $k => $v) {
                $price = floatval($specPrice[$k]);
                $stock = intval($specSku[$k]);
                $ssn = trim($skuSn[$k]);
                if ($price < 0) {
                    $this->error('第' . ($k + 1) . '行,商品价格小于0');
                }
                if ($stock < 0) {
                    $this->error('第' . ($k + 1) . '行,商品库存小于0');
                }
                if ($ssn == '') {
                    $this->error('第' . ($k + 1) . '行,商品编码为空');
                }
            }
        }
        if ($pkId) {
            $skuinfo = db('goods_sku')->where(['goods_id' => $pkId, 'is_del' => 0, 'status' => 1, /*'spec_json' => ['neq', ""]*/])->find();
            if ($skuinfo) {
                unset($data['goods_stock']);
            }
        }
        $data['thumb'] = isset($data['thumb']) && $data['thumb'] ? $data['thumb'] : (isset($data['imgs']) && $data['imgs'] ? $data['imgs'][0] : '');
        if (isset($data['imgs']) && $data['imgs']) {
            $data['imgs'] = array_filter($data['imgs']);
            $data['imgs'] = $data['imgs'] ? array_unique($data['imgs']) : [];
            $data['imgs'] = $data['imgs'] ? json_encode($data['imgs']) : '';
        }
        if (!$pkId) {
            $data['content'] = '';
        }
        return $data;
    }

    function _goodsSpec($id = 0, $data = [])
    {
        $dataSet = [];
        $specSns = isset($data['sku_sn']) ? $data['sku_sn'] : [];
        $minPrice = $maxPrice = $goodsStock = 0;
        $skuIds = isset($data['skuid']) ? $data['skuid'] : [];
        if (!empty($specSns) && is_array($specSns)) {
            $specJson = $data['spec_json'] ?? [];
            $specPrice = $data['price'];
            $installPrice = $data['install_price'];
            $specName = $data['spec_name'] ?? [];
            $specSku = $data['sku_stock'];

            $skuIdsExist=[];
            foreach ($specSns as $k=>$v) {
                $where=[];
                if (isset($skuIds[$k]) && $skuIds[$k]) {
                    $where['sku_id'] = $skuIds[$k];
                } else {
                    $where['goods_id'] = $id;
                    $where['is_del'] = 0;
                    $where['sku_name'] = $specName[$k] ?? $data['name'];
                }
                $sku=GoodsSku::where($where)->find();

                $stock = intval($specSku[$k]);
                $goodsStock += $stock;
                $specValue = '';
                if ($specJson[$k]) {
                    $specValue = json_decode($specJson[$k], true);
                    if ($specValue) {
                        $specValue=implode(';',array_values($specValue));
                    }
                }
                $price = floatval($specPrice[$k]);
                $install = floatval($installPrice[$k]);
                $minPrice = !$minPrice ? $price : min($minPrice, $price);
                $maxPrice = !$maxPrice ? $price : max($maxPrice, $price);
                $skuData = [
                    'goods_cate'            => intval($data['goods_cate']),
                    'goods_type'            => $data['goods_type'],
                    'sku_name'              => $specName[$k] ?? $data['name'],
                    'sku_sn'                => trim($v),
                    'spec_json'             => $specJson[$k] ?? '',
                    'sku_stock'             => $stock,
                    'spec_value'            => $specValue,
                    'price'                 => $price,
                    'install_price'         => $install,
                    'stock_reduce_time'     => intval($data['stock_reduce_time']),
                    'sample_purchase_limit' => intval($data['sample_purchase_limit']),
                    'store_id'              => $data['store_id'],
                    'goods_id'              => $id,
                    'is_del'                => 0,
                    'status'                => 1,
                ];
                $model=new GoodsSku();
                $where=[];
                if (!empty($sku)) {
                    $where=['sku_id'=>$sku['sku_id']];
                }
                $result=$model->save($skuData,$where);
                if ($result === false) {
                    $this->error('系统错误，保存失败！');
                    return false;
                }
                $skuIdsExist[]=$model->sku_id;
            }
            //更新商品属性
            $goodsData = array(
                'specs_json'  => trim($data['specs_json']),
                'min_price'   => $minPrice,
                'max_price'   => $maxPrice > $minPrice ? $maxPrice : $minPrice,
                'goods_stock' => $goodsStock,
            );
            $this->model->where(['goods_id' => $id])->update($goodsData);
            //删除多余的SKU
            GoodsSku::where([
                'sku_id'   => ['NOT IN', $skuIdsExist],
                'goods_id' => $id,
            ])->update(['is_del' => 1, 'update_time' => time()]);
            return true;
        }
    }

    function _afterAdd($pkId = 0, $data = [])
    {
        if ($pkId) {
            if (isset($data['sku_sn']) && $data['sku_sn'] != '') {
                $this->_goodsSpec($pkId, $data);
            }
            setcookie("goodsUpload", NULL);
        }
        return TRUE;
    }

    function _afterEdit($pkId = 0, $data = [])
    {
        if ($pkId) {
            if (isset($data['spec_json']) && $data['spec_json'] != '') {
                $this->_goodsSpec($pkId, $data);
            } else {
                //修改商品属性
                $update = [
                    'goods_cate'            => intval($data['goods_cate']),
                    'goods_type'            => intval($data['goods_type']),
                    //'install_price' => floatval($data['install_price']),
                    'stock_reduce_time'     => intval($data['stock_reduce_time']),
                    'sample_purchase_limit' => intval($data['sample_purchase_limit']),
                ];
                $result = db('goods_sku')->where(['goods_id' => $pkId, 'is_del' => 0, 'status' => 1])->update($update);

                //更新商品属性
                $goodsData = array(
                    'specs_json' => '',
                    'max_price'  => $data['min_price'],
                );
                $this->model->where(['goods_id' => $pkId])->update($goodsData);
                db('goods_sku')->where(['goods_id' => $pkId, 'is_del' => 0, 'spec_json' => ['neq', ""]])->update(['is_del' => 1, 'update_time' => time()]);
                $update = [
                    'sku_sn'    => $data['goods_sn'],
                    'is_del'    => 0,
                    'sku_stock' => intval($data['goods_stock']),
                    'price'     => $data['min_price'],
                ];
                db('goods_sku')->where(['goods_id' => $pkId, 'is_del' => 0, 'spec_json' => ['eq', ""]])->update($update);
            }
            setcookie("editgoods" . $pkId, NULL);
        }
        return TRUE;
    }

    /**
     * 列表搜索配置
     */
    function _searchData()
    {
        $types = goodstype();
        $this->assign('types', $types);
        $search = [
            ['type' => 'input', 'name' => 'name', 'value' => '商品名称', 'width' => '30'],
            //             ['type' => 'select', 'name' => 'goods_type', 'options'=>'types', 'default_option' => '==商品类型=='],
            ['type' => 'input', 'name' => 'sn', 'value' => '商品编号', 'width' => '30'],
        ];
        return $search;
    }

    /**
     * 列表项配置
     */
    function _tableData()
    {
        $table = parent::_tableData();
        $btnArray = [];
        $btnArray = ['text' => '商品规格', 'action' => 'spec', 'icon' => 'setting', 'bgClass' => 'bg-yellow'];
        $table['actions']['button'][] = $btnArray;
        $table['actions']['button'][] = ['text' => '下架','action'=> 'condition','condition'=>['action'=>'offline','rule'=>'$vo["status"] == 1'], 'js-action' => TRUE, 'icon' => 'bottom', 'bgClass' => 'bg-red'];
        $table['actions']['button'][] = ['text' => '上架','action'=> 'condition','condition'=>['action'=>'offline','rule'=>'$vo["status"] == 0'], 'js-action' => TRUE, 'icon' => 'top', 'bgClass' => 'bg-green'];
        $table['actions']['width'] = '240';

        foreach ($table as $key => $value) {
            if ($this->adminUser['store_type'] == STORE_SERVICE_NEW) {
                if (isset($value['value']) && $value['value'] == 'price') {
                    $table[$key]['title'] = '厂商价格';
                }
                if (isset($value['value']) && $value['value'] == 'goods_stock') {
                    $table[$key]['title'] = '厂商库存';
                }
            } else if (isset($value['value']) && $value['value'] == 'price_store') {
                unset($table[$key]);
            } else if (isset($value['value']) && $value['value'] == 'sales_service') {
                unset($table[$key]);
            } else if (isset($value['value']) && $value['value'] == 'stock') {
                unset($table[$key]);
            }
            if (isset($value['value']) && $value['value'] == 'goods_stock') {
                $table[$key]['warning'] = TRUE;
                //break;
            }
            if (isset($value['value']) && $value['value'] == 'status') {
                $table[$key]['title'] = '是否上架';
                $table[$key]['width'] = 80;
                $table[$key]['function'] = 'yorn';
            }
        }
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

    public function sync_goods(Request $request)
    {
        if (!in_array($this->adminUser['admin_type'], [ADMIN_SERVICE_NEW])) {
            $this->error = lang('NO_OPERATE_PERMISSION');
            return FALSE;
        }
        $where = [
            'G.is_del'   => 0,
            'G.status'   => 1,
            'G.store_id' => $this->adminUser['factory_id'],
            'G.e_commerce'   => 0,
            //'G.activity_id' => 0,
        ];
        if (IS_POST) {
            $ids = $request->param('id', 'intval');
            if (empty($ids)) {
                $this->error("请选择需要导入的商品！");
            }
            $ids = array_unique($ids);
            foreach ($ids as $k => $v) {
                $field = 'G.goods_id,G.store_id factory_id,G.goods_sn,G.min_price,G.max_price,G.specs_json,GS.id,GS.store_id,GS.min_price_service,GS.max_price_service';
                $on = 'GS.goods_id=G.goods_id AND GS.is_del=0 AND GS.status=1 AND GS.store_id=' . $this->adminStore['store_id'];
                $goods = $this->model->alias('G')->field($field)->join('goods_service GS', $on, 'left')->where($where)->find($v);
                if (empty($goods)) {
                    continue;
                }
                $data = [
                    'goods_id'           => $goods['goods_id'],
                    'factory_id'         => $this->adminFactory['store_id'],
                    'store_id'           => $this->adminStore['store_id'],
                    'min_price_service'  => $goods['min_price'],
                    'max_price_service'  => $goods['max_price'],
                    'specs_json_service' => $goods['specs_json'],
                ];
                $where = [];
                if (!empty($goods['id'])) {
                    $where = ['id' => $goods['id']];
                }
                $goodService = new GoodsService();
                $result = $goodService->save($data, $where);
                if ($result!==FALSE) {//导入商品规格
                    $skus = db('goods_sku')->where([
                        'store_id' => $this->adminUser['factory_id'],
                        'goods_id' => $goods['goods_id'],
                        'is_del'   => 0,
                        'status'   => 1,
                    ])->select();
                    if (empty($skus)) {
                        continue;
                    }
                    foreach ($skus as $sku) {
                        $skuModel = new GoodsSkuService();
                        $whereSku=[
                            'store_id' => $this->adminStore['store_id'],
                            'goods_id' => $goods['goods_id'],
                            'sku_id'   => $sku['sku_id']
                        ];
                        $skuService=GoodsSkuService::where($whereSku)->find();
                        if (empty($skuService)) {
                            $whereSku=[];
                        }
                        $skuModel->save([
                            'factory_id'            => $this->adminFactory['store_id'],
                            'store_id'              => $this->adminStore['store_id'],
                            'goods_id'              => $goods['goods_id'],
                            'sku_id'                => $sku['sku_id'],
                            'price_service'         => $sku['price'],
                            'install_price_service' => 0
                        ],$whereSku);
                    }
                }
            }
            $this->success("导入成功！");
        } else {
            $field = 'G.goods_id,G.name,G.min_price,G.max_price,G.specs_json,G.goods_sn';
            $join=[
                ['goods G','G.goods_id=GS.goods_id','INNER'],
                ['goods_sku_service GSS','GS.sku_id= GSS.sku_id AND GSS.is_del=0 AND GSS.store_id='.$this->adminUser['store_id'],'LEFT'],
            ];
            $where = [
                'G.status'     => 1,
                'G.is_del'     => 0,
                'GS.status'    => 1,
                'GS.is_del'    => 0,
                'G.e_commerce' => 0,
                'G.store_id'   => $this->adminUser['factory_id'],
                'GSS.sku_id'   => null,
            ];
            $query=db('goods_sku')
                ->alias('GS')
                ->field($field)
                ->join($join)
                ->where($where)
                //->whereNull('GSS.sku_id')
                ->group('GS.goods_id')
                ->paginate($this->perPage, false,['query' => input('param.')]);
            $list = $query->items();
            $list = array_map(function ($item) {
                $specs = json_decode($item['specs_json'], true);
                $html = '';
                if ($specs) {
                    foreach ($specs as $spec) {
                        $html .= $spec['specname'] . '：' . implode('、', array_values($spec['list'])) . '；';
                    }
                    $item['specs'] = rtrim($html, '；');
                }
                return $item;
            }, $list);
            $page = $query->render();
            $this->assign('list', $list);
            $this->assign('page', $page);
            return $this->fetch();
        }
    }

    public function offline()
    {
        $id = $this->request->param('id');
        if (empty($id)) {
            $this->error('参数错误');
        }
        $storeId = $this->adminStore['store_id'];
        $goods = GoodsService::where(['is_del' => 0, 'goods_id' => $id, 'store_id' => $storeId])->find();
        if (empty($goods)) {
            $this->error('商品不存在或已删除');
        }

        $status = $goods->status == 0 ? 1 : 0;
        $goods->status = $status;
        //$statusTxt=$status==1?'上架':'下架';
        $result = $goods->save();
        if ($result === false) {
            $this->error('系统故障');
        }
        GoodsSkuService::update(['status' => 0], ['goods_id' => $id, 'store_id' => $storeId, 'is_del' => 0]);
        $this->success('操作成功');
    }

}