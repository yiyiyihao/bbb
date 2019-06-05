//编辑器调用
$.fn.Editor = function (options) {
    var defaults = {
        uploadUrl: Config.editorUploadUrl,
        uploadParams: function () {},
        config: {}
    }
    var options = $.extend(defaults, options);
    var uploadParams = {
        session_id: Config.sessId
    };
    this.each(function () {
        var id = this;
        var idName = $(this).attr('id') + '_editor';
        Do.ready('editor', function () {
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
			if(options.items){
				editorConfig.items = options.items;
			}
            editorConfig = $.extend(editorConfig, options.config);
            var str = idName + ' = KindEditor.create(id, editorConfig);';
            eval(str);
        });

    });
};

//多图上传
$.fn.MultiUpload = function (options) {
    var defaults = {
        uploadUrl: '/admin/adminupload/multiUpload',
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
        var div = $('#' + dataName).find(".swiper-wrapper");
		var preview = $('#preview_' + dataName);
        var data = div.attr('data');
		var index = options.num;
		var cookieName = options.cookie;
        /*创建上传*/
        Do.ready('webuploader', function () {
			getHistory();
            var uploader = WebUploader.create({
                swf: Config.baseDir + 'webuploader/Uploader.swf',
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
                    //options.complete(data.data);
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
				//console.log(file);
				index++;
				//console.log(index);
				var dataType=swiper.$el.attr('data-type');
				var plus = "";
				if (dataType !== 'simple') {
					if(index == 1){
						preview.attr("src",file.thumb);
						preview.prev("input[type=hidden]").val(file.thumb);
						plus = '<span>我是封面</span>';
					}else{
						plus = '<span class="uptofirst">设为封面</span>';
					}
				}
                var html = '<div class="swiper-slide"><div class="media radius clearfix">\
                    <a class="media-del icon-close" href="javascript:;" title="点击移除本图"></a>'+plus+'<img src="' + file.thumb + '" >\
                    <div class="media-body">\
                    <input name="' + dataName + '[]" type="hidden" class="input" value="' + file.thumbMid + '" />\
                    </div>\
                    </div>\
					</div>\
                    ';
                //div.append(html);
				swiper.appendSlide(html);
				HistoryUp();
            }
			function HistoryUp(){
				var re = arguments[0] ? arguments[0] : 0;
				//console.log("re:"+re);
				//读取生成的图片列表并记录
				var myHis = new Array()
				$('.imagesBox .media').each(function(index){
					myHis[index] = new Array();
					myHis[index][0] = $(this).find('img').attr('src');
					myHis[index][1] = $(this).find('input').val();
				});
				var urlCookie = JSON.stringify(myHis);
				localStorage.setItem(cookieName, urlCookie)
				//$.setCookie(cookieName, urlCookie);
				if(re){
					index = 0;
					getHistory();
				}
			}			
			function getHistory(){
				//var h = $.getCookie(cookieName);
				var h = localStorage.getItem(cookieName);
				if(h != '' && h != null && h != 'undefined'){					
					//div.html("");
					index = 0;
					swiper.removeAllSlides();
					//var arr = h.split(',');
					var arr=eval(''+h+'');
					//console.log(arr);
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
				var index = $(this).parent().parent().index();
				//取得当前对象
				var item = $(this).parent().parent();
				swiper.removeSlide(index);
				swiper.prependSlide(item);
				//$(this).parent().parent().prependTo(wrapper);
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
    });
};

//图表插件
$.fn.EChart = function (options) {
	var chartId = this.attr("id");
	var chartData = $("#"+chartId).data("chart");
	if (!chartData) {
		return false;
	}
    var defaults = {
		title : {},
		tooltip : {
			formatter: "{a} <br/>{b} : {c} ({d}%)"
		},
		//legend: {},
		series : [],
		chartObj: {},
    };
	if(chartData.type == 'bar'){
		var typeOptions = {
			color: ['rgba(225,85,85,0.8)'],
			tooltip : {
				trigger: 'axis',
				axisPointer : {            // 坐标轴指示器，坐标轴触发有效
					type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
				}
			},
			grid: {
				left: '3%',
				right: '4%',
				bottom: '3%',
				containLabel: true
			},
			xAxis : [
				{
					type : 'category',
					data : chartData.legend,
					axisTick: {
						alignWithLabel: true
					},
					axisLine:{
						lineStyle:{
							color:['#ccc'],
						}
					}
				}
			],
			yAxis : [
				{
					type : 'value',
					axisLine:{
						show :false,
						lineStyle:{
							color:['#ccc'],
						}
					}
				}
			],
			series : [
				{
					name: chartData.name,
					type:'bar',
					barWidth: '40%',
					data:chartData.data,
					label:{show: true,position: 'top'},
				}
			]
		}
	}else if(chartData.type == 'pie'){
		var typeOptions = {
			legend:{
				orient: 'vertical',
				left: 'left',
				data: chartData.legend,
			},
			series: [{			
				label: {
					normal: {
						show: false,
					},
				},
				labelLine: {
					normal: {
						show: false
					}
				},
				data: chartData.data,
				name: chartData.name,
				type:'pie',
			}],
			color: chartData.color,
		}
	}else if(chartData.type == 'group'){
		var typeOptions = {
			tooltip: {
				trigger: 'axis'
			},
			legend: {
				left: 'left',
				show: false,
				textStyle: {
					color:['#ccc'],
				},
				data: chartData.legend
			},
			grid: {
				left: '20px',
				right: '40px',
				bottom: '0%',
				containLabel: true
			},
			xAxis: {
				type: 'category',
				boundaryGap: false,
				axisLine:{
					lineStyle:{
						color:['#ccc'],
					}
				},
				data: chartData.label
			},
			yAxis: {
				type: 'value',
				axisLine:{
					show :false,
					lineStyle:{
						color:['#ccc'],
					}
				}
			},
			series: chartData.data
		}
	}
    var options = $.extend(defaults, typeOptions);
	//console.log(options);
	var chartObj = this;
    Do.ready('eChart', function () {
		var id = chartObj.attr("id");
		var obj = document.getElementById(id);
		var myChart = echarts.init(document.getElementById(chartObj.attr("id")));
        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(options,true);
		if(window.addEventListener)
		{
			window.addEventListener("resize",myChart.resize,false);
		}
		else
		{
			window.attachEvent("onresize",myChart.resize)
		}
    });
};


function isEmpty(obj){
	if(!obj && obj !== 0 && obj !== '') {
		return true;
	}
	if(Array.prototype.isPrototypeOf(obj) && obj.length === 0) { return true;}
	if(Object.prototype.isPrototypeOf(obj) && Object.keys(obj).length === 0) {
		return true;
	}
	return false;
}

//图表插件
$.fn.EChartNew = function (options) {
	var chartId = this.attr("id");
	var chartData = $("#"+chartId).data("chart");
    var options = chartData;
	var chartObj = this;
    Do.ready('eChart', function () {
		var id = chartObj.attr("id");
		var obj = document.getElementById(id);
		var myChart = echarts.init(document.getElementById(chartObj.attr("id")));
        // 使用刚指定的配置项和数据显示图表。
		if (!isEmpty(options)) {
			myChart.setOption(options,true);
		}else {
			myChart.setOption({},true);
		}
		if(window.addEventListener)
		{
			window.addEventListener("resize",myChart.resize,false);
		}
		else
		{
			window.attachEvent("onresize",myChart.resize)
		}
    });
};
//绘制图表控件
$.fn.DrawChart = function (options) {
	var defaults = {}
    var options = $.extend(defaults, options);
	//初始化绘制图表
	this.each(function () {	
		$(this).EChart();
	})
}
//绘制图表控件
$.fn.DrawChartNew = function (options) {
	var defaults = {}
    var options = $.extend(defaults, options);
	//初始化绘制图表
	this.each(function () {	
		$(this).EChartNew();
	})
}
if($(".js-draw-chart").length > 0){
	$('.js-draw-chart').DrawChart();
}
if($(".js-chart").length > 0){
	$('.js-chart').DrawChartNew();
}
//加载系统菜单
$.fn.AdminMenu = function (options) {
    var defaults = {
        data: []
    }
    var options = $.extend(defaults, options);
    var chartObj = this;
    Do.ready('adminMenuJS', function () {
		//生成主菜单
		var data = options.data;		
		/* 初始化顶部导航 */
		initMenu(data);
    });
};
if($("#siderbar-nav .nav-box").length > 0){
	$("body").AdminMenu();
}
//表单页面处理
$.fn.FormPage = function (options) {
    var defaults = {
        uploadUrl: Config.uploadUrl,
        editorUploadUrl: Config.editorUploadUrl,
        uploadComplete: function () {},
        uploadParams: function () {},
        uploadType: [],
        postFun: {},
        returnUrl: '',
        returnFun: {},
		cookie: 'photosurlCookie',
		num: 0,
        form: true
    }
    var options = $.extend(defaults, options);
    this.each(function () {
        var form = this;
        form = $(form);
        //表单处理
        if (options.form) {
            form.Form({
                postFun: options.postFun,
                returnUrl: options.returnUrl,
                returnFun: options.returnFun
            });
        }
        //文件上传
        if (form.find(".js-file-upload").length > 0) {
            form.find('.js-file-upload').FileUpload({
                type: '*',
                uploadUrl: options.uploadUrl,
                complete: options.uploadComplete,
                uploadParams: options.uploadParams
            });
        }
        //图片上传
        if (form.find(".js-img-upload").length > 0) {
            form.find('.js-img-upload').FileUpload({
                type: 'jpg,png,gif,bmp,jpeg',
                uploadUrl: options.uploadUrl,
                complete: options.uploadComplete,
                uploadParams: options.uploadParams
            });
        }
        //多图片上传
        if (form.find(".js-multi-upload").length > 0) {
            form.find('.js-multi-upload').MultiUpload({
                type: 'jpg,png,gif,bmp,jpeg',
                uploadUrl: options.uploadUrl,
                complete: options.uploadComplete,
                uploadParams: options.uploadParams,
				cookie: options.cookie,
				num: options.num,
            });
        }
        //编辑器
        if (form.find(".js-editor").length > 0) {
            form.find('.js-editor').Editor({
                uploadUrl: options.editorUploadUrl,
                uploadParams: options.uploadParams,
				items: options.items
            });
        }
        //时间选择
        if (form.find(".js-time").length > 0) {
            form.find('.js-time').attr("readonly","readonly").Time();
        }
        if (form.find(".js-date").length > 0) {
            form.find('.js-date').attr("readonly","readonly").Time({'timepicker': false, format:'Y-m-d'});
        }
        //区域多选框初始化
        if (form.find(".js-selectmul").length > 0) {
            form.find('.js-selectmul').selectmul();
        }
		//区域单选框初始化
        if (form.find(".js-select").length > 0) {
            form.find('.js-select').selectsin();
        }
		//地区联级选择初始化
        if (form.find(".js-select-child").length > 0) {
            form.find('.js-select-child').selectchild();
        }
    });
};