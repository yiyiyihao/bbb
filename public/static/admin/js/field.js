(function($){
	$.fn.Field = function( opt ) {
		var type = '';
		function textType(){
			$(".textType .button").click(function(){
				var textType = $(this).find('input').val();
				$(".textType").hide();
				$(".textType.textType-all").show();
				$(".textType.textType-"+textType).show();
			})
			$(".textType .button:first").trigger("click");
		}
		function textArea(){
			$(".textArea").show();
		}
		$(".js-type-select select").change(function(){			
			$(".textExtend .form-group").hide();
			type = $(this).val();
			switch (type){
				case '1':
				textType();
				break;
				case '2':
				textArea();
				break;
				case '3':
				redioType();
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