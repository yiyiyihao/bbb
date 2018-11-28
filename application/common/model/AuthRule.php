<?php
namespace app\common\model;
use think\Model;

class AuthRule extends Model
{
	public $error;
	protected $pk = 'id';
	protected $table;
	
	protected $field = true;
	//自定义初始化
	protected function initialize()
	{
	    $this->table = $this->config['prefix'].'auth_rule';
	    parent::initialize();
	}
	
	//取得规则列表
	static function getRuleList(){	    
// 	    cache('authRule', null);
	    //检查缓存中是否有菜单配置
	    $authRule = cache('authRule');
	    if(!$authRule){
	        $where = [
	            'menustatus'    => 1,
	            'status'        => 1,
	            'is_del'        => 0,
	        ];
	        $authRule = db('auth_rule')->where($where)->order('sort_order')->select();
	        cache('authRule', $authRule);
	    }
	    return $authRule;
	}
	//取得所有权限列表
	static function getALLRule(){
		$allRules = cache('allRules');
	    if(!$allRules){
	        $where = [
	            'status'        => 1,
	            'is_del'        => 0,
	        ];
	        $allRules = db('auth_rule')->where($where)->order('sort_order')->select();
	        cache('allRules', $allRules);
	    }
	    return $allRules;
	}
}