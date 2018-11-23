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
    
    //底层通用参数初始化
    protected function initBase() {
        defined('SYSTEM_ADMIN')     or define('SYSTEM_ADMIN',   1); //平台管理员 
        defined('STORE_ADMIN')      or define('STORE_ADMIN',    2); //商户管理员
        defined('STORE_FINANCE')    or define('STORE_FINANCE',  3); //商户财务
        defined('STORE_SERVICE')    or define('STORE_SERVICE',  4); //商户客服
        defined('STORE_OPERATOR')   or define('STORE_OPERATOR', 5); //商户运营
        
        
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
