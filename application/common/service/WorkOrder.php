<?php
namespace app\common\service;
class WorkOrder
{
    var $error;
    var $worderModel;
    public function __construct(){
        $this->worderModel = db('work_order');
    }
    public function worderLog($userId, $worderId)
    {
        
    }
}