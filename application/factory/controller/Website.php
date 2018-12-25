<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2018/12/24 0024
 * Time: 19:28
 */

namespace app\factory\controller;


use app\common\controller\Site;

class Website extends Site
{
    public function setting()
    {
        return $this->fetch();
    }

    public function cms()
    {
        echo 888;
    }

    public function add_cate()
    {
        echo 9999;
    }

}