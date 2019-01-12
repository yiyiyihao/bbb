<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2018/12/24 0024
 * Time: 19:28
 */

namespace app\factory\controller;

use app\common\model\WebConfig;
use app\common\model\WebBanner;
use app\common\model\WebMenu;
use app\common\model\WebPage;
use think\Request;

class Site extends FactoryForm
{
    private $store_id;

    public function __construct()
    {
        $this->modelName = '导航图片';
        $this->model = model('web_banner');
        parent::__construct();
        $this->store_id = $this->adminUser['store_id'];
    }


    //导航图管理
    public function index()
    {
        //轮播图
        $slideShow = WebBanner::where([
            'type' => 0,
            'store_id' => $this->store_id,
            'is_del' => 0
        ])->limit(8)->select();
        $this->assign('slideShow', $slideShow);
        $this->subMenu['add'] = [
            'name' => '新增图片',
            'url' => url('banner'),
        ];
        //图片导航
        //$navShow = WebBanner::where('type', 1)->select();
        //$arr = [];
        //foreach ($navShow as $item) {
        //    $arr[$item['group_id']] = isset($arr[$item['group_id']]) ? $arr[$item['group_id']] : [];
        //    $arr[$item['group_id']][] = $item;
        //}
        //$this->assign('navShow', $arr);
        return $this->fetch();
    }


    //基本设置
    public function setting()
    {
        $store_id = $this->adminUser['store_id'];
        $data = WebConfig::where(['key' => 'setting', 'store_id' => $store_id])->value('value');
        $this->assign('data', json_decode($data, true));
        return $this->fetch();
    }

    //图片导航
    public function banner()
    {
        $type = $this->request->param('type', 0, 'intval');
        $id = $this->request->param('id', 0, 'intval');
        if (IS_POST) {//处理表单
            $param = $this->request->param('banner');
            $group_id = $this->request->param('group_id', 0, 'intval');
            if (empty($group_id) && $type == 1) {
                $group_id = $this->getGroupId();
            }
            foreach ($param as $item) {
                if (empty($item['img_url']) && empty($item['link_url'])) {
                    continue;
                }
                $bool = false;
                if (empty($item['id'])) {
                    $banner = new WebBanner;
                } else {
                    $banner = WebBanner::find($item['id']);
                }
                $banner->store_id = $this->store_id;
                $banner->group_id = $group_id;
                $banner->sort = $item['sort'];
                $banner->img_url = $item['img_url'];
                $banner->link_url = $item['link_url'];
                $banner->type = $type;
                $banner->save();
                if (empty($item['id']) && empty($item['sort'])) {
                    $banner->sort = $banner->id;
                    $banner->save();
                }
            }
            return $this->success("保存成功", 'index');
        }

        $id = $this->request->param('id');
        if (!empty($id)) {
            $banner = WebBanner::find($id);
            if (!empty($banner)) {
                $this->assign('data', $banner);
            } else {
                return $this->error("导航图片不存在或已删除");
            }
        }
        $this->subMenu['add'] = [
            'name' => '返回',
            'url' => url('index'),
        ];
        return $this->fetch();
    }


    //添加基本配置
    public function add()
    {
        $store_id = $this->adminUser['store_id'];
        $where = ['key' => 'setting', 'store_id' => $store_id];
        $config = WebConfig::where($where)->find();
        $params = $this->request->param();
        if (empty($config)) {
            $config = new WebConfig;
            $config->key = 'setting';
            $config->name = '基本配置';
            $config->store_id = $store_id;
            $config->value = $params;
            $config->add_time = time();
            $config->update_time = time();
            $bool = $config->save();
        } else {
            $config->value = $params;
            $config->update_time = time();
            $bool = $config->save();
        }
        if ($bool) {
            $this->success("保存成功");
        }
        $this->error("保存失败");
    }

    //导航图列表
    public function nav()
    {
        $group_id = (int)$this->request->param('group_id');
        if (!empty($group_id)) {
            $banner = WebBanner::where('group_id', $group_id)->limit(4)->select();
            $this->assign('list', $banner);
            $this->assign('group_id', $group_id);
        }
        $this->subMenu['add'] = [
            'name' => '返回',
            'url' => url('index'),
        ];
        return $this->fetch();
    }

    //导航列表
    public function menu(Request $request)
    {
        $parent_id = input('pid', 0, 'intval');
        $list_top = WebMenu::alias('m')
            ->field('m.id,m.page_id,m.url,m.sort,m.name,p.title,m.page_type')
            ->join('web_page p', 'm.page_id = p.id', 'left')
            ->where([
                'm.parent_id' => $parent_id,
                'm.is_del' => 0,
                'm.store_id' => $this->store_id,
                'm.type' => 0,
            ])->order('sort')->select();
        $sysmenu=config('sysmenu.');
        $sysmenu=array_map(function ($item)use ($request){
            $item['url']=str_replace($request->subDomain(),'www',$request->domain()).'/#'.$item['url'];
            return $item;
        },$sysmenu);

        $list_top = array_merge($sysmenu, $list_top->toArray());
        $list_bottom = WebMenu::alias('m')
            ->field('m.id,m.parent_id,m.page_id,m.url,m.sort,m.name,p.title,m.page_type')
            ->join('web_page p', 'm.page_id = p.id', 'left')
            ->where([
                //'m.parent_id' => $parent_id,
                'm.is_del' => 0,
                'm.store_id' => $this->store_id,
                'm.type' => 1,
            ])->order('sort')->select();
        if ($list_bottom) {
            $treeService = new \app\common\service\Tree();
            $list_bottom = $treeService->getTree($list_bottom, 0, 'id');
        }

        $this->assign('list_top', $list_top);
        $this->assign('list_bottom', $list_bottom);

        //pre(getTree($list_bottom->toArray()));
        $this->subMenu['add'] = [
            'name' => '项部导航管理',
            'url' => url('add_menu'),
        ];
        $sysMenu = config('sysmenu.');
        $sysMenu = array_column($sysMenu, 'name');
        $this->assign('sysMenu', $sysMenu);
        return $this->fetch();
    }


