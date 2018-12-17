//form
Do.add('form', {
    path: Config.baseDir + 'Validform.min.js'
});
//dialog
/*Do.add('dialog',
{
    path : Config.baseDir + 'dialog/layer.min.js'
});*/
Do.add('dialogcss',
{
    path : Config.baseDir + 'layer/skin/layer.css'
});
Do.add('dialog',
{
    path : Config.baseDir + 'layer/layer.js',
	requires : ['dialogcss']
});
//tip
Do.add('tipsCss', {
    path: Config.baseDir + 'tips/toastr.css',
    type : 'css'
});
Do.add('tips', {
    path: Config.baseDir + 'tips/toastr.min.js',
    requires : ['tipsCss']
});

//time
Do.add('timeCss', {
    path: Config.baseDir + 'time/jquery.datetimepicker.css',
    type: 'css'
});
Do.add('time', {
    path: Config.baseDir + 'time/jquery.datetimepicker.js',
    requires: ['timeCss']
});

//webuploader
Do.add('webuploaderCss', {
    path: Config.baseDir + 'webuploader/webuploader.css',
    type: 'css'
});
Do.add('webuploader', {
    path: Config.baseDir + 'webuploader/webuploader.withoutimage.min.js',
    requires: ['webuploaderCss']
});
Do.add('selectmul', {
    path: Config.libDir + 'selectmul.js'
});
Do.add('region', {
    path: Config.libDir + 'region.js'
});
Do.add('qrcode', {
    path: Config.baseDir + 'jquery.qrcode.min.js',
});

//调试函数
function debug(obj) {
    if (typeof console != 'undefined') {
        console.log(obj);
    }
}
Do.ready('base', function () {});