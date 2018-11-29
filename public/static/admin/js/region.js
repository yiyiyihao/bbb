(function($){
	//区域单选
	$.fn.region = function( opt ) {
		var dataType = '';
		if(opt.datatype){
			dataType = 'datatype="'+opt.datatype+'"';
		}
		var notmsg = '';
		if(opt.notmsg != undefined){
			notmsg = opt.notmsg;
		}
		var html = '<div class="label"><label class="labelName">'+opt.str+'</label></div>'
				  +'<div class="field"><input type="hidden" id="region_id" name="'+opt.name+'" '+dataType+' value="'+opt.value+'"><input type="hidden" id="region_name" name="region_name" value="'+opt.formstr+'">'
				  +'<div id="regiondata"></div>'
				  +'<div class="input-note">'+notmsg+'</div>'
   				  +'</div>';
		$(this).html(html);
		var tis = $(this);
		if(opt.value != '' && opt.value != '0'){
			var formStr = '<span>'+opt.formstr+'</span> <span class="button button-small changeRegion">更改</span>';
			$("#regiondata").append(formStr);
		}else{	
			var postParam = false;
			getRegionList(opt.postUrl, postParam,tis);
		}
		$(".form-group").on('change','#regiondata select',function(){
			var region_id = $(this).val();
			$(this).nextAll().remove();
			if(region_id != ''){
				tis.region_id = region_id;
				getRegionList(opt.postUrl, {parent_id:region_id}, tis);
			}
		})
		$(".form-group").on('click','.changeRegion',function(){
			$("#regiondata").html("");
			getRegionList(opt.postUrl, false,tis);
		})
	}
	function getRegionList(url,postParam,tis){
		if(!url){
			layer.alert('ajax post 地址不存在，请检查错误！');
			return false;
		}
    	var postData = {};
    	if(postParam){
    		postData = postParam;
    	}else{
			postData.parent_id = 1;
		}
		var load = layer.msg("加载中...",{icon: 16,time:10000});
		$.post(url, postData,function(data){
			var data = data.data;
			if(data && data.length > 0){
				var option = '<select class="input">';
					option +='<option value="">--请选择--</option>';
				$.each(data,function(i,e){
					option += '<option value="'+e.id+'">'+e.name+'</option>';
				})
				option += '</select> ';
				$("#regiondata").append(option);
				$("#region_id").val('');
			}else{
				if(tis.region_id > 0){
					var region_name = '';
					var option = tis.find("select.input option:selected");
					$.each(option,function(i,e){
						region_name += e.text+' ';
					})
					region_name = $.trim(region_name);
					//debug(region_name);
					$("#region_id").val(tis.region_id);
					$("#region_name").val(region_name);
				}
			}
			layer.close(load);
		})
	}
})( jQuery );