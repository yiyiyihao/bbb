<?php


namespace app\open\controller\v10;


use app\open\controller\Base;

class Upload extends Base
{
    public function upImg()
    {
        $file = $this->request->file('file');
        if (!$file) {
            return $this->upImageSource();//兼容
            //return $this->dataReturn(1,'请选择上传图片');
        }
        //图片上传到七牛
        $upload = new \app\common\controller\UploadBase();
        $result = $upload->upload(TRUE, 'file', 'up_file');
        if (!$result || !$result['status']) {
            return $this->dataReturn(1,$result['info']);
        }
        unset($result['status']);
        return $this->dataReturn(0,'图片上传成功',$result);
    }

    public function upImageSource()
    {
        $image=$this->request->param('file','','trim');
        if (!$image) {
            return $this->dataReturn(1,'图片数据不能为空');
        }
        if (preg_match('/^(data:\s*image\/(\w+);base64,)/',$image, $res)) {
            $image = base64_decode(str_replace($res[1],'', $image));
        }
        $fileSize = strlen($image);
        //图片上传到七牛
        $upload = new \app\common\controller\UploadBase();
        $result = $upload->qiniuUploadData($image, 'api_'.$type.'_', $type, $fileSize);
        if (!$result || !$result['status']) {
            return $this->dataReturn(1,$result['info']);
        }
        unset($result['status']);
        return $this->dataReturn(0,'图片上传成功',$result);
    }

}