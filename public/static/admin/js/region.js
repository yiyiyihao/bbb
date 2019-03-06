(function($){
	//区域单选
	$.fn.region = function( opt ) {
		var dataType = '';
		var length = opt.length;
		if(opt.datatype){
			dataType = 'datatype="'+opt.datatype+'"';
		}
		var notmsg = '';
		if(opt.notmsg != undefined){
			notmsg = opt.notmsg;
		}
		var html = '<input type="hidden" id="region_id" name="'+opt.name+'" '+dataType+' value="'+opt.value+'"><input type="hidden" id="region_name" name="region_name" value="'+opt.formstr+'"><input type="hidden" id="region_len" name="region_len">'
				  +'<div id="regiondata"></div>'
   				  +'';
		$(this).html(html);
		var tis = $(this);
		if(opt.value != '' && opt.value != '0'){
			var formStr = '<span>'+opt.formstr+'</span> <span class="button button-small changeRegion">更改</span>';
			$("#regiondata").append(formStr);
		}else{	
			var postParam = false;
			getRegionList(opt, postParam,tis);
		}
		$(".form-group").on('change','#regiondata select',function(){
			var region_id = $(this).val();
			$(this).nextAll().remove();
			if(region_id != ''){
				tis.region_id = region_id;
				getRegionList(opt, {parent_id:region_id}, tis,length);
			}
		})
		$(".form-group").on('click','.changeRegion',function(){
			$("#regiondata").html("");
			getRegionList(opt, false,tis,length);
		})
	}
	function getRegionList(opt,postParam,tis,length){
		url=opt.postUrl;
		if(!url){
			layer.alert('ajax post 地址不存在，请检查错误！');
			return false;
		}
		if(length == 0 || length == undefined) length = 10;//理论上为零应该不限制节点,这里定义10是自信联级菜单不会超过十级
    	var postData = {};
    	if(postParam){
    		postData = postParam;
    	}else{
			postData.parent_id = 1;
		}
		var load = layer.msg("加载中...",{icon: 16,time:10000});
		$.post(url, postData,function(data){
			var data = data.data;
			var nowLen = $("#regiondata select").length;
			//@20190306 zhou
			var region_name = '';
			var option = tis.find("select.input option:selected");
			$.each(option,function(i,e){
				region_name += e.text+' ';
			});
			region_name = $.trim(region_name);
			//debug(region_name);
			$("#region_id").val(tis.region_id);
			$("#region_name").val(region_name);
			$("#region_len").val(nowLen);


			if(data && data.length > 0 && nowLen < (length)){
				var option = '<select class="input">';
					option +='<option value="">--请选择--</option>';
				$.each(data,function(i,e){
					option += '<option value="'+e.id+'">'+e.name+'</option>';
				})
				option += '</select> ';
				$("#regiondata").append(option);
				//按地址搜索等操作时可以只选择部分地址
				if (opt.datatype){
					$("#region_id").val('');
					$("#region_name").val('');
					$("#region_len").val('');
				}
			}
			layer.close(load);
		})
	}
})( jQuery );