<?php
namespace app\admin\service;
/**
 * 后台授权树
 */
class Purview{
    /**
     * 获取用户组授权树
     */
    public function getGroupPurview($groupPurview = FALSE){
        $menuArr = [
            'index'   => [    //控制器名称
                'name'  =>  '数据汇总',
                'list'  =>  [
                    '*'     =>  [
                        'name'  =>  lang('全部'),
                        'type'  =>  'all',
                    ],
                    'index' =>  [
                        'name'  =>  lang('后台登陆'),
                        'type'  =>  'single',
                    ],
                    'home'  => [
                        'name'  =>  lang('客流分析'),
                        'type'  =>  'single',
                    ],
                    'person'  => [
                        'name'  =>  lang('访客详情'),
                        'type'  =>  'single',
                    ],
                    'store'  => [
                        'name'  =>  lang('门店分析'),
                        'type'  =>  'single',
                    ],
                ],
            ],
            'store'   => [    //控制器名称
                'name'  =>  '门店管理',
                'list'  =>  [
                    '*'     =>  [
                        'name'  =>  lang('全部'),
                        'type'  =>  'all',
                    ],
                    'index' =>  [
                        'name'  =>  lang('门店列表'),
                        'type'  =>  'single',
                    ],
                    'add'  => [
                        'name'  =>  lang('添加门店'),
                        'type'  =>  'single',
                    ],
                    'edit'  => [
                        'name'  =>  lang('修改门店'),
                        'type'  =>  'single',
                    ],
                    'del'  => [
                        'name'  =>  lang('删除门店'),
                        'type'  =>  'single',
                    ],
                ],
            ],
            'block'   => [    //控制器名称
                'name'  =>  '区域管理',
                'list'  =>  [
                    '*'     =>  [
                        'name'  =>  lang('全部'),
                        'type'  =>  'all',
                    ],
                    'index' =>  [
                        'name'  =>  lang('区域列表'),
                        'type'  =>  'single',
                    ],
                    'add'  => [
                        'name'  =>  lang('添加区域'),
                        'type'  =>  'single',
                    ],
                    'edit'  => [
                        'name'  =>  lang('修改区域'),
                        'type'  =>  'single',
                    ],
                    'del'  => [
                        'name'  =>  lang('删除区域'),
                        'type'  =>  'single',
                    ],
                ],
            ],
            'dgroup'   => [    //控制器名称
                'name'  =>  '设备分组',
                'list'  =>  [
                    '*'     =>  [
                        'name'  =>  lang('全部'),
                        'type'  =>  'all',
                    ],
                    'index' =>  [
                        'name'  =>  lang('分组列表'),
                        'type'  =>  'single',
                    ],
                    'add'  => [
                        'name'  =>  lang('添加分组'),
                        'type'  =>  'single',
                    ],
                    'edit'  => [
                        'name'  =>  lang('修改分组'),
                        'type'  =>  'single',
                    ],
                    'del'  => [
                        'name'  =>  lang('删除分组'),
                        'type'  =>  'single',
                    ],
                ],
            ],
            'device'   => [    //控制器名称
                'name'  =>  '设备管理',
                'list'  =>  [
                    '*'     =>  [
                        'name'  =>  lang('全部'),
                        'type'  =>  'all',
                    ],
                    'index' =>  [
                        'name'  =>  lang('设备列表'),
                        'type'  =>  'single',
                    ],
                    'add'  => [
                        'name'  =>  lang('添加设备'),
                        'type'  =>  'single',
                    ],
                    'edit'  => [
                        'name'  =>  lang('修改设备'),
                        'type'  =>  'single',
                    ],
                    'del'  => [
                        'name'  =>  lang('删除设备'),
                        'type'  =>  'single',
                    ],
                    'authorize' =>  [
                        'name'  =>  lang('设备授权'),
                        'type'  =>  'single',
                    ],
                ],
            ],
            'ugroup'   => [    //控制器名称
                'name'  =>  '用户分组',
                'list'  =>  [
                    '*'     =>  [
                        'name'  =>  lang('全部'),
                        'type'  =>  'all',
                    ],
                    'index' =>  [
                        'name'  =>  lang('分组列表'),
                        'type'  =>  'single',
                    ],
                    'add'  => [
                        'name'  =>  lang('添加分组'),
                        'type'  =>  'single',
                    ],
                    'edit'  => [
                        'name'  =>  lang('修改分组'),
                        'type'  =>  'single',
                    ],
                    'del'  => [
                        'name'  =>  lang('删除分组'),
                        'type'  =>  'single',
                    ],
                    'purview'  => [
                        'name'  =>  lang('分组搜权'),
                        'type'  =>  'single',
                    ],
                ],
            ],
            'member'   => [    //控制器名称
                'name'  =>  '用户管理',
                'list'  =>  [
                    '*'     =>  [
                        'name'  =>  lang('全部'),
                        'type'  =>  'all',
                    ],
                    'index' =>  [
                        'name'  =>  lang('用户列表'),
                        'type'  =>  'single',
                    ],
                    'add'  => [
                        'name'  =>  lang('添加用户'),
                        'type'  =>  'single',
                    ],
                    'edit'  => [
                        'name'  =>  lang('修改用户'),
                        'type'  =>  'single',
                    ],
                    'del'  => [
                        'name'  =>  lang('删除用户'),
                        'type'  =>  'single',
                    ],
                ],
            ],
        ];
        return $menuArr;
    }
}
