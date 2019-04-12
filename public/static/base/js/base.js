$.ajaxSetup({
    cache: false
});
(function ($) {
    //表格处理
    $.fn.Table = function (options) {
        var defaults = {
            selectAll: '#selectAll',
            selectSubmit: '#selectSubmit',
            selectAction: '#selectAction',
            deleteUrl: '',
            actionUrl: '',
            actionParameter: function(){}
        }
        var options = $.extend(defaults, options);
        this.each(function () {
            var table = this;
            var id = $(this).attr('id');
            //处理多选单选
            $(options.selectAll).click(function () {
                $(table).find("[name='id[]']").each(function () {
                    if ($(this).prop("checked")) {
                        $(this).prop("checked", false);
                    } else {
                        $(this).prop("checked", true);
                    }
                })
            });
            //处理批量提交
            $(options.selectSubmit).click(function () {
                Do.ready('tips', 'dialog', function () {
                    //记录获取
                    var ids = new Array();
                    $(table).find("[name='id[]']").each(function () {
                        if ($(this).prop("checked")) {
                            ids.push($(this).val());
                        }
                    })
                    toastr.options = {
                        "positionClass": "toast-bottom-right"
                    }
                    if (ids.length == 0) {
                        toastr.warning('请先选择操作记录');
                        return false;
                    }
                    //操作项目
                    var dialog = layer.confirm('你确认要进行本次批量操作！', function () {
                        var parameter = $.extend({
                                ids: ids,
                                type: $(options.selectAction).val()
                            },
                            options.actionParameter()
                        );
                        $.post(options.actionUrl, parameter, function (json) {
                            if (json.status) {
                                toastr.success(json.info);
                                setTimeout(function () {
                                    window.location.reload();
                                }, 2000);
                            } else {
                                toastr.warning(json.info);
                            }
                        }, 'json');
                        layer.close(dialog);
                    });

                });
            });
            /*$(table).find('.js-open').click(function (e) {
                var obj = this;
                var div = $(obj).parents('tr');
                var url = $(obj).attr('href');
                Do.ready('tips', 'dialog', function () {
                	if(!url){
                		layer.msg('地址错误');
                    	return false;
                    }
                    var text = $(obj).attr('title');
                    layer.open({
                  	  type: 2,
                  	  area: ['800px', '700px'], //宽高 
                  	  content: url //这里content是一个URL，如果你不想让iframe出现滚动条，你还可以content: ['http://sentsin.com', 'no']
                  	});
                });
                return false;
            });*/
			//添加到进货单
			$(table).find('.js-addcart').click(function(){
				Do.ready('flyer','dialog', function () {
				   //弹出属性选择窗
				   layer.open({
					   type:2,
					   shade: [0.3, '#000000'],
					   title: false, //不显示标题
					   area: ['600px','500px'],
					   btn: ['去结算','继续添加'],
					   maxHeight: '500px',
					   scrollbar: true,
					   content:'/goods/choosespec?id=18'
				   });
				});
			});
			//处理排序
			$(table).find('.js-sort').click(function(){
				//获取当前页面URL
				var url = window.location.href;
				var sortstr;
				var sortarr = [];
				sortstr = $("#table").data('sort');
				if(sortstr){
					var temp = sortstr.split(",");
					$.each(temp,function(i,e){
						var arr = e.split("|");
						sortarr[arr[0]] = arr[1];
					})
				}
				var value = $(this).parent().data('sort');
				var sorttype = $(this).data('sort');
				var str = '';
				if(url.indexOf("?")>0){
					var sortNew = [];
					sortNew[value] = sorttype;
					if(sortarr[value]) sortarr[value] = sorttype;
					sortNew = $.extend(sortNew, sortarr);		
					for(var key in sortNew){
						str += key+'|'+sortNew[key]+',';
					}
					//去掉最后逗号
					str = (str.substring(str.length-1)==',')?str.substring(0,str.length-1):str;
					if(url.indexOf("sort=")>0){
						//替换掉url里sort里面的值
						var reg = /sort=[^&]+/;
						str = 'sort='+str;
						url = url.replace(reg,str);
						str = '';
					}else{
						str = '&sort='+str;
					}
				}else{
					str = '?';
					str += 'sort='+value+'|'+sorttype;
				}
				url += str;
				window.location.href = url;
			});
            //处理删除
            $(table).find('.js-del').click(function () {
                var obj = this;
                var div = $(obj).parents('tr');
                var url = $(obj).attr('url');
                if (url == '' || url == null || url == 'undefined') {
                    url = options.deleteUrl;
                }
                operat(
                    obj,
                    url,
                    function () {
                        div.remove();
                    },
                    function () {});
            });
            //处理其他动作
            $(table).find('.js-action').click(function () {
                var obj = this;
                var div = $(obj).parent().parent();
                var url = $(obj).attr('url');
                var refresh = $(obj).attr('refresh') ? true: false;
                operat(
                    obj,
                    url,
                    function () {
                        var success = $(obj).attr('success');
                        if (success) {
                            eval(success);
                        }
                    },
                    function () {
                        var failure = $(obj).attr('failure');
                        if (failure) {
                            eval(failure);
                        }
                    }, refresh);
            });
            //处理动作
            function operat(obj, url, success, failure, refresh) {
                Do.ready('tips', 'dialog', function () {
                    var text = $(obj).attr('title');
                    var message='你确认执行 <b>' + text + '</b> 操作？';
                    var title=$(obj).data('title');
                    if (title) {
                        message=title;
                    }
                    var dialog = layer.confirm(message, function () {
                        var dload = layer.load('操作执行中，请稍候...');
                        $.post(url, $(obj).data(),
                            function (json) {
                                layer.close(dload);
                                layer.close(dialog);
                                if (json.code) {
                                	var msg = json.msg;
                                	if(refresh){
                                		msg += '<br>1秒后刷新当前页面';
                                	}
                                    toastr.success(msg);
                                    success();
                                    if(refresh){
                                    	var interval = setInterval(function(){
                                    		window.location.reload();
                                    		clearInterval(interval);
                                    	}, 1000);
                                    }
                                } else {
                                    toastr.error(json.msg,text+"失败");
                                    failure();
                                }
                            }, 'json');
                    });
                });
            }
            //处理编辑
            $(table).find('.table_edit').blur(function () {
                var obj = this;
                var data = $(obj).attr('data');
                var url = $(obj).attr('url');
                if (url == '' || url == null || url == 'undefined') {
                    url = options.editUrl;
                }
                Do.ready('tips', function () {
                    $.post(url, {
                            data: $(obj).attr('data'),
                            name: $(obj).attr('name'),
                            val: $(obj).val(),
                        },
                        function (json) {
                            if (json.status) {
                                toastr.success(json.info);
                            } else {
                                toastr.warning(json.info);
                            }
                        }, 'json');
                });
            });
        });
    };
    //表单处理
    $.fn.Form = function (options) {
        var defaults = {
            postFun: {},
            returnFun: {}
        }
        var options = $.extend(defaults, options);
        this.each(function () {
            //表单提交
            var form = this;
            Do.ready('form', 'dialog', function () {
                Config['valid'] = $(form).Validform({
                    ajaxPost: true,
                    postonce: true,
                    tiptype: function (msg, o, cssctl) {
                        if (!o.obj.is("form")) {
                            //设置提示信息
                            var objtip = o.obj.siblings(".input-note");
                            if (o.type == 2) {
                                //通过
                                var className = ' ';
                                $('#tips').html('');
                                objtip.next('.js-tip').remove();
                                objtip.show();
                            }
                            if (o.type == 3) {
                                //未通过
                                var html = '<div class="alert alert-yellow"><strong>注意：</strong>您填写的信息未通过验证，请检查后重新提交！</div>';
                                $('#tips').html(html);
                                var className = 'check-error';
                                if ( objtip.next('.js-tip').length == 0 ) {
                                    objtip.after('<div class="input-note js-tip">' + msg + '</div>');
                                    objtip.hide();
                                }
                            }
                            //设置样式
                            o.obj.parents('.form-group').removeClass('check-error');
                            o.obj.parents('.form-group').addClass(className);
                        }
                    },
                    callback: function (data) {
                    	layer.closeAll();
                        //layer.load('表单正在处理中，请稍等 ...');
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
									layer.confirm(data.msg, {
										btn: ['确定', '关闭'],
									}, function(){
									 	window.location.href = data.url;
									}, function(){
										window.location.reload();
									});
                                }
                            }
                        } else {
                            //失败返回
							if(data.msg){
                            	layer.alert(data.msg);
							}
                        }
                    }
                });
                //下拉赋值
                var assignObj = $(form).find('.js-assign');
                assignObj.each(function () {
                    var assignTarget = $(this).attr('target');
                    $(this).change(function () {
                        $(assignTarget).val($(this).val());
                    });
                });
            });
        });
    };

    //时间插件
    $.fn.Time = function (options) {
        var defaults = {
            lang: 'ch'
        }
        var options = $.extend(defaults, options);
        this.each(function () {
            var id = this;
            Do.ready('time', function () {
                $(id).datetimepicker(options);
            });
        });
    };
    
    //区域多选框初始化
    $.fn.selectmul = function (options) {
		var opt = options;
		
        this.each(function () {
			var defaults = {
				postUrl: $(this).attr("posturl") ? $(this).attr("posturl") : null,
				str    : $(this).attr("str") ? $(this).attr("str") : '',
				searchName: $(this).attr("searchName"),
				name:$(this).attr("formname"),
				datatype:$(this).attr("validtype"),
				initData:$(this).attr("formvalue"),
			}
			var options = $.extend(defaults, opt);
			
            var id = this;
            Do.ready('dialog','selectmul', function () {
                $(id).selectmul(options);
            });
        });
    };
	
	//区域多选框初始化
    $.fn.selectsin = function (options) {
		var opt = options;
        this.each(function () {			
			var defaults = {
				postUrl: $(this).attr("posturl"),
				str    : $(this).attr("str"),
				searchName: $(this).attr("searchName"),
				name:$(this).attr("formname"),
				datatype:$(this).attr("validtype"),
			}
			var options = $.extend(defaults, opt);
            var id = this;
            Do.ready('dialog','selectmul', function () {
                $(id).selectsin(options);
            });
        });
    };
	
    //地区联级选择初始化
    $.fn.selectchild = function (options) {
		var opt = options;
        this.each(function () {			
			var defaults = {
				postUrl: $(this).attr("posturl"),
				formstr: $(this).attr("formstr"),
				name:$(this).attr("formname"),
				value:$(this).attr("formvalue"),
				datatype:$(this).attr("validtype"),
				length:$(this).attr("formlength"),
			}
			var options = $.extend(defaults, opt);
            var id = this;
            Do.ready('dialog','region', function () {
                $(id).region(options);
            });
        });
    };

	//选择图片调用
	$.fn.FileChose = function (options) {
		var defaults = {
            lang: 'ch'
        }
        var options = $.extend(defaults, options);
		this.each(function () {
			var button = this;
			Do.ready('dialog',function(){
				$(button).click(function(){
					//加载选择图片层
					layer.open({
					  type: 2,
					  title: '选择图片',
					  shadeClose: true,
					  shade: 0.3,
					  area: ['600px', '400px'],
					  content: '/sysadmin/upload/index' //iframe的url
					}); 
				})
			})
		})
	}
    //上传调用
    $.fn.FileUpload = function (options) {
        var defaults = {
            uploadUrl: Config.uploadUrl,
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
            Do.ready('webuploader', function () {
                var uploader = WebUploader.create({
                    swf: Config.baseDir + 'webuploader/Uploader.swf',
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
                        urlVal.val(data.thumb);
						urlVal.hide();
						if(preview.hasClass("msg-img")){
							var img = data.thumb;
							var num = active - 1;
							localJson[num].pic = img;
							if($("#msgitem"+active+" .msg-img img").length > 0){
								$("#msgitem"+active+" .msg-img img").attr('src',localJson[num].pic);
							}else{
								$("#msgitem"+active).find(".msg-img").append('<img src="'+localJson[num].pic+'"/>');
							}
						}else{							
							preview.attr('src',data.thumb);
							preview.show();
						}
						//console.log(options);
                        options.complete(data);
                    } else {
                    	layer.alert(data.info);
                        //alert(data.info);
                    }
                });
                uploader.on('uploadError', function (file) {
                    alert('文件上传失败');
                });
            });
        });
    };

})(jQuery);