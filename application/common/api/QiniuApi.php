<?php
namespace app\common\api;
use Qiniu\Auth;
use Qiniu\Storage\UploadManager;
use think\facade\App;
/**
 * 七牛云接口
 * @author xiaojun
 */
class QiniuApi
{
    var $config;
    public function __construct()
    {
        $this->config = [
            'accessKey' => 'B5D22bbwnP2ntnrWyg6WKy9lOyZuHiIH6WcO8jnQ',  //accessKey
            'secretKey' => 'zQf-G4PfhMeB869kBHUBs2OExg1QpGK1f527zSxC',  //secretKey
            'bucket'    => 'huixiang',                                  //上传的空间
            'domain'    => 'pimvhcf3v.bkt.clouddn.com',                 //空间绑定的域名
//             'domain'    => 'pimvhcf3v.bkt.clouddn.com',                 //空间绑定的域名
            'thumb_config' => [
//                 'goods_thumb' => '?imageView2/1/w/400/h/400/q/75|imageslim',
//                 'avatar_thumb' => '?imageView2/1/w/200/h/200/q/75|imageslim',
            ],
        ];
    }
    
    public function uploadFileData($data, $qiniuName = '', $thumbType = '')
    {
        require_once APP_PATH . '/../vendor/Qiniu/autoload.php';
        // 构建鉴权对象
        $auth = new Auth($this->config['accessKey'], $this->config['secretKey']);
        $token = $auth->uploadToken($this->config['bucket']);
        // 初始化 UploadManager 对象并进行文件的上传
        $uploadManager = new UploadManager();
        // 调用 UploadManager 的 putFile 方法进行文件的上传
        $result = $uploadManager->put($token, $qiniuName, $data);
        if ($result && isset($result['statusCode']) && $result['statusCode'] != 200) {
            $return = [
                'error' => 1,
                'msg'   => $result['error'],
                'data'  => '',
            ];
        }else{
            $body = isset($result['body']) && $result['body'] ? json_decode($result['body'], TRUE) : [];
            $filePath = 'http://'.$this->config['domain'].'/'.$body['key'];
            if (isset($this->config['thumb_config']) && $thumbType && $this->config['thumb_config'][$thumbType]) {
                $thumb = $filePath.$this->config['thumb_config'][$thumbType];
            }else{
                $thumb = '';
            }
            $return = [
                'error' => 0,
                'msg' => '上传完成',
                'domain' => $this->config['domain'],
                'file' => [
                    'hash'  => $body['hash'],
                    'key'   => $body['key'],
                    'path'  => $filePath,
                    'thumb' => $thumb,
                ],
            ];
        }
        return $return;
    }
    
    public function uploadFile($filePath = '', $qiniuName = '', $thumbType = '')
    {
        $path = App::getThinkPath();
        require_once $path . '/vendor/Qiniu/autoload.php';
        // 构建鉴权对象
        $auth = new Auth($this->config['accessKey'], $this->config['secretKey']);
        $token = $auth->uploadToken($this->config['bucket']);
        // 初始化 UploadManager 对象并进行文件的上传
        $uploadManager = new UploadManager();
        // 调用 UploadManager 的 putFile 方法进行文件的上传
        $result = $uploadManager->putFile($token, $qiniuName, $filePath);
        if ($result && isset($result['statusCode']) && $result['statusCode'] != 200) {
            $return = [
                'error' => 1,
                'msg'   => $result['error'],
                'data'  => '',
            ];
        }else{
            $body = isset($result['body']) && $result['body'] ? json_decode($result['body'], TRUE) : [];
            $filePath = 'http://'.$this->config['domain'].'/'.$body['key'];
            if (isset($this->config['thumb_config']) && $thumbType && isset($this->config['thumb_config'][$thumbType]) && $this->config['thumb_config'][$thumbType]) {
                $thumb = $filePath.$this->config['thumb_config'][$thumbType];
            }else{
                $thumb = '';
            }
            $return = [
                'error' => 0,
                'msg' => '上传完成',
                'domain' => $this->config['domain'],
                'file' => [
                    'hash'  => $body['hash'],
                    'key'   => $body['key'],
                    'path'  => $filePath,
                    'thumb' => $thumb,
                ],
            ];
        }
        return $return;
    }
}