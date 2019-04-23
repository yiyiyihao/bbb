KindEditor.plugin('goods', function(K) {
	var editor = this, name = 'goods';
        // 点击图标时执行
        editor.clickToolbar(name, function() {
			//editor.insertHtml('你好');
			layer.open({
				  type: 2,
				  title: '选择商品',
				  shadeClose: true,
				  shade: 0.3,
				  area: ['700px', '538px'],
				  content: '/goods/choose', //iframe的url
				  success: function(layero, index){
					var body = layer.getChildFrame('body', index);
					var iframeWin = window[layero.find('iframe')[0]['name']]; //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
					//console.log(body.html()) //得到iframe页的body内容
					//body.find("#chose").text('Hi，我是从父页来的');
					body.find("#submit").click(function(){
						var goodsInfo = iframeWin.getGoodsInfo();
						//console.log(goodsInfo);
						if(goodsInfo){
							editor.insertHtml(goodsInfo);
							layer.close(index);
						}
					})
				  }
			});
        });
});
