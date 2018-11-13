/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author Roddy <luolonghao@gmail.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/

KindEditor.plugin('image', function(K) {
	var editor = this, name = 'image';
        // 点击图标时执行
        editor.clickToolbar(name, function() {
			//editor.insertHtml('你好');
			layer.open({
				  type: 2,
				  title: '选择图片',
				  shadeClose: true,
				  shade: 0.3,
				  area: ['600px', '400px'],
				  content: '/sysadmin/upload/index/type/3', //iframe的url
				  success: function(layero, index){
					var body = layer.getChildFrame('body', index);
					var iframeWin = window[layero.find('iframe')[0]['name']]; //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
					//console.log(body.html()) //得到iframe页的body内容
					//body.find("#chose").text('Hi，我是从父页来的');
					body.find("#submit").click(function(){
						var imgsrc = iframeWin.getimgsrc();
						if(imgsrc){
							editor.exec('insertimage', imgsrc);
							//editor.insertHtml(imgsrc);
							layer.close(index);
						}
					})
				  }
			});
        });
	/*console.log(K);
	var self = this, name = 'image',
		allowImageUpload = K.undef(self.allowImageUpload, true),
		allowImageRemote = K.undef(self.allowImageRemote, true),
		formatUploadUrl = K.undef(self.formatUploadUrl, true),
		allowFileManager = K.undef(self.allowFileManager, false),
		uploadJson = K.undef(self.uploadJson, self.basePath + 'php/upload_json.php'),
		imageTabIndex = K.undef(self.imageTabIndex, 0),
		imgPath = self.pluginsPath + 'image/images/',
		extraParams = K.undef(self.extraFileUploadParams, {}),
		filePostName = K.undef(self.filePostName, 'imgFile'),
		fillDescAfterUploadImage = K.undef(self.fillDescAfterUploadImage, false),
		lang = self.lang(name + '.');
	layer.open({
	  type: 2,
	  title: '选择图片',
	  shadeClose: true,
	  shade: 0.3,
	  area: ['600px', '400px'],
	  content: '/sysadmin/upload/index' //iframe的url
	});*/
});
