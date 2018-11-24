<?php
namespace app\common\controller;
use app\common\controller\Base;

class UploadBase extends Base
{
    public $prex;
    public $_oname = '';
    public function __construct()
    {
        parent::__construct();
        $params = $this->request->param();
        $this->prex = isset($params['prex']) && $params['prex'] ? trim($params['prex']) : '';
    }
    /**
     * 文件上传
     * @param boolean $flag 是否返回
     * @param string $filename 上传文件参数名称
     * @param string $prex  文件名称前缀
     * @return 
     */
    public function upload($flag = FALSE, $filename = 'file', $prex = ''){
        $params = $this->request->param();
        $file = $this->request->file($filename);
        if (!$file) {
            $return = [
                'status' => 0,
                'info' => '请选择上传图片',
            ];
        }else{
            $thumbType = isset($params['thumb_type']) && $params['thumb_type'] ? $params['thumb_type'] : '';
            // 要上传图片的本地路径
            $filePath = $file->getRealPath();
            $oname = $this->_oname = $file->getInfo('name');
            if (preg_match('/[^\x00-\x80]/', $oname)) {
                $ext = pathinfo($oname, PATHINFO_EXTENSION);
                $oname = '.'.$ext;
            }else{
                $oname = '_'.$oname;
            }
            $name = date('YmdHis').$oname;
            $name = ($prex ? $prex : $this->prex).$name;
            $fileSize = $file->getInfo('size');
            $return = $this->qiniuUpload($filePath, $name, $fileSize, $thumbType);
        }
        if ($flag) {
            return $return;
        }
        return json($return);
    }
    /**
     * 编辑器上传文件
     * @return \think\response\Json
     */
    public function editorUpload()
    {
        $result = $this->upload(true, 'imgFile', $this->prex.'editor_');
        if ($result && isset($result['status'])){
            $result['error'] = $result['status'] ? 0: 1;
            if (isset($result['info']) && $result['info']) {
                $result['message'] = $result['info'];
            }
            if (isset($result['thumb']) && $result['thumb']) {
                $result['url'] = $result['thumb'];
            }
            return json($result);
        }else{
            return json(['error' => 1, 'message' => '图片上传异常']);
        }
    }
    /**
     * 七牛云上传图片
     * @param string $filePath 文件地址
     * @param string $name  文件名称
     * @param int $fileSize 文件大小
     * @param string $thumbType 
     * @return 
     */
    public function qiniuUpload($filePath, $name, $fileSize, $thumbType = '')
    {
        $qiniuApi = new \app\common\api\QiniuApi();
        $result = $qiniuApi->uploadFile($filePath, $name, $thumbType);
        if ($result['error'] == 1) {
            $return = [
                'status' => 0,
                'info' => $result['msg'],
            ];
        }else{
            $filePath = $result['file']['path'];
            $fileModel = db('file');
            //判断数据库是否存在当前文件
            $exist = $fileModel->where(['qiniu_hash' => $result['file']['hash'], 'qiniu_domain' => $result['domain']])->find();
            if (!$exist) {
                //将对应文件保存到数据库
                $data = [
                    'qiniu_hash'    => $result['file']['hash'],
                    'qiniu_key'     => $result['file']['key'],
                    'qiniu_domain'  => $result['domain'],
                    'file_path'     => $filePath,
                    'file_name'     => $this->_oname,
                    'file_size'     => $fileSize,
                    'add_time'      => time(),
                    'update_time'   => time(),
                ];
                $fileId = $fileModel->insertGetId($data);
            }else{
                $fileId = $exist['file_id'];
            }
            $thumb = isset($result['file']['thumb']) && $result['file']['thumb'] ? $result['file']['thumb'] : $filePath;
            $return = [
                'status'    => 1,
                'thumb'     => $thumb,
                'thumbMid'  => $thumb,
                'file'      => $filePath,
            ];
        }
        return $return;
    }
}