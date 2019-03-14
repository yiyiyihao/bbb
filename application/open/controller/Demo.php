<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2019/3/12 0012
 * Time: 14:37
 */

namespace app\open\controller;


use think\Controller;
use think\Request;

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
        if (isset($result['data'][0]) && $result['data'][0] && is_array($result['data'][0])) {
            $result['data'] = $result['data'][0];
        }else if (isset($result['data']['list'][0]) && $result['data']['list'][0] && is_array($result['data']['list'][0])) {
            $result['data']['list']=$result['data']['list'][0];
        }
        $this->showTable($result);
        echo '</pre>';
        //p($result);
    }

    private function showTable($data, $subTxt = '')
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
            echo '|' . $subTxt . ' ' . $k . ' |' . gettype($v) . '   |' . $desc . '|<br>';
            if (is_array($v)) {
                $subTxt .= '├';
                $this->showTable($v, $subTxt);
            }
        }
    }

}