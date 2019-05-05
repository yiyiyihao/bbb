<?php
namespace app\common\model;
use think\Model;
class TemplateConfig extends Model
{

    public $error;
    protected $fields;
    protected $pk = 'config_id';
}