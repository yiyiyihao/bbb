<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2018/12/24 0024
 * Time: 19:28
 */

namespace app\factory\controller;


use app\common\controller\FormBase;
use app\common\model\WebArticle;

class Article extends FormBase
{
    private $store_id;

    public function __construct()
    {
        $this->modelName = '文章';
        $this->model = db('web_article');
        parent::__construct();
        $this->store_id = $this->adminUser['store_id'];
    }

    //添加|编辑文章
    public function add()
    {
        $store_id = $this->store_id;
        $this->subMenu['add'] = [
            'name' => '返回',
            'url' => url('index'),
        ];
        $id = input('id', 0, 'intval');
        if (IS_POST) {
            $article = empty($id) ? (new WebArticle) : (WebArticle::get($id));
            $data = [
                'store_id' => $store_id,
                'sys_menu_id' => 2,//公司动态
                'is_top' => input('is_top') ? 1 : 0,
                'title' => input('title'),
                'status' => input('status'),
                'summary' => trim(strip_tags(input('summary'))),
                'content' => trim(input('content')),
                'cover_img' => input('cover_img'),
            ];
            if (empty($data['content'])) {
                $this->error("文章详情不能为空");
            }
            if (empty($data['summary'])) {
                $data['summary'] = sub_str($data['content'], 120);
            }

            $article->save($data);
            $this->success("保存成功", 'index');
            return true;
        }
        $article = WebArticle::get($id);
        $this->assign('data', $article);
        return $this->fetch();
    }


    //内容发布
    public function publish()
    {
        $id = $this->request->param('id', 0, 'intval');
        if (empty($id)) {
            $this->error("非法请求");
            return false;
        }
        $store_id = $this->store_id;
        $article = WebArticle::where([
            'is_del' => 0,
            'store_id' => $store_id,
            'id' => $id,
        ])->find();
        if ($article->status) {
            $this->error('文章已经发布');
            return false;
        }
        if (empty($article)) {
            $this->error("文章不存在或已被删除");
            return false;
        }
        $article->status = 1;
        $article->save();
        $this->success("发布成功！", 'index');
        return false;
    }


    public function _getField()
    {

    }

    public function _getWhere()
    {
        $where = [
            'is_del' => 0,
        ];
        $status = $this->request->param('status', 0, 'intval');
        $title = $this->request->param('title');
        if ($status !== 0) {
            $where['status'] = $status == 1 ? 0 : 1;
        }
        if (!empty($title)) {
            $where['title'] = ['like', '%' . $title . '%'];
        }
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