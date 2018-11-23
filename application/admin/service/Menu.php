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
                'name' => lang('厂商管理'),
                'order' => 10,
                'icon'  => 'user-setting',
                'menu' => [
                    'store'   => [
                        'name'    => lang('厂商管理'),
                        'list'    => [
                            'store' => [
                                'name' => lang('厂商列表'),
                                'url' => url("factory/index"),
                                'order' => 10
                            ],
                        ]
                    ],
                ]
            ],
            'channel' => [
                'name' => lang('渠道管理'),
                'order' => 10,
                'icon'  => 'user-group',
                'menu' => [
                    'channel'   => [
                        'name'    => lang('渠道商管理'),
                        'list'    => [
                            'index' => [
                                'name' => lang('渠道商列表'),
                                'url' => url("channel/index"),
                                'order' => 10
                            ],
                            
                        ]
                    ],
                    'cgrade'   => [
                        'name'    => lang('渠道等级管理'),
                        'list'    => [
                            'index' => [
                                'name' => lang('渠道商等级'),
                                'url' => url("cgrade/index"),
                                'order' => 10
                            ],
                            
                        ]
                    ],
                ]
            ],
            'dealer' => [
                'name' => lang('经销商管理'),
                'order' => 10,
                'icon'  => 'sitemap',
                'menu' => [
                    'dealer'   => [
                        'name'    => lang('经销商管理'),
                        'list'    => [
                            'dealer' => [
                                'name' => lang('经销商列表'),
                                'url' => url("dealer/index"),
                                'order' => 10
                            ],
                        ]
                    ],
                ]
            ],
            'servicer' => [
                'name' => lang('服务商管理'),
                'order' => 10,
                'icon'  => 'user-list',
                'menu' => [
                    'servicer'   => [
                        'name'    => lang('服务商管理'),
                        'list'    => [
                            'index' => [
                                'name' => lang('服务商列表'),
                                'url' => url("servicer/index"),
                                'order' => 10
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
                        'name'    =>  lang('产品管理'),
                        'list'    =>  [
                            'goods' => [
                                'name' => lang('产品管理'),
                                'url' => url('goods/index'),
                                'order' => 10
                            ],
                            'gcate' => [
                                'name' => lang('产品分类'),
                                'url' => url('gcate/index'),
                                'order' => 20
                            ],
                            'spec' => [
                                'name' => lang('产品规格'),
                                'url' => url('gspec/index'),
                                'order' => 20
                            ],
                        ]
                    ],
//                     'order' => [
//                         'name'    =>  lang('订单管理'),
//                         'list'    =>  [
//                             'index' => [
//                                 'name' => lang('订单管理'),
//                                 'url' => url('order/index'),
//                                 'order' => 10
//                             ],
//                             'payment' => [
//                                 'name' => lang('支付方式'),
//                                 'url' => url('payment/index'),
//                                 'order' => 10
//                             ],
//                         ]
//                     ],
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
                                'url' => url('ugroup/index'),
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
                                'url' => url('ugroup/index'),
                                'order' => 10
                            ],
                            'device' => [
                                'name' => lang('设备数据'),
                                'url' => url('ugroup/index'),
                                'order' => 10
                            ],
                            'finance' => [
                                'name' => lang('财务数据'),
                                'url' => url('ugroup/index'),
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
                                'url' => url('ugroup/index'),
                                'order' => 10
                            ],
                            'shipping' => [
                                'name' => lang('配送服务'),
                                'url' => url('ugroup/index'),
                                'order' => 10
                            ],
                            'repair' => [
                                'name' => lang('维修服务'),
                                'url' => url('ugroup/index'),
                                'order' => 10
                            ],
                            'comment' => [
                                'name' => lang('服务评价'),
                                'url' => url('ugroup/index'),
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
                                'url' => url('ugroup/index'),
                                'order' => 10
                            ],
                            'device' => [
                                'name' => lang('工作区管理'),
                                'url' => url('ugroup/index'),
                                'order' => 10
                            ],
                            'paymethod' => [
                                'name' => lang('支付方式'),
                                'url' => url('ugroup/index'),
                                'order' => 10
                            ],
                            'rule' => [
                                'name' => lang('规则配置'),
                                'url' => url('ugroup/index'),
                                'order' => 10
                            ],
                            'channel' => [
                                'name' => lang('渠道配置'),
                                'url' => url('ugroup/index'),
                                'order' => 10
                            ],
                        ]
                    ]
                ]
            ],
        ];
        return $menuArr;
    }
    public function getFactoryMenu(){
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
            'channel' => [
                'name' => lang('渠道管理'),
                'order' => 10,
                'icon'  => 'sitemap',
                'menu' => [
                    'channel'   => [
                        'name'    => lang('渠道商管理'),
                        'list'    => [
                            'index' => [
                                'name' => lang('渠道商列表'),
                                'url' => url("channel/index"),
                                'order' => 10
                            ],
                            
                        ]
                    ],
                    'cgrade'   => [
                        'name'    => lang('渠道等级管理'),
                        'list'    => [
                            'index' => [
                                'name' => lang('渠道商等级'),
                                'url' => url("cgrade/index"),
                                'order' => 10
                            ],
                            
                        ]
                    ],
                ]
            ],
            'dealer' => [
                'name' => lang('经销商管理'),
                'order' => 10,
                'icon'  => 'sitemap',
                'menu' => [
                    'dealer'   => [
                        'name'    => lang('经销商管理'),
                        'list'    => [
                            'dealer' => [
                                'name' => lang('经销商列表'),
                                'url' => url("dealer/index"),
                                'order' => 10
                            ],
                        ]
                    ],
                ]
            ],
            'servicer' => [
                'name' => lang('服务商管理'),
                'order' => 10,
                'icon'  => 'sitemap',
                'menu' => [
                    'servicer'   => [
                        'name'    => lang('服务商管理'),
                        'list'    => [
                            'index' => [
                                'name' => lang('服务商列表'),
                                'url' => url("servicer/index"),
                                'order' => 10
                            ],
                        ]
                    ],
                ]
            ],
            'content' => [
                'name' => lang('产品库管理'),
                'order' => 20,
                'icon'  => 'store',
                'menu' => [
                    'goods' => [
                        'name'    =>  lang('产品管理'),
                        'list'    =>  [
                            'goods' => [
                                'name' => lang('产品管理'),
                                'url' => url('goods/index'),
                                'order' => 10
                            ],
                            'gcate' => [
                                'name' => lang('产品分类'),
                                'url' => url('gcate/index'),
                                'order' => 20
                            ],
                            'spec' => [
                                'name' => lang('产品规格'),
                                'url' => url('gspec/index'),
                                'order' => 20
                            ],
                        ]
                    ],
                ]
            ],
            'member' => [
                'name' => lang('成员管理'),
                'order' => 30,
                'icon'  => 'user-group',
                'menu' => [
                    'user' => [
                        'name'    =>  lang('用户角色'),
                        'list'    =>  [
                            'member' => [
                                'name' => lang('角色列表'),
                                'url' => url('ugroup/index'),
                                'order' => 10
                            ],
                        ]
                    ]
                ]
            ],
        ];
        return $menuArr;
    }
    public function getChannelMenu(){
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
            'content' => [
                'name' => lang('采购管理'),
                'order' => 20,
                'icon'  => 'store',
                'menu' => [
                ]
            ],
            'member' => [
                'name' => lang('成员管理'),
                'order' => 30,
                'icon'  => 'user-group',
                'menu' => [
                    'user' => [
                        'name'    =>  lang('用户角色'),
                        'list'    =>  [
                            'member' => [
                                'name' => lang('角色列表'),
                                'url' => url('ugroup/index'),
                                'order' => 10
                            ],
                        ]
                    ]
                ]
            ],
        ];
        return $menuArr;
    }
    public function getDealerMenu(){
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
            'content' => [
                'name' => lang('采购管理'),
                'order' => 20,
                'icon'  => 'store',
                'menu' => [
                ]
            ],
        ];
        return $menuArr;
    }
    public function getServiceMenu(){
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
            'content' => [
                'name' => lang('安装员管理'),
                'order' => 20,
                'icon'  => 'store',
                'menu' => [
                ]
            ],
            'content' => [
                'name' => lang('派单管理'),
                'order' => 20,
                'icon'  => 'store',
                'menu' => [
                ]
            ],
        ];
        return $menuArr;
    }
}