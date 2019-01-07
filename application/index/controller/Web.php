<?php

namespace app\index\controller;

use app\common\controller\Base;
use app\common\model\Store;
use app\common\model\WebArticle;
use app\common\model\WebBanner;
use app\common\model\WebConfig;
use app\common\model\WebMenu;

class Web extends Base
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

    /**
     * 获取首页新闻
     */
    public function getTopNews()
    {
        $data = WebArticle::field('id,title,summary,update_time')->where([
            'is_del' => 0,
            'store_id' => $this->store_id,
            'is_top' => 1,
        ])->order('update_time desc')->limit(3)->select();
        $data = $data->map(function ($item) {
            $arr = $item;
            if (mb_strlen($arr['summary']) > 120) {
                $arr['summary'] = mb_substr($arr['summary'], 0, 120) . '...';
            }
            return $arr;
        });
        return returnMsg(0, 'ok', $data);
    }


    public function getRegion()
    {
        $id = input('id', 1, 'intval');
        $model = db('region');
        $data = $model->field('region_id id,region_name name')->where([
            'is_del' => 0,
            'parent_id' => $id,
        ])->order('sort_order')->select();
        return returnMsg(0, 'ok', $data);
    }

    public function getRetailer()
    {
        $where = [
            'is_del' => 0,
            'factory_id' => $this->store_id,];
        $region_id = input('region_id', 0, 'intval');
        $type = input('region_type', 0, 'intval');
        $region = db('region');
        if ($type == 3) {//区/县
            $where['region_id'] = $region_id;
        } else if ($type == 2) {//市
            $region_arr = $region->where([
                'parent_id' => $region_id
            ])->column('region_id');
            array_push($region_arr, $region_id);
            $where['region_id'] = ['in', $region_arr];
        } else if ($type == 1) {//省
            //市
            $region_arr=$region->alias('p')
                ->field('c.region_id c_id,d.region_id d_id')
                ->join([
                    ['region c','p.region_id = c.parent_id'],
                    ['region d','d.parent_id = c.region_id'],
                ])->where([
                    'p.region_id'=>$region_id,
                    'p.is_del'=>0,
                    'c.is_del'=>0,
                    'd.is_del'=>0
                ])->select();
            $arr_1=array_unique(array_column($region_arr,'c_id'));//市
            $arr_2=array_column($region_arr,'d_id');//区/县
            $region_arr=array_merge($arr_1,$arr_2);
            $where['region_id'] = ['in', $region_arr];
        }

        $data = Store::field('region_name,address,mobile')->where($where)->select();
        $result = $data->map(function ($item) {
            $item['region_name'] = str_replace(' ', '', $item['region_name']) . '店';
            return $item;
        });
        return returnMsg(0, 'ok', $result);
    }


}