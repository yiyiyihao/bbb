<?php
namespace app\factory\controller;
use app\admin\controller\User as adminUser;

class User extends adminUser
{
    public function __construct()
    {
        parent::__construct();
    }
}