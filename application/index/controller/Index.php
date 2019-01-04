<?php

namespace app\index\controller;

use app\common\controller\Base;
use app\common\model\Store;
use app\common\model\WebBanner;
use app\common\model\WebConfig;
use app\common\model\WebMenu;

class Index extends Base
{

    private $store_id;

    public function initialize()
    {
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


    public function index()
    {
        dump($this->store_id);
    }

    public function banner()
    {
        $banner = WebBanner::field('img_url,link_url')->where([
            'type' => 0,
            'store_id' => $this->store_id
        ])->limit(8)->select();
        return returnMsg(0,'ok',$banner);
    }


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
                $arr['url']=url('page/index', ['id' => $item['page_id']]);
            }
            return $arr;
        }, $data);
        $result['list'] = getTree($data);
        $config=WebConfig::where('store_id',$this->store_id)->value('value');
        $config=json_decode($config,true);
        unset($config['logo'],$config['login_bg']);
        return returnMsg(0, 'ok', array_merge($config,$result));
    }



}
