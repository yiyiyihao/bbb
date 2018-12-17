<?php
namespace app\factory\controller;
use app\common\controller\Index as CommonIndex;

class Index extends CommonIndex
{
    function __construct(){
        parent::__construct();
    }
    public function index()
    {
        //获取登录商家类型
        $storeType = $this->adminUser['store_type'];
        //判断当前登录用户是否存在未查看的公告信息
        $bulletinModel = db('bulletin');
        $where = [
            'B.store_type' => $this->adminUser['store_type'], 
            'B.publish_status' => 1,
            'B.visible_range = 1 OR (visible_range = 0 AND find_in_set('.$this->adminUser['store_id'].', B.to_store_ids))',
            'BR.bulletin_id IS NULL',
        ];
        $join = [
            ['bulletin_log BR', 'B.bulletin_id = BR.bulletin_id ', 'LEFT']
        ];
        $field  = "B.*";
        //未读公告列表
        $bulletins      = $bulletinModel->field($field)->alias('B')->join($join)->where($where)->whereNull('BR.bulletin_id')->select();
        $unReadCount    = count($bulletins);
        $unReadCount    = $unReadCount > 0 ? $unReadCount : '';
        $this->assign("unread",$unReadCount);
        $this->assign('bulletins', $bulletins);
        
        //获取需要开屏展示的公告列表
        #TODO 登录展示特效未处理
        $where['B.special_display'] = 1;
        $specialBulletins = $bulletinModel->field($field)->where($where)->whereNull('BR.bulletin_id')->select();
        if(count($specialBulletins) > 0 && count($specialBulletins) == 1){
            $this->assign('specialBulletin', $specialBulletins[0]);
        }
//         pre($specialBulletins);
        $this->assign('specialBulletins', $specialBulletins);
        
        return parent::index();
    }
}
