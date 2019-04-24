<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/3/11 0011
 * Time: 15:11
 */

namespace app\open\controller\v10\goods;

use app\open\controller\Base;
use think\Request;

class Cate extends Base
{
    private $cateModel;
    
    public function __construct(Request $request)
    {
        parent::__construct();
        $this->cateModel = model('goods_cate');
        /**
         * Error 开头:002100
         */
    }
    public function list()
    {
        $result = $this->checkStoreManager();
        if ($this->error) {
            return $result;
        }
        $parentId = isset($this->postParams['parent_id']) ? intval($this->postParams['parent_id']) : '';
        if ($parentId) {
            $parent = $this->_verifyCate($parentId, '*');
            if ($this->error) {
                return $parent;
            }
        }
        $field = 'cate_id, name, parent_id';
        $where = [
            ['udata_id', '=', $this->user['udata_id']],
            ['is_del', '=', 0],
        ];
        if ($parentId) {
            $where[] = ['parent_id', '=', $parentId];
        }
        $result = $this->getModelList($this->cateModel, $where, $field, 'add_time ASC');
        return $this->dataReturn(0, 'ok', $result);
    }
    public function info()
    {
        $info = $this->_verifyCate(FALSE, 'cate_id, name, parent_id');
        if ($this->error) {
            return $info;
        }
        return $this->dataReturn(0, 'ok', $info);
    }
    public function add()
    {
        $data = $this->_checkField();
        if ($this->error) {
            return $data;
        }
        $data['udata_id'] = $this->user['udata_id'];
        $data['store_id'] = $this->user['factory_id'];
        $result = $this->cateModel->save($data);
        if ($result === FALSE) {
            return $this->dataReturn(-1, 'system_error');
        }
        return $this->dataReturn(0, 'ok', ['cate_id' => $this->cateModel->cate_id]);
    }
    public function edit()
    {
        $info = $this->_verifyCate();
        if ($this->error) {
            return $info;
        }
        $data = $this->_checkField($info);
        if ($this->error) {
            return $data;
        }
        $result = $this->cateModel->save($data, ['cate_id' => $info['cate_id']]);
        if ($result === FALSE) {
            return $this->dataReturn(-1, 'system_error');
        }
        return $this->dataReturn(0, 'ok');
    }
    public function del()
    {
        $info = $this->_verifyCate();
        if ($this->error) {
            return $info;
        }
        $result = $this->cateModel->save(['is_del' => 1], ['cate_id' => $info['cate_id']]);
        if ($result === FALSE) {
            return $this->dataReturn(-1, 'system_error');
        }
        return $this->dataReturn(0, 'ok');
    }
    
    /**
     * 验证表单信息
     * @param int $cateId
     * @param string $field
     * @return \think\response\Json|array
     */
    private function _verifyCate($cateId = 0, $field = '')
    {
        $result = $this->checkStoreManager();
        if ($this->error) {
            return $result;
        }
        if (!$cateId) {
            $cateId = isset($this->postParams['cate_id']) ? intval($this->postParams['cate_id']) : '';
        }
        if (!$cateId) {
            return $this->dataReturn('002100', 'missing cate_id');
        }
        $field = $field ? $field : '*';
        $info = $this->cateModel->field($field)->where('cate_id', $cateId)->where('udata_id', $this->user['udata_id'])->where('is_del', 0)->find();
        if (!$info) {
            return $this->dataReturn('002101', 'cate not exist');
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
        $parentId = isset($this->postParams['parent_id']) ? intval($this->postParams['parent_id']) : '';
        if (!$name) {
            return $this->dataReturn('002102', 'missing name');
        }
        if ($parentId) {
            $where = [
                ['cate_id', '=', $parentId],
                ['status', '=', 1],
                ['is_del', '=', 0],
                ['udata_id', '=', $this->user['udata_id']],
            ];
            $exist = $this->cateModel->where($where)->find();
            if (!$exist) {
                return $this->dataReturn('002103', 'cate not exist');
            }
        }
        //判断分类名称是否存在
        $where = [
            ['name', '=', $name],
            ['status', '=', 1],
            ['is_del', '=', 0],
            ['udata_id', '=', $this->user['udata_id']],
        ];
        if ($info) {
            $where[] = ['cate_id', '<>', $info['cate_id']];
        }
        $exist = $this->cateModel->where($where)->find();
        if ($exist) {
            return $this->dataReturn('002104', 'name exist');
        }
        $return =  [
            'name'      => $name,
            'parent_id'  => $parentId,
        ];
        return $return;
    }
}