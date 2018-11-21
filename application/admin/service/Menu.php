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
                'name' => lang('home'),
                'order' => 0,
                'icon'  => 'home',
                'menu' => [
                    'analysis' => [
                        'name'  => lang('dashboard'),
                        'list'  => [
                            'index' => [
                                'name' => lang('dashboard'),
                                'url' => url('home'),
                                'order' => 10
                            ],
                        ]
                    ],
                ]
            ],
		    'channel' => [
		        'name' => lang('渠道管理'),
		        'order' => 10,
		        'icon'  => 'sitemap',
		        'menu' => [
		            'channel'   => [
		                'name'    => lang('渠道管理'),
		                'list'    => [
		                    'index' => [
		                        'name' => lang('渠道列表'),
		                        'url' => url("channel/index"),
		                        'order' => 10
		                    ],
		                ]
		            ],
		        ]
		    ],
		    'product' => [
		        'name' => lang('商品管理'),
		        'order' => 20,
		        'icon'  => 'store',
		        'menu' => [
		            'product' => [
		                'name'    =>  lang('商品管理'),
		                'list'    =>  [
		                    'product' => [
		                        'name' => lang('商品管理'),
		                        'url' => url('product/index'),
		                        'order' => 10
		                    ],
		                    'category' => [
		                        'name' => lang('商品分类'),
		                        'url' => url('category/index'),
		                        'order' => 20
		                    ],
		                    'type' => [
		                        'name' => lang('商品类型'),
		                        'url' => url('product/type'),
		                        'order' => 30
		                    ],
		                    'spec' => [
		                        'name' => lang('商品规格'),
		                        'url' => url('gspec/index'),
		                        'order' => 40
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
		                    'index' => [
		                        'name' => lang('用户列表'),
		                        'url' => url('member/index'),
		                        'order' => 10
		                    ],
		                    'group' => [
		                        'name' => lang('角色管理'),
		                        'url' => url('member/group'),
		                        'order' => 20
		                    ],
		                ]
		            ]
		        ]
		    ],
		    'order' => [
		        'name' => lang('订单管理'),
		        'order' => 40,
		        'icon'  => 'list-book',
		        'menu' => [
		            'order' => [
		                'name'    =>  lang('订单管理'),
		                'list'    =>  [
		                    'index' => [
		                        'name' => lang('订单列表'),
		                        'url' => url('order/index'),
		                        'order' => 10
		                    ],
		                ]
		            ]
		        ]
		    ],
		    'finance' => [
		        'name' => lang('财务管理'),
		        'order' => 50,
		        'icon'  => 'pay-list',
		        'menu' => [
		            'finance' => [
		                'name'    =>  lang('财务管理'),
		                'list'    =>  [
		                    'index' => [
		                        'name' => lang('财务主页'),
		                        'url' => url('finance/index'),
		                        'order' => 10
		                    ],
		                    'order' => [
		                        'name' => lang('进货账单'),
		                        'url' => url('finance/order'),
		                        'order' => 20
		                    ],
		                    'channel' => [
		                        'name' => lang('渠道账单'),
		                        'url' => url('finance/channel'),
		                        'order' => 30
		                    ],
		                    'works' => [
		                        'name' => lang('施工账单'),
		                        'url' => url('finance/works'),
		                        'order' => 40
		                    ],
		                ]
		            ]
		        ]
		    ],
		    /*'dataset' => [
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
		    ],*/
		    'service' => [
		        'name' => lang('售后管理'),
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
