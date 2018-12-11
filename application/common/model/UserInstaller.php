<?php
namespace app\common\model;
use think\Model;

class UserInstaller extends Model
{
    public $error;
    protected $fields;
    protected $pk = 'installer_id';
    
    //自定义初始化
    protected function initialize()
    {
        parent::initialize();
    }
    public function save($data = [], $where = [], $sequence = null)
    {
        parent::checkBeforeSave($data, $where);
        if (!$this->checkBeforeSave($data, $where)) {
            return false;
        }
        $flag = $this->exists;
        $result = $installerId = parent::save($data, $where, $sequence);
        if (!$flag) {
            $no = $this->_getJobNo();
            $this->save(['job_no' => $no], ['installer_id' => $installerId]);
        }
        return $result;
    }
    /**
     * 生成安装工程师工号
     * @return string
     */
    private function _getJobNo()
    {
        $no = get_nonce_str(8, 2);
        //判断售后工程师工号是否存在
        $info = $this->where(['job_no' => $no])->find();
        if ($info){
            return $this->_getJobNo();
        }else{
            return $no;
        }
    }
}