    //新建|编辑导航
    public function add_menu()
    {
        $id = input('id', 0, ['trim', 'intval']);
        $pid = input('pid', 0, ['trim', 'intval']);
        if (IS_POST) {
            $menu = empty($id) ? (new WebMenu) : WebMenu::alias('m')->get($id);
            $store_no = \app\common\model\Store::where('store_id', $this->store_id)->value('store_no');
            $data = [
                'name' => input('name'),
                'type' => input('type', 0, 'trim,intval'),
                'page_type' => input('page_type', 0, 'trim,intval'),
                'store_id' => $this->store_id,
                'store_no' => $store_no,
                'page_id' => input('page_id', 0, 'trim,intval'),
                'url' => input('url', '', 'trim'),
            ];
            $parent_id = input('pid', '');
            if ($parent_id !== '') {
                $data['parent_id'] = (int)$parent_id;
            }
            $menu->save($data);
            if (empty($id)) {
                $menu->sort = $menu->id;
                $menu->save();
            }
            return $this->success('保存成功', url('menu'));
        }
        if (!empty($id)) {
            $data = WebMenu::alias('m')->field('m.*,pm.name p_name')->join('web_menu pm', 'pm.id=m.parent_id', 'left')->get($id);
            $this->assign('data', $data);
        } else if (!empty($pid)) {
            $data = WebMenu::field('id parent_id,name p_name')->get($pid);
            $this->assign('data', $data);
        }
        $this->subMenu['add'] = [
            'name' => '返回',
            'url' => url('menu'),
        ];
        $this->assign('pages', $this->getPages());


        return $this->fetch();
    }

    public function del_menu()
    {
        $id = input('id', 0, ['trim', 'intval']);
        $bool = WebMenu::alias('m')->where([
            'id' => $id, 'store_id' => $this->store_id
        ])->update(['is_del' => 1]);
        if ($bool) {
            return $this->success('删除成功', url('menu'));
        }
        return $this->success('删除失败');
    }


    //单页列表
    public function page(Request $request)
    {
        $title = $this->request->param('title', '', 'htmlspecialchars');
        $model = WebPage::where('store_id', $this->store_id);
        if (!empty($title)) {
            $model->where('title', 'like', '%' . trim($title) . '%');
        }
        $data = $model->select();
        $data=$data->map(function ($item) use ($request) {
            $domain=str_replace($request->subDomain(),'www',$request->domain());
            $item['url']=$domain.url('page/index',['id'=>$item['id']]);
            return $item;
        });

        $this->assign('list', $data);
        $this->subMenu['add'] = [
            'name' => '新增单页',
            'url' => url('add_page'),
        ];
        return $this->fetch();
    }

    //新建|编辑单页
    public function add_page()
    {
        $id = $this->request->param('id');
        if (IS_POST) {
            //更新单页
            $page = empty($id) ? (new WebPage) : (WebPage::get($id));
            $title = $this->request->param('title');
            $content = $this->request->param('content');
            $page->content = trim($content);
            $page->title = trim($title);
            $page->store_id = $this->store_id;
            $page->save();
            return $this->success('保存成功', 'page');
        }
        if (!empty($id)) {
            $page = WebPage::get($id);
            $this->assign('data', $page);
        }
        $this->subMenu['add'] = [
            'name' => '返回',
            'url' => url('page'),
        ];
        return $this->fetch();
    }


    public function getPages()
    {
        $type = $this->request->param('type', 0, 'intval');
        $pages = WebPage::field('id,title')->where([
            'store_id' => $this->store_id,
            'is_del' => 0,
        ])->select()->toArray();
        return $pages;
    }

    //删除页面
    public function del_page()
    {
        $id = $this->request->param('id');
        if (empty($id)) {
            return $this->error("参数错误");
        }
        $result = WebPage::find($id);
        if (empty($result)) {
            return $this->error("单页不存在或已经被删除");
        }
        $result->is_del = 1;
        $result->save();
        return $this->success("删除成功", url('page'));
    }


    private function getGroupId()
    {
        $id = db('web_banner_group')->insertGetId(['add_time' => time()]);
        return $id;
    }


    public function _getField()
    {

    }

    public function _getWhere()
    {
        $where = [
            'is_del' => 0,
        ];
        return $where;
    }

    public function _getAlias()
    {

    }

    public function _getJoin()
    {

    }

    public function _getOrder()
    {

    }

    /**
     * 列表搜索配置
     */
    function _searchData()
    {
        $search = [
            ['type' => 'input', 'name' => 'phone', 'value' => '手机号', 'width' => '30'],
        ];
        return $search;
    }

}