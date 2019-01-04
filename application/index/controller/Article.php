<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/1/4 0004
 * Time: 10:20
 */

namespace app\index\controller;


use app\common\controller\Base;
use app\common\model\WebArticle;
use think\Controller;

class Article extends Base
{
    public function index()
    {
        $id = (int)input('id');
        $result = WebArticle::get($id);
        $this->assign('data', $result);
        $this->assign('title', $result['title']);
        return $this->fetch('page/index');
    }

}