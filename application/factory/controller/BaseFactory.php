<?php
namespace app\factory\controller;
use think\facade\Request;
use app\common\controller\FormBase;

class BaseFactory extends FormBase
{
    function __construct(){
        $domain = Request::panDomain();
        if ($domain) {
            //根据domain取得厂商信息
            $this->adminFactory = db('store_factory')->alias('SF')->join('store S', 'S.store_id = SF.store_id', 'INNER')->where(['domain' => trim($domain), 'is_del' => 0])->find();
            session('admin_factory', $this->adminFactory);
            if ($this->adminFactory) {
                //传值给厂商后台处理逻辑,渲染厂商后台页面信息
                parent::__construct();
            }else{
                $this->error(lang('NO ACCESS'));
            }
        }
    }
}
