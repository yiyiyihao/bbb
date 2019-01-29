
CREATE TABLE `wja_help` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cate_id` int(10) unsigned DEFAULT '0' COMMENT '公类ID',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '标题',
  `answer` text NOT NULL COMMENT '回复',
  `visible_store_type` varchar(255) DEFAULT '' COMMENT '可见商户角色',
  `is_del` tinyint(2) NOT NULL DEFAULT '0' COMMENT '0正常，1已删除',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '1显示，0不显示',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE `wja_help_cate` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '分类名称',
  `is_del` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0正常，1已删除',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0禁用，1启用',
  `sort_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='帮助分类';
