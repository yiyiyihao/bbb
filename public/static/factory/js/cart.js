/**
 * 购物车ajax请求
 */
var cart = {
	add:function(goods_id,skuid,nums,action,callback){ //添加到购物车
		
		$.ajax({
		   type: "GET",
		   async: false,
		   url: "/cart/ajax_add",
		   data: "goods_id="+goods_id+"&skuid="+skuid+"&nums="+nums+"&action="+action,
		   success: function(res){
	     	 callback(res);
		   }
		});
	},
	del:function(goods_id,skuid,cart_callback){ //从购物车删除商品
        $.ajax({
		   type: "GET",
		   async: false,
		   url: "/cart/ajax_del",
		   data: "goods_id="+goods_id+"&skuid="+skuid,
		   success: function(res){
	     	 layer.msg(res.message);
	     	 if(res.status) cart_callback(res);
		   }
		});
    },
	nums:function(goods_id,skuid,nums,type,cart_callback){ //从购物车删除商品
        $.ajax({
		   type: "GET",
		   async: false,
		   url: "/cart/ajax_num",
		   data: "goods_id="+goods_id+"&skuid="+"&nums="+nums+"&type="+type,
		   success: function(res){
	       		if(res.status) cart_callback(res);
		   }
		});
    },
	total:function(cart_callback){ //从购物车删除商品
        $.ajax({
		   type: "GET",
		   async: false,
		   url: "/cart/ajax_total",
		   success: function(res){
	     	 cart_callback(res);
		   }
		});
    }
}