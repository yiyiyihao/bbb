<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/3/12 0012
 * Time: 14:37
 */

namespace app\open\controller;


use think\Controller;
use think\process\pipes\Unix;
use think\Request;
use think\Response;

class Demo extends Controller
{
    public function index(Request $request)
    {
        $param = $request->param();
        $method = $request->param('method');
        unset($param['method']);
        $url = url($method, [], '', true);
        array_shift($param);
        $result = curl_post_https($url, http_build_query($param));

        echo '<h3>请求接口：</h3>';
        echo '<p>' . $method . '</p>';
        echo '<h3>请求URL</h3>';
        echo '<p>' . url($method, $param, '', true) . '</p>';


        echo '<h3>请求参数：</h3>';
        echo '<pre>';
        echo json_encode($param, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);

        echo '</pre>';

        echo '<br><br>';
        echo '<pre>';
        echo '|参数名 |是否必填|类型   |说明    |<br>';
        echo '|:---- |:---  |:----- |------ |<br>';
        foreach ($param as $k => $v) {
            $desc = '';
            $isRequired = '否';
            switch ($k) {
                case 'page':
                    $desc = '分页，第几页，默认1';
                    break;
                case 'page_size':
                    $desc = '分页，每页几条，默认10';
                    break;
                case 'openid':
                    $desc = 'openid';
                    $isRequired = '是';
                    break;
                default:
                    $isRequired = '是';
                    $desc = $k;
            }
            echo '|' . $k . '  |' . $isRequired . '  |string | ' . $desc . ' |<br>';
        }
        echo '</pre>';


        echo '<h3>返回结果：</h3>';
        //p($result);
        echo '<pre>';
        echo json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        echo '</pre>';
        echo '<h3>返回参数说明：</h3>';
        echo '<pre>';
        echo '|参数名|类型|说明|<br>';
        echo '|:-----  |:-----|-----|<br>';
        $flag = false;
        if (isset($result['data'][0]) && is_array($result['data'][0])) {
            $result['data'] = $result['data'][0];
            $flag = true;
        } else if (isset($result['data']['list'][0]) && $result['data']['list'][0] && is_array($result['data']['list'][0])) {
            $result['data']['list'] = $result['data']['list'][0];
        }
        $this->showTable($result, '', $flag);
        echo '</pre>';
        //p($result);
    }


    private function showTable($data, $subTxt = '', $isArray = false)
    {
        foreach ($data as $k => $v) {
            $desc = '';
            switch ($k) {
                case 'code':
                    $desc = '返回码';
                    break;
                case 'msg':
                    $desc = '返回信息';
                    break;
                case 'data':
                    $desc = '返回数据';
                    break;
                default:
                    $desc = $k;
            }
            $type = gettype($v);
            if ($k == 'data' && !$isArray) {
                $type = 'object';
            }
            echo '|' . $subTxt . ' ' . $k . ' |' . $type . '   |' . $desc . '|<br>';
            if (is_array($v)) {
                $subTxt .= '├';
                $this->showTable($v, $subTxt);
            }
        }
    }


    public function hello(Request $request)
    {
        $param = $request->param(false);//获得原始数据，不进行数据过滤
        array_shift($param);
        $result = json_decode(array_pop($param), true);

        echo '<h3>请求参数：</h3>';
        $this->request_table($request, $param);

        echo '<div style="border: 1px double #0da216;"></div>';

        echo '<h3>返回结果：</h3>';
        $this->return_table($request, $result);
    }

    public function request_table(Request $request, $param = [])
    {
        if (empty($param)) {
            $param = $request->param();
            array_shift($param);
        }
        unset($param['developer_id']);

        if (empty($param)) {
            return '无请求参数';
        }

        echo '<pre>';
        echo json_encode($param, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        echo '</pre>';

        echo '<br><br>';
        echo '<pre>';
        echo '|参数名 |是否必填|类型   |说明    |<br>';
        echo '|:---- |:---  |:----- |------ |<br>';
        foreach ($param as $k => $v) {
            if ($k == 'developer_id') {
                continue;
            }
            $desc = '';
            $isRequired = '否';
            switch ($k) {
                case 'page':
                    $desc = '分页，第几页，默认1';
                    break;
                case 'page_size':
                    $desc = '分页，每页几条，默认10';
                    break;
                case 'openid':
                    $desc = '用户唯一标识';
                    $isRequired = '是';
                    break;
                default:
                    $isRequired = '是';
                    $desc = $k;
            }
            echo '|' . $k . '  |' . $isRequired . '  |string | ' . $desc . ' |<br>';
        }
        echo '</pre>';

    }


    public function return_table(Request $request, $param = [])
    {
        if (empty($param)) {
            $param = $request->param();
        }
        if (empty($param)) {
            echo '<p>你玩我啊，啥都没有，不信你自己看！</p>';
            p($param, 0);
            return;
        }

        echo '<pre>';
        echo json_encode($param, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        echo '</pre>';

        echo '<h3>返回参数说明：</h3>';
        echo '<pre>';
        echo '|参数名|类型|说明|<br>';
        echo '|:-----  |:-----|-----|<br>';
        $isArray = false;
        if (isset($param['data'][0]) && is_array($param['data'][0])) {
            $param['data'] = $param['data'][0];
            $isArray = true;
        } else if (isset($param['data']['list'][0]) && $param['data']['list'][0] && is_array($param['data']['list'][0])) {
            $param['data']['list'] = $param['data']['list'][0];
        }
        $this->showTable($param, '', $isArray);
        echo '</pre>';
    }

    public function xml()
    {
        $data = dataFormat(0, "success", ["username" => "joe", "mobile" => "13512783986"]);
        $xml = arr2xml($data);
        header('Content-Type: text/xml;');
        echo $xml;
        die();
    }

    public function up()
    {
        $this->view->engine->layout(false);
        return $this->fetch();
    }

}