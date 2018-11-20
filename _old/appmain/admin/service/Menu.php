<?php
namespace app\admin\service;
/**
 * 后台菜单接口
 */
class Menu{
	/**
	 * 获取菜单结构
	 */
	public function getAdminMenu(){
		$menuArr = [
            'index' => [
                'name' => lang('主页'),
                'order' => 0,
                'icon'  => 'home',
                'menu' => [
                    'analysis' => [
                        'name'  => lang('数据汇总'),
                        'list'  => [
                            'index' => [
                                'name' => lang('首页'),
                                'url' => url('home'),
                                'order' => 10
                            ],
                        ]
                    ],
                ]
            ],
		    'store' => [
		        'name' => lang('供应链管理'),
		        'order' => 10,
		        'icon'  => 'sitemap',
		        'menu' => [
		            'store'   => [
		                'name'    => lang('产品库管理'),
		                'list'    => [
		                    'store' => [
		                        'name' => lang('产品列表'),
		                        'url' => url("store/index"),
		                        'order' => 10
		                    ],
		                ]
		            ],
		            'device'  => [
		                'name'    =>  lang('流通数据'),
		                'list'    => [
		                    'list' => [
		                        'name' => lang('数据报表'),
		                        'url' => url('device/index'),
		                        'order' => 20
		                    ],
		                    'group' => [
		                        'name' => lang('流通溯源'),
		                        'url' => url('dgroup/index'),
		                        'order' => 30
		                    ],
		                ]
		            ],
		        ]
		    ],
		    'content' => [
		        'name' => lang('电商管理'),
		        'order' => 20,
		        'icon'  => 'store',
		        'menu' => [
		            'goods' => [
		                'name'    =>  lang('商品管理'),
		                'list'    =>  [
		                    'goods' => [
		                        'name' => lang('商品管理'),
		                        'url' => url('product/index'),
		                        'order' => 10
		                    ],
		                    'gcategory' => [
		                        'name' => lang('商品分类'),
		                        'url' => url('category/index'),
		                        'order' => 20
		                    ],
		                    'spec' => [
		                        'name' => lang('商品规格'),
		                        'url' => url('gspec/index'),
		                        'order' => 20
		                    ],
		                ]
		            ],
		            'order' => [
		                'name'    =>  lang('订单管理'),
		                'list'    =>  [
		                    'index' => [
		                        'name' => lang('订单管理'),
		                        'url' => url('order/index'),
		                        'order' => 10
		                    ],
		                    'payment' => [
		                        'name' => lang('支付方式'),
		                        'url' => url('payment/index'),
		                        'order' => 10
		                    ],
		                ]
		            ],
		        ]
		    ],
		    'user' => [
		        'name' => lang('用户管理'),
		        'order' => 30,
		        'icon'  => 'user-group',
		        'menu' => [
		            'user' => [
		                'name'    =>  lang('用户角色'),
		                'list'    =>  [
		                    'member' => [
		                        'name' => lang('角色列表'),
		                        'url' => url('member/index'),
		                        'order' => 10
		                    ],
		                ]
		            ]
		        ]
		    ],
		    'dataset' => [
		        'name' => lang('数据管理'),
		        'icon'  => 'chart',
		        'order' => 60,
		        'menu' => [
		            'user' => [
		                'name'    =>  lang('数据管理'),
		                'list'    =>  [
		                    'sale' => [
		                        'name' => lang('业务数据'),
		                        'url' => url('member/index'),
		                        'order' => 10
		                    ],
		                    'device' => [
		                        'name' => lang('设备数据'),
		                        'url' => url('member/index'),
		                        'order' => 10
		                    ],
		                    'finance' => [
		                        'name' => lang('财务数据'),
		                        'url' => url('member/index'),
		                        'order' => 10
		                    ],
		                ]
		            ]
		        ]
		    ],
		    'service' => [
		        'name' => lang('售后服务'),
		        'order' => 60,
		        'icon'  => 'kefu',
		        'menu' => [
		            'user' => [
		                'name'    =>  lang('售后服务'),
		                'list'    =>  [
		                    'install' => [
		                        'name' => lang('安装服务'),
		                        'url' => url('member/index'),
		                        'order' => 10
		                    ],
		                    'shipping' => [
		                        'name' => lang('配送服务'),
		                        'url' => url('member/index'),
		                        'order' => 10
		                    ],
		                    'repair' => [
		                        'name' => lang('维修服务'),
		                        'url' => url('member/index'),
		                        'order' => 10
		                    ],
		                    'comment' => [
		                        'name' => lang('服务评价'),
		                        'url' => url('member/index'),
		                        'order' => 10
		                    ],
		                ]
		            ]
		        ]
		    ],
		    'setting' => [
		        'name' => lang('系统管理'),
		        'order' => 80,
		        'icon'  => 'setting',
		        'menu' => [
		            'user' => [
		                'name'    =>  lang('系统管理'),
		                'list'    =>  [
		                    'sale' => [
		                        'name' => lang('核心配置'),
		                        'url' => url('member/index'),
		                        'order' => 10
		                    ],
		                    'device' => [
		                        'name' => lang('工作区管理'),
		                        'url' => url('member/index'),
		                        'order' => 10
		                    ],
		                    'paymethod' => [
		                        'name' => lang('支付方式'),
		                        'url' => url('member/index'),
		                        'order' => 10
		                    ],
		                    'rule' => [
		                        'name' => lang('规则配置'),
		                        'url' => url('member/index'),
		                        'order' => 10
		                    ],
		                    'channel' => [
		                        'name' => lang('渠道配置'),
		                        'url' => url('member/index'),
		                        'order' => 10
		                    ],
		                ]
		            ]
		        ]
		    ],
        ];
		return $menuArr;
	}
}
