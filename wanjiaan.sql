/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50721
Source Host           : localhost:3306
Source Database       : wanjiaan

Target Server Type    : MYSQL
Target Server Version : 50721
File Encoding         : 65001

Date: 2018-12-12 09:49:48
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for wja_apilog_app
-- ----------------------------
DROP TABLE IF EXISTS `wja_apilog_app`;
CREATE TABLE `wja_apilog_app` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `request_source` varchar(25) NOT NULL DEFAULT '' COMMENT '请求来源',
  `request_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '请求时间',
  `return_time` int(10) unsigned NOT NULL DEFAULT '0',
  `method` varchar(255) NOT NULL DEFAULT '' COMMENT '接口方法',
  `request_params` text NOT NULL COMMENT '请求参数',
  `return_params` text NOT NULL COMMENT '返回数据',
  `response_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '响应时间',
  `error` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '错误状态',
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='接口访问日志表';

-- ----------------------------
-- Records of wja_apilog_app
-- ----------------------------

-- ----------------------------
-- Table structure for wja_apilog_pay
-- ----------------------------
DROP TABLE IF EXISTS `wja_apilog_pay`;
CREATE TABLE `wja_apilog_pay` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `request_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '请求时间',
  `return_time` int(10) unsigned NOT NULL DEFAULT '0',
  `method` varchar(255) NOT NULL DEFAULT '' COMMENT '支付调用方法',
  `pay_code` varchar(255) NOT NULL DEFAULT '' COMMENT '支付code',
  `order_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '支付订单号',
  `request_params` text NOT NULL COMMENT '请求参数',
  `return_params` text NOT NULL COMMENT '返回数据',
  `response_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '响应时间',
  `error` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '错误状态',
  `error_msg` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='支付日志表';

-- ----------------------------
-- Records of wja_apilog_pay
-- ----------------------------

-- ----------------------------
-- Table structure for wja_apilog_timer
-- ----------------------------
DROP TABLE IF EXISTS `wja_apilog_timer`;
CREATE TABLE `wja_apilog_timer` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `request_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '请求时间',
  `return_time` int(10) unsigned NOT NULL DEFAULT '0',
  `method` varchar(255) NOT NULL DEFAULT '' COMMENT '访问方法',
  `return_params` text NOT NULL COMMENT '返回数据',
  `response_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '响应时间',
  `error` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '错误状态',
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='定时器执行日志';

-- ----------------------------
-- Records of wja_apilog_timer
-- ----------------------------

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
) ENGINE=MyISAM AUTO_INCREMENT=115 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='权限节点';

-- ----------------------------
-- Records of wja_auth_rule
-- ----------------------------
INSERT INTO `wja_auth_rule` VALUES ('1', '1', 'admin', '', '', '平台操作权限', '', '0', '1', '10', '1', '1', '1543802558', '1543802578', '0');
INSERT INTO `wja_auth_rule` VALUES ('2', '1', 'factory', '', '', '厂商管理权限', '', '0', '1', '20', '1', '1', '1543802607', '1543802617', '0');
INSERT INTO `wja_auth_rule` VALUES ('3', '1', 'admin', 'index', '', '后台登录', 'home', '1', '1', '10', '1', '1', '1543802677', '1543802727', '0');
INSERT INTO `wja_auth_rule` VALUES ('4', '1', 'admin', 'index', 'home', '后台首页', '', '3', '1', '20', '1', '1', '1543802716', '1543815694', '0');
INSERT INTO `wja_auth_rule` VALUES ('5', '1', 'factory', 'index', '', '后台登录', 'home', '2', '1', '20', '1', '1', '1543804363', '1543804415', '0');
INSERT INTO `wja_auth_rule` VALUES ('6', '1', 'factory', 'index', 'home', '后台首页', '', '5', '1', '30', '1', '1', '1543804391', '1543804399', '0');
INSERT INTO `wja_auth_rule` VALUES ('7', '1', 'factory', '', '', '系统配置', 'setting', '2', '1', '30', '1', '1', '1543807532', '1543807615', '0');
INSERT INTO `wja_auth_rule` VALUES ('8', '1', 'factory', 'system', '', '权限配置', '', '7', '1', '10', '1', '1', '1543807604', '1543807604', '0');
INSERT INTO `wja_auth_rule` VALUES ('9', '1', 'factory', 'user', 'index', '账户管理', '', '7', '1', '20', '1', '1', '1543807654', '1543807654', '0');
INSERT INTO `wja_auth_rule` VALUES ('10', '1', 'factory', 'system', 'factory', '厂商配置', '', '7', '1', '30', '1', '1', '1543807714', '1543807714', '0');
INSERT INTO `wja_auth_rule` VALUES ('11', '1', 'factory', 'system', 'servicer', '服务商配置', '', '7', '1', '40', '1', '1', '1543807754', '1543807754', '0');
INSERT INTO `wja_auth_rule` VALUES ('12', '1', 'factory', 'goods', '', '产品管理', 'tips', '2', '1', '40', '1', '1', '1543808011', '1543808011', '0');
INSERT INTO `wja_auth_rule` VALUES ('13', '1', 'factory', 'goods', 'index', '产品列表', '', '12', '1', '10', '1', '1', '1543808047', '1543808047', '0');
INSERT INTO `wja_auth_rule` VALUES ('14', '1', 'factory', 'merchant', '', '商户管理', 'user-setting', '2', '1', '50', '1', '1', '1543808090', '1543808157', '0');
INSERT INTO `wja_auth_rule` VALUES ('15', '1', 'factory', 'finance', '', '财务管理', 'ticket-list', '2', '1', '60', '1', '1', '1543808132', '1543808132', '0');
INSERT INTO `wja_auth_rule` VALUES ('16', '1', 'factory', 'installer', '', '售后工程师', 'user', '2', '1', '70', '1', '1', '1543814053', '1543814053', '0');
INSERT INTO `wja_auth_rule` VALUES ('17', '1', 'factory', 'worder', '', '工单管理', 'list-done', '2', '1', '80', '1', '1', '1543814156', '1543814156', '0');
INSERT INTO `wja_auth_rule` VALUES ('18', '1', 'factory', 'goods', 'add', '新增产品', '', '12', '1', '20', '0', '1', '1543816983', '1543816983', '0');
INSERT INTO `wja_auth_rule` VALUES ('19', '1', 'factory', 'goods', 'edit', '编辑产品', '', '12', '1', '30', '0', '1', '1543817012', '1543817012', '0');
INSERT INTO `wja_auth_rule` VALUES ('20', '1', 'factory', 'goods', 'del', '删除产品', '', '12', '1', '40', '0', '1', '1543817045', '1543817045', '0');
INSERT INTO `wja_auth_rule` VALUES ('21', '1', 'factory', 'goods', 'spec', '产品规格属性配置', '', '12', '1', '50', '0', '1', '1543817108', '1543817216', '0');
INSERT INTO `wja_auth_rule` VALUES ('22', '1', 'factory', 'gcate', 'index', '产品分类', '', '12', '1', '60', '1', '1', '1543817270', '1543817353', '0');
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
INSERT INTO `wja_auth_rule` VALUES ('35', '1', 'factory', 'channel', 'index', '渠道列表', '', '14', '1', '10', '1', '1', '1543974007', '1543974007', '0');
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
INSERT INTO `wja_auth_rule` VALUES ('51', '1', 'factory', 'worder', 'index', '工单列表', '', '17', '1', '10', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('52', '1', 'factory', 'worder', 'add', '新增工单', '', '17', '1', '11', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('53', '1', 'factory', 'worder', 'edit', '编辑工单', '', '17', '1', '12', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('54', '1', 'factory', 'worder', 'del', '删除工单', '', '17', '1', '13', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('55', '1', 'factory', 'gspec', 'index', '产品规格列表', '', '12', '1', '100', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('56', '1', 'factory', 'gspec', 'add', '新增产品规格', '', '12', '1', '101', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('57', '1', 'factory', 'gspec', 'edit', '编辑产品规格', '', '12', '1', '102', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('58', '1', 'factory', 'gspec', 'del', '删除产品规格', '', '12', '1', '103', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('59', '1', 'factory', 'finance', 'index', '财务管理', '', '15', '1', '10', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('60', '1', 'factory', 'purchase', '', '采购管理', 'money', '2', '1', '90', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('61', '1', 'factory', 'purchase', 'index', '采购列表', '', '60', '1', '10', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('62', '1', 'factory', 'purchase', 'detail', '产品详情', '', '60', '1', '11', '0', '1', '1543974007', '1543974007', '0');
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
INSERT INTO `wja_auth_rule` VALUES ('96', '1', 'factory', 'user', 'add', '新增账户', '', '7', '1', '50', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('97', '1', 'factory', 'user', 'edit', '编辑账户', '', '7', '1', '50', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('98', '1', 'factory', 'user', 'del', '删除账户', '', '7', '1', '50', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('99', '1', 'factory', 'finance', 'check', '提现审核', '', '15', '1', '60', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('100', '1', 'factory', 'installer', 'check', '审核', '', '16', '1', '60', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('101', '1', 'factory', 'worder', 'dispatch', '分派工单', '', '17', '1', '14', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('102', '1', 'factory', 'worder', 'detail', '工单详情', '', '17', '1', '15', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('103', '1', 'factory', 'worder', 'cancel', '取消工单', '', '17', '1', '16', '0', '1', '1543974007', '1543974007', '0');
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
INSERT INTO `wja_auth_rule` VALUES ('114', '1', 'factory', 'bulletin', 'detail', '公告详情', '', '7', '1', '15', '0', '1', '1543974007', '1543974007', '0');

-- ----------------------------
-- Table structure for wja_bulletin
-- ----------------------------
DROP TABLE IF EXISTS `wja_bulletin`;
CREATE TABLE `wja_bulletin` (
  `bulletin_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商户ID',
  `post_user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新增用户账户ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '公告标题',
  `special_display` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '特殊展示场景:1登录后弹窗显示',
  `description` varchar(1000) NOT NULL DEFAULT '' COMMENT '公告描述',
  `content` text NOT NULL COMMENT '公告内容',
  `store_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '接收公告商户类型(1厂商 2渠道商 3零售商/零售商 4服务商)',
  `region_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '指定区域接收通知(多个区域id用英文逗号分隔)',
  `region_json` varchar(2000) NOT NULL DEFAULT '' COMMENT '指定区域信息(区域id,区域名称),json格式保存',
  `to_store_ids` varchar(2000) NOT NULL DEFAULT '' COMMENT '指定接收公告的商户ID(多个用英文逗号分隔)',
  `is_top` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否置顶',
  `publish_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '发布时间',
  `publish_status` tinyint(1) unsigned DEFAULT '0' COMMENT '发布状态(1已发布0未发布)',
  `sort_order` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '排序',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(0禁用 1正常)',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`bulletin_id`) USING BTREE,
  KEY `store_id` (`store_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='公告数据表';

-- ----------------------------
-- Records of wja_bulletin
-- ----------------------------
INSERT INTO `wja_bulletin` VALUES ('1', '2', '2', '11', '1', '22', '		                  	33		                  ', '2', '[\"undefined\"]', '', '', '0', '1544525725', '1', '1', '1', '0', '1544525725', '0');

-- ----------------------------
-- Table structure for wja_channel_grade
-- ----------------------------
DROP TABLE IF EXISTS `wja_channel_grade`;
CREATE TABLE `wja_channel_grade` (
  `cgrade_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '渠道等级ID',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '厂商ID',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上级等级ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '等级名称',
  `description` varchar(1000) NOT NULL DEFAULT '' COMMENT '等级描述',
  `goods_discount` decimal(5,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '商品折扣(保留小数点后两位)',
  `sort_order` tinyint(1) unsigned NOT NULL DEFAULT '255' COMMENT '排序',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`cgrade_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='渠道等级表';

-- ----------------------------
-- Records of wja_channel_grade
-- ----------------------------

-- ----------------------------
-- Table structure for wja_config
-- ----------------------------
DROP TABLE IF EXISTS `wja_config`;
CREATE TABLE `wja_config` (
  `config_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `post_user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加config用户ID',
  `config_key` varchar(255) NOT NULL DEFAULT '',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '配置信息名称',
  `config_value` text NOT NULL COMMENT '配置对应数据信息详情(string/json/其它)',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配置信息添加时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `sort_order` int(1) unsigned NOT NULL DEFAULT '1',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否启用',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`config_id`) USING BTREE,
  KEY `admin_id` (`post_user_id`) USING BTREE,
  KEY `name` (`name`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='数据配置表';

-- ----------------------------
-- Records of wja_config
-- ----------------------------
INSERT INTO `wja_config` VALUES ('1', '1', 'config_workorder_assess', '服务态度', '5', '1544079691', '1544079691', '1', '1', '0');
INSERT INTO `wja_config` VALUES ('2', '1', 'config_workorder_assess', '专业技能', '5', '1544079783', '1544079933', '1', '1', '0');
INSERT INTO `wja_config` VALUES ('3', '1', 'system_default', '系统默认配置', '{\"order_cancel_minute\":\"1\",\"order_return_day\":\"2\",\"workorder_auto_assess_day\":\"3\",\"monthly_withdraw_start_date\":\"6\",\"monthly_withdraw_end_date\":\"8\",\"withdraw_min_amount\":\"50\",\"withdrawal_work_day\":\"7\",\"ordersku_return_limit\":\"2\"}', '1544155010', '1544497054', '1', '1', '0');

-- ----------------------------
-- Table structure for wja_file
-- ----------------------------
DROP TABLE IF EXISTS `wja_file`;
CREATE TABLE `wja_file` (
  `file_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `qiniu_hash` varchar(255) NOT NULL DEFAULT '' COMMENT '七牛云:已上传资源的校验码,供用户核对使用',
  `qiniu_key` varchar(255) NOT NULL DEFAULT '' COMMENT '七牛云:目标资源的最终名字,可由七牛云存储自动命名',
  `qiniu_domain` varchar(255) NOT NULL DEFAULT '' COMMENT '七牛云:图片保留空间域名',
  `file_path` varchar(255) NOT NULL DEFAULT '' COMMENT '文件访问地址',
  `file_name` varchar(255) NOT NULL DEFAULT '' COMMENT '上传文件原文件名称',
  `file_size` varchar(25) NOT NULL DEFAULT '' COMMENT '文件大小',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`file_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_file
-- ----------------------------
INSERT INTO `wja_file` VALUES ('1', 'Fo0icQ_qiUVkg-AwiqPa4PC0LTqB', 'goods_20181127110724_basicprofile.jpg', 'pimvhcf3v.bkt.clouddn.com', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181127110724_basicprofile.jpg', 'basicprofile.jpg', '11188', '1543288045', '1543288045');
INSERT INTO `wja_file` VALUES ('2', 'FrCT-5YjuNdBbOiY94OuVMbuJK16', 'goods_20181127110736.png', 'pimvhcf3v.bkt.clouddn.com', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181127110736.png', 'cloud_未标题-3.png', '13031', '1543288056', '1543288056');
INSERT INTO `wja_file` VALUES ('3', 'FmQYuophAXVDlPwZHSmOPPssP5sr', 'store_logo_20181127181255_logo1.jpg', 'pimvhcf3v.bkt.clouddn.com', 'http://pimvhcf3v.bkt.clouddn.com/store_logo_20181127181255_logo1.jpg', 'logo1.jpg', '65021', '1543313576', '1543313576');
INSERT INTO `wja_file` VALUES ('4', 'Fpxthn7XjPNUXR10VQaaUoMTvp3m', 'store_logo_20181130105308_71e36e51f7eceec6.png', 'pimvhcf3v.bkt.clouddn.com', 'http://pimvhcf3v.bkt.clouddn.com/store_logo_20181130105308_71e36e51f7eceec6.png', '71e36e51f7eceec6.png', '803940', '1543546389', '1543546389');
INSERT INTO `wja_file` VALUES ('5', 'Fsj7zM1Vb1xS9qtQJgMT9o_cAinS', 'store_logo_20181130142443_c5a77654dd974592.png', 'pimvhcf3v.bkt.clouddn.com', 'http://pimvhcf3v.bkt.clouddn.com/store_logo_20181130142443_c5a77654dd974592.png', 'c5a77654dd974592.png', '831513', '1543559084', '1543559084');

-- ----------------------------
-- Table structure for wja_form_field
-- ----------------------------
DROP TABLE IF EXISTS `wja_form_field`;
CREATE TABLE `wja_form_field` (
  `field_id` int(10) NOT NULL AUTO_INCREMENT,
  `model_id` varchar(80) NOT NULL COMMENT '对应model表主键',
  `field` varchar(80) DEFAULT NULL COMMENT '对应数据字段',
  `title` varchar(80) DEFAULT NULL COMMENT '显示标题',
  `notemsg` varchar(255) DEFAULT NULL COMMENT '字段文字描述',
  `type` tinyint(1) unsigned DEFAULT '1' COMMENT '数据类型 1 文本 2 文本域 3 单选 4 复选 5 选择菜单 6 图片上传 7 编辑器',
  `type_extend` varchar(80) DEFAULT NULL COMMENT '相同数据类似的扩展类型,如数字/货币/邮箱/URL/日期/内容去重 等格式验证，(去重考虑基本去重和严格去重，基本去重指比方说厂商下的信息 基本去重，严格去重指平台内相对数据严格去重)',
  `datatype` varchar(100) DEFAULT NULL COMMENT '字段验证规则',
  `nullmsg` varchar(255) DEFAULT NULL COMMENT '非空字段显示的空内容提醒',
  `errormsg` varchar(255) DEFAULT NULL COMMENT '验证错误提醒',
  `size` tinyint(1) unsigned DEFAULT NULL COMMENT '字段长度（text/textarea类型有效）',
  `default` varchar(255) DEFAULT NULL COMMENT '默认值配置（json格式）',
  `value` varchar(255) DEFAULT NULL COMMENT '字段可用参数配置（json格式）',
  `variable` varchar(255) DEFAULT NULL COMMENT '来自control赋值的变量名称',
  `sort_order` tinyint(1) unsigned DEFAULT '255',
  `status` tinyint(1) unsigned DEFAULT '1',
  `is_del` tinyint(1) unsigned DEFAULT '0',
  `add_time` int(13) unsigned DEFAULT NULL,
  `update_time` int(13) unsigned DEFAULT NULL,
  PRIMARY KEY (`field_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_form_field
-- ----------------------------
INSERT INTO `wja_form_field` VALUES ('1', '1', 'parent_id', '上级节点', '顶级节点请留空,其它上级节点请慎重选择', '5', 'select', '', '', '', '0', '==顶级节点==', '', 'rulelist', '255', '1', '0', '1543287116', '1543287116');
INSERT INTO `wja_form_field` VALUES ('2', '1', 'title', '权限名称', '请填写权限节点名称', '1', 'text', '*', '权限节点名称不能为空', '权限节点名称填写错误', '20', '', '', '', '255', '1', '0', '1543287314', '1543287314');
INSERT INTO `wja_form_field` VALUES ('3', '1', 'module', '权限模块', '请填写权限节点操作module,留空默认admin', '1', 'text', '', '', '', '20', '', '', '', '255', '1', '0', '1543287496', '1543287496');
INSERT INTO `wja_form_field` VALUES ('4', '1', 'controller', '权限控制器', '请填写权限节点操作控制器', '1', 'text', '', '', '', '20', '', '', '', '255', '1', '0', '1543287550', '1543287550');
INSERT INTO `wja_form_field` VALUES ('5', '1', 'action', '权限操作', '请填写权限节点操作行为', '1', 'text', '', '', '', '20', '', '', '', '255', '1', '0', '1543287598', '1543287598');
INSERT INTO `wja_form_field` VALUES ('6', '1', 'icon', '菜单图标', '请填写图标名称class 示例：icon-home，请填写home', '1', 'text', '', '', '', '20', '', '', '', '255', '1', '0', '1543287666', '1543287666');
INSERT INTO `wja_form_field` VALUES ('7', '1', 'status', '节点状态', '', '3', '', '', '', '', '0', '1', '可用|1\r\n禁用|0', '', '255', '1', '0', '1543287841', '1543287841');
INSERT INTO `wja_form_field` VALUES ('8', '1', 'authopen', '权限状态', '', '3', '', '', '', '', '0', '1', '开启|1\r\n关闭|0', '', '255', '1', '0', '1543287919', '1543287919');
INSERT INTO `wja_form_field` VALUES ('9', '1', 'menustatus', '显示状态', '', '3', '', '', '', '', '0', '1', '开启|1\r\n关闭|0', '', '255', '1', '0', '1543287968', '1543287968');
INSERT INTO `wja_form_field` VALUES ('10', '1', 'sort_order', '排序', '', '1', 'text', '', '', '', '20', '255', '', '', '255', '1', '0', '1543288003', '1543288003');
INSERT INTO `wja_form_field` VALUES ('12', '3', 'name', '角色名称', '角色名称请不要填写特殊字符', '1', 'text', '*', '角色名称不能为空', '角色名称填写错误', '40', '', '', '', '10', '1', '0', '1544097814', '1544097814');
INSERT INTO `wja_form_field` VALUES ('13', '3', 'group_type', '角色分组', '平台角色请选择平台角色,其它角色请选择厂商角色', '3', 'select', '*', '', '', '0', '1', '平台角色|1\r\n厂商角色|2', '', '20', '1', '0', '1544097959', '1544097991');
INSERT INTO `wja_form_field` VALUES ('14', '3', 'status', '角色状态', '禁用后角色将不可用', '3', '', '', '', '', '0', '1', '可用|1\r\n禁用|0', '', '30', '1', '0', '1544098196', '1544098196');
INSERT INTO `wja_form_field` VALUES ('15', '3', 'sort_order', '排序', '', '1', 'text', '', '', '', '20', '255', '', '', '40', '1', '0', '1544098239', '1544098239');

-- ----------------------------
-- Table structure for wja_form_model
-- ----------------------------
DROP TABLE IF EXISTS `wja_form_model`;
CREATE TABLE `wja_form_model` (
  `model_id` int(10) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `name` varchar(80) DEFAULT NULL COMMENT '数据表名称',
  `description` varchar(255) DEFAULT NULL COMMENT '数据表描述',
  `status` tinyint(1) unsigned DEFAULT '1',
  `is_del` tinyint(1) unsigned DEFAULT '0',
  `sort_order` tinyint(1) unsigned DEFAULT NULL,
  `add_time` int(13) unsigned DEFAULT NULL,
  `update_time` int(13) unsigned DEFAULT NULL,
  PRIMARY KEY (`model_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_form_model
-- ----------------------------
INSERT INTO `wja_form_model` VALUES ('1', '权限管理', 'auth_rule', '', '1', '0', null, '1543225261', '1543225261');
INSERT INTO `wja_form_model` VALUES ('2', '厂商管理', 'store_factory', '', '1', '0', null, '1544069639', '1544069639');
INSERT INTO `wja_form_model` VALUES ('3', '角色管理', 'user_group', '', '1', '0', null, '1544096207', '1544096207');
INSERT INTO `wja_form_model` VALUES ('4', '用户管理', 'user', '', '1', '0', null, '1544098575', '1544098575');
INSERT INTO `wja_form_model` VALUES ('5', '商品管理', 'goods', '', '1', '0', null, '1544099050', '1544099050');
INSERT INTO `wja_form_model` VALUES ('6', '商品分类', 'goods_cate', '', '1', '0', null, '1544146973', '1544146973');
INSERT INTO `wja_form_model` VALUES ('7', '商品规格', 'goods_spec', '', '1', '0', null, '1544147492', '1544147492');
INSERT INTO `wja_form_model` VALUES ('8', '渠道管理', 'store_channel', '', '1', '0', null, '1544147751', '1544147751');
INSERT INTO `wja_form_model` VALUES ('9', '零售商管理', 'store_dealer', '', '1', '0', null, '1544148310', '1544148310');
INSERT INTO `wja_form_model` VALUES ('10', '服务商管理', 'store_servicer', '', '1', '0', null, '1544148899', '1544148899');
INSERT INTO `wja_form_model` VALUES ('11', '安装员管理', 'user_installer', '', '1', '0', null, '1544149645', '1544149645');
INSERT INTO `wja_form_model` VALUES ('12', '返佣明细表', 'store_commission', '', '1', '0', null, '1544100306', '1544100306');
INSERT INTO `wja_form_model` VALUES ('13', '售后订单', 'order_sku_service', '', '1', '0', null, '1544424419', '1544424428');
INSERT INTO `wja_form_model` VALUES ('14', '服务商收益表', 'store_service_income', '', '1', '0', null, '1544511261', '1544511261');
INSERT INTO `wja_form_model` VALUES ('15', '公告管理', 'bulletin', '', '1', '0', null, '1544522778', '1544522787');

-- ----------------------------
-- Table structure for wja_form_table
-- ----------------------------
DROP TABLE IF EXISTS `wja_form_table`;
CREATE TABLE `wja_form_table` (
  `table_id` int(10) NOT NULL AUTO_INCREMENT,
  `model_id` varchar(80) NOT NULL COMMENT '对应model表主键',
  `field` varchar(80) DEFAULT NULL COMMENT '对应数据字段',
  `title` varchar(80) DEFAULT NULL COMMENT '显示标题',
  `width` varchar(10) DEFAULT NULL COMMENT '显示宽度',
  `type` tinyint(1) unsigned DEFAULT '1' COMMENT '数据类型 1 文本 2 图标 3 单选 4 状态值 5 操作列表',
  `value` varchar(255) DEFAULT NULL COMMENT '字段可用参数配置',
  `function` varchar(255) DEFAULT NULL COMMENT '字符需函数处理的函数名称',
  `sort_order` tinyint(1) unsigned DEFAULT '255',
  `status` tinyint(1) unsigned DEFAULT '1',
  `is_edit` tinyint(1) unsigned DEFAULT '0' COMMENT '是否支持点击编辑',
  `is_sort` tinyint(1) unsigned DEFAULT '0' COMMENT '是否支持键值排序',
  `is_del` tinyint(1) unsigned DEFAULT '0',
  `add_time` int(13) unsigned DEFAULT NULL,
  `update_time` int(13) unsigned DEFAULT NULL,
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_form_table
-- ----------------------------
INSERT INTO `wja_form_table` VALUES ('1', '1', '', '编号', '60', '3', '', '', '10', '1', '0', '0', '0', '1544012686', '1544013483');
INSERT INTO `wja_form_table` VALUES ('2', '1', 'icon', '图标', '50', '4', 'icon', '', '20', '1', '0', '0', '0', '1544012981', '1544013469');
INSERT INTO `wja_form_table` VALUES ('3', '1', 'cname', '节点名称', '*', '1', null, '', '30', '1', '0', '0', '0', '1544061627', '1544061627');
INSERT INTO `wja_form_table` VALUES ('4', '1', 'module', '权限归属', '100', '1', null, '', '40', '1', '0', '0', '0', '1544061680', '1544061680');
INSERT INTO `wja_form_table` VALUES ('5', '1', 'href', '操作地址', '*', '1', null, '', '50', '1', '0', '0', '0', '1544061750', '1544061750');
INSERT INTO `wja_form_table` VALUES ('6', '1', 'authopen', '是否验证权限', '120', '2', null, 'openorclose', '60', '1', '0', '0', '0', '1544061814', '1544061814');
INSERT INTO `wja_form_table` VALUES ('7', '1', 'menustatus', '是否显示菜单', '120', '2', null, 'openorclose', '70', '1', '0', '0', '0', '1544061917', '1544061917');
INSERT INTO `wja_form_table` VALUES ('8', '2', '', '编号', '60', '3', null, '', '10', '1', '0', '0', '0', '1544069675', '1544069675');
INSERT INTO `wja_form_table` VALUES ('9', '2', 'name', '厂商名称', '*', '1', null, '', '20', '1', '0', '0', '0', '1544069902', '1544069902');
INSERT INTO `wja_form_table` VALUES ('10', '2', 'user_name', '联系人姓名', '100', '1', null, '', '30', '1', '0', '0', '0', '1544070008', '1544070041');
INSERT INTO `wja_form_table` VALUES ('11', '2', 'mobile', '联系电话', '160', '1', null, '', '40', '1', '0', '0', '0', '1544070033', '1544070033');
INSERT INTO `wja_form_table` VALUES ('12', '2', 'username', '管理员账号', '120', '1', null, '', '50', '1', '0', '0', '0', '1544070079', '1544070079');
INSERT INTO `wja_form_table` VALUES ('13', '3', '', '编号', '60', '3', null, '', '10', '1', '0', '0', '0', '1544096236', '1544096236');
INSERT INTO `wja_form_table` VALUES ('14', '3', 'group_type', '角色分组', '150', '2', null, 'groupname', '20', '1', '0', '0', '0', '1544096342', '1544096342');
INSERT INTO `wja_form_table` VALUES ('15', '3', 'name', '角色名称', '*', '1', null, '', '30', '1', '0', '0', '0', '1544096365', '1544096365');
INSERT INTO `wja_form_table` VALUES ('16', '4', '', '编号', '60', '3', null, '', '10', '1', '0', '0', '0', '1544098612', '1544098612');
INSERT INTO `wja_form_table` VALUES ('17', '4', 'sname', '所属商户', '100', '1', null, '', '20', '1', '0', '0', '0', '1544098638', '1544098638');
INSERT INTO `wja_form_table` VALUES ('18', '4', 'gname', '角色名称', '*', '1', null, '', '30', '1', '0', '0', '0', '1544098666', '1544098666');
INSERT INTO `wja_form_table` VALUES ('19', '4', 'username', '登录用户名', '*', '1', null, '', '40', '1', '0', '0', '0', '1544098711', '1544098711');
INSERT INTO `wja_form_table` VALUES ('20', '4', 'phone', '联系电话', '120', '1', null, '', '50', '1', '0', '0', '0', '1544098739', '1544098739');
INSERT INTO `wja_form_table` VALUES ('21', '5', '', '编号', '60', '3', null, '', '10', '1', '0', '0', '0', '1544099072', '1544099072');
INSERT INTO `wja_form_table` VALUES ('22', '5', 'goods_cate', '产品类别', '*', '2', null, 'get_goods_cate', '30', '1', '0', '0', '0', '1544099112', '1544406652');
INSERT INTO `wja_form_table` VALUES ('23', '5', 'cate_name', '产品分类', '100', '1', null, '', '30', '1', '0', '0', '0', '1544099141', '1544099141');
INSERT INTO `wja_form_table` VALUES ('24', '5', 'name', '产品名称', '*', '1', null, '', '20', '1', '0', '0', '0', '1544099174', '1544406856');
INSERT INTO `wja_form_table` VALUES ('25', '5', 'goods_type', '产品类型', '100', '2', null, 'goodstype', '50', '1', '0', '0', '0', '1544099237', '1544099237');
INSERT INTO `wja_form_table` VALUES ('26', '5', 'thumb', '产品图片', '100', '5', null, '', '60', '1', '0', '0', '0', '1544099277', '1544099277');
INSERT INTO `wja_form_table` VALUES ('27', '5', 'goods_sn', '产品货号', '100', '1', null, '', '70', '1', '0', '0', '0', '1544099311', '1544099311');
INSERT INTO `wja_form_table` VALUES ('28', '5', 'min_price', '产品价格', '100', '1', null, '', '80', '1', '0', '0', '0', '1544099348', '1544099348');
INSERT INTO `wja_form_table` VALUES ('29', '5', 'goods_stock', '产品库存', '100', '1', null, '', '90', '1', '0', '0', '0', '1544099396', '1544099396');
INSERT INTO `wja_form_table` VALUES ('30', '6', '', '编号', '60', '3', null, '', '10', '1', '0', '0', '0', '1544147221', '1544147221');
INSERT INTO `wja_form_table` VALUES ('31', '6', 'sname', '厂商名称', '*', '1', null, '', '20', '1', '0', '0', '0', '1544147262', '1544147262');
INSERT INTO `wja_form_table` VALUES ('32', '6', 'name', '分类名称', '*', '1', null, '', '30', '1', '0', '0', '0', '1544147341', '1544147341');
INSERT INTO `wja_form_table` VALUES ('33', '7', '', '编号', '60', '3', null, '', '10', '1', '0', '0', '0', '1544147514', '1544147514');
INSERT INTO `wja_form_table` VALUES ('34', '7', 'sname', '厂商名称', '*', '1', null, '', '20', '1', '0', '0', '0', '1544147539', '1544147539');
INSERT INTO `wja_form_table` VALUES ('35', '7', 'name', '规格名称', '100', '1', null, '', '30', '1', '0', '0', '0', '1544147583', '1544147660');
INSERT INTO `wja_form_table` VALUES ('36', '7', 'value', '规格属性', '*', '1', null, '', '40', '1', '0', '0', '0', '1544147605', '1544147605');
INSERT INTO `wja_form_table` VALUES ('37', '6', 'add_time', '新增时间', '*', '2', null, 'time_to_date', '70', '1', '0', '0', '0', '1544147775', '1544407610');
INSERT INTO `wja_form_table` VALUES ('38', '8', 'region_name', '负责区域', '*', '1', null, '', '50', '1', '0', '0', '0', '1544147856', '1544148085');
INSERT INTO `wja_form_table` VALUES ('39', '8', 'security_money', '保证金金额', '100', '1', null, '', '60', '1', '0', '0', '0', '1544147888', '1544148090');
INSERT INTO `wja_form_table` VALUES ('40', '2', 'domain', '二级域名', '100', '1', null, '', '15', '1', '0', '0', '0', '1544147968', '1544147968');
INSERT INTO `wja_form_table` VALUES ('41', '8', 'name', '渠道名称', '*', '1', null, '', '20', '1', '0', '0', '0', '1544148133', '1544148133');
INSERT INTO `wja_form_table` VALUES ('42', '8', 'user_name', '联系人姓名', '100', '1', null, '', '30', '1', '0', '0', '0', '1544148175', '1544257165');
INSERT INTO `wja_form_table` VALUES ('43', '8', 'mobile', '联系电话', '150', '1', null, '', '40', '1', '0', '0', '0', '1544148200', '1544521721');
INSERT INTO `wja_form_table` VALUES ('44', '8', 'username', '管理员账号', '100', '1', null, '', '90', '1', '0', '0', '0', '1544148223', '1544148223');
INSERT INTO `wja_form_table` VALUES ('45', '9', '', '编号', '60', '3', null, '', '10', '1', '0', '0', '0', '1544148337', '1544148337');
INSERT INTO `wja_form_table` VALUES ('46', '9', 'name', '零售商名称', '*', '1', null, '', '20', '1', '0', '0', '0', '1544148370', '1544148370');
INSERT INTO `wja_form_table` VALUES ('47', '9', 'cname', '所属渠道', '*', '1', null, '', '30', '1', '0', '0', '0', '1544148442', '1544148442');
INSERT INTO `wja_form_table` VALUES ('48', '8', 'sname', '所属厂商', '*', '1', null, '', '15', '1', '0', '0', '0', '1544148510', '1544148510');
INSERT INTO `wja_form_table` VALUES ('49', '9', 'sname', '所属厂商', '*', '1', null, '', '25', '1', '0', '0', '0', '1544148663', '1544148663');
INSERT INTO `wja_form_table` VALUES ('50', '9', 'user_name', '联系人姓名', '100', '1', null, '', '50', '1', '0', '0', '0', '1544148759', '1544148759');
INSERT INTO `wja_form_table` VALUES ('51', '9', 'mobile', '联系电话', '150', '1', null, '', '60', '1', '0', '0', '0', '1544148785', '1544521888');
INSERT INTO `wja_form_table` VALUES ('52', '9', 'username', '管理员账号', '100', '1', null, '', '70', '1', '0', '0', '0', '1544148823', '1544148823');
INSERT INTO `wja_form_table` VALUES ('53', '10', '', '编号', '60', '3', null, '', '10', '1', '0', '0', '0', '1544148997', '1544148997');
INSERT INTO `wja_form_table` VALUES ('54', '10', 'name', '服务商名称', '*', '1', null, '', '20', '1', '0', '0', '0', '1544149017', '1544149017');
INSERT INTO `wja_form_table` VALUES ('55', '10', 'sname', '所属厂商', '*', '1', null, '', '30', '1', '0', '0', '0', '1544149033', '1544149033');
INSERT INTO `wja_form_table` VALUES ('56', '10', 'user_name', '联系人姓名', '100', '1', null, '', '40', '1', '0', '0', '0', '1544149061', '1544149061');
INSERT INTO `wja_form_table` VALUES ('57', '10', 'mobile', '联系电话', '150', '1', null, '', '50', '1', '0', '0', '0', '1544149082', '1544521777');
INSERT INTO `wja_form_table` VALUES ('58', '10', 'username', '管理员账号', '100', '1', null, '', '80', '1', '0', '0', '0', '1544149108', '1544257073');
INSERT INTO `wja_form_table` VALUES ('59', '11', '', '编号', '60', '3', null, '', '10', '1', '0', '0', '0', '1544149679', '1544149679');
INSERT INTO `wja_form_table` VALUES ('60', '11', 'fname', '所属厂商', '*', '1', null, '', '20', '1', '0', '0', '0', '1544149723', '1544149723');
INSERT INTO `wja_form_table` VALUES ('61', '11', 'sname', '所属服务商', '*', '1', null, '', '30', '1', '0', '0', '0', '1544149748', '1544149748');
INSERT INTO `wja_form_table` VALUES ('62', '11', 'service_count', '服务次数', '*', '1', null, '', '60', '1', '0', '0', '0', '1544150166', '1544259506');
INSERT INTO `wja_form_table` VALUES ('63', '11', 'realname', '真实姓名', '100', '1', null, '', '40', '1', '0', '0', '0', '1544150207', '1544260727');
INSERT INTO `wja_form_table` VALUES ('64', '11', 'phone', '联系电话', '150', '1', null, '', '50', '1', '0', '0', '0', '1544150234', '1544260732');
INSERT INTO `wja_form_table` VALUES ('65', '11', 'udata_id', '绑定小程序', '100', '2', null, 'yorn', '80', '1', '0', '0', '0', '1544150592', '1544150600');
INSERT INTO `wja_form_table` VALUES ('66', '12', '', '编号', '60', '3', null, '', '10', '1', '0', '0', '0', '1544100500', '1544100500');
INSERT INTO `wja_form_table` VALUES ('67', '12', 'order_sn', '订单编号', '*', '1', null, '', '20', '1', '0', '0', '0', '1544100538', '1544100538');
INSERT INTO `wja_form_table` VALUES ('68', '12', 'gname', '商品名称', '*', '1', null, '', '20', '1', '0', '0', '0', '1544100572', '1544100572');
INSERT INTO `wja_form_table` VALUES ('69', '12', 'sname', '零售商名称', '*', '1', null, '', '30', '1', '0', '0', '0', '1544100592', '1544101029');
INSERT INTO `wja_form_table` VALUES ('70', '12', 'order_amount', '订单金额', '80', '1', null, '', '40', '1', '0', '0', '0', '1544100610', '1544100610');
INSERT INTO `wja_form_table` VALUES ('71', '12', 'commission_ratio', '佣金百分比', '100', '1', null, '', '50', '1', '0', '0', '0', '1544100633', '1544100633');
INSERT INTO `wja_form_table` VALUES ('72', '12', 'income_amount', '佣金金额', '80', '1', null, '', '60', '1', '0', '0', '0', '1544100654', '1544100654');
INSERT INTO `wja_form_table` VALUES ('73', '12', 'add_time', '交易时间', '120', '2', null, 'time_to_date', '70', '1', '0', '0', '0', '1544100679', '1544151665');
INSERT INTO `wja_form_table` VALUES ('74', '12', 'commission_status', '佣金状态', '*', '2', null, 'get_commission_status', '60', '1', '0', '0', '0', '1544151698', '1544151720');
INSERT INTO `wja_form_table` VALUES ('75', '10', 'region_name', '服务区域', '*', '1', null, '', '60', '1', '0', '0', '0', '1544257088', '1544257098');
INSERT INTO `wja_form_table` VALUES ('76', '10', 'security_money', '保证金金额', '*', '1', null, '', '70', '1', '0', '0', '0', '1544257131', '1544257131');
INSERT INTO `wja_form_table` VALUES ('77', '11', 'check_status', '工程师状态', '*', '2', null, 'get_installer_status', '70', '1', '0', '0', '0', '1544260762', '1544260852');
INSERT INTO `wja_form_table` VALUES ('78', '13', 'order_sn', '订单号', '120', '1', null, '', '10', '1', '0', '0', '0', '1544424456', '1544424456');
INSERT INTO `wja_form_table` VALUES ('79', '13', 'sku_name', '商品名称', '*', '1', null, '', '30', '1', '0', '0', '0', '1544424490', '1544424682');
INSERT INTO `wja_form_table` VALUES ('80', '13', 'num', '商品数量', '80', '1', null, '', '40', '1', '0', '0', '0', '1544424598', '1544424688');
INSERT INTO `wja_form_table` VALUES ('81', '13', 'refund_amount', '退款金额', '80', '1', null, '', '50', '1', '0', '0', '0', '1544424617', '1544424719');
INSERT INTO `wja_form_table` VALUES ('82', '13', 'service_type', '售后类型', '120', '2', null, 'get_service_type', '20', '1', '0', '0', '0', '1544424651', '1544433133');
INSERT INTO `wja_form_table` VALUES ('83', '13', 'sname', '商户名称', '*', '1', null, '', '60', '1', '0', '0', '0', '1544425893', '1544425893');
INSERT INTO `wja_form_table` VALUES ('84', '13', 'mobile', '联系电话', '140', '1', null, '', '90', '1', '0', '0', '0', '1544425914', '1544425914');
INSERT INTO `wja_form_table` VALUES ('85', '13', 'username', '操作用户', '130', '1', null, '', '70', '1', '0', '0', '0', '1544425939', '1544427506');
INSERT INTO `wja_form_table` VALUES ('86', '13', 'service_status', '售后状态', '140', '2', null, 'get_service_status', '100', '1', '0', '0', '0', '1544426496', '1544426810');
INSERT INTO `wja_form_table` VALUES ('87', '14', 'worder_sn', '工单编号', '*', '1', null, '', '10', '1', '0', '0', '0', '1544511284', '1544511284');
INSERT INTO `wja_form_table` VALUES ('88', '14', 'realname', '安装工程师', '*', '1', null, '', '20', '1', '0', '0', '0', '1544511306', '1544511306');
INSERT INTO `wja_form_table` VALUES ('89', '14', 'gname', '安装产品名称', '*', '1', null, '', '30', '1', '0', '0', '0', '1544511331', '1544511331');
INSERT INTO `wja_form_table` VALUES ('90', '14', 'install_amount', '预安装费', '100', '1', null, '', '40', '1', '0', '0', '0', '1544511366', '1544511366');
INSERT INTO `wja_form_table` VALUES ('91', '14', 'income_amount', '实得安装费', '120', '1', null, '', '50', '1', '0', '0', '0', '1544511408', '1544511408');
INSERT INTO `wja_form_table` VALUES ('92', '14', 'income_status', '收益状态', '120', '2', null, 'get_commission_status', '60', '1', '0', '0', '0', '1544511449', '1544511449');
INSERT INTO `wja_form_table` VALUES ('93', '14', 'add_time', '工单完成时间', '130', '2', null, 'time_to_date', '70', '1', '0', '0', '0', '1544511474', '1544511474');
INSERT INTO `wja_form_table` VALUES ('94', '15', 'name', '公告标题', '*', '1', null, '', '10', '1', '0', '0', '0', '1544522813', '1544522813');
INSERT INTO `wja_form_table` VALUES ('95', '15', 'publish_time', '发布时间', '140', '2', null, 'time_to_date', '60', '1', '0', '0', '0', '1544522856', '1544524926');
INSERT INTO `wja_form_table` VALUES ('96', '15', 'store_type', '可见用户', '*', '2', null, 'get_store_type', '30', '1', '0', '0', '0', '1544522896', '1544522896');
INSERT INTO `wja_form_table` VALUES ('97', '15', 'is_top', '是否置顶', '100', '2', null, 'get_status', '40', '1', '0', '0', '0', '1544523287', '1544524998');
INSERT INTO `wja_form_table` VALUES ('98', '15', 'publish_status', '发布状态', '100', '2', null, 'get_publish_status', '50', '1', '0', '0', '0', '1544523514', '1544523520');
INSERT INTO `wja_form_table` VALUES ('99', '15', '', '编号', '60', '3', null, '', '1', '1', '0', '0', '0', '1544523549', '1544523549');
INSERT INTO `wja_form_table` VALUES ('100', '15', 'description', '公告描述', '*', '1', null, '', '20', '1', '0', '0', '0', '1544524911', '1544524918');

-- ----------------------------
-- Table structure for wja_goods
-- ----------------------------
DROP TABLE IF EXISTS `wja_goods`;
CREATE TABLE `wja_goods` (
  `goods_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '门店ID',
  `cate_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '产品分类ID',
  `goods_cate` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '产品类别(1标准产品 2零配件)',
  `goods_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '产品类型(1为标准产品 2为样品)',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '产品名称',
  `goods_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '产品货号',
  `thumb` varchar(255) NOT NULL DEFAULT '' COMMENT '产品缩略图',
  `imgs` varchar(1500) NOT NULL DEFAULT '' COMMENT '产品图片列表',
  `min_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '最小价格',
  `max_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '最大价格',
  `install_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '产品安装费',
  `goods_stock` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '产品库存',
  `description` varchar(500) NOT NULL DEFAULT '' COMMENT '产品描述',
  `content` text NOT NULL COMMENT '产品详情',
  `sales` int(5) unsigned NOT NULL DEFAULT '0' COMMENT '产品售出数量',
  `sort_order` tinyint(1) unsigned NOT NULL DEFAULT '255' COMMENT '排序',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(1为正常0为下架)',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `specs_json` text,
  `stock_reduce_time` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '库存减少时间:1买家拍下减少库存 2买家付款成功减少库存',
  `sample_purchase_limit` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '样品限购数量(单个用户）',
  PRIMARY KEY (`goods_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='产品表';

-- ----------------------------
-- Records of wja_goods
-- ----------------------------
INSERT INTO `wja_goods` VALUES ('1', '1', '2', '1', '2', '无规格样品测试', '11111111', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181206174545_basicprofile.jpg', '[\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181206174545_basicprofile.jpg\"]', '19.90', '19.90', '0.00', '9', '', '		                  			                  			                  			                  			                  			                  		                  		                  		                  		                  ', '2', '1', '1', '0', '1544089567', '1544091375', null, '1', '5');
INSERT INTO `wja_goods` VALUES ('2', '1', '2', '1', '2', '有规格样品测试', '22222222', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181206174545_basicprofile.jpg', '[\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181206174545_basicprofile.jpg\"]', '9.90', '15.00', '0.00', '20', '', '		                  			                  			                  			                  		                  		                  ', '0', '1', '1', '0', '1544089826', '1544090046', '[{\"specid\":\"1\",\"specname\":\"容量\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"颜色\",\"list\":[\"黑色\",\"灰色\"]}]', '1', '1');
INSERT INTO `wja_goods` VALUES ('3', '1', '2', '1', '1', '无规格普通商品', '33333333', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181206174545_basicprofile.jpg', '[\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181206174545_basicprofile.jpg\"]', '12.20', '12.20', '120.00', '10', '', '		                  			                  			                  			                  		                  		                  ', '0', '1', '1', '0', '1544089910', '1544091532', null, '1', '0');
INSERT INTO `wja_goods` VALUES ('4', '1', '2', '1', '1', '有规格普通商品测试', '44444444', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181206174545_basicprofile.jpg', '[\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181206174545_basicprofile.jpg\"]', '10.00', '12.50', '100.00', '40', '', '		                  			                  ', '3', '1', '1', '0', '1544089950', '1544491485', '[{\"specid\":\"1\",\"specname\":\"容量\",\"list\":[\"32G\",\"64G\"]},{\"specid\":\"2\",\"specname\":\"颜色\",\"list\":[\"黑色\",\"灰色\"]}]', '2', '0');

-- ----------------------------
-- Table structure for wja_goods_cate
-- ----------------------------
DROP TABLE IF EXISTS `wja_goods_cate`;
CREATE TABLE `wja_goods_cate` (
  `cate_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '厂商ID',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '分类上级分类ID 0 表示顶级分类',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '分类名称',
  `sort_order` tinyint(1) unsigned NOT NULL DEFAULT '10' COMMENT '排序',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`cate_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='产品分类表';

-- ----------------------------
-- Records of wja_goods_cate
-- ----------------------------
INSERT INTO `wja_goods_cate` VALUES ('1', '2', '0', '摄像机', '1', '1', '1543289188', '1543303882', '0');
INSERT INTO `wja_goods_cate` VALUES ('2', '1', '0', '智能产品', '1', '1', '1543819999', '1543819999', '0');

-- ----------------------------
-- Table structure for wja_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `wja_goods_sku`;
CREATE TABLE `wja_goods_sku` (
  `sku_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '商品规格ID',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '门店ID',
  `goods_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_cate` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '产品类别(1标准产品 2零配件)',
  `goods_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '产品类型(1为标准产品 2为零配件产品)',
  `sku_name` varchar(255) NOT NULL DEFAULT '' COMMENT '规格名称',
  `sku_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '商品货号',
  `sku_thumb` varchar(255) NOT NULL DEFAULT '' COMMENT '规格图片',
  `sku_stock` int(5) unsigned NOT NULL DEFAULT '0' COMMENT '库存',
  `spec_value` varchar(500) NOT NULL DEFAULT '' COMMENT '商品对应规格值(多规格用;分隔)',
  `spec_json` text COMMENT '规格对应Json',
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '价格',
  `install_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '产品安装费',
  `sales` int(5) unsigned NOT NULL DEFAULT '0' COMMENT '商品售出数量',
  `sort_order` tinyint(1) unsigned NOT NULL DEFAULT '255' COMMENT '排序',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `stock_reduce_time` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '库存减少时间:1买家拍下减少库存 2买家付款成功减少库存',
  `sample_purchase_limit` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '样品限购数量(单个用户）',
  PRIMARY KEY (`sku_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_goods_sku
-- ----------------------------
INSERT INTO `wja_goods_sku` VALUES ('1', '1', '1', '1', '2', '', '11111111', '', '9', '', '', '19.90', '0.00', '1', '255', '1', '0', '0', '0', '1', '5');
INSERT INTO `wja_goods_sku` VALUES ('2', '1', '2', '1', '2', '', '2222222222', '', '10', '', '', '18.80', '0.00', '0', '255', '1', '1', '0', '1544089836', '1', '1');
INSERT INTO `wja_goods_sku` VALUES ('3', '1', '3', '1', '1', '', '33333333', '', '10', '', '', '12.20', '120.00', '0', '255', '1', '0', '0', '0', '1', '0');
INSERT INTO `wja_goods_sku` VALUES ('4', '1', '4', '1', '1', '', '44444444', '', '10', '', '', '16.78', '20.00', '0', '255', '1', '1', '0', '1544090025', '1', '0');
INSERT INTO `wja_goods_sku` VALUES ('5', '1', '4', '1', '1', '容量:32G 颜色:黑色 ', '44444444-1', '', '10', '32G;黑色', '{\"容量\":\"32G\",\"颜色\":\"黑色\"}', '12.50', '100.00', '0', '255', '1', '0', '0', '0', '2', '0');
INSERT INTO `wja_goods_sku` VALUES ('6', '1', '4', '1', '1', '容量:32G 颜色:灰色 ', '44444444-2', '', '10', '32G;灰色', '{\"容量\":\"32G\",\"颜色\":\"灰色\"}', '12.50', '100.00', '0', '255', '1', '0', '0', '0', '2', '0');
INSERT INTO `wja_goods_sku` VALUES ('7', '1', '4', '1', '1', '容量:64G 颜色:黑色 ', '44444444-3', '', '10', '64G;黑色', '{\"容量\":\"64G\",\"颜色\":\"黑色\"}', '12.50', '100.00', '0', '255', '1', '0', '0', '0', '2', '0');
INSERT INTO `wja_goods_sku` VALUES ('8', '1', '4', '1', '1', '容量:64G 颜色:灰色 ', '44444444-4', '', '10', '64G;灰色', '{\"容量\":\"64G\",\"颜色\":\"灰色\"}', '10.00', '100.00', '0', '255', '1', '0', '0', '0', '2', '0');
INSERT INTO `wja_goods_sku` VALUES ('9', '1', '2', '1', '2', '容量:32G 颜色:黑色 ', '22222222-1', '', '10', '32G;黑色', '{\"容量\":\"32G\",\"颜色\":\"黑色\"}', '9.90', '0.00', '0', '255', '1', '0', '0', '0', '1', '1');
INSERT INTO `wja_goods_sku` VALUES ('10', '1', '2', '1', '2', '容量:32G 颜色:灰色 ', '22222222-2', '', '10', '32G;灰色', '{\"容量\":\"32G\",\"颜色\":\"灰色\"}', '15.00', '0.00', '0', '255', '1', '0', '0', '0', '1', '1');

-- ----------------------------
-- Table structure for wja_goods_spec
-- ----------------------------
DROP TABLE IF EXISTS `wja_goods_spec`;
CREATE TABLE `wja_goods_spec` (
  `spec_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '商品规格ID',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '厂商ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '规格名称',
  `value` tinytext,
  `sort_order` tinyint(1) unsigned NOT NULL DEFAULT '10' COMMENT '排序',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`spec_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='产品规格表';

-- ----------------------------
-- Records of wja_goods_spec
-- ----------------------------
INSERT INTO `wja_goods_spec` VALUES ('1', '1', '容量', '32G,64G', '1', '1', '1543289267', '1543304199', '0');
INSERT INTO `wja_goods_spec` VALUES ('2', '1', '颜色', '黑色,灰色', '1', '1', '1543820094', '1543820094', '0');

-- ----------------------------
-- Table structure for wja_goods_tag
-- ----------------------------
DROP TABLE IF EXISTS `wja_goods_tag`;
CREATE TABLE `wja_goods_tag` (
  `tag_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '厂商ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '标签名称',
  `sort_order` tinyint(1) unsigned NOT NULL DEFAULT '10' COMMENT '排序',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`tag_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='产品标签表';

-- ----------------------------
-- Records of wja_goods_tag
-- ----------------------------

-- ----------------------------
-- Table structure for wja_log_code
-- ----------------------------
DROP TABLE IF EXISTS `wja_log_code`;
CREATE TABLE `wja_log_code` (
  `sms_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '验证码自增长id',
  `phone` varchar(11) NOT NULL DEFAULT '' COMMENT '手机号',
  `code` varchar(6) NOT NULL DEFAULT '' COMMENT '验证码',
  `type` varchar(10) NOT NULL DEFAULT '' COMMENT '验证码类型',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '验证码发送时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '验证码发送状态(1成功0失败)',
  `result` varchar(2000) NOT NULL DEFAULT '' COMMENT '验证码发送接口返回json数据',
  PRIMARY KEY (`sms_id`) USING BTREE,
  KEY `phone` (`phone`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='验证码日志表';

-- ----------------------------
-- Records of wja_log_code
-- ----------------------------

-- ----------------------------
-- Table structure for wja_log_notify
-- ----------------------------
DROP TABLE IF EXISTS `wja_log_notify`;
CREATE TABLE `wja_log_notify` (
  `inform_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '通知信息自增长ID',
  `type` varchar(25) NOT NULL DEFAULT '' COMMENT '通知类型(sms短信 wechat微信模板消息)',
  `to_user` varchar(50) NOT NULL DEFAULT '' COMMENT '收信用户信息(sms对应手机号)',
  `tpl_type` varchar(50) NOT NULL DEFAULT '' COMMENT '通知模板类型',
  `content` varchar(1500) NOT NULL DEFAULT '' COMMENT '通知发送内容',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '通知发送时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '通知发送状态(1成功0失败)',
  `result` varchar(2000) NOT NULL DEFAULT '' COMMENT '通知发送接口返回json数据',
  PRIMARY KEY (`inform_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='通知发送日志表';

-- ----------------------------
-- Records of wja_log_notify
-- ----------------------------

-- ----------------------------
-- Table structure for wja_order
-- ----------------------------
DROP TABLE IF EXISTS `wja_order`;
CREATE TABLE `wja_order` (
  `order_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '订单类型(1商户订单:支付成功后直接完成 2电商订单)',
  `order_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '订单号',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '厂商ID',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '下单用户ID',
  `user_store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '购买用户商户ID',
  `goods_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '商品总额',
  `delivery_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '物流费',
  `real_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '应付总额',
  `install_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '安装费',
  `paid_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  `pay_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '支付方式(1在线支付)',
  `pay_code` varchar(25) NOT NULL DEFAULT '' COMMENT '支付方式',
  `pay_sn` varchar(500) NOT NULL DEFAULT '' COMMENT '第三方支付交易号',
  `address_name` varchar(100) NOT NULL DEFAULT '' COMMENT '收货人姓名',
  `address_phone` varchar(25) NOT NULL DEFAULT '' COMMENT '收货人电话',
  `region_id` int(10) unsigned NOT NULL DEFAULT '0',
  `address_detail` varchar(100) NOT NULL DEFAULT '' COMMENT '收货详细地址',
  `order_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '订单状态(1：正常，2：全部取消，3：全部关闭，4：全部删除)',
  `pay_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否支付',
  `delivery_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '发货状态(0：待发货，1：部分发货，2：已发货)',
  `finish_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '完成状态(0：待完成，1：部分完成，2：已完成)',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '下单时间',
  `cancel_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '取消时间',
  `pay_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '支付时间',
  `finish_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '确认完成时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `extra` text NOT NULL COMMENT '其它参数(如小程序支付prepay_id)',
  `remark` varchar(1000) NOT NULL DEFAULT '' COMMENT '买家留言',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '订单显示状态',
  `worder_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '安装工单申请状态(0:未申请，1：部分申请，2：已申请)',
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE KEY `order_sn` (`order_sn`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_order
-- ----------------------------

-- ----------------------------
-- Table structure for wja_order_log
-- ----------------------------
DROP TABLE IF EXISTS `wja_order_log`;
CREATE TABLE `wja_order_log` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单ID',
  `order_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '订单号',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作用户ID',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '用户昵称',
  `service_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '售后ID',
  `action` varchar(50) NOT NULL DEFAULT '' COMMENT '操作类型(创建订单 支付订单 确认订单 配送订单 完成订单)',
  `msg` varchar(500) NOT NULL DEFAULT '' COMMENT '操作信息',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '日志记录时间',
  PRIMARY KEY (`log_id`) USING BTREE,
  KEY `order_id` (`order_id`) USING BTREE,
  KEY `order_sn` (`order_sn`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_order_log
-- ----------------------------

-- ----------------------------
-- Table structure for wja_order_sku
-- ----------------------------
DROP TABLE IF EXISTS `wja_order_sku`;
CREATE TABLE `wja_order_sku` (
  `osku_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单商品ID',
  `order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单ID',
  `order_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '订单号',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '厂商ID',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '购买用户ID',
  `user_store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '购买用户商户ID',
  `goods_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `sku_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品规格属性ID',
  `sku_name` varchar(255) NOT NULL DEFAULT '' COMMENT '商品名称',
  `sku_thumb` varchar(255) NOT NULL DEFAULT '' COMMENT '商品缩略图',
  `sku_spec` varchar(1500) NOT NULL DEFAULT '' COMMENT '商品规格',
  `sku_info` text COMMENT '商品快照',
  `num` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '商品数量',
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '商品单价(原价)',
  `install_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '安装费',
  `pay_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '商品单价(成交价)',
  `delivery_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '运费',
  `real_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `odelivery_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'order_sku_delivery表自增长ID',
  `delivery_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '发货状态(0：待发货，1：已发货，2：已收货)',
  `delivery_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '发货时间',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0',
  `stock_reduce_time` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '库存减少时间:1买家拍下减少库存 2买家付款成功减少库存',
  `return_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否退货退款状态(0可退还 -1已关闭 1已退还)',
  `service_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '售后ID',
  `service_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '售后状态(-1拒绝申请 0申请中 1等待买家退货 2等待买家退款 3退款成功 4已取消)',
  PRIMARY KEY (`osku_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_order_sku
-- ----------------------------

-- ----------------------------
-- Table structure for wja_order_sku_delivery
-- ----------------------------
DROP TABLE IF EXISTS `wja_order_sku_delivery`;
CREATE TABLE `wja_order_sku_delivery` (
  `odelivery_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '主订单ID',
  `order_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '主订单号',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `osku_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '订单商品ID(多个用","逗号分割)',
  `delivery_identif` varchar(255) NOT NULL DEFAULT '' COMMENT '物流公司唯一标识',
  `delivery_name` varchar(20) NOT NULL DEFAULT '' COMMENT '所属物流',
  `delivery_sn` varchar(50) NOT NULL COMMENT '运单号',
  `delivery_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '发货时间',
  `isreceive` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否确认收货',
  `receive_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '确认收货时间',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `delivery_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '物流状态',
  `delivery_msg` varchar(30) NOT NULL DEFAULT '' COMMENT '物流状态信息',
  PRIMARY KEY (`odelivery_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_order_sku_delivery
-- ----------------------------

-- ----------------------------
-- Table structure for wja_order_sku_service
-- ----------------------------
DROP TABLE IF EXISTS `wja_order_sku_service`;
CREATE TABLE `wja_order_sku_service` (
  `service_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `service_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '售后单号',
  `service_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '售后类型(1退款 2退货退款)',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '卖家商户ID',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '退款申请用户ID',
  `user_store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '申请商户ID',
  `order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单ID',
  `order_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '订单号',
  `osku_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单商品ID',
  `num` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '退货/退款商品数量',
  `refund_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '退款金额',
  `remark` varchar(500) NOT NULL DEFAULT '' COMMENT '申请说明',
  `imgs` varchar(2000) NOT NULL DEFAULT '' COMMENT '申请凭证(json格式)',
  `service_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '售后状态(-1拒绝申请 0申请中 1等待买家退货 2等待买家退款 3退款成功 4已取消)',
  `refund_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '退款时间',
  `transfer_no` varchar(255) NOT NULL DEFAULT '' COMMENT '退款转账流水号',
  `is_delivery` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否物流配送',
  `delivery_identif` varchar(25) NOT NULL DEFAULT '',
  `delivery_name` varchar(20) NOT NULL DEFAULT '' COMMENT '退货物流公司',
  `delivery_sn` varchar(50) NOT NULL DEFAULT '' COMMENT '退货物流单号',
  `delivery_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '退货时间',
  `admin_remark` varchar(500) NOT NULL DEFAULT '' COMMENT '后台审核操作备注',
  `sort_order` int(1) unsigned NOT NULL DEFAULT '1',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '发起售后时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '申请状态(0：禁用 1：正常)',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='商品售后表';

-- ----------------------------
-- Records of wja_order_sku_service
-- ----------------------------

-- ----------------------------
-- Table structure for wja_order_track
-- ----------------------------
DROP TABLE IF EXISTS `wja_order_track`;
CREATE TABLE `wja_order_track` (
  `track_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `odelivery_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'order_sku_delivery表自增长ID',
  `order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '主订单ID',
  `order_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '主订单号',
  `msg` varchar(500) NOT NULL DEFAULT '' COMMENT '信息',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`track_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_order_track
-- ----------------------------

-- ----------------------------
-- Table structure for wja_payment
-- ----------------------------
DROP TABLE IF EXISTS `wja_payment`;
CREATE TABLE `wja_payment` (
  `pay_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '门店ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '支付名称',
  `pay_code` varchar(20) NOT NULL DEFAULT '',
  `config_json` varchar(2000) NOT NULL,
  `description` varchar(500) NOT NULL DEFAULT '',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `sort_order` tinyint(1) unsigned NOT NULL DEFAULT '255' COMMENT '排序',
  `display_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '显示类型(1pc端 2微信小程序 3APP客户端)',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`pay_id`) USING BTREE,
  KEY `pay_code` (`pay_code`) USING BTREE,
  KEY `store_id` (`store_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='商户支付配置数据表';

-- ----------------------------
-- Records of wja_payment
-- ----------------------------
INSERT INTO `wja_payment` VALUES ('1', '1', '微信扫码支付', 'wechat_native', '{\"app_id\":\"wxa57c32c95d2999e5\",\"mch_id\":\"1502262791\",\"mch_key\":\"v9t47O7Cdw1mM6vLlIlSOnxEn1YByTXa\"}', '', '1', '0', '0', '1', '1', '0');
INSERT INTO `wja_payment` VALUES ('2', '1', '微信小程序支付', 'wechat_applet', '{\"app_id\":\"wx0451129aa1cd6fa9\",\"mch_id\":\"1502262791\",\"mch_key\":\"v9t47O7Cdw1mM6vLlIlSOnxEn1YByTXa\"}', '', '1', '0', '0', '1', '2', '0');

-- ----------------------------
-- Table structure for wja_region
-- ----------------------------
DROP TABLE IF EXISTS `wja_region`;
CREATE TABLE `wja_region` (
  `region_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `region_name` varchar(100) NOT NULL DEFAULT '',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0',
  `sort_order` tinyint(3) unsigned NOT NULL DEFAULT '255',
  `recommend` tinyint(1) DEFAULT '0' COMMENT '是否是热门推荐城市',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`region_id`) USING BTREE,
  KEY `parent_id` (`parent_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=3263 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_region
-- ----------------------------
INSERT INTO `wja_region` VALUES ('1', '中国', '0', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2', '北京市', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3', '北京市', '2', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('4', '东城区', '3', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('5', '西城区', '3', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('6', '朝阳区', '3', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('7', '丰台区', '3', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('8', '石景山区', '3', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('9', '海淀区', '3', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('10', '门头沟区', '3', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('11', '房山区', '3', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('12', '通州区', '3', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('13', '顺义区', '3', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('14', '昌平区', '3', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('15', '大兴区', '3', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('16', '怀柔区', '3', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('17', '平谷区', '3', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('18', '密云区', '3', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('19', '延庆区', '3', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('20', '天津市', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('21', '天津市', '20', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('22', '和平区', '21', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('23', '河东区', '21', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('24', '河西区', '21', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('25', '南开区', '21', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('26', '河北区', '21', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('27', '红桥区', '21', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('28', '东丽区', '21', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('29', '西青区', '21', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('30', '津南区', '21', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('31', '北辰区', '21', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('32', '武清区', '21', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('33', '宝坻区', '21', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('34', '滨海新区', '21', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('35', '宁河区', '21', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('36', '静海区', '21', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('37', '蓟州区', '21', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('38', '河北省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('39', '石家庄市', '38', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('40', '长安区', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('41', '桥西区', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('42', '新华区', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('43', '井陉矿区', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('44', '裕华区', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('45', '藁城区', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('46', '鹿泉区', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('47', '栾城区', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('48', '井陉县', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('49', '正定县', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('50', '行唐县', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('51', '灵寿县', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('52', '高邑县', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('53', '深泽县', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('54', '赞皇县', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('55', '无极县', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('56', '平山县', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('57', '元氏县', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('58', '赵县', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('59', '晋州市', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('60', '新乐市', '39', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('61', '唐山市', '38', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('62', '路南区', '61', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('63', '路北区', '61', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('64', '古冶区', '61', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('65', '开平区', '61', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('66', '丰南区', '61', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('67', '丰润区', '61', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('68', '曹妃甸区', '61', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('69', '滦县', '61', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('70', '滦南县', '61', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('71', '乐亭县', '61', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('72', '迁西县', '61', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('73', '玉田县', '61', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('74', '遵化市', '61', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('75', '迁安市', '61', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('76', '秦皇岛市', '38', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('77', '海港区', '76', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('78', '山海关区', '76', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('79', '北戴河区', '76', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('80', '抚宁区', '76', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('81', '青龙满族自治县', '76', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('82', '昌黎县', '76', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('83', '卢龙县', '76', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('84', '邯郸市', '38', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('85', '邯山区', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('86', '丛台区', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('87', '复兴区', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('88', '峰峰矿区', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('89', '邯郸县', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('90', '临漳县', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('91', '成安县', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('92', '大名县', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('93', '涉县', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('94', '磁县', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('95', '肥乡县', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('96', '永年县', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('97', '邱县', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('98', '鸡泽县', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('99', '广平县', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('100', '馆陶县', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('101', '魏县', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('102', '曲周县', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('103', '武安市', '84', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('104', '邢台市', '38', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('105', '桥东区', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('106', '桥西区', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('107', '邢台县', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('108', '临城县', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('109', '内丘县', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('110', '柏乡县', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('111', '隆尧县', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('112', '任县', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('113', '南和县', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('114', '宁晋县', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('115', '巨鹿县', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('116', '新河县', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('117', '广宗县', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('118', '平乡县', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('119', '威县', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('120', '清河县', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('121', '临西县', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('122', '南宫市', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('123', '沙河市', '104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('124', '保定市', '38', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('125', '竞秀区', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('126', '莲池区', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('127', '满城区', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('128', '清苑区', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('129', '徐水区', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('130', '涞水县', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('131', '阜平县', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('132', '定兴县', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('133', '唐县', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('134', '高阳县', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('135', '容城县', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('136', '涞源县', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('137', '望都县', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('138', '安新县', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('139', '易县', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('140', '曲阳县', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('141', '蠡县', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('142', '顺平县', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('143', '博野县', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('144', '雄县', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('145', '涿州市', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('146', '安国市', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('147', '高碑店市', '124', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('148', '张家口市', '38', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('149', '桥东区', '148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('150', '桥西区', '148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('151', '宣化区', '148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('152', '下花园区', '148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('153', '万全区', '148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('154', '崇礼区', '148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('155', '张北县', '148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('156', '康保县', '148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('157', '沽源县', '148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('158', '尚义县', '148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('159', '蔚县', '148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('160', '阳原县', '148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('161', '怀安县', '148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('162', '怀来县', '148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('163', '涿鹿县', '148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('164', '赤城县', '148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('165', '承德市', '38', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('166', '双桥区', '165', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('167', '双滦区', '165', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('168', '鹰手营子矿区', '165', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('169', '承德县', '165', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('170', '兴隆县', '165', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('171', '平泉县', '165', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('172', '滦平县', '165', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('173', '隆化县', '165', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('174', '丰宁满族自治县', '165', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('175', '宽城满族自治县', '165', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('176', '围场满族蒙古族自治县', '165', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('177', '沧州市', '38', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('178', '新华区', '177', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('179', '运河区', '177', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('180', '沧县', '177', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('181', '青县', '177', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('182', '东光县', '177', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('183', '海兴县', '177', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('184', '盐山县', '177', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('185', '肃宁县', '177', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('186', '南皮县', '177', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('187', '吴桥县', '177', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('188', '献县', '177', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('189', '孟村回族自治县', '177', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('190', '泊头市', '177', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('191', '任丘市', '177', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('192', '黄骅市', '177', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('193', '河间市', '177', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('194', '廊坊市', '38', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('195', '安次区', '194', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('196', '广阳区', '194', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('197', '固安县', '194', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('198', '永清县', '194', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('199', '香河县', '194', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('200', '大城县', '194', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('201', '文安县', '194', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('202', '大厂回族自治县', '194', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('203', '霸州市', '194', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('204', '三河市', '194', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('205', '衡水市', '38', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('206', '桃城区', '205', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('207', '冀州区', '205', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('208', '枣强县', '205', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('209', '武邑县', '205', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('210', '武强县', '205', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('211', '饶阳县', '205', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('212', '安平县', '205', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('213', '故城县', '205', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('214', '景县', '205', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('215', '阜城县', '205', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('216', '深州市', '205', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('217', '省直辖县级行政区划', '38', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('218', '定州市', '217', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('219', '辛集市', '217', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('220', '山西省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('221', '太原市', '220', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('222', '小店区', '221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('223', '迎泽区', '221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('224', '杏花岭区', '221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('225', '尖草坪区', '221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('226', '万柏林区', '221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('227', '晋源区', '221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('228', '清徐县', '221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('229', '阳曲县', '221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('230', '娄烦县', '221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('231', '古交市', '221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('232', '大同市', '220', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('233', '城区', '232', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('234', '矿区', '232', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('235', '南郊区', '232', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('236', '新荣区', '232', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('237', '阳高县', '232', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('238', '天镇县', '232', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('239', '广灵县', '232', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('240', '灵丘县', '232', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('241', '浑源县', '232', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('242', '左云县', '232', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('243', '大同县', '232', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('244', '阳泉市', '220', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('245', '城区', '244', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('246', '矿区', '244', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('247', '郊区', '244', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('248', '平定县', '244', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('249', '盂县', '244', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('250', '长治市', '220', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('251', '城区', '250', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('252', '郊区', '250', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('253', '长治县', '250', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('254', '襄垣县', '250', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('255', '屯留县', '250', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('256', '平顺县', '250', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('257', '黎城县', '250', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('258', '壶关县', '250', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('259', '长子县', '250', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('260', '武乡县', '250', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('261', '沁县', '250', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('262', '沁源县', '250', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('263', '潞城市', '250', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('264', '晋城市', '220', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('265', '城区', '264', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('266', '沁水县', '264', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('267', '阳城县', '264', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('268', '陵川县', '264', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('269', '泽州县', '264', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('270', '高平市', '264', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('271', '朔州市', '220', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('272', '朔城区', '271', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('273', '平鲁区', '271', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('274', '山阴县', '271', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('275', '应县', '271', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('276', '右玉县', '271', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('277', '怀仁县', '271', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('278', '晋中市', '220', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('279', '榆次区', '278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('280', '榆社县', '278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('281', '左权县', '278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('282', '和顺县', '278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('283', '昔阳县', '278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('284', '寿阳县', '278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('285', '太谷县', '278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('286', '祁县', '278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('287', '平遥县', '278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('288', '灵石县', '278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('289', '介休市', '278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('290', '运城市', '220', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('291', '盐湖区', '290', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('292', '临猗县', '290', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('293', '万荣县', '290', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('294', '闻喜县', '290', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('295', '稷山县', '290', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('296', '新绛县', '290', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('297', '绛县', '290', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('298', '垣曲县', '290', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('299', '夏县', '290', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('300', '平陆县', '290', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('301', '芮城县', '290', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('302', '永济市', '290', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('303', '河津市', '290', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('304', '忻州市', '220', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('305', '忻府区', '304', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('306', '定襄县', '304', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('307', '五台县', '304', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('308', '代县', '304', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('309', '繁峙县', '304', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('310', '宁武县', '304', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('311', '静乐县', '304', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('312', '神池县', '304', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('313', '五寨县', '304', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('314', '岢岚县', '304', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('315', '河曲县', '304', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('316', '保德县', '304', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('317', '偏关县', '304', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('318', '原平市', '304', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('319', '临汾市', '220', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('320', '尧都区', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('321', '曲沃县', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('322', '翼城县', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('323', '襄汾县', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('324', '洪洞县', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('325', '古县', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('326', '安泽县', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('327', '浮山县', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('328', '吉县', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('329', '乡宁县', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('330', '大宁县', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('331', '隰县', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('332', '永和县', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('333', '蒲县', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('334', '汾西县', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('335', '侯马市', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('336', '霍州市', '319', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('337', '吕梁市', '220', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('338', '离石区', '337', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('339', '文水县', '337', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('340', '交城县', '337', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('341', '兴县', '337', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('342', '临县', '337', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('343', '柳林县', '337', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('344', '石楼县', '337', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('345', '岚县', '337', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('346', '方山县', '337', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('347', '中阳县', '337', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('348', '交口县', '337', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('349', '孝义市', '337', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('350', '汾阳市', '337', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('351', '内蒙古自治区', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('352', '呼和浩特市', '351', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('353', '新城区', '352', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('354', '回民区', '352', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('355', '玉泉区', '352', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('356', '赛罕区', '352', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('357', '土默特左旗', '352', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('358', '托克托县', '352', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('359', '和林格尔县', '352', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('360', '清水河县', '352', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('361', '武川县', '352', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('362', '包头市', '351', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('363', '东河区', '362', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('364', '昆都仑区', '362', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('365', '青山区', '362', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('366', '石拐区', '362', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('367', '白云鄂博矿区', '362', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('368', '九原区', '362', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('369', '土默特右旗', '362', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('370', '固阳县', '362', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('371', '达尔罕茂明安联合旗', '362', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('372', '乌海市', '351', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('373', '海勃湾区', '372', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('374', '海南区', '372', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('375', '乌达区', '372', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('376', '赤峰市', '351', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('377', '红山区', '376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('378', '元宝山区', '376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('379', '松山区', '376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('380', '阿鲁科尔沁旗', '376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('381', '巴林左旗', '376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('382', '巴林右旗', '376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('383', '林西县', '376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('384', '克什克腾旗', '376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('385', '翁牛特旗', '376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('386', '喀喇沁旗', '376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('387', '宁城县', '376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('388', '敖汉旗', '376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('389', '通辽市', '351', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('390', '科尔沁区', '389', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('391', '科尔沁左翼中旗', '389', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('392', '科尔沁左翼后旗', '389', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('393', '开鲁县', '389', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('394', '库伦旗', '389', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('395', '奈曼旗', '389', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('396', '扎鲁特旗', '389', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('397', '霍林郭勒市', '389', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('398', '鄂尔多斯市', '351', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('399', '东胜区', '398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('400', '康巴什区', '398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('401', '达拉特旗', '398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('402', '准格尔旗', '398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('403', '鄂托克前旗', '398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('404', '鄂托克旗', '398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('405', '杭锦旗', '398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('406', '乌审旗', '398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('407', '伊金霍洛旗', '398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('408', '呼伦贝尔市', '351', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('409', '海拉尔区', '408', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('410', '扎赉诺尔区', '408', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('411', '阿荣旗', '408', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('412', '莫力达瓦达斡尔族自治旗', '408', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('413', '鄂伦春自治旗', '408', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('414', '鄂温克族自治旗', '408', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('415', '陈巴尔虎旗', '408', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('416', '新巴尔虎左旗', '408', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('417', '新巴尔虎右旗', '408', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('418', '满洲里市', '408', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('419', '牙克石市', '408', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('420', '扎兰屯市', '408', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('421', '额尔古纳市', '408', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('422', '根河市', '408', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('423', '巴彦淖尔市', '351', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('424', '临河区', '423', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('425', '五原县', '423', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('426', '磴口县', '423', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('427', '乌拉特前旗', '423', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('428', '乌拉特中旗', '423', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('429', '乌拉特后旗', '423', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('430', '杭锦后旗', '423', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('431', '乌兰察布市', '351', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('432', '集宁区', '431', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('433', '卓资县', '431', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('434', '化德县', '431', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('435', '商都县', '431', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('436', '兴和县', '431', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('437', '凉城县', '431', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('438', '察哈尔右翼前旗', '431', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('439', '察哈尔右翼中旗', '431', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('440', '察哈尔右翼后旗', '431', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('441', '四子王旗', '431', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('442', '丰镇市', '431', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('443', '兴安盟', '351', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('444', '乌兰浩特市', '443', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('445', '阿尔山市', '443', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('446', '科尔沁右翼前旗', '443', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('447', '科尔沁右翼中旗', '443', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('448', '扎赉特旗', '443', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('449', '突泉县', '443', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('450', '锡林郭勒盟', '351', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('451', '二连浩特市', '450', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('452', '锡林浩特市', '450', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('453', '阿巴嘎旗', '450', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('454', '苏尼特左旗', '450', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('455', '苏尼特右旗', '450', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('456', '东乌珠穆沁旗', '450', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('457', '西乌珠穆沁旗', '450', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('458', '太仆寺旗', '450', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('459', '镶黄旗', '450', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('460', '正镶白旗', '450', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('461', '正蓝旗', '450', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('462', '多伦县', '450', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('463', '阿拉善盟', '351', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('464', '阿拉善左旗', '463', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('465', '阿拉善右旗', '463', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('466', '额济纳旗', '463', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('467', '辽宁省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('468', '沈阳市', '467', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('469', '和平区', '468', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('470', '沈河区', '468', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('471', '大东区', '468', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('472', '皇姑区', '468', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('473', '铁西区', '468', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('474', '苏家屯区', '468', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('475', '浑南区', '468', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('476', '沈北新区', '468', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('477', '于洪区', '468', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('478', '辽中区', '468', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('479', '康平县', '468', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('480', '法库县', '468', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('481', '新民市', '468', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('482', '大连市', '467', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('483', '中山区', '482', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('484', '西岗区', '482', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('485', '沙河口区', '482', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('486', '甘井子区', '482', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('487', '旅顺口区', '482', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('488', '金州区', '482', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('489', '普兰店区', '482', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('490', '长海县', '482', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('491', '瓦房店市', '482', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('492', '庄河市', '482', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('493', '鞍山市', '467', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('494', '铁东区', '493', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('495', '铁西区', '493', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('496', '立山区', '493', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('497', '千山区', '493', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('498', '台安县', '493', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('499', '岫岩满族自治县', '493', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('500', '海城市', '493', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('501', '抚顺市', '467', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('502', '新抚区', '501', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('503', '东洲区', '501', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('504', '望花区', '501', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('505', '顺城区', '501', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('506', '抚顺县', '501', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('507', '新宾满族自治县', '501', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('508', '清原满族自治县', '501', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('509', '本溪市', '467', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('510', '平山区', '509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('511', '溪湖区', '509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('512', '明山区', '509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('513', '南芬区', '509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('514', '本溪满族自治县', '509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('515', '桓仁满族自治县', '509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('516', '丹东市', '467', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('517', '元宝区', '516', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('518', '振兴区', '516', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('519', '振安区', '516', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('520', '宽甸满族自治县', '516', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('521', '东港市', '516', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('522', '凤城市', '516', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('523', '锦州市', '467', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('524', '古塔区', '523', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('525', '凌河区', '523', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('526', '太和区', '523', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('527', '黑山县', '523', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('528', '义县', '523', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('529', '凌海市', '523', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('530', '北镇市', '523', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('531', '营口市', '467', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('532', '站前区', '531', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('533', '西市区', '531', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('534', '鲅鱼圈区', '531', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('535', '老边区', '531', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('536', '盖州市', '531', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('537', '大石桥市', '531', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('538', '阜新市', '467', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('539', '海州区', '538', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('540', '新邱区', '538', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('541', '太平区', '538', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('542', '清河门区', '538', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('543', '细河区', '538', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('544', '阜新蒙古族自治县', '538', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('545', '彰武县', '538', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('546', '辽阳市', '467', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('547', '白塔区', '546', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('548', '文圣区', '546', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('549', '宏伟区', '546', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('550', '弓长岭区', '546', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('551', '太子河区', '546', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('552', '辽阳县', '546', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('553', '灯塔市', '546', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('554', '盘锦市', '467', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('555', '双台子区', '554', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('556', '兴隆台区', '554', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('557', '大洼区', '554', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('558', '盘山县', '554', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('559', '铁岭市', '467', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('560', '银州区', '559', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('561', '清河区', '559', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('562', '铁岭县', '559', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('563', '西丰县', '559', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('564', '昌图县', '559', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('565', '调兵山市', '559', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('566', '开原市', '559', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('567', '朝阳市', '467', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('568', '双塔区', '567', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('569', '龙城区', '567', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('570', '朝阳县', '567', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('571', '建平县', '567', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('572', '喀喇沁左翼蒙古族自治县', '567', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('573', '北票市', '567', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('574', '凌源市', '567', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('575', '葫芦岛市', '467', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('576', '连山区', '575', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('577', '龙港区', '575', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('578', '南票区', '575', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('579', '绥中县', '575', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('580', '建昌县', '575', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('581', '兴城市', '575', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('582', '吉林省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('583', '长春市', '582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('584', '南关区', '583', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('585', '宽城区', '583', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('586', '朝阳区', '583', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('587', '二道区', '583', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('588', '绿园区', '583', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('589', '双阳区', '583', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('590', '九台区', '583', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('591', '农安县', '583', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('592', '榆树市', '583', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('593', '德惠市', '583', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('594', '吉林市', '582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('595', '昌邑区', '594', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('596', '龙潭区', '594', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('597', '船营区', '594', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('598', '丰满区', '594', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('599', '永吉县', '594', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('600', '蛟河市', '594', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('601', '桦甸市', '594', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('602', '舒兰市', '594', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('603', '磐石市', '594', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('604', '四平市', '582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('605', '铁西区', '604', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('606', '铁东区', '604', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('607', '梨树县', '604', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('608', '伊通满族自治县', '604', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('609', '公主岭市', '604', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('610', '双辽市', '604', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('611', '辽源市', '582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('612', '龙山区', '611', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('613', '西安区', '611', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('614', '东丰县', '611', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('615', '东辽县', '611', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('616', '通化市', '582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('617', '东昌区', '616', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('618', '二道江区', '616', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('619', '通化县', '616', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('620', '辉南县', '616', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('621', '柳河县', '616', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('622', '梅河口市', '616', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('623', '集安市', '616', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('624', '白山市', '582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('625', '浑江区', '624', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('626', '江源区', '624', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('627', '抚松县', '624', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('628', '靖宇县', '624', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('629', '长白朝鲜族自治县', '624', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('630', '临江市', '624', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('631', '松原市', '582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('632', '宁江区', '631', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('633', '前郭尔罗斯蒙古族自治县', '631', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('634', '长岭县', '631', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('635', '乾安县', '631', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('636', '扶余市', '631', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('637', '白城市', '582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('638', '洮北区', '637', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('639', '镇赉县', '637', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('640', '通榆县', '637', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('641', '洮南市', '637', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('642', '大安市', '637', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('643', '延边朝鲜族自治州', '582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('644', '延吉市', '643', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('645', '图们市', '643', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('646', '敦化市', '643', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('647', '珲春市', '643', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('648', '龙井市', '643', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('649', '和龙市', '643', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('650', '汪清县', '643', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('651', '安图县', '643', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('652', '黑龙江省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('653', '哈尔滨市', '652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('654', '道里区', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('655', '南岗区', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('656', '道外区', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('657', '平房区', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('658', '松北区', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('659', '香坊区', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('660', '呼兰区', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('661', '阿城区', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('662', '双城区', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('663', '依兰县', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('664', '方正县', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('665', '宾县', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('666', '巴彦县', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('667', '木兰县', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('668', '通河县', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('669', '延寿县', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('670', '尚志市', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('671', '五常市', '653', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('672', '齐齐哈尔市', '652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('673', '龙沙区', '672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('674', '建华区', '672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('675', '铁锋区', '672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('676', '昂昂溪区', '672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('677', '富拉尔基区', '672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('678', '碾子山区', '672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('679', '梅里斯达斡尔族区', '672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('680', '龙江县', '672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('681', '依安县', '672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('682', '泰来县', '672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('683', '甘南县', '672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('684', '富裕县', '672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('685', '克山县', '672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('686', '克东县', '672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('687', '拜泉县', '672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('688', '讷河市', '672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('689', '鸡西市', '652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('690', '鸡冠区', '689', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('691', '恒山区', '689', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('692', '滴道区', '689', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('693', '梨树区', '689', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('694', '城子河区', '689', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('695', '麻山区', '689', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('696', '鸡东县', '689', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('697', '虎林市', '689', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('698', '密山市', '689', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('699', '鹤岗市', '652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('700', '向阳区', '699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('701', '工农区', '699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('702', '南山区', '699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('703', '兴安区', '699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('704', '东山区', '699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('705', '兴山区', '699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('706', '萝北县', '699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('707', '绥滨县', '699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('708', '双鸭山市', '652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('709', '尖山区', '708', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('710', '岭东区', '708', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('711', '四方台区', '708', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('712', '宝山区', '708', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('713', '集贤县', '708', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('714', '友谊县', '708', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('715', '宝清县', '708', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('716', '饶河县', '708', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('717', '大庆市', '652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('718', '萨尔图区', '717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('719', '龙凤区', '717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('720', '让胡路区', '717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('721', '红岗区', '717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('722', '大同区', '717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('723', '肇州县', '717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('724', '肇源县', '717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('725', '林甸县', '717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('726', '杜尔伯特蒙古族自治县', '717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('727', '伊春市', '652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('728', '伊春区', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('729', '南岔区', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('730', '友好区', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('731', '西林区', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('732', '翠峦区', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('733', '新青区', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('734', '美溪区', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('735', '金山屯区', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('736', '五营区', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('737', '乌马河区', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('738', '汤旺河区', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('739', '带岭区', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('740', '乌伊岭区', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('741', '红星区', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('742', '上甘岭区', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('743', '嘉荫县', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('744', '铁力市', '727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('745', '佳木斯市', '652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('746', '向阳区', '745', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('747', '前进区', '745', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('748', '东风区', '745', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('749', '郊区', '745', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('750', '桦南县', '745', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('751', '桦川县', '745', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('752', '汤原县', '745', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('753', '同江市', '745', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('754', '富锦市', '745', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('755', '抚远市', '745', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('756', '七台河市', '652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('757', '新兴区', '756', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('758', '桃山区', '756', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('759', '茄子河区', '756', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('760', '勃利县', '756', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('761', '牡丹江市', '652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('762', '东安区', '761', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('763', '阳明区', '761', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('764', '爱民区', '761', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('765', '西安区', '761', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('766', '林口县', '761', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('767', '绥芬河市', '761', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('768', '海林市', '761', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('769', '宁安市', '761', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('770', '穆棱市', '761', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('771', '东宁市', '761', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('772', '黑河市', '652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('773', '爱辉区', '772', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('774', '嫩江县', '772', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('775', '逊克县', '772', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('776', '孙吴县', '772', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('777', '北安市', '772', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('778', '五大连池市', '772', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('779', '绥化市', '652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('780', '北林区', '779', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('781', '望奎县', '779', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('782', '兰西县', '779', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('783', '青冈县', '779', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('784', '庆安县', '779', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('785', '明水县', '779', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('786', '绥棱县', '779', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('787', '安达市', '779', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('788', '肇东市', '779', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('789', '海伦市', '779', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('790', '大兴安岭地区', '652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('791', '呼玛县', '790', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('792', '塔河县', '790', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('793', '漠河县', '790', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('794', '上海市', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('795', '上海市', '794', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('796', '黄浦区', '795', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('797', '徐汇区', '795', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('798', '长宁区', '795', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('799', '静安区', '795', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('800', '普陀区', '795', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('801', '虹口区', '795', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('802', '杨浦区', '795', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('803', '闵行区', '795', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('804', '宝山区', '795', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('805', '嘉定区', '795', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('806', '浦东新区', '795', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('807', '金山区', '795', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('808', '松江区', '795', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('809', '青浦区', '795', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('810', '奉贤区', '795', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('811', '崇明区', '795', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('812', '江苏省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('813', '南京市', '812', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('814', '玄武区', '813', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('815', '秦淮区', '813', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('816', '建邺区', '813', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('817', '鼓楼区', '813', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('818', '浦口区', '813', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('819', '栖霞区', '813', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('820', '雨花台区', '813', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('821', '江宁区', '813', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('822', '六合区', '813', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('823', '溧水区', '813', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('824', '高淳区', '813', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('825', '无锡市', '812', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('826', '锡山区', '825', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('827', '惠山区', '825', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('828', '滨湖区', '825', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('829', '梁溪区', '825', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('830', '新吴区', '825', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('831', '江阴市', '825', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('832', '宜兴市', '825', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('833', '徐州市', '812', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('834', '鼓楼区', '833', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('835', '云龙区', '833', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('836', '贾汪区', '833', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('837', '泉山区', '833', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('838', '铜山区', '833', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('839', '丰县', '833', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('840', '沛县', '833', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('841', '睢宁县', '833', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('842', '新沂市', '833', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('843', '邳州市', '833', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('844', '常州市', '812', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('845', '天宁区', '844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('846', '钟楼区', '844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('847', '新北区', '844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('848', '武进区', '844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('849', '金坛区', '844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('850', '溧阳市', '844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('851', '苏州市', '812', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('852', '虎丘区', '851', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('853', '吴中区', '851', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('854', '相城区', '851', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('855', '姑苏区', '851', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('856', '吴江区', '851', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('857', '常熟市', '851', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('858', '张家港市', '851', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('859', '昆山市', '851', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('860', '太仓市', '851', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('861', '南通市', '812', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('862', '崇川区', '861', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('863', '港闸区', '861', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('864', '通州区', '861', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('865', '海安县', '861', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('866', '如东县', '861', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('867', '启东市', '861', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('868', '如皋市', '861', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('869', '海门市', '861', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('870', '连云港市', '812', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('871', '连云区', '870', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('872', '海州区', '870', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('873', '赣榆区', '870', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('874', '东海县', '870', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('875', '灌云县', '870', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('876', '灌南县', '870', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('877', '淮安市', '812', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('878', '淮安区', '877', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('879', '淮阴区', '877', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('880', '清江浦区', '877', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('881', '洪泽区', '877', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('882', '涟水县', '877', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('883', '盱眙县', '877', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('884', '金湖县', '877', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('885', '盐城市', '812', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('886', '亭湖区', '885', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('887', '盐都区', '885', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('888', '大丰区', '885', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('889', '响水县', '885', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('890', '滨海县', '885', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('891', '阜宁县', '885', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('892', '射阳县', '885', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('893', '建湖县', '885', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('894', '东台市', '885', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('895', '扬州市', '812', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('896', '广陵区', '895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('897', '邗江区', '895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('898', '江都区', '895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('899', '宝应县', '895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('900', '仪征市', '895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('901', '高邮市', '895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('902', '镇江市', '812', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('903', '京口区', '902', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('904', '润州区', '902', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('905', '丹徒区', '902', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('906', '丹阳市', '902', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('907', '扬中市', '902', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('908', '句容市', '902', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('909', '泰州市', '812', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('910', '海陵区', '909', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('911', '高港区', '909', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('912', '姜堰区', '909', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('913', '兴化市', '909', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('914', '靖江市', '909', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('915', '泰兴市', '909', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('916', '宿迁市', '812', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('917', '宿城区', '916', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('918', '宿豫区', '916', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('919', '沭阳县', '916', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('920', '泗阳县', '916', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('921', '泗洪县', '916', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('922', '浙江省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('923', '杭州市', '922', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('924', '上城区', '923', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('925', '下城区', '923', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('926', '江干区', '923', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('927', '拱墅区', '923', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('928', '西湖区', '923', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('929', '滨江区', '923', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('930', '萧山区', '923', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('931', '余杭区', '923', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('932', '富阳区', '923', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('933', '桐庐县', '923', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('934', '淳安县', '923', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('935', '建德市', '923', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('936', '临安市', '923', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('937', '宁波市', '922', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('938', '海曙区', '937', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('939', '江东区', '937', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('940', '江北区', '937', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('941', '北仑区', '937', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('942', '镇海区', '937', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('943', '鄞州区', '937', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('944', '象山县', '937', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('945', '宁海县', '937', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('946', '余姚市', '937', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('947', '慈溪市', '937', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('948', '奉化市', '937', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('949', '温州市', '922', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('950', '鹿城区', '949', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('951', '龙湾区', '949', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('952', '瓯海区', '949', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('953', '洞头区', '949', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('954', '永嘉县', '949', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('955', '平阳县', '949', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('956', '苍南县', '949', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('957', '文成县', '949', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('958', '泰顺县', '949', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('959', '瑞安市', '949', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('960', '乐清市', '949', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('961', '嘉兴市', '922', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('962', '南湖区', '961', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('963', '秀洲区', '961', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('964', '嘉善县', '961', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('965', '海盐县', '961', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('966', '海宁市', '961', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('967', '平湖市', '961', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('968', '桐乡市', '961', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('969', '湖州市', '922', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('970', '吴兴区', '969', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('971', '南浔区', '969', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('972', '德清县', '969', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('973', '长兴县', '969', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('974', '安吉县', '969', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('975', '绍兴市', '922', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('976', '越城区', '975', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('977', '柯桥区', '975', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('978', '上虞区', '975', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('979', '新昌县', '975', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('980', '诸暨市', '975', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('981', '嵊州市', '975', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('982', '金华市', '922', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('983', '婺城区', '982', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('984', '金东区', '982', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('985', '武义县', '982', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('986', '浦江县', '982', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('987', '磐安县', '982', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('988', '兰溪市', '982', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('989', '义乌市', '982', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('990', '东阳市', '982', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('991', '永康市', '982', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('992', '衢州市', '922', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('993', '柯城区', '992', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('994', '衢江区', '992', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('995', '常山县', '992', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('996', '开化县', '992', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('997', '龙游县', '992', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('998', '江山市', '992', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('999', '舟山市', '922', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1000', '定海区', '999', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1001', '普陀区', '999', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1002', '岱山县', '999', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1003', '嵊泗县', '999', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1004', '台州市', '922', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1005', '椒江区', '1004', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1006', '黄岩区', '1004', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1007', '路桥区', '1004', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1008', '玉环县', '1004', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1009', '三门县', '1004', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1010', '天台县', '1004', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1011', '仙居县', '1004', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1012', '温岭市', '1004', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1013', '临海市', '1004', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1014', '丽水市', '922', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1015', '莲都区', '1014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1016', '青田县', '1014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1017', '缙云县', '1014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1018', '遂昌县', '1014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1019', '松阳县', '1014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1020', '云和县', '1014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1021', '庆元县', '1014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1022', '景宁畲族自治县', '1014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1023', '龙泉市', '1014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1024', '安徽省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1025', '合肥市', '1024', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1026', '瑶海区', '1025', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1027', '庐阳区', '1025', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1028', '蜀山区', '1025', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1029', '包河区', '1025', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1030', '长丰县', '1025', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1031', '肥东县', '1025', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1032', '肥西县', '1025', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1033', '庐江县', '1025', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1034', '巢湖市', '1025', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1035', '芜湖市', '1024', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1036', '镜湖区', '1035', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1037', '弋江区', '1035', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1038', '鸠江区', '1035', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1039', '三山区', '1035', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1040', '芜湖县', '1035', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1041', '繁昌县', '1035', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1042', '南陵县', '1035', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1043', '无为县', '1035', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1044', '蚌埠市', '1024', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1045', '龙子湖区', '1044', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1046', '蚌山区', '1044', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1047', '禹会区', '1044', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1048', '淮上区', '1044', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1049', '怀远县', '1044', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1050', '五河县', '1044', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1051', '固镇县', '1044', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1052', '淮南市', '1024', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1053', '大通区', '1052', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1054', '田家庵区', '1052', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1055', '谢家集区', '1052', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1056', '八公山区', '1052', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1057', '潘集区', '1052', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1058', '凤台县', '1052', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1059', '寿县', '1052', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1060', '马鞍山市', '1024', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1061', '花山区', '1060', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1062', '雨山区', '1060', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1063', '博望区', '1060', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1064', '当涂县', '1060', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1065', '含山县', '1060', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1066', '和县', '1060', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1067', '淮北市', '1024', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1068', '杜集区', '1067', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1069', '相山区', '1067', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1070', '烈山区', '1067', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1071', '濉溪县', '1067', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1072', '铜陵市', '1024', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1073', '铜官区', '1072', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1074', '义安区', '1072', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1075', '郊区', '1072', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1076', '枞阳县', '1072', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1077', '安庆市', '1024', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1078', '迎江区', '1077', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1079', '大观区', '1077', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1080', '宜秀区', '1077', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1081', '怀宁县', '1077', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1082', '潜山县', '1077', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1083', '太湖县', '1077', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1084', '宿松县', '1077', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1085', '望江县', '1077', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1086', '岳西县', '1077', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1087', '桐城市', '1077', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1088', '黄山市', '1024', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1089', '屯溪区', '1088', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1090', '黄山区', '1088', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1091', '徽州区', '1088', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1092', '歙县', '1088', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1093', '休宁县', '1088', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1094', '黟县', '1088', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1095', '祁门县', '1088', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1096', '滁州市', '1024', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1097', '琅琊区', '1096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1098', '南谯区', '1096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1099', '来安县', '1096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1100', '全椒县', '1096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1101', '定远县', '1096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1102', '凤阳县', '1096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1103', '天长市', '1096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1104', '明光市', '1096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1105', '阜阳市', '1024', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1106', '颍州区', '1105', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1107', '颍东区', '1105', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1108', '颍泉区', '1105', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1109', '临泉县', '1105', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1110', '太和县', '1105', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1111', '阜南县', '1105', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1112', '颍上县', '1105', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1113', '界首市', '1105', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1114', '宿州市', '1024', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1115', '埇桥区', '1114', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1116', '砀山县', '1114', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1117', '萧县', '1114', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1118', '灵璧县', '1114', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1119', '泗县', '1114', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1120', '六安市', '1024', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1121', '金安区', '1120', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1122', '裕安区', '1120', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1123', '叶集区', '1120', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1124', '霍邱县', '1120', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1125', '舒城县', '1120', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1126', '金寨县', '1120', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1127', '霍山县', '1120', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1128', '亳州市', '1024', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1129', '谯城区', '1128', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1130', '涡阳县', '1128', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1131', '蒙城县', '1128', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1132', '利辛县', '1128', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1133', '池州市', '1024', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1134', '贵池区', '1133', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1135', '东至县', '1133', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1136', '石台县', '1133', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1137', '青阳县', '1133', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1138', '宣城市', '1024', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1139', '宣州区', '1138', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1140', '郎溪县', '1138', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1141', '广德县', '1138', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1142', '泾县', '1138', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1143', '绩溪县', '1138', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1144', '旌德县', '1138', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1145', '宁国市', '1138', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1146', '福建省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1147', '福州市', '1146', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1148', '鼓楼区', '1147', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1149', '台江区', '1147', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1150', '仓山区', '1147', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1151', '马尾区', '1147', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1152', '晋安区', '1147', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1153', '闽侯县', '1147', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1154', '连江县', '1147', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1155', '罗源县', '1147', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1156', '闽清县', '1147', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1157', '永泰县', '1147', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1158', '平潭县', '1147', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1159', '福清市', '1147', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1160', '长乐市', '1147', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1161', '厦门市', '1146', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1162', '思明区', '1161', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1163', '海沧区', '1161', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1164', '湖里区', '1161', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1165', '集美区', '1161', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1166', '同安区', '1161', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1167', '翔安区', '1161', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1168', '莆田市', '1146', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1169', '城厢区', '1168', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1170', '涵江区', '1168', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1171', '荔城区', '1168', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1172', '秀屿区', '1168', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1173', '仙游县', '1168', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1174', '三明市', '1146', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1175', '梅列区', '1174', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1176', '三元区', '1174', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1177', '明溪县', '1174', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1178', '清流县', '1174', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1179', '宁化县', '1174', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1180', '大田县', '1174', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1181', '尤溪县', '1174', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1182', '沙县', '1174', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1183', '将乐县', '1174', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1184', '泰宁县', '1174', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1185', '建宁县', '1174', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1186', '永安市', '1174', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1187', '泉州市', '1146', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1188', '鲤城区', '1187', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1189', '丰泽区', '1187', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1190', '洛江区', '1187', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1191', '泉港区', '1187', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1192', '惠安县', '1187', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1193', '安溪县', '1187', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1194', '永春县', '1187', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1195', '德化县', '1187', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1196', '金门县', '1187', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1197', '石狮市', '1187', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1198', '晋江市', '1187', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1199', '南安市', '1187', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1200', '漳州市', '1146', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1201', '芗城区', '1200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1202', '龙文区', '1200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1203', '云霄县', '1200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1204', '漳浦县', '1200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1205', '诏安县', '1200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1206', '长泰县', '1200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1207', '东山县', '1200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1208', '南靖县', '1200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1209', '平和县', '1200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1210', '华安县', '1200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1211', '龙海市', '1200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1212', '南平市', '1146', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1213', '延平区', '1212', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1214', '建阳区', '1212', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1215', '顺昌县', '1212', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1216', '浦城县', '1212', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1217', '光泽县', '1212', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1218', '松溪县', '1212', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1219', '政和县', '1212', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1220', '邵武市', '1212', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1221', '武夷山市', '1212', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1222', '建瓯市', '1212', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1223', '龙岩市', '1146', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1224', '新罗区', '1223', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1225', '永定区', '1223', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1226', '长汀县', '1223', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1227', '上杭县', '1223', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1228', '武平县', '1223', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1229', '连城县', '1223', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1230', '漳平市', '1223', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1231', '宁德市', '1146', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1232', '蕉城区', '1231', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1233', '霞浦县', '1231', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1234', '古田县', '1231', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1235', '屏南县', '1231', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1236', '寿宁县', '1231', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1237', '周宁县', '1231', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1238', '柘荣县', '1231', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1239', '福安市', '1231', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1240', '福鼎市', '1231', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1241', '江西省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1242', '南昌市', '1241', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1243', '东湖区', '1242', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1244', '西湖区', '1242', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1245', '青云谱区', '1242', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1246', '湾里区', '1242', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1247', '青山湖区', '1242', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1248', '新建区', '1242', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1249', '南昌县', '1242', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1250', '安义县', '1242', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1251', '进贤县', '1242', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1252', '景德镇市', '1241', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1253', '昌江区', '1252', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1254', '珠山区', '1252', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1255', '浮梁县', '1252', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1256', '乐平市', '1252', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1257', '萍乡市', '1241', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1258', '安源区', '1257', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1259', '湘东区', '1257', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1260', '莲花县', '1257', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1261', '上栗县', '1257', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1262', '芦溪县', '1257', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1263', '九江市', '1241', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1264', '濂溪区', '1263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1265', '浔阳区', '1263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1266', '九江县', '1263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1267', '武宁县', '1263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1268', '修水县', '1263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1269', '永修县', '1263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1270', '德安县', '1263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1271', '都昌县', '1263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1272', '湖口县', '1263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1273', '彭泽县', '1263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1274', '瑞昌市', '1263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1275', '共青城市', '1263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1276', '庐山市', '1263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1277', '新余市', '1241', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1278', '渝水区', '1277', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1279', '分宜县', '1277', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1280', '鹰潭市', '1241', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1281', '月湖区', '1280', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1282', '余江县', '1280', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1283', '贵溪市', '1280', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1284', '赣州市', '1241', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1285', '章贡区', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1286', '南康区', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1287', '赣县', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1288', '信丰县', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1289', '大余县', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1290', '上犹县', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1291', '崇义县', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1292', '安远县', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1293', '龙南县', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1294', '定南县', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1295', '全南县', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1296', '宁都县', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1297', '于都县', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1298', '兴国县', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1299', '会昌县', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1300', '寻乌县', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1301', '石城县', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1302', '瑞金市', '1284', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1303', '吉安市', '1241', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1304', '吉州区', '1303', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1305', '青原区', '1303', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1306', '吉安县', '1303', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1307', '吉水县', '1303', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1308', '峡江县', '1303', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1309', '新干县', '1303', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1310', '永丰县', '1303', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1311', '泰和县', '1303', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1312', '遂川县', '1303', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1313', '万安县', '1303', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1314', '安福县', '1303', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1315', '永新县', '1303', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1316', '井冈山市', '1303', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1317', '宜春市', '1241', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1318', '袁州区', '1317', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1319', '奉新县', '1317', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1320', '万载县', '1317', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1321', '上高县', '1317', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1322', '宜丰县', '1317', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1323', '靖安县', '1317', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1324', '铜鼓县', '1317', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1325', '丰城市', '1317', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1326', '樟树市', '1317', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1327', '高安市', '1317', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1328', '抚州市', '1241', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1329', '临川区', '1328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1330', '南城县', '1328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1331', '黎川县', '1328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1332', '南丰县', '1328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1333', '崇仁县', '1328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1334', '乐安县', '1328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1335', '宜黄县', '1328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1336', '金溪县', '1328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1337', '资溪县', '1328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1338', '东乡县', '1328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1339', '广昌县', '1328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1340', '上饶市', '1241', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1341', '信州区', '1340', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1342', '广丰区', '1340', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1343', '上饶县', '1340', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1344', '玉山县', '1340', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1345', '铅山县', '1340', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1346', '横峰县', '1340', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1347', '弋阳县', '1340', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1348', '余干县', '1340', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1349', '鄱阳县', '1340', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1350', '万年县', '1340', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1351', '婺源县', '1340', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1352', '德兴市', '1340', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1353', '山东省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1354', '济南市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1355', '历下区', '1354', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1356', '市中区', '1354', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1357', '槐荫区', '1354', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1358', '天桥区', '1354', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1359', '历城区', '1354', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1360', '长清区', '1354', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1361', '平阴县', '1354', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1362', '济阳县', '1354', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1363', '商河县', '1354', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1364', '章丘市', '1354', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1365', '青岛市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1366', '市南区', '1365', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1367', '市北区', '1365', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1368', '黄岛区', '1365', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1369', '崂山区', '1365', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1370', '李沧区', '1365', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1371', '城阳区', '1365', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1372', '胶州市', '1365', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1373', '即墨市', '1365', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1374', '平度市', '1365', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1375', '莱西市', '1365', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1376', '淄博市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1377', '淄川区', '1376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1378', '张店区', '1376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1379', '博山区', '1376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1380', '临淄区', '1376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1381', '周村区', '1376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1382', '桓台县', '1376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1383', '高青县', '1376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1384', '沂源县', '1376', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1385', '枣庄市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1386', '市中区', '1385', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1387', '薛城区', '1385', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1388', '峄城区', '1385', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1389', '台儿庄区', '1385', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1390', '山亭区', '1385', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1391', '滕州市', '1385', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1392', '东营市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1393', '东营区', '1392', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1394', '河口区', '1392', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1395', '垦利区', '1392', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1396', '利津县', '1392', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1397', '广饶县', '1392', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1398', '烟台市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1399', '芝罘区', '1398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1400', '福山区', '1398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1401', '牟平区', '1398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1402', '莱山区', '1398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1403', '长岛县', '1398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1404', '龙口市', '1398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1405', '莱阳市', '1398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1406', '莱州市', '1398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1407', '蓬莱市', '1398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1408', '招远市', '1398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1409', '栖霞市', '1398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1410', '海阳市', '1398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1411', '潍坊市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1412', '潍城区', '1411', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1413', '寒亭区', '1411', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1414', '坊子区', '1411', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1415', '奎文区', '1411', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1416', '临朐县', '1411', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1417', '昌乐县', '1411', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1418', '青州市', '1411', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1419', '诸城市', '1411', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1420', '寿光市', '1411', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1421', '安丘市', '1411', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1422', '高密市', '1411', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1423', '昌邑市', '1411', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1424', '济宁市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1425', '任城区', '1424', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1426', '兖州区', '1424', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1427', '微山县', '1424', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1428', '鱼台县', '1424', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1429', '金乡县', '1424', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1430', '嘉祥县', '1424', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1431', '汶上县', '1424', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1432', '泗水县', '1424', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1433', '梁山县', '1424', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1434', '曲阜市', '1424', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1435', '邹城市', '1424', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1436', '泰安市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1437', '泰山区', '1436', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1438', '岱岳区', '1436', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1439', '宁阳县', '1436', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1440', '东平县', '1436', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1441', '新泰市', '1436', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1442', '肥城市', '1436', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1443', '威海市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1444', '环翠区', '1443', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1445', '文登区', '1443', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1446', '荣成市', '1443', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1447', '乳山市', '1443', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1448', '日照市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1449', '东港区', '1448', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1450', '岚山区', '1448', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1451', '五莲县', '1448', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1452', '莒县', '1448', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1453', '莱芜市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1454', '莱城区', '1453', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1455', '钢城区', '1453', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1456', '临沂市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1457', '兰山区', '1456', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1458', '罗庄区', '1456', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1459', '河东区', '1456', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1460', '沂南县', '1456', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1461', '郯城县', '1456', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1462', '沂水县', '1456', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1463', '兰陵县', '1456', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1464', '费县', '1456', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1465', '平邑县', '1456', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1466', '莒南县', '1456', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1467', '蒙阴县', '1456', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1468', '临沭县', '1456', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1469', '德州市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1470', '德城区', '1469', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1471', '陵城区', '1469', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1472', '宁津县', '1469', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1473', '庆云县', '1469', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1474', '临邑县', '1469', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1475', '齐河县', '1469', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1476', '平原县', '1469', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1477', '夏津县', '1469', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1478', '武城县', '1469', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1479', '乐陵市', '1469', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1480', '禹城市', '1469', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1481', '聊城市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1482', '东昌府区', '1481', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1483', '阳谷县', '1481', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1484', '莘县', '1481', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1485', '茌平县', '1481', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1486', '东阿县', '1481', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1487', '冠县', '1481', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1488', '高唐县', '1481', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1489', '临清市', '1481', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1490', '滨州市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1491', '滨城区', '1490', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1492', '沾化区', '1490', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1493', '惠民县', '1490', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1494', '阳信县', '1490', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1495', '无棣县', '1490', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1496', '博兴县', '1490', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1497', '邹平县', '1490', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1498', '菏泽市', '1353', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1499', '牡丹区', '1498', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1500', '定陶区', '1498', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1501', '曹县', '1498', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1502', '单县', '1498', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1503', '成武县', '1498', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1504', '巨野县', '1498', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1505', '郓城县', '1498', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1506', '鄄城县', '1498', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1507', '东明县', '1498', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1508', '河南省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1509', '郑州市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1510', '中原区', '1509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1511', '二七区', '1509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1512', '管城回族区', '1509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1513', '金水区', '1509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1514', '上街区', '1509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1515', '惠济区', '1509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1516', '中牟县', '1509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1517', '巩义市', '1509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1518', '荥阳市', '1509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1519', '新密市', '1509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1520', '新郑市', '1509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1521', '登封市', '1509', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1522', '开封市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1523', '龙亭区', '1522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1524', '顺河回族区', '1522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1525', '鼓楼区', '1522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1526', '禹王台区', '1522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1527', '金明区', '1522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1528', '祥符区', '1522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1529', '杞县', '1522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1530', '通许县', '1522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1531', '尉氏县', '1522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1532', '兰考县', '1522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1533', '洛阳市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1534', '老城区', '1533', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1535', '西工区', '1533', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1536', '瀍河回族区', '1533', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1537', '涧西区', '1533', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1538', '吉利区', '1533', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1539', '洛龙区', '1533', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1540', '孟津县', '1533', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1541', '新安县', '1533', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1542', '栾川县', '1533', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1543', '嵩县', '1533', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1544', '汝阳县', '1533', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1545', '宜阳县', '1533', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1546', '洛宁县', '1533', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1547', '伊川县', '1533', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1548', '偃师市', '1533', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1549', '平顶山市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1550', '新华区', '1549', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1551', '卫东区', '1549', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1552', '石龙区', '1549', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1553', '湛河区', '1549', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1554', '宝丰县', '1549', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1555', '叶县', '1549', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1556', '鲁山县', '1549', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1557', '郏县', '1549', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1558', '舞钢市', '1549', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1559', '汝州市', '1549', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1560', '安阳市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1561', '文峰区', '1560', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1562', '北关区', '1560', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1563', '殷都区', '1560', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1564', '龙安区', '1560', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1565', '安阳县', '1560', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1566', '汤阴县', '1560', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1567', '滑县', '1560', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1568', '内黄县', '1560', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1569', '林州市', '1560', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1570', '鹤壁市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1571', '鹤山区', '1570', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1572', '山城区', '1570', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1573', '淇滨区', '1570', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1574', '浚县', '1570', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1575', '淇县', '1570', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1576', '新乡市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1577', '红旗区', '1576', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1578', '卫滨区', '1576', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1579', '凤泉区', '1576', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1580', '牧野区', '1576', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1581', '新乡县', '1576', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1582', '获嘉县', '1576', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1583', '原阳县', '1576', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1584', '延津县', '1576', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1585', '封丘县', '1576', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1586', '长垣县', '1576', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1587', '卫辉市', '1576', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1588', '辉县市', '1576', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1589', '焦作市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1590', '解放区', '1589', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1591', '中站区', '1589', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1592', '马村区', '1589', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1593', '山阳区', '1589', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1594', '修武县', '1589', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1595', '博爱县', '1589', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1596', '武陟县', '1589', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1597', '温县', '1589', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1598', '沁阳市', '1589', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1599', '孟州市', '1589', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1600', '濮阳市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1601', '华龙区', '1600', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1602', '清丰县', '1600', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1603', '南乐县', '1600', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1604', '范县', '1600', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1605', '台前县', '1600', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1606', '濮阳县', '1600', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1607', '许昌市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1608', '魏都区', '1607', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1609', '许昌县', '1607', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1610', '鄢陵县', '1607', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1611', '襄城县', '1607', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1612', '禹州市', '1607', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1613', '长葛市', '1607', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1614', '漯河市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1615', '源汇区', '1614', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1616', '郾城区', '1614', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1617', '召陵区', '1614', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1618', '舞阳县', '1614', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1619', '临颍县', '1614', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1620', '三门峡市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1621', '湖滨区', '1620', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1622', '陕州区', '1620', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1623', '渑池县', '1620', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1624', '卢氏县', '1620', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1625', '义马市', '1620', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1626', '灵宝市', '1620', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1627', '南阳市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1628', '宛城区', '1627', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1629', '卧龙区', '1627', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1630', '南召县', '1627', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1631', '方城县', '1627', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1632', '西峡县', '1627', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1633', '镇平县', '1627', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1634', '内乡县', '1627', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1635', '淅川县', '1627', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1636', '社旗县', '1627', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1637', '唐河县', '1627', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1638', '新野县', '1627', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1639', '桐柏县', '1627', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1640', '邓州市', '1627', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1641', '商丘市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1642', '梁园区', '1641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1643', '睢阳区', '1641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1644', '民权县', '1641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1645', '睢县', '1641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1646', '宁陵县', '1641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1647', '柘城县', '1641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1648', '虞城县', '1641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1649', '夏邑县', '1641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1650', '永城市', '1641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1651', '信阳市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1652', '浉河区', '1651', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1653', '平桥区', '1651', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1654', '罗山县', '1651', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1655', '光山县', '1651', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1656', '新县', '1651', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1657', '商城县', '1651', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1658', '固始县', '1651', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1659', '潢川县', '1651', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1660', '淮滨县', '1651', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1661', '息县', '1651', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1662', '周口市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1663', '川汇区', '1662', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1664', '扶沟县', '1662', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1665', '西华县', '1662', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1666', '商水县', '1662', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1667', '沈丘县', '1662', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1668', '郸城县', '1662', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1669', '淮阳县', '1662', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1670', '太康县', '1662', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1671', '鹿邑县', '1662', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1672', '项城市', '1662', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1673', '驻马店市', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1674', '驿城区', '1673', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1675', '西平县', '1673', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1676', '上蔡县', '1673', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1677', '平舆县', '1673', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1678', '正阳县', '1673', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1679', '确山县', '1673', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1680', '泌阳县', '1673', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1681', '汝南县', '1673', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1682', '遂平县', '1673', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1683', '新蔡县', '1673', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1684', '省直辖县级行政区划', '1508', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1685', '济源市', '1684', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1686', '湖北省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1687', '武汉市', '1686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1688', '江岸区', '1687', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1689', '江汉区', '1687', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1690', '硚口区', '1687', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1691', '汉阳区', '1687', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1692', '武昌区', '1687', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1693', '青山区', '1687', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1694', '洪山区', '1687', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1695', '东西湖区', '1687', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1696', '汉南区', '1687', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1697', '蔡甸区', '1687', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1698', '江夏区', '1687', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1699', '黄陂区', '1687', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1700', '新洲区', '1687', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1701', '黄石市', '1686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1702', '黄石港区', '1701', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1703', '西塞山区', '1701', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1704', '下陆区', '1701', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1705', '铁山区', '1701', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1706', '阳新县', '1701', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1707', '大冶市', '1701', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1708', '十堰市', '1686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1709', '茅箭区', '1708', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1710', '张湾区', '1708', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1711', '郧阳区', '1708', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1712', '郧西县', '1708', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1713', '竹山县', '1708', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1714', '竹溪县', '1708', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1715', '房县', '1708', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1716', '丹江口市', '1708', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1717', '宜昌市', '1686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1718', '西陵区', '1717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1719', '伍家岗区', '1717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1720', '点军区', '1717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1721', '猇亭区', '1717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1722', '夷陵区', '1717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1723', '远安县', '1717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1724', '兴山县', '1717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1725', '秭归县', '1717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1726', '长阳土家族自治县', '1717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1727', '五峰土家族自治县', '1717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1728', '宜都市', '1717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1729', '当阳市', '1717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1730', '枝江市', '1717', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1731', '襄阳市', '1686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1732', '襄城区', '1731', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1733', '樊城区', '1731', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1734', '襄州区', '1731', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1735', '南漳县', '1731', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1736', '谷城县', '1731', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1737', '保康县', '1731', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1738', '老河口市', '1731', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1739', '枣阳市', '1731', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1740', '宜城市', '1731', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1741', '鄂州市', '1686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1742', '梁子湖区', '1741', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1743', '华容区', '1741', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1744', '鄂城区', '1741', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1745', '荆门市', '1686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1746', '东宝区', '1745', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1747', '掇刀区', '1745', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1748', '京山县', '1745', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1749', '沙洋县', '1745', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1750', '钟祥市', '1745', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1751', '孝感市', '1686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1752', '孝南区', '1751', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1753', '孝昌县', '1751', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1754', '大悟县', '1751', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1755', '云梦县', '1751', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1756', '应城市', '1751', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1757', '安陆市', '1751', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1758', '汉川市', '1751', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1759', '荆州市', '1686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1760', '沙市区', '1759', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1761', '荆州区', '1759', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1762', '公安县', '1759', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1763', '监利县', '1759', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1764', '江陵县', '1759', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1765', '石首市', '1759', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1766', '洪湖市', '1759', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1767', '松滋市', '1759', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1768', '黄冈市', '1686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1769', '黄州区', '1768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1770', '团风县', '1768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1771', '红安县', '1768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1772', '罗田县', '1768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1773', '英山县', '1768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1774', '浠水县', '1768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1775', '蕲春县', '1768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1776', '黄梅县', '1768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1777', '麻城市', '1768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1778', '武穴市', '1768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1779', '咸宁市', '1686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1780', '咸安区', '1779', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1781', '嘉鱼县', '1779', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1782', '通城县', '1779', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1783', '崇阳县', '1779', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1784', '通山县', '1779', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1785', '赤壁市', '1779', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1786', '随州市', '1686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1787', '曾都区', '1786', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1788', '随县', '1786', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1789', '广水市', '1786', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1790', '恩施土家族苗族自治州', '1686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1791', '恩施市', '1790', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1792', '利川市', '1790', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1793', '建始县', '1790', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1794', '巴东县', '1790', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1795', '宣恩县', '1790', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1796', '咸丰县', '1790', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1797', '来凤县', '1790', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1798', '鹤峰县', '1790', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1799', '省直辖县级行政区划', '1686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1800', '仙桃市', '1799', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1801', '潜江市', '1799', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1802', '天门市', '1799', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1803', '神农架林区', '1799', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1804', '湖南省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1805', '长沙市', '1804', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1806', '芙蓉区', '1805', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1807', '天心区', '1805', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1808', '岳麓区', '1805', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1809', '开福区', '1805', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1810', '雨花区', '1805', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1811', '望城区', '1805', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1812', '长沙县', '1805', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1813', '宁乡县', '1805', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1814', '浏阳市', '1805', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1815', '株洲市', '1804', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1816', '荷塘区', '1815', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1817', '芦淞区', '1815', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1818', '石峰区', '1815', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1819', '天元区', '1815', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1820', '株洲县', '1815', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1821', '攸县', '1815', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1822', '茶陵县', '1815', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1823', '炎陵县', '1815', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1824', '醴陵市', '1815', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1825', '湘潭市', '1804', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1826', '雨湖区', '1825', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1827', '岳塘区', '1825', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1828', '湘潭县', '1825', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1829', '湘乡市', '1825', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1830', '韶山市', '1825', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1831', '衡阳市', '1804', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1832', '珠晖区', '1831', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1833', '雁峰区', '1831', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1834', '石鼓区', '1831', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1835', '蒸湘区', '1831', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1836', '南岳区', '1831', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1837', '衡阳县', '1831', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1838', '衡南县', '1831', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1839', '衡山县', '1831', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1840', '衡东县', '1831', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1841', '祁东县', '1831', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1842', '耒阳市', '1831', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1843', '常宁市', '1831', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1844', '邵阳市', '1804', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1845', '双清区', '1844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1846', '大祥区', '1844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1847', '北塔区', '1844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1848', '邵东县', '1844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1849', '新邵县', '1844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1850', '邵阳县', '1844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1851', '隆回县', '1844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1852', '洞口县', '1844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1853', '绥宁县', '1844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1854', '新宁县', '1844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1855', '城步苗族自治县', '1844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1856', '武冈市', '1844', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1857', '岳阳市', '1804', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1858', '岳阳楼区', '1857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1859', '云溪区', '1857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1860', '君山区', '1857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1861', '岳阳县', '1857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1862', '华容县', '1857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1863', '湘阴县', '1857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1864', '平江县', '1857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1865', '汨罗市', '1857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1866', '临湘市', '1857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1867', '常德市', '1804', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1868', '武陵区', '1867', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1869', '鼎城区', '1867', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1870', '安乡县', '1867', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1871', '汉寿县', '1867', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1872', '澧县', '1867', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1873', '临澧县', '1867', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1874', '桃源县', '1867', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1875', '石门县', '1867', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1876', '津市市', '1867', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1877', '张家界市', '1804', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1878', '永定区', '1877', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1879', '武陵源区', '1877', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1880', '慈利县', '1877', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1881', '桑植县', '1877', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1882', '益阳市', '1804', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1883', '资阳区', '1882', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1884', '赫山区', '1882', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1885', '南县', '1882', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1886', '桃江县', '1882', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1887', '安化县', '1882', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1888', '沅江市', '1882', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1889', '郴州市', '1804', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1890', '北湖区', '1889', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1891', '苏仙区', '1889', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1892', '桂阳县', '1889', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1893', '宜章县', '1889', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1894', '永兴县', '1889', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1895', '嘉禾县', '1889', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1896', '临武县', '1889', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1897', '汝城县', '1889', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1898', '桂东县', '1889', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1899', '安仁县', '1889', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1900', '资兴市', '1889', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1901', '永州市', '1804', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1902', '零陵区', '1901', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1903', '冷水滩区', '1901', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1904', '祁阳县', '1901', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1905', '东安县', '1901', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1906', '双牌县', '1901', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1907', '道县', '1901', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1908', '江永县', '1901', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1909', '宁远县', '1901', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1910', '蓝山县', '1901', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1911', '新田县', '1901', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1912', '江华瑶族自治县', '1901', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1913', '怀化市', '1804', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1914', '鹤城区', '1913', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1915', '中方县', '1913', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1916', '沅陵县', '1913', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1917', '辰溪县', '1913', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1918', '溆浦县', '1913', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1919', '会同县', '1913', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1920', '麻阳苗族自治县', '1913', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1921', '新晃侗族自治县', '1913', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1922', '芷江侗族自治县', '1913', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1923', '靖州苗族侗族自治县', '1913', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1924', '通道侗族自治县', '1913', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1925', '洪江市', '1913', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1926', '娄底市', '1804', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1927', '娄星区', '1926', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1928', '双峰县', '1926', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1929', '新化县', '1926', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1930', '冷水江市', '1926', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1931', '涟源市', '1926', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1932', '湘西土家族苗族自治州', '1804', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1933', '吉首市', '1932', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1934', '泸溪县', '1932', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1935', '凤凰县', '1932', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1936', '花垣县', '1932', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1937', '保靖县', '1932', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1938', '古丈县', '1932', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1939', '永顺县', '1932', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1940', '龙山县', '1932', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1941', '广东省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1942', '广州市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1943', '荔湾区', '1942', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1944', '越秀区', '1942', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1945', '海珠区', '1942', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1946', '天河区', '1942', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1947', '白云区', '1942', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1948', '黄埔区', '1942', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1949', '番禺区', '1942', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1950', '花都区', '1942', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1951', '南沙区', '1942', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1952', '从化区', '1942', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1953', '增城区', '1942', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1954', '韶关市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1955', '武江区', '1954', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1956', '浈江区', '1954', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1957', '曲江区', '1954', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1958', '始兴县', '1954', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1959', '仁化县', '1954', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1960', '翁源县', '1954', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1961', '乳源瑶族自治县', '1954', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1962', '新丰县', '1954', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1963', '乐昌市', '1954', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1964', '南雄市', '1954', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1965', '深圳市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1966', '罗湖区', '1965', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1967', '福田区', '1965', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1968', '南山区', '1965', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1969', '宝安区', '1965', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1970', '龙岗区', '1965', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1971', '盐田区', '1965', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1972', '珠海市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1973', '香洲区', '1972', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1974', '斗门区', '1972', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1975', '金湾区', '1972', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1976', '汕头市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1977', '龙湖区', '1976', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1978', '金平区', '1976', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1979', '濠江区', '1976', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1980', '潮阳区', '1976', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1981', '潮南区', '1976', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1982', '澄海区', '1976', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1983', '南澳县', '1976', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1984', '佛山市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1985', '禅城区', '1984', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1986', '南海区', '1984', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1987', '顺德区', '1984', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1988', '三水区', '1984', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1989', '高明区', '1984', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1990', '江门市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1991', '蓬江区', '1990', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1992', '江海区', '1990', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1993', '新会区', '1990', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1994', '台山市', '1990', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1995', '开平市', '1990', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1996', '鹤山市', '1990', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1997', '恩平市', '1990', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1998', '湛江市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('1999', '赤坎区', '1998', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2000', '霞山区', '1998', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2001', '坡头区', '1998', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2002', '麻章区', '1998', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2003', '遂溪县', '1998', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2004', '徐闻县', '1998', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2005', '廉江市', '1998', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2006', '雷州市', '1998', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2007', '吴川市', '1998', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2008', '茂名市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2009', '茂南区', '2008', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2010', '电白区', '2008', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2011', '高州市', '2008', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2012', '化州市', '2008', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2013', '信宜市', '2008', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2014', '肇庆市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2015', '端州区', '2014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2016', '鼎湖区', '2014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2017', '高要区', '2014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2018', '广宁县', '2014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2019', '怀集县', '2014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2020', '封开县', '2014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2021', '德庆县', '2014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2022', '四会市', '2014', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2023', '惠州市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2024', '惠城区', '2023', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2025', '惠阳区', '2023', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2026', '博罗县', '2023', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2027', '惠东县', '2023', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2028', '龙门县', '2023', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2029', '梅州市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2030', '梅江区', '2029', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2031', '梅县区', '2029', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2032', '大埔县', '2029', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2033', '丰顺县', '2029', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2034', '五华县', '2029', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2035', '平远县', '2029', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2036', '蕉岭县', '2029', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2037', '兴宁市', '2029', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2038', '汕尾市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2039', '城区', '2038', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2040', '海丰县', '2038', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2041', '陆河县', '2038', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2042', '陆丰市', '2038', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2043', '河源市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2044', '源城区', '2043', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2045', '紫金县', '2043', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2046', '龙川县', '2043', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2047', '连平县', '2043', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2048', '和平县', '2043', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2049', '东源县', '2043', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2050', '阳江市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2051', '江城区', '2050', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2052', '阳东区', '2050', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2053', '阳西县', '2050', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2054', '阳春市', '2050', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2055', '清远市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2056', '清城区', '2055', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2057', '清新区', '2055', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2058', '佛冈县', '2055', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2059', '阳山县', '2055', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2060', '连山壮族瑶族自治县', '2055', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2061', '连南瑶族自治县', '2055', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2062', '英德市', '2055', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2063', '连州市', '2055', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2064', '东莞市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2065', '中山市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2066', '潮州市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2067', '湘桥区', '2066', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2068', '潮安区', '2066', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2069', '饶平县', '2066', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2070', '揭阳市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2071', '榕城区', '2070', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2072', '揭东区', '2070', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2073', '揭西县', '2070', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2074', '惠来县', '2070', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2075', '普宁市', '2070', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2076', '云浮市', '1941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2077', '云城区', '2076', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2078', '云安区', '2076', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2079', '新兴县', '2076', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2080', '郁南县', '2076', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2081', '罗定市', '2076', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2082', '广西壮族自治区', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2083', '南宁市', '2082', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2084', '兴宁区', '2083', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2085', '青秀区', '2083', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2086', '江南区', '2083', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2087', '西乡塘区', '2083', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2088', '良庆区', '2083', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2089', '邕宁区', '2083', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2090', '武鸣区', '2083', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2091', '隆安县', '2083', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2092', '马山县', '2083', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2093', '上林县', '2083', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2094', '宾阳县', '2083', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2095', '横县', '2083', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2096', '柳州市', '2082', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2097', '城中区', '2096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2098', '鱼峰区', '2096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2099', '柳南区', '2096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2100', '柳北区', '2096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2101', '柳江区', '2096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2102', '柳城县', '2096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2103', '鹿寨县', '2096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2104', '融安县', '2096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2105', '融水苗族自治县', '2096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2106', '三江侗族自治县', '2096', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2107', '桂林市', '2082', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2108', '秀峰区', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2109', '叠彩区', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2110', '象山区', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2111', '七星区', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2112', '雁山区', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2113', '临桂区', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2114', '阳朔县', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2115', '灵川县', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2116', '全州县', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2117', '兴安县', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2118', '永福县', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2119', '灌阳县', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2120', '龙胜各族自治县', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2121', '资源县', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2122', '平乐县', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2123', '荔浦县', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2124', '恭城瑶族自治县', '2107', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2125', '梧州市', '2082', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2126', '万秀区', '2125', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2127', '长洲区', '2125', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2128', '龙圩区', '2125', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2129', '苍梧县', '2125', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2130', '藤县', '2125', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2131', '蒙山县', '2125', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2132', '岑溪市', '2125', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2133', '北海市', '2082', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2134', '海城区', '2133', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2135', '银海区', '2133', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2136', '铁山港区', '2133', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2137', '合浦县', '2133', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2138', '防城港市', '2082', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2139', '港口区', '2138', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2140', '防城区', '2138', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2141', '上思县', '2138', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2142', '东兴市', '2138', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2143', '钦州市', '2082', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2144', '钦南区', '2143', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2145', '钦北区', '2143', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2146', '灵山县', '2143', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2147', '浦北县', '2143', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2148', '贵港市', '2082', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2149', '港北区', '2148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2150', '港南区', '2148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2151', '覃塘区', '2148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2152', '平南县', '2148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2153', '桂平市', '2148', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2154', '玉林市', '2082', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2155', '玉州区', '2154', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2156', '福绵区', '2154', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2157', '容县', '2154', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2158', '陆川县', '2154', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2159', '博白县', '2154', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2160', '兴业县', '2154', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2161', '北流市', '2154', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2162', '百色市', '2082', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2163', '右江区', '2162', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2164', '田阳县', '2162', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2165', '田东县', '2162', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2166', '平果县', '2162', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2167', '德保县', '2162', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2168', '那坡县', '2162', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2169', '凌云县', '2162', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2170', '乐业县', '2162', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2171', '田林县', '2162', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2172', '西林县', '2162', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2173', '隆林各族自治县', '2162', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2174', '靖西市', '2162', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2175', '贺州市', '2082', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2176', '八步区', '2175', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2177', '平桂区', '2175', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2178', '昭平县', '2175', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2179', '钟山县', '2175', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2180', '富川瑶族自治县', '2175', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2181', '河池市', '2082', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2182', '金城江区', '2181', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2183', '南丹县', '2181', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2184', '天峨县', '2181', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2185', '凤山县', '2181', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2186', '东兰县', '2181', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2187', '罗城仫佬族自治县', '2181', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2188', '环江毛南族自治县', '2181', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2189', '巴马瑶族自治县', '2181', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2190', '都安瑶族自治县', '2181', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2191', '大化瑶族自治县', '2181', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2192', '宜州市', '2181', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2193', '来宾市', '2082', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2194', '兴宾区', '2193', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2195', '忻城县', '2193', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2196', '象州县', '2193', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2197', '武宣县', '2193', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2198', '金秀瑶族自治县', '2193', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2199', '合山市', '2193', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2200', '崇左市', '2082', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2201', '江州区', '2200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2202', '扶绥县', '2200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2203', '宁明县', '2200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2204', '龙州县', '2200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2205', '大新县', '2200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2206', '天等县', '2200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2207', '凭祥市', '2200', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2208', '海南省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2209', '海口市', '2208', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2210', '秀英区', '2209', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2211', '龙华区', '2209', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2212', '琼山区', '2209', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2213', '美兰区', '2209', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2214', '三亚市', '2208', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2215', '海棠区', '2214', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2216', '吉阳区', '2214', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2217', '天涯区', '2214', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2218', '崖州区', '2214', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2219', '三沙市', '2208', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2220', '儋州市', '2208', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2221', '省直辖县级行政区划', '2208', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2222', '五指山市', '2221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2223', '琼海市', '2221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2224', '文昌市', '2221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2225', '万宁市', '2221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2226', '东方市', '2221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2227', '定安县', '2221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2228', '屯昌县', '2221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2229', '澄迈县', '2221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2230', '临高县', '2221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2231', '白沙黎族自治县', '2221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2232', '昌江黎族自治县', '2221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2233', '乐东黎族自治县', '2221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2234', '陵水黎族自治县', '2221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2235', '保亭黎族苗族自治县', '2221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2236', '琼中黎族苗族自治县', '2221', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2237', '重庆市', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2238', '重庆市', '2237', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2239', '万州区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2240', '涪陵区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2241', '渝中区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2242', '大渡口区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2243', '江北区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2244', '沙坪坝区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2245', '九龙坡区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2246', '南岸区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2247', '北碚区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2248', '綦江区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2249', '大足区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2250', '渝北区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2251', '巴南区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2252', '黔江区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2253', '长寿区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2254', '江津区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2255', '合川区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2256', '永川区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2257', '南川区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2258', '璧山区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2259', '铜梁区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2260', '潼南区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2261', '荣昌区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2262', '开州区', '2238', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2263', '县', '2237', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2264', '梁平县', '2263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2265', '城口县', '2263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2266', '丰都县', '2263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2267', '垫江县', '2263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2268', '武隆县', '2263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2269', '忠县', '2263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2270', '云阳县', '2263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2271', '奉节县', '2263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2272', '巫山县', '2263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2273', '巫溪县', '2263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2274', '石柱土家族自治县', '2263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2275', '秀山土家族苗族自治县', '2263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2276', '酉阳土家族苗族自治县', '2263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2277', '彭水苗族土家族自治县', '2263', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2278', '四川省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2279', '成都市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2280', '锦江区', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2281', '青羊区', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2282', '金牛区', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2283', '武侯区', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2284', '成华区', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2285', '龙泉驿区', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2286', '青白江区', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2287', '新都区', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2288', '温江区', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2289', '双流区', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2290', '金堂县', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2291', '郫县', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2292', '大邑县', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2293', '蒲江县', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2294', '新津县', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2295', '都江堰市', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2296', '彭州市', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2297', '邛崃市', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2298', '崇州市', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2299', '简阳市', '2279', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2300', '自贡市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2301', '自流井区', '2300', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2302', '贡井区', '2300', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2303', '大安区', '2300', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2304', '沿滩区', '2300', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2305', '荣县', '2300', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2306', '富顺县', '2300', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2307', '攀枝花市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2308', '东区', '2307', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2309', '西区', '2307', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2310', '仁和区', '2307', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2311', '米易县', '2307', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2312', '盐边县', '2307', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2313', '泸州市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2314', '江阳区', '2313', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2315', '纳溪区', '2313', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2316', '龙马潭区', '2313', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2317', '泸县', '2313', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2318', '合江县', '2313', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2319', '叙永县', '2313', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2320', '古蔺县', '2313', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2321', '德阳市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2322', '旌阳区', '2321', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2323', '中江县', '2321', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2324', '罗江县', '2321', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2325', '广汉市', '2321', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2326', '什邡市', '2321', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2327', '绵竹市', '2321', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2328', '绵阳市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2329', '涪城区', '2328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2330', '游仙区', '2328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2331', '安州区', '2328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2332', '三台县', '2328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2333', '盐亭县', '2328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2334', '梓潼县', '2328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2335', '北川羌族自治县', '2328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2336', '平武县', '2328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2337', '江油市', '2328', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2338', '广元市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2339', '利州区', '2338', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2340', '昭化区', '2338', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2341', '朝天区', '2338', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2342', '旺苍县', '2338', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2343', '青川县', '2338', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2344', '剑阁县', '2338', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2345', '苍溪县', '2338', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2346', '遂宁市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2347', '船山区', '2346', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2348', '安居区', '2346', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2349', '蓬溪县', '2346', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2350', '射洪县', '2346', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2351', '大英县', '2346', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2352', '内江市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2353', '市中区', '2352', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2354', '东兴区', '2352', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2355', '威远县', '2352', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2356', '资中县', '2352', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2357', '隆昌县', '2352', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2358', '乐山市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2359', '市中区', '2358', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2360', '沙湾区', '2358', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2361', '五通桥区', '2358', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2362', '金口河区', '2358', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2363', '犍为县', '2358', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2364', '井研县', '2358', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2365', '夹江县', '2358', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2366', '沐川县', '2358', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2367', '峨边彝族自治县', '2358', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2368', '马边彝族自治县', '2358', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2369', '峨眉山市', '2358', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2370', '南充市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2371', '顺庆区', '2370', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2372', '高坪区', '2370', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2373', '嘉陵区', '2370', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2374', '南部县', '2370', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2375', '营山县', '2370', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2376', '蓬安县', '2370', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2377', '仪陇县', '2370', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2378', '西充县', '2370', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2379', '阆中市', '2370', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2380', '眉山市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2381', '东坡区', '2380', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2382', '彭山区', '2380', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2383', '仁寿县', '2380', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2384', '洪雅县', '2380', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2385', '丹棱县', '2380', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2386', '青神县', '2380', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2387', '宜宾市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2388', '翠屏区', '2387', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2389', '南溪区', '2387', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2390', '宜宾县', '2387', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2391', '江安县', '2387', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2392', '长宁县', '2387', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2393', '高县', '2387', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2394', '珙县', '2387', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2395', '筠连县', '2387', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2396', '兴文县', '2387', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2397', '屏山县', '2387', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2398', '广安市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2399', '广安区', '2398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2400', '前锋区', '2398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2401', '岳池县', '2398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2402', '武胜县', '2398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2403', '邻水县', '2398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2404', '华蓥市', '2398', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2405', '达州市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2406', '通川区', '2405', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2407', '达川区', '2405', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2408', '宣汉县', '2405', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2409', '开江县', '2405', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2410', '大竹县', '2405', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2411', '渠县', '2405', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2412', '万源市', '2405', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2413', '雅安市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2414', '雨城区', '2413', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2415', '名山区', '2413', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2416', '荥经县', '2413', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2417', '汉源县', '2413', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2418', '石棉县', '2413', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2419', '天全县', '2413', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2420', '芦山县', '2413', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2421', '宝兴县', '2413', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2422', '巴中市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2423', '巴州区', '2422', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2424', '恩阳区', '2422', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2425', '通江县', '2422', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2426', '南江县', '2422', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2427', '平昌县', '2422', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2428', '资阳市', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2429', '雁江区', '2428', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2430', '安岳县', '2428', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2431', '乐至县', '2428', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2432', '阿坝藏族羌族自治州', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2433', '马尔康市', '2432', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2434', '汶川县', '2432', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2435', '理县', '2432', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2436', '茂县', '2432', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2437', '松潘县', '2432', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2438', '九寨沟县', '2432', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2439', '金川县', '2432', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2440', '小金县', '2432', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2441', '黑水县', '2432', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2442', '壤塘县', '2432', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2443', '阿坝县', '2432', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2444', '若尔盖县', '2432', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2445', '红原县', '2432', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2446', '甘孜藏族自治州', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2447', '康定市', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2448', '泸定县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2449', '丹巴县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2450', '九龙县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2451', '雅江县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2452', '道孚县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2453', '炉霍县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2454', '甘孜县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2455', '新龙县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2456', '德格县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2457', '白玉县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2458', '石渠县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2459', '色达县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2460', '理塘县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2461', '巴塘县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2462', '乡城县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2463', '稻城县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2464', '得荣县', '2446', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2465', '凉山彝族自治州', '2278', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2466', '西昌市', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2467', '木里藏族自治县', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2468', '盐源县', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2469', '德昌县', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2470', '会理县', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2471', '会东县', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2472', '宁南县', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2473', '普格县', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2474', '布拖县', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2475', '金阳县', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2476', '昭觉县', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2477', '喜德县', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2478', '冕宁县', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2479', '越西县', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2480', '甘洛县', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2481', '美姑县', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2482', '雷波县', '2465', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2483', '贵州省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2484', '贵阳市', '2483', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2485', '南明区', '2484', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2486', '云岩区', '2484', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2487', '花溪区', '2484', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2488', '乌当区', '2484', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2489', '白云区', '2484', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2490', '观山湖区', '2484', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2491', '开阳县', '2484', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2492', '息烽县', '2484', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2493', '修文县', '2484', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2494', '清镇市', '2484', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2495', '六盘水市', '2483', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2496', '钟山区', '2495', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2497', '六枝特区', '2495', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2498', '水城县', '2495', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2499', '盘县', '2495', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2500', '遵义市', '2483', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2501', '红花岗区', '2500', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2502', '汇川区', '2500', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2503', '播州区', '2500', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2504', '桐梓县', '2500', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2505', '绥阳县', '2500', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2506', '正安县', '2500', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2507', '道真仡佬族苗族自治县', '2500', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2508', '务川仡佬族苗族自治县', '2500', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2509', '凤冈县', '2500', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2510', '湄潭县', '2500', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2511', '余庆县', '2500', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2512', '习水县', '2500', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2513', '赤水市', '2500', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2514', '仁怀市', '2500', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2515', '安顺市', '2483', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2516', '西秀区', '2515', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2517', '平坝区', '2515', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2518', '普定县', '2515', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2519', '镇宁布依族苗族自治县', '2515', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2520', '关岭布依族苗族自治县', '2515', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2521', '紫云苗族布依族自治县', '2515', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2522', '毕节市', '2483', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2523', '七星关区', '2522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2524', '大方县', '2522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2525', '黔西县', '2522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2526', '金沙县', '2522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2527', '织金县', '2522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2528', '纳雍县', '2522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2529', '威宁彝族回族苗族自治县', '2522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2530', '赫章县', '2522', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2531', '铜仁市', '2483', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2532', '碧江区', '2531', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2533', '万山区', '2531', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2534', '江口县', '2531', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2535', '玉屏侗族自治县', '2531', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2536', '石阡县', '2531', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2537', '思南县', '2531', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2538', '印江土家族苗族自治县', '2531', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2539', '德江县', '2531', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2540', '沿河土家族自治县', '2531', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2541', '松桃苗族自治县', '2531', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2542', '黔西南布依族苗族自治州', '2483', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2543', '兴义市', '2542', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2544', '兴仁县', '2542', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2545', '普安县', '2542', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2546', '晴隆县', '2542', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2547', '贞丰县', '2542', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2548', '望谟县', '2542', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2549', '册亨县', '2542', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2550', '安龙县', '2542', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2551', '黔东南苗族侗族自治州', '2483', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2552', '凯里市', '2551', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2553', '黄平县', '2551', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2554', '施秉县', '2551', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2555', '三穗县', '2551', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2556', '镇远县', '2551', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2557', '岑巩县', '2551', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2558', '天柱县', '2551', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2559', '锦屏县', '2551', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2560', '剑河县', '2551', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2561', '台江县', '2551', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2562', '黎平县', '2551', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2563', '榕江县', '2551', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2564', '从江县', '2551', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2565', '雷山县', '2551', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2566', '麻江县', '2551', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2567', '丹寨县', '2551', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2568', '黔南布依族苗族自治州', '2483', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2569', '都匀市', '2568', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2570', '福泉市', '2568', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2571', '荔波县', '2568', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2572', '贵定县', '2568', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2573', '瓮安县', '2568', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2574', '独山县', '2568', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2575', '平塘县', '2568', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2576', '罗甸县', '2568', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2577', '长顺县', '2568', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2578', '龙里县', '2568', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2579', '惠水县', '2568', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2580', '三都水族自治县', '2568', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2581', '云南省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2582', '昆明市', '2581', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2583', '五华区', '2582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2584', '盘龙区', '2582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2585', '官渡区', '2582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2586', '西山区', '2582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2587', '东川区', '2582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2588', '呈贡区', '2582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2589', '晋宁县', '2582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2590', '富民县', '2582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2591', '宜良县', '2582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2592', '石林彝族自治县', '2582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2593', '嵩明县', '2582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2594', '禄劝彝族苗族自治县', '2582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2595', '寻甸回族彝族自治县', '2582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2596', '安宁市', '2582', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2597', '曲靖市', '2581', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2598', '麒麟区', '2597', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2599', '沾益区', '2597', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2600', '马龙县', '2597', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2601', '陆良县', '2597', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2602', '师宗县', '2597', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2603', '罗平县', '2597', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2604', '富源县', '2597', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2605', '会泽县', '2597', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2606', '宣威市', '2597', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2607', '玉溪市', '2581', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2608', '红塔区', '2607', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2609', '江川区', '2607', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2610', '澄江县', '2607', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2611', '通海县', '2607', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2612', '华宁县', '2607', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2613', '易门县', '2607', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2614', '峨山彝族自治县', '2607', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2615', '新平彝族傣族自治县', '2607', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2616', '元江哈尼族彝族傣族自治县', '2607', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2617', '保山市', '2581', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2618', '隆阳区', '2617', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2619', '施甸县', '2617', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2620', '龙陵县', '2617', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2621', '昌宁县', '2617', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2622', '腾冲市', '2617', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2623', '昭通市', '2581', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2624', '昭阳区', '2623', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2625', '鲁甸县', '2623', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2626', '巧家县', '2623', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2627', '盐津县', '2623', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2628', '大关县', '2623', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2629', '永善县', '2623', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2630', '绥江县', '2623', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2631', '镇雄县', '2623', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2632', '彝良县', '2623', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2633', '威信县', '2623', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2634', '水富县', '2623', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2635', '丽江市', '2581', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2636', '古城区', '2635', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2637', '玉龙纳西族自治县', '2635', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2638', '永胜县', '2635', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2639', '华坪县', '2635', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2640', '宁蒗彝族自治县', '2635', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2641', '普洱市', '2581', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2642', '思茅区', '2641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2643', '宁洱哈尼族彝族自治县', '2641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2644', '墨江哈尼族自治县', '2641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2645', '景东彝族自治县', '2641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2646', '景谷傣族彝族自治县', '2641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2647', '镇沅彝族哈尼族拉祜族自治县', '2641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2648', '江城哈尼族彝族自治县', '2641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2649', '孟连傣族拉祜族佤族自治县', '2641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2650', '澜沧拉祜族自治县', '2641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2651', '西盟佤族自治县', '2641', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2652', '临沧市', '2581', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2653', '临翔区', '2652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2654', '凤庆县', '2652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2655', '云县', '2652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2656', '永德县', '2652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2657', '镇康县', '2652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2658', '双江拉祜族佤族布朗族傣族自治县', '2652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2659', '耿马傣族佤族自治县', '2652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2660', '沧源佤族自治县', '2652', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2661', '楚雄彝族自治州', '2581', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2662', '楚雄市', '2661', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2663', '双柏县', '2661', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2664', '牟定县', '2661', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2665', '南华县', '2661', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2666', '姚安县', '2661', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2667', '大姚县', '2661', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2668', '永仁县', '2661', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2669', '元谋县', '2661', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2670', '武定县', '2661', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2671', '禄丰县', '2661', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2672', '红河哈尼族彝族自治州', '2581', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2673', '个旧市', '2672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2674', '开远市', '2672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2675', '蒙自市', '2672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2676', '弥勒市', '2672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2677', '屏边苗族自治县', '2672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2678', '建水县', '2672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2679', '石屏县', '2672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2680', '泸西县', '2672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2681', '元阳县', '2672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2682', '红河县', '2672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2683', '金平苗族瑶族傣族自治县', '2672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2684', '绿春县', '2672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2685', '河口瑶族自治县', '2672', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2686', '文山壮族苗族自治州', '2581', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2687', '文山市', '2686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2688', '砚山县', '2686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2689', '西畴县', '2686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2690', '麻栗坡县', '2686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2691', '马关县', '2686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2692', '丘北县', '2686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2693', '广南县', '2686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2694', '富宁县', '2686', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2695', '西双版纳傣族自治州', '2581', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2696', '景洪市', '2695', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2697', '勐海县', '2695', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2698', '勐腊县', '2695', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2699', '大理白族自治州', '2581', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2700', '大理市', '2699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2701', '漾濞彝族自治县', '2699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2702', '祥云县', '2699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2703', '宾川县', '2699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2704', '弥渡县', '2699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2705', '南涧彝族自治县', '2699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2706', '巍山彝族回族自治县', '2699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2707', '永平县', '2699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2708', '云龙县', '2699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2709', '洱源县', '2699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2710', '剑川县', '2699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2711', '鹤庆县', '2699', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2712', '德宏傣族景颇族自治州', '2581', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2713', '瑞丽市', '2712', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2714', '芒市', '2712', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2715', '梁河县', '2712', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2716', '盈江县', '2712', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2717', '陇川县', '2712', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2718', '怒江傈僳族自治州', '2581', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2719', '泸水市', '2718', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2720', '福贡县', '2718', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2721', '贡山独龙族怒族自治县', '2718', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2722', '兰坪白族普米族自治县', '2718', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2723', '迪庆藏族自治州', '2581', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2724', '香格里拉市', '2723', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2725', '德钦县', '2723', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2726', '维西傈僳族自治县', '2723', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2727', '西藏自治区', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2728', '拉萨市', '2727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2729', '城关区', '2728', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2730', '堆龙德庆区', '2728', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2731', '林周县', '2728', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2732', '当雄县', '2728', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2733', '尼木县', '2728', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2734', '曲水县', '2728', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2735', '达孜县', '2728', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2736', '墨竹工卡县', '2728', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2737', '日喀则市', '2727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2738', '桑珠孜区', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2739', '南木林县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2740', '江孜县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2741', '定日县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2742', '萨迦县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2743', '拉孜县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2744', '昂仁县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2745', '谢通门县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2746', '白朗县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2747', '仁布县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2748', '康马县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2749', '定结县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2750', '仲巴县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2751', '亚东县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2752', '吉隆县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2753', '聂拉木县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2754', '萨嘎县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2755', '岗巴县', '2737', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2756', '昌都市', '2727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2757', '卡若区', '2756', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2758', '江达县', '2756', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2759', '贡觉县', '2756', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2760', '类乌齐县', '2756', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2761', '丁青县', '2756', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2762', '察雅县', '2756', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2763', '八宿县', '2756', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2764', '左贡县', '2756', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2765', '芒康县', '2756', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2766', '洛隆县', '2756', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2767', '边坝县', '2756', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2768', '林芝市', '2727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2769', '巴宜区', '2768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2770', '工布江达县', '2768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2771', '米林县', '2768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2772', '墨脱县', '2768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2773', '波密县', '2768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2774', '察隅县', '2768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2775', '朗县', '2768', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2776', '山南市', '2727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2777', '乃东区', '2776', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2778', '扎囊县', '2776', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2779', '贡嘎县', '2776', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2780', '桑日县', '2776', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2781', '琼结县', '2776', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2782', '曲松县', '2776', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2783', '措美县', '2776', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2784', '洛扎县', '2776', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2785', '加查县', '2776', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2786', '隆子县', '2776', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2787', '错那县', '2776', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2788', '浪卡子县', '2776', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2789', '那曲地区', '2727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2790', '那曲县', '2789', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2791', '嘉黎县', '2789', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2792', '比如县', '2789', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2793', '聂荣县', '2789', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2794', '安多县', '2789', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2795', '申扎县', '2789', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2796', '索县', '2789', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2797', '班戈县', '2789', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2798', '巴青县', '2789', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2799', '尼玛县', '2789', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2800', '双湖县', '2789', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2801', '阿里地区', '2727', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2802', '普兰县', '2801', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2803', '札达县', '2801', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2804', '噶尔县', '2801', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2805', '日土县', '2801', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2806', '革吉县', '2801', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2807', '改则县', '2801', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2808', '措勤县', '2801', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2809', '陕西省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2810', '西安市', '2809', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2811', '新城区', '2810', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2812', '碑林区', '2810', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2813', '莲湖区', '2810', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2814', '灞桥区', '2810', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2815', '未央区', '2810', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2816', '雁塔区', '2810', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2817', '阎良区', '2810', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2818', '临潼区', '2810', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2819', '长安区', '2810', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2820', '高陵区', '2810', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2821', '蓝田县', '2810', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2822', '周至县', '2810', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2823', '户县', '2810', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2824', '铜川市', '2809', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2825', '王益区', '2824', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2826', '印台区', '2824', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2827', '耀州区', '2824', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2828', '宜君县', '2824', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2829', '宝鸡市', '2809', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2830', '渭滨区', '2829', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2831', '金台区', '2829', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2832', '陈仓区', '2829', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2833', '凤翔县', '2829', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2834', '岐山县', '2829', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2835', '扶风县', '2829', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2836', '眉县', '2829', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2837', '陇县', '2829', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2838', '千阳县', '2829', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2839', '麟游县', '2829', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2840', '凤县', '2829', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2841', '太白县', '2829', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2842', '咸阳市', '2809', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2843', '秦都区', '2842', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2844', '杨陵区', '2842', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2845', '渭城区', '2842', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2846', '三原县', '2842', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2847', '泾阳县', '2842', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2848', '乾县', '2842', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2849', '礼泉县', '2842', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2850', '永寿县', '2842', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2851', '彬县', '2842', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2852', '长武县', '2842', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2853', '旬邑县', '2842', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2854', '淳化县', '2842', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2855', '武功县', '2842', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2856', '兴平市', '2842', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2857', '渭南市', '2809', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2858', '临渭区', '2857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2859', '华州区', '2857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2860', '潼关县', '2857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2861', '大荔县', '2857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2862', '合阳县', '2857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2863', '澄城县', '2857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2864', '蒲城县', '2857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2865', '白水县', '2857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2866', '富平县', '2857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2867', '韩城市', '2857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2868', '华阴市', '2857', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2869', '延安市', '2809', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2870', '宝塔区', '2869', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2871', '安塞区', '2869', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2872', '延长县', '2869', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2873', '延川县', '2869', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2874', '子长县', '2869', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2875', '志丹县', '2869', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2876', '吴起县', '2869', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2877', '甘泉县', '2869', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2878', '富县', '2869', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2879', '洛川县', '2869', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2880', '宜川县', '2869', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2881', '黄龙县', '2869', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2882', '黄陵县', '2869', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2883', '汉中市', '2809', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2884', '汉台区', '2883', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2885', '南郑县', '2883', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2886', '城固县', '2883', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2887', '洋县', '2883', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2888', '西乡县', '2883', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2889', '勉县', '2883', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2890', '宁强县', '2883', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2891', '略阳县', '2883', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2892', '镇巴县', '2883', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2893', '留坝县', '2883', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2894', '佛坪县', '2883', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2895', '榆林市', '2809', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2896', '榆阳区', '2895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2897', '横山区', '2895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2898', '神木县', '2895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2899', '府谷县', '2895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2900', '靖边县', '2895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2901', '定边县', '2895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2902', '绥德县', '2895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2903', '米脂县', '2895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2904', '佳县', '2895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2905', '吴堡县', '2895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2906', '清涧县', '2895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2907', '子洲县', '2895', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2908', '安康市', '2809', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2909', '汉滨区', '2908', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2910', '汉阴县', '2908', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2911', '石泉县', '2908', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2912', '宁陕县', '2908', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2913', '紫阳县', '2908', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2914', '岚皋县', '2908', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2915', '平利县', '2908', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2916', '镇坪县', '2908', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2917', '旬阳县', '2908', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2918', '白河县', '2908', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2919', '商洛市', '2809', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2920', '商州区', '2919', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2921', '洛南县', '2919', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2922', '丹凤县', '2919', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2923', '商南县', '2919', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2924', '山阳县', '2919', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2925', '镇安县', '2919', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2926', '柞水县', '2919', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2927', '甘肃省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2928', '兰州市', '2927', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2929', '城关区', '2928', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2930', '七里河区', '2928', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2931', '西固区', '2928', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2932', '安宁区', '2928', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2933', '红古区', '2928', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2934', '永登县', '2928', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2935', '皋兰县', '2928', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2936', '榆中县', '2928', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2937', '嘉峪关市', '2927', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2938', '金昌市', '2927', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2939', '金川区', '2938', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2940', '永昌县', '2938', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2941', '白银市', '2927', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2942', '白银区', '2941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2943', '平川区', '2941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2944', '靖远县', '2941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2945', '会宁县', '2941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2946', '景泰县', '2941', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2947', '天水市', '2927', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2948', '秦州区', '2947', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2949', '麦积区', '2947', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2950', '清水县', '2947', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2951', '秦安县', '2947', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2952', '甘谷县', '2947', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2953', '武山县', '2947', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2954', '张家川回族自治县', '2947', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2955', '武威市', '2927', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2956', '凉州区', '2955', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2957', '民勤县', '2955', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2958', '古浪县', '2955', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2959', '天祝藏族自治县', '2955', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2960', '张掖市', '2927', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2961', '甘州区', '2960', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2962', '肃南裕固族自治县', '2960', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2963', '民乐县', '2960', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2964', '临泽县', '2960', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2965', '高台县', '2960', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2966', '山丹县', '2960', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2967', '平凉市', '2927', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2968', '崆峒区', '2967', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2969', '泾川县', '2967', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2970', '灵台县', '2967', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2971', '崇信县', '2967', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2972', '华亭县', '2967', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2973', '庄浪县', '2967', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2974', '静宁县', '2967', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2975', '酒泉市', '2927', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2976', '肃州区', '2975', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2977', '金塔县', '2975', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2978', '瓜州县', '2975', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2979', '肃北蒙古族自治县', '2975', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2980', '阿克塞哈萨克族自治县', '2975', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2981', '玉门市', '2975', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2982', '敦煌市', '2975', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2983', '庆阳市', '2927', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2984', '西峰区', '2983', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2985', '庆城县', '2983', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2986', '环县', '2983', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2987', '华池县', '2983', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2988', '合水县', '2983', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2989', '正宁县', '2983', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2990', '宁县', '2983', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2991', '镇原县', '2983', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2992', '定西市', '2927', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2993', '安定区', '2992', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2994', '通渭县', '2992', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2995', '陇西县', '2992', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2996', '渭源县', '2992', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2997', '临洮县', '2992', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2998', '漳县', '2992', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('2999', '岷县', '2992', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3000', '陇南市', '2927', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3001', '武都区', '3000', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3002', '成县', '3000', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3003', '文县', '3000', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3004', '宕昌县', '3000', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3005', '康县', '3000', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3006', '西和县', '3000', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3007', '礼县', '3000', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3008', '徽县', '3000', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3009', '两当县', '3000', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3010', '临夏回族自治州', '2927', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3011', '临夏市', '3010', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3012', '临夏县', '3010', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3013', '康乐县', '3010', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3014', '永靖县', '3010', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3015', '广河县', '3010', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3016', '和政县', '3010', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3017', '东乡族自治县', '3010', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3018', '积石山保安族东乡族撒拉族自治县', '3010', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3019', '甘南藏族自治州', '2927', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3020', '合作市', '3019', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3021', '临潭县', '3019', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3022', '卓尼县', '3019', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3023', '舟曲县', '3019', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3024', '迭部县', '3019', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3025', '玛曲县', '3019', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3026', '碌曲县', '3019', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3027', '夏河县', '3019', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3028', '青海省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3029', '西宁市', '3028', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3030', '城东区', '3029', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3031', '城中区', '3029', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3032', '城西区', '3029', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3033', '城北区', '3029', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3034', '大通回族土族自治县', '3029', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3035', '湟中县', '3029', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3036', '湟源县', '3029', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3037', '海东市', '3028', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3038', '乐都区', '3037', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3039', '平安区', '3037', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3040', '民和回族土族自治县', '3037', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3041', '互助土族自治县', '3037', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3042', '化隆回族自治县', '3037', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3043', '循化撒拉族自治县', '3037', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3044', '海北藏族自治州', '3028', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3045', '门源回族自治县', '3044', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3046', '祁连县', '3044', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3047', '海晏县', '3044', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3048', '刚察县', '3044', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3049', '黄南藏族自治州', '3028', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3050', '同仁县', '3049', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3051', '尖扎县', '3049', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3052', '泽库县', '3049', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3053', '河南蒙古族自治县', '3049', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3054', '海南藏族自治州', '3028', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3055', '共和县', '3054', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3056', '同德县', '3054', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3057', '贵德县', '3054', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3058', '兴海县', '3054', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3059', '贵南县', '3054', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3060', '果洛藏族自治州', '3028', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3061', '玛沁县', '3060', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3062', '班玛县', '3060', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3063', '甘德县', '3060', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3064', '达日县', '3060', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3065', '久治县', '3060', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3066', '玛多县', '3060', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3067', '玉树藏族自治州', '3028', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3068', '玉树市', '3067', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3069', '杂多县', '3067', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3070', '称多县', '3067', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3071', '治多县', '3067', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3072', '囊谦县', '3067', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3073', '曲麻莱县', '3067', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3074', '海西蒙古族藏族自治州', '3028', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3075', '格尔木市', '3074', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3076', '德令哈市', '3074', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3077', '乌兰县', '3074', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3078', '都兰县', '3074', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3079', '天峻县', '3074', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3080', '宁夏回族自治区', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3081', '银川市', '3080', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3082', '兴庆区', '3081', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3083', '西夏区', '3081', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3084', '金凤区', '3081', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3085', '永宁县', '3081', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3086', '贺兰县', '3081', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3087', '灵武市', '3081', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3088', '石嘴山市', '3080', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3089', '大武口区', '3088', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3090', '惠农区', '3088', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3091', '平罗县', '3088', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3092', '吴忠市', '3080', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3093', '利通区', '3092', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3094', '红寺堡区', '3092', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3095', '盐池县', '3092', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3096', '同心县', '3092', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3097', '青铜峡市', '3092', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3098', '固原市', '3080', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3099', '原州区', '3098', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3100', '西吉县', '3098', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3101', '隆德县', '3098', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3102', '泾源县', '3098', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3103', '彭阳县', '3098', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3104', '中卫市', '3080', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3105', '沙坡头区', '3104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3106', '中宁县', '3104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3107', '海原县', '3104', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3108', '新疆维吾尔自治区', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3109', '乌鲁木齐市', '3108', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3110', '天山区', '3109', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3111', '沙依巴克区', '3109', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3112', '新市区', '3109', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3113', '水磨沟区', '3109', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3114', '头屯河区', '3109', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3115', '达坂城区', '3109', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3116', '米东区', '3109', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3117', '乌鲁木齐县', '3109', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3118', '克拉玛依市', '3108', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3119', '独山子区', '3118', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3120', '克拉玛依区', '3118', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3121', '白碱滩区', '3118', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3122', '乌尔禾区', '3118', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3123', '吐鲁番市', '3108', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3124', '高昌区', '3123', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3125', '鄯善县', '3123', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3126', '托克逊县', '3123', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3127', '哈密市', '3108', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3128', '伊州区', '3127', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3129', '巴里坤哈萨克自治县', '3127', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3130', '伊吾县', '3127', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3131', '昌吉回族自治州', '3108', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3132', '昌吉市', '3131', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3133', '阜康市', '3131', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3134', '呼图壁县', '3131', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3135', '玛纳斯县', '3131', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3136', '奇台县', '3131', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3137', '吉木萨尔县', '3131', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3138', '木垒哈萨克自治县', '3131', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3139', '博尔塔拉蒙古自治州', '3108', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3140', '博乐市', '3139', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3141', '阿拉山口市', '3139', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3142', '精河县', '3139', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3143', '温泉县', '3139', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3144', '巴音郭楞蒙古自治州', '3108', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3145', '库尔勒市', '3144', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3146', '轮台县', '3144', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3147', '尉犁县', '3144', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3148', '若羌县', '3144', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3149', '且末县', '3144', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3150', '焉耆回族自治县', '3144', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3151', '和静县', '3144', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3152', '和硕县', '3144', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3153', '博湖县', '3144', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3154', '阿克苏地区', '3108', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3155', '阿克苏市', '3154', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3156', '温宿县', '3154', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3157', '库车县', '3154', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3158', '沙雅县', '3154', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3159', '新和县', '3154', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3160', '拜城县', '3154', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3161', '乌什县', '3154', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3162', '阿瓦提县', '3154', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3163', '柯坪县', '3154', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3164', '克孜勒苏柯尔克孜自治州', '3108', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3165', '阿图什市', '3164', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3166', '阿克陶县', '3164', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3167', '阿合奇县', '3164', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3168', '乌恰县', '3164', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3169', '喀什地区', '3108', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3170', '喀什市', '3169', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3171', '疏附县', '3169', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3172', '疏勒县', '3169', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3173', '英吉沙县', '3169', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3174', '泽普县', '3169', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3175', '莎车县', '3169', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3176', '叶城县', '3169', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3177', '麦盖提县', '3169', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3178', '岳普湖县', '3169', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3179', '伽师县', '3169', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3180', '巴楚县', '3169', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3181', '塔什库尔干塔吉克自治县', '3169', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3182', '和田地区', '3108', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3183', '和田市', '3182', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3184', '和田县', '3182', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3185', '墨玉县', '3182', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3186', '皮山县', '3182', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3187', '洛浦县', '3182', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3188', '策勒县', '3182', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3189', '于田县', '3182', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3190', '民丰县', '3182', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3191', '伊犁哈萨克自治州', '3108', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3192', '伊宁市', '3191', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3193', '奎屯市', '3191', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3194', '霍尔果斯市', '3191', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3195', '伊宁县', '3191', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3196', '察布查尔锡伯自治县', '3191', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3197', '霍城县', '3191', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3198', '巩留县', '3191', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3199', '新源县', '3191', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3200', '昭苏县', '3191', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3201', '特克斯县', '3191', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3202', '尼勒克县', '3191', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3203', '塔城地区', '3108', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3204', '塔城市', '3203', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3205', '乌苏市', '3203', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3206', '额敏县', '3203', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3207', '沙湾县', '3203', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3208', '托里县', '3203', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3209', '裕民县', '3203', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3210', '和布克赛尔蒙古自治县', '3203', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3211', '阿勒泰地区', '3108', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3212', '阿勒泰市', '3211', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3213', '布尔津县', '3211', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3214', '富蕴县', '3211', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3215', '福海县', '3211', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3216', '哈巴河县', '3211', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3217', '青河县', '3211', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3218', '吉木乃县', '3211', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3219', '自治区直辖县级行政区划', '3108', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3220', '石河子市', '3219', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3221', '阿拉尔市', '3219', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3222', '图木舒克市', '3219', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3223', '五家渠市', '3219', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3224', '铁门关市', '3219', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3225', '台湾省', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3226', '香港特别行政区', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3227', '澳门特别行政区', '1', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3228', '东城街道', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3229', '南城街道', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3230', '万江街道', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3231', '莞城街道', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3232', '石碣镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3233', '石龙镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3234', '茶山镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3235', '石排镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3236', '企石镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3237', '横沥镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3238', '桥头镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3239', '谢岗镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3240', '东坑镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3241', '常平镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3242', '寮步镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3243', '樟木头镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3244', '大朗镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3245', '黄江镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3246', '清溪镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3247', '塘厦镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3248', '凤岗镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3249', '大岭山镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3250', '长安镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3251', '虎门镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3252', '厚街镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3253', '沙田镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3254', '道滘镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3255', '洪梅镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3256', '麻涌镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3257', '望牛墩镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3258', '中堂镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3259', '高埗镇', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3260', '松山湖管委会', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3261', '虎门港管委会', '2064', '255', '0', '1', '0', '0', '0');
INSERT INTO `wja_region` VALUES ('3262', '东莞生态园', '2064', '255', '0', '1', '0', '0', '0');

-- ----------------------------
-- Table structure for wja_store
-- ----------------------------
DROP TABLE IF EXISTS `wja_store`;
CREATE TABLE `wja_store` (
  `store_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '商户ID',
  `factory_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '所属厂商ID',
  `store_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '商户类型(1厂商 2渠道商 3零售商/零售商 4服务商)',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '商户名称',
  `logo` varchar(255) NOT NULL DEFAULT '' COMMENT '厂商LOGO地址',
  `user_name` varchar(255) NOT NULL DEFAULT '' COMMENT '联系人姓名',
  `mobile` varchar(255) NOT NULL DEFAULT '' COMMENT '联系电话',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '商户地址',
  `sort_order` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '排序',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(1为正常0为下架)',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `config_json` text NOT NULL COMMENT 'json格式配置信息',
  `idcard_font_img` varchar(255) NOT NULL DEFAULT '' COMMENT '法人身份证正面',
  `idcard_back_img` varchar(255) NOT NULL DEFAULT '' COMMENT '法人身份证背面',
  `license_img` varchar(255) NOT NULL DEFAULT '' COMMENT '营业执照',
  `signing_contract_img` varchar(255) NOT NULL DEFAULT '' COMMENT '签约合同图片',
  `security_money` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '保证金金额',
  PRIMARY KEY (`store_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_store
-- ----------------------------
INSERT INTO `wja_store` VALUES ('1', '0', '1', '万佳安', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181127110724_basicprofile.jpg', '', '', '', '1', '1', '1543287954', '1544519705', '0', '{\"order_cancel_minute\":\"1\",\"order_return_day\":\"2\",\"channel_commission_ratio\":\"10\",\"installer_return_ratio\":\"0\",\"workorder_auto_assess_day\":\"3\",\"monthly_withdraw_start_date\":\"6\",\"monthly_withdraw_end_date\":\"15\",\"consumer_hotline\":\"400-2569-5252\",\"installer_check\":\"0\"}', '', '', '', '', '0.00');
INSERT INTO `wja_store` VALUES ('2', '0', '1', '测试厂商', 'http://pimvhcf3v.bkt.clouddn.com/store_logo_20181127181255_logo1.jpg', '', '', '', '1', '1', '1543288024', '1543313576', '0', '', '', '', '', '', '0.00');
INSERT INTO `wja_store` VALUES ('3', '1', '2', '万佳安渠道', '', '111', '222', '', '1', '1', '1543302062', '1544521685', '0', '', '', '', '', '', '0.00');
INSERT INTO `wja_store` VALUES ('4', '1', '3', '万佳安零售商', '', '', '', '', '1', '1', '1543302246', '1543562065', '0', '', '', '', '', '', '0.00');
INSERT INTO `wja_store` VALUES ('5', '1', '4', '测试服务商', '', 'AAA', '023-56874582', '', '1', '1', '1543302262', '1544521796', '0', '', '', '', '', '', '100.00');
INSERT INTO `wja_store` VALUES ('6', '1', '3', '测试零售1', '', '测试', '13452147854', '', '1', '1', '1544092565', '1544092565', '0', '', '', '', '', '', '0.00');

-- ----------------------------
-- Table structure for wja_store_bank
-- ----------------------------
DROP TABLE IF EXISTS `wja_store_bank`;
CREATE TABLE `wja_store_bank` (
  `bank_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bank_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '账号类型(1银行卡 2微信 3支付宝 )',
  `id_card` varchar(255) NOT NULL DEFAULT '' COMMENT '持卡人身份证号',
  `realname` varchar(50) NOT NULL DEFAULT '' COMMENT '银行卡持卡人姓名',
  `bank_name` varchar(255) NOT NULL DEFAULT '' COMMENT '开户行名称(如工商银行等)',
  `bank_branch` varchar(255) NOT NULL DEFAULT '' COMMENT '开户行支行名称',
  `bank_no` varchar(255) NOT NULL DEFAULT '' COMMENT '银行卡号',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商户ID',
  `post_user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '提交用户id',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配置信息添加时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `sort_order` int(1) unsigned NOT NULL DEFAULT '1',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否启用',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`bank_id`),
  KEY `bank_type` (`bank_type`),
  KEY `store_id` (`store_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='商户提现账户数据表';

-- ----------------------------
-- Records of wja_store_bank
-- ----------------------------
INSERT INTO `wja_store_bank` VALUES ('1', '1', '111222198906125469', '小明', '工商银行', '广东省深圳市南山支行', '6222 9800 1357 6125', '3', '4', '1544234228', '1544234256', '1', '1', '0');
INSERT INTO `wja_store_bank` VALUES ('2', '1', '22', '11', '33', '44', '55', '5', '9', '1544509186', '1544509186', '1', '1', '0');

-- ----------------------------
-- Table structure for wja_store_channel
-- ----------------------------
DROP TABLE IF EXISTS `wja_store_channel`;
CREATE TABLE `wja_store_channel` (
  `store_id` int(10) unsigned NOT NULL COMMENT '商户ID',
  `cgrade_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '渠道等级',
  `region_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '渠道负责区域ID',
  `region_name` varchar(255) NOT NULL DEFAULT '' COMMENT '渠道负责区域地址',
  PRIMARY KEY (`store_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='渠道商数据表';

-- ----------------------------
-- Records of wja_store_channel
-- ----------------------------
INSERT INTO `wja_store_channel` VALUES ('3', '0', '1717', '湖北省 宜昌市');

-- ----------------------------
-- Table structure for wja_store_commission
-- ----------------------------
DROP TABLE IF EXISTS `wja_store_commission`;
CREATE TABLE `wja_store_commission` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商户ID(收到佣金的商户ID)',
  `from_store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '佣金来源商户ID',
  `order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单ID',
  `order_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '订单编号',
  `osku_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单商品表ID',
  `goods_id` int(10) unsigned NOT NULL DEFAULT '0',
  `sku_id` int(10) unsigned NOT NULL DEFAULT '0',
  `order_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '订单金额',
  `commission_ratio` decimal(5,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '返佣比例(百分比)',
  `income_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '收益金额(返佣金额)',
  `commission_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '收益状态(0待结算 1已结算 2已退还)',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '交易时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '到账时间',
  `sort_order` int(1) unsigned NOT NULL DEFAULT '1',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(0禁用 1启用)',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`log_id`),
  KEY `store_id` (`store_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='返佣明细表';

-- ----------------------------
-- Records of wja_store_commission
-- ----------------------------

-- ----------------------------
-- Table structure for wja_store_dealer
-- ----------------------------
DROP TABLE IF EXISTS `wja_store_dealer`;
CREATE TABLE `wja_store_dealer` (
  `store_id` int(10) unsigned NOT NULL COMMENT '商户ID',
  `ostore_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '渠道商/零售商ID',
  PRIMARY KEY (`store_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='零售商/零售商数据表';

-- ----------------------------
-- Records of wja_store_dealer
-- ----------------------------
INSERT INTO `wja_store_dealer` VALUES ('4', '3');
INSERT INTO `wja_store_dealer` VALUES ('6', '3');

-- ----------------------------
-- Table structure for wja_store_factory
-- ----------------------------
DROP TABLE IF EXISTS `wja_store_factory`;
CREATE TABLE `wja_store_factory` (
  `store_id` int(10) unsigned NOT NULL COMMENT '商户ID',
  `domain` varchar(50) NOT NULL DEFAULT '' COMMENT '厂商二级域名',
  PRIMARY KEY (`store_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='厂商数据表';

-- ----------------------------
-- Records of wja_store_factory
-- ----------------------------
INSERT INTO `wja_store_factory` VALUES ('1', 'dev');
INSERT INTO `wja_store_factory` VALUES ('2', 'ceshi');

-- ----------------------------
-- Table structure for wja_store_finance
-- ----------------------------
DROP TABLE IF EXISTS `wja_store_finance`;
CREATE TABLE `wja_store_finance` (
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商户ID',
  `amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '账户当前可提现金额',
  `withdraw_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '已提现金额',
  `pending_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '待结算金额',
  `total_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '总收益',
  PRIMARY KEY (`store_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='商户账户数据';

-- ----------------------------
-- Records of wja_store_finance
-- ----------------------------
INSERT INTO `wja_store_finance` VALUES ('1', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('2', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('3', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('4', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('5', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('6', '0.00', '0.00', '0.00', '0.00');

-- ----------------------------
-- Table structure for wja_store_servicer
-- ----------------------------
DROP TABLE IF EXISTS `wja_store_servicer`;
CREATE TABLE `wja_store_servicer` (
  `store_id` int(10) unsigned NOT NULL COMMENT '商户ID',
  `region_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '渠道负责区域ID',
  `region_name` varchar(255) NOT NULL DEFAULT '' COMMENT '渠道负责区域地址',
  PRIMARY KEY (`store_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='服务商数据表';

-- ----------------------------
-- Records of wja_store_servicer
-- ----------------------------
INSERT INTO `wja_store_servicer` VALUES ('5', '1662', '河南省 周口市');

-- ----------------------------
-- Table structure for wja_store_service_income
-- ----------------------------
DROP TABLE IF EXISTS `wja_store_service_income`;
CREATE TABLE `wja_store_service_income` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商户ID(收到安装费的商户ID)',
  `worder_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '工单ID',
  `worder_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '工单编号',
  `installer_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '安装工程师',
  `order_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '安装工单对应订单号',
  `osku_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单商品表ID',
  `goods_id` int(10) unsigned NOT NULL DEFAULT '0',
  `sku_id` int(10) unsigned NOT NULL DEFAULT '0',
  `install_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '预安装费',
  `assess_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '关联评论ID',
  `score` decimal(5,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '评价得分',
  `income_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '收益金额(实际得到安装费金额)',
  `income_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '收益状态(0待结算 1已结算 2已退还)',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '交易时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '到账时间',
  `sort_order` int(1) unsigned NOT NULL DEFAULT '1',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(0禁用 1启用)',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`log_id`),
  KEY `store_id` (`store_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='服务商安装费数据表';

-- ----------------------------
-- Records of wja_store_service_income
-- ----------------------------

-- ----------------------------
-- Table structure for wja_store_withdraw
-- ----------------------------
DROP TABLE IF EXISTS `wja_store_withdraw`;
CREATE TABLE `wja_store_withdraw` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商户ID(接收申请商户ID-厂商ID)',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作用户ID',
  `from_store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '申请提现商户ID',
  `from_store_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '商户类型',
  `amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '申请提现金额',
  `withdraw_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '提现状态(0申请中 1审核通过-提现中 2提现成功 -1 拒绝提现 -2提现失败)',
  `bank_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '提现到账银行卡ID',
  `realname` varchar(255) NOT NULL DEFAULT '' COMMENT '持卡人姓名',
  `bank_name` varchar(255) NOT NULL DEFAULT '' COMMENT '到账银行名称',
  `bank_no` varchar(255) NOT NULL DEFAULT '' COMMENT '到账银行卡号',
  `bank_detail` varchar(2000) NOT NULL DEFAULT '' COMMENT '到账银行卡信息',
  `transfer_no` varchar(255) NOT NULL DEFAULT '' COMMENT '转账流水号',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '操作备注',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '申请时间',
  `check_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '审核时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '到账时间',
  `sort_order` int(1) unsigned NOT NULL DEFAULT '1',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(0禁用 1启用)',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`log_id`),
  KEY `store_id` (`store_id`),
  KEY `from_store_id` (`from_store_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='提现数据表';

-- ----------------------------
-- Records of wja_store_withdraw
-- ----------------------------

-- ----------------------------
-- Table structure for wja_user
-- ----------------------------
DROP TABLE IF EXISTS `wja_user`;
CREATE TABLE `wja_user` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `admin_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '账户类型(0普通会员 1平台管理账号 2厂商管理账号 3渠道商 4服务商 5 零售商)',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '关联商户ID',
  `group_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '管理员分组',
  `grade_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会员等级ID',
  `username` varchar(255) NOT NULL DEFAULT '' COMMENT '登录用户名',
  `password` varchar(32) NOT NULL DEFAULT '' COMMENT '密码',
  `nickname` varchar(255) DEFAULT '' COMMENT '昵称',
  `realname` varchar(255) DEFAULT '' COMMENT '真实姓名',
  `phone` varchar(11) NOT NULL DEFAULT '' COMMENT '联系电话',
  `avatar` varchar(255) DEFAULT '' COMMENT '用户头像',
  `balance` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '账户余额',
  `age` varchar(10) DEFAULT '' COMMENT '年龄',
  `gender` varchar(10) DEFAULT '' COMMENT '性别',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `sort_order` smallint(3) unsigned NOT NULL DEFAULT '1',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0',
  `last_login_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`) USING BTREE,
  KEY `username` (`username`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='前台会员表';

-- ----------------------------
-- Records of wja_user
-- ----------------------------
INSERT INTO `wja_user` VALUES ('1', '1', '0', '0', '0', 'admin', 'f62df18cf9f77c1ddd315da773e0a18b', '', '管理员', '13587458745', '', '0.00', '', '', '1', '1', '1542683553', '1544579036', '1544579036', '0');
INSERT INTO `wja_user` VALUES ('2', '2', '1', '1', '0', 'wanjiaan', 'f03be5a5d3fa6933cbe31b3817728515', '', '', '13458745748', '', '0.00', '', '', '1', '1', '1543223533', '1544579059', '1544579059', '0');
INSERT INTO `wja_user` VALUES ('3', '2', '2', '1', '0', 'ceshi', '3de54ec60cfd102a6f0e6a7211a5be1c', '', '', '', '', '0.00', '', '', '1', '1', '1543288394', '1544428622', '1544428622', '0');
INSERT INTO `wja_user` VALUES ('4', '3', '3', '2', '0', 'qudao', 'e8c94a39f248ffd0973920279f7a9a89', '', '', '', '', '0.00', '', '', '1', '1', '1543302686', '1544511726', '1544511726', '0');
INSERT INTO `wja_user` VALUES ('5', '0', '0', '0', '0', 'xytPju4XCqS6wsoWsVYZiy28H4k0vM', '', '小君', '', '', '', '0.00', '', '2', '1', '1', '1543396294', '1543818381', '1543818381', '0');
INSERT INTO `wja_user` VALUES ('6', '0', '0', '0', '0', 'lZ1UGtD9JpQ7RxTWxkk14WDUUOotWX', '', '微信昵称', '', '', '', '0.00', '', '1', '1', '1', '1543818409', '1544080134', '1544080134', '0');
INSERT INTO `wja_user` VALUES ('7', '4', '4', '3', '0', 'lingshou', '8ba8f868ba577b107b8908c11e5c3758', '', '', '', '', '0.00', '', '', '1', '1', '1544092030', '1544502171', '1544502171', '0');
INSERT INTO `wja_user` VALUES ('8', '4', '6', '3', '0', 'lingshou1', 'ddb26f505418ec290e9fe09953530090', '', '', '', '', '0.00', '', '', '1', '1', '1544092577', '1544092577', '0', '0');
INSERT INTO `wja_user` VALUES ('9', '5', '5', '4', '0', 'fuwu0', '71b5ae2224384de48378da23c00ce187', '', '', '', '', '0.00', '', '', '1', '1', '1544501785', '1544509125', '1544509125', '0');

-- ----------------------------
-- Table structure for wja_user_address
-- ----------------------------
DROP TABLE IF EXISTS `wja_user_address`;
CREATE TABLE `wja_user_address` (
  `address_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `user_id` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '所属会员',
  `name` varchar(20) NOT NULL DEFAULT '' COMMENT '收货人',
  `phone` char(20) NOT NULL DEFAULT '' COMMENT '收货人联系电话',
  `region_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '地址ID',
  `region_name` varchar(255) NOT NULL DEFAULT '' COMMENT '地址',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
  `isdefault` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否默认',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`address_id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='会员收货地址';

-- ----------------------------
-- Records of wja_user_address
-- ----------------------------
INSERT INTO `wja_user_address` VALUES ('1', '5', '小君', '13465874578', '45', '河北省 石家庄市 藁城区', '测试地址', '0', '1', '1543397305', '1543399021', '0');

-- ----------------------------
-- Table structure for wja_user_data
-- ----------------------------
DROP TABLE IF EXISTS `wja_user_data`;
CREATE TABLE `wja_user_data` (
  `udata_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '关联user表ID',
  `openid` varchar(255) NOT NULL DEFAULT '' COMMENT '第三方账号对应平台唯一标识',
  `third_type` varchar(25) NOT NULL DEFAULT '' COMMENT '第三方账号类型(wechat_applet微信小程序 wechat微信公众账号)',
  `third_openid` varchar(500) NOT NULL DEFAULT '' COMMENT '第三方账号唯一标识',
  `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '第三方账号用户头像',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '第三方账号用户昵称',
  `gender` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '第三方账号用户性别(0未知 1男士 2女士)',
  `unionid` varchar(255) NOT NULL DEFAULT '' COMMENT '微信开放平台帐号下的移动应用、网站应用和公众帐号，用户的unionid',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `form_data` varchar(500) NOT NULL DEFAULT '' COMMENT '微信小程序发送模板消息的formid和有效期保存(json)',
  PRIMARY KEY (`udata_id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `openid` (`openid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='会员第三方账号表';

-- ----------------------------
-- Records of wja_user_data
-- ----------------------------
INSERT INTO `wja_user_data` VALUES ('1', '5', 'xytPju4XCqS6wsoWsVYZiy28H4k0vM', 'wechat_applet', 'oDDkf5RMJ5hLJ3oOOqGmTXyt3BJk', '', '小君', '2', '', '1543396295', '1543818381', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('2', '6', 'lZ1UGtD9JpQ7RxTWxkk14WDUUOotWX', 'wechat_applet', 'oDDkf5aVC76YRNSp3FV2E3AW7eAk', '', '微信昵称', '1', '', '1543818409', '1544080134', '1', '0', '');

-- ----------------------------
-- Table structure for wja_user_grade
-- ----------------------------
DROP TABLE IF EXISTS `wja_user_grade`;
CREATE TABLE `wja_user_grade` (
  `grade_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '会员等级ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '等级名称',
  `description` varchar(1000) NOT NULL DEFAULT '' COMMENT '等级描述',
  `sort_order` tinyint(1) unsigned NOT NULL DEFAULT '255' COMMENT '排序',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`grade_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_user_grade
-- ----------------------------

-- ----------------------------
-- Table structure for wja_user_group
-- ----------------------------
DROP TABLE IF EXISTS `wja_user_group`;
CREATE TABLE `wja_user_group` (
  `group_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户分组ID',
  `group_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 admin下角色 2 factory下角色 ',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '管理员账户ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '分组名称',
  `is_system` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否是系统角色',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `sort_order` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '排序',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `menu_json` text NOT NULL COMMENT '分组显示菜单权限',
  PRIMARY KEY (`group_id`) USING BTREE,
  KEY `store_id` (`store_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='用户分组表';

-- ----------------------------
-- Records of wja_user_group
-- ----------------------------
INSERT INTO `wja_user_group` VALUES ('1', '2', '0', '厂商', '1', '1', '1', '0', '1535715012', '1535715012', '[{\"id\":5,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"\"},{\"id\":6,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"home\"},{\"id\":7,\"module\":\"factory\",\"controller\":\"\",\"action\":\"\"},{\"id\":83,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"index\"},{\"id\":84,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"add\"},{\"id\":85,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"edit\"},{\"id\":86,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"publish\"},{\"id\":87,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"del\"},{\"id\":114,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"detail\"},{\"id\":9,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"index\"},{\"id\":10,\"module\":\"factory\",\"controller\":\"system\",\"action\":\"factory\"},{\"id\":96,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"add\"},{\"id\":97,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"edit\"},{\"id\":98,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"del\"},{\"id\":12,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"\"},{\"id\":13,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"index\"},{\"id\":18,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"add\"},{\"id\":19,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"edit\"},{\"id\":20,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"del\"},{\"id\":21,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"spec\"},{\"id\":22,\"module\":\"factory\",\"controller\":\"gcate\",\"action\":\"index\"},{\"id\":23,\"module\":\"factory\",\"controller\":\"gcate\",\"action\":\"add\"},{\"id\":24,\"module\":\"factory\",\"controller\":\"gcate\",\"action\":\"edit\"},{\"id\":25,\"module\":\"factory\",\"controller\":\"gcate\",\"action\":\"del\"},{\"id\":55,\"module\":\"factory\",\"controller\":\"gspec\",\"action\":\"index\"},{\"id\":56,\"module\":\"factory\",\"controller\":\"gspec\",\"action\":\"add\"},{\"id\":57,\"module\":\"factory\",\"controller\":\"gspec\",\"action\":\"edit\"},{\"id\":58,\"module\":\"factory\",\"controller\":\"gspec\",\"action\":\"del\"},{\"id\":14,\"module\":\"factory\",\"controller\":\"merchant\",\"action\":\"\"},{\"id\":35,\"module\":\"factory\",\"controller\":\"channel\",\"action\":\"index\"},{\"id\":36,\"module\":\"factory\",\"controller\":\"channel\",\"action\":\"add\"},{\"id\":37,\"module\":\"factory\",\"controller\":\"channel\",\"action\":\"edit\"},{\"id\":38,\"module\":\"factory\",\"controller\":\"channel\",\"action\":\"del\"},{\"id\":79,\"module\":\"factory\",\"controller\":\"channel\",\"action\":\"manager\"},{\"id\":39,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"index\"},{\"id\":40,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"add\"},{\"id\":41,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"edit\"},{\"id\":42,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"del\"},{\"id\":80,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"manager\"},{\"id\":43,\"module\":\"factory\",\"controller\":\"servicer\",\"action\":\"index\"},{\"id\":44,\"module\":\"factory\",\"controller\":\"servicer\",\"action\":\"add\"},{\"id\":45,\"module\":\"factory\",\"controller\":\"servicer\",\"action\":\"edit\"},{\"id\":46,\"module\":\"factory\",\"controller\":\"servicer\",\"action\":\"del\"},{\"id\":81,\"module\":\"factory\",\"controller\":\"servicer\",\"action\":\"manager\"},{\"id\":15,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"\"},{\"id\":59,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"index\"},{\"id\":94,\"module\":\"factory\",\"controller\":\"security\",\"action\":\"index\"},{\"id\":95,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"finance\"},{\"id\":99,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"check\"},{\"id\":16,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"\"},{\"id\":47,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"index\"},{\"id\":48,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"add\"},{\"id\":49,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"edit\"},{\"id\":50,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"del\"},{\"id\":100,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"check\"},{\"id\":17,\"module\":\"factory\",\"controller\":\"worder\",\"action\":\"\"},{\"id\":51,\"module\":\"factory\",\"controller\":\"worder\",\"action\":\"index\"},{\"id\":52,\"module\":\"factory\",\"controller\":\"worder\",\"action\":\"add\"},{\"id\":53,\"module\":\"factory\",\"controller\":\"worder\",\"action\":\"edit\"},{\"id\":54,\"module\":\"factory\",\"controller\":\"worder\",\"action\":\"del\"},{\"id\":101,\"module\":\"factory\",\"controller\":\"worder\",\"action\":\"dispatch\"},{\"id\":102,\"module\":\"factory\",\"controller\":\"worder\",\"action\":\"detail\"},{\"id\":103,\"module\":\"factory\",\"controller\":\"worder\",\"action\":\"cancel\"},{\"id\":70,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"\"},{\"id\":71,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"index\"},{\"id\":72,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"detail\"},{\"id\":73,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"pay\"},{\"id\":74,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"cancel\"},{\"id\":76,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"delivery\"},{\"id\":77,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"deliverylogs\"},{\"id\":78,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"finish\"},{\"id\":107,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"detail\"},{\"id\":108,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"check\"},{\"id\":106,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"seller\"},{\"id\":111,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"cancel\"},{\"id\":113,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"refund\"}]');
INSERT INTO `wja_user_group` VALUES ('2', '2', '0', '渠道商', '1', '1', '1', '0', '1535715012', '1535715012', '[{\"id\":5,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"\"},{\"id\":6,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"home\"},{\"id\":7,\"module\":\"factory\",\"controller\":\"\",\"action\":\"\"},{\"id\":9,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"index\"},{\"id\":98,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"del\"},{\"id\":97,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"edit\"},{\"id\":96,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"add\"},{\"id\":14,\"module\":\"factory\",\"controller\":\"merchant\",\"action\":\"\"},{\"id\":39,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"index\"},{\"id\":40,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"add\"},{\"id\":41,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"edit\"},{\"id\":80,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"manager\"},{\"id\":15,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"\"},{\"id\":59,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"index\"},{\"id\":88,\"module\":\"factory\",\"controller\":\"commission\",\"action\":\"index\"},{\"id\":92,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"setting\"},{\"id\":93,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"apply\"},{\"id\":60,\"module\":\"factory\",\"controller\":\"purchase\",\"action\":\"\"},{\"id\":61,\"module\":\"factory\",\"controller\":\"purchase\",\"action\":\"index\"},{\"id\":62,\"module\":\"factory\",\"controller\":\"purchase\",\"action\":\"detail\"},{\"id\":63,\"module\":\"factory\",\"controller\":\"purchase\",\"action\":\"confirm\"},{\"id\":64,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"index\"},{\"id\":69,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"pay\"},{\"id\":65,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"detail\"},{\"id\":66,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"cancel\"},{\"id\":67,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"deliverylogs\"},{\"id\":68,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"finish\"},{\"id\":104,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"return\"},{\"id\":82,\"module\":\"factory\",\"controller\":\"suborder\",\"action\":\"index\"},{\"id\":90,\"module\":\"factory\",\"controller\":\"suborder\",\"action\":\"detail\"},{\"id\":105,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"index\"},{\"id\":109,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"detail\"},{\"id\":110,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"cancel\"},{\"id\":112,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"delivery\"}]');
INSERT INTO `wja_user_group` VALUES ('3', '2', '0', '零售商/经销商', '1', '1', '1', '0', '1535715012', '1535715012', '[{\"id\":5,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"\"},{\"id\":6,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"home\"},{\"id\":7,\"module\":\"factory\",\"controller\":\"\",\"action\":\"\"},{\"id\":9,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"index\"},{\"id\":96,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"add\"},{\"id\":97,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"edit\"},{\"id\":98,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"del\"},{\"id\":60,\"module\":\"factory\",\"controller\":\"purchase\",\"action\":\"\"},{\"id\":61,\"module\":\"factory\",\"controller\":\"purchase\",\"action\":\"index\"},{\"id\":62,\"module\":\"factory\",\"controller\":\"purchase\",\"action\":\"detail\"},{\"id\":63,\"module\":\"factory\",\"controller\":\"purchase\",\"action\":\"confirm\"},{\"id\":64,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"index\"},{\"id\":69,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"pay\"},{\"id\":66,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"cancel\"},{\"id\":65,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"detail\"},{\"id\":67,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"deliverylogs\"},{\"id\":68,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"finish\"},{\"id\":104,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"return\"},{\"id\":105,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"index\"},{\"id\":109,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"detail\"},{\"id\":110,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"cancel\"},{\"id\":112,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"delivery\"}]');
INSERT INTO `wja_user_group` VALUES ('4', '2', '0', '服务商', '1', '1', '1', '0', '1535715012', '1535715012', '[{\"id\":5,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"\"},{\"id\":6,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"home\"},{\"id\":7,\"module\":\"factory\",\"controller\":\"\",\"action\":\"\"},{\"id\":9,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"index\"},{\"id\":11,\"module\":\"factory\",\"controller\":\"system\",\"action\":\"servicer\"},{\"id\":15,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"\"},{\"id\":59,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"index\"},{\"id\":88,\"module\":\"factory\",\"controller\":\"commission\",\"action\":\"index\"},{\"id\":92,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"setting\"},{\"id\":93,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"apply\"},{\"id\":16,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"\"},{\"id\":47,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"index\"},{\"id\":48,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"add\"},{\"id\":49,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"edit\"},{\"id\":50,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"del\"},{\"id\":100,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"check\"},{\"id\":17,\"module\":\"factory\",\"controller\":\"worder\",\"action\":\"\"},{\"id\":51,\"module\":\"factory\",\"controller\":\"worder\",\"action\":\"index\"},{\"id\":52,\"module\":\"factory\",\"controller\":\"worder\",\"action\":\"add\"},{\"id\":53,\"module\":\"factory\",\"controller\":\"worder\",\"action\":\"edit\"},{\"id\":54,\"module\":\"factory\",\"controller\":\"worder\",\"action\":\"del\"},{\"id\":101,\"module\":\"factory\",\"controller\":\"worder\",\"action\":\"dispatch\"},{\"id\":102,\"module\":\"factory\",\"controller\":\"worder\",\"action\":\"detail\"},{\"id\":103,\"module\":\"factory\",\"controller\":\"worder\",\"action\":\"cancel\"}]');
INSERT INTO `wja_user_group` VALUES ('5', '1', '0', '财务', '0', '1', '1', '0', '1535715012', '1535715012', '');
INSERT INTO `wja_user_group` VALUES ('6', '1', '0', '运营', '0', '1', '1', '0', '1535715012', '1535715012', '');
INSERT INTO `wja_user_group` VALUES ('7', '1', '0', '客服', '0', '1', '1', '0', '1535715012', '1535715012', '');

-- ----------------------------
-- Table structure for wja_user_installer
-- ----------------------------
DROP TABLE IF EXISTS `wja_user_installer`;
CREATE TABLE `wja_user_installer` (
  `installer_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `job_no` varchar(50) NOT NULL DEFAULT '' COMMENT '工程师工号',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '售后工程师对应账号ID',
  `factory_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '厂商ID',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商户ID',
  `realname` varchar(255) NOT NULL DEFAULT '' COMMENT '真实姓名',
  `gender` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '工程师性别',
  `phone` varchar(11) NOT NULL DEFAULT '' COMMENT '联系电话',
  `work_time` varchar(50) NOT NULL DEFAULT '' COMMENT '工程师从业时间',
  `idcard_font_img` varchar(255) NOT NULL DEFAULT '' COMMENT '身份证正面',
  `idcard_back_img` varchar(255) NOT NULL DEFAULT '' COMMENT '身份证背面',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `sort_order` smallint(3) unsigned NOT NULL DEFAULT '1',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `wxacode` varchar(255) NOT NULL DEFAULT '' COMMENT '工程师绑定二维码地址',
  `remark` varchar(255) NOT NULL DEFAULT '',
  `service_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '服务次数',
  `security_record_num` varchar(255) NOT NULL DEFAULT '' COMMENT '公安机关备案号',
  `check_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '(0待审核 1审核成功 -1厂商审核中 -2厂商拒绝 -3服务商审核中 -4服务商拒绝)',
  PRIMARY KEY (`installer_id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='售后工程师数据表';

-- ----------------------------
-- Records of wja_user_installer
-- ----------------------------

-- ----------------------------
-- Table structure for wja_user_installer_score
-- ----------------------------
DROP TABLE IF EXISTS `wja_user_installer_score`;
CREATE TABLE `wja_user_installer_score` (
  `score_id` int(10) NOT NULL AUTO_INCREMENT,
  `installer_id` int(10) NOT NULL COMMENT '工程师ID',
  `config_id` int(10) NOT NULL COMMENT '对应配置服务评分项ID',
  `value` float(10,2) NOT NULL COMMENT '对应工程师单项服务项总平均得分',
  `add_time` int(10) unsigned NOT NULL COMMENT '分值初创时间',
  `update_time` int(10) NOT NULL COMMENT '分值最后更新时间',
  PRIMARY KEY (`score_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Records of wja_user_installer_score
-- ----------------------------

-- ----------------------------
-- Table structure for wja_work_order
-- ----------------------------
DROP TABLE IF EXISTS `wja_work_order`;
CREATE TABLE `wja_work_order` (
  `worder_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '工单自增长ID',
  `worder_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '工单编号',
  `order_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '工单类型(1安装工单 2故障报修)',
  `factory_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '厂商ID',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '工单服务商ID',
  `post_user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '工单提交用户ID',
  `order_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '安装工单关联订单编号',
  `osku_id` int(10) unsigned NOT NULL DEFAULT '0',
  `goods_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '产品表ID',
  `sku_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '产品属性规格表ID',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '客户ID',
  `installer_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '售后工程师ID',
  `user_name` varchar(255) NOT NULL DEFAULT '' COMMENT '客户名称',
  `phone` varchar(255) NOT NULL DEFAULT '' COMMENT '客户联系电话',
  `region_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '客户地址所属区域ID',
  `region_name` varchar(255) NOT NULL DEFAULT '' COMMENT '区域名称',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '客户地址',
  `appointment` int(10) NOT NULL DEFAULT '0' COMMENT '预约服务时间',
  `images` text NOT NULL COMMENT '故障图片',
  `fault_desc` text NOT NULL COMMENT '故障报修单:故障描述',
  `sort_order` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `dispatch_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '工程师分派时间',
  `cancel_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '工单取消时间',
  `receive_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '售后工程师接单时间',
  `sign_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '工程师签到',
  `finish_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '售后完成时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `install_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '工单预安装费',
  `real_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '实得安装费',
  PRIMARY KEY (`worder_id`) USING BTREE,
  KEY `worder_sn` (`worder_sn`),
  KEY `factory_id` (`factory_id`),
  KEY `store_id` (`store_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='工单数据表';

-- ----------------------------
-- Records of wja_work_order
-- ----------------------------

-- ----------------------------
-- Table structure for wja_work_order_assess
-- ----------------------------
DROP TABLE IF EXISTS `wja_work_order_assess`;
CREATE TABLE `wja_work_order_assess` (
  `assess_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '工单评价ID',
  `worder_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '工单ID',
  `worder_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '工单号',
  `installer_id` int(10) NOT NULL COMMENT '工程师ID',
  `post_user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '评价客户ID',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '用户昵称',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '评价类型: 1首次评价 2追加评价',
  `msg` varchar(500) NOT NULL DEFAULT '' COMMENT '用户评价内容',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '客户评价时间',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`assess_id`) USING BTREE,
  KEY `worder_id` (`worder_id`) USING BTREE,
  KEY `worder_sn` (`worder_sn`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='工单评价数据表';

-- ----------------------------
-- Records of wja_work_order_assess
-- ----------------------------

-- ----------------------------
-- Table structure for wja_work_order_assess_log
-- ----------------------------
DROP TABLE IF EXISTS `wja_work_order_assess_log`;
CREATE TABLE `wja_work_order_assess_log` (
  `log_id` int(10) NOT NULL AUTO_INCREMENT,
  `assess_id` int(10) NOT NULL COMMENT '工单评价记录ID',
  `installer_id` int(10) NOT NULL COMMENT '工程师ID',
  `config_id` int(10) NOT NULL COMMENT '对应配置服务评分项ID',
  `value` float(10,2) unsigned NOT NULL COMMENT '服务项分数',
  PRIMARY KEY (`log_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Records of wja_work_order_assess_log
-- ----------------------------

-- ----------------------------
-- Table structure for wja_work_order_log
-- ----------------------------
DROP TABLE IF EXISTS `wja_work_order_log`;
CREATE TABLE `wja_work_order_log` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `worder_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单ID',
  `worder_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '订单号',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作用户ID',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '用户昵称',
  `action` varchar(50) NOT NULL DEFAULT '' COMMENT '操作类型',
  `msg` varchar(500) NOT NULL DEFAULT '' COMMENT '操作信息',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '日志记录时间',
  PRIMARY KEY (`log_id`) USING BTREE,
  KEY `worder_id` (`worder_id`) USING BTREE,
  KEY `worder_sn` (`worder_sn`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='工单日志数据表';

-- ----------------------------
-- Records of wja_work_order_log
-- ----------------------------
