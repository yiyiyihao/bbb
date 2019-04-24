<?php
namespace app\open\controller\v10\goods;

use app\open\controller\Base;
use think\Request;

class Spec extends Base
{
    private $specsModel;
    
    public function __construct(Request $request)
    {
        parent::__construct();
        $this->specsModel = model('goods_spec');
        /**
         * Error 开头:002200
         */
    }
    public function list()
    {
        $result = $this->checkStoreManager();
        if ($this->error) {
            return $result;
        }
        $field = 'spec_id as specid, name as specname, value as list, status';
        $where = [
            ['udata_id', '=', $this->user['udata_id']],
            ['is_del', '=', 0],
        ];
        $result = $this->getModelList($this->specsModel, $where, $field, 'add_time ASC');
        if ($result && $result['list']) {
            foreach ($result['list'] as $key => $value) {
                $result['list'][$key]['list'] = $value ? explode(',', $value['list']) : [];
            }
        }
        return $this->dataReturn(0, 'ok', $result);
    }
    public function info()
    {
        $info = $this->_verifySpec(FALSE, 'spec_id as specid, name as specname, value as list, status');
        if ($this->error) {
            return $info;
        }
        if ($info && $info['list']) {
            $info['list'] = $info['list'] ? explode(',', $info['list']) : [];
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
        $result = $this->specsModel->save($data);
        if ($result === FALSE) {
            return $this->dataReturn(-1, 'system_error');
        }
        return $this->dataReturn(0, 'ok', ['specid' => $this->specsModel->spec_id]);
    }
    public function edit()
    {
        $info = $this->_verifySpec();
        if ($this->error) {
            return $info;
        }
        $parentId = isset($this->postParams['parent_id']) ? intval($this->postParams['parent_id']) : '';
        $data = $this->_checkField($info);
        if ($this->error) {
            return $data;
        }
        $result = $this->specsModel->save($data, ['spec_id' => $info['spec_id']]);
        if ($result === FALSE) {
            return $this->dataReturn(-1, 'system_error');
        }
        return $this->dataReturn(0, 'ok');
    }
    public function del()
    {
        $info = $this->_verifySpec();
        if ($this->error) {
            return $info;
        }
        $result = $this->specsModel->save(['is_del' => 1], ['spec_id' => $info['spec_id']]);
        if ($result === FALSE) {
            return $this->dataReturn(-1, 'system_error');
        }
        return $this->dataReturn(0, 'ok');
    }
    
    /**
     * 验证表单信息
     * @param int $specId
     * @param string $field
     * @return \think\response\Json|array
     */
    private function _verifySpec($specId = 0, $field = '')
    {
        $result = $this->checkStoreManager();
        if ($this->error) {
            return $result;
        }
        if (!$specId) {
            $specId = isset($this->postParams['specid']) ? intval($this->postParams['specid']) : '';
        }
        if (!$specId) {
            return $this->dataReturn('002200', 'missing specid');
        }
        $field = $field ? $field : '*';
        $info = $this->specsModel->field($field)->where('spec_id', $specId)->where('udata_id', $this->user['udata_id'])->where('is_del', 0)->find();
        if (!$info) {
            return $this->dataReturn('002201', 'spec not exist');
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
        $value = isset($this->postParams['list']) ? $this->postParams['list'] : [];
        if (!$name) {
            return $this->dataReturn('002202', 'missing name');
        }
        if (!$value) {
            return $this->dataReturn('002203', 'missing list');
        }
        if (!is_array($value)) {
            return $this->dataReturn('002204', 'invalid list');
        }
        //判断规格名称是否存在
        $where = [
            ['name', '=', $name],
            ['status', '=', 1],
            ['is_del', '=', 0],
            ['udata_id', '=', $this->user['udata_id']],
        ];
        if ($info) {
            $where[] = ['spec_id', '<>', $info['spec_id']];
        }
        $exist = $this->specsModel->where($where)->find();
        if ($exist) {
            return $this->dataReturn('002205', 'name exist');
        }
        $return =  [
            'name'  => $name,
            'value' => $value ? implode(',', $value) : '',
        ];
        return $return;
    }
}