<?php


namespace app\factory\controller;


use app\common\controller\Base;
use think\Request;

class Tools extends Base
{
    //腾讯地图KEY
    private $mapKey = 'TTZBZ-33P35-GBWIX-QOANN-MF6IJ-EFBDX';

    public function getAddress(Request $request)
    {
        $lat = $request->param('lat', 0, 'trim');//纬度
        $lng = $request->param('lng', 0, 'trim');//经度
        if ($lat > 90 || $lat < -90) {
            return json(dataFormat(1, '参数错误'));
        }
        if ($lng > 180 || $lng < -180) {
            return json(dataFormat(1, '参数错误'));
        }
        $param = [
            'location' => $lat . ',' . $lng,
            'key'      => $this->mapKey,
            'get_poi'  => '0',
        ];
        $query = http_build_query($param);
        $url = 'https://apis.map.qq.com/ws/geocoder/v1/';
        $url .= '?' . $query;
        $result = curl_request($url);
        $result = json_decode($result, true);
        log_msg($result);
        if (empty($result)) {
            return json(dataFormat(1, '第三方应用异常，请求失败'));
        }
        if (isset($result['status']) && $result['status'] == '0') {
            $result = $result['result'];
            $data = [
                'address'   => $result['address'],
                'recommend' => $result['formatted_addresses']['recommend'],
                'province'  => $result['ad_info']['province'],
                'city'      => $result['ad_info']['city'],
            ];
            return json(dataFormat(0, 'ok',$data));
        }
        return json(dataFormat($result['status'], $result['message']));
    }

    //地址转经纬度
    public function getCoder(Request $request)
    {
        $address = $request->param('address', 0, 'trim');
        $param = [
            'address' => $address,
            'key'     => $this->mapKey,
        ];
        $query = http_build_query($param);
        $url = 'https://apis.map.qq.com/ws/geocoder/v1/';
        $url .= '?' . $query;
        $result = curl_request($url);
        $result = json_decode($result, true);
        if (empty($result)) {
            return json(dataFormat(1, '第三方应用异常，请求失败'));
        }
        if (isset($result['status']) && $result['status'] == '0') {
            return json(dataFormat(0, $result['message'], $result['result']['location']));
        }
        return json(dataFormat($result['status'], $result['message']));
    }
}