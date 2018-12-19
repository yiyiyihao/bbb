<?php
namespace app\common\api;

/**
 * 微信接口
 * @author xiaojun
 */
class WechatApi
{
    var $config;
    var $error;
    var $templateCodes;
    public function __construct($storeId, $wechatType = 'wechat_applet', $platType = 1){
        if (!$storeId) {
            $this->error = lang('paran_error');
            return FALSE;
        }
        $type = $platType == 1? 'installer' : 'user';
        $config = get_store_config($storeId);
        $wechatConfig = $config && isset($config[$wechatType]) ? $config[$wechatType] : [];
        if (!$wechatConfig) {
            $this->_returnMsg(['errCode' => 1, 'errMsg' => '厂商未配置小程序信息']);
        }
        $this->config['appid']      = isset($wechatConfig[$type.'_appid']) ? trim($wechatConfig[$type.'_appid']) : '';
        $this->config['appsecret']  = isset($wechatConfig[$type.'_appsecret']) ? trim($wechatConfig[$type.'_appsecret']) : '';
    }
    /**
     * 微信接口:获取access_token(接口调用凭证)
     * @return string
     */
    public function getWechatAccessToken()
    {
        $appid = isset($this->config['appid']) ? trim($this->config['appid']) : '';
        if (!$appid) {
            $this->error = 'APPID不能为空';
            return FALSE;
        }
        $tokenName = 'asscess_token_'.$appid;
        $accessToken = \think\facade\Cache::get($tokenName);
        if (!$accessToken) {
            $url = 'https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid='.$appid.'&secret='.trim($this->config['appsecret']);
            $result = curl_post_https($url, []);
            if (isset($result['access_token'])) {
                $accessToken = $result['access_token'];
                $expiresIn = isset($result['expires_in']) ? $result['expires_in']-1 : 7100;
                \think\facade\Cache::set($tokenName, $accessToken, $expiresIn);
                return $accessToken;
            }else{
                $this->error = 'errcode:'.$result['errcode'].'; errmsg:'.$result['errmsg'];
                return FALSE;
            }
        }else{
            return $accessToken;
        }
    }
    public function getWXACodeUnlimit($scene, $page = FALSE)
    {
        $token = $this->getWechatAccessToken();
        if (!$token) {
            return FALSE;
        }
        $post = [
            'scene' => $scene,
        ];
        if ($page) {
            $post['page'] = $page;
        }
        $url = 'https://api.weixin.qq.com/wxa/getwxacodeunlimit?access_token='.trim($token);
        $result = curl_post_https($url, json_encode($post));
        if (isset($result['errcode']) && $result['errcode']) {
            $this->error = 'errcode:'.$result['errcode'].'; errmsg:'.$result['errmsg'];
            return FALSE;
        }
        return $result;
    }
    
    /**
     * 微信小程序接口:小程序发送模板消息
     * @param array $post 模板消息发送内容
     * @return array
     */
    public function sendAppletTemplateMessage($post)
    {
        $token = $this->getWechatAccessToken();
        if (!$token) {
            return FALSE;
        }
        $url = 'https://api.weixin.qq.com/cgi-bin/message/wxopen/template/send?access_token='.trim($token);
        $result = curl_post_https($url, json_encode($post));
        if (isset($result['errcode']) && $result['errcode']) {
            $this->error = 'errcode:'.$result['errcode'].'; errmsg:'.$result['errmsg'];
            return FALSE;
        }
        return $result;
    }
    /**
     * 微信公众平台接口：发送模板消息
     * @param array $post
     * @return array
     */
    public function sendTemplateMessage($post)
    {
        $token = $this->getWechatAccessToken();
        if (!$token) {
            return FALSE;
        }
        $url = 'https://api.weixin.qq.com/cgi-bin/message/template/send?access_token='.trim($token);
        $result = curl_post_https($url, json_encode($post));
        if (isset($result['errcode']) && $result['errcode']) {
            $this->error = 'errcode:'.$result['errcode'].'; errmsg:'.$result['errmsg'];
            return FALSE;
        }
        return $result;
    }
    
}