<?php

namespace app\api\controller;

use app\common\model\Store;
use app\common\model\WebArticle;
use app\common\model\WebBanner;
use app\common\model\WebConfig;
use app\common\model\WebMenu;

class Web extends ApiBase
{

    private $store_id;

    public function initialize()
    {
        //放过所有跨域
        $origin = isset($_SERVER['HTTP_ORIGIN']) ? $_SERVER['HTTP_ORIGIN'] : '';
        header('Access-Control-Allow-Origin:' . $origin);
        header('Access-Control-Allow-Methods:POST');
        header('Access-Control-Allow-Headers:x-requested-with,content-type');
        $store_no = input('store_no', '0', 'intval');
        if (empty($store_no)) {
            return $this->returnMsg(1, '参数错误');
        }
        $store_id = Store::where('store_no', $store_no)->value('store_id');
        if (empty($store_id)) {
            return returnMsg(1, '厂商不存在');
        }
        $this->store_id = $store_id;
    }

    //零售商查询
    public function retailers()
    {
        $province = input('province');
        $city = input('city');
        $district = input('district');
        if (empty($district) && empty($city)) {
            
        }

    }

    //公司动态
    public function company_dynamic()
    {
        $page = input('page', 1, 'intval');
        $limit = input('limit', 10, 'intval');
        $data = WebArticle::field('id,title,update_time,summary,cover_img')->where([
            'store_id' => $this->store_id,
            'is_del' => 0,
            'sys_menu_id' => 2,
        ])->page($page)->limit($limit)->select();
        return returnMsg(0, 'ok', $data);
    }


    //轮播图
    public function banner()
    {
        $banner = WebBanner::field('id,img_url,link_url')->where([
            'type' => 0,
            'store_id' => $this->store_id
        ])->limit(8)->select();
        return returnMsg(0, 'ok', $banner);
    }


    //顶部导航
    public function nav_top()
    {
        $data = WebMenu::alias('m')
            ->field('m.id,m.page_id,m.url,m.sort,m.name,p.title,m.page_type')
            ->join('web_page p', 'm.page_id = p.id', 'left')
            ->where([
                'm.parent_id' => 0,
                'm.is_del' => 0,
                'm.store_id' => $this->store_id,
                'm.type' => 0,
            ])->order('sort')->select();
        $menu = $data->map(function ($item) {
            $arr['name'] = $item['name'];
            $arr['url'] = $item['url'];
            if ($item['page_type'] == 0) {
                $arr['url'] = url('page/index', ['id' => $item['page_id']]);
            }
            return $arr;
        })->toArray();
        $sysMenu = config('sysmenu.');
        $sysMenu = array_map(function ($item) {
            return [
                'name' => $item['name'],
                'url' => $item['url'],
            ];
        }, $sysMenu);
        return returnMsg(0, 'ok', array_merge($menu, $sysMenu));
    }

    //底部导航
    public function nav_bottom()
    {
        $data = WebMenu::alias('m')
            ->field('m.id,m.parent_id,m.page_id,m.url,m.sort,m.name,p.title,m.page_type')
            ->join('web_page p', 'm.page_id = p.id', 'left')
            ->where([
                'm.is_del' => 0,
                'm.store_id' => $this->store_id,
                'm.type' => 1,
            ])->order('sort')->select()->toArray();
        $data = array_map(function ($item) {
            $arr['id'] = $item['id'];
            $arr['name'] = $item['name'];
            $arr['parent_id'] = $item['parent_id'];
            $arr['url'] = $item['url'];
            if ($item['page_type'] == 0) {
                $arr['url'] = url('page/index', ['id' => $item['page_id']]);
            }
            return $arr;
        }, $data);
        $result['list'] = getTree($data);
        $config = WebConfig::where('store_id', $this->store_id)->value('value');
        $config = json_decode($config, true);
        unset($config['logo'], $config['login_bg']);
        return returnMsg(0, 'ok', array_merge($config, $result));
    }


}    