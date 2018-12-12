(function($){
	$.fn.ajaxsin = function( opt ) {
		var dataType = '';
		if(opt.datatype){
			dataType = 'datatype="'+opt.datatype+'"';
		}
		var disableData = '';
		if(opt.disableData){
			disableData = ' disabled="'+opt.disableData+' "';
		}
		var html = '<div class="label"><label class="labelName">'+opt.str+'</label></div>'
				+'<div class="field" id="data">'
   		+'<div class="margin-bottom float-left select-lists"><select class="select-list from-list input overflow-hidden" name="'+opt.name+'" '+disableData + dataType+' size="10"></select><div class="panel-foot table-foot clearfix pages"></div></div>';
		if($(".form-"+opt.name).length > 0){
			if(opt.value && opt.value!=""){
				$(".form-"+opt.name).html(html);
			}else{
				$(".form-"+opt.name).remove();
			}
		}else{
			var newHtml = '<div class="form-group form-'+opt.name+'">';
			newHtml += html;
			newHtml += '</div>';
			$(this).parent().parent().after(newHtml);
		}
		//alert($(".form-"+opt.name).length);
		if($(".form-"+opt.name).length > 0){
			tis = $(".form-"+opt.name);
			getAjaxData(opt.ajaxUrl,opt.value,tis,opt.predata);
			tis.off('click','.pagination a');
			tis.on('click','.pagination a', function(){
				var url = $(this).attr('url').trim();
				if(url){
					getAjaxData(url,opt.value,tis,opt.predata);
				}
			});	
		}
	}
	$.fn.ajaxmul = function( opt ) {
		var dataType = '';
		if(opt.datatype){
			dataType = 'datatype="'+opt.datatype+'"';
		}
		if(opt.hide != undefined && opt.hide){
			$(this).html('');	
			return false;
		}
		var html = '<div class="label"><label class="labelName">'+opt.str+'</label></div>'
				+'<div class="field" id="data"><div class="margin-bottom form-search-box"><input type="text" class="input" name="keyword" size="40" value="" placeholder="'+opt.searchName+'"><a class="button bg-green icon-search" id="search"> 搜索</a></div>'
   		+'<div class="margin-bottom float-left select-lists"><select class="select-list from-list input overflow-hidden" multiple="multiple"></select><div class="panel-foot table-foot clearfix pages"></div></div>'
    	+'<div class="float-left margin-left button-toolbar vertical-top"><p class="toTop button bg select-move icon-toright"></p><p class="toRight button bg select-move icon-right"></p><p class="toLeft button bg select-move icon-left"></p><p class="toBottom button bg select-move icon-toleft"></p><div class="list_top"></div></div>'
    	+'<div class="margin-bottom float-left margin-left overflow-hidden"><select class="choose-list to-list input" multiple="multiple"></select><select '+dataType+' multiple="multiple" name="'+opt.name+'[]" class="hide sub-list"></select></div></div>';
		
		$(this).html(html);		
		var tis = $(this);
		var postParam = opt.postData ? opt.postData: true;
		var initData = opt.initData ? opt.initData: null;
		if(initData){
			getInitData(initData,tis);
		}
		getSearchData(opt.ajaxUrl, postParam, tis);
		tis.off('click','p.toRight');
		$(this).on('click','p.toRight', function(){
			var value = text = '';
			var htmlStr=htmlSubStr='';
        	tis.find("select.from-list option:selected").each(function(){
        		value = $(this).val();
				text  = $(this).text();
        		var length = tis.find("select.to-list option[value='"+value+"']").length;
        		if(length >= 1){
        			layer.msg( $(this).html()+'已选择');
        			//return false;
        		}else{
        			htmlStr += '<option value="'+value+'">'+ $(this).html()+'</option>';	
					htmlSubStr += '<option value="'+value+'" selected="selected">'+text+'</option>';				
				}
        		//$(this).remove();
        	});
        	tis.find("select.to-list").append(htmlStr);
			tis.find("select.sub-list").append(htmlSubStr);
		})
		tis.off('click','p.toLeft');
		$(this).on('click','p.toLeft', function(){
        	var value = '';
			var htmlStr='';
        	tis.find("select.to-list option:selected").each(function(){
        		value = $(this).val();
				tis.find("select.sub-list option[value='"+value+"']").remove();
        		$(this).remove();
        	});
        	//tis.find("select.from-list").append(htmlStr);
        });		
        tis.off('click','p.toTop');
        $(this).on('click','p.toTop',function(){
        	var toLeftVal = tis.find("select.from-list").html();
        	tis.find("select.to-list").html(toLeftVal);
        	tis.find(".list_top").html(toLeftVal);
        	var toleftVal3 = tis.find(".list_top").find('option').attr('selected','selected');
        	tis.find("select.sub-list").html(toleftVal3);
        });
        tis.off('click','p.toBottom');
        $(this).on('click','p.toBottom',function(){
        	tis.find("select.to-list").html(null);
        	tis.find("select.sub-list").html(null);
        });
		tis.off('click','a#search');
		$(this).on('click','a#search', function(){					
    		var keyword = tis.find("input[name='keyword']").val().trim();
    		if(!keyword){
    			layer.alert(opt.searchName);
				return false;
    		}
			var postParam = opt.postData ? opt.postData: true;
    		getSearchData(opt.postUrl, postParam,tis);
    	});
		tis.off('click','.pagination a');
    	$(this).on('click','.pagination a', function(){
        	var url = $(this).attr('url').trim();
        	if(url){
				var postParam = opt.postData ? opt.postData: true;
        		getSearchData(url, postParam,tis);
        	}
        });
	}
	//区域单选
	$.fn.selectsin = function( opt ) {
		var dataType = '';
		if(opt.datatype){
			dataType = 'datatype="'+opt.datatype+'"';
		}
		var html = '<div class="label"><label class="labelName">'+opt.str+'</label></div>'
				+'<div class="field" id="data"><div class="margin-bottom form-search-box"><input type="text" class="input" name="keyword" size="40" value="" placeholder="'+opt.searchName+'"><a class="button bg-green icon-search" id="search"> 搜索</a></div>'
   		+'<div class="margin-bottom float-left select-lists"><select class="select-list from-list input overflow-hidden" name="'+opt.name+'" '+dataType+'  size="10"></select><div class="panel-foot table-foot clearfix pages"></div></div>';
		$(this).html(html);
		var tis = $(this);
		var postParam = opt.postData ? opt.postData: false;
		getSearchDataSingle(opt.postUrl, postParam,tis);
		tis.off('click','a#search');
		$(this).on('click','a#search', function(){					
    		var keyword = tis.find("input[name='keyword']").val().trim();
    		if(!keyword){
    			layer.alert(opt.searchName);
				return false;
    		}
			var postParam = opt.postData ? opt.postData: true;
    		getSearchDataSingle(opt.postUrl, postParam,tis);
    	});
		tis.off('click','.pagination a');
    	$(this).on('click','.pagination a', function(){
        	var url = $(this).attr('url').trim();
        	if(url){
				var postParam = opt.postData ? opt.postData: true;
        		getSearchDataSingle(url, postParam,tis);
        	}
        });	
	}
	//区域多选
	$.fn.selectmul = function( opt ) {
		var tis = $(this);
		var dataType = '';
		if(opt.datatype){
			dataType = 'datatype="'+opt.datatype+'"';
		}
		var disableData = '';
		if(tis.attr('disableData')){
			disableData = ' disabled="'+tis.attr('disableData')+' "';
		}
		if(tis.attr('hide') != undefined){
			return false;
		}
		var html = '<div class="label"><label class="labelName">'+opt.str+'</label></div>'
				+'<div class="field" id="data"><div class="margin-bottom form-search-box"><input type="text" class="input" name="keyword" size="40" value="" placeholder="'+opt.searchName+'"><a class="button bg-green icon-search" id="search"> 搜索</a></div>'
   		+'<div class="margin-bottom float-left select-lists"><select class="select-list from-list input overflow-hidden" multiple="multiple"></select><div class="panel-foot table-foot clearfix pages"></div></div>'
    	+'<div class="float-left margin-left button-toolbar vertical-top"><p class="toTop button bg select-move icon-toright"></p><p class="toRight button bg select-move icon-right"></p><p class="toLeft button bg select-move icon-left"></p><p class="toBottom button bg select-move icon-toleft"></p><div class="list_top"></div></div>'
    	+'<div class="margin-bottom float-left margin-left overflow-hidden"><select '+disableData+' class="choose-list to-list input" multiple="multiple"></select><select '+dataType+' multiple="multiple" name="'+opt.name+'[]" class="hide sub-list"></select></div></div>';
		
		$(this).html(html);
		var postParam = opt.postData ? opt.postData: true;
		var initData = opt.initData ? opt.initData: null;
		if(initData){
			getInitData(initData,tis);
		}
		getSearchData(opt.postUrl, postParam, tis);
		if(tis.attr('disableData')){
			return false;
		}
		tis.off('click','p.toRight');
		$(this).on('click','p.toRight', function(){
			var value = text = '';
			var htmlStr=htmlSubStr='';
        	tis.find("select.from-list option:selected").each(function(){
        		value = $(this).val();
				text  = $(this).text();
        		var length = tis.find("select.to-list option[value='"+value+"']").length;
        		if(length >= 1){
        			layer.msg( $(this).html()+'已选择');
        			//return false;
        		}else{
        			htmlStr += '<option value="'+value+'">'+ $(this).html()+'</option>';	
					htmlSubStr += '<option value="'+value+'" selected="selected">'+text+'</option>';				
				}
        		//$(this).remove();
        	});
        	tis.find("select.to-list").append(htmlStr);
			tis.find("select.sub-list").append(htmlSubStr);
		})
		tis.off('click','p.toLeft');
		$(this).on('click','p.toLeft', function(){
        	var value = '';
			var htmlStr='';
        	tis.find("select.to-list option:selected").each(function(){
        		value = $(this).val();
				tis.find("select.sub-list option[value='"+value+"']").remove();
        		$(this).remove();
        	});
        	//tis.find("select.from-list").append(htmlStr);
        });		
        tis.off('click','p.toTop');
        $(this).on('click','p.toTop',function(){
        	var toLeftVal = tis.find("select.from-list").html();
        	tis.find("select.to-list").html(toLeftVal);
        	tis.find(".list_top").html(toLeftVal);
        	var toleftVal3 = tis.find(".list_top").find('option').attr('selected','selected');
        	tis.find("select.sub-list").html(toleftVal3);
        });
        tis.off('click','p.toBottom');
        $(this).on('click','p.toBottom',function(){
        	tis.find("select.to-list").html(null);
        	tis.find("select.sub-list").html(null);
        });
		tis.off('click','a#search');
		$(this).on('click','a#search', function(){					
    		var keyword = tis.find("input[name='keyword']").val().trim();
    		if(!keyword){
    			layer.alert(opt.searchName);
				return false;
    		}
			var postParam = opt.postData ? opt.postData: true;
    		getSearchData(opt.postUrl, postParam,tis);
    	});
		tis.off('click','.pagination a');
    	$(this).on('click','.pagination a', function(){
        	var url = $(this).attr('url').trim();
        	if(url){
				var postParam = opt.postData ? opt.postData: true;
        		getSearchData(url, postParam,tis);
        	}
        });
	}
	getAjaxData = function(url,postParam,tis,predata){
		if(!url){
			layer.alert('ajax post 地址不存在，请检查错误！');
			return false;
		}
    	var postData = {};
    	postData.isPage = 1;
    	if(postParam){
    		postData.value = postParam;
			postData.page = 1;
			//postData = $.extend(postData, postParam);
    	}
		var load = layer.msg("加载中...",{icon: 16,time:10000});
    	$.post(url, postData,function(data){
			var htmlStr = '';
			if(data!= '[]'){
				if(data.info){
					layer.alert(data.info);
					return false;
				}
				result = data;
				//result = eval('('+data+')');
				if(result.data.length == 0){
					tis.find("select.from-list").html('');
					tis.find("div.pages").html('');
					layer.alert('对应数据不存在，请重新查询！');
					return false;
				}
				$.each(result.data, function(i, item){
					htmlStr += '<option value="'+item.id+'"';
					if(predata == item.id && predata != '' && predata != 'undefind'){
						htmlStr += ' selected';
					}
					htmlStr += '>'+ item.name+'</option>';
				});
				tis.show();
				tis.find("select.from-list").html(htmlStr);
				tis.find("div.pages").html(result.page);
			}else{
				layer.alert('对应数据不存在，请重新查询！');
			}
			layer.close(load);
		});
	}
	getSearchDataSingle = function(url, postParam,tis){
		if(!url){
			layer.alert('ajax post 地址不存在，请检查错误！');
			return false;
		}
    	var postData = {};
    	postData.isPage = 1;
    	if(postParam){
    		postData.word = tis.find("input[name='keyword']").val().trim();
			postData.page = 1;
			postData = $.extend(postData, postParam);
    	}
		var load = layer.msg("加载中...",{icon: 16,time:10000});
    	$.post(url, postData,function(data){
			var htmlStr = '';
			if(data!= '[]'){
				if(data.info){
					layer.alert(data.info);
					return false;
				}
				result = data;
				//result = eval('('+data+')');
				if(result.data.length == 0){
					tis.find("select.from-list").html('');
					tis.find("div.pages").html('');
					if(postParam){
						layer.alert('对应数据不存在，请重新查询！');
					}else{
						layer.closeAll();
					}
					return false;
				}
				var fromValue = tis.attr('formvalue');
				$.each(result.data, function(i, item){
					htmlStr += '<option value="'+item.id+'" '+ (fromValue == item.id ? 'selected' : '') +'>'+ item.name+'</option>';
				});
				tis.show();
				tis.find("select.from-list").html(htmlStr);
				tis.find("div.pages").html(result.page);
			}else{
				layer.alert('对应数据不存在，请重新查询！');
			}
			layer.close(load);
		});
	}
	getSearchData = function(url, postParam,tis){
		var postData = {};
		postData.isPage = 1;
		if(postParam){
			postData.word = tis.find("input[name='keyword']").val().trim();
			postData.page = 1;
			postData = $.extend(postData, postParam);
		}
		if(!url){
			layer.alert('ajax post 地址不存在，请检查错误！');
			return false;
		}
		var load = layer.msg("加载中...",{icon: 16,time:10000});
		$.post(url, postData,function(data){
			//debug(data);
			var htmlStr = '';
			if(data!= '[]'){
				if(data.info){
					layer.alert(data.info);
					return false;
				}
				result = data;
				//result = eval('('+data+')');
				if(result.data.length == 0 || result.data == "undefind"){
					tis.find("select.from-list").html('');
					tis.find("div.pages").html('');
					layer.alert('对应数据不存在，请重新查询！');
					return false;
				}
				$.each(result.data, function(i, item){
					htmlStr += '<option value="'+item.id+'">'+ item.name+'</option>';
				});
				tis.show();
				tis.find("select.from-list").html(htmlStr);
				tis.find("div.pages").html(result.page);
			}else{
				layer.alert('对应数据不存在，请重新查询！');
			}
			layer.close(load);
		});
	}
	getInitData = function(initData,tis){
		var result = eval('('+initData+')');
		if(result.length == 0 || result == "undefind"){
			//tis.find("select.to-list").html('');
			layer.alert('初始化失败');
			return false;
		}else{
			var htmlStr = '';
			var htmlSelect = '';
			$.each(result, function(i, item){
				htmlStr += '<option value="'+item.id+'">'+ item.name+'</option>';
				tis.find("select.to-list").html(htmlStr);
				htmlSelect += '<option selected value="'+item.id+'">'+ item.name+'</option>';
				tis.find("select.sub-list").html(htmlSelect);
			});
		}
	}
})( jQuery );