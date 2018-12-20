function initMenu(data){	
	var topNav = '';
	var maxHistoryLength = 5;
	initNav(data);
		
	/* 初始化侧边菜单 */
	/* 初始化顶部导航 */
	function initNav(data){		
		//记录打开位置
		var n = '';
		var m = $('#siderbar-nav a:first').data('m');
		var c = $('#siderbar-nav a:first').data('c');
		var a = $('#siderbar-nav a:first').data('a');
					
		//绑定菜单连接
		$('#siderbar-nav').on('click','a',function(){
			var m = $(this).attr('data-m');
			var c = $(this).attr('data-c');
			var a = $(this).attr('data-a');			
			var menu = '';
			if(m!='' && m!=undefined) {menu += '_'+m;}
			if(c!='' && c!=undefined) {menu += '_'+c;}
			if(a!='' && a!=undefined) {menu += '_'+a;}
			sessionStorage.setItem("activeMenu",menu);
			var url = $(this).attr('url');
			$('.admin-iframe').attr('src',url);
			//设置样式
			$('#siderbar-nav li').removeClass('active');
			$(this).parent('li').addClass('active');
			$(".nav-box").addClass("fold");
			$(this).parents(".nav-box").removeClass("fold");
			//记录打开位置TODO
		});
		//绑定菜单鼠标经过事件
		$('#siderbar-nav').on('mouseenter','.nav-box',function(){
			var h = $(this).find(".nav-head").height();
			var t = $(this).find(".nav-head").offset().top - 65;
			$("#nav-bar").css({height:h,top:t})
		})
		$('#siderbar-nav').on('mouseleave','.nav-box',function(){
			var t = $("#nav-bar").offset().top - ($("#nav-bar").height())
			$("#nav-bar").css({height:0,top:t})
		})
		//绑定菜单鼠标经过事件
		$('.admin-nav-box').on('mouseenter','.nav-item',function(){
			var w = $(this).children("a").outerWidth();
			var l = $(this).offset().left;
			$("#top-bar").css({width:w,left:l})
		})
		$('.admin-nav-box').on('mouseleave','.nav-item',function(){
			var l = $("#top-bar").offset().left + ($("#top-bar").width()/2)
			$("#top-bar").css({width:0,left:l})
		})
		//绑定菜单折叠事件
		$('#siderbar-nav').on('click','.nav-head',function(){
			if($(this).parent().hasClass("fold")){
				$(".nav-box").addClass("fold");			
				$(this).parent().toggleClass("fold");
			}else{
				$(this).parent().addClass("fold");
			}
		})
		var hisM = sessionStorage.getItem("activeMenu");
		if(hisM){
			//打开菜单
			$('#siderbar-nav #menu'+hisM).click();
		}else{
			//打开菜单
			$('#siderbar-nav a:first').click();
		}
		$("#backHome").click(function(){
			$('#siderbar-nav a:first').click();
		})
	}
	
	$('.admin-head').on('click','.sideflag',function(){
		if($("body").hasClass("side-none")){
			$("body").removeClass("side-none");
			//$(this).find("span").removeClass('icon-toright');
			//$(this).find("span").addClass('icon-toleft');
		}else{			
			$("body").addClass("side-none");
			//$(this).find("span").removeClass('icon-toleft');
			//$(this).find("span").addClass('icon-toright');
		}
	})
	$('.admin-sidebar').on('click','#siderbar-nav',function(){
		$("body").removeClass("side-none");
	})
	$("#siderbar-nav .nav-head").hover(function(){
		if($("body").hasClass("side-none")){
			var that = $(this);
			var text = that.find(".head-name").text();
			Do.ready('dialog', function () {
				layer.tips(text, that,{tips:[2,'#333']});
			})
		}
	},function(){
		Do.ready('dialog', function () {		
			layer.closeAll();
		})
	})
	
}