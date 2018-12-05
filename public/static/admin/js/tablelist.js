(function($){
	$.fn.TableList = function( opt ) {
		var type = '';
		//通用多级子菜单处理
		function typeChild(type){
			$("."+type+"-all .button").click(function(){
				var childType = $(this).find('input').val();
				$("#type_extend").val(childType);
				$("."+type).hide();
				$("."+type+"."+type+"-all").show();
				$("."+type+"."+type+"-"+childType).show();
			})
			$("."+type+" .button:first").trigger("click");
		}
		function textType(){
			$(".textType").show();
		}
		function functionType(){
			$(".functionType").show();
		}
		function indexType(){
			$(".indexType").show();
		}
		function iconType(){
			$(".iconType").show();
		}
		function imageType(){
			$(".imageType").show();
		}
		function buttonType(){
			typeChild("buttonType");
		}
		
		$(".js-type-select select").change(function(){
			$(".textExtend .form-group").hide();
			type = $(this).val();
			$("#type").val(type);
			switch (type){
				case '1':
				textType();
				break;
				case '2':
				functionType();
				break;
				case '3':
				indexType();
				break;
				case '4':
				iconType();
				break;
				case '5':
				imageType();
				break;
				case '6':
				buttonType();
				break;
			}
		})
	}
})( jQuery );