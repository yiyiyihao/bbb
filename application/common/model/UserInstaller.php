<?php
namespace app\common\model;
use think\Model;

/**
 * 工程师数据模型相关业务处理
 * @author chany
 * 
 */
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
    
    public function getInstallerStatus($storeId = 0, $factoryId = 0)
    {
        $flag = TRUE; //默认需要厂商审核
        //状态(0待审核 1审核成功 -1厂商审核中 -2厂商拒绝 -3服务商审核中 -4服务商拒绝)
        if ($storeId > 0) {
            $config = get_store_config($storeId, TRUE);
            //默认需要服务商审核
            if (!isset($config['installer_check']) || $config['installer_check'] > 0) {
                $checkStatus = -3;
                $flag = FALSE;
            }
        }
        if ($flag && $factoryId) {
            //不需要服务商审核,判断是否需要厂商审核
            $config = get_store_config($factoryId, TRUE);
            //默认需要厂商审核
            if (!isset($config['installer_check']) || $config['installer_check'] > 0) {
                $checkStatus = -1;
            }else {
                //服务商和厂商都不审核,直接通过
                $checkStatus = 1;
            }
        }
        return $checkStatus;
    }
    
    /**
     * 更新指定工程师综合得分
     */
    public function scoreUpdate($installerId,$score = 0){
        $where = [
            'installer_id'  => $installerId,
//             'is_del'        => 0,
        ];
        $info  = $this->where($where)->find();
        if($info['score'] && $info['score'] > 0){
            $score = ($score + $info['score'])/2;
        }
        $data = [
            'score' => $score,
        ];
        $this->update($data,$where);
    }
    
    //添加工程师评价
    public function assessAdd($installerId,$configId = '',$value = ''){
        $scoreModel = db('user_installer_score');
        $where = [
            'installer_id'  => $installerId,
            'config_id'     => $configId,
        ];
        //判断该工程师 对应服务项是否有评分
        $info = $scoreModel->where($where)->find();
        if($info){
            //原有总分加本次得分,取平均值,更新数据
            $value = ($info['value'] + $value)/2;
            $data = [
                'value'         => $value,
                'update_time'   => time(),
            ];
            $scoreModel->where($where)->update($data);
        }else{
            //新增记录
            $data = [
                'installer_id'  => $installerId,
                'config_id'     => $configId,
                'value'         => $value,
                'add_time'      => time(),
                'update_time'   => time(),
            ];
            $scoreModel->insert($data);
        }
    }
    //获取工程师评价
    public function assessGet($installerId,$configId = ''){
        #TODO 如果configId 为空 代表取所有评分 如果有 取该服务项评分
    }
    //添加工程师
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