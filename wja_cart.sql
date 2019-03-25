/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50721
Source Host           : localhost:3306
Source Database       : zxj

Target Server Type    : MYSQL
Target Server Version : 50721
File Encoding         : 65001

Date: 2019-03-25 14:27:04
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for wja_cart
-- ----------------------------
DROP TABLE IF EXISTS `wja_cart`;
CREATE TABLE `wja_cart` (
  `cart_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '购物车ID',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0',
  `seller_udata_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '卖家udata_id',
  `udata_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '买家udata_id',
  `sku_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品规格属性ID',
  `goods_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `num` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '商品数量',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '加入购物车时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`cart_id`),
  KEY `seller_udata_id` (`seller_udata_id`),
  KEY `udata_id` (`udata_id`)
) ENGINE=MyISAM AUTO_INCREMENT=109 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;
