<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/1/4 0004
 * Time: 10:07
 */

namespace app\index\controller;


use app\common\controller\Base;
use app\common\model\WebPage;
use think\Controller;

class Page extends Base
{

    public function index()
    {
        $id = (int)input('id');
        $result = WebPage::get($id);
        $this->assign('data', $result);
        $this->assign('title', $result['title']);
        return $this->fetch();
    }


}