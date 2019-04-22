<?php


namespace app\open\controller\v10;


use app\open\controller\Base;

class Upload extends Base
{
    public function upImg()
    {
        $file = $this->request->file('file');
        if (!$file) {
            return $this->dataReturn(1,'请选择上传图片');
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

}