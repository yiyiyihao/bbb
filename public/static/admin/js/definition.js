//base载入
Do.add('baseJs', {
    path: Config.baseDir + 'base.js',
});

Do.add('base', {
    path: Config.libDir + 'lib.js',
    requires: ['baseJs']
});
//加载系统菜单
Do.add('adminMenuJS', {
    path: Config.libDir + 'adminMenu.js',
    requires: ['base']
});
//echart 图表
Do.add('eChart', {
    path: Config.libDir + 'echarts.min.js',
	//path: Config.libDir + 'echarts.js',
});
//editor
Do.add('editorCss',{
    path : Config.libDir + 'keditor4.1/themes/default/default.css',
    type : 'css'
});
Do.add('editorSrc', {
    path: Config.libDir + 'keditor4.1/kindeditor.js',
    requires : ['editorCss']
});
Do.add('editor', {
    path: Config.libDir + 'keditor4.1/lang/zh-CN.js',
    requires: ['editorSrc']
});

Do.ready('base', function () {});