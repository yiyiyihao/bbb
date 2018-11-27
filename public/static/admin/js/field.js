(function($){
	$.fn.Field = function( opt ) {
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
			typeChild("textType");
		}
		function textArea(){
			$(".textArea").show();
		}
		function radioType(){
			$(".radioType").show();
		}
		function checkBox(){
			typeChild("checkBox");
		}
		function selectType(){
			typeChild("selectType");
		}
		function imgUpload(){
			typeChild("imgUpload");
		}
		function editor(){}
		$(".js-type-select select").change(function(){			
			$(".textExtend .form-group").hide();
			type = $(this).val();
			$("#type").val(type);
			switch (type){
				case '1':
				textType();
				break;
				case '2':
				textArea();
				break;
				case '3':
				radioType();
				break;
				case '4':
				checkBox();
				break;
				case '5':
				selectType();
				break;
				case '6':
				imgUpload();
				break;
				case '7':
				editor();
				break;
			}
		})
	}
})( jQuery );