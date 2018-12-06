<?php
namespace app\common\model;
use think\Model;

class Table extends Model
{
	public $error;
	protected $pk = 'table_id';
	protected $tableName = 'form_table';
	protected $table;
	
	protected $field = true;
	//自定义初始化
	protected function initialize()
	{
	    $this->table = $this->config['prefix'].$this->tableName;
	    parent::initialize();
	}
	
	//取得模型列表字段
	function getTableList($model){
	    $cacheName = $model.'tableList';
	    cache($cacheName, null);
	    //检查缓存中是否有菜单配置
	    $tableList = cache($cacheName);
	    if(!$tableList){
	        $where = [
	            'status'        => 1,
	            'is_del'        => 0,
	        ];
	        $tableList = $this
	        ->where($where)->order('sort_order')->select();
	        cache($cacheName, $tableList);
	    }
	    //重新格式化数据
	    $tables = [];
	    foreach ($tableList as $k=>$v){
	        $temp['title']     = $v['title'];
	        $temp['width']     = $v['width'];
	        switch ($v['type']){
	            case 1://字段取值
	                $temp['type']      = 'text';
	                $temp['value']     = $v['field'];
	            break;
	            case 2://函数处理
	                $temp['type']      = 'function';
	                $temp['function']  = $v['function'];
	                $temp['value']     = $v['field'];
	            break;
	            case 3://索引
	                $temp['type']      = 'index';	                
	            break;
	            case 4://图标
	                $temp['type']      = 'icon';
	                $temp['value']     = $v['field'];
	            break;
	            case 5://图片
	                $temp['type']      = 'image';
	                $temp['value']     = $v['field'];
	            break;
	            case 6://操作按钮
	            break;
	        }
	        
	        $tables[$k] = $temp;
	    }
	    $tables[] = [
            'title'     => '操作',
            'width'     => '160',
            'type'      => 'button',
            'value'     => 'id',
            'button'    =>  [
                [
                    'text'  => '编辑',
                    'action'=> 'edit',
                    'icon'  => 'edit',
                    'bgClass'=> 'bg-main'	                    
                ],[
                    'text'  => '删除',
                    'action'=> 'del',
                    'icon'  => 'delete',
                    'bgClass'=> 'bg-red'	                    
                ]	                
            ]
	    ];
	    return $tables;
	}
}