<?php
namespace app\common\service;
class Wxcode
{
    public $error;
    public function getStoreAppletCode($store, $type = 'installer')
    {
        $storeModel = new \app\common\model\Store();
        //远程判断图片是否存在
        $qiniuApi = new \app\common\api\QiniuApi();
        $config = $qiniuApi->config;
        $domain = $config ? 'http://'.$config['domain'].'/': '';
        $filename = 'wxacode_'.$store['store_no'].'_'.$type.'.png';
        $page = 'pages/index/index';//二维码扫码打开页面
        $page = '';
        $scene = 'store_no='.$store['store_no'];//最大32个可见字符，只支持数字，大小写英文以及部分特殊字符：!#$&'()*+,/:;=?@-._~，其它字符请自行编码为合法字符（因不支持%，中文无法使用 urlencode 处理，请使用其他编码方式）
        $wechatApi = new \app\common\api\WechatApi($store['store_id'], 'wechat_applet');
        $data = $wechatApi->getWXACodeUnlimit($scene, $page);
        if ($data === FALSE) {
            $this->error = $wechatApi->error;
            return FALSE;
        }else{
            $result = $qiniuApi->uploadFileData($data, $filename);
            if (isset($result['error']) && $result['error'] > 0) {
                $this->error($result['msg']);
            }
            $codeUrl = $wxacode[$type] = $domain.$filename;
            $data = [
                'wxacode' => json_encode($wxacode),
            ];
            $result = $storeModel->save($data, ['store_id' => $store['store_id']]);
        }
        return $codeUrl;
    }
}