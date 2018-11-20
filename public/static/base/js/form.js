//编辑器调用
$.fn.Editor = function (options) {
    var defaults = {
        uploadUrl: '',
        uploadParams: function () {},
        config: {}
    }
    var options = $.extend(defaults, options);
    var uploadParams = {
        //session_id: Config.sessId
    };
    this.each(function () {
        var id = this;
        var idName = $(this).attr('id') + '_editor';
            //编辑器
            var editorConfig = {
                allowFileManager: false,
                uploadJson: options.uploadUrl,
                filterMode: false,
                extraFileUploadParams: $.extend(uploadParams, options.uploadParams()),
                afterBlur: function () {
                    this.sync();
                },
                width: '100%'
            };
            editorConfig = $.extend(editorConfig, options.config);
            var str = idName + ' = KindEditor.create(id, editorConfig);';
            eval(str);
        });
};
//表单处理
$.fn.Form = function (options) {
	var defaults = {
		postFun: {},
		returnFun: {}
	}
	var options = $.extend(defaults, options);
	//编辑器
	if ($(".js-editor").length > 0) {
		$('.js-editor').Editor({
			uploadUrl: '/upload/editor/type/3',
		});
	}	
	//时间选择
	if ($(".js-time").length > 0) {
		$('.js-time').attr("readonly","readonly").datetimepicker({lang: 'ch'});
	}
	this.each(function () {
		//表单提交
		var form = this;
		$(form).Validform({
				ajaxPost: true,
				postonce: true,
				tiptype: function (msg, o, cssctl) {
					if (!o.obj.is("form")) {
						//设置提示信息
						var objtip = o.obj.siblings(".note");
						var objico = o.obj.siblings(".form-icon");
						if (o.type == 1) {
							//正在检测中
							objico.attr('class','form-icon');
							objtip.after('<div class="input-note icon-spinner icon-spin"> ' + msg + '</div>');
							objico.addClass("icon-spinner icon-spin");
							objtip.hide();
						}
						if (o.type == 2) {
							//通过
							var className = ' ';
							$('#tips').html('');
							objico.attr('class','form-icon');
							objtip.next('.icon-spinner').remove();
							if ( objtip.next('.js-tip').length > 0 ) {
								objtip.next('.js-tip').remove();
							}
							objico.addClass("icon-check text-green");
							objtip.hide();
						}
						if (o.type == 3) {
							//未通过
							var html = '<div class="alert alert-yellow"><strong>注意：</strong>您填写的信息未通过验证，请检查后重新提交！</div>';
							$('#tips').html(html);
							objico.attr('class','form-icon');
							var className = 'check-error';
							if ( objtip.next('.js-tip').length > 0 ) {
								objtip.next('.js-tip').remove();
							}
							objtip.after('<div class="input-note js-tip">' + msg + '</div>');
							objico.addClass("icon-close");
							objtip.hide();
						}
						//设置样式
						o.obj.parent('.form-group').removeClass('check-error');
						o.obj.parent('.form-group').addClass(className);
						o.obj.parent().parent('.form-group').removeClass('check-error');
						o.obj.parent().parent('.form-group').addClass(className);
					}
				},
				callback: function (data) {
					var msg = data.data.tipmsg ? data.data.tipmsg : '正在处理中,请稍等 ...';
					layer.msg(msg, {icon: 16});
					if (data.code == 1) {
						//成功返回
						if ($.isFunction(options.returnFun)) {
							options.returnFun(data);
						} else {					
							if (data.url == null || data.url == '') {
								//不带连接
								layer.alert(data.msg, 1, function () {
									window.location.reload();
								});
							} else {
								//带连接
								//判断是否异步
								if (data.type == 'json'){
									var wait = data.wait;
									var interval = setInterval(function(){
										var time = --wait;
										if(time <= 0) {
											window.location.href = data.url;
											clearInterval(interval);
										};
									}, 1000);
									//window.location.href = data.url;
								}else{
									layer.confirm(data.info, {
									  btn: ['确定','关闭'] //按钮
									}, function(){
									  window.location.href = data.url;
									}, function(){
									  window.location.reload();
									});
								}
								
							}
						}
					} else {
						//失败返回
						if(data.msg){
							if (data.type == 'json'){
								layer.closeAll();
								var html = '<div class="alert alert-yellow"><strong>注意：</strong>'+data.msg+'</div>';
								$('#tips').html(html);
							}else{
								layer.alert(data.msg);
							}
						}
					}
				}
			});
	});
};
//上传调用
$.fn.FileUpload = function (options) {
	var defaults = {
		uploadUrl: '/upload/upload',
		type: '',
		uploadParams: function () {},
		complete: function () {}
	}
	var options = $.extend(defaults, options);
	this.each(function () {
		var upButton = $(this);
		var urlVal = upButton.attr('data');
		urlVal = $('#' + urlVal);
		var buttonText = upButton.text();
		var preview = upButton.attr('preview');
		preview = $('#' + preview);
		/*创建上传*/
		
			var uploader = WebUploader.create({
				swf: '/static/base/js/webuploader/Uploader.swf',
				server: options.uploadUrl,
				pick: {
					id: upButton,
					multiple: false
				},
				resize: false,
				auto: true,
				accept: {
					title: '指定格式文件',
					extensions: options.type
				}
			});
			//上传开始
			uploader.on('uploadStart', function (file) {
				uploader.option('formData' , $.extend(options.uploadParams(), {'class_id':$('#class_id').val()}));
				upButton.attr('disabled', true);
				upButton.find('.webuploader-pick span').text(' 等待');
			});
			//上传完毕
			uploader.on('uploadSuccess', function (file, data) {
				upButton.attr('disabled', false);
				upButton.find('.webuploader-pick span').text(' 上传');
				if (data.status) {
					urlVal.val(data.url);
					if(preview.hasClass("msg-img")){
						var img = data.url;
						var num = active - 1;
						localJson[num].pic = img;
						if($("#msgitem"+active+" .msg-img img").length > 0){
							$("#msgitem"+active+" .msg-img img").attr('src',localJson[num].pic);
						}else{
							$("#msgitem"+active).find(".msg-img").append('<img src="'+localJson[num].pic+'"/>');
						}
					}else{
						preview.attr('src',data.url);
					}
					options.complete(data);
				} else {
					alert(data.message);
				}
			});
			uploader.on('uploadError', function (file) {
				alert('文件上传失败');
			});
		});
};
	
	
//多图上传
$.fn.MultiUpload = function (options) {
    var defaults = {
        uploadUrl: '/upload/multiUpload',
        uploadParams: function () {},
        complete: function () {},
        type: '',
		cookie: 'photosurlCookie',
		num: 0
    }
    var options = $.extend(defaults, options);
    this.each(function () {
        var upButton = $(this);
        var dataName = upButton.attr('data');
        var div = $('#' + dataName);
		var preview = $('#preview_' + dataName);
        var data = div.attr('data');
		var index = options.num;
		var cookieName = options.cookie;
		getHistory();
        /*创建上传*/
            var uploader = WebUploader.create({
                swf: '/static/base/js/webuploader/Uploader.swf',
                server: options.uploadUrl,
                pick: upButton,
                resize: false,
                auto: true,
                accept: {
                    title: '指定格式文件',
                    extensions: options.type
                }
            });
            //上传开始
            uploader.on('uploadStart', function (file) {
                uploader.option('formData', $.extend(options.uploadParams(), {
                    'class_id': $('#class_id').val()
                }));
                upButton.attr('disabled', true);
                upButton.find('.webuploader-pick span').text(' 图片上传中……');
            });
            //上传完毕
            uploader.on('uploadSuccess', function (file, data) {
                upButton.attr('disabled', false);
                upButton.find('.webuploader-pick span').text(' 批量上传');
                if (data.status) {
                    htmlList(data);
                    //options.complete(data);
                } else {
                    alert(data.info);
                }
            });
            uploader.on('uploadError', function (file) {
                alert('文件上传失败');
            });
            uploader.on('uploadComplete', function (file) {
                //图片排序
                //div.sortable();
            });
            //处理上传列表
            function htmlList(file) {
				index++;
				var plus = "";
				if(index == 1){
					preview.attr("src",file.thumb);
					preview.prev("input[name=title_img]").val(file.thumb);
					plus = '<span>我是封面</span>';
				}else{
					plus = '<span class="uptofirst">设为封面</span>';
				}
                var html = '<div class="media radius clearfix">\
                    <a class="media-del icon-close" href="javascript:;" title="点击移除本图"></a>'+plus+'<img src="' + file.thumb + '" >\
                    <div class="media-body">\
                    <input name="' + dataName + '[]" type="hidden" class="input" value="' + file.thumbMid + '" />\
                    </div>\
                    </div>\
                    ';
                div.append(html);
				HistoryUp();
            }
			function HistoryUp(){
				var re = arguments[0] ? arguments[0] : 0;
				//读取生成的图片列表并记录
				var myHis = new Array()
				$('.imagesBox .media').each(function(index){
					myHis[index] = new Array();
					myHis[index][0] = $(this).find('img').attr('src');
					myHis[index][1] = $(this).find('input').val();
				});
				var urlCookie = JSON.stringify(myHis);
				$.setCookie(cookieName, urlCookie);
				if(re){
					index = 0;
					getHistory();
				}
			}			
			function getHistory(){			
				var h = $.getCookie(cookieName);
				if(h != '' && h != 'undefined'){					
					div.html("");
					//var arr = h.split(',');
					var arr=eval(''+h+'');
					$.each(arr, function(index,data){
						var files=new Object();
						files.thumb    = data[0];
						files.thumbMid = data[1];
						//console.log(files);
						htmlList(files);
					});
				}
			}
			//处理设为封面
            div.on('click', '.uptofirst', function () {
				$(this).parent().prependTo(div);
				HistoryUp(1);
            });
            //处理删除
            div.on('click', '.media-del', function () {
				var i = $(this).parent().index();				
                $(this).parent().remove();
				if(i === 0){
					preview.attr("src","/static/base/images/default.png");			
					HistoryUp(1);
				}else{					
					HistoryUp();
				}
            });
    });
};
