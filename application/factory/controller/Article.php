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

    public function add()
    {
        $store_id = $this->store_id;
        $this->subMenu['add'] = [
            'name' => '返回',
            'url' => url('index'),
        ];
        $id = $this->request->param('id', 0, 'intval');
        if (IS_POST) {
            $flag = null;
            if (empty($id)) {
                $article = new WebArticle;
                $article->store_id = $store_id;
                $article->menu_id = $this->request->post('id', 0, 'intval');
                $article->title = $this->request->post('title');
                $article->summary = $this->request->post('summary');
                $article->content = $this->request->post('content');
                $article->cover_img = $this->request->post('cover_img');
                $article->add_time = time();
                $article->update_time = time();
                $flag = $article->save();
            } else {
                $article = WebArticle::where(['store_id' => $store_id])->find($id);
                $article->store_id = $store_id;
                $article->menu_id = $this->request->post('id', 0, 'intval');
                $article->title = $this->request->post('title');
                $article->summary = $this->request->post('summary');
                $article->content = $this->request->post('content');
                $article->cover_img = $this->request->post('cover_img');
                $article->update_time = time();
                $flag = $article->save();
            }
            if ($flag) {
                $this->success("保存成功", 'index');
            }
            $this->error("保存失败");
            return false;
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
            'article_id' => $id,
        ])->find();
        if (empty($article)) {
            $this->error("文章不存在或已被删除");
            return false;
        }
        $article->status = 1;
        if ($article->save()) {
            $this->success("发布成功！", 'index');
        }
        $this->error("文章不存在或已被删除");
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