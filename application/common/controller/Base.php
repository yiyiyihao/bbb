<?php
namespace app\common\controller;
use think\Controller;
//公共处理
class Base extends Controller
{
	//系统预处理方法
	public function __construct()
    {
    	parent::__construct();
    	$this->initBase();
    }
    protected function initStoreConfig($storeId = 0, $merge = FALSE)
    {
        $factory = db('store')->where(['store_id' => $storeId, 'is_del' => 0])->find();
        $config = $factory['config_json'] ? json_decode($factory['config_json'], 1) : [];
        if ($merge) {
            //获取系统默认配置
            $default = $this->getSystemConfig('system_default');
            $sysConfig = $default['config_value'];
            
            if ($sysConfig) {
                foreach ($sysConfig as $key => $value) {
                    if (!isset($config[$key])) {
                        $config[$key] = $value;
                    }
                }
            }
        }
        return $config;
    }
    protected function getSystemConfig($key = '')
    {
        //获取系统默认配置
        $where = [
            'is_del' => 0, 
            'status' => 1,
        ];
        if ($key) {
            $where['config_key'] = trim($key);
        }
        $info = db('config')->where($where)->find();
        $info['config_value'] = $info && $info['config_value'] ? json_decode($info['config_value'], 1) : [];
        return $info;
    }
    
    //底层通用参数初始化
    protected function initBase() {
        defined('ADMIN_SYSTEM') or define('ADMIN_SYSTEM',   1); //平台账户 
        defined('ADMIN_FACTORY')or define('ADMIN_FACTORY',  2); //商户账户
        defined('ADMIN_CHANNEL')or define('ADMIN_CHANNEL',  3); //渠道商账户
        defined('ADMIN_DEALER') or define('ADMIN_DEALER',   4); //经销商/零售商账户
        defined('ADMIN_SERVICE')or define('ADMIN_SERVICE',  5); //服务商账户
        
        defined('STORE_FACTORY')or define('STORE_FACTORY',  1); //厂商商户
        defined('STORE_CHANNEL')or define('STORE_CHANNEL',  2); //渠道商商户
        defined('STORE_DEALER') or define('STORE_DEALER',   3); //经销商/零售商商户
        defined('STORE_SERVICE')or define('STORE_SERVICE',  4); //服务商商户
        
        defined('GROUP_FACTORY')or define('GROUP_FACTORY',  1); //厂商角色
        defined('GROUP_CHANNEL')or define('GROUP_CHANNEL',  2); //渠道商角色
        defined('GROUP_DEALER') or define('GROUP_DEALER',   3); //经销商/零售商角色
        defined('GROUP_SERVICE')or define('GROUP_SERVICE',  4); //服务商角色
        
        defined('CONFIG_WORKORDER_ASSESS')or define('CONFIG_WORKORDER_ASSESS',  'config_workorder_assess');
        
        defined('NOW_TIME')or define('NOW_TIME', $_SERVER['REQUEST_TIME']);
    	defined('IS_POST') or define('IS_POST', $this->request->isPost());
    	defined('IS_AJAX') or define('IS_AJAX', $this->request->isAjax());
    	defined('IS_GET')  or define('IS_GET', $this->request->isGet());
    	defined('IS_MOBILE')or define('IS_MOBILE', $this->request->isMobile());
    }
    
    /**
     *    导入资源到模板
     */
    protected function import_resource($resources, $spec_type = null)
    {
    	$headtag = '';
    	if (is_string($resources) || $spec_type)
    	{
    		!$spec_type && $spec_type = 'script';
    		$resources = $this->_get_resource_data($resources);
    		foreach ($resources as $params)
    		{
    			$headtag .= $this->_get_resource_code($spec_type, $params) . "\r\n";
    		}
    		$this->headtag($headtag);
    	}
    	elseif (is_array($resources))
    	{
    		foreach ($resources as $type => $res)
    		{
    			$headtag .= $this->import_resource($res, $type);
    		}
    		$this->headtag($headtag);
    	}
    
    	return $headtag;
    }
    
    /**
     *    head标签内的内容
     */
    private function headtag($string)
    {
    	$this->assign('_head_tags', $string);
    }
    /**
     *    获取资源数据
     */
    private function _get_resource_data($resources)
    {
    	$return = array();
    	if (is_string($resources))
    	{
    		$items = explode(',', $resources);
    		array_walk($items, create_function('&$val, $key', '$val = trim($val);'));
    		foreach ($items as $path)
    		{
    			$return[] = array('path' => $path, 'attr' => '');
    		}
    	}
    	elseif (is_array($resources))
    	{
    		foreach ($resources as $item)
    		{
    			!isset($item['attr']) && $item['attr'] = '';
    			$return[] = $item;
    		}
    	}
    
    	return $return;
    }
    
    /**
     *    获取资源文件的HTML代码
     */
    private function _get_resource_code($type, $params)
    {
    	switch ($type)
    	{
    		case 'script':
    			$pre = '<script charset="utf-8" type="text/javascript"';
    			$path= ' src="' . $this->_get_resource_url($params['path'],"js") . '"';
    			$attr= ' ' . $params['attr'];
    			$tail= '></script>';
    			break;
    		case 'style':
    			$pre = '<link rel="stylesheet" type="text/css"';
    			$path= ' href="' . $this->_get_resource_url($params['path'],"css") . '"';
    			$attr= ' ' . $params['attr'];
    			$tail= ' />';
    			break;
    	}
    	$html = $pre . $path . $attr . $tail;
    
    	return $html;
    }
    
    /**
     *    获取真实的资源路径
     */
    private function _get_resource_url($res,$type)
    {
    	$res_par = explode(':', $res);
    	$url_type = $res_par[0];
    	$return  = '';
    	switch ($url_type)
    	{
    		case 'url':
    			$return = $res_par[1];
    			break;
    		case 'lib':
    			$return = '/static/lib/' . $res_par[1];
    			break;
    		case 'base':
    			$return = '/static/base/' . $res_par[1];
    			break;
    		default:
    			$res_path = empty($res_par[1]) ? $res : $res_par[1];
    			$return = "/static/".$this->request->module()."/".$type."/".$res_path;
    			break;
    	}
    
    	return $return;
    }
}
