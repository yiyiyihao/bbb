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
	static function getRuleList($domain = config('app.admin_domain')){
	    //检查缓存中是否有菜单配置
	    $authRule = cache($domain.'authRule');
	    $module = $domain;
	    switch ($domain){
	        case config('app.admin_domain'):
	            $module = 'admin';
	            break;
	        default:
	            $module = 'factory';
	            break;
	    }
	    if(!$authRule){
	        $where = [
	            'module'        => $module,
	            'menustatus'    => 1,
	            'parent_id'     => ['neq',0],
	            'status'        => 1,
	            'is_del'        => 0,
	        ];
	        $authRule = db('auth_rule')->where($where)->order('sort_order')->column('*','id');
	        cache($domain.'authRule', $authRule);
	    }
	    return $authRule;
	}
	//取得所有权限列表
	static function getALLRule($domain = config('app.admin_domain')){
	    $allRules = cache($domain.'allRules');
	    $module = $domain;
	    switch ($domain){
	        case config('app.admin_domain'):
	            $module = 'admin';
	            break;
	        default:
	            $module = 'factory';
	            break;
	    }
	    if(!$allRules){
	        $where = [
	            'module'        => $module,
	            'parent_id'     => ['neq',0],
	            'status'        => 1,
	            'is_del'        => 0,
	        ];
	        $allRules = db('auth_rule')->where($where)->order('sort_order')->column('*','id');
	        cache($domain.'allRules', $allRules);
	    }
	    return $allRules;
	}
}