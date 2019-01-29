/*
Navicat MySQL Data Transfer

Source Server         : wamp
Source Server Version : 50724
Source Host           : localhost:3306
Source Database       : wanjiaan

Target Server Type    : MYSQL
Target Server Version : 50724
File Encoding         : 65001

Date: 2019-01-29 11:12:01
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for wja_help
-- ----------------------------
DROP TABLE IF EXISTS `wja_help`;
CREATE TABLE `wja_help` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上级ID',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '标题',
  `answer` text NOT NULL COMMENT '回复',
  `visible_store_type` varchar(255) DEFAULT '' COMMENT '可见商户角色',
  `is_del` tinyint(2) NOT NULL DEFAULT '0' COMMENT '0正常，1已删除',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '1显示，0不显示',
  `sort_order` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `help_parent_id` (`parent_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
