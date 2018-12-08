<?php
namespace app\common\model;
use think\Model;

class Field extends Model
{
	public $error;
	protected $pk = 'field_id';
	protected $tableName = 'form_field';
	protected $table;
	
	protected $field = true;
	//自定义初始化
	protected function initialize()
	{
	    $this->table = $this->config['prefix'].$this->tableName;
	    parent::initialize();
	}
	
	//取得模型字段列表
	function getFieldList($model){
	    $cacheName = $model.'fieldList';
// 	    cache($cacheName, null);
	    //检查缓存中是否有菜单配置
	    $fieldList = cache($cacheName);
	    if(!$fieldList){
	        $where = [
	            'M.name'        => $model,
	            'F.status'        => 1,
	            'F.is_del'        => 0,
	        ];
	        $join[] = ['form_model M', 'M.model_id = F.model_id', 'LEFT'];
	        $field = 'F.*,M.name';
	        $fieldList = $this
	        ->alias("F")
	        ->join($join)
	        ->field($field)
	        ->where($where)->order('sort_order')->select();
	        cache($cacheName, $fieldList);
	    }
	    //重新格式化数据
	    $fields = [];
	    foreach ($fieldList as $k=>$v){
	        $temp['title']     = $v['title'];
	        $temp['name']      = $v['field'];
	        $temp['datatype']  = $v['datatype'];
	        $temp['notetext']  = $v['notemsg'];
	        $temp['nullmsg']   = $v['nullmsg'];
	        $temp['errormsg']  = $v['errormsg'];
	        switch ($v['type']){
	            case 1://文本类型
	                $temp['type']      = $v['type_extend'];
	                $temp['size']      = $v['size'];
	                $temp['default']   = $v['default'];
	            break;
	            case 2://文本域
	                $temp['type']      = 'textarea';
	                $temp['size']      = $v['size'];
	                $temp['default']   = $v['default'];
	            break;
	            case 3://单选
	                $temp['type']      = 'radio';
	                $temp['default']   = $v['default'];
	                $tempList = explode("\n", trim($v['value']));
	                $radioList = [];
	                if($tempList){
	                    foreach ($tempList as $key=>$val){
	                        $valArray = explode("|", trim($val));
	                        $radioList[$key]['text'] = $valArray[0];
	                        $radioList[$key]['value'] = $valArray[1];
	                    }
	                }
	                $temp['radioList'] = $radioList;
	            break;
	            case 4://复选
	            break;
	            case 5://选择菜单
	                $temp['options']      = $v['variable'];
	                $temp['type']         = $v['type_extend'];
	                switch ($v['type_extend']){
	                    case 'select':
	                        $temp['default_option']   = $v['default'];
	                    break;
	                    case 'select-search':
	                    break;
	                    case 'select-mul-search':
	                    break;
	                    case 'select-child':
	                    break;
	                }
	            break;
	            case 6://图片上传
	            break;
	            case 7://编辑器
	            break;
	        }
	        
	        $fields[$k] = $temp;
	    }
	    return $fields;
	}
}