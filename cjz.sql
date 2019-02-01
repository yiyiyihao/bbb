
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




/*
Navicat MySQL Data Transfer

Source Server         : wamp
Source Server Version : 50724
Source Host           : localhost:3306
Source Database       : wanjiaan

Target Server Type    : MYSQL
Target Server Version : 50724
File Encoding         : 65001

Date: 2019-02-01 17:24:26
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for wja_auth_rule
-- ----------------------------
DROP TABLE IF EXISTS `wja_auth_rule`;
CREATE TABLE `wja_auth_rule` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '权限节点类型 1 管理员操作节点配置 2 厂商操作节点配置 3 渠道商操作节点配置 4 服务商操作节点配置 5 零售商操作节点配置',
  `module` varchar(80) NOT NULL DEFAULT '' COMMENT 'module节点',
  `controller` varchar(80) NOT NULL DEFAULT '' COMMENT 'controller节点',
  `action` varchar(80) NOT NULL DEFAULT '' COMMENT 'action节点',
  `title` varchar(20) NOT NULL DEFAULT '' COMMENT '节点名称',
  `icon` varchar(20) NOT NULL DEFAULT '' COMMENT '样式',
  `parent_id` int(5) unsigned NOT NULL DEFAULT '0' COMMENT '父栏目ID',
  `authopen` tinyint(2) NOT NULL DEFAULT '1' COMMENT '开启权限验证',
  `sort_order` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `menustatus` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=170 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='权限节点';

-- ----------------------------
-- Records of wja_auth_rule
-- ----------------------------
INSERT INTO `wja_auth_rule` VALUES ('1', '1', 'admin', '', '', '平台操作权限', '', '0', '1', '10', '1', '1', '1543802558', '1543802578', '0');
INSERT INTO `wja_auth_rule` VALUES ('2', '1', 'factory', '', '', '厂商管理权限', '', '0', '1', '20', '1', '1', '1543802607', '1543802617', '0');
INSERT INTO `wja_auth_rule` VALUES ('3', '1', 'admin', 'index', '', '后台登录', 'home', '1', '1', '10', '1', '1', '1543802677', '1543802727', '0');
INSERT INTO `wja_auth_rule` VALUES ('4', '1', 'admin', 'index', 'home', '后台首页', '', '3', '1', '20', '1', '1', '1543802716', '1543815694', '0');
INSERT INTO `wja_auth_rule` VALUES ('5', '1', 'factory', 'index', '', '后台首页', 'home', '2', '1', '20', '1', '1', '1543804363', '1543804415', '0');
INSERT INTO `wja_auth_rule` VALUES ('6', '1', 'factory', 'index', 'home', '概况', '', '5', '1', '30', '1', '1', '1543804391', '1543804399', '0');
INSERT INTO `wja_auth_rule` VALUES ('7', '1', 'factory', '', '', '系统配置', 'setting', '2', '1', '30', '1', '1', '1543807532', '1543807615', '0');
INSERT INTO `wja_auth_rule` VALUES ('8', '1', 'factory', 'system', '', '权限配置', '', '7', '1', '10', '1', '1', '1543807604', '1543807604', '0');
INSERT INTO `wja_auth_rule` VALUES ('9', '1', 'factory', 'user', 'index', '账户管理', '', '7', '1', '20', '1', '1', '1543807654', '1543807654', '0');
INSERT INTO `wja_auth_rule` VALUES ('10', '1', 'factory', 'system', 'factory', '厂商配置', '', '7', '1', '30', '1', '1', '1543807714', '1543807714', '0');
INSERT INTO `wja_auth_rule` VALUES ('11', '1', 'factory', 'system', 'servicer', '服务商配置', '', '7', '1', '40', '1', '1', '1543807754', '1543807754', '1');
INSERT INTO `wja_auth_rule` VALUES ('12', '1', 'factory', 'goods', '', '商品管理', 'tips', '2', '1', '40', '1', '1', '1543808011', '1543808011', '0');
INSERT INTO `wja_auth_rule` VALUES ('13', '1', 'factory', 'goods', 'index', '商品列表', '', '12', '1', '10', '1', '1', '1543808047', '1543808047', '0');
INSERT INTO `wja_auth_rule` VALUES ('14', '1', 'factory', 'merchant', '', '商户管理', 'user-setting', '2', '1', '50', '1', '1', '1543808090', '1543808157', '0');
INSERT INTO `wja_auth_rule` VALUES ('15', '1', 'factory', 'finance', '', '财务管理', 'ticket-list', '2', '1', '60', '1', '1', '1543808132', '1543808132', '0');
INSERT INTO `wja_auth_rule` VALUES ('16', '1', 'factory', 'installer', '', '售后工程师', 'user', '2', '1', '70', '1', '1', '1543814053', '1543814053', '0');
INSERT INTO `wja_auth_rule` VALUES ('17', '1', 'factory', 'workorder', '', '工单管理', 'list-done', '2', '1', '80', '1', '1', '1543814156', '1543814156', '0');
INSERT INTO `wja_auth_rule` VALUES ('18', '1', 'factory', 'goods', 'add', '新增商品', '', '12', '1', '20', '0', '1', '1543816983', '1543816983', '0');
INSERT INTO `wja_auth_rule` VALUES ('19', '1', 'factory', 'goods', 'edit', '编辑商品', '', '12', '1', '30', '0', '1', '1543817012', '1543817012', '0');
INSERT INTO `wja_auth_rule` VALUES ('20', '1', 'factory', 'goods', 'del', '删除商品', '', '12', '1', '40', '0', '1', '1543817045', '1543817045', '0');
INSERT INTO `wja_auth_rule` VALUES ('21', '1', 'factory', 'goods', 'detail', '商品编辑第二步', '', '12', '1', '50', '0', '1', '1543817108', '1547091102', '0');
INSERT INTO `wja_auth_rule` VALUES ('22', '1', 'factory', 'gcate', 'index', '商品分类', '', '12', '1', '60', '1', '1', '1543817270', '1543817353', '0');
INSERT INTO `wja_auth_rule` VALUES ('23', '1', 'factory', 'gcate', 'add', '新增分类', '', '12', '1', '70', '0', '1', '1543817342', '1543817416', '0');
INSERT INTO `wja_auth_rule` VALUES ('24', '1', 'factory', 'gcate', 'edit', '编辑分类', '', '12', '1', '80', '0', '1', '1543817398', '1543817409', '0');
INSERT INTO `wja_auth_rule` VALUES ('25', '1', 'factory', 'gcate', 'del', '删除分类', '', '12', '1', '90', '0', '1', '1543817456', '1543817456', '0');
INSERT INTO `wja_auth_rule` VALUES ('26', '1', 'admin', 'authrule', '', '权限管理', 'star', '1', '1', '20', '1', '1', '1543818043', '1543818111', '0');
INSERT INTO `wja_auth_rule` VALUES ('27', '1', 'admin', 'authrule', 'index', '权限列表', '', '26', '1', '30', '1', '1', '1543818086', '1543818201', '0');
INSERT INTO `wja_auth_rule` VALUES ('28', '1', 'admin', 'factory', '', '厂商管理', 'user-setting', '1', '1', '30', '1', '1', '1543818177', '1543818177', '0');
INSERT INTO `wja_auth_rule` VALUES ('29', '1', 'admin', 'factory', 'index', '厂商列表', '', '28', '1', '10', '1', '1', '1543818243', '1543818243', '0');
INSERT INTO `wja_auth_rule` VALUES ('30', '1', 'admin', 'factory', 'add', '新增厂商', '', '28', '1', '20', '0', '1', '1543818281', '1543818322', '0');
INSERT INTO `wja_auth_rule` VALUES ('31', '1', 'admin', 'factory', 'edit', '编辑厂商', '', '28', '1', '30', '0', '1', '1543818312', '1543818312', '0');
INSERT INTO `wja_auth_rule` VALUES ('32', '1', 'admin', 'factory', 'del', '删除厂商', '', '28', '1', '40', '0', '1', '1543818347', '1543818347', '0');
INSERT INTO `wja_auth_rule` VALUES ('33', '1', 'admin', 'sysadmin', '', '系统配置', 'setting', '1', '1', '40', '1', '1', '1543818855', '1543818855', '0');
INSERT INTO `wja_auth_rule` VALUES ('34', '1', 'admin', 'ugroup', 'index', '角色管理', '', '33', '1', '10', '1', '1', '1543818920', '1543818920', '0');
INSERT INTO `wja_auth_rule` VALUES ('35', '1', 'factory', 'channel', 'index', '渠道商列表', '', '14', '1', '10', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('36', '1', 'factory', 'channel', 'add', '新增渠道商', '', '14', '1', '11', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('37', '1', 'factory', 'channel', 'edit', '编辑渠道商', '', '14', '1', '12', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('38', '1', 'factory', 'channel', 'del', '删除渠道商', '', '14', '1', '13', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('39', '1', 'factory', 'dealer', 'index', '零售商列表', '', '14', '1', '20', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('40', '1', 'factory', 'dealer', 'add', '新增零售商', '', '14', '1', '21', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('41', '1', 'factory', 'dealer', 'edit', '编辑零售商', '', '14', '1', '22', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('42', '1', 'factory', 'dealer', 'del', '删除零售商', '', '14', '1', '23', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('43', '1', 'factory', 'servicer', 'index', '服务商列表', '', '14', '1', '30', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('44', '1', 'factory', 'servicer', 'add', '新增服务商', '', '14', '1', '31', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('45', '1', 'factory', 'servicer', 'edit', '编辑服务商', '', '14', '1', '32', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('46', '1', 'factory', 'servicer', 'del', '删除服务商', '', '14', '1', '33', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('47', '1', 'factory', 'installer', 'index', '工程师列表', '', '16', '1', '10', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('48', '1', 'factory', 'installer', 'add', '新增工程师', '', '16', '1', '11', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('49', '1', 'factory', 'installer', 'edit', '编辑工程师', '', '16', '1', '12', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('50', '1', 'factory', 'installer', 'del', '删除工程师', '', '16', '1', '13', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('51', '1', 'factory', 'workorder', 'index', '安装工单列表', '', '17', '1', '9', '1', '1', '1543974007', '1547007737', '0');
INSERT INTO `wja_auth_rule` VALUES ('52', '1', 'factory', 'workorder', 'add', '新增工单', '', '17', '1', '11', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('53', '1', 'factory', 'workorder', 'edit', '编辑工单', '', '17', '1', '12', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('54', '1', 'factory', 'workorder', 'del', '删除工单', '', '17', '1', '13', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('55', '1', 'factory', 'gspec', 'index', '商品规格列表', '', '12', '1', '100', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('56', '1', 'factory', 'gspec', 'add', '新增商品规格', '', '12', '1', '101', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('57', '1', 'factory', 'gspec', 'edit', '编辑商品规格', '', '12', '1', '102', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('58', '1', 'factory', 'gspec', 'del', '删除商品规格', '', '12', '1', '103', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('59', '1', 'factory', 'finance', 'index', '财务管理', '', '15', '1', '10', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('60', '1', 'factory', 'purchase', '', '采购管理', 'money', '2', '1', '90', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('61', '1', 'factory', 'purchase', 'index', '采购列表', '', '60', '1', '10', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('62', '1', 'factory', 'purchase', 'detail', '商品详情', '', '60', '1', '11', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('63', '1', 'factory', 'purchase', 'confirm', '确认并提交订单', '', '60', '1', '12', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('64', '1', 'factory', 'myorder', 'index', '我的订单', '', '60', '1', '20', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('65', '1', 'factory', 'myorder', 'detail', '订单详情', '', '60', '1', '22', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('66', '1', 'factory', 'myorder', 'cancel', '取消订单', '', '60', '1', '22', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('67', '1', 'factory', 'myorder', 'deliverylogs', '查看物流', '', '60', '1', '23', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('68', '1', 'factory', 'myorder', 'finish', '确认收货', '', '60', '1', '24', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('69', '1', 'factory', 'myorder', 'pay', '订单付款', '', '60', '1', '21', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('70', '1', 'factory', 'order', '', '订单管理', 'list-dot', '2', '1', '110', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('72', '1', 'factory', 'order', 'detail', '订单详情', '', '70', '1', '11', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('71', '1', 'factory', 'order', 'index', '订单列表', '', '70', '1', '10', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('73', '1', 'factory', 'order', 'pay', '确认收款', '', '70', '1', '12', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('74', '1', 'factory', 'order', 'cancel', '取消订单', '', '70', '1', '13', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('75', '1', 'factory', 'order', 'updateprice', '调整订单金额', '', '70', '1', '14', '0', '1', '1543974007', '1543974007', '1');
INSERT INTO `wja_auth_rule` VALUES ('76', '1', 'factory', 'order', 'delivery', '订单商品发货', '', '70', '1', '15', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('77', '1', 'factory', 'order', 'deliverylogs', '查看发货物流', '', '70', '1', '16', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('78', '1', 'factory', 'order', 'finish', '确认完成', '', '70', '1', '17', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('79', '1', 'factory', 'channel', 'manager', '渠道商管理员设置', '', '14', '1', '14', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('80', '1', 'factory', 'dealer', 'manager', '零售商管理员设置', '', '14', '1', '24', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('81', '1', 'factory', 'servicer', 'manager', '服务商管理员设置', '', '14', '1', '34', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('82', '1', 'factory', 'suborder', 'index', '零售商订单', '', '60', '1', '30', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('83', '1', 'factory', 'bulletin', 'index', '公告管理', '', '7', '1', '10', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('84', '1', 'factory', 'bulletin', 'add', '新增公告', '', '7', '1', '11', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('85', '1', 'factory', 'bulletin', 'edit', '编辑公告', '', '7', '1', '12', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('86', '1', 'factory', 'bulletin', 'publish', '发布公告', '', '7', '1', '13', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('87', '1', 'factory', 'bulletin', 'del', '删除公告', '', '7', '1', '14', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('88', '1', 'factory', 'commission', 'index', '收益明细', '', '15', '1', '20', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('89', '1', 'admin', 'assess', 'index', '评价系统配置', '', '33', '1', '20', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('90', '1', 'factory', 'suborder', 'detail', '零售商订单查看', '', '60', '1', '40', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('91', '1', 'admin', 'system', 'default', '默认数据配置', '', '33', '1', '30', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('92', '1', 'factory', 'finance', 'setting', '提现设置', '', '15', '1', '30', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('93', '1', 'factory', 'finance', 'apply', '申请提现', '', '15', '1', '60', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('94', '1', 'factory', 'security', 'index', '保证金列表', '', '15', '1', '40', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('95', '1', 'factory', 'order', 'finance', '财务订单', '', '15', '1', '50', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('96', '1', 'factory', 'user', 'add', '新增账户', '', '7', '1', '21', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('97', '1', 'factory', 'user', 'edit', '编辑账户', '', '7', '1', '22', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('98', '1', 'factory', 'user', 'del', '删除账户', '', '7', '1', '23', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('99', '1', 'factory', 'finance', 'check', '提现审核', '', '15', '1', '60', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('100', '1', 'factory', 'installer', 'check', '审核', '', '16', '1', '60', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('101', '1', 'factory', 'workorder', 'dispatch', '分派工单', '', '17', '1', '14', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('102', '1', 'factory', 'workorder', 'detail', '工单详情', '', '17', '1', '15', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('103', '1', 'factory', 'workorder', 'cancel', '取消工单', '', '17', '1', '16', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('104', '1', 'factory', 'myorder', 'return', '退货/退款', '', '60', '1', '25', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('105', '1', 'factory', 'service', 'index', '售后订单', '', '60', '1', '50', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('106', '1', 'factory', 'service', 'seller', '售后订单', '', '70', '1', '50', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('107', '1', 'factory', 'service', 'detail', '售后订单详情', '', '70', '1', '50', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('108', '1', 'factory', 'service', 'check', '售后审核', '', '70', '1', '50', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('109', '1', 'factory', 'service', 'detail', '售后订单详情', '', '60', '1', '50', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('110', '1', 'factory', 'service', 'cancel', '取消售后', '', '60', '1', '60', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('111', '1', 'factory', 'service', 'cancel', '取消售后', '', '70', '1', '60', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('112', '1', 'factory', 'service', 'delivery', '填写退货物流', '', '60', '1', '70', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('113', '1', 'factory', 'service', 'refund', '售后退款', '', '70', '1', '70', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('114', '1', 'factory', 'bulletin', 'detail', '公告详情', '', '7', '1', '10', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('115', '1', 'factory', 'installer', 'detail', '工程师详情', '', '16', '1', '255', '0', '1', '1544509254', '1544509254', '0');
INSERT INTO `wja_auth_rule` VALUES ('116', '1', 'factory', 'workorder', 'assess', '工单评价', '', '17', '1', '17', '0', '1', '1544585792', '1544585805', '0');
INSERT INTO `wja_auth_rule` VALUES ('117', '1', 'factory', 'payment', 'index', '支付列表', '', '7', '1', '40', '1', '1', '1544585792', '1544585792', '0');
INSERT INTO `wja_auth_rule` VALUES ('118', '1', 'factory', 'payment', 'config', '支付配置', '', '7', '1', '41', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('119', '1', 'factory', 'payment', 'del', '删除支付配置', '', '7', '1', '42', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('120', '1', 'admin', 'system', 'sms', '短信配置', '', '33', '1', '43', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('121', '1', 'factory', 'channel', 'resetpwd', '重置渠道商密码', '', '14', '1', '15', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('122', '1', 'factory', 'dealer', 'resetpwd', '重置零售商密码', '', '14', '1', '25', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('123', '1', 'factory', 'servicer', 'resetpwd', '重置服务商密码', '', '14', '1', '35', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('124', '1', 'factory', 'index', 'profile', '个人资料', '', '5', '1', '50', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('125', '1', 'factory', 'index', 'password', '修改密码', '', '5', '1', '60', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('126', '1', 'factory', 'system', 'wxacode', '服务商二维码', '', '7', '1', '30', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('127', '1', 'factory', 'channel', 'detail', '渠道商详情', 'detail', '14', '1', '12', '0', '1', '1545969621', '1545969621', '0');
INSERT INTO `wja_auth_rule` VALUES ('128', '1', 'factory', 'dealer', 'detail', '零售商详情', 'detail', '14', '1', '22', '0', '1', '1545969686', '1545969686', '0');
INSERT INTO `wja_auth_rule` VALUES ('129', '1', 'factory', 'servicer', 'detail', '服务商详情', 'detail', '14', '1', '32', '0', '1', '1545969708', '1545969708', '0');
INSERT INTO `wja_auth_rule` VALUES ('130', '1', 'factory', 'store', 'index', '入驻申请列表', 'list', '14', '1', '40', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('131', '1', 'factory', 'store', 'detail', '入驻申请详情', 'detail', '14', '1', '41', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('132', '1', 'factory', 'store', 'check', '入驻审核', 'check', '14', '1', '42', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('133', '1', 'factory', 'storeaction', 'index', '操作申请列表', 'lise', '14', '1', '50', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('134', '1', 'factory', 'storeaction', 'detail', '操作申请详情', 'detail', '14', '1', '51', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('135', '1', 'factory', 'storeaction', 'check', '操作审核', 'check', '14', '1', '52', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('136', '1', 'factory', 'workorder', 'lists', '维修工单列表', 'list', '17', '1', '10', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('137', '1', 'factory', 'finance', 'detail', '提现详情', '', '15', '1', '70', '0', '1', '1546412498', '1546412498', '0');
INSERT INTO `wja_auth_rule` VALUES ('138', '1', 'factory', 'site', '', '网站管理', 'home', '2', '1', '120', '1', '1', '1547184080', '1547184711', '0');
INSERT INTO `wja_auth_rule` VALUES ('139', '1', 'factory', 'site', 'setting', '基本设置', '', '138', '1', '10', '1', '1', '1547184208', '1547184208', '0');
INSERT INTO `wja_auth_rule` VALUES ('140', '1', 'factory', 'site', 'menu', '导航列表', '', '138', '1', '20', '1', '1', '1547184298', '1547184298', '0');
INSERT INTO `wja_auth_rule` VALUES ('141', '1', 'factory', 'site', 'add_menu', '新增/编辑导航', '', '138', '1', '21', '0', '1', '1547184384', '1547184384', '0');
INSERT INTO `wja_auth_rule` VALUES ('142', '1', 'factory', 'site', 'del_menu', '删除导航', '', '138', '1', '22', '0', '1', '1547184445', '1547184445', '0');
INSERT INTO `wja_auth_rule` VALUES ('143', '1', 'factory', 'site', 'index', '轮播图列表', '', '138', '1', '30', '1', '1', '1547184512', '1547184512', '0');
INSERT INTO `wja_auth_rule` VALUES ('144', '1', 'factory', 'site', 'banner', '新增/编辑轮播图', '', '138', '1', '31', '0', '1', '1547184582', '1547184582', '0');
INSERT INTO `wja_auth_rule` VALUES ('145', '1', 'factory', 'site', 'del', '删除轮播图', '', '138', '1', '32', '0', '1', '1547184633', '1547184633', '0');
INSERT INTO `wja_auth_rule` VALUES ('146', '1', 'factory', 'article', 'index', '文章列表', '', '138', '1', '40', '1', '1', '1547184687', '1547184687', '0');
INSERT INTO `wja_auth_rule` VALUES ('147', '1', 'factory', 'article', 'add', '新增文章', '', '138', '1', '41', '0', '1', '1547184781', '1547184781', '0');
INSERT INTO `wja_auth_rule` VALUES ('148', '1', 'factory', 'article', 'edit', '编辑文章', '', '138', '1', '42', '0', '1', '1547184848', '1547184848', '0');
INSERT INTO `wja_auth_rule` VALUES ('149', '1', 'factory', 'article', 'del', '删除文章', '', '138', '1', '43', '0', '1', '1547184933', '1547184933', '0');
INSERT INTO `wja_auth_rule` VALUES ('150', '1', 'factory', 'article', 'publish', '发布文章', '', '138', '1', '44', '0', '1', '1547184996', '1547184996', '0');
INSERT INTO `wja_auth_rule` VALUES ('151', '1', 'factory', 'site', 'page', '单页列表', '', '138', '1', '50', '1', '1', '1547185044', '1547185067', '0');
INSERT INTO `wja_auth_rule` VALUES ('152', '1', 'factory', 'site', 'add_page', '新增/编辑单页', '', '138', '1', '51', '0', '1', '1547185104', '1547185104', '0');
INSERT INTO `wja_auth_rule` VALUES ('153', '1', 'factory', 'site', 'del_page', '删除单页', '', '138', '1', '52', '0', '1', '1547185145', '1547185145', '0');
INSERT INTO `wja_auth_rule` VALUES ('154', '1', 'factory', 'activity', '', '营销活动', 'home', '2', '1', '100', '1', '1', '1547185145', '1548638941', '0');
INSERT INTO `wja_auth_rule` VALUES ('155', '1', 'factory', 'activityorder', 'index', '营销订单', '', '154', '1', '10', '1', '1', '1547185145', '1547185145', '0');
INSERT INTO `wja_auth_rule` VALUES ('156', '1', 'factory', 'activityorder', 'detail', '订单详情', '', '154', '1', '11', '0', '1', '1547185145', '1547185145', '0');
INSERT INTO `wja_auth_rule` VALUES ('157', '1', 'factory', 'activityorder', 'pay', '支付订单', '', '154', '1', '12', '0', '1', '1547185145', '1547185145', '0');
INSERT INTO `wja_auth_rule` VALUES ('158', '1', 'factory', 'activityorder', 'cancel', '取消订单', '', '154', '1', '13', '0', '1', '1547185145', '1547185145', '0');
INSERT INTO `wja_auth_rule` VALUES ('159', '1', 'factory', 'activityorder', 'delivery', '确认发货', '', '154', '1', '14', '0', '1', '1547185145', '1547185145', '0');
INSERT INTO `wja_auth_rule` VALUES ('160', '1', 'factory', 'activityorder', 'finish', '确认完成', '', '154', '1', '15', '0', '1', '1547185145', '1547185145', '0');
INSERT INTO `wja_auth_rule` VALUES ('164', '1', 'factory', 'help', '', '帮助管理', '', '7', '1', '43', '1', '1', '1548649061', '1548649186', '0');
INSERT INTO `wja_auth_rule` VALUES ('167', '1', 'admin', 'help', 'index', '帮助管理', '', '33', '1', '50', '1', '1', '1548751372', '1548751372', '0');
INSERT INTO `wja_auth_rule` VALUES ('168', '1', 'admin', 'help_cate', 'index', '帮助分类', '', '33', '1', '50', '1', '1', '1548751564', '1548757964', '0');
INSERT INTO `wja_auth_rule` VALUES ('169', '1', 'factory', 'activity', '', '活动配置', '', '154', '1', '255', '1', '1', '1549003962', '1549003962', '0');
