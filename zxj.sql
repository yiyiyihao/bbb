/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50721
Source Host           : localhost:3306
Source Database       : zxj

Target Server Type    : MYSQL
Target Server Version : 50721
File Encoding         : 65001

Date: 2019-01-03 18:10:56
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
  `errmsg` text NOT NULL,
  `show_time` varchar(255) NOT NULL DEFAULT '',
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
) ENGINE=MyISAM AUTO_INCREMENT=153 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='权限节点';

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
INSERT INTO `wja_auth_rule` VALUES ('11', '1', 'factory', 'system', 'servicer', '服务商配置', '', '7', '1', '40', '1', '1', '1543807754', '1543807754', '1');
INSERT INTO `wja_auth_rule` VALUES ('12', '1', 'factory', 'goods', '', '产品管理', 'tips', '2', '1', '40', '1', '1', '1543808011', '1543808011', '0');
INSERT INTO `wja_auth_rule` VALUES ('13', '1', 'factory', 'goods', 'index', '产品列表', '', '12', '1', '10', '1', '1', '1543808047', '1543808047', '0');
INSERT INTO `wja_auth_rule` VALUES ('14', '1', 'factory', 'merchant', '', '商户管理', 'user-setting', '2', '1', '50', '1', '1', '1543808090', '1543808157', '0');
INSERT INTO `wja_auth_rule` VALUES ('15', '1', 'factory', 'finance', '', '财务管理', 'ticket-list', '2', '1', '60', '1', '1', '1543808132', '1543808132', '0');
INSERT INTO `wja_auth_rule` VALUES ('16', '1', 'factory', 'installer', '', '售后工程师', 'user', '2', '1', '70', '1', '1', '1543814053', '1543814053', '0');
INSERT INTO `wja_auth_rule` VALUES ('17', '1', 'factory', 'workorder', '', '工单管理', 'list-done', '2', '1', '80', '1', '1', '1543814156', '1543814156', '0');
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
INSERT INTO `wja_auth_rule` VALUES ('51', '1', 'factory', 'workorder', 'index', '安装工单列表', '', '17', '1', '10', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('52', '1', 'factory', 'workorder', 'add', '新增工单', '', '17', '1', '11', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('53', '1', 'factory', 'workorder', 'edit', '编辑工单', '', '17', '1', '12', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('54', '1', 'factory', 'workorder', 'del', '删除工单', '', '17', '1', '13', '0', '1', '1543974007', '1543974007', '0');
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
INSERT INTO `wja_auth_rule` VALUES ('130', '1', 'factory', 'store', 'index', '入驻申请列表', 'list', '14', '1', '40', '1', '1', '1543974007', '1543974007', '1');
INSERT INTO `wja_auth_rule` VALUES ('131', '1', 'factory', 'store', 'detail', '入驻申请详情', 'detail', '14', '1', '41', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('132', '1', 'factory', 'store', 'check', '入驻审核', 'check', '14', '1', '42', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('133', '1', 'factory', 'storeaction', 'index', '操作申请列表', 'lise', '14', '1', '50', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('134', '1', 'factory', 'storeaction', 'detail', '操作申请详情', 'detail', '14', '1', '51', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('135', '1', 'factory', 'storeaction', 'check', '操作审核', 'check', '14', '1', '52', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('136', '1', 'factory', 'workorder', 'lists', '维修工单列表', 'list', '17', '1', '10', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('137', '1', 'factory', 'site', '', '网站管理', 'home', '2', '1', '255', '1', '1', '1545708234', '1545882653', '0');
INSERT INTO `wja_auth_rule` VALUES ('138', '1', 'factory', 'site', 'setting', '基本设置', '', '137', '1', '10', '1', '1', '1545708314', '1545882678', '0');
INSERT INTO `wja_auth_rule` VALUES ('139', '1', 'factory', 'article', 'index', '文章管理', '', '137', '1', '20', '1', '1', '1545708742', '1545877509', '0');
INSERT INTO `wja_auth_rule` VALUES ('140', '1', 'factory', 'site', 'menu', '导航管理', '', '137', '1', '10', '1', '1', '1545708824', '1546053107', '0');
INSERT INTO `wja_auth_rule` VALUES ('141', '1', 'factory', 'article', 'add', '新增文章', '', '137', '1', '21', '0', '1', '1545725520', '1545877549', '0');
INSERT INTO `wja_auth_rule` VALUES ('142', '1', 'factory', 'article', 'del', '删除文章', '', '137', '1', '22', '0', '1', '1545819541', '1545877577', '0');
INSERT INTO `wja_auth_rule` VALUES ('143', '1', 'factory', 'article', 'publish', '发布文章', '', '137', '1', '23', '0', '1', '1545875514', '1545877565', '0');
INSERT INTO `wja_auth_rule` VALUES ('144', '1', 'factory', 'site', 'index', '首页管理', '', '137', '1', '2', '1', '1', '1545877388', '1545882699', '0');
INSERT INTO `wja_auth_rule` VALUES ('145', '1', 'factory', 'site', 'banner', '编辑轮播图', '', '137', '1', '100', '0', '1', '1545887232', '1545905216', '0');
INSERT INTO `wja_auth_rule` VALUES ('146', '1', 'factory', 'site', 'del', '删除轮播图', '', '137', '1', '100', '0', '1', '1545899124', '1545905234', '0');
INSERT INTO `wja_auth_rule` VALUES ('147', '1', 'factory', 'site', 'page', '单页管理', '', '137', '1', '30', '1', '1', '1546064760', '1546064932', '0');
INSERT INTO `wja_auth_rule` VALUES ('148', '1', 'factory', 'site', 'nav', '导航列表', '', '137', '1', '11', '0', '1', '1545905644', '1545905644', '0');
INSERT INTO `wja_auth_rule` VALUES ('149', '1', 'factory', 'site', 'add_menu', '新增导航', '', '137', '1', '12', '0', '1', '1546055893', '1546055893', '0');
INSERT INTO `wja_auth_rule` VALUES ('150', '1', 'factory', 'site', 'add_page', '新建单页', '', '137', '1', '31', '0', '1', '1546066567', '1546066567', '0');
INSERT INTO `wja_auth_rule` VALUES ('151', '1', 'factory', 'site', 'del_page', '删除单页', '', '137', '1', '32', '0', '1', '1546075791', '1546078053', '0');
INSERT INTO `wja_auth_rule` VALUES ('152', '1', 'factory', 'site', 'del_menu', '删除导航', '', '137', '1', '13', '0', '1', '1546412498', '1546412630', '0');

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
  `visible_range` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '商户类型下的用户可见范围(1全部可见 0部分可见)',
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
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='公告数据表';

-- ----------------------------
-- Records of wja_bulletin
-- ----------------------------
INSERT INTO `wja_bulletin` VALUES ('1', '1', '2', '123', '0', '123', '123456', '0', '1', '', '0', '1546052126', '1', '1', '1', '1546052102', '1546052126', '0');
INSERT INTO `wja_bulletin` VALUES ('2', '1', '2', '2333', '1', '233333', '233333333', '0', '1', '', '1', '1546056795', '1', '1', '1', '1546056788', '1546056795', '0');
INSERT INTO `wja_bulletin` VALUES ('3', '1', '2', '啊大大', '1', '啊啊啊', '啊啊啊', '0', '1', '', '1', '1546056878', '1', '1', '1', '1546056867', '1546056878', '0');
INSERT INTO `wja_bulletin` VALUES ('4', '1', '2', '122', '0', '122', '122', '0', '1', '', '0', '1546056926', '1', '1', '1', '1546056920', '1546056926', '0');
INSERT INTO `wja_bulletin` VALUES ('5', '1', '2', '123456', '0', '123456789', '987654321', '0', '1', '', '0', '1546072900', '1', '1', '1', '1546072894', '1546072900', '0');
INSERT INTO `wja_bulletin` VALUES ('6', '1', '2', '新增', '0', '新增', '新增', '0', '1', '', '0', '1546073033', '1', '1', '1', '1546073029', '1546073033', '0');
INSERT INTO `wja_bulletin` VALUES ('7', '1', '2', 'asdf', '0', '', '		                  	s		                  ', '2', '1', '', '0', '0', '0', '1', '1', '1546497355', '1546497512', '0');

-- ----------------------------
-- Table structure for wja_bulletin_log
-- ----------------------------
DROP TABLE IF EXISTS `wja_bulletin_log`;
CREATE TABLE `wja_bulletin_log` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bulletin_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '公告ID',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '读取公告用户ID',
  `store_id` int(10) unsigned NOT NULL,
  `has_display` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '特效展示是否已完成',
  `is_read` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否已读',
  `sort_order` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '排序',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(0禁用 1正常)',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '读取时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`log_id`),
  KEY `bulletin_id` (`bulletin_id`),
  KEY `store_id` (`store_id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='公告读取日志记录表';

-- ----------------------------
-- Records of wja_bulletin_log
-- ----------------------------
INSERT INTO `wja_bulletin_log` VALUES ('1', '3', '5', '4', '0', '1', '1', '1', '1546072138', '1546072138', '0');
INSERT INTO `wja_bulletin_log` VALUES ('2', '4', '6', '5', '0', '1', '1', '1', '1546072842', '1546072842', '0');
INSERT INTO `wja_bulletin_log` VALUES ('3', '1', '6', '5', '0', '1', '1', '1', '1546072847', '1546072847', '0');
INSERT INTO `wja_bulletin_log` VALUES ('4', '2', '6', '5', '0', '1', '1', '1', '1546072850', '1546072850', '0');
INSERT INTO `wja_bulletin_log` VALUES ('5', '2', '4', '3', '0', '1', '1', '1', '1546072867', '1546072867', '0');
INSERT INTO `wja_bulletin_log` VALUES ('6', '5', '6', '5', '0', '1', '1', '1', '1546072909', '1546072909', '0');
INSERT INTO `wja_bulletin_log` VALUES ('7', '6', '6', '5', '0', '1', '1', '1', '1546073040', '1546073040', '0');
INSERT INTO `wja_bulletin_log` VALUES ('8', '6', '4', '3', '0', '1', '1', '1', '1546416044', '1546416044', '0');
INSERT INTO `wja_bulletin_log` VALUES ('9', '5', '4', '3', '0', '1', '1', '1', '1546416052', '1546416052', '0');
INSERT INTO `wja_bulletin_log` VALUES ('10', '3', '4', '3', '0', '1', '1', '1', '1546416062', '1546416062', '0');
INSERT INTO `wja_bulletin_log` VALUES ('11', '4', '4', '3', '0', '1', '1', '1', '1546416069', '1546416069', '0');
INSERT INTO `wja_bulletin_log` VALUES ('12', '1', '4', '3', '0', '1', '1', '1', '1546416072', '1546416072', '0');

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
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='数据配置表';

-- ----------------------------
-- Records of wja_config
-- ----------------------------
INSERT INTO `wja_config` VALUES ('1', '1', 'config_workorder_assess', '服务态度', '5', '1544079691', '1544079691', '1', '1', '0');
INSERT INTO `wja_config` VALUES ('2', '1', 'config_workorder_assess', '专业技能', '5', '1544079783', '1544079933', '1', '1', '0');
INSERT INTO `wja_config` VALUES ('3', '1', 'system_default', '系统默认配置', '{\"order_cancel_minute\":\"1\",\"order_return_day\":\"2\",\"workorder_auto_assess_day\":\"3\",\"monthly_withdraw_start_date\":\"6\",\"monthly_withdraw_end_date\":\"8\",\"withdraw_min_amount\":\"50\",\"withdrawal_work_day\":\"7\",\"ordersku_return_limit\":\"2\"}', '1544155010', '1544497054', '1', '1', '0');
INSERT INTO `wja_config` VALUES ('4', '1', 'system_sms', '系统短信模版配置', '{\"accesskey_id\":\"LTAIdE0O2k9FuBgz\",\"accesskey_secret\":\"j0sYzdja2fIroi4xVXbjnwlRh1GwgQ\",\"sign_name\":\"\\u4e07\\u4f73\\u5b89\\u667a\\u80fd\",\"send_code\":{\"template_code\":\"SMS_153331130\",\"template_content\":\"\\u60a8\\u7684\\u9a8c\\u8bc1\\u7801\\u4e3a\\uff1a${code}\\uff0c\\u8be5\\u9a8c\\u8bc1\\u7801 5 \\u5206\\u949f\\u5185\\u6709\\u6548\\uff0c\\u8bf7\\u52ff\\u6cc4\\u6f0f\\u4e8e\\u4ed6\\u4eba\"},\"reset_pwd\":{\"template_code\":\"SMS_153331143\",\"template_content\":\"\\u60a8\\u597d\\uff0c\\u60a8\\u7684\\u5bc6\\u7801\\u5df2\\u7ecf\\u91cd\\u7f6e\\u4e3a${password}\\uff0c\\u8bf7\\u53ca\\u65f6\\u767b\\u5f55\\u5e76\\u4fee\\u6539\\u5bc6\\u7801\\u3002\"},\"worder_dispatch_installer\":{\"template_code\":\"SMS_153990108\",\"template_content\":\"\\u6536\\u5230\\u65b0\\u7684\\u670d\\u52a1\\u5de5\\u5355\\uff0c\\u8bf7\\u8fdb\\u5165\\u667a\\u4eab\\u5bb6\\u5e08\\u5085\\u7aef\\u5c0f\\u7a0b\\u5e8f\\u63a5\\u5355\\u3002\"},\"installer_check_fail\":{\"template_code\":\"SMS_153990107\",\"template_content\":\"\\u5c0a\\u656c\\u7684${name}\\uff1a\\u60a8\\u597d\\uff0c\\u975e\\u5e38\\u62b1\\u6b49\\uff0c\\u60a8\\u7533\\u8bf7\\u7684\\u667a\\u4eab\\u5bb6\\u670d\\u52a1\\u5de5\\u7a0b\\u5e08\\u672a\\u901a\\u8fc7\\u5ba1\\u6838\\uff0c\\u8bf7\\u8fdb\\u5165\\u667a\\u4eab\\u5bb6\\u5e08\\u5085\\u7aef\\u5c0f\\u7a0b\\u5e8f\\u67e5\\u770b\\u8be6\\u60c5\\u3002\"},\"installer_check_success\":{\"template_code\":\"SMS_153990106\",\"template_content\":\"\\u5c0a\\u656c\\u7684${name}\\uff1a\\u60a8\\u597d\\uff0c\\u606d\\u559c\\u60a8\\u5df2\\u901a\\u8fc7\\u667a\\u4eab\\u5bb6\\u670d\\u52a1\\u5de5\\u7a0b\\u5e08\\u7684\\u6ce8\\u518c\\u5ba1\\u6838\\uff0c\\u8bf7\\u7b49\\u5f85\\u7cfb\\u7edf\\u5206\\u6d3e\\u5de5\\u5355\\u5427\\u3002\"}}', '1545205596', '1545984738', '1', '1', '0');

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
) ENGINE=MyISAM AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_file
-- ----------------------------
INSERT INTO `wja_file` VALUES ('1', 'FnXij7lbY5-lZX2rGmSgmZEKhmSL', 'goods_20181224103855_1.jpg', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/goods_20181224103855_1.jpg', '1.jpg', '17652', '1545619136', '1545619136');
INSERT INTO `wja_file` VALUES ('2', 'FurRyLMT6LV1UtszQo0JFvBJ07hX', 'goods_20181224103931_4.jpg', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg', '4.jpg', '22018', '1545619172', '1545619172');
INSERT INTO `wja_file` VALUES ('3', 'FhtPGf_x-K7OU9rS5eQXIM6yP3H3', 'api_idcard20181224115101_tmp_a052b5657318bc0ec790bb0e9fe17fdc.jpg', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181224115101_tmp_a052b5657318bc0ec790bb0e9fe17fdc.jpg', 'tmp_a052b5657318bc0ec790bb0e9fe17fdc.jpg', '655992', '1545623461', '1545623461');
INSERT INTO `wja_file` VALUES ('4', 'FgTmTwQsKZFrIIAaVPfV3glGghPE', 'api_idcard20181224115111_tmp_6ff090180ceb8b8e7b83349b519dd21a.jpg', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181224115111_tmp_6ff090180ceb8b8e7b83349b519dd21a.jpg', 'tmp_6ff090180ceb8b8e7b83349b519dd21a.jpg', '564531', '1545623471', '1545623471');
INSERT INTO `wja_file` VALUES ('5', 'Fl5MsduDCwPUVKdZs0ICQ1YqK-81', 'api_idcard20181224144430_tmp_fe26c9bd1087b3549c082ff27f853e87.jpg', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181224144430_tmp_fe26c9bd1087b3549c082ff27f853e87.jpg', 'tmp_fe26c9bd1087b3549c082ff27f853e87.jpg', '300382', '1545633870', '1545633870');
INSERT INTO `wja_file` VALUES ('6', 'Fp8QP31cpOIGuLNkqD4ZUwzdwqzP', 'api_idcard20181224144437_tmp_2b4aca7d54065aaf60d78ee293744e79.jpg', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181224144437_tmp_2b4aca7d54065aaf60d78ee293744e79.jpg', 'tmp_2b4aca7d54065aaf60d78ee293744e79.jpg', '122476', '1545633877', '1545633877');
INSERT INTO `wja_file` VALUES ('7', 'FkFT01GwQJOnMJ7f1izykpm0O9kZ', 'store_20181225140352_asdasdsadwqd.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/store_20181225140352_asdasdsadwqd.png', 'asdasdsadwqd.png', '6035', '1545717832', '1545717832');
INSERT INTO `wja_file` VALUES ('8', 'FtVMPxNn4yotIdGMfqLQ-w-Kd7fE', 'store_20181225140355_589444.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/store_20181225140355_589444.png', '589444.png', '1952', '1545717835', '1545717835');
INSERT INTO `wja_file` VALUES ('9', 'FkWzu3Sdfm4eN_KDt1IU0TWpMUBq', 'store_20181225140402_544448.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/store_20181225140402_544448.png', '544448.png', '4434', '1545717842', '1545717842');
INSERT INTO `wja_file` VALUES ('10', 'Fona7vDpuZqvbEfj49gF42lx1Z8n', 'store_20181225140406_123131.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/store_20181225140406_123131.png', '123131.png', '2533', '1545717846', '1545717846');
INSERT INTO `wja_file` VALUES ('11', 'FstwA6Cr6H_QJZB170eSLbb5_oYc', 'store_20181225140731_5564464.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/store_20181225140731_5564464.png', '5564464.png', '2549', '1545718051', '1545718051');
INSERT INTO `wja_file` VALUES ('12', 'FtPN1tyYYjLAn-E8Yx_EMviXO54N', 'api_idcard20181225142238_tmp_cc646b67d1c6269a6b76cead367eb5340fda9f3e3972ac86.jpg', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181225142238_tmp_cc646b67d1c6269a6b76cead367eb5340fda9f3e3972ac86.jpg', 'tmp_cc646b67d1c6269a6b76cead367eb5340fda9f3e3972ac86.jpg', '169988', '1545718958', '1545718958');
INSERT INTO `wja_file` VALUES ('13', 'Fg0rX9Yn4lG4GhM4tO25YAHFwCo5', 'api_idcard20181225142245_tmp_649a0e562992b69f5f07aa2fa07b41edc48c2d9a1d284772.jpg', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181225142245_tmp_649a0e562992b69f5f07aa2fa07b41edc48c2d9a1d284772.jpg', 'tmp_649a0e562992b69f5f07aa2fa07b41edc48c2d9a1d284772.jpg', '120667', '1545718965', '1545718965');
INSERT INTO `wja_file` VALUES ('14', 'FuSc2dVyXr8E5EYQNPzezxn08tT2', 'store_20181226151144_65465478.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/store_20181226151144_65465478.png', '65465478.png', '4335', '1545808304', '1545808304');
INSERT INTO `wja_file` VALUES ('15', 'FrCT-5YjuNdBbOiY94OuVMbuJK16', 'order_service_20181227163801.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/order_service_20181227163801.png', 'cloud_未标题-3.png', '13031', '1545899881', '1545899881');
INSERT INTO `wja_file` VALUES ('16', 'FjJdAU1Cx1EWpqdv8OYTpHHfELA3', 'api_idcard20181228144135_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.QGBqhlBLcHwif886b2b53c78839a70074fd86afefe67.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181228144135_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.QGBqhlBLcHwif886b2b53c78839a70074fd86afefe67.png', 'wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.QGBqhlBLcHwif886b2b53c78839a70074fd86afefe67.png', '36394', '1545979296', '1545979296');
INSERT INTO `wja_file` VALUES ('17', 'Fv9D5bhgV_UnboOIIbCZsz6BY-XX', 'api_idcard20181228144309_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.sjLnWmnV4rOA70757369d999833ae5058022b6c713e9.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181228144309_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.sjLnWmnV4rOA70757369d999833ae5058022b6c713e9.png', 'wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.sjLnWmnV4rOA70757369d999833ae5058022b6c713e9.png', '120035', '1545979389', '1545979389');
INSERT INTO `wja_file` VALUES ('18', 'FguyMqhlVR27HsxRQ2HJuY6NvXxR', 'api_idcard20181228144312_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.sH4001ty7Gbnc632573c2d087a4be218e2d64b107fc7.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181228144312_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.sH4001ty7Gbnc632573c2d087a4be218e2d64b107fc7.png', 'wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.sH4001ty7Gbnc632573c2d087a4be218e2d64b107fc7.png', '60186', '1545979392', '1545979392');
INSERT INTO `wja_file` VALUES ('19', 'FpoKXYwU9PKSYyWgHfazBp5zel6d', 'api_idcard20181228153656_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.Kju7hT37oUot9625ec3dbf8ad1868896abe693cb23cf.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181228153656_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.Kju7hT37oUot9625ec3dbf8ad1868896abe693cb23cf.png', 'wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.Kju7hT37oUot9625ec3dbf8ad1868896abe693cb23cf.png', '47569', '1545982616', '1545982616');
INSERT INTO `wja_file` VALUES ('20', 'Fm1r6gWmhOT2f6sNXb18hS5FYvw_', 'api_idcard20181228153700_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.81D813WTjWpI9458aad2032e2da5880f50305e64a561.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181228153700_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.81D813WTjWpI9458aad2032e2da5880f50305e64a561.png', 'wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.81D813WTjWpI9458aad2032e2da5880f50305e64a561.png', '66235', '1545982621', '1545982621');
INSERT INTO `wja_file` VALUES ('21', 'FisO-vXczf5Iwk4DC8RslvESldqb', 'api_idcard20181228154016_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.75amiVXmovK2931803610bbcbbf010fd9afa85fb6677.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181228154016_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.75amiVXmovK2931803610bbcbbf010fd9afa85fb6677.png', 'wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.75amiVXmovK2931803610bbcbbf010fd9afa85fb6677.png', '314054', '1545982816', '1545982816');
INSERT INTO `wja_file` VALUES ('22', 'FvAeY9EBt0M5WpcGYkCQJBXlUQIF', 'api_idcard20181228154022_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.9lxnLz2rbdvd7b4e25e42e77944c65dd00ae2ba1f3ca.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181228154022_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.9lxnLz2rbdvd7b4e25e42e77944c65dd00ae2ba1f3ca.png', 'wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.9lxnLz2rbdvd7b4e25e42e77944c65dd00ae2ba1f3ca.png', '39849', '1545982823', '1545982823');
INSERT INTO `wja_file` VALUES ('23', 'FjPxvaXeg9xdpqW6wMxUtQs0hwAJ', 'api_idcard20181228154246_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.Hz5AE2q5ruPb517ce3716134615ba05feee6ff1d2c9b.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181228154246_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.Hz5AE2q5ruPb517ce3716134615ba05feee6ff1d2c9b.png', 'wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.Hz5AE2q5ruPb517ce3716134615ba05feee6ff1d2c9b.png', '42889', '1545982966', '1545982966');
INSERT INTO `wja_file` VALUES ('24', 'FmPAQk5b5VgFQMAQsMjb-_ziI1Zq', 'api_idcard20181228154249_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.OgxSP5qnbydJ2afb76b2847aaffb662b0e5b478f40a2.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181228154249_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.OgxSP5qnbydJ2afb76b2847aaffb662b0e5b478f40a2.png', 'wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.OgxSP5qnbydJ2afb76b2847aaffb662b0e5b478f40a2.png', '49003', '1545982969', '1545982969');
INSERT INTO `wja_file` VALUES ('25', 'FqAewyaOnQ4dpwK3F6_V5EBNu0KI', 'api_idcard20181228161717_wx06b088dbc933d613.o6zAJszlz6qiRFZVQ_cJgToWLKbE.ahXjEC293MWi5830128093f94e27a03f24b8ea29bc05.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181228161717_wx06b088dbc933d613.o6zAJszlz6qiRFZVQ_cJgToWLKbE.ahXjEC293MWi5830128093f94e27a03f24b8ea29bc05.png', 'wx06b088dbc933d613.o6zAJszlz6qiRFZVQ_cJgToWLKbE.ahXjEC293MWi5830128093f94e27a03f24b8ea29bc05.png', '74247', '1545985040', '1545985040');
INSERT INTO `wja_file` VALUES ('26', 'FikIpdadjRFucDfT5A0M-2HFJBu0', 'api_idcard20181228171724_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.3EKU6r52nshsfb6320c65a8d369777b4139362cf4596.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181228171724_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.3EKU6r52nshsfb6320c65a8d369777b4139362cf4596.png', 'wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.3EKU6r52nshsfb6320c65a8d369777b4139362cf4596.png', '72508', '1545988644', '1545988644');
INSERT INTO `wja_file` VALUES ('27', 'Ft5Czl_l8Bw2xfuB_yk0eT07U6JG', 'api_idcard20181229090754_tmp_3f4af389bd4691fa2ba982b6067a98387976f518d71be770.jpg', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181229090754_tmp_3f4af389bd4691fa2ba982b6067a98387976f518d71be770.jpg', 'tmp_3f4af389bd4691fa2ba982b6067a98387976f518d71be770.jpg', '1380223', '1546045676', '1546045676');
INSERT INTO `wja_file` VALUES ('28', 'FnIlgXdFAnAT_jbx20DY39YwIl4X', 'api_idcard20181229102146_tmp_6de0634cca7c87a5f5a89f2e9fe2dcdd8d5e2636fa3652be.jpg', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181229102146_tmp_6de0634cca7c87a5f5a89f2e9fe2dcdd8d5e2636fa3652be.jpg', 'tmp_6de0634cca7c87a5f5a89f2e9fe2dcdd8d5e2636fa3652be.jpg', '45172', '1546050106', '1546050106');
INSERT INTO `wja_file` VALUES ('29', 'FoG02cKJ7gqsH1ncHTMD6cFNkLPI', 'api_idcard20181229102152_tmp_5772276f2bcec178f4569012cec5355f53975f432de7fbe8.jpg', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/api_idcard20181229102152_tmp_5772276f2bcec178f4569012cec5355f53975f432de7fbe8.jpg', 'tmp_5772276f2bcec178f4569012cec5355f53975f432de7fbe8.jpg', '133579', '1546050112', '1546050112');
INSERT INTO `wja_file` VALUES ('30', 'FhUYhfMPC2OfanQy-MFOpayRt6CN', 'store_20181229103139_adsdqweqw.png', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/store_20181229103139_adsdqweqw.png', 'adsdqweqw.png', '1681', '1546050699', '1546050699');
INSERT INTO `wja_file` VALUES ('31', 'FlKAxrxFi3mF_5yynXvHnXwEqrDN', 'store_20181229171104_demo-pic33.jpg', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/store_20181229171104_demo-pic33.jpg', 'demo-pic33.jpg', '76939', '1546074664', '1546074664');
INSERT INTO `wja_file` VALUES ('32', 'FtqXygMKNir9iaiNy2uWBAw6sZ0b', 'store_20181229171126_demo-pic34.jpg', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/store_20181229171126_demo-pic34.jpg', 'demo-pic34.jpg', '30568', '1546074686', '1546074686');
INSERT INTO `wja_file` VALUES ('33', 'FuZmBgRlBEVFVvTpfBDBEFS_ojvn', 'store_20181229171129_demo-pic60.jpg', 'img.zxjsj.zhidekan.me', 'http://img.zxjsj.zhidekan.me/store_20181229171129_demo-pic60.jpg', 'demo-pic60.jpg', '61734', '1546074689', '1546074689');

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
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

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
INSERT INTO `wja_form_model` VALUES ('16', '商户操作审核表', 'store_action_record', '', '1', '0', null, '1546072765', '1546072765');
INSERT INTO `wja_form_model` VALUES ('17', '商户表', 'store', '用户入驻审核列表显示', '1', '0', null, '1546072803', '1546072803');

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
) ENGINE=MyISAM AUTO_INCREMENT=124 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_form_table
-- ----------------------------
INSERT INTO `wja_form_table` VALUES ('1', '1', '', '编号', '60', '3', '', '', '10', '1', '0', '0', '0', '1544012686', '1544013483');
INSERT INTO `wja_form_table` VALUES ('2', '1', 'icon', '图标', '50', '4', 'icon', '', '20', '1', '0', '0', '0', '1544012981', '1544013469');
INSERT INTO `wja_form_table` VALUES ('3', '1', 'title', '节点名称', '*', '1', null, '', '30', '1', '0', '0', '0', '1544061627', '1544780228');
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
INSERT INTO `wja_form_table` VALUES ('14', '3', 'group_type', '角色分组', '150', '2', null, 'get_group_type', '20', '1', '0', '0', '0', '1544096342', '1544096342');
INSERT INTO `wja_form_table` VALUES ('15', '3', 'name', '角色名称', '*', '1', null, '', '30', '1', '0', '0', '0', '1544096365', '1544096365');
INSERT INTO `wja_form_table` VALUES ('16', '4', '', '编号', '60', '3', null, '', '10', '1', '0', '0', '0', '1544098612', '1544098612');
INSERT INTO `wja_form_table` VALUES ('17', '4', 'sname', '商户名称', '130', '1', null, '', '20', '1', '0', '0', '0', '1544098638', '1546072557');
INSERT INTO `wja_form_table` VALUES ('18', '4', 'gname', '角色名称', '*', '1', null, '', '30', '1', '0', '0', '0', '1544098666', '1544098666');
INSERT INTO `wja_form_table` VALUES ('19', '4', 'username', '登录用户名', '*', '1', null, '', '40', '1', '0', '0', '0', '1544098711', '1544098711');
INSERT INTO `wja_form_table` VALUES ('20', '4', 'phone', '联系电话', '120', '1', null, '', '50', '1', '0', '0', '0', '1544098739', '1544098739');
INSERT INTO `wja_form_table` VALUES ('21', '5', '', '编号', '60', '3', null, '', '10', '1', '0', '0', '0', '1544099072', '1544099072');
INSERT INTO `wja_form_table` VALUES ('22', '5', 'goods_cate', '产品类别', '*', '2', null, 'get_goods_cate', '30', '1', '0', '0', '0', '1544099112', '1544406652');
INSERT INTO `wja_form_table` VALUES ('23', '5', 'cate_name', '产品分类', '100', '1', null, '', '30', '1', '0', '0', '0', '1544099141', '1544099141');
INSERT INTO `wja_form_table` VALUES ('24', '5', 'name', '产品名称', '*', '1', null, '', '20', '1', '0', '0', '0', '1544099174', '1544406856');
INSERT INTO `wja_form_table` VALUES ('25', '5', 'goods_type', '产品类型', '100', '2', null, 'goodstype', '50', '1', '0', '0', '1', '1544099237', '1544099237');
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
INSERT INTO `wja_form_table` VALUES ('62', '11', 'service_count', '服务次数', '80', '1', null, '', '60', '1', '0', '0', '0', '1544150166', '1544672886');
INSERT INTO `wja_form_table` VALUES ('63', '11', 'realname', '真实姓名', '100', '1', null, '', '40', '1', '0', '0', '0', '1544150207', '1544260727');
INSERT INTO `wja_form_table` VALUES ('64', '11', 'phone', '联系电话', '150', '1', null, '', '50', '1', '0', '0', '0', '1544150234', '1544260732');
INSERT INTO `wja_form_table` VALUES ('65', '11', 'user_id', '绑定小程序', '100', '2', null, 'yorn', '100', '1', '0', '0', '1', '1544150592', '1544672879');
INSERT INTO `wja_form_table` VALUES ('66', '12', '', '编号', '60', '3', null, '', '10', '1', '0', '0', '0', '1544100500', '1544100500');
INSERT INTO `wja_form_table` VALUES ('67', '12', 'order_sn', '订单编号', '*', '1', null, '', '20', '1', '0', '0', '0', '1544100538', '1544100538');
INSERT INTO `wja_form_table` VALUES ('68', '12', 'gname', '商品名称', '*', '1', null, '', '20', '1', '0', '0', '0', '1544100572', '1544100572');
INSERT INTO `wja_form_table` VALUES ('69', '12', 'sname', '零售商名称', '*', '1', null, '', '30', '1', '0', '0', '0', '1544100592', '1544101029');
INSERT INTO `wja_form_table` VALUES ('70', '12', 'order_amount', '订单金额', '80', '1', null, '', '40', '1', '0', '0', '0', '1544100610', '1544100610');
INSERT INTO `wja_form_table` VALUES ('71', '12', 'commission_ratio', '佣金百分比', '100', '1', null, '', '70', '1', '0', '0', '0', '1544100633', '1544754053');
INSERT INTO `wja_form_table` VALUES ('72', '12', 'income_amount', '佣金金额', '80', '1', null, '', '80', '1', '0', '0', '0', '1544100654', '1544754075');
INSERT INTO `wja_form_table` VALUES ('73', '12', 'add_time', '交易时间', '120', '2', null, 'time_to_date', '90', '1', '0', '0', '0', '1544100679', '1544754080');
INSERT INTO `wja_form_table` VALUES ('74', '12', 'commission_status', '佣金状态', '*', '2', null, 'get_commission_status', '60', '1', '0', '0', '0', '1544151698', '1544151720');
INSERT INTO `wja_form_table` VALUES ('75', '10', 'region_name', '服务区域', '*', '1', null, '', '60', '1', '0', '0', '0', '1544257088', '1544257098');
INSERT INTO `wja_form_table` VALUES ('76', '10', 'security_money', '保证金金额', '*', '1', null, '', '70', '1', '0', '0', '0', '1544257131', '1544257131');
INSERT INTO `wja_form_table` VALUES ('77', '11', 'check_status', '工程师状态', '*', '2', null, 'get_installer_status', '90', '1', '0', '0', '0', '1544260762', '1544672875');
INSERT INTO `wja_form_table` VALUES ('78', '13', 'order_sn', '订单号', '120', '1', null, '', '10', '1', '0', '0', '0', '1544424456', '1544424456');
INSERT INTO `wja_form_table` VALUES ('79', '13', 'sku_name', '商品名称', '*', '1', null, '', '30', '1', '0', '0', '0', '1544424490', '1544424682');
INSERT INTO `wja_form_table` VALUES ('80', '13', 'num', '商品数量', '80', '1', null, '', '40', '1', '0', '0', '0', '1544424598', '1544424688');
INSERT INTO `wja_form_table` VALUES ('81', '13', 'refund_amount', '退款金额', '80', '1', null, '', '50', '1', '0', '0', '0', '1544424617', '1544424719');
INSERT INTO `wja_form_table` VALUES ('82', '13', 'service_type', '售后类型', '120', '2', null, 'get_service_type', '20', '1', '0', '0', '1', '1544424651', '1544433133');
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
INSERT INTO `wja_form_table` VALUES ('96', '15', 'store_type', '可见商户', '*', '2', null, 'get_store_type', '30', '1', '0', '0', '0', '1544522896', '1544597446');
INSERT INTO `wja_form_table` VALUES ('97', '15', 'is_top', '是否置顶', '100', '2', null, 'get_status', '40', '1', '0', '0', '0', '1544523287', '1544524998');
INSERT INTO `wja_form_table` VALUES ('98', '15', 'publish_status', '发布状态', '100', '2', null, 'get_publish_status', '50', '1', '0', '0', '0', '1544523514', '1544523520');
INSERT INTO `wja_form_table` VALUES ('99', '15', '', '编号', '60', '3', null, '', '1', '1', '0', '0', '0', '1544523549', '1544523549');
INSERT INTO `wja_form_table` VALUES ('100', '15', 'description', '公告描述', '*', '1', null, '', '20', '1', '0', '0', '0', '1544524911', '1544524918');
INSERT INTO `wja_form_table` VALUES ('101', '11', 'score', '综合得分', '80', '1', null, '', '80', '1', '0', '0', '0', '1544672582', '1544672871');
INSERT INTO `wja_form_table` VALUES ('102', '11', 'assess_detail', '服务评分', '*', '1', null, '', '70', '1', '0', '0', '1', '1544672668', '1544672865');
INSERT INTO `wja_form_table` VALUES ('103', '12', 'refund_amount', '订单退款金额', '120', '1', null, '', '50', '1', '0', '0', '0', '1544754025', '1544754036');
INSERT INTO `wja_form_table` VALUES ('104', '8', 'store_no', '渠道商编号', '100', '1', null, '', '20', '1', '0', '0', '0', '1545813452', '1545813452');
INSERT INTO `wja_form_table` VALUES ('105', '13', 'pay_code', '支付方式', '80', '1', null, '', '90', '1', '0', '0', '0', '1545900829', '1545900829');
INSERT INTO `wja_form_table` VALUES ('106', '16', '', '编号', '60', '3', '', '', '10', '1', '0', '0', '0', '1545905710', '1545905710');
INSERT INTO `wja_form_table` VALUES ('107', '16', 'name', '操作商户名称', '*', '1', '', '', '20', '1', '0', '0', '0', '1545905740', '1545905740');
INSERT INTO `wja_form_table` VALUES ('108', '16', 'to_store_name', '被操作商户名称', '*', '1', '', '', '30', '1', '0', '0', '0', '1545905773', '1545905773');
INSERT INTO `wja_form_table` VALUES ('109', '16', 'add_time', '操作时间', '120', '2', '', 'time_to_date', '60', '1', '0', '0', '0', '1545905803', '1545965487');
INSERT INTO `wja_form_table` VALUES ('110', '16', 'check_status', '审核状态', '100', '2', '', 'get_check_status', '50', '1', '0', '0', '0', '1545905835', '1545905835');
INSERT INTO `wja_form_table` VALUES ('111', '16', 'check_time', '审核时间', '120', '2', '', 'time_to_date', '80', '1', '0', '0', '0', '1545905860', '1545965497');
INSERT INTO `wja_form_table` VALUES ('112', '16', 'remark', '审核备注', '*', '1', '', '', '70', '1', '0', '0', '0', '1545905881', '1545905881');
INSERT INTO `wja_form_table` VALUES ('113', '16', 'action_type', '操作类型', '100', '2', '', 'get_action_type', '40', '1', '0', '0', '0', '1545906151', '1545906151');
INSERT INTO `wja_form_table` VALUES ('114', '17', '', '编号', '60', '3', null, '', '10', '1', '0', '0', '0', '1546072828', '1546072828');
INSERT INTO `wja_form_table` VALUES ('115', '17', 'store_type', '商户类型', '120', '2', null, 'get_store_type', '20', '1', '0', '0', '0', '1546072846', '1546072851');
INSERT INTO `wja_form_table` VALUES ('116', '17', 'name', '商户名称', '*', '1', null, '', '30', '1', '0', '0', '0', '1546072865', '1546072865');
INSERT INTO `wja_form_table` VALUES ('117', '17', 'region_name', '负责区域', '*', '1', null, '', '40', '1', '0', '0', '0', '1546072899', '1546072899');
INSERT INTO `wja_form_table` VALUES ('118', '17', 'security_money', '缴纳保证金金额', '140', '1', null, '', '50', '1', '0', '0', '0', '1546072921', '1546072921');
INSERT INTO `wja_form_table` VALUES ('119', '17', 'user_name', '联系人姓名', '100', '1', null, '', '60', '1', '0', '0', '0', '1546072946', '1546072946');
INSERT INTO `wja_form_table` VALUES ('120', '17', 'mobile', '联系人电话', '120', '1', null, '', '70', '1', '0', '0', '0', '1546072963', '1546072963');
INSERT INTO `wja_form_table` VALUES ('121', '17', 'add_time', '申请时间', '160', '1', null, '', '80', '1', '0', '0', '0', '1546072978', '1546072978');
INSERT INTO `wja_form_table` VALUES ('122', '17', 'check_status', '审核状态', '80', '2', null, 'get_check_status', '90', '1', '0', '0', '0', '1546072999', '1546072999');
INSERT INTO `wja_form_table` VALUES ('123', '9', 'store_no', '零售商编号', '100', '1', '', '', '20', '1', '0', '0', '0', '1545813452', '1545813452');

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
  `cate_thumb` varchar(255) NOT NULL DEFAULT '',
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
  `stock_warning_num` int(1) unsigned NOT NULL DEFAULT '0' COMMENT '库存预警值',
  PRIMARY KEY (`goods_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='产品表';

-- ----------------------------
-- Records of wja_goods
-- ----------------------------
INSERT INTO `wja_goods` VALUES ('1', '1', '2', '1', '2', '无规格样品测试', '11111111', '', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181206174545_basicprofile.jpg', '[\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181206174545_basicprofile.jpg\"]', '19.90', '19.90', '0.00', '10', '', '		                  			                  			                  			                  			                  			                  			                  		                  		                  		                  		                  		                  ', '2', '1', '1', '1', '1544089567', '1545296581', null, '1', '5', '0');
INSERT INTO `wja_goods` VALUES ('2', '1', '2', '1', '2', '有规格样品测试', '22222222', '', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181206174545_basicprofile.jpg', '[\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181206174545_basicprofile.jpg\"]', '9.90', '15.00', '0.00', '20', '', '		                  			                  			                  			                  			                  		                  		                  		                  ', '1', '1', '1', '1', '1544089826', '1545296582', '[{\"specid\":\"1\",\"specname\":\"容量\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"颜色\",\"list\":[\"黑色\",\"灰色\"]}]', '2', '1', '0');
INSERT INTO `wja_goods` VALUES ('3', '1', '2', '1', '1', '无规格普通商品', '33333333', '', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181206174545_basicprofile.jpg', '[\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181206174545_basicprofile.jpg\"]', '12.20', '12.20', '120.00', '4', '', '		                  			                  			                  			                  			                  		                  		                  		                  ', '10', '1', '1', '1', '1544089910', '1545296584', null, '1', '0', '0');
INSERT INTO `wja_goods` VALUES ('4', '1', '2', '1', '1', '有规格普通商品测试', '44444444', '', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181206174545_basicprofile.jpg', '[\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181206174545_basicprofile.jpg\"]', '10.00', '12.50', '100.00', '39', '', '		                  			                  ', '10', '1', '1', '1', '1544089950', '1545296585', '[{\"specid\":\"1\",\"specname\":\"容量\",\"list\":[\"32G\",\"64G\"]},{\"specid\":\"2\",\"specname\":\"颜色\",\"list\":[\"黑色\",\"灰色\"]}]', '2', '0', '0');
INSERT INTO `wja_goods` VALUES ('5', '1', '2', '1', '1', '1222333', '', '', '', '', '0.00', '0.00', '300.00', '0', '', '', '0', '1', '1', '1', '1544781604', '1544781642', null, '1', '0', '0');
INSERT INTO `wja_goods` VALUES ('6', '1', '2', '1', '2', '支付测试', '', '', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181217154858.png?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '[\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181217154858.png?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"]', '0.01', '0.01', '0.00', '99', '', '<img src=\"http://pimvhcf3v.bkt.clouddn.com/goods_editor_20181220110453_zxjlogo.jpg\" alt=\"\" />', '6', '1', '1', '1', '1545032840', '1545296587', null, '1', '10', '0');
INSERT INTO `wja_goods` VALUES ('7', '1', '3', '1', '1', '万佳安智能门锁', '1102022155', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181220160154.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181220155827.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '[\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220155827.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220155836.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220155846.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220155850.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"]', '0.02', '0.02', '0.01', '2498', '这里是产品描述', '		                  	这里是产品详情这里是产品详情<br />\r\n这里是产品详情<br />\r\n这里是产品详情<br />\r\n这里是产品详情<br />\r\n这里是产品详情<br />\r\n这里是产品详情<br />\r\n这里是产品详情<br />\r\n这里是产品详情<br />\r\n这里是产品详情<br />\r\n这里是产品详情<br />\r\n这里是产品详情<br />\r\n这里是产品详情<br />\r\n这里是产品详情<br />\r\n这里是产品详情<br />\r\n这里是产品详情<br />\r\n这里是产品详情<br />\r\n这里是产品详情<br />\r\n<p>\r\n	这里是产品详情\r\n</p>\r\n<p>\r\n	<img src=\"http://pimvhcf3v.bkt.clouddn.com/goods_editor_20181220160217.jpg\" alt=\"\" />\r\n</p>\r\n<br />		                  ', '2', '1', '1', '1', '1545292802', '1545296591', null, '1', '0', '2');
INSERT INTO `wja_goods` VALUES ('8', '1', '2', '1', '1', 'I9  PLUS   黑色', '001', 'http://img.zxjsj.zhidekan.me/goods_20181228144529_2.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', 'http://img.zxjsj.zhidekan.me/goods_20181224103921_2.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103921_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"]', '0.01', '0.01', '0.01', '995', '多种智能开门方式，再也不怕忘带钥匙。全方位防范，安全有保障。亲情互动，开启智慧到家新体验。轻松管理，操作方便...', '		                  			                  			                  	<p class=\"MsoBodyText\" style=\"margin-left:21.15pt;\" align=\"center\">\r\n	多种智能开门方式，再也不怕忘带钥匙\r\n</p>\r\n<p class=\"16\" style=\"margin-left:39.2pt;\" align=\"center\">\r\n	1. 指纹开锁；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:39.2pt;\" align=\"center\">\r\n	2. 密码开锁；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:39.2pt;\" align=\"center\">\r\n	3. 刷卡开锁；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:39.2pt;\" align=\"center\">\r\n	4. 钥匙开锁；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:39.2pt;\" align=\"center\">\r\n	5. APP开锁；\r\n</p>\r\n<p class=\"MsoBodyText\" style=\"margin-left:21.15pt;\" align=\"center\">\r\n	全方位防范，安全有保障\r\n</p>\r\n<p class=\"16\" style=\"margin-left:39.2pt;\" align=\"center\">\r\n	1. FPC半导体活体自学习指纹识别，越用越灵敏，杜绝假指纹；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:39.2pt;\" align=\"center\">\r\n	2. 虚位密码，不怕偷窥；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:39.2pt;\" align=\"center\">\r\n	3. 双重验证安全开锁模式（指纹/密码/刷卡，任意两种组合开门）；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:39.2pt;\" align=\"center\">\r\n	4. 尝试解锁时系统锁定、本地报警、信息推送至APP、手机短信；\r\n</p>\r\n<p class=\"MsoNormal\" align=\"center\">\r\n	             5.防撬锁本地报警、信息推送至APP、手机短信\r\n</p>\r\n<p class=\"MsoNormal\" align=\"center\">\r\n	             6.胁迫开锁密码和指纹，隐蔽报警，信息推送至APP，同时给设定号码拨打电话\r\n</p>\r\n<p class=\"MsoNormal\" align=\"center\">\r\n	<p class=\"15\" style=\"margin-left:415.1pt;text-align:left;\">\r\n		7. 自动锁定时长灵活定义，防尾随；\r\n	</p>\r\n	<p class=\"15\" style=\"margin-left:415.1pt;text-align:left;\">\r\n		8. 室内把手防猫眼开锁设计；\r\n	</p>\r\n	<p class=\"15\" style=\"margin-left:415.1pt;text-align:left;\">\r\n		9. PIR人体检测，室外异常主动防范，信息推送至APP提醒查看； \r\n	</p>\r\n	<p class=\"MsoNormal\">\r\n		10. 智能猫眼，可视对讲远程开锁更安全；\r\n	</p>\r\n	<p class=\"MsoNormal\">\r\n		   11.智能联动：离家布防、回家撤防、联动策略\r\n	</p>\r\n</p>\r\n<p class=\"MsoNormal\" align=\"center\">\r\n	 亲情互动，开启智慧到家新体验\r\n	<p class=\"15\" style=\"margin-left:415.1pt;text-align:left;\">\r\n		1. 语音留言、备忘提醒，给她惊喜、表达温情；\r\n	</p>\r\n	<p class=\"15\" style=\"margin-left:415.1pt;text-align:left;\">\r\n		2. 家人到家，实时提醒；\r\n	</p>\r\n	<p class=\"15\" style=\"margin-left:415.1pt;text-align:left;\">\r\n		3. 远程授权临时密码，可轻松应对临时到访；\r\n	</p>\r\n	<p class=\"15\" style=\"margin-left:397.1pt;text-align:left;\">\r\n		4. 温馨问候：“值管家欢迎你！”； 轻松管理，操作方便\r\n	</p>\r\n	<p class=\"15\" style=\"margin-left:415.1pt;text-align:left;\">\r\n		1. APP管理，轻松掌握；\r\n	</p>\r\n	<p class=\"15\" style=\"margin-left:415.1pt;text-align:left;\">\r\n		2. 指纹验证、开门一步到位；\r\n	</p>\r\n	<p class=\"15\" style=\"margin-left:415.1pt;text-align:left;\">\r\n		3. 室内把手上提反锁，下压开门；\r\n	</p>\r\n	<p class=\"15\" style=\"margin-left:415.1pt;text-align:left;\">\r\n		4. 支持各种NFC卡写入绑定，如身份证、公交卡、门禁卡等；\r\n	</p>\r\n	<p class=\"15\" style=\"margin-left:397.1pt;text-align:left;\">\r\n		5. 电子门铃； 其它实用功能\r\n	</p>\r\n	<p class=\"15\" style=\"margin-left:415.1pt;text-align:left;\">\r\n		1. 超低功耗，12个月长续航；\r\n	</p>\r\n	<p class=\"15\" style=\"margin-left:415.1pt;text-align:left;\">\r\n		2. 低电提醒，USB应急供电；\r\n	</p>\r\n	<p class=\"15\" style=\"margin-left:415.1pt;text-align:left;\">\r\n		3. 钢化玻璃面板，特殊处理不留指纹； \r\n	</p>\r\n	<p class=\"15\" style=\"margin-left:415.1pt;text-align:left;\">\r\n		4. C级锁芯，国家标准；\r\n	</p>\r\n	<p class=\"MsoNormal\" style=\"text-align:left;\">\r\n		<br />\r\n	</p>\r\n<br />\r\n<b><span style=\"font-family:微软雅黑;color:#BCD6ED;font-weight:bold;font-size:8.0000pt;\"> </span></b>\r\n</p>\r\n<span style=\"font-family:微软雅黑;font-size:11.0000pt;\"></span><span style=\"font-family:微软雅黑;font-weight:bold;font-size:11.0000pt;\"><span></span></span>		                  		                  		                  ', '6', '1', '1', '0', '1545297109', '1545979530', '[{\"specid\":\"1\",\"specname\":\"容量\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"颜色\",\"list\":[\"黑色\"]},{\"specid\":\"3\",\"specname\":\"大小\",\"list\":[\"大\"]}]', '1', '0', '10');
INSERT INTO `wja_goods` VALUES ('9', '1', '2', '1', '1', 'I9 黑色', '002', 'http://img.zxjsj.zhidekan.me/goods_20181228144523_3.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', 'http://img.zxjsj.zhidekan.me/goods_20181224103909_3.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103909_3.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"]', '0.01', '0.01', '0.01', '996', '多种智能开门方式，再也不怕忘带钥匙。全方位防范，安全有保。亲情互动，开启智慧到家新体验。轻松管理，操作方便', '		                  			                  			                  	<div class=\"Section0\" align=\"center\">\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		多种智能开门方式，再也不怕忘带钥匙\r\n	</p>\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		1. 指纹开锁；\r\n	</p>\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		2. 密码开锁；\r\n	</p>\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		3. 刷卡开锁；\r\n	</p>\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		4. 钥匙开锁；\r\n	</p>\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		5. APP开锁；\r\n	</p>\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		全方位防范，安全有保\r\n	</p>\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		1. FPC半导体活体自学习指纹识别，越用越灵敏，杜绝假指纹；\r\n	</p>\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		2. 虚位密码，不怕偷窥；\r\n	</p>\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		3. 双重验证安全开锁模式（指纹/密码/刷卡，任意两种组合开门）；\r\n	</p>\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		4. 尝试解锁时系统锁定、本地报警、信息推送至APP、手机短信；\r\n	</p>\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		5. 防撬锁本地报警、信息推送至APP、手机短信 ；\r\n	</p>\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		6. 胁迫开锁密码和指纹，隐蔽报警，信息推送至APP，同时给设定号码拨打电话；\r\n	</p>\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		7. 自动锁定时长灵活定义，防尾随；\r\n	</p>\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		8. 室内把手防猫眼开锁设计；\r\n	</p>\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		9. 智能联动：离家布防、回家撤防、联动策略；\r\n	</p>\r\n	<p class=\"16\" style=\"margin-left:397.1pt;\">\r\n		亲情互动，开启智慧到家新体验\r\n	</p>\r\n</div>\r\n<p class=\"16\" style=\"margin-left:415.1pt;\" align=\"center\">\r\n	1. 语音留言、备忘提醒，给她惊喜、表达温情（网关播放）；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:415.1pt;\" align=\"center\">\r\n	2. 家人到家，实时提醒；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:415.1pt;\" align=\"center\">\r\n	3. 远程授权临时密码，可轻松应对临时到访；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:397.1pt;\" align=\"center\">\r\n	4. 温馨问候：“值管家欢迎你！”；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:397.1pt;\" align=\"center\">\r\n	轻松管理，操作方便\r\n</p>\r\n<p class=\"16\" style=\"margin-left:415.1pt;\" align=\"center\">\r\n	1. APP管理，轻松掌握；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:415.1pt;\" align=\"center\">\r\n	2. 指纹验证、开门一步到位；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:415.1pt;\" align=\"center\">\r\n	3. 室内把手上提反锁，下压开门；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:415.1pt;\" align=\"center\">\r\n	4. 支持各种NFC卡写入绑定，如身份证、公交卡、门禁卡等；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:397.1pt;\" align=\"center\">\r\n	5. 电子门铃；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:397.1pt;\" align=\"center\">\r\n	其它实用功能\r\n</p>\r\n<p class=\"16\" style=\"margin-left:415.1pt;\" align=\"center\">\r\n	1. 超低功耗，12个月长续航；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:415.1pt;\" align=\"center\">\r\n	2. 低电提醒，USB应急供电；\r\n</p>\r\n<p class=\"16\" style=\"margin-left:415.1pt;\" align=\"center\">\r\n	3. 钢化玻璃面板，特殊处理不留指纹； \r\n</p>\r\n<p class=\"16\" style=\"margin-left:415.1pt;\" align=\"center\">\r\n	4. C级锁芯，国家标准；\r\n</p>\r\n<p class=\"MsoNormal\" align=\"center\">\r\n	<br />\r\n</p>\r\n<div align=\"center\">\r\n	<br />\r\n</div>		                  		                  		                  ', '4', '1', '1', '0', '1545298348', '1545979524', '[{\"specid\":\"1\",\"specname\":\"容量\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"颜色\",\"list\":[\"黑色\"]},{\"specid\":\"3\",\"specname\":\"大小\",\"list\":[\"大\"]}]', '1', '0', '11');
INSERT INTO `wja_goods` VALUES ('10', '1', '2', '1', '1', 'Q7   土豪金+黑灰色', '003', 'http://img.zxjsj.zhidekan.me/goods_20181228144516_1.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', 'http://img.zxjsj.zhidekan.me/goods_20181224103901_2.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103901_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"]', '0.01', '0.01', '0.01', '993', '多种智能开门方式，再也不怕忘带钥匙。全方位防范，安全有保障。虚位密码，不怕偷窥；家人到家，实时提醒；', '		                  			                  			                  	<div align=\"center\">\r\n	多种智能开门方式，再也不怕忘带钥匙<br />\r\n1. 指纹开锁；<br />\r\n2. 密码开锁；<br />\r\n3. 刷卡开锁；<br />\r\n4. 钥匙开锁；<br />\r\n5. APP开锁；<br />\r\n全方位防范，安全有保障<br />\r\n1. FPC半导体活体自学习指纹识别，越用越灵敏，杜绝假指纹；<br />\r\n2. 虚位密码，不怕偷窥；<br />\r\n3. 双重验证安全开锁模式（指纹/密码/刷卡，任意两种组合开门）；<br />\r\n4. 尝试解锁时系统锁定、本地报警、信息推送至APP、手机短信；<br />\r\n5. 防撬锁本地报警、信息推送至APP、手机短信 ；<br />\r\n6. 胁迫开锁密码和指纹，隐蔽报警，信息推送至APP，同时给设定号码拨打电话；<br />\r\n7. 自动锁定时长灵活定义，防尾随；<br />\r\n8. 室内把手防猫眼开锁设计；<br />\r\n9. 智能联动：离家布防、回家撤防、联动策略；<br />\r\n亲情互动，开启智慧到家新体验<br />\r\n1. 语音留言、备忘提醒，给她惊喜、表达温情（网关播放）；★<br />\r\n2. 家人到家，实时提醒；<br />\r\n3. 远程授权临时密码，可轻松应对临时到访；<br />\r\n4. 温馨问候：“值管家欢迎你！”；<br />\r\n轻松管理，操作方便<br />\r\n1. APP管理，轻松掌握；<br />\r\n2. 指纹验证、开门一步到位；<br />\r\n3. 室内把手上提反锁，下压开门；<br />\r\n4. 支持各种NFC卡写入绑定，如身份证、公交卡、门禁卡等；<br />\r\n5. 电子门铃；<br />\r\n其它实用功能<br />\r\n1. 超低功耗，12个月长续航；<br />\r\n2. 低电提醒，USB应急供电；<br />\r\n3. 面板特殊处理不留指纹；<br />\r\n4. C级锁芯，国家标准；<span style=\"font-family:微软雅黑;font-size:11.0000pt;\"></span><span style=\"font-family:微软雅黑;font-size:11.0000pt;\"></span>\r\n</div>		                  		                  		                  ', '7', '1', '1', '0', '1545299493', '1545979517', '[{\"specid\":\"1\",\"specname\":\"容量\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"颜色\",\"list\":[\"黑色\",\"土豪金\"]},{\"specid\":\"3\",\"specname\":\"大小\",\"list\":[\"大\"]}]', '1', '0', '10');
INSERT INTO `wja_goods` VALUES ('11', '1', '2', '1', '1', 'L5  黑灰  香槟粉', '004', 'http://img.zxjsj.zhidekan.me/goods_20181228144510_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20190102172557_3.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20190102172557_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20190102172645_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20190102172645_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"]', '0.01', '0.01', '0.01', '1970', '多种智能开门方式，再也不怕忘带钥匙。全方位防范，安全有保障。亲情互动，开启智慧到家新体验。轻松管理，操作方便', '		                  			                  			                  			                  			                  			                  			                  	<div align=\"center\">\r\n	多种智能开门方式，再也不怕忘带钥匙<br />\r\n1. 指纹开锁；<br />\r\n2. 密码开锁；<br />\r\n3. 刷卡开锁；<br />\r\n4. 钥匙开锁；<br />\r\n5. APP开锁；<br />\r\n全方位防范，安全有保障<br />\r\n1. FPC半导体活体自学习指纹识别，越用越灵敏，杜绝假指纹；<br />\r\n2. 虚位密码，不怕偷窥；<br />\r\n3. 双重验证安全开锁模式（指纹/密码/刷卡，任意两种组合开门）；<br />\r\n4. 尝试解锁时系统锁定、本地报警、抓拍及信息推送至APP、手机短信；<br />\r\n5. 防撬锁本地报警、抓拍及信息推送至APP、手机短信 ；<br />\r\n6. 胁迫开锁密码和指纹，隐蔽报警，信息推送至APP，同时给设定号码拨打电话；<br />\r\n7. 自动锁定时长灵活定义，防尾随；<br />\r\n8. 室内把手防猫眼开锁设计；<br />\r\n9. 智能联动：离家布防、回家撤防、联动策略；<br />\r\n亲情互动，开启智慧到家新体验<br />\r\n1. 语音留言、备忘提醒，给她惊喜、表达温情（网关播放）；★<br />\r\n2. 家人到家，实时提醒；<br />\r\n3. 远程授权临时密码，可轻松应对临时到访；<br />\r\n4. 温馨问候：“值管家欢迎你！”；<br />\r\n轻松管理，操作方便<br />\r\n1. APP管理，轻松掌握；<br />\r\n2. 指纹验证、开门一步到位；<br />\r\n3. 室内把手上提反锁，下压开门；<br />\r\n4. 支持各种NFC卡写入绑定，如身份证、公交卡、门禁卡等；<br />\r\n5. 电子门铃；<br />\r\n其它实用功能<br />\r\n1. 超低功耗，12个月长续航；<br />\r\n2. 低电提醒，USB应急供电；<br />\r\n3. 面板特殊处理不留指纹；<br />\r\n4. C级锁芯，国家标准；\r\n</div>		                  		                  		                  		                  		                  		                  		                  ', '30', '1', '1', '0', '1545299688', '1546421212', '[{\"specid\":\"1\",\"specname\":\"容量\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"颜色\",\"list\":[\"黑色\",\"香槟粉\"]},{\"specid\":\"3\",\"specname\":\"大小\",\"list\":[\"大\"]}]', '1', '0', '10');

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
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='产品分类表';

-- ----------------------------
-- Records of wja_goods_cate
-- ----------------------------
INSERT INTO `wja_goods_cate` VALUES ('1', '2', '0', '摄像机', '1', '1', '1543289188', '1543303882', '0');
INSERT INTO `wja_goods_cate` VALUES ('2', '1', '0', '智能产品', '1', '1', '1543819999', '1543819999', '0');
INSERT INTO `wja_goods_cate` VALUES ('3', '1', '0', '食品', '1', '1', '1545292498', '1545292498', '0');

-- ----------------------------
-- Table structure for wja_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `wja_goods_sku`;
CREATE TABLE `wja_goods_sku` (
  `sku_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '商品规格ID',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '门店ID',
  `goods_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `goods_cate` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '产品类别(1标准产品 2零配件)',
  `goods_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '产品类型(1为标准产品 2为样品)',
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
) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_goods_sku
-- ----------------------------
INSERT INTO `wja_goods_sku` VALUES ('1', '1', '1', '1', '2', '', '11111111', '', '10', '', '', '19.90', '0.00', '1', '255', '1', '0', '0', '0', '1', '5');
INSERT INTO `wja_goods_sku` VALUES ('2', '1', '2', '1', '2', '', '2222222222', '', '10', '', '', '18.80', '0.00', '0', '255', '1', '1', '0', '1544089836', '1', '1');
INSERT INTO `wja_goods_sku` VALUES ('3', '1', '3', '1', '1', '', '33333333', '', '4', '', '', '12.20', '120.00', '10', '255', '1', '0', '0', '0', '1', '0');
INSERT INTO `wja_goods_sku` VALUES ('4', '1', '4', '1', '1', '', '44444444', '', '10', '', '', '16.78', '20.00', '0', '255', '1', '1', '0', '1544090025', '1', '0');
INSERT INTO `wja_goods_sku` VALUES ('5', '1', '4', '1', '1', '容量:32G 颜色:黑色 ', '44444444-1', '', '10', '32G;黑色', '{\"容量\":\"32G\",\"颜色\":\"黑色\"}', '12.50', '100.00', '0', '255', '1', '0', '0', '0', '2', '0');
INSERT INTO `wja_goods_sku` VALUES ('6', '1', '4', '1', '1', '容量:32G 颜色:灰色 ', '44444444-2', '', '9', '32G;灰色', '{\"容量\":\"32G\",\"颜色\":\"灰色\"}', '12.50', '100.00', '2', '255', '1', '0', '0', '0', '2', '0');
INSERT INTO `wja_goods_sku` VALUES ('7', '1', '4', '1', '1', '容量:64G 颜色:黑色 ', '44444444-3', '', '10', '64G;黑色', '{\"容量\":\"64G\",\"颜色\":\"黑色\"}', '12.50', '100.00', '5', '255', '1', '0', '0', '0', '2', '0');
INSERT INTO `wja_goods_sku` VALUES ('8', '1', '4', '1', '1', '容量:64G 颜色:灰色 ', '44444444-4', '', '10', '64G;灰色', '{\"容量\":\"64G\",\"颜色\":\"灰色\"}', '10.00', '100.00', '0', '255', '1', '0', '0', '0', '2', '0');
INSERT INTO `wja_goods_sku` VALUES ('9', '1', '2', '1', '2', '容量:32G 颜色:黑色 ', '22222222-1', '', '10', '32G;黑色', '{\"容量\":\"32G\",\"颜色\":\"黑色\"}', '9.90', '0.00', '1', '255', '1', '0', '0', '0', '2', '1');
INSERT INTO `wja_goods_sku` VALUES ('10', '1', '2', '1', '2', '容量:32G 颜色:灰色 ', '22222222-2', '', '10', '32G;灰色', '{\"容量\":\"32G\",\"颜色\":\"灰色\"}', '15.00', '0.00', '0', '255', '1', '0', '0', '0', '2', '1');
INSERT INTO `wja_goods_sku` VALUES ('11', '1', '5', '1', '1', '', '', '', '0', '', '', '0.00', '300.00', '0', '255', '1', '0', '0', '0', '1', '0');
INSERT INTO `wja_goods_sku` VALUES ('12', '1', '6', '1', '2', '', '', '', '99', '', '', '0.01', '0.00', '6', '255', '1', '0', '0', '0', '1', '10');
INSERT INTO `wja_goods_sku` VALUES ('13', '1', '7', '1', '1', '', '1102022155', '', '2498', '', '', '0.02', '0.01', '2', '255', '1', '0', '0', '0', '1', '0');
INSERT INTO `wja_goods_sku` VALUES ('14', '1', '8', '1', '1', '', '001', '', '1000', '', '', '0.01', '0.01', '1', '255', '1', '1', '0', '1545300067', '1', '0');
INSERT INTO `wja_goods_sku` VALUES ('15', '1', '9', '1', '1', '', '002', '', '1000', '', '', '0.01', '0.01', '0', '255', '1', '1', '0', '1545300060', '1', '0');
INSERT INTO `wja_goods_sku` VALUES ('16', '1', '10', '1', '1', '', '003', '', '1000', '', '', '0.01', '0.01', '0', '255', '1', '1', '0', '1545300052', '1', '0');
INSERT INTO `wja_goods_sku` VALUES ('17', '1', '11', '1', '1', '', '004', '', '1000', '', '', '0.01', '0.01', '0', '255', '1', '1', '0', '1545300040', '1', '0');
INSERT INTO `wja_goods_sku` VALUES ('18', '1', '11', '1', '1', '容量:32G 颜色:黑色 大小:大 ', '004-1', '', '990', '32G;黑色;大', '{\"容量\":\"32G\",\"颜色\":\"黑色\",\"大小\":\"大\"}', '0.01', '0.01', '10', '255', '1', '0', '0', '0', '1', '0');
INSERT INTO `wja_goods_sku` VALUES ('19', '1', '11', '1', '1', '容量:32G 颜色:香槟粉 大小:大 ', '004-2', '', '980', '32G;香槟粉;大', '{\"容量\":\"32G\",\"颜色\":\"香槟粉\",\"大小\":\"大\"}', '0.01', '0.01', '20', '255', '1', '0', '0', '0', '1', '0');
INSERT INTO `wja_goods_sku` VALUES ('20', '1', '10', '1', '1', '容量:32G 颜色:黑色 大小:大 ', '003-1', '', '1000', '32G;黑色;大', '{\"容量\":\"32G\",\"颜色\":\"黑色\",\"大小\":\"大\"}', '0.01', '0.01', '0', '255', '1', '1', '0', '1545300106', '1', '0');
INSERT INTO `wja_goods_sku` VALUES ('21', '1', '9', '1', '1', '容量:32G 颜色:黑色 大小:大 ', '002-1', '', '996', '32G;黑色;大', '{\"容量\":\"32G\",\"颜色\":\"黑色\",\"大小\":\"大\"}', '0.01', '0.01', '4', '255', '1', '0', '0', '0', '1', '0');
INSERT INTO `wja_goods_sku` VALUES ('22', '1', '8', '1', '1', '容量:32G 颜色:黑色 大小:大 ', '001-1', '', '995', '32G;黑色;大', '{\"容量\":\"32G\",\"颜色\":\"黑色\",\"大小\":\"大\"}', '0.01', '0.01', '5', '255', '1', '0', '0', '0', '1', '0');
INSERT INTO `wja_goods_sku` VALUES ('23', '1', '10', '1', '1', '容量:32G 颜色:土豪金 大小:大 ', '003-2', '', '993', '32G;土豪金;大', '{\"容量\":\"32G\",\"颜色\":\"土豪金\",\"大小\":\"大\"}', '0.01', '0.01', '7', '255', '1', '0', '0', '0', '1', '0');

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
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='产品规格表';

-- ----------------------------
-- Records of wja_goods_spec
-- ----------------------------
INSERT INTO `wja_goods_spec` VALUES ('1', '1', '容量', '32G,64G', '1', '1', '1543289267', '1543304199', '0');
INSERT INTO `wja_goods_spec` VALUES ('2', '1', '颜色', '黑色,灰色,香槟粉,土豪金', '1', '1', '1543820094', '1545300082', '0');
INSERT INTO `wja_goods_spec` VALUES ('3', '1', '大小', '大,中,小', '1', '1', '1545292535', '1545292535', '0');

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
  `code_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '验证码自增长id',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '通知发送商户ID',
  `phone` varchar(11) NOT NULL DEFAULT '' COMMENT '手机号',
  `code_type` varchar(25) NOT NULL DEFAULT '' COMMENT '验证码类型',
  `code` varchar(6) NOT NULL DEFAULT '' COMMENT '验证码',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '验证码发送时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '验证码发送状态(1成功0失败)',
  `content` varchar(500) NOT NULL DEFAULT '' COMMENT '验证码内容',
  `result` varchar(2000) NOT NULL DEFAULT '' COMMENT '验证码发送接口返回结果',
  PRIMARY KEY (`code_id`) USING BTREE,
  KEY `phone` (`phone`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=63 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='验证码数据表';

-- ----------------------------
-- Records of wja_log_code
-- ----------------------------
INSERT INTO `wja_log_code` VALUES ('35', '1', '13760170788', 'bind_phone', '229840', '1545391634', '1545391634', '1', '您的验证码：229840，该验证码5分钟内有效，请勿泄漏于他人！', '567501845391634648^0');

-- ----------------------------
-- Table structure for wja_log_inform
-- ----------------------------
DROP TABLE IF EXISTS `wja_log_inform`;
CREATE TABLE `wja_log_inform` (
  `inform_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '通知信息自增长ID',
  `inform_type` varchar(25) NOT NULL DEFAULT '' COMMENT '通知类型(sms短信 wechat微信模板消息)',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '通知发送商户ID',
  `to_user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '收信人用户ID',
  `to_user` varchar(50) NOT NULL DEFAULT '' COMMENT '收信用户信息(sms对应手机号)',
  `template_type` varchar(255) NOT NULL DEFAULT '' COMMENT '模板类型(reset_pwd重置密码......)',
  `template_code` varchar(255) NOT NULL DEFAULT '' COMMENT '模板code',
  `content` varchar(1500) NOT NULL DEFAULT '' COMMENT '通知发送内容',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '通知发送时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '通知发送状态(1成功0失败)',
  `result` varchar(2000) NOT NULL DEFAULT '' COMMENT '通知发送接口返回数据',
  PRIMARY KEY (`inform_id`) USING BTREE,
  KEY `inform_type` (`inform_type`)
) ENGINE=MyISAM AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='通知发送日志表';

-- ----------------------------
-- Records of wja_log_inform
-- ----------------------------
INSERT INTO `wja_log_inform` VALUES ('1', 'sms', '1', '23', '13714906176', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1545985192', '1545985192', '1', '237908145985192255^0');
INSERT INTO `wja_log_inform` VALUES ('2', 'sms', '1', '10', '18319019601', 'reset_pwd', 'SMS_153331143', '您好，您的密码已经重置为58091233，请及时登录并修改密码。', '1545985282', '1545985282', '1', '198805845985282428^0');
INSERT INTO `wja_log_inform` VALUES ('3', 'sms', '1', '23', '13714906176', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1545985316', '1545985317', '1', '594508145985316853^0');
INSERT INTO `wja_log_inform` VALUES ('4', 'sms', '1', '23', '13714906176', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1545985327', '1545985327', '1', '298303245985327190^0');
INSERT INTO `wja_log_inform` VALUES ('5', 'sms', '1', '22', '13760170785', 'reset_pwd', 'SMS_153331143', '您好，您的密码已经重置为83837824，请及时登录并修改密码。', '1545985643', '1545985643', '1', '782722045985643551^0');
INSERT INTO `wja_log_inform` VALUES ('6', 'sms', '1', '23', '13714906176', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1545988809', '1545988809', '1', '223008045988809199^0');
INSERT INTO `wja_log_inform` VALUES ('7', 'sms', '1', '23', '13714906176', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1545988815', '1545988816', '1', '971113845988816261^0');
INSERT INTO `wja_log_inform` VALUES ('8', 'sms', '1', '7', '18565854698', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1545991815', '1545991815', '1', '297022745991815627^0');
INSERT INTO `wja_log_inform` VALUES ('9', 'sms', '1', '7', '18565854698', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1545992007', '1545992007', '1', '126210045992007277^0');
INSERT INTO `wja_log_inform` VALUES ('10', 'sms', '1', '7', '18565854698', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1546049182', '1546049182', '1', '931618246049182365^0');
INSERT INTO `wja_log_inform` VALUES ('11', 'sms', '1', '7', '18565854698', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1546049432', '1546049432', '1', '557105046049432440^0');
INSERT INTO `wja_log_inform` VALUES ('12', 'sms', '1', '23', '13714906176', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1546066276', '1546066277', '1', '498313046066276663^0');
INSERT INTO `wja_log_inform` VALUES ('13', 'sms', '1', '23', '13714906176', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1546066694', '1546066695', '1', '753100546066694420^0');
INSERT INTO `wja_log_inform` VALUES ('14', 'sms', '1', '23', '13714906176', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1546066766', '1546066766', '1', '795822046066766373^0');
INSERT INTO `wja_log_inform` VALUES ('15', 'sms', '1', '7', '18565854698', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1546068114', '1546068115', '1', '250113346068115046^0');
INSERT INTO `wja_log_inform` VALUES ('16', 'sms', '1', '7', '18565854698', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1546068378', '1546068378', '1', '115008646068378119^0');
INSERT INTO `wja_log_inform` VALUES ('17', 'sms', '1', '19', '15118815476', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1546068394', '1546068394', '1', '669600246068394318^0');
INSERT INTO `wja_log_inform` VALUES ('18', 'sms', '1', '19', '15118815476', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1546068488', '1546068489', '1', '933407746068489188^0');
INSERT INTO `wja_log_inform` VALUES ('19', 'sms', '1', '19', '15118815476', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1546069104', '1546069105', '1', '842613946069105130^0');
INSERT INTO `wja_log_inform` VALUES ('20', 'sms', '1', '19', '15118815476', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1546069432', '1546069433', '1', '489613846069433022^0');
INSERT INTO `wja_log_inform` VALUES ('21', 'sms', '1', '19', '15118815476', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1546069662', '1546069662', '1', '151101146069662117^0');
INSERT INTO `wja_log_inform` VALUES ('22', 'sms', '1', '19', '15118815476', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1546070519', '1546070519', '1', '468808146070519684^0');
INSERT INTO `wja_log_inform` VALUES ('23', 'sms', '1', '19', '15118815476', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1546070543', '1546070543', '1', '513108146070543481^0');
INSERT INTO `wja_log_inform` VALUES ('24', 'sms', '1', '19', '15118815476', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1546070557', '1546070557', '1', '408509946070557271^0');
INSERT INTO `wja_log_inform` VALUES ('25', 'sms', '1', '19', '15118815476', 'worder_dispatch_installer', 'SMS_153990108', '收到新的服务工单，请进入智享家师傅端小程序接单。', '1546070686', '1546070687', '1', '850408146070686889^0');

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
  `user_store_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '下单用户 管理员商户类型',
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
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '订单显示状态',
  `close_refund_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '退货退换关闭状态(0未关闭 1部分关闭 2已关闭)',
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE KEY `order_sn` (`order_sn`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_order
-- ----------------------------
INSERT INTO `wja_order` VALUES ('1', '1', '20181221161445531015571266774', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '123', '刘瑞', '18565854698', '1663', '河南省 周口市 川汇区 二道口子右拐', '1', '1', '0', '2', '1545380085', '0', '1545380213', '1545380213', '1545702170', '', '', '1', '2');
INSERT INTO `wja_order` VALUES ('2', '1', '20181221171909100971243370754', '1', '4', '3', '2', '0.01', '0.00', '0.02', '0.01', '0.00', '1', '', '', '张三', '13569874512', '1968', '广东省 深圳市 南山区 德赛科技大厦2201', '2', '0', '0', '0', '1545383949', '0', '0', '0', '1545791188', '', '', '1', '0');
INSERT INTO `wja_order` VALUES ('3', '1', '20181221174711102100020789604', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000209201812215641443423', '曾大腿', '13854587585', '1670', '河南省 周口市 太康县 德赛科技大厦', '1', '1', '0', '2', '1545385631', '0', '1545385648', '1545385648', '1545702191', '', '66666', '1', '2');
INSERT INTO `wja_order` VALUES ('4', '1', '20181221174955515197060400288', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000228201812213030780538', '张三', '15116678768', '1968', '广东省 深圳市 南山区 大冲商务中心', '1', '1', '0', '2', '1545385795', '0', '1545385811', '1545385811', '1545792131', '', '', '1', '2');
INSERT INTO `wja_order` VALUES ('5', '1', '20181224091740525252047510697', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000223201812240381659571', '蜘蛛侠', '18565854698', '1968', '广东省 深圳市 南山区 二道口子右拐', '1', '1', '0', '2', '1545614260', '0', '1545614279', '1545614279', '1545792342', '', '', '1', '2');
INSERT INTO `wja_order` VALUES ('6', '1', '20181224182633571001288537126', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'alipay_page', '2018122522001478830506190936', '测试', '13685698562', '2216', '海南省 三亚市 吉阳区 测试地址', '1', '1', '0', '2', '1545647193', '0', '1545703687', '1545703687', '1545703687', '', '', '1', '0');
INSERT INTO `wja_order` VALUES ('7', '1', '20181225094902101102305253833', '1', '5', '4', '3', '0.02', '0.00', '0.04', '0.02', '0.00', '1', '', '', '奇异博士', '13635613699', '2811', '陕西省 西安市 新城区 深圳市', '2', '0', '0', '0', '1545702542', '0', '0', '0', '1545702624', '', '', '1', '0');
INSERT INTO `wja_order` VALUES ('8', '1', '20181225095004991015104960914', '1', '5', '4', '3', '0.02', '0.00', '0.04', '0.02', '0.00', '1', '', '', '奇异博士', '13635613699', '2511', '贵州省 遵义市 余庆县 深圳市', '2', '0', '0', '0', '1545702604', '0', '0', '0', '1545702638', '', '', '1', '0');
INSERT INTO `wja_order` VALUES ('9', '1', '20181225095746975048006806088', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'alipay_page', '2018122522001478830505063396', 'AA', '13658965412', '2040', '广东省 汕尾市 海丰县 CC', '1', '1', '0', '2', '1545703066', '0', '1545703656', '1545703656', '1545703656', '', 'DD', '1', '0');
INSERT INTO `wja_order` VALUES ('10', '1', '20181225100917100101148975214', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'alipay_page', '2018122522001478830502404562', '11', '13698565245', '1943', '广东省 广州市 荔湾区 a2s', '1', '1', '0', '2', '1545703757', '0', '1545708823', '1545708823', '1545708823', '', 'dfasdf', '1', '0');
INSERT INTO `wja_order` VALUES ('11', '1', '20181225104329495410039864814', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'alipay_page', '2018122522001478830504950530', '11', '13698569854', '2217', '海南省 三亚市 天涯区 sss', '1', '1', '0', '2', '1545705809', '0', '1545706605', '1545706605', '1545706605', '', 'add', '1', '0');
INSERT INTO `wja_order` VALUES ('12', '1', '20181225111202509850119817794', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'alipay_page', '2018122522001478830508041725', '234123', '13685965856', '2264', '重庆市 县 梁平县 11', '1', '1', '0', '2', '1545707522', '0', '1545708022', '1545708022', '1545708022', '', 'dsfasd', '1', '0');
INSERT INTO `wja_order` VALUES ('13', '1', '20181225113556995798964280737', '1', '4', '3', '2', '0.01', '0.00', '0.02', '0.01', '0.00', '1', '', '', '奇异博士', '13635613699', '3225', '台湾省 sadsa', '2', '0', '0', '0', '1545708956', '0', '0', '0', '1545791247', '', '', '1', '2');
INSERT INTO `wja_order` VALUES ('14', '1', '20181225114444995399352182151', '1', '4', '3', '2', '0.01', '0.00', '0.02', '0.01', '0.00', '1', '', '', '奇异博士', '13635613699', '4', '北京市 北京市 东城区 北京三里屯', '2', '0', '0', '0', '1545709484', '0', '0', '0', '1545791644', '', '', '1', '0');
INSERT INTO `wja_order` VALUES ('15', '1', '20181225114444999950718379329', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'alipay_page', '2018122522001461920540211769', '张飞', '15118815476', '1968', '广东省 深圳市 南山区 大冲商务中心', '1', '1', '0', '2', '1545709484', '0', '1545709550', '1545709550', '1545709550', '', '12.25日测试', '1', '0');
INSERT INTO `wja_order` VALUES ('16', '1', '20181225115553575255469740793', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.00', '1', '', '', '奇异博士', '13635613699', '6', '北京市 北京市 朝阳区 北京三里屯', '2', '0', '0', '0', '1545710153', '0', '0', '0', '1545791722', '', '', '1', '0');
INSERT INTO `wja_order` VALUES ('17', '1', '20181225115636525052931985577', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.00', '1', '', '', '测试', '13458745824', '2194', '广西壮族自治区 来宾市 兴宾区 测试', '2', '0', '0', '0', '1545710196', '0', '0', '0', '1545791776', '', '是', '1', '0');
INSERT INTO `wja_order` VALUES ('18', '1', '20181225115858509810411449076', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.00', '1', '', '', '111', '13658956210', '2219', '海南省 三沙市 sdfasdf', '2', '0', '0', '0', '1545710338', '0', '0', '0', '1545791952', '', '啊', '1', '0');
INSERT INTO `wja_order` VALUES ('19', '1', '20181225120213539797440763134', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.00', '1', '', '', '测试', '13698501258', '2190', '广西壮族自治区 河池市 都安瑶族自治县 111', '2', '0', '0', '0', '1545710533', '0', '0', '0', '1545791974', '', '册', '1', '0');
INSERT INTO `wja_order` VALUES ('20', '1', '20181225120652995398333107220', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000212201812250130895835', '测试', '13587458745', '1943', '广东省 广州市 荔湾区 111', '1', '1', '0', '2', '1545710812', '0', '1545721898', '1545721898', '1545721898', '', '222', '1', '0');
INSERT INTO `wja_order` VALUES ('21', '1', '20181225121455102545363935718', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000237201812250805654248', '11', '13698568548', '2276', '重庆市 县 酉阳土家族苗族自治县 11', '1', '1', '0', '2', '1545711295', '0', '1545722473', '1545722473', '1545722473', '', '', '1', '0');
INSERT INTO `wja_order` VALUES ('22', '1', '20181225122855555099860202144', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000219201812251080836301', '341234', '13569854785', '2216', '海南省 三亚市 吉阳区 sdfsd', '1', '1', '0', '2', '1545712135', '0', '1545723207', '1545723207', '1545723207', '', 'fads', '1', '0');
INSERT INTO `wja_order` VALUES ('23', '1', '20181225125249495255423378410', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000230201812250508074647', '刘畅', '18903769208', '1968', '广东省 深圳市 南山区 德赛科技大厦', '1', '1', '0', '2', '1545713569', '0', '1545724639', '1545724639', '1545724639', '', 'aaa', '1', '0');
INSERT INTO `wja_order` VALUES ('24', '1', '20181225131026501004652642017', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000234201812254116647844', 'test', '18903769208', '4', '北京市 北京市 东城区 aaaa', '1', '1', '0', '2', '1545714626', '0', '1545722112', '1545722112', '1545722112', '', 'aa', '1', '0');
INSERT INTO `wja_order` VALUES ('25', '1', '20181225142636999710963464721', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'alipay_page', '2018122522001437240506640895', '蜘蛛侠', '18565854698', '1968', '广东省 深圳市 南山区 二道口子', '1', '1', '0', '2', '1545719196', '0', '1545719224', '1545719224', '1545719224', '', '', '1', '0');
INSERT INTO `wja_order` VALUES ('26', '1', '20181225143510101524067231322', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000227201812255372723788', 'aaaa', '18903769208', '1943', '广东省 广州市 荔湾区 aaa', '1', '1', '0', '2', '1545719710', '0', '1545721802', '1545721802', '1545721802', '', 'aa', '1', '0');
INSERT INTO `wja_order` VALUES ('27', '1', '20181225144306975048616924664', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000211201812251316269907', 'ffff', '18903769208', '4', '北京市 北京市 东城区 aaa', '1', '1', '0', '2', '1545720186', '0', '1545722247', '1545722247', '1545722247', '', 'aaa', '1', '0');
INSERT INTO `wja_order` VALUES ('28', '1', '20181225144322974956027879121', '1', '4', '3', '2', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000229201812254111658157', '蜘蛛侠', '18565854698', '1968', '广东省 深圳市 南山区 二道口子', '1', '1', '0', '2', '1545720202', '0', '1545722267', '1545722267', '1545722267', '', '', '1', '0');
INSERT INTO `wja_order` VALUES ('29', '1', '20181225144523519950259485886', '1', '4', '3', '2', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'alipay_page', '2018122522001437240504767622', '蜘蛛侠', '18565854698', '1968', '广东省 深圳市 南山区 二道口子', '1', '1', '0', '2', '1545720323', '0', '1545720337', '1545720337', '1546503900', '', '', '1', '2');
INSERT INTO `wja_order` VALUES ('30', '1', '20181225145420995098669939526', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000221201812253897205079', 'ggg', '18903769208', '4', '北京市 北京市 东城区 gg', '1', '1', '0', '2', '1545720860', '0', '1545722924', '1545722924', '1545722924', '', 'gg', '1', '0');
INSERT INTO `wja_order` VALUES ('31', '1', '20181225145834975550077286485', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000227201812250779730873', 'gda', '18903769208', '4', '北京市 北京市 东城区 agag', '1', '1', '0', '2', '1545721114', '0', '1545723180', '1545723180', '1545723180', '', 'ag', '1', '0');
INSERT INTO `wja_order` VALUES ('32', '1', '20181225151102549853093709219', '1', '4', '3', '2', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000215201812257592652170', '11', '13598547852', '2040', '广东省 汕尾市 海丰县 1122', '1', '1', '0', '2', '1545721862', '0', '1545721877', '1545721878', '1545721878', '', '1250', '1', '0');
INSERT INTO `wja_order` VALUES ('33', '1', '20181225151317100100663220192', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000229201812250638939127', 'zhizhuxia ', '18565854698', '1968', '广东省 深圳市 南山区 二道口子', '1', '1', '0', '2', '1545721997', '0', '1545722015', '1545722015', '1545722015', '', '', '1', '0');
INSERT INTO `wja_order` VALUES ('34', '1', '20181226095553575155600481175', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.00', '1', '', '', '', '', '0', '', '2', '0', '0', '0', '1545789353', '0', '0', '0', '1545792080', '', '', '1', '2');
INSERT INTO `wja_order` VALUES ('35', '1', '20181226113207554999627746460', '1', '4', '3', '2', '0.01', '0.00', '0.02', '0.01', '0.00', '1', '', '', '', '', '0', '', '1', '0', '0', '0', '1545795127', '0', '0', '0', '1545795127', '', '', '1', '0');
INSERT INTO `wja_order` VALUES ('36', '1', '20181227163226975110293764391', '1', '22', '10', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000238201812270285745984', '', '', '0', '', '3', '1', '0', '2', '1545899546', '0', '1545899563', '1545899563', '1545899916', '', '', '1', '2');
INSERT INTO `wja_order` VALUES ('37', '1', '20181227163917535699416879519', '1', '22', '10', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'alipay_page', '2018122722001478830523839310', '', '', '0', '', '3', '1', '0', '2', '1545899957', '0', '1545899983', '1545899983', '1545900165', '', '', '1', '2');
INSERT INTO `wja_order` VALUES ('38', '1', '20181227165721494954166112109', '1', '22', '10', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'alipay_page', '2018122722001478830523742411', '', '', '0', '', '1', '1', '0', '2', '1545901041', '0', '1545901074', '1545901074', '1545901074', '', '', '1', '0');
INSERT INTO `wja_order` VALUES ('39', '1', '20181228170346501005194047741', '1', '22', '10', '3', '0.01', '0.00', '0.02', '0.01', '0.00', '1', '', '', '', '', '0', '', '1', '0', '0', '0', '1545987826', '0', '0', '0', '1545987826', '', '', '1', '0');
INSERT INTO `wja_order` VALUES ('40', '1', '20181228175445534853281947923', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000235201812287075851350', '', '', '0', '', '1', '1', '0', '2', '1545990885', '0', '1545990899', '1545990899', '1545990899', '', '', '1', '0');
INSERT INTO `wja_order` VALUES ('41', '1', '20181228184005534910223759900', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000233201812289484536805', '', '', '0', '', '1', '1', '0', '2', '1545993605', '0', '1545993622', '1545993622', '1545993622', '', '', '1', '0');
INSERT INTO `wja_order` VALUES ('42', '1', '20181228184210501024133410700', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000225201812280768855858', '', '', '0', '', '1', '1', '0', '2', '1545993730', '0', '1545993746', '1545993746', '1545993746', '', '', '1', '0');
INSERT INTO `wja_order` VALUES ('43', '1', '20181229095605535755091943774', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000232201812295015876622', '', '', '0', '', '3', '1', '0', '2', '1546048565', '0', '1546048626', '1546048626', '1546048804', '', '', '1', '2');
INSERT INTO `wja_order` VALUES ('44', '1', '20181229100233579855109535557', '1', '5', '4', '3', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000218201812297184289335', '', '', '0', '', '1', '1', '0', '2', '1546048953', '0', '1546048967', '1546048967', '1546502333', '', '', '1', '2');
INSERT INTO `wja_order` VALUES ('45', '1', '20181229120903102535045970359', '1', '4', '3', '2', '0.01', '0.00', '0.02', '0.01', '0.02', '1', 'wechat_native', '4200000214201812299348719403', '', '', '0', '', '1', '1', '0', '2', '1546056543', '0', '1546056557', '1546056557', '1546500894', '', '', '1', '2');

-- ----------------------------
-- Table structure for wja_order_log
-- ----------------------------
DROP TABLE IF EXISTS `wja_order_log`;
CREATE TABLE `wja_order_log` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单ID',
  `order_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '订单号',
  `service_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '售后ID',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作用户ID',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '用户昵称',
  `action` varchar(50) NOT NULL DEFAULT '' COMMENT '操作类型(创建订单 支付订单 确认订单 配送订单 完成订单)',
  `msg` varchar(500) NOT NULL DEFAULT '' COMMENT '操作信息',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '日志记录时间',
  PRIMARY KEY (`log_id`) USING BTREE,
  KEY `order_id` (`order_id`) USING BTREE,
  KEY `order_sn` (`order_sn`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=148 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_order_log
-- ----------------------------
INSERT INTO `wja_order_log` VALUES ('1', '1', '20181221161445531015571266774', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545380085');
INSERT INTO `wja_order_log` VALUES ('2', '1', '20181221161445531015571266774', '0', '2', '[卖家]wanjiaan', '支付订单', '', '1545380213');
INSERT INTO `wja_order_log` VALUES ('3', '1', '20181221161445531015571266774', '0', '2', '[卖家]wanjiaan', '确认完成', '支付成功,订单完成', '1545380213');
INSERT INTO `wja_order_log` VALUES ('4', '2', '20181221171909100971243370754', '0', '4', '[买家]刘越', '创建订单', '提交购买产品并生成订单', '1545383949');
INSERT INTO `wja_order_log` VALUES ('5', '3', '20181221174711102100020789604', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545385631');
INSERT INTO `wja_order_log` VALUES ('6', '3', '20181221174711102100020789604', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545385648');
INSERT INTO `wja_order_log` VALUES ('7', '3', '20181221174711102100020789604', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545385648');
INSERT INTO `wja_order_log` VALUES ('8', '4', '20181221174955515197060400288', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545385795');
INSERT INTO `wja_order_log` VALUES ('9', '4', '20181221174955515197060400288', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545385811');
INSERT INTO `wja_order_log` VALUES ('10', '4', '20181221174955515197060400288', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545385811');
INSERT INTO `wja_order_log` VALUES ('11', '5', '20181224091740525252047510697', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545614260');
INSERT INTO `wja_order_log` VALUES ('12', '5', '20181224091740525252047510697', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545614279');
INSERT INTO `wja_order_log` VALUES ('13', '5', '20181224091740525252047510697', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545614279');
INSERT INTO `wja_order_log` VALUES ('14', '6', '20181224182633571001288537126', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545647193');
INSERT INTO `wja_order_log` VALUES ('15', '1', '20181221161445531015571266774', '0', '0', '系统', '关闭退货退款功能', '系统自动关闭退货退款功能', '1545702170');
INSERT INTO `wja_order_log` VALUES ('16', '3', '20181221174711102100020789604', '0', '0', '系统', '关闭退货退款功能', '系统自动关闭退货退款功能', '1545702191');
INSERT INTO `wja_order_log` VALUES ('17', '7', '20181225094902101102305253833', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545702543');
INSERT INTO `wja_order_log` VALUES ('18', '8', '20181225095004991015104960914', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545702604');
INSERT INTO `wja_order_log` VALUES ('19', '7', '20181225094902101102305253833', '0', '5', '[买家]lingshou', '取消订单', '', '1545702624');
INSERT INTO `wja_order_log` VALUES ('20', '8', '20181225095004991015104960914', '0', '5', '[买家]lingshou', '取消订单', '', '1545702638');
INSERT INTO `wja_order_log` VALUES ('21', '9', '20181225095746975048006806088', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545703066');
INSERT INTO `wja_order_log` VALUES ('22', '9', '20181225095746975048006806088', '0', '2', '[卖家]wanjiaan', '支付订单', '', '1545703656');
INSERT INTO `wja_order_log` VALUES ('23', '9', '20181225095746975048006806088', '0', '2', '[卖家]wanjiaan', '确认完成', '支付成功,订单完成', '1545703656');
INSERT INTO `wja_order_log` VALUES ('24', '6', '20181224182633571001288537126', '0', '2', '[卖家]wanjiaan', '支付订单', '', '1545703687');
INSERT INTO `wja_order_log` VALUES ('25', '6', '20181224182633571001288537126', '0', '2', '[卖家]wanjiaan', '确认完成', '支付成功,订单完成', '1545703687');
INSERT INTO `wja_order_log` VALUES ('26', '10', '20181225100917100101148975214', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545703757');
INSERT INTO `wja_order_log` VALUES ('27', '11', '20181225104329495410039864814', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545705809');
INSERT INTO `wja_order_log` VALUES ('28', '11', '20181225104329495410039864814', '0', '2', '[卖家]wanjiaan', '支付订单', '', '1545706605');
INSERT INTO `wja_order_log` VALUES ('29', '11', '20181225104329495410039864814', '0', '2', '[卖家]wanjiaan', '确认完成', '支付成功,订单完成', '1545706605');
INSERT INTO `wja_order_log` VALUES ('30', '12', '20181225111202509850119817794', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545707522');
INSERT INTO `wja_order_log` VALUES ('31', '12', '20181225111202509850119817794', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545708022');
INSERT INTO `wja_order_log` VALUES ('32', '12', '20181225111202509850119817794', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545708022');
INSERT INTO `wja_order_log` VALUES ('33', '10', '20181225100917100101148975214', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545708823');
INSERT INTO `wja_order_log` VALUES ('34', '10', '20181225100917100101148975214', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545708823');
INSERT INTO `wja_order_log` VALUES ('35', '13', '20181225113556995798964280737', '0', '4', '[买家]刘越', '创建订单', '提交购买产品并生成订单', '1545708956');
INSERT INTO `wja_order_log` VALUES ('36', '14', '20181225114444995399352182151', '0', '4', '[买家]刘越', '创建订单', '提交购买产品并生成订单', '1545709484');
INSERT INTO `wja_order_log` VALUES ('37', '15', '20181225114444999950718379329', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545709484');
INSERT INTO `wja_order_log` VALUES ('38', '15', '20181225114444999950718379329', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545709550');
INSERT INTO `wja_order_log` VALUES ('39', '15', '20181225114444999950718379329', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545709550');
INSERT INTO `wja_order_log` VALUES ('40', '16', '20181225115553575255469740793', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545710153');
INSERT INTO `wja_order_log` VALUES ('41', '17', '20181225115636525052931985577', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545710196');
INSERT INTO `wja_order_log` VALUES ('42', '18', '20181225115858509810411449076', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545710338');
INSERT INTO `wja_order_log` VALUES ('43', '19', '20181225120213539797440763134', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545710533');
INSERT INTO `wja_order_log` VALUES ('44', '20', '20181225120652995398333107220', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545710812');
INSERT INTO `wja_order_log` VALUES ('45', '21', '20181225121455102545363935718', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545711295');
INSERT INTO `wja_order_log` VALUES ('46', '22', '20181225122855555099860202144', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545712135');
INSERT INTO `wja_order_log` VALUES ('47', '23', '20181225125249495255423378410', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545713569');
INSERT INTO `wja_order_log` VALUES ('48', '24', '20181225131026501004652642017', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545714626');
INSERT INTO `wja_order_log` VALUES ('49', '25', '20181225142636999710963464721', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545719196');
INSERT INTO `wja_order_log` VALUES ('50', '25', '20181225142636999710963464721', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545719224');
INSERT INTO `wja_order_log` VALUES ('51', '25', '20181225142636999710963464721', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545719224');
INSERT INTO `wja_order_log` VALUES ('52', '26', '20181225143510101524067231322', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545719710');
INSERT INTO `wja_order_log` VALUES ('53', '27', '20181225144306975048616924664', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545720186');
INSERT INTO `wja_order_log` VALUES ('54', '28', '20181225144322974956027879121', '0', '4', '[买家]刘越', '创建订单', '提交购买产品并生成订单', '1545720202');
INSERT INTO `wja_order_log` VALUES ('55', '29', '20181225144523519950259485886', '0', '4', '[买家]刘越', '创建订单', '提交购买产品并生成订单', '1545720323');
INSERT INTO `wja_order_log` VALUES ('56', '29', '20181225144523519950259485886', '0', '4', '[买家]刘越', '支付订单', '支付完成,等待商家发货', '1545720337');
INSERT INTO `wja_order_log` VALUES ('57', '29', '20181225144523519950259485886', '0', '4', '[买家]刘越', '确认完成', '支付成功,订单完成', '1545720337');
INSERT INTO `wja_order_log` VALUES ('58', '30', '20181225145420995098669939526', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545720860');
INSERT INTO `wja_order_log` VALUES ('59', '31', '20181225145834975550077286485', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545721114');
INSERT INTO `wja_order_log` VALUES ('60', '26', '20181225143510101524067231322', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545721802');
INSERT INTO `wja_order_log` VALUES ('61', '26', '20181225143510101524067231322', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545721802');
INSERT INTO `wja_order_log` VALUES ('62', '32', '20181225151102549853093709219', '0', '4', '[买家]刘越', '创建订单', '提交购买产品并生成订单', '1545721862');
INSERT INTO `wja_order_log` VALUES ('63', '32', '20181225151102549853093709219', '0', '4', '[买家]刘越', '支付订单', '支付完成,等待商家发货', '1545721878');
INSERT INTO `wja_order_log` VALUES ('64', '32', '20181225151102549853093709219', '0', '4', '[买家]刘越', '确认完成', '支付成功,订单完成', '1545721878');
INSERT INTO `wja_order_log` VALUES ('65', '20', '20181225120652995398333107220', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545721898');
INSERT INTO `wja_order_log` VALUES ('66', '20', '20181225120652995398333107220', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545721898');
INSERT INTO `wja_order_log` VALUES ('67', '33', '20181225151317100100663220192', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545721997');
INSERT INTO `wja_order_log` VALUES ('68', '33', '20181225151317100100663220192', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545722015');
INSERT INTO `wja_order_log` VALUES ('69', '33', '20181225151317100100663220192', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545722015');
INSERT INTO `wja_order_log` VALUES ('70', '24', '20181225131026501004652642017', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545722112');
INSERT INTO `wja_order_log` VALUES ('71', '24', '20181225131026501004652642017', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545722112');
INSERT INTO `wja_order_log` VALUES ('72', '27', '20181225144306975048616924664', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545722247');
INSERT INTO `wja_order_log` VALUES ('73', '27', '20181225144306975048616924664', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545722247');
INSERT INTO `wja_order_log` VALUES ('74', '28', '20181225144322974956027879121', '0', '4', '[买家]刘越', '支付订单', '支付完成,等待商家发货', '1545722267');
INSERT INTO `wja_order_log` VALUES ('75', '28', '20181225144322974956027879121', '0', '4', '[买家]刘越', '确认完成', '支付成功,订单完成', '1545722267');
INSERT INTO `wja_order_log` VALUES ('76', '21', '20181225121455102545363935718', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545722473');
INSERT INTO `wja_order_log` VALUES ('77', '21', '20181225121455102545363935718', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545722473');
INSERT INTO `wja_order_log` VALUES ('78', '30', '20181225145420995098669939526', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545722924');
INSERT INTO `wja_order_log` VALUES ('79', '30', '20181225145420995098669939526', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545722924');
INSERT INTO `wja_order_log` VALUES ('80', '31', '20181225145834975550077286485', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545723180');
INSERT INTO `wja_order_log` VALUES ('81', '31', '20181225145834975550077286485', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545723180');
INSERT INTO `wja_order_log` VALUES ('82', '22', '20181225122855555099860202144', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545723207');
INSERT INTO `wja_order_log` VALUES ('83', '22', '20181225122855555099860202144', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545723207');
INSERT INTO `wja_order_log` VALUES ('84', '23', '20181225125249495255423378410', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545724639');
INSERT INTO `wja_order_log` VALUES ('85', '23', '20181225125249495255423378410', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545724639');
INSERT INTO `wja_order_log` VALUES ('86', '34', '20181226095553575155600481175', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545789353');
INSERT INTO `wja_order_log` VALUES ('87', '13', '20181225113556995798964280737', '0', '0', '系统', '取消订单', '订单超时未付款，系统自动取消订单', '1545791247');
INSERT INTO `wja_order_log` VALUES ('88', '4', '20181221174955515197060400288', '0', '0', '系统', '关闭退货退款功能', '自动关闭退货退款功能', '1545791247');
INSERT INTO `wja_order_log` VALUES ('89', '5', '20181224091740525252047510697', '0', '0', '系统', '关闭退货退款功能', '自动关闭退货退款功能', '1545791247');
INSERT INTO `wja_order_log` VALUES ('90', '14', '20181225114444995399352182151', '0', '0', '系统', '取消订单', '订单超时未付款，系统自动取消订单', '1545791644');
INSERT INTO `wja_order_log` VALUES ('91', '17', '20181225115636525052931985577', '0', '0', '系统', '取消订单', '订单超时未付款，系统自动取消订单', '1545791776');
INSERT INTO `wja_order_log` VALUES ('92', '18', '20181225115858509810411449076', '0', '0', '系统', '取消订单', '订单超时未付款，系统自动取消订单', '1545791952');
INSERT INTO `wja_order_log` VALUES ('93', '19', '20181225120213539797440763134', '0', '0', '系统', '取消订单', '订单超时未付款，系统自动取消订单', '1545791974');
INSERT INTO `wja_order_log` VALUES ('94', '34', '20181226095553575155600481175', '0', '0', '系统', '取消订单', '订单超时未付款，系统自动取消订单', '1545792080');
INSERT INTO `wja_order_log` VALUES ('95', '4', '20181221174955515197060400288', '0', '0', '系统', '关闭退货退款功能', '自动关闭退货退款功能', '1545792080');
INSERT INTO `wja_order_log` VALUES ('96', '5', '20181224091740525252047510697', '0', '0', '系统', '关闭退货退款功能', '自动关闭退货退款功能', '1545792080');
INSERT INTO `wja_order_log` VALUES ('97', '4', '20181221174955515197060400288', '0', '0', '系统', '关闭退货退款功能', '自动关闭退货退款功能', '1545792131');
INSERT INTO `wja_order_log` VALUES ('98', '5', '20181224091740525252047510697', '0', '0', '系统', '关闭退货退款功能', '自动关闭退货退款功能', '1545792131');
INSERT INTO `wja_order_log` VALUES ('99', '5', '20181224091740525252047510697', '0', '0', '系统', '关闭退货退款功能', '系统自动关闭退货退款功能', '1545792342');
INSERT INTO `wja_order_log` VALUES ('100', '35', '20181226113207554999627746460', '0', '4', '[买家]刘越', '创建订单', '提交购买产品并生成订单', '1545795127');
INSERT INTO `wja_order_log` VALUES ('101', '36', '20181227163226975110293764391', '0', '22', '[买家]wja_lingshou', '创建订单', '提交购买产品并生成订单', '1545899546');
INSERT INTO `wja_order_log` VALUES ('102', '36', '20181227163226975110293764391', '0', '22', '[买家]wja_lingshou', '支付订单', '支付完成,等待商家发货', '1545899563');
INSERT INTO `wja_order_log` VALUES ('103', '36', '20181227163226975110293764391', '0', '22', '[买家]wja_lingshou', '确认完成', '支付成功,订单完成', '1545899563');
INSERT INTO `wja_order_log` VALUES ('104', '36', '20181227163226975110293764391', '1', '22', '[买家]wja_lingshou', '申请退货退款', '质量有问题', '1545899584');
INSERT INTO `wja_order_log` VALUES ('105', '36', '20181227163226975110293764391', '1', '2', '[卖家]wanjiaan', '拒绝退货退款', '不同意', '1545899719');
INSERT INTO `wja_order_log` VALUES ('106', '36', '20181227163226975110293764391', '1', '22', '[买家]wja_lingshou', '申请退货退款', '质量有问题', '1545899883');
INSERT INTO `wja_order_log` VALUES ('107', '36', '20181227163226975110293764391', '1', '2', '[卖家]wanjiaan', '同意退货退款', '', '1545899890');
INSERT INTO `wja_order_log` VALUES ('108', '36', '20181227163226975110293764391', '1', '22', '[买家]wja_lingshou', '买家填写退货信息', '物流公司:圆通快递<br>物流单号:123456<br>', '1545899900');
INSERT INTO `wja_order_log` VALUES ('109', '36', '20181227163226975110293764391', '1', '2', '[卖家]wanjiaan', '卖家退款', '', '1545899916');
INSERT INTO `wja_order_log` VALUES ('110', '36', '20181227163226975110293764391', '0', '2', '[卖家]wanjiaan', '订单关闭', '订单产品全部退款，系统自动关闭订单', '1545899916');
INSERT INTO `wja_order_log` VALUES ('111', '37', '20181227163917535699416879519', '0', '22', '[买家]wja_lingshou', '创建订单', '提交购买产品并生成订单', '1545899957');
INSERT INTO `wja_order_log` VALUES ('112', '37', '20181227163917535699416879519', '0', '22', '[买家]wja_lingshou', '支付订单', '支付完成,等待商家发货', '1545899983');
INSERT INTO `wja_order_log` VALUES ('113', '37', '20181227163917535699416879519', '0', '22', '[买家]wja_lingshou', '确认完成', '支付成功,订单完成', '1545899983');
INSERT INTO `wja_order_log` VALUES ('114', '37', '20181227163917535699416879519', '2', '22', '[买家]wja_lingshou', '申请退货退款', '缺钱花啦~~', '1545900046');
INSERT INTO `wja_order_log` VALUES ('115', '37', '20181227163917535699416879519', '2', '2', '[卖家]wanjiaan', '同意退货退款', '', '1545900053');
INSERT INTO `wja_order_log` VALUES ('116', '37', '20181227163917535699416879519', '2', '22', '[买家]wja_lingshou', '买家填写退货信息', '', '1545900061');
INSERT INTO `wja_order_log` VALUES ('117', '37', '20181227163917535699416879519', '2', '2', '[卖家]wanjiaan', '卖家退款', '', '1545900165');
INSERT INTO `wja_order_log` VALUES ('118', '37', '20181227163917535699416879519', '0', '2', '[卖家]wanjiaan', '订单关闭', '订单产品全部退款，系统自动关闭订单', '1545900165');
INSERT INTO `wja_order_log` VALUES ('119', '38', '20181227165721494954166112109', '0', '22', '[买家]wja_lingshou', '创建订单', '提交购买产品并生成订单', '1545901041');
INSERT INTO `wja_order_log` VALUES ('120', '38', '20181227165721494954166112109', '0', '22', '[买家]wja_lingshou', '支付订单', '支付完成,等待商家发货', '1545901074');
INSERT INTO `wja_order_log` VALUES ('121', '38', '20181227165721494954166112109', '0', '22', '[买家]wja_lingshou', '确认完成', '支付成功,订单完成', '1545901074');
INSERT INTO `wja_order_log` VALUES ('122', '38', '20181227165721494954166112109', '3', '22', '[买家]wja_lingshou', '申请退货退款', 'v v\r\n -', '1545901092');
INSERT INTO `wja_order_log` VALUES ('123', '39', '20181228170346501005194047741', '0', '22', '[买家]7589870766', '创建订单', '提交购买产品并生成订单', '1545987826');
INSERT INTO `wja_order_log` VALUES ('124', '40', '20181228175445534853281947923', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545990885');
INSERT INTO `wja_order_log` VALUES ('125', '40', '20181228175445534853281947923', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545990899');
INSERT INTO `wja_order_log` VALUES ('126', '40', '20181228175445534853281947923', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545990899');
INSERT INTO `wja_order_log` VALUES ('127', '41', '20181228184005534910223759900', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545993605');
INSERT INTO `wja_order_log` VALUES ('128', '41', '20181228184005534910223759900', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545993622');
INSERT INTO `wja_order_log` VALUES ('129', '41', '20181228184005534910223759900', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545993622');
INSERT INTO `wja_order_log` VALUES ('130', '42', '20181228184210501024133410700', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1545993731');
INSERT INTO `wja_order_log` VALUES ('131', '42', '20181228184210501024133410700', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1545993746');
INSERT INTO `wja_order_log` VALUES ('132', '42', '20181228184210501024133410700', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1545993746');
INSERT INTO `wja_order_log` VALUES ('133', '43', '20181229095605535755091943774', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1546048565');
INSERT INTO `wja_order_log` VALUES ('134', '43', '20181229095605535755091943774', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1546048626');
INSERT INTO `wja_order_log` VALUES ('135', '43', '20181229095605535755091943774', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1546048626');
INSERT INTO `wja_order_log` VALUES ('136', '43', '20181229095605535755091943774', '4', '5', '[买家]lingshou', '申请退货退款', '1', '1546048730');
INSERT INTO `wja_order_log` VALUES ('137', '43', '20181229095605535755091943774', '4', '2', '[卖家]wanjiaan', '同意退货退款', '', '1546048751');
INSERT INTO `wja_order_log` VALUES ('138', '43', '20181229095605535755091943774', '4', '5', '[买家]lingshou', '买家填写退货信息', '1', '1546048784');
INSERT INTO `wja_order_log` VALUES ('139', '43', '20181229095605535755091943774', '4', '2', '[卖家]wanjiaan', '卖家退款', '微信原路退款', '1546048804');
INSERT INTO `wja_order_log` VALUES ('140', '43', '20181229095605535755091943774', '0', '0', '系统', '订单关闭', '订单产品全部退款，系统自动关闭订单', '1546048804');
INSERT INTO `wja_order_log` VALUES ('141', '44', '20181229100233579855109535557', '0', '5', '[买家]lingshou', '创建订单', '提交购买产品并生成订单', '1546048953');
INSERT INTO `wja_order_log` VALUES ('142', '44', '20181229100233579855109535557', '0', '5', '[买家]lingshou', '支付订单', '支付完成,等待商家发货', '1546048967');
INSERT INTO `wja_order_log` VALUES ('143', '44', '20181229100233579855109535557', '0', '5', '[买家]lingshou', '确认完成', '支付成功,订单完成', '1546048967');
INSERT INTO `wja_order_log` VALUES ('144', '45', '20181229120903102535045970359', '0', '4', '[买家]刘越', '创建订单', '提交购买产品并生成订单', '1546056543');
INSERT INTO `wja_order_log` VALUES ('145', '45', '20181229120903102535045970359', '0', '4', '[买家]刘越', '支付订单', '支付完成,等待商家发货', '1546056557');
INSERT INTO `wja_order_log` VALUES ('146', '45', '20181229120903102535045970359', '0', '4', '[买家]刘越', '确认完成', '支付成功,订单完成', '1546056557');
INSERT INTO `wja_order_log` VALUES ('147', '44', '20181229100233579855109535557', '0', '0', '系统', '关闭退货退款功能', '系统自动关闭退货退款功能', '1546502333');

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
  `goods_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '产品类型(1为标准产品 2为样品)',
  `sku_name` varchar(255) NOT NULL DEFAULT '' COMMENT '商品名称',
  `sku_thumb` varchar(255) NOT NULL DEFAULT '' COMMENT '商品缩略图',
  `sku_spec` varchar(1500) NOT NULL DEFAULT '' COMMENT '商品规格',
  `sku_info` text COMMENT '商品快照',
  `num` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '商品数量',
  `sku_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '商品单价(原价)',
  `install_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '安装费',
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '单个商品成交价',
  `delivery_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '运费',
  `real_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  `stock_reduce_time` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '库存减少时间:1买家拍下减少库存 2买家付款成功减少库存',
  `odelivery_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '产品物流ID(多个用","逗号分割)',
  `delivery_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '发货状态(0：待发货，1：部分发货，2：已发货)',
  `delivery_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '发货时间',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`osku_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_order_sku
-- ----------------------------
INSERT INTO `wja_order_sku` VALUES ('1', '1', '20181221161445531015571266774', '1', '5', '4', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181220175329_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175329_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175329_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175334_431a25f358a8e6be49f8e2e83594ada.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1994,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \",\"sales\":6,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-20 17:59:11\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":998,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":2},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":996,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":4}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545380085', '1545380085');
INSERT INTO `wja_order_sku` VALUES ('2', '2', '20181221171909100971243370754', '1', '4', '3', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181220175329_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175329_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175329_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175334_431a25f358a8e6be49f8e2e83594ada.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1993,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \",\"sales\":7,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-20 17:59:11\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":998,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":2},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":995,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":5}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545383949', '1545383949');
INSERT INTO `wja_order_sku` VALUES ('3', '3', '20181221174711102100020789604', '1', '5', '4', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181220175329_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175329_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175329_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175334_431a25f358a8e6be49f8e2e83594ada.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1992,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \",\"sales\":8,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-20 17:59:11\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":998,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":2},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":994,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":6}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545385631', '1545385631');
INSERT INTO `wja_order_sku` VALUES ('4', '4', '20181221174955515197060400288', '1', '5', '4', '11', '18', '1', 'L5  黑灰  香槟粉', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181220175329_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175329_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175329_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175334_431a25f358a8e6be49f8e2e83594ada.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1991,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \",\"sales\":9,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-20 17:59:11\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":998,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":2},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":993,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":7}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545385795', '1545385795');
INSERT INTO `wja_order_sku` VALUES ('5', '5', '20181224091740525252047510697', '1', '5', '4', '10', '23', '1', 'Q7   土豪金+黑灰色', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181220174647_14e3301ccb3505523d547aae9895e75.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;土豪金;大', '{\"goods_id\":10,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"Q7   \\u571f\\u8c6a\\u91d1+\\u9ed1\\u7070\\u8272\",\"goods_sn\":\"003\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220174748_14e3301ccb3505523d547aae9895e75.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220174647_14e3301ccb3505523d547aae9895e75.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220174647_14e3301ccb3505523d547aae9895e75.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":997,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b\\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b\",\"content\":\"<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b<span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-size:11.0000pt;\\\"><\\/span><span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-size:11.0000pt;\\\"><\\/span>\\r\\n<\\/div>\",\"sales\":3,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:51:33\",\"update_time\":\"2018-12-20 17:55:14\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u571f\\u8c6a\\u91d1\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":23,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u571f\\u8c6a\\u91d1 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"003-2\",\"sku_thumb\":\"\",\"sku_stock\":997,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u571f\\u8c6a\\u91d1;\\u5927\",\"sales\":3}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545614260', '1545614260');
INSERT INTO `wja_order_sku` VALUES ('6', '6', '20181224182633571001288537126', '1', '5', '4', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1990,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":10,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":997,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":3},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":993,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":7}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545647193', '1545647193');
INSERT INTO `wja_order_sku` VALUES ('7', '7', '20181225094902101102305253833', '1', '5', '4', '11', '18', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1989,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":11,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":997,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":3},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":992,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":8}]}', '2', '0.01', '0.01', '0.02', '0.00', '0.04', '1', '', '0', '0', '1545702543', '1545702543');
INSERT INTO `wja_order_sku` VALUES ('8', '8', '20181225095004991015104960914', '1', '5', '4', '11', '18', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1987,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":13,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":995,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":5},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":992,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":8}]}', '2', '0.01', '0.01', '0.02', '0.00', '0.04', '1', '', '0', '0', '1545702604', '1545702604');
INSERT INTO `wja_order_sku` VALUES ('9', '9', '20181225095746975048006806088', '1', '5', '4', '9', '21', '1', 'I9 黑色', 'http://img.zxjsj.zhidekan.me/goods_20181224103909_3.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":9,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"I9 \\u9ed1\\u8272\",\"goods_sn\":\"002\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220173226_7832e9f24083c5f3a35dfc9e97e2316.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103909_3.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103909_3.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":998,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t<div class=\\\"Section0\\\" align=\\\"center\\\">\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t1.\\u00a0\\u6307\\u7eb9\\u5f00\\u9501\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t2.\\u00a0\\u5bc6\\u7801\\u5f00\\u9501\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t3.\\u00a0\\u5237\\u5361\\u5f00\\u9501\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t4.\\u00a0\\u94a5\\u5319\\u5f00\\u9501\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t5.\\u00a0APP\\u5f00\\u9501\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t1.\\u00a0FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t2.\\u00a0\\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t3.\\u00a0\\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t4.\\u00a0\\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t5.\\u00a0\\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t6.\\u00a0\\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t7.\\u00a0\\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t8.\\u00a0\\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t9.\\u00a0\\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\r\\n\\t<\\/p>\\r\\n<\\/div>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0\\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0\\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\" align=\\\"center\\\">\\r\\n\\t\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0\\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\" align=\\\"center\\\">\\r\\n\\t5.\\u00a0\\u7535\\u5b50\\u95e8\\u94c3\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\" align=\\\"center\\\">\\r\\n\\t\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0\\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u94a2\\u5316\\u73bb\\u7483\\u9762\\u677f\\uff0c\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b\\u00a0\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t<br \\/>\\r\\n<\\/p>\\r\\n<div align=\\\"center\\\">\\r\\n\\t<br \\/>\\r\\n<\\/div>\\t\\t                  \\t\\t                  \",\"sales\":2,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:32:28\",\"update_time\":\"2018-12-24 10:39:10\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":11,\"sku_id\":0,\"skus\":[{\"sku_id\":21,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"002-1\",\"sku_thumb\":\"\",\"sku_stock\":998,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":2}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545703066', '1545703066');
INSERT INTO `wja_order_sku` VALUES ('10', '10', '20181225100917100101148975214', '1', '5', '4', '8', '22', '1', 'I9  PLUS   黑色', 'http://img.zxjsj.zhidekan.me/goods_20181224103921_2.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":8,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"I9  PLUS   \\u9ed1\\u8272\",\"goods_sn\":\"001\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220171329_7832e9f24083c5f3a35dfc9e97e2316.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103921_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103921_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":998,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf...\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t<p class=\\\"MsoBodyText\\\" style=\\\"margin-left:21.15pt;\\\" align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0\\u6307\\u7eb9\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u5bc6\\u7801\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u5237\\u5361\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0\\u94a5\\u5319\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t5.\\u00a0APP\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"MsoBodyText\\\" style=\\\"margin-left:21.15pt;\\\" align=\\\"center\\\">\\r\\n\\t\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0\\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0 5.\\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0 6.\\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t7.\\u00a0\\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t8.\\u00a0\\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t9.\\u00a0PIR\\u4eba\\u4f53\\u68c0\\u6d4b\\uff0c\\u5ba4\\u5916\\u5f02\\u5e38\\u4e3b\\u52a8\\u9632\\u8303\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u63d0\\u9192\\u67e5\\u770b\\uff1b\\u00a0\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"MsoNormal\\\">\\r\\n\\t\\t10.\\u00a0\\u667a\\u80fd\\u732b\\u773c\\uff0c\\u53ef\\u89c6\\u5bf9\\u8bb2\\u8fdc\\u7a0b\\u5f00\\u9501\\u66f4\\u5b89\\u5168\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"MsoNormal\\\">\\r\\n\\t\\t\\u00a0\\u00a0 11.\\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\r\\n\\t<\\/p>\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t\\u00a0\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t1.\\u00a0\\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t2.\\u00a0\\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t3.\\u00a0\\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:397.1pt;text-align:left;\\\">\\r\\n\\t\\t4.\\u00a0\\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b \\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t1.\\u00a0APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t2.\\u00a0\\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t3.\\u00a0\\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t4.\\u00a0\\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:397.1pt;text-align:left;\\\">\\r\\n\\t\\t5.\\u00a0\\u7535\\u5b50\\u95e8\\u94c3\\uff1b \\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t1.\\u00a0\\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t2.\\u00a0\\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t3.\\u00a0\\u94a2\\u5316\\u73bb\\u7483\\u9762\\u677f\\uff0c\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b\\u00a0\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t4.\\u00a0C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"MsoNormal\\\" style=\\\"text-align:left;\\\">\\r\\n\\t\\t<br \\/>\\r\\n\\t<\\/p>\\r\\n<br \\/>\\r\\n<b><span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;color:#BCD6ED;font-weight:bold;font-size:8.0000pt;\\\"> <\\/span><\\/b>\\r\\n<\\/p>\\r\\n<span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-size:11.0000pt;\\\"><\\/span><span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-weight:bold;font-size:11.0000pt;\\\"><span><\\/span><\\/span>\\t\\t                  \\t\\t                  \",\"sales\":3,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:11:49\",\"update_time\":\"2018-12-24 10:39:22\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":22,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"001-1\",\"sku_thumb\":\"\",\"sku_stock\":998,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":2}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545703757', '1545703757');
INSERT INTO `wja_order_sku` VALUES ('11', '11', '20181225104329495410039864814', '1', '5', '4', '8', '22', '1', 'I9  PLUS   黑色', 'http://img.zxjsj.zhidekan.me/goods_20181224103921_2.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":8,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"I9  PLUS   \\u9ed1\\u8272\",\"goods_sn\":\"001\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220171329_7832e9f24083c5f3a35dfc9e97e2316.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103921_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103921_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":997,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf...\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t<p class=\\\"MsoBodyText\\\" style=\\\"margin-left:21.15pt;\\\" align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0\\u6307\\u7eb9\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u5bc6\\u7801\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u5237\\u5361\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0\\u94a5\\u5319\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t5.\\u00a0APP\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"MsoBodyText\\\" style=\\\"margin-left:21.15pt;\\\" align=\\\"center\\\">\\r\\n\\t\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0\\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0 5.\\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0 6.\\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t7.\\u00a0\\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t8.\\u00a0\\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t9.\\u00a0PIR\\u4eba\\u4f53\\u68c0\\u6d4b\\uff0c\\u5ba4\\u5916\\u5f02\\u5e38\\u4e3b\\u52a8\\u9632\\u8303\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u63d0\\u9192\\u67e5\\u770b\\uff1b\\u00a0\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"MsoNormal\\\">\\r\\n\\t\\t10.\\u00a0\\u667a\\u80fd\\u732b\\u773c\\uff0c\\u53ef\\u89c6\\u5bf9\\u8bb2\\u8fdc\\u7a0b\\u5f00\\u9501\\u66f4\\u5b89\\u5168\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"MsoNormal\\\">\\r\\n\\t\\t\\u00a0\\u00a0 11.\\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\r\\n\\t<\\/p>\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t\\u00a0\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t1.\\u00a0\\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t2.\\u00a0\\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t3.\\u00a0\\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:397.1pt;text-align:left;\\\">\\r\\n\\t\\t4.\\u00a0\\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b \\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t1.\\u00a0APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t2.\\u00a0\\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t3.\\u00a0\\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t4.\\u00a0\\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:397.1pt;text-align:left;\\\">\\r\\n\\t\\t5.\\u00a0\\u7535\\u5b50\\u95e8\\u94c3\\uff1b \\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t1.\\u00a0\\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t2.\\u00a0\\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t3.\\u00a0\\u94a2\\u5316\\u73bb\\u7483\\u9762\\u677f\\uff0c\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b\\u00a0\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t4.\\u00a0C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"MsoNormal\\\" style=\\\"text-align:left;\\\">\\r\\n\\t\\t<br \\/>\\r\\n\\t<\\/p>\\r\\n<br \\/>\\r\\n<b><span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;color:#BCD6ED;font-weight:bold;font-size:8.0000pt;\\\"> <\\/span><\\/b>\\r\\n<\\/p>\\r\\n<span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-size:11.0000pt;\\\"><\\/span><span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-weight:bold;font-size:11.0000pt;\\\"><span><\\/span><\\/span>\\t\\t                  \\t\\t                  \",\"sales\":4,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:11:49\",\"update_time\":\"2018-12-24 10:39:22\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":22,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"001-1\",\"sku_thumb\":\"\",\"sku_stock\":997,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":3}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545705809', '1545705809');
INSERT INTO `wja_order_sku` VALUES ('12', '12', '20181225111202509850119817794', '1', '5', '4', '8', '22', '1', 'I9  PLUS   黑色', 'http://img.zxjsj.zhidekan.me/goods_20181224103921_2.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":8,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"I9  PLUS   \\u9ed1\\u8272\",\"goods_sn\":\"001\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220171329_7832e9f24083c5f3a35dfc9e97e2316.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103921_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103921_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":996,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf...\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t<p class=\\\"MsoBodyText\\\" style=\\\"margin-left:21.15pt;\\\" align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0\\u6307\\u7eb9\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u5bc6\\u7801\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u5237\\u5361\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0\\u94a5\\u5319\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t5.\\u00a0APP\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"MsoBodyText\\\" style=\\\"margin-left:21.15pt;\\\" align=\\\"center\\\">\\r\\n\\t\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0\\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0 5.\\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0 6.\\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t7.\\u00a0\\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t8.\\u00a0\\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t9.\\u00a0PIR\\u4eba\\u4f53\\u68c0\\u6d4b\\uff0c\\u5ba4\\u5916\\u5f02\\u5e38\\u4e3b\\u52a8\\u9632\\u8303\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u63d0\\u9192\\u67e5\\u770b\\uff1b\\u00a0\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"MsoNormal\\\">\\r\\n\\t\\t10.\\u00a0\\u667a\\u80fd\\u732b\\u773c\\uff0c\\u53ef\\u89c6\\u5bf9\\u8bb2\\u8fdc\\u7a0b\\u5f00\\u9501\\u66f4\\u5b89\\u5168\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"MsoNormal\\\">\\r\\n\\t\\t\\u00a0\\u00a0 11.\\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\r\\n\\t<\\/p>\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t\\u00a0\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t1.\\u00a0\\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t2.\\u00a0\\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t3.\\u00a0\\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:397.1pt;text-align:left;\\\">\\r\\n\\t\\t4.\\u00a0\\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b \\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t1.\\u00a0APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t2.\\u00a0\\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t3.\\u00a0\\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t4.\\u00a0\\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:397.1pt;text-align:left;\\\">\\r\\n\\t\\t5.\\u00a0\\u7535\\u5b50\\u95e8\\u94c3\\uff1b \\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t1.\\u00a0\\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t2.\\u00a0\\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t3.\\u00a0\\u94a2\\u5316\\u73bb\\u7483\\u9762\\u677f\\uff0c\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b\\u00a0\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t4.\\u00a0C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"MsoNormal\\\" style=\\\"text-align:left;\\\">\\r\\n\\t\\t<br \\/>\\r\\n\\t<\\/p>\\r\\n<br \\/>\\r\\n<b><span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;color:#BCD6ED;font-weight:bold;font-size:8.0000pt;\\\"> <\\/span><\\/b>\\r\\n<\\/p>\\r\\n<span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-size:11.0000pt;\\\"><\\/span><span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-weight:bold;font-size:11.0000pt;\\\"><span><\\/span><\\/span>\\t\\t                  \\t\\t                  \",\"sales\":5,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:11:49\",\"update_time\":\"2018-12-24 10:39:22\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":22,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"001-1\",\"sku_thumb\":\"\",\"sku_stock\":996,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":4}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545707522', '1545707522');
INSERT INTO `wja_order_sku` VALUES ('13', '13', '20181225113556995798964280737', '1', '4', '3', '11', '18', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1989,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":11,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":997,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":3},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":992,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":8}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545708956', '1545708956');
INSERT INTO `wja_order_sku` VALUES ('14', '14', '20181225114444995399352182151', '1', '4', '3', '11', '18', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1988,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":12,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":996,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":4},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":992,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":8}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545709484', '1545709484');
INSERT INTO `wja_order_sku` VALUES ('15', '15', '20181225114444999950718379329', '1', '5', '4', '11', '18', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1987,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":13,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":995,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":5},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":992,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":8}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545709484', '1545709484');
INSERT INTO `wja_order_sku` VALUES ('16', '16', '20181225115553575255469740793', '1', '5', '4', '11', '18', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1986,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":14,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":994,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":6},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":992,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":8}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545710153', '1545710153');
INSERT INTO `wja_order_sku` VALUES ('17', '17', '20181225115636525052931985577', '1', '5', '4', '9', '21', '1', 'I9 黑色', 'http://img.zxjsj.zhidekan.me/goods_20181224103909_3.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":9,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"I9 \\u9ed1\\u8272\",\"goods_sn\":\"002\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220173226_7832e9f24083c5f3a35dfc9e97e2316.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103909_3.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103909_3.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":997,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t<div class=\\\"Section0\\\" align=\\\"center\\\">\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t1.\\u00a0\\u6307\\u7eb9\\u5f00\\u9501\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t2.\\u00a0\\u5bc6\\u7801\\u5f00\\u9501\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t3.\\u00a0\\u5237\\u5361\\u5f00\\u9501\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t4.\\u00a0\\u94a5\\u5319\\u5f00\\u9501\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t5.\\u00a0APP\\u5f00\\u9501\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t1.\\u00a0FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t2.\\u00a0\\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t3.\\u00a0\\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t4.\\u00a0\\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t5.\\u00a0\\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t6.\\u00a0\\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t7.\\u00a0\\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t8.\\u00a0\\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t9.\\u00a0\\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\r\\n\\t<\\/p>\\r\\n<\\/div>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0\\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0\\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\" align=\\\"center\\\">\\r\\n\\t\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0\\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\" align=\\\"center\\\">\\r\\n\\t5.\\u00a0\\u7535\\u5b50\\u95e8\\u94c3\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\" align=\\\"center\\\">\\r\\n\\t\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0\\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u94a2\\u5316\\u73bb\\u7483\\u9762\\u677f\\uff0c\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b\\u00a0\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t<br \\/>\\r\\n<\\/p>\\r\\n<div align=\\\"center\\\">\\r\\n\\t<br \\/>\\r\\n<\\/div>\\t\\t                  \\t\\t                  \",\"sales\":3,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:32:28\",\"update_time\":\"2018-12-24 10:39:10\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":11,\"sku_id\":0,\"skus\":[{\"sku_id\":21,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"002-1\",\"sku_thumb\":\"\",\"sku_stock\":997,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":3}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545710196', '1545710196');
INSERT INTO `wja_order_sku` VALUES ('18', '18', '20181225115858509810411449076', '1', '5', '4', '8', '22', '1', 'I9  PLUS   黑色', 'http://img.zxjsj.zhidekan.me/goods_20181224103921_2.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":8,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"I9  PLUS   \\u9ed1\\u8272\",\"goods_sn\":\"001\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220171329_7832e9f24083c5f3a35dfc9e97e2316.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103921_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103921_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":995,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf...\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t<p class=\\\"MsoBodyText\\\" style=\\\"margin-left:21.15pt;\\\" align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0\\u6307\\u7eb9\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u5bc6\\u7801\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u5237\\u5361\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0\\u94a5\\u5319\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t5.\\u00a0APP\\u5f00\\u9501\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"MsoBodyText\\\" style=\\\"margin-left:21.15pt;\\\" align=\\\"center\\\">\\r\\n\\t\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:39.2pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0\\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0 5.\\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0\\u00a0 6.\\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t7.\\u00a0\\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t8.\\u00a0\\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t9.\\u00a0PIR\\u4eba\\u4f53\\u68c0\\u6d4b\\uff0c\\u5ba4\\u5916\\u5f02\\u5e38\\u4e3b\\u52a8\\u9632\\u8303\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u63d0\\u9192\\u67e5\\u770b\\uff1b\\u00a0\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"MsoNormal\\\">\\r\\n\\t\\t10.\\u00a0\\u667a\\u80fd\\u732b\\u773c\\uff0c\\u53ef\\u89c6\\u5bf9\\u8bb2\\u8fdc\\u7a0b\\u5f00\\u9501\\u66f4\\u5b89\\u5168\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"MsoNormal\\\">\\r\\n\\t\\t\\u00a0\\u00a0 11.\\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\r\\n\\t<\\/p>\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t\\u00a0\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t1.\\u00a0\\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t2.\\u00a0\\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t3.\\u00a0\\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:397.1pt;text-align:left;\\\">\\r\\n\\t\\t4.\\u00a0\\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b \\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t1.\\u00a0APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t2.\\u00a0\\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t3.\\u00a0\\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t4.\\u00a0\\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:397.1pt;text-align:left;\\\">\\r\\n\\t\\t5.\\u00a0\\u7535\\u5b50\\u95e8\\u94c3\\uff1b \\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t1.\\u00a0\\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t2.\\u00a0\\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t3.\\u00a0\\u94a2\\u5316\\u73bb\\u7483\\u9762\\u677f\\uff0c\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b\\u00a0\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"15\\\" style=\\\"margin-left:415.1pt;text-align:left;\\\">\\r\\n\\t\\t4.\\u00a0C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"MsoNormal\\\" style=\\\"text-align:left;\\\">\\r\\n\\t\\t<br \\/>\\r\\n\\t<\\/p>\\r\\n<br \\/>\\r\\n<b><span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;color:#BCD6ED;font-weight:bold;font-size:8.0000pt;\\\"> <\\/span><\\/b>\\r\\n<\\/p>\\r\\n<span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-size:11.0000pt;\\\"><\\/span><span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-weight:bold;font-size:11.0000pt;\\\"><span><\\/span><\\/span>\\t\\t                  \\t\\t                  \",\"sales\":6,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:11:49\",\"update_time\":\"2018-12-24 10:39:22\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":22,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"001-1\",\"sku_thumb\":\"\",\"sku_stock\":995,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":5}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545710338', '1545710338');
INSERT INTO `wja_order_sku` VALUES ('19', '19', '20181225120213539797440763134', '1', '5', '4', '10', '23', '1', 'Q7   土豪金+黑灰色', 'http://img.zxjsj.zhidekan.me/goods_20181224103901_2.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;土豪金;大', '{\"goods_id\":10,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"Q7   \\u571f\\u8c6a\\u91d1+\\u9ed1\\u7070\\u8272\",\"goods_sn\":\"003\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220174748_14e3301ccb3505523d547aae9895e75.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103901_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103901_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":996,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b\\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b<span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-size:11.0000pt;\\\"><\\/span><span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-size:11.0000pt;\\\"><\\/span>\\r\\n<\\/div>\\t\\t                  \\t\\t                  \",\"sales\":4,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:51:33\",\"update_time\":\"2018-12-24 10:39:04\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u571f\\u8c6a\\u91d1\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":23,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u571f\\u8c6a\\u91d1 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"003-2\",\"sku_thumb\":\"\",\"sku_stock\":996,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u571f\\u8c6a\\u91d1;\\u5927\",\"sales\":4}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545710533', '1545710533');
INSERT INTO `wja_order_sku` VALUES ('20', '20', '20181225120652995398333107220', '1', '5', '4', '11', '18', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1985,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":15,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":993,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":7},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":992,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":8}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545710812', '1545710812');
INSERT INTO `wja_order_sku` VALUES ('21', '21', '20181225121455102545363935718', '1', '5', '4', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1984,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":16,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":992,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":8},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":992,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":8}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545711295', '1545711295');
INSERT INTO `wja_order_sku` VALUES ('22', '22', '20181225122855555099860202144', '1', '5', '4', '9', '21', '1', 'I9 黑色', 'http://img.zxjsj.zhidekan.me/goods_20181224103909_3.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":9,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"I9 \\u9ed1\\u8272\",\"goods_sn\":\"002\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220173226_7832e9f24083c5f3a35dfc9e97e2316.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103909_3.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103909_3.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":996,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t<div class=\\\"Section0\\\" align=\\\"center\\\">\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t1.\\u00a0\\u6307\\u7eb9\\u5f00\\u9501\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t2.\\u00a0\\u5bc6\\u7801\\u5f00\\u9501\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t3.\\u00a0\\u5237\\u5361\\u5f00\\u9501\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t4.\\u00a0\\u94a5\\u5319\\u5f00\\u9501\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t5.\\u00a0APP\\u5f00\\u9501\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t1.\\u00a0FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t2.\\u00a0\\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t3.\\u00a0\\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t4.\\u00a0\\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t5.\\u00a0\\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t6.\\u00a0\\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t7.\\u00a0\\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t8.\\u00a0\\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t9.\\u00a0\\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b\\r\\n\\t<\\/p>\\r\\n\\t<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\">\\r\\n\\t\\t\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\r\\n\\t<\\/p>\\r\\n<\\/div>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0\\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0\\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\" align=\\\"center\\\">\\r\\n\\t\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0\\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\" align=\\\"center\\\">\\r\\n\\t5.\\u00a0\\u7535\\u5b50\\u95e8\\u94c3\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:397.1pt;\\\" align=\\\"center\\\">\\r\\n\\t\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t1.\\u00a0\\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t2.\\u00a0\\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t3.\\u00a0\\u94a2\\u5316\\u73bb\\u7483\\u9762\\u677f\\uff0c\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b\\u00a0\\r\\n<\\/p>\\r\\n<p class=\\\"16\\\" style=\\\"margin-left:415.1pt;\\\" align=\\\"center\\\">\\r\\n\\t4.\\u00a0C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/p>\\r\\n<p class=\\\"MsoNormal\\\" align=\\\"center\\\">\\r\\n\\t<br \\/>\\r\\n<\\/p>\\r\\n<div align=\\\"center\\\">\\r\\n\\t<br \\/>\\r\\n<\\/div>\\t\\t                  \\t\\t                  \",\"sales\":4,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:32:28\",\"update_time\":\"2018-12-24 10:39:10\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":11,\"sku_id\":0,\"skus\":[{\"sku_id\":21,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"002-1\",\"sku_thumb\":\"\",\"sku_stock\":996,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":4}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545712135', '1545712135');
INSERT INTO `wja_order_sku` VALUES ('23', '23', '20181225125249495255423378410', '1', '5', '4', '10', '23', '1', 'Q7   土豪金+黑灰色', 'http://img.zxjsj.zhidekan.me/goods_20181224103901_2.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;土豪金;大', '{\"goods_id\":10,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"Q7   \\u571f\\u8c6a\\u91d1+\\u9ed1\\u7070\\u8272\",\"goods_sn\":\"003\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220174748_14e3301ccb3505523d547aae9895e75.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103901_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103901_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":995,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b\\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b<span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-size:11.0000pt;\\\"><\\/span><span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-size:11.0000pt;\\\"><\\/span>\\r\\n<\\/div>\\t\\t                  \\t\\t                  \",\"sales\":5,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:51:33\",\"update_time\":\"2018-12-24 10:39:04\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u571f\\u8c6a\\u91d1\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":23,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u571f\\u8c6a\\u91d1 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"003-2\",\"sku_thumb\":\"\",\"sku_stock\":995,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u571f\\u8c6a\\u91d1;\\u5927\",\"sales\":5}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545713569', '1545713569');
INSERT INTO `wja_order_sku` VALUES ('24', '24', '20181225131026501004652642017', '1', '5', '4', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1983,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":17,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":992,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":8},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":991,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":9}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545714626', '1545714626');
INSERT INTO `wja_order_sku` VALUES ('25', '25', '20181225142636999710963464721', '1', '5', '4', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1982,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":18,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":992,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":8},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":990,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":10}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545719196', '1545719196');
INSERT INTO `wja_order_sku` VALUES ('26', '26', '20181225143510101524067231322', '1', '5', '4', '11', '18', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1981,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":19,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":992,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":8},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":989,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":11}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545719710', '1545719710');
INSERT INTO `wja_order_sku` VALUES ('27', '27', '20181225144306975048616924664', '1', '5', '4', '11', '18', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1980,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":20,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":991,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":9},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":989,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":11}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545720186', '1545720186');
INSERT INTO `wja_order_sku` VALUES ('28', '28', '20181225144322974956027879121', '1', '4', '3', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1979,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":21,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":990,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":10},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":989,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":11}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545720202', '1545720202');
INSERT INTO `wja_order_sku` VALUES ('29', '29', '20181225144523519950259485886', '1', '4', '3', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1978,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":22,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":990,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":10},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":988,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":12}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545720323', '1545720323');
INSERT INTO `wja_order_sku` VALUES ('30', '30', '20181225145420995098669939526', '1', '5', '4', '10', '23', '1', 'Q7   土豪金+黑灰色', 'http://img.zxjsj.zhidekan.me/goods_20181224103901_2.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;土豪金;大', '{\"goods_id\":10,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"Q7   \\u571f\\u8c6a\\u91d1+\\u9ed1\\u7070\\u8272\",\"goods_sn\":\"003\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220174748_14e3301ccb3505523d547aae9895e75.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103901_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103901_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":994,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b\\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b<span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-size:11.0000pt;\\\"><\\/span><span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-size:11.0000pt;\\\"><\\/span>\\r\\n<\\/div>\\t\\t                  \\t\\t                  \",\"sales\":6,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:51:33\",\"update_time\":\"2018-12-24 10:39:04\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u571f\\u8c6a\\u91d1\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":23,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u571f\\u8c6a\\u91d1 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"003-2\",\"sku_thumb\":\"\",\"sku_stock\":994,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u571f\\u8c6a\\u91d1;\\u5927\",\"sales\":6}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545720860', '1545720860');
INSERT INTO `wja_order_sku` VALUES ('31', '31', '20181225145834975550077286485', '1', '5', '4', '11', '18', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1977,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":23,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":990,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":10},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":987,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":13}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545721114', '1545721114');
INSERT INTO `wja_order_sku` VALUES ('32', '32', '20181225151102549853093709219', '1', '4', '3', '10', '23', '1', 'Q7   土豪金+黑灰色', 'http://img.zxjsj.zhidekan.me/goods_20181224103901_2.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;土豪金;大', '{\"goods_id\":10,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"Q7   \\u571f\\u8c6a\\u91d1+\\u9ed1\\u7070\\u8272\",\"goods_sn\":\"003\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220174748_14e3301ccb3505523d547aae9895e75.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103901_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103901_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":993,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b\\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b<span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-size:11.0000pt;\\\"><\\/span><span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-size:11.0000pt;\\\"><\\/span>\\r\\n<\\/div>\\t\\t                  \\t\\t                  \",\"sales\":7,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:51:33\",\"update_time\":\"2018-12-24 10:39:04\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u571f\\u8c6a\\u91d1\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":23,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u571f\\u8c6a\\u91d1 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"003-2\",\"sku_thumb\":\"\",\"sku_stock\":993,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u571f\\u8c6a\\u91d1;\\u5927\",\"sales\":7}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545721862', '1545721862');
INSERT INTO `wja_order_sku` VALUES ('33', '33', '20181225151317100100663220192', '1', '5', '4', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1976,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":24,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":989,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":11},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":987,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":13}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545721997', '1545721997');
INSERT INTO `wja_order_sku` VALUES ('34', '34', '20181226095553575155600481175', '1', '5', '4', '11', '18', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1975,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":25,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":989,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":11},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":986,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":14}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545789353', '1545789353');
INSERT INTO `wja_order_sku` VALUES ('35', '35', '20181226113207554999627746460', '1', '4', '3', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1978,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":22,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":991,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":9},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":987,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":13}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545795127', '1545795127');
INSERT INTO `wja_order_sku` VALUES ('36', '36', '20181227163226975110293764391', '1', '22', '10', '11', '18', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1977,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":23,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":991,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":9},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":986,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":14}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545899546', '1545899546');
INSERT INTO `wja_order_sku` VALUES ('37', '37', '20181227163917535699416879519', '1', '22', '10', '10', '23', '1', 'Q7   土豪金+黑灰色', 'http://img.zxjsj.zhidekan.me/goods_20181224103901_2.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;土豪金;大', '{\"goods_id\":10,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"Q7   \\u571f\\u8c6a\\u91d1+\\u9ed1\\u7070\\u8272\",\"goods_sn\":\"003\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220174748_14e3301ccb3505523d547aae9895e75.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103901_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103901_2.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":993,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b\\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b<span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-size:11.0000pt;\\\"><\\/span><span style=\\\"font-family:\\u5fae\\u8f6f\\u96c5\\u9ed1;font-size:11.0000pt;\\\"><\\/span>\\r\\n<\\/div>\\t\\t                  \\t\\t                  \",\"sales\":7,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:51:33\",\"update_time\":\"2018-12-24 10:39:04\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u571f\\u8c6a\\u91d1\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":23,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u571f\\u8c6a\\u91d1 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"003-2\",\"sku_thumb\":\"\",\"sku_stock\":993,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u571f\\u8c6a\\u91d1;\\u5927\",\"sales\":7}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545899957', '1545899957');
INSERT INTO `wja_order_sku` VALUES ('38', '38', '20181227165721494954166112109', '1', '22', '10', '11', '18', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;黑色;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/goods_20181220175424_07779ae171dd77c3ffe4e33c0dbdf02.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1977,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":23,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-24 10:39:35\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":991,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":9},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":986,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":14}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545901041', '1545901041');
INSERT INTO `wja_order_sku` VALUES ('39', '39', '20181228170346501005194047741', '1', '22', '10', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181228144510_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1976,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":24,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-28 14:45:11\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":990,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":10},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":986,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":14}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545987826', '1545987826');
INSERT INTO `wja_order_sku` VALUES ('40', '40', '20181228175445534853281947923', '1', '5', '4', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181228144510_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1975,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":25,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-28 14:45:11\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":990,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":10},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":985,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":15}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545990885', '1545990885');
INSERT INTO `wja_order_sku` VALUES ('41', '41', '20181228184005534910223759900', '1', '5', '4', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181228144510_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1974,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":26,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-28 14:45:11\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":990,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":10},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":984,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":16}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545993605', '1545993605');
INSERT INTO `wja_order_sku` VALUES ('42', '42', '20181228184210501024133410700', '1', '5', '4', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181228144510_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1973,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":27,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-28 14:45:11\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":990,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":10},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":983,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":17}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1545993730', '1545993730');
INSERT INTO `wja_order_sku` VALUES ('43', '43', '20181229095605535755091943774', '1', '5', '4', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181228144510_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1972,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":28,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-28 14:45:11\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":990,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":10},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":982,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":18}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1546048565', '1546048565');
INSERT INTO `wja_order_sku` VALUES ('44', '44', '20181229100233579855109535557', '1', '5', '4', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181228144510_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1972,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":28,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-28 14:45:11\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":990,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":10},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":982,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":18}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1546048953', '1546048953');
INSERT INTO `wja_order_sku` VALUES ('45', '45', '20181229120903102535045970359', '1', '4', '3', '11', '19', '1', 'L5  黑灰  香槟粉', 'http://img.zxjsj.zhidekan.me/goods_20181224103931_4.jpg?imageMogr2/auto-orient/thumbnail/!500x500r/gravity/Center/crop/500x500/format/jpg/blur/1x0/quality/75', '32G;香槟粉;大', '{\"goods_id\":11,\"store_id\":1,\"cate_id\":2,\"goods_cate\":1,\"goods_type\":1,\"name\":\"L5  \\u9ed1\\u7070  \\u9999\\u69df\\u7c89\",\"goods_sn\":\"004\",\"cate_thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181228144510_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"thumb\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"imgs\":[\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103931_4.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\",\"http:\\/\\/img.zxjsj.zhidekan.me\\/goods_20181224103855_1.jpg?imageMogr2\\/auto-orient\\/thumbnail\\/!500x500r\\/gravity\\/Center\\/crop\\/500x500\\/format\\/jpg\\/blur\\/1x0\\/quality\\/75\"],\"min_price\":\"0.01\",\"max_price\":\"0.01\",\"install_price\":\"0.01\",\"goods_stock\":1971,\"description\":\"\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319\\u3002\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c\\u3002\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c\\u3002\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf\",\"content\":\"\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t\\t\\t                  \\t<div align=\\\"center\\\">\\r\\n\\t\\u591a\\u79cd\\u667a\\u80fd\\u5f00\\u95e8\\u65b9\\u5f0f\\uff0c\\u518d\\u4e5f\\u4e0d\\u6015\\u5fd8\\u5e26\\u94a5\\u5319<br \\/>\\r\\n1. \\u6307\\u7eb9\\u5f00\\u9501\\uff1b<br \\/>\\r\\n2. \\u5bc6\\u7801\\u5f00\\u9501\\uff1b<br \\/>\\r\\n3. \\u5237\\u5361\\u5f00\\u9501\\uff1b<br \\/>\\r\\n4. \\u94a5\\u5319\\u5f00\\u9501\\uff1b<br \\/>\\r\\n5. APP\\u5f00\\u9501\\uff1b<br \\/>\\r\\n\\u5168\\u65b9\\u4f4d\\u9632\\u8303\\uff0c\\u5b89\\u5168\\u6709\\u4fdd\\u969c<br \\/>\\r\\n1. FPC\\u534a\\u5bfc\\u4f53\\u6d3b\\u4f53\\u81ea\\u5b66\\u4e60\\u6307\\u7eb9\\u8bc6\\u522b\\uff0c\\u8d8a\\u7528\\u8d8a\\u7075\\u654f\\uff0c\\u675c\\u7edd\\u5047\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n2. \\u865a\\u4f4d\\u5bc6\\u7801\\uff0c\\u4e0d\\u6015\\u5077\\u7aa5\\uff1b<br \\/>\\r\\n3. \\u53cc\\u91cd\\u9a8c\\u8bc1\\u5b89\\u5168\\u5f00\\u9501\\u6a21\\u5f0f\\uff08\\u6307\\u7eb9\\/\\u5bc6\\u7801\\/\\u5237\\u5361\\uff0c\\u4efb\\u610f\\u4e24\\u79cd\\u7ec4\\u5408\\u5f00\\u95e8\\uff09\\uff1b<br \\/>\\r\\n4. \\u5c1d\\u8bd5\\u89e3\\u9501\\u65f6\\u7cfb\\u7edf\\u9501\\u5b9a\\u3001\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1\\uff1b<br \\/>\\r\\n5. \\u9632\\u64ac\\u9501\\u672c\\u5730\\u62a5\\u8b66\\u3001\\u6293\\u62cd\\u53ca\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\u3001\\u624b\\u673a\\u77ed\\u4fe1 \\uff1b<br \\/>\\r\\n6. \\u80c1\\u8feb\\u5f00\\u9501\\u5bc6\\u7801\\u548c\\u6307\\u7eb9\\uff0c\\u9690\\u853d\\u62a5\\u8b66\\uff0c\\u4fe1\\u606f\\u63a8\\u9001\\u81f3APP\\uff0c\\u540c\\u65f6\\u7ed9\\u8bbe\\u5b9a\\u53f7\\u7801\\u62e8\\u6253\\u7535\\u8bdd\\uff1b<br \\/>\\r\\n7. \\u81ea\\u52a8\\u9501\\u5b9a\\u65f6\\u957f\\u7075\\u6d3b\\u5b9a\\u4e49\\uff0c\\u9632\\u5c3e\\u968f\\uff1b<br \\/>\\r\\n8. \\u5ba4\\u5185\\u628a\\u624b\\u9632\\u732b\\u773c\\u5f00\\u9501\\u8bbe\\u8ba1\\uff1b<br \\/>\\r\\n9. \\u667a\\u80fd\\u8054\\u52a8\\uff1a\\u79bb\\u5bb6\\u5e03\\u9632\\u3001\\u56de\\u5bb6\\u64a4\\u9632\\u3001\\u8054\\u52a8\\u7b56\\u7565\\uff1b<br \\/>\\r\\n\\u4eb2\\u60c5\\u4e92\\u52a8\\uff0c\\u5f00\\u542f\\u667a\\u6167\\u5230\\u5bb6\\u65b0\\u4f53\\u9a8c<br \\/>\\r\\n1. \\u8bed\\u97f3\\u7559\\u8a00\\u3001\\u5907\\u5fd8\\u63d0\\u9192\\uff0c\\u7ed9\\u5979\\u60ca\\u559c\\u3001\\u8868\\u8fbe\\u6e29\\u60c5\\uff08\\u7f51\\u5173\\u64ad\\u653e\\uff09\\uff1b\\u2605<br \\/>\\r\\n2. \\u5bb6\\u4eba\\u5230\\u5bb6\\uff0c\\u5b9e\\u65f6\\u63d0\\u9192\\uff1b<br \\/>\\r\\n3. \\u8fdc\\u7a0b\\u6388\\u6743\\u4e34\\u65f6\\u5bc6\\u7801\\uff0c\\u53ef\\u8f7b\\u677e\\u5e94\\u5bf9\\u4e34\\u65f6\\u5230\\u8bbf\\uff1b<br \\/>\\r\\n4. \\u6e29\\u99a8\\u95ee\\u5019\\uff1a\\u201c\\u503c\\u7ba1\\u5bb6\\u6b22\\u8fce\\u4f60\\uff01\\u201d\\uff1b<br \\/>\\r\\n\\u8f7b\\u677e\\u7ba1\\u7406\\uff0c\\u64cd\\u4f5c\\u65b9\\u4fbf<br \\/>\\r\\n1. APP\\u7ba1\\u7406\\uff0c\\u8f7b\\u677e\\u638c\\u63e1\\uff1b<br \\/>\\r\\n2. \\u6307\\u7eb9\\u9a8c\\u8bc1\\u3001\\u5f00\\u95e8\\u4e00\\u6b65\\u5230\\u4f4d\\uff1b<br \\/>\\r\\n3. \\u5ba4\\u5185\\u628a\\u624b\\u4e0a\\u63d0\\u53cd\\u9501\\uff0c\\u4e0b\\u538b\\u5f00\\u95e8\\uff1b<br \\/>\\r\\n4. \\u652f\\u6301\\u5404\\u79cdNFC\\u5361\\u5199\\u5165\\u7ed1\\u5b9a\\uff0c\\u5982\\u8eab\\u4efd\\u8bc1\\u3001\\u516c\\u4ea4\\u5361\\u3001\\u95e8\\u7981\\u5361\\u7b49\\uff1b<br \\/>\\r\\n5. \\u7535\\u5b50\\u95e8\\u94c3\\uff1b<br \\/>\\r\\n\\u5176\\u5b83\\u5b9e\\u7528\\u529f\\u80fd<br \\/>\\r\\n1. \\u8d85\\u4f4e\\u529f\\u8017\\uff0c12\\u4e2a\\u6708\\u957f\\u7eed\\u822a\\uff1b<br \\/>\\r\\n2. \\u4f4e\\u7535\\u63d0\\u9192\\uff0cUSB\\u5e94\\u6025\\u4f9b\\u7535\\uff1b<br \\/>\\r\\n3. \\u9762\\u677f\\u7279\\u6b8a\\u5904\\u7406\\u4e0d\\u7559\\u6307\\u7eb9\\uff1b<br \\/>\\r\\n4. C\\u7ea7\\u9501\\u82af\\uff0c\\u56fd\\u5bb6\\u6807\\u51c6\\uff1b\\r\\n<\\/div>\\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \\t\\t                  \",\"sales\":29,\"sort_order\":1,\"status\":1,\"is_del\":0,\"add_time\":\"2018-12-20 17:54:48\",\"update_time\":\"2018-12-28 14:45:11\",\"specs_json\":[{\"specid\":\"1\",\"specname\":\"\\u5bb9\\u91cf\",\"list\":[\"32G\"]},{\"specid\":\"2\",\"specname\":\"\\u989c\\u8272\",\"list\":[\"\\u9ed1\\u8272\",\"\\u9999\\u69df\\u7c89\"]},{\"specid\":\"3\",\"specname\":\"\\u5927\\u5c0f\",\"list\":[\"\\u5927\"]}],\"stock_reduce_time\":1,\"sample_purchase_limit\":0,\"stock_warning_num\":10,\"sku_id\":0,\"skus\":[{\"sku_id\":18,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9ed1\\u8272 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-1\",\"sku_thumb\":\"\",\"sku_stock\":990,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9ed1\\u8272;\\u5927\",\"sales\":10},{\"sku_id\":19,\"sku_name\":\"\\u5bb9\\u91cf:32G \\u989c\\u8272:\\u9999\\u69df\\u7c89 \\u5927\\u5c0f:\\u5927 \",\"sku_sn\":\"004-2\",\"sku_thumb\":\"\",\"sku_stock\":981,\"install_price\":\"0.01\",\"price\":\"0.01\",\"spec_value\":\"32G;\\u9999\\u69df\\u7c89;\\u5927\",\"sales\":19}]}', '1', '0.01', '0.01', '0.02', '0.00', '0.02', '1', '', '0', '0', '1546056543', '1546056543');

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
  `ossub_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '订单商品-商品ID(多个用","逗号分割)',
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
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '卖家商户ID',
  `service_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '售后单号',
  `service_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '售后服务类型(1退货退款)',
  `order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单ID',
  `order_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '订单号',
  `osku_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单商品ID',
  `ossub_id` int(10) unsigned NOT NULL DEFAULT '0',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '退款申请用户ID',
  `user_store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '申请商户ID',
  `num` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '退货/退款商品数量',
  `refund_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '退款金额',
  `remark` varchar(500) NOT NULL DEFAULT '' COMMENT '申请说明',
  `imgs` varchar(2000) NOT NULL DEFAULT '' COMMENT '申请凭证(json格式)',
  `service_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '售后状态(-2已取消 -1拒绝申请 0申请中 1等待买家退货 2等待卖家退款 3退款成功)',
  `refund_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '退款时间',
  `refund_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '退款类型(1原路退)',
  `transfer_no` varchar(255) NOT NULL DEFAULT '' COMMENT '退款转账流水号',
  `admin_remark` varchar(500) NOT NULL DEFAULT '' COMMENT '后台审核操作备注',
  `sort_order` int(1) unsigned NOT NULL DEFAULT '1',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '发起售后时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '申请状态(0：禁用 1：正常)',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_delivery` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否需要第三方物流',
  `delivery_identif` varchar(255) NOT NULL DEFAULT '' COMMENT '物流公司唯一标识',
  `delivery_name` varchar(255) NOT NULL DEFAULT '' COMMENT '物流名称',
  `delivery_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '物流单号',
  `delivery_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '发货状态(0：待发货，1：已发货，2：已收货)',
  `delivery_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '发货时间',
  PRIMARY KEY (`service_id`),
  KEY `store_id` (`store_id`),
  KEY `ossub_id` (`ossub_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='商品售后表';

-- ----------------------------
-- Records of wja_order_sku_service
-- ----------------------------
INSERT INTO `wja_order_sku_service` VALUES ('1', '1', '162977840130484810', '1', '36', '20181227163226975110293764391', '36', '38', '22', '10', '1', '0.02', '质量有问题', '[\"http:\\/\\/img.zxjsj.zhidekan.me\\/order_service_20181227163801.png\"]', '3', '1545899916', '1', '162977840130484810', '', '1', '1545899584', '1545899916', '0', '0', '0', 'yuantong', '圆通快递', '123456', '1', '1545899900');
INSERT INTO `wja_order_sku_service` VALUES ('2', '1', '967195277582101100', '1', '37', '20181227163917535699416879519', '37', '39', '22', '10', '1', '0.02', '缺钱花啦~~', '', '3', '1545900164', '1', '967195277582101100', '', '1', '1545900046', '1545900164', '0', '0', '0', '', '', '', '1', '1545900061');
INSERT INTO `wja_order_sku_service` VALUES ('3', '1', '035716243344525497', '1', '38', '20181227165721494954166112109', '38', '40', '22', '10', '1', '0.02', 'v v\r\n -', '', '0', '0', '1', '', '', '1', '1545901092', '1545901092', '0', '0', '0', '', '', '', '0', '0');
INSERT INTO `wja_order_sku_service` VALUES ('4', '1', '696925376535974810', '1', '43', '20181229095605535755091943774', '43', '45', '5', '4', '1', '0.02', '1', '', '3', '1546048804', '1', '696925376535974810', '微信原路退款', '1', '1546048730', '1546048804', '0', '0', '0', '', '', '', '1', '1546048784');

-- ----------------------------
-- Table structure for wja_order_sku_sub
-- ----------------------------
DROP TABLE IF EXISTS `wja_order_sku_sub`;
CREATE TABLE `wja_order_sku_sub` (
  `ossub_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `good_sku_code` varchar(255) NOT NULL DEFAULT '' COMMENT '单个商品唯一串码',
  `order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '关联订单ID',
  `order_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '关联订单编号',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '厂商ID',
  `osku_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '关联订单商品ID',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '购买用户ID',
  `user_store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '购买用户商户ID',
  `goods_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `sku_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品规格属性ID',
  `sku_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '产品单价',
  `install_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '安装费',
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '单个商品成交价',
  `real_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  `delivery_price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '运费',
  `odelivery_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'order_sku_delivery表自增长ID',
  `delivery_name` varchar(255) NOT NULL DEFAULT '' COMMENT '物流名称',
  `delivery_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '物流单号',
  `delivery_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '发货状态(0：待发货，1：已发货，2：已收货)',
  `delivery_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '发货时间',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ossub_id`),
  UNIQUE KEY `good_sku_code` (`good_sku_code`),
  KEY `order_id` (`order_id`),
  KEY `order_sn` (`order_sn`),
  KEY `osku_id` (`osku_id`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=utf8 COMMENT='订单商品明细表';

-- ----------------------------
-- Records of wja_order_sku_sub
-- ----------------------------
INSERT INTO `wja_order_sku_sub` VALUES ('1', 'auto_004-2_7177237164', '1', '20181221161445531015571266774', '1', '1', '5', '4', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545380085', '1545380085');
INSERT INTO `wja_order_sku_sub` VALUES ('2', 'auto_004-2_7387418628', '2', '20181221171909100971243370754', '1', '2', '4', '3', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545383949', '1545383949');
INSERT INTO `wja_order_sku_sub` VALUES ('3', 'auto_004-2_9536705682', '3', '20181221174711102100020789604', '1', '3', '5', '4', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545385631', '1545385631');
INSERT INTO `wja_order_sku_sub` VALUES ('4', 'auto_004-1_9270676536', '4', '20181221174955515197060400288', '1', '4', '5', '4', '11', '18', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545385795', '1545385795');
INSERT INTO `wja_order_sku_sub` VALUES ('5', 'auto_003-2_1381884584', '5', '20181224091740525252047510697', '1', '5', '5', '4', '10', '23', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545614260', '1545614260');
INSERT INTO `wja_order_sku_sub` VALUES ('6', 'auto_004-2_7401845788', '6', '20181224182633571001288537126', '1', '6', '5', '4', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545647193', '1545647193');
INSERT INTO `wja_order_sku_sub` VALUES ('7', 'auto_004-1_5624151253', '7', '20181225094902101102305253833', '1', '7', '5', '4', '11', '18', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545702543', '1545702543');
INSERT INTO `wja_order_sku_sub` VALUES ('8', 'auto_004-1_8735481443', '7', '20181225094902101102305253833', '1', '7', '5', '4', '11', '18', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545702543', '1545702543');
INSERT INTO `wja_order_sku_sub` VALUES ('9', 'auto_004-1_9225739875', '8', '20181225095004991015104960914', '1', '8', '5', '4', '11', '18', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545702604', '1545702604');
INSERT INTO `wja_order_sku_sub` VALUES ('10', 'auto_004-1_8975804348', '8', '20181225095004991015104960914', '1', '8', '5', '4', '11', '18', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545702604', '1545702604');
INSERT INTO `wja_order_sku_sub` VALUES ('11', 'auto_002-1_6468385888', '9', '20181225095746975048006806088', '1', '9', '5', '4', '9', '21', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545703066', '1545703066');
INSERT INTO `wja_order_sku_sub` VALUES ('12', 'auto_001-1_6929068793', '10', '20181225100917100101148975214', '1', '10', '5', '4', '8', '22', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545703757', '1545703757');
INSERT INTO `wja_order_sku_sub` VALUES ('13', 'auto_001-1_1604512264', '11', '20181225104329495410039864814', '1', '11', '5', '4', '8', '22', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545705809', '1545705809');
INSERT INTO `wja_order_sku_sub` VALUES ('14', 'auto_001-1_3795383823', '12', '20181225111202509850119817794', '1', '12', '5', '4', '8', '22', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545707522', '1545707522');
INSERT INTO `wja_order_sku_sub` VALUES ('15', 'auto_004-1_4937452749', '13', '20181225113556995798964280737', '1', '13', '4', '3', '11', '18', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545708956', '1545708956');
INSERT INTO `wja_order_sku_sub` VALUES ('16', 'auto_004-1_2597124648', '14', '20181225114444995399352182151', '1', '14', '4', '3', '11', '18', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545709484', '1545709484');
INSERT INTO `wja_order_sku_sub` VALUES ('17', 'auto_004-1_6723242418', '15', '20181225114444999950718379329', '1', '15', '5', '4', '11', '18', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545709484', '1545709484');
INSERT INTO `wja_order_sku_sub` VALUES ('18', 'auto_004-1_3517223300', '16', '20181225115553575255469740793', '1', '16', '5', '4', '11', '18', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545710153', '1545710153');
INSERT INTO `wja_order_sku_sub` VALUES ('19', 'auto_002-1_4474741054', '17', '20181225115636525052931985577', '1', '17', '5', '4', '9', '21', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545710196', '1545710196');
INSERT INTO `wja_order_sku_sub` VALUES ('20', 'auto_001-1_6813057325', '18', '20181225115858509810411449076', '1', '18', '5', '4', '8', '22', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545710338', '1545710338');
INSERT INTO `wja_order_sku_sub` VALUES ('21', 'auto_003-2_6103723434', '19', '20181225120213539797440763134', '1', '19', '5', '4', '10', '23', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545710533', '1545710533');
INSERT INTO `wja_order_sku_sub` VALUES ('22', 'auto_004-1_2630844101', '20', '20181225120652995398333107220', '1', '20', '5', '4', '11', '18', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545710812', '1545710812');
INSERT INTO `wja_order_sku_sub` VALUES ('23', 'auto_004-2_6627476664', '21', '20181225121455102545363935718', '1', '21', '5', '4', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545711295', '1545711295');
INSERT INTO `wja_order_sku_sub` VALUES ('24', 'auto_002-1_8305113448', '22', '20181225122855555099860202144', '1', '22', '5', '4', '9', '21', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545712135', '1545712135');
INSERT INTO `wja_order_sku_sub` VALUES ('25', 'auto_003-2_2729759831', '23', '20181225125249495255423378410', '1', '23', '5', '4', '10', '23', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545713569', '1545713569');
INSERT INTO `wja_order_sku_sub` VALUES ('26', 'auto_004-2_8695571411', '24', '20181225131026501004652642017', '1', '24', '5', '4', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545714626', '1545714626');
INSERT INTO `wja_order_sku_sub` VALUES ('27', 'auto_004-2_2327081403', '25', '20181225142636999710963464721', '1', '25', '5', '4', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545719196', '1545719196');
INSERT INTO `wja_order_sku_sub` VALUES ('28', 'auto_004-1_2932762220', '26', '20181225143510101524067231322', '1', '26', '5', '4', '11', '18', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545719710', '1545719710');
INSERT INTO `wja_order_sku_sub` VALUES ('29', 'auto_004-1_1195681869', '27', '20181225144306975048616924664', '1', '27', '5', '4', '11', '18', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545720186', '1545720186');
INSERT INTO `wja_order_sku_sub` VALUES ('30', 'auto_004-2_3484753307', '28', '20181225144322974956027879121', '1', '28', '4', '3', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545720202', '1545720202');
INSERT INTO `wja_order_sku_sub` VALUES ('31', 'auto_004-2_6248492661', '29', '20181225144523519950259485886', '1', '29', '4', '3', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545720323', '1545720323');
INSERT INTO `wja_order_sku_sub` VALUES ('32', 'auto_003-2_1095471098', '30', '20181225145420995098669939526', '1', '30', '5', '4', '10', '23', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545720860', '1545720860');
INSERT INTO `wja_order_sku_sub` VALUES ('33', 'auto_004-1_8284623482', '31', '20181225145834975550077286485', '1', '31', '5', '4', '11', '18', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545721114', '1545721114');
INSERT INTO `wja_order_sku_sub` VALUES ('34', 'auto_003-2_1831352291', '32', '20181225151102549853093709219', '1', '32', '4', '3', '10', '23', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545721862', '1545721862');
INSERT INTO `wja_order_sku_sub` VALUES ('35', 'auto_004-2_0276323526', '33', '20181225151317100100663220192', '1', '33', '5', '4', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545721997', '1545721997');
INSERT INTO `wja_order_sku_sub` VALUES ('36', 'auto_004-1_5550900869', '34', '20181226095553575155600481175', '1', '34', '5', '4', '11', '18', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545789353', '1545789353');
INSERT INTO `wja_order_sku_sub` VALUES ('37', 'auto_004-2_5669036398', '35', '20181226113207554999627746460', '1', '35', '4', '3', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545795127', '1545795127');
INSERT INTO `wja_order_sku_sub` VALUES ('38', 'auto_004-1_7015129153', '36', '20181227163226975110293764391', '1', '36', '22', '10', '11', '18', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545899546', '1545899546');
INSERT INTO `wja_order_sku_sub` VALUES ('39', 'auto_003-2_0450336588', '37', '20181227163917535699416879519', '1', '37', '22', '10', '10', '23', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545899957', '1545899957');
INSERT INTO `wja_order_sku_sub` VALUES ('40', 'auto_004-1_2499033433', '38', '20181227165721494954166112109', '1', '38', '22', '10', '11', '18', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545901041', '1545901041');
INSERT INTO `wja_order_sku_sub` VALUES ('41', 'auto_004-2_1058748317', '39', '20181228170346501005194047741', '1', '39', '22', '10', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545987826', '1545987826');
INSERT INTO `wja_order_sku_sub` VALUES ('42', 'auto_004-2_2266840081', '40', '20181228175445534853281947923', '1', '40', '5', '4', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545990885', '1545990885');
INSERT INTO `wja_order_sku_sub` VALUES ('43', 'auto_004-2_7726932777', '41', '20181228184005534910223759900', '1', '41', '5', '4', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545993605', '1545993605');
INSERT INTO `wja_order_sku_sub` VALUES ('44', 'auto_004-2_1168979164', '42', '20181228184210501024133410700', '1', '42', '5', '4', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1545993731', '1545993731');
INSERT INTO `wja_order_sku_sub` VALUES ('45', 'auto_004-2_4667847472', '43', '20181229095605535755091943774', '1', '43', '5', '4', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1546048565', '1546048565');
INSERT INTO `wja_order_sku_sub` VALUES ('46', 'auto_004-2_1010028899', '44', '20181229100233579855109535557', '1', '44', '5', '4', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1546048953', '1546048953');
INSERT INTO `wja_order_sku_sub` VALUES ('47', 'auto_004-2_5159612830', '45', '20181229120903102535045970359', '1', '45', '4', '3', '11', '19', '0.01', '0.01', '0.02', '0.02', '0.00', '0', '', '', '0', '0', '1546056543', '1546056543');

-- ----------------------------
-- Table structure for wja_order_track
-- ----------------------------
DROP TABLE IF EXISTS `wja_order_track`;
CREATE TABLE `wja_order_track` (
  `track_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '主订单ID',
  `order_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '主订单号',
  `odelivery_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'order_sku_delivery表自增长ID',
  `msg` varchar(500) NOT NULL DEFAULT '' COMMENT '信息',
  `time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`track_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_order_track
-- ----------------------------
INSERT INTO `wja_order_track` VALUES ('1', '1', '20181221161445531015571266774', '0', '订单已提交, 系统正在等待付款', '1545380085', '1545380085');
INSERT INTO `wja_order_track` VALUES ('2', '1', '20181221161445531015571266774', '0', '订单已付款, 等待商家发货', '1545380213', '1545380213');
INSERT INTO `wja_order_track` VALUES ('3', '1', '20181221161445531015571266774', '0', '支付成功,订单完成', '1545380213', '1545380213');
INSERT INTO `wja_order_track` VALUES ('4', '2', '20181221171909100971243370754', '0', '订单已提交, 系统正在等待付款', '1545383949', '1545383949');
INSERT INTO `wja_order_track` VALUES ('5', '3', '20181221174711102100020789604', '0', '订单已提交, 系统正在等待付款', '1545385631', '1545385631');
INSERT INTO `wja_order_track` VALUES ('6', '3', '20181221174711102100020789604', '0', '订单已付款, 等待商家发货', '1545385648', '1545385648');
INSERT INTO `wja_order_track` VALUES ('7', '3', '20181221174711102100020789604', '0', '支付成功,订单完成', '1545385648', '1545385648');
INSERT INTO `wja_order_track` VALUES ('8', '4', '20181221174955515197060400288', '0', '订单已提交, 系统正在等待付款', '1545385795', '1545385795');
INSERT INTO `wja_order_track` VALUES ('9', '4', '20181221174955515197060400288', '0', '订单已付款, 等待商家发货', '1545385811', '1545385811');
INSERT INTO `wja_order_track` VALUES ('10', '4', '20181221174955515197060400288', '0', '支付成功,订单完成', '1545385811', '1545385811');
INSERT INTO `wja_order_track` VALUES ('11', '5', '20181224091740525252047510697', '0', '订单已提交, 系统正在等待付款', '1545614260', '1545614260');
INSERT INTO `wja_order_track` VALUES ('12', '5', '20181224091740525252047510697', '0', '订单已付款, 等待商家发货', '1545614279', '1545614279');
INSERT INTO `wja_order_track` VALUES ('13', '5', '20181224091740525252047510697', '0', '支付成功,订单完成', '1545614279', '1545614279');
INSERT INTO `wja_order_track` VALUES ('14', '6', '20181224182633571001288537126', '0', '订单已提交, 系统正在等待付款', '1545647193', '1545647193');
INSERT INTO `wja_order_track` VALUES ('15', '1', '20181221161445531015571266774', '0', '系统自动关闭退货退款功能', '1545702170', '1545702170');
INSERT INTO `wja_order_track` VALUES ('16', '3', '20181221174711102100020789604', '0', '系统自动关闭退货退款功能', '1545702191', '1545702191');
INSERT INTO `wja_order_track` VALUES ('17', '7', '20181225094902101102305253833', '0', '订单已提交, 系统正在等待付款', '1545702543', '1545702543');
INSERT INTO `wja_order_track` VALUES ('18', '8', '20181225095004991015104960914', '0', '订单已提交, 系统正在等待付款', '1545702604', '1545702604');
INSERT INTO `wja_order_track` VALUES ('19', '7', '20181225094902101102305253833', '0', '', '1545702624', '1545702624');
INSERT INTO `wja_order_track` VALUES ('20', '8', '20181225095004991015104960914', '0', '', '1545702638', '1545702638');
INSERT INTO `wja_order_track` VALUES ('21', '9', '20181225095746975048006806088', '0', '订单已提交, 系统正在等待付款', '1545703066', '1545703066');
INSERT INTO `wja_order_track` VALUES ('22', '9', '20181225095746975048006806088', '0', '订单已付款, 等待商家发货', '1545703656', '1545703656');
INSERT INTO `wja_order_track` VALUES ('23', '9', '20181225095746975048006806088', '0', '支付成功,订单完成', '1545703656', '1545703656');
INSERT INTO `wja_order_track` VALUES ('24', '6', '20181224182633571001288537126', '0', '订单已付款, 等待商家发货', '1545703687', '1545703687');
INSERT INTO `wja_order_track` VALUES ('25', '6', '20181224182633571001288537126', '0', '支付成功,订单完成', '1545703687', '1545703687');
INSERT INTO `wja_order_track` VALUES ('26', '10', '20181225100917100101148975214', '0', '订单已提交, 系统正在等待付款', '1545703757', '1545703757');
INSERT INTO `wja_order_track` VALUES ('27', '11', '20181225104329495410039864814', '0', '订单已提交, 系统正在等待付款', '1545705809', '1545705809');
INSERT INTO `wja_order_track` VALUES ('28', '11', '20181225104329495410039864814', '0', '订单已付款, 等待商家发货', '1545706605', '1545706605');
INSERT INTO `wja_order_track` VALUES ('29', '11', '20181225104329495410039864814', '0', '支付成功,订单完成', '1545706605', '1545706605');
INSERT INTO `wja_order_track` VALUES ('30', '12', '20181225111202509850119817794', '0', '订单已提交, 系统正在等待付款', '1545707522', '1545707522');
INSERT INTO `wja_order_track` VALUES ('31', '12', '20181225111202509850119817794', '0', '订单已付款, 等待商家发货', '1545708022', '1545708022');
INSERT INTO `wja_order_track` VALUES ('32', '12', '20181225111202509850119817794', '0', '支付成功,订单完成', '1545708022', '1545708022');
INSERT INTO `wja_order_track` VALUES ('33', '10', '20181225100917100101148975214', '0', '订单已付款, 等待商家发货', '1545708823', '1545708823');
INSERT INTO `wja_order_track` VALUES ('34', '10', '20181225100917100101148975214', '0', '支付成功,订单完成', '1545708823', '1545708823');
INSERT INTO `wja_order_track` VALUES ('35', '13', '20181225113556995798964280737', '0', '订单已提交, 系统正在等待付款', '1545708956', '1545708956');
INSERT INTO `wja_order_track` VALUES ('36', '14', '20181225114444995399352182151', '0', '订单已提交, 系统正在等待付款', '1545709484', '1545709484');
INSERT INTO `wja_order_track` VALUES ('37', '15', '20181225114444999950718379329', '0', '订单已提交, 系统正在等待付款', '1545709484', '1545709484');
INSERT INTO `wja_order_track` VALUES ('38', '15', '20181225114444999950718379329', '0', '订单已付款, 等待商家发货', '1545709550', '1545709550');
INSERT INTO `wja_order_track` VALUES ('39', '15', '20181225114444999950718379329', '0', '支付成功,订单完成', '1545709550', '1545709550');
INSERT INTO `wja_order_track` VALUES ('40', '16', '20181225115553575255469740793', '0', '订单已提交, 系统正在等待付款', '1545710153', '1545710153');
INSERT INTO `wja_order_track` VALUES ('41', '17', '20181225115636525052931985577', '0', '订单已提交, 系统正在等待付款', '1545710196', '1545710196');
INSERT INTO `wja_order_track` VALUES ('42', '18', '20181225115858509810411449076', '0', '订单已提交, 系统正在等待付款', '1545710338', '1545710338');
INSERT INTO `wja_order_track` VALUES ('43', '19', '20181225120213539797440763134', '0', '订单已提交, 系统正在等待付款', '1545710533', '1545710533');
INSERT INTO `wja_order_track` VALUES ('44', '20', '20181225120652995398333107220', '0', '订单已提交, 系统正在等待付款', '1545710812', '1545710812');
INSERT INTO `wja_order_track` VALUES ('45', '21', '20181225121455102545363935718', '0', '订单已提交, 系统正在等待付款', '1545711295', '1545711295');
INSERT INTO `wja_order_track` VALUES ('46', '22', '20181225122855555099860202144', '0', '订单已提交, 系统正在等待付款', '1545712135', '1545712135');
INSERT INTO `wja_order_track` VALUES ('47', '23', '20181225125249495255423378410', '0', '订单已提交, 系统正在等待付款', '1545713569', '1545713569');
INSERT INTO `wja_order_track` VALUES ('48', '24', '20181225131026501004652642017', '0', '订单已提交, 系统正在等待付款', '1545714626', '1545714626');
INSERT INTO `wja_order_track` VALUES ('49', '25', '20181225142636999710963464721', '0', '订单已提交, 系统正在等待付款', '1545719196', '1545719196');
INSERT INTO `wja_order_track` VALUES ('50', '25', '20181225142636999710963464721', '0', '订单已付款, 等待商家发货', '1545719224', '1545719224');
INSERT INTO `wja_order_track` VALUES ('51', '25', '20181225142636999710963464721', '0', '支付成功,订单完成', '1545719224', '1545719224');
INSERT INTO `wja_order_track` VALUES ('52', '26', '20181225143510101524067231322', '0', '订单已提交, 系统正在等待付款', '1545719710', '1545719710');
INSERT INTO `wja_order_track` VALUES ('53', '27', '20181225144306975048616924664', '0', '订单已提交, 系统正在等待付款', '1545720186', '1545720186');
INSERT INTO `wja_order_track` VALUES ('54', '28', '20181225144322974956027879121', '0', '订单已提交, 系统正在等待付款', '1545720202', '1545720202');
INSERT INTO `wja_order_track` VALUES ('55', '29', '20181225144523519950259485886', '0', '订单已提交, 系统正在等待付款', '1545720323', '1545720323');
INSERT INTO `wja_order_track` VALUES ('56', '29', '20181225144523519950259485886', '0', '订单已付款, 等待商家发货', '1545720337', '1545720337');
INSERT INTO `wja_order_track` VALUES ('57', '29', '20181225144523519950259485886', '0', '支付成功,订单完成', '1545720337', '1545720337');
INSERT INTO `wja_order_track` VALUES ('58', '30', '20181225145420995098669939526', '0', '订单已提交, 系统正在等待付款', '1545720860', '1545720860');
INSERT INTO `wja_order_track` VALUES ('59', '31', '20181225145834975550077286485', '0', '订单已提交, 系统正在等待付款', '1545721114', '1545721114');
INSERT INTO `wja_order_track` VALUES ('60', '26', '20181225143510101524067231322', '0', '订单已付款, 等待商家发货', '1545721802', '1545721802');
INSERT INTO `wja_order_track` VALUES ('61', '26', '20181225143510101524067231322', '0', '支付成功,订单完成', '1545721802', '1545721802');
INSERT INTO `wja_order_track` VALUES ('62', '32', '20181225151102549853093709219', '0', '订单已提交, 系统正在等待付款', '1545721862', '1545721862');
INSERT INTO `wja_order_track` VALUES ('63', '32', '20181225151102549853093709219', '0', '订单已付款, 等待商家发货', '1545721878', '1545721878');
INSERT INTO `wja_order_track` VALUES ('64', '32', '20181225151102549853093709219', '0', '支付成功,订单完成', '1545721878', '1545721878');
INSERT INTO `wja_order_track` VALUES ('65', '20', '20181225120652995398333107220', '0', '订单已付款, 等待商家发货', '1545721898', '1545721898');
INSERT INTO `wja_order_track` VALUES ('66', '20', '20181225120652995398333107220', '0', '支付成功,订单完成', '1545721898', '1545721898');
INSERT INTO `wja_order_track` VALUES ('67', '33', '20181225151317100100663220192', '0', '订单已提交, 系统正在等待付款', '1545721997', '1545721997');
INSERT INTO `wja_order_track` VALUES ('68', '33', '20181225151317100100663220192', '0', '订单已付款, 等待商家发货', '1545722015', '1545722015');
INSERT INTO `wja_order_track` VALUES ('69', '33', '20181225151317100100663220192', '0', '支付成功,订单完成', '1545722015', '1545722015');
INSERT INTO `wja_order_track` VALUES ('70', '24', '20181225131026501004652642017', '0', '订单已付款, 等待商家发货', '1545722112', '1545722112');
INSERT INTO `wja_order_track` VALUES ('71', '24', '20181225131026501004652642017', '0', '支付成功,订单完成', '1545722112', '1545722112');
INSERT INTO `wja_order_track` VALUES ('72', '27', '20181225144306975048616924664', '0', '订单已付款, 等待商家发货', '1545722247', '1545722247');
INSERT INTO `wja_order_track` VALUES ('73', '27', '20181225144306975048616924664', '0', '支付成功,订单完成', '1545722247', '1545722247');
INSERT INTO `wja_order_track` VALUES ('74', '28', '20181225144322974956027879121', '0', '订单已付款, 等待商家发货', '1545722267', '1545722267');
INSERT INTO `wja_order_track` VALUES ('75', '28', '20181225144322974956027879121', '0', '支付成功,订单完成', '1545722267', '1545722267');
INSERT INTO `wja_order_track` VALUES ('76', '21', '20181225121455102545363935718', '0', '订单已付款, 等待商家发货', '1545722473', '1545722473');
INSERT INTO `wja_order_track` VALUES ('77', '21', '20181225121455102545363935718', '0', '支付成功,订单完成', '1545722473', '1545722473');
INSERT INTO `wja_order_track` VALUES ('78', '30', '20181225145420995098669939526', '0', '订单已付款, 等待商家发货', '1545722924', '1545722924');
INSERT INTO `wja_order_track` VALUES ('79', '30', '20181225145420995098669939526', '0', '支付成功,订单完成', '1545722924', '1545722924');
INSERT INTO `wja_order_track` VALUES ('80', '31', '20181225145834975550077286485', '0', '订单已付款, 等待商家发货', '1545723180', '1545723180');
INSERT INTO `wja_order_track` VALUES ('81', '31', '20181225145834975550077286485', '0', '支付成功,订单完成', '1545723180', '1545723180');
INSERT INTO `wja_order_track` VALUES ('82', '22', '20181225122855555099860202144', '0', '订单已付款, 等待商家发货', '1545723207', '1545723207');
INSERT INTO `wja_order_track` VALUES ('83', '22', '20181225122855555099860202144', '0', '支付成功,订单完成', '1545723207', '1545723207');
INSERT INTO `wja_order_track` VALUES ('84', '23', '20181225125249495255423378410', '0', '订单已付款, 等待商家发货', '1545724639', '1545724639');
INSERT INTO `wja_order_track` VALUES ('85', '23', '20181225125249495255423378410', '0', '支付成功,订单完成', '1545724639', '1545724639');
INSERT INTO `wja_order_track` VALUES ('86', '34', '20181226095553575155600481175', '0', '订单已提交, 系统正在等待付款', '1545789353', '1545789353');
INSERT INTO `wja_order_track` VALUES ('87', '2', '20181221171909100971243370754', '0', '订单超时未付款，系统自动取消订单', '1545791188', '1545791188');
INSERT INTO `wja_order_track` VALUES ('88', '13', '20181225113556995798964280737', '0', '订单超时未付款，系统自动取消订单', '1545791247', '1545791247');
INSERT INTO `wja_order_track` VALUES ('89', '4', '20181221174955515197060400288', '0', '自动关闭退货退款功能', '1545791247', '1545791247');
INSERT INTO `wja_order_track` VALUES ('90', '5', '20181224091740525252047510697', '0', '自动关闭退货退款功能', '1545791247', '1545791247');
INSERT INTO `wja_order_track` VALUES ('91', '14', '20181225114444995399352182151', '0', '订单超时未付款，系统自动取消订单', '1545791644', '1545791644');
INSERT INTO `wja_order_track` VALUES ('92', '17', '20181225115636525052931985577', '0', '订单超时未付款，系统自动取消订单', '1545791776', '1545791776');
INSERT INTO `wja_order_track` VALUES ('93', '18', '20181225115858509810411449076', '0', '订单超时未付款，系统自动取消订单', '1545791952', '1545791952');
INSERT INTO `wja_order_track` VALUES ('94', '19', '20181225120213539797440763134', '0', '订单超时未付款，系统自动取消订单', '1545791974', '1545791974');
INSERT INTO `wja_order_track` VALUES ('95', '34', '20181226095553575155600481175', '0', '订单超时未付款，系统自动取消订单', '1545792080', '1545792080');
INSERT INTO `wja_order_track` VALUES ('96', '4', '20181221174955515197060400288', '0', '自动关闭退货退款功能', '1545792080', '1545792080');
INSERT INTO `wja_order_track` VALUES ('97', '5', '20181224091740525252047510697', '0', '自动关闭退货退款功能', '1545792080', '1545792080');
INSERT INTO `wja_order_track` VALUES ('98', '4', '20181221174955515197060400288', '0', '自动关闭退货退款功能', '1545792131', '1545792131');
INSERT INTO `wja_order_track` VALUES ('99', '5', '20181224091740525252047510697', '0', '自动关闭退货退款功能', '1545792131', '1545792131');
INSERT INTO `wja_order_track` VALUES ('100', '5', '20181224091740525252047510697', '0', '系统自动关闭退货退款功能', '1545792342', '1545792342');
INSERT INTO `wja_order_track` VALUES ('101', '35', '20181226113207554999627746460', '0', '订单已提交, 系统正在等待付款', '1545795127', '1545795127');
INSERT INTO `wja_order_track` VALUES ('102', '36', '20181227163226975110293764391', '0', '订单已提交, 系统正在等待付款', '1545899546', '1545899546');
INSERT INTO `wja_order_track` VALUES ('103', '36', '20181227163226975110293764391', '0', '订单已付款, 等待商家发货', '1545899563', '1545899563');
INSERT INTO `wja_order_track` VALUES ('104', '36', '20181227163226975110293764391', '0', '支付成功,订单完成', '1545899563', '1545899563');
INSERT INTO `wja_order_track` VALUES ('105', '37', '20181227163917535699416879519', '0', '订单已提交, 系统正在等待付款', '1545899957', '1545899957');
INSERT INTO `wja_order_track` VALUES ('106', '37', '20181227163917535699416879519', '0', '订单已付款, 等待商家发货', '1545899983', '1545899983');
INSERT INTO `wja_order_track` VALUES ('107', '37', '20181227163917535699416879519', '0', '支付成功,订单完成', '1545899983', '1545899983');
INSERT INTO `wja_order_track` VALUES ('108', '38', '20181227165721494954166112109', '0', '订单已提交, 系统正在等待付款', '1545901041', '1545901041');
INSERT INTO `wja_order_track` VALUES ('109', '38', '20181227165721494954166112109', '0', '订单已付款, 等待商家发货', '1545901074', '1545901074');
INSERT INTO `wja_order_track` VALUES ('110', '38', '20181227165721494954166112109', '0', '支付成功,订单完成', '1545901074', '1545901074');
INSERT INTO `wja_order_track` VALUES ('111', '39', '20181228170346501005194047741', '0', '订单已提交, 系统正在等待付款', '1545987826', '1545987826');
INSERT INTO `wja_order_track` VALUES ('112', '40', '20181228175445534853281947923', '0', '订单已提交, 系统正在等待付款', '1545990885', '1545990885');
INSERT INTO `wja_order_track` VALUES ('113', '40', '20181228175445534853281947923', '0', '订单已付款, 等待商家发货', '1545990899', '1545990899');
INSERT INTO `wja_order_track` VALUES ('114', '40', '20181228175445534853281947923', '0', '支付成功,订单完成', '1545990899', '1545990899');
INSERT INTO `wja_order_track` VALUES ('115', '41', '20181228184005534910223759900', '0', '订单已提交, 系统正在等待付款', '1545993605', '1545993605');
INSERT INTO `wja_order_track` VALUES ('116', '41', '20181228184005534910223759900', '0', '订单已付款, 等待商家发货', '1545993622', '1545993622');
INSERT INTO `wja_order_track` VALUES ('117', '41', '20181228184005534910223759900', '0', '支付成功,订单完成', '1545993622', '1545993622');
INSERT INTO `wja_order_track` VALUES ('118', '42', '20181228184210501024133410700', '0', '订单已提交, 系统正在等待付款', '1545993731', '1545993731');
INSERT INTO `wja_order_track` VALUES ('119', '42', '20181228184210501024133410700', '0', '订单已付款, 等待商家发货', '1545993746', '1545993746');
INSERT INTO `wja_order_track` VALUES ('120', '42', '20181228184210501024133410700', '0', '支付成功,订单完成', '1545993746', '1545993746');
INSERT INTO `wja_order_track` VALUES ('121', '43', '20181229095605535755091943774', '0', '订单已提交, 系统正在等待付款', '1546048565', '1546048565');
INSERT INTO `wja_order_track` VALUES ('122', '43', '20181229095605535755091943774', '0', '订单已付款, 等待商家发货', '1546048626', '1546048626');
INSERT INTO `wja_order_track` VALUES ('123', '43', '20181229095605535755091943774', '0', '支付成功,订单完成', '1546048626', '1546048626');
INSERT INTO `wja_order_track` VALUES ('124', '44', '20181229100233579855109535557', '0', '订单已提交, 系统正在等待付款', '1546048953', '1546048953');
INSERT INTO `wja_order_track` VALUES ('125', '44', '20181229100233579855109535557', '0', '订单已付款, 等待商家发货', '1546048967', '1546048967');
INSERT INTO `wja_order_track` VALUES ('126', '44', '20181229100233579855109535557', '0', '支付成功,订单完成', '1546048967', '1546048967');
INSERT INTO `wja_order_track` VALUES ('127', '45', '20181229120903102535045970359', '0', '订单已提交, 系统正在等待付款', '1546056543', '1546056543');
INSERT INTO `wja_order_track` VALUES ('128', '45', '20181229120903102535045970359', '0', '订单已付款, 等待商家发货', '1546056557', '1546056557');
INSERT INTO `wja_order_track` VALUES ('129', '45', '20181229120903102535045970359', '0', '支付成功,订单完成', '1546056557', '1546056557');
INSERT INTO `wja_order_track` VALUES ('130', '44', '20181229100233579855109535557', '0', '系统自动关闭退货退款功能', '1546502333', '1546502333');

-- ----------------------------
-- Table structure for wja_payment
-- ----------------------------
DROP TABLE IF EXISTS `wja_payment`;
CREATE TABLE `wja_payment` (
  `pay_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '门店ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '支付名称',
  `pay_code` varchar(20) NOT NULL DEFAULT '',
  `config_json` text NOT NULL,
  `description` varchar(500) NOT NULL DEFAULT '',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `sort_order` tinyint(1) unsigned NOT NULL DEFAULT '255' COMMENT '排序',
  `display_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '显示类型(1pc端 2微信小程序 3APP客户端)',
  `api_type` varchar(255) NOT NULL DEFAULT 'wechat' COMMENT '接口类型',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`pay_id`) USING BTREE,
  KEY `pay_code` (`pay_code`) USING BTREE,
  KEY `store_id` (`store_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='商户支付配置数据表';

-- ----------------------------
-- Records of wja_payment
-- ----------------------------
INSERT INTO `wja_payment` VALUES ('1', '1', '微信扫码支付', 'wechat_native', '{\"app_id\":\"wx06b088dbc933d613\",\"mch_id\":\"1520990381\",\"mch_key\":\"cugbuQVsnihCoQEx3MXD2WYlYtdoQJCH\"}', '', '1', '0', '0', '1', '1', 'wechat', '0');
INSERT INTO `wja_payment` VALUES ('2', '1', '微信小程序支付', 'wechat_applet', '{\"app_id\":\"wx0451129aa1cd6fa9\",\"mch_id\":\"1502262791\",\"mch_key\":\"v9t47O7Cdw1mM6vLlIlSOnxEn1YByTXa\"}', '', '1', '0', '0', '1', '2', 'wechat', '1');
INSERT INTO `wja_payment` VALUES ('3', '1', '支付宝支付', 'alipay_page', '{\"app_id\":\"2018122162662317\",\"merchant_private_key\":\"MIIEpAIBAAKCAQEAun163XHcXjCLWEIFsrwEcwULPnJURdv57Kg997K9QqPpOzGyaZOIGDD4bORpLx1AKCQdB0eIJEzeBBMFdaPxc20gLwKr5FWmFlMXZtp+GSsIPWnrwOQLtMz\\/RLHh7KU7cgKnzFzbVRu4M02TxmVg5RD3B3+XDHtngkQJ\\/c7iNJ+SpVNWJld+aqNVYTqqaCurtdvNm1a0wnFAuZbiuBI3L1JohD3t1lHG8UoOXiSiKU+Fqpl0RsC6nF9GXRVQ636qQK0dEU9hbDFvbjr05OLLdmCBdVOPKF6pLO4U9oEOdcYDgM3AyHl+o8NCn4fG2LAs65ptlI5wuDSSr615OvROVQIDAQABAoIBAEM6vTJbu7\\/Q7EsS8g7vLQNyDA2lFbBhjwW72SsUqpn9kTUfw1vALc3ayZQn+6tadiiCbFyVcwTzGQ6K9OrmAUNFUdbgtasJHWjq54LSvabBFqVdK\\/pLu9SgGl5fajzvjDCbuHY5+3ABIDSOgPmCzp2Fsihn3MJJMpWJhbiT\\/oRNbGhNzWMnHjyWxBMidSMoTucbjDWCT2W5hznmCukSW\\/TTSrQ3NUOIJ5NLRq0gmPXmcZvlLRfzPYlpL\\/8c1dQ7+LIBzVvDkA\\/YS2NtuxtC4UVCdm0ZQxr9drtGzvzDTcCRxi1XC5q\\/K4VpfhU8kMrmIXeL7MDcxbJ3fSbNssHrefkCgYEA7gqsjodmxUIk4LM0\\/b6L1kub2n7YZpgUmKh1suYKZx3p1joAaMg2R53Vd3U40bbGrtoVWe4O\\/4MGkc1pvVJ4QpMEFBdTUCsQZIR3mX5lTirOtULhXRMk+IfYdj6oH9Jh9qF5guXmpHpojUUFyxuX\\/23paghQ+JDSV6t0g+DopNMCgYEAyI8va0UsY+hQreoAeHCG9GOoLE+31QYjvPE836WthSNs3g6q5i07u1xaXiuyjvO+ZMGTgBRtRxCxISxXw7Ik171StFsVJIbBF3Em0kFYnwkV7ewEwTIbT2upQw3mYmJ4Mj4rgvl+QwV6T20\\/BP98CKzlx5NU6U58sewddm24ZzcCgYEA4heDVBDpHPy5GC8+arAcE5tW2c3W7oMONPz0Zco3IT\\/5RP9sOhnH7HfONBtDr3TB+3uqAfOpjSi\\/CacoAqkdDmai3g5VlHSCqmZjTogN4pOoJ+PxN70iRWiJwa27dBYX8+\\/lAN4qFhkpytw\\/J237DaIwrARgG+c50glIrqXlcf8CgYEAs137VsCCtsdqgF+rFAvvZlpKaXbSPh5DkBNgEdSmn0\\/TabVMepcxuJsb5uTFyLuNJ6dIN2ANa2UuRTDXPRnxgVC8yrg67HPn9QMpaRkwHOuPRT2z8uTRL\\/JlaqbfyFWwkZ6wY26m0WHwxWA64EltsISQ7DCD3DRpqOY2Y1g1d3kCgYBkKkSUaZL\\/VVfyZq1xMUZhxiJG6uA2zGkOD77D8zs1Bg\\/1dZiDZz+cy9IgchYMgrDghEboESNRePQnFLHpN6OZ9vZVavHpRZTjlMjWvwWU+BpqQsE649TrdWYijWDvbsSY8zrd3RmtmP8KX9OP8DXZWXjTze2tqCs4MeDZCixwtQ==\",\"alipay_public_key\":\"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAh+m78FwkH8Hq1ibZLdIKN\\/8F0qUrGNj2BbmCRwUzkcVDRIk54rTrYbDuocC2W8CwPAZM5fdkY++37uSlUUsj4zyd1q8KmAo4Ym1cLYPFda4WC72xikRRSPXG9XvUWvrJ2rntII37qzz7mUDXmYiyyp0FZ9GUseBAudPxdu8LqFEXySNxGp2AjMYHnlgmnmbpzxeQJFZWorWyBrPuJ2Gd4sBhN0gt6bmI1nbgx76NXwFrjdXMxBWroU+Miz\\/4RlDIClzqz+r4hpV1K0CL8+wel\\/lVXLlapL+JVz9J8ANmUIsA4Kb6CZp\\/1ZOkodFBNQm7a5BoWSPB3wkHKB7PhLSgsQIDAQAB\"}', '', '1', '0', '0', '1', '1', 'alipay', '0');

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
  `store_no` varchar(255) NOT NULL DEFAULT '' COMMENT '商户编号',
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
  `group_photo` varchar(255) NOT NULL DEFAULT '' COMMENT '签约合影图片',
  `wxacode` varchar(2000) NOT NULL DEFAULT '' COMMENT '小程序二维码[json串]',
  `check_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '审核状态(0审核中 1已通过 2已拒绝)',
  `admin_remark` varchar(5000) NOT NULL DEFAULT '' COMMENT '申请审核理由',
  `region_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '渠道负责区域ID',
  `region_name` varchar(255) NOT NULL DEFAULT '' COMMENT '渠道负责区域地址',
  `enter_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '入驻方式(0后台添加 1申请入驻)',
  PRIMARY KEY (`store_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_store
-- ----------------------------
INSERT INTO `wja_store` VALUES ('1', '1458745225', '0', '1', '万佳安', 'http://pimvhcf3v.bkt.clouddn.com/goods_20181127110724_basicprofile.jpg', '张三', '18634563214', '', '1', '1', '1543287954', '1545363913', '0', '{\"wechat_applet\":{\"installer_appid\":\"wx06b088dbc933d613\",\"installer_appsecret\":\"f295d42b655e1217c4bc34e9f6ada817\",\"user_appid\":\"wxf0b833c0aa297da9\",\"user_appsecret\":\"93785b74f09b91c592bc09553ccb6e98\"},\"default\":{\"order_cancel_minute\":\"30\",\"order_return_day\":\"2\",\"channel_commission_ratio\":\"10\",\"servicer_return_ratio\":\"20\",\"workorder_auto_assess_day\":\"3\",\"monthly_withdraw_start_date\":\"6\",\"monthly_withdraw_end_date\":\"8\",\"consumer_hotline\":\"123456789\",\"installer_check\":\"0\"}}', '', '', '', '', '0.00', '', '', '1', '', '0', '', '0');
INSERT INTO `wja_store` VALUES ('2', '1562547886', '0', '1', '测试厂商', 'http://pimvhcf3v.bkt.clouddn.com/store_logo_20181127181255_logo1.jpg', '', '', '', '1', '1', '1543288024', '1543313576', '0', '', '', '', '', '', '0.00', '', '', '1', '', '0', '', '0');
INSERT INTO `wja_store` VALUES ('3', '1523547850', '1', '2', '深圳市渠道商', 'http://pimvhcf3v.bkt.clouddn.com/store_logo_20181220161652.png', '马画藤', '158598789545', '', '1', '1', '1543302062', '1545365178', '0', '', '', '', '', '', '150000.00', 'http://pimvhcf3v.bkt.clouddn.com/store_20181221120614.png', '', '1', '', '1965', '广东省 深圳市', '0');
INSERT INTO `wja_store` VALUES ('4', '1258456924', '1', '3', '万佳安零售商', '', '', '', '', '1', '1', '1543302246', '1543562065', '0', '', '', '', '', '', '0.00', '', '', '1', '', '0', '', '0');
INSERT INTO `wja_store` VALUES ('5', '5121288100', '1', '4', '测试服务商', '', 'AAA', '023-56874582', '', '1', '1', '1543302262', '1545364027', '0', '{\"default\":{\"installer_check\":\"0\"}}', '', '', '', '', '100.00', '', '{\"installer\":\"http:\\/\\/pimvhcf3v.bkt.clouddn.com\\/wxacode_5121288100_installer.png\"}', '1', '', '1965', '广东省 深圳市', '0');
INSERT INTO `wja_store` VALUES ('6', '0663175501', '1', '2', '马云', '', '马云', '18888888888', '二道口子', '1', '1', '1545717856', '1545717875', '1', '', 'http://img.zxjsj.zhidekan.me/store_20181225140355_589444.png', 'http://img.zxjsj.zhidekan.me/store_20181225140352_asdasdsadwqd.png', 'http://img.zxjsj.zhidekan.me/store_20181225140402_544448.png', '', '1500000.00', 'http://img.zxjsj.zhidekan.me/store_20181225140406_123131.png', '', '1', '', '923', '浙江省 杭州市', '0');
INSERT INTO `wja_store` VALUES ('7', '9797747020', '1', '3', '马云', '', '马云', '18888888888', '二道口子', '1', '1', '1545717962', '1545717972', '1', '', 'http://img.zxjsj.zhidekan.me/store_20181225140549_123131.png', 'http://img.zxjsj.zhidekan.me/store_20181225140553_544448.png', '', 'http://img.zxjsj.zhidekan.me/store_20181225140556_589444.png', '0.00', '', '', '1', '', '0', '', '0');
INSERT INTO `wja_store` VALUES ('8', '5228491536', '1', '4', '马云', '', '马云', '18888888888', '二道口子', '1', '1', '1545718060', '1545718072', '1', '', 'http://img.zxjsj.zhidekan.me/store_20181225140720_123131.png', 'http://img.zxjsj.zhidekan.me/store_20181225140724_544448.png', 'http://img.zxjsj.zhidekan.me/store_20181225140727_589444.png', '', '1000000.00', 'http://img.zxjsj.zhidekan.me/store_20181225140731_5564464.png', '', '1', '', '923', '浙江省 杭州市', '0');
INSERT INTO `wja_store` VALUES ('9', '0608862089', '1', '3', '额热热热', '', '二二恶 ', '18888888888', '二道口子', '1', '1', '1545720727', '1545720793', '1', '', '', '', '', '', '0.00', '', '', '1', '', '0', '', '0');
INSERT INTO `wja_store` VALUES ('10', '7589870766', '1', '3', '111', '', '222', '333', '44', '1', '1', '1545790210', '1545790210', '0', '', '', '', '', '', '0.00', '', '', '1', '', '0', '', '0');
INSERT INTO `wja_store` VALUES ('11', '0610215604', '1', '4', '111', '', '菩提祖师', '18888888888', '二道口子', '1', '1', '1545808311', '1545808321', '1', '', 'http://img.zxjsj.zhidekan.me/store_20181226151134_123131.png', 'http://img.zxjsj.zhidekan.me/store_20181226151137_589444.png', 'http://img.zxjsj.zhidekan.me/store_20181226151140_544448.png', '', '1000000.00', 'http://img.zxjsj.zhidekan.me/store_20181226151144_65465478.png', '', '1', '', '3', '北京市 北京市', '0');
INSERT INTO `wja_store` VALUES ('12', '3450119374', '1', '4', '蜘蛛', '', '蜘蛛', '18888888888', '二道口子', '1', '1', '1545993946', '1545993963', '1', '', 'http://img.zxjsj.zhidekan.me/store_20181228184526_544448.png', 'http://img.zxjsj.zhidekan.me/store_20181228184530_589444.png', 'http://img.zxjsj.zhidekan.me/store_20181228184532_123131.png', 'http://img.zxjsj.zhidekan.me/store_20181228184536_5564464.png', '100.00', 'http://img.zxjsj.zhidekan.me/store_20181228184540_65465478.png', '', '1', '', '1942', '广东省 广州市', '0');
INSERT INTO `wja_store` VALUES ('13', '2479160920', '1', '2', '菩提祖师', '', '菩提', '18888888888', '菩提仙洞', '1', '1', '1546050714', '1546078296', '1', '', 'http://img.zxjsj.zhidekan.me/store_20181229103119_544448.png', 'http://img.zxjsj.zhidekan.me/store_20181229103122_589444.png', 'http://img.zxjsj.zhidekan.me/store_20181229103127_5564464.png', 'http://img.zxjsj.zhidekan.me/store_20181229103131_asdasdsadwqd.png', '1000000.00', 'http://img.zxjsj.zhidekan.me/store_20181229103139_adsdqweqw.png', '', '1', '', '3098', '宁夏回族自治区 固原市', '0');
INSERT INTO `wja_store` VALUES ('14', '5413550989', '1', '3', '三清道长', '', '三清', '233', '二道口子', '1', '1', '1546055064', '1546055190', '1', '', 'http://img.zxjsj.zhidekan.me/store_20181229114328_544448.png', 'http://img.zxjsj.zhidekan.me/store_20181229114332_589444.png', '', 'http://img.zxjsj.zhidekan.me/store_20181229114335_589444.png', '0.00', '', '', '1', '', '3101', '宁夏回族自治区 固原市 隆德县', '0');
INSERT INTO `wja_store` VALUES ('15', '6119213689', '1', '4', '元始天尊', '', '天尊', '23333', '二道口子', '1', '1', '1546055134', '1546055196', '1', '', 'http://img.zxjsj.zhidekan.me/store_20181229114515_544448.png', 'http://img.zxjsj.zhidekan.me/store_20181229114519_123131.png', 'http://img.zxjsj.zhidekan.me/store_20181229114522_589444.png', 'http://img.zxjsj.zhidekan.me/store_20181229114525_5564464.png', '100.00', 'http://img.zxjsj.zhidekan.me/store_20181229114528_asdasdsadwqd.png', '', '1', '', '3098', '宁夏回族自治区 固原市', '0');
INSERT INTO `wja_store` VALUES ('16', '0295195263', '1', '3', '测试申请', 'http://img.zxjsj.zhidekan.me/store_20181229171104_demo-pic33.jpg', '1111', '13697458745', '', '1', '1', '1546074693', '1546076371', '1', '', 'http://img.zxjsj.zhidekan.me/store_20181229171123_demo-pic33.jpg', 'http://img.zxjsj.zhidekan.me/store_20181229171126_demo-pic34.jpg', '', 'http://img.zxjsj.zhidekan.me/store_20181229171129_demo-pic60.jpg', '0.00', '', '', '1', '', '1847', '湖南省 邵阳市 北塔区', '0');
INSERT INTO `wja_store` VALUES ('17', '7509017610', '1', '2', 'adfadf', '', 'sdfasdfasdfa', 'dfadfa', '', '1', '1', '1546488224', '1546488227', '1', '', '', '', '', '', '0.00', '', '', '1', '', '1799', '湖北省 省直辖县级行政区划', '0');
INSERT INTO `wja_store` VALUES ('18', '0800000465', '1', '2', '1111', '', '2222', '3333', '', '1', '1', '1546497067', '1546497098', '1', '', '', '', '', '', '444.00', '', '', '1', '', '1913', '湖南省 怀化市', '0');

-- ----------------------------
-- Table structure for wja_store_action_record
-- ----------------------------
DROP TABLE IF EXISTS `wja_store_action_record`;
CREATE TABLE `wja_store_action_record` (
  `record_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `action_store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作商户ID',
  `action_user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作用户ID',
  `to_store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '被修改商户ID',
  `to_store_name` varchar(255) NOT NULL DEFAULT '' COMMENT '被修改商户名称',
  `action_type` varchar(25) NOT NULL DEFAULT '' COMMENT '操作类型(add新增 edit编辑 del删除)',
  `before` text NOT NULL COMMENT '修改前数据',
  `after` text NOT NULL COMMENT '修改后数据',
  `modify` text NOT NULL COMMENT '修改的数据内容',
  `check_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '审核状态(0待审核 1审核通过 2已拒绝)',
  `check_time` int(10) unsigned NOT NULL DEFAULT '0',
  `remark` varchar(1000) NOT NULL DEFAULT '' COMMENT '操作备注',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '通知发送时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `sort_order` int(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`record_id`),
  KEY `action_store_id` (`action_store_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_store_action_record
-- ----------------------------
INSERT INTO `wja_store_action_record` VALUES ('1', '3', '4', '16', '测试申请', 'add', '', '{\"name\":\"\\u6d4b\\u8bd5\\u7533\\u8bf7\",\"logo\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171104_demo-pic33.jpg\",\"user_name\":\"1111\",\"mobile\":\"13697458745\",\"sample_amount\":1520,\"idcard_font_img\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171123_demo-pic33.jpg\",\"idcard_back_img\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171126_demo-pic34.jpg\",\"signing_contract_img\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171129_demo-pic60.jpg\",\"region_id\":\"1847\",\"region_name\":\"\\u6e56\\u5357\\u7701 \\u90b5\\u9633\\u5e02 \\u5317\\u5854\\u533a\",\"address\":\"\",\"add_time\":1546074693,\"update_time\":1546074693,\"factory_id\":1,\"ostore_id\":3,\"config_json\":\"\",\"check_status\":1,\"store_type\":3}', '{\"name\":\"\\u6d4b\\u8bd5\\u7533\\u8bf7\",\"logo\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171104_demo-pic33.jpg\",\"user_name\":\"1111\",\"mobile\":\"13697458745\",\"sample_amount\":1520,\"idcard_font_img\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171123_demo-pic33.jpg\",\"idcard_back_img\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171126_demo-pic34.jpg\",\"signing_contract_img\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171129_demo-pic60.jpg\",\"region_id\":\"1847\",\"region_name\":\"\\u6e56\\u5357\\u7701 \\u90b5\\u9633\\u5e02 \\u5317\\u5854\\u533a\",\"address\":\"\",\"add_time\":1546074693,\"update_time\":1546074693,\"factory_id\":1,\"ostore_id\":3,\"config_json\":\"\",\"check_status\":1,\"store_type\":3}', '1', '1546074725', '', '1546074693', '1546074693', '1', '0', '1');
INSERT INTO `wja_store_action_record` VALUES ('2', '3', '4', '16', '测试申请', 'edit', '{\"store_id\":16,\"store_no\":\"0295195263\",\"factory_id\":1,\"store_type\":3,\"name\":\"\\u6d4b\\u8bd5\\u7533\\u8bf7\",\"logo\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171104_demo-pic33.jpg\",\"user_name\":\"1111\",\"mobile\":\"13697458745\",\"address\":\"\",\"sort_order\":1,\"status\":1,\"add_time\":\"2018-12-29 17:11:33\",\"update_time\":\"2018-12-29 17:11:33\",\"is_del\":0,\"config_json\":\"\",\"idcard_font_img\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171123_demo-pic33.jpg\",\"idcard_back_img\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171126_demo-pic34.jpg\",\"license_img\":\"\",\"signing_contract_img\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171129_demo-pic60.jpg\",\"security_money\":\"0.00\",\"group_photo\":\"\",\"wxacode\":\"\",\"check_status\":1,\"admin_remark\":\"\",\"region_id\":1847,\"region_name\":\"\\u6e56\\u5357\\u7701 \\u90b5\\u9633\\u5e02 \\u5317\\u5854\\u533a\",\"enter_type\":0,\"ostore_id\":3,\"sample_amount\":\"1520.00\",\"channel_name\":\"\\u6df1\\u5733\\u5e02\\u6e20\\u9053\\u5546\"}', '{\"name\":\"\\u6d4b\\u8bd5\\u7533\\u8bf7\",\"logo\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171104_demo-pic33.jpg\",\"user_name\":\"222\",\"mobile\":\"13697458745\",\"sample_amount\":1520,\"idcard_font_img\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171123_demo-pic33.jpg\",\"idcard_back_img\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171126_demo-pic34.jpg\",\"signing_contract_img\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171129_demo-pic60.jpg\",\"region_id\":\"1847\",\"region_name\":\"\\u6e56\\u5357\\u7701 \\u90b5\\u9633\\u5e02 \\u5317\\u5854\\u533a\",\"address\":\"\",\"update_time\":1546076040,\"factory_id\":1,\"ostore_id\":3,\"store_type\":3}', '{\"user_name\":\"222\"}', '2', '1546424945', '商户不存在或已删除[系统拒绝删除申请]', '1546076040', '1546076040', '1', '0', '1');
INSERT INTO `wja_store_action_record` VALUES ('3', '3', '4', '16', '测试申请', 'del', '{\"store_id\":16,\"store_no\":\"0295195263\",\"factory_id\":1,\"store_type\":3,\"name\":\"\\u6d4b\\u8bd5\\u7533\\u8bf7\",\"logo\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171104_demo-pic33.jpg\",\"user_name\":\"1111\",\"mobile\":\"13697458745\",\"address\":\"\",\"sort_order\":1,\"status\":1,\"add_time\":\"2018-12-29 17:11:33\",\"update_time\":\"2018-12-29 17:11:33\",\"is_del\":0,\"config_json\":\"\",\"idcard_font_img\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171123_demo-pic33.jpg\",\"idcard_back_img\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171126_demo-pic34.jpg\",\"license_img\":\"\",\"signing_contract_img\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/store_20181229171129_demo-pic60.jpg\",\"security_money\":\"0.00\",\"group_photo\":\"\",\"wxacode\":\"\",\"check_status\":1,\"admin_remark\":\"\",\"region_id\":1847,\"region_name\":\"\\u6e56\\u5357\\u7701 \\u90b5\\u9633\\u5e02 \\u5317\\u5854\\u533a\",\"enter_type\":0,\"ostore_id\":3,\"sample_amount\":\"1520.00\",\"manager\":null,\"channel_name\":\"\\u6df1\\u5733\\u5e02\\u6e20\\u9053\\u5546\",\"channel_no\":\"1523547850\"}', '', '', '2', '1546076860', '商户不存在或已删除[系统拒绝删除申请]', '1546076125', '1546076125', '1', '0', '1');

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
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='商户提现账户数据表';

-- ----------------------------
-- Records of wja_store_bank
-- ----------------------------
INSERT INTO `wja_store_bank` VALUES ('1', '1', '1', '1', '1', '1', '1', '3', '4', '1545716672', '1545716772', '1', '1', '0');

-- ----------------------------
-- Table structure for wja_store_channel
-- ----------------------------
DROP TABLE IF EXISTS `wja_store_channel`;
CREATE TABLE `wja_store_channel` (
  `store_id` int(10) unsigned NOT NULL COMMENT '商户ID',
  PRIMARY KEY (`store_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='渠道商数据表';

-- ----------------------------
-- Records of wja_store_channel
-- ----------------------------
INSERT INTO `wja_store_channel` VALUES ('3');
INSERT INTO `wja_store_channel` VALUES ('6');
INSERT INTO `wja_store_channel` VALUES ('13');
INSERT INTO `wja_store_channel` VALUES ('17');
INSERT INTO `wja_store_channel` VALUES ('18');

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
  `refund_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '订单退款金额',
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
) ENGINE=MyISAM AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COMMENT='返佣明细表';

-- ----------------------------
-- Records of wja_store_commission
-- ----------------------------
INSERT INTO `wja_store_commission` VALUES ('1', '3', '4', '1', '20181221161445531015571266774', '1', '11', '19', '0.02', '0.00', '10.00', '0.00', '1', '1545380213', '1545702170', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('2', '3', '4', '3', '20181221174711102100020789604', '3', '11', '19', '0.02', '0.00', '10.00', '0.00', '1', '1545385648', '1545702191', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('3', '3', '4', '4', '20181221174955515197060400288', '4', '11', '18', '0.02', '0.00', '10.00', '0.00', '1', '1545385811', '1545792131', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('4', '3', '4', '5', '20181224091740525252047510697', '5', '10', '23', '0.02', '0.00', '10.00', '0.00', '1', '1545614279', '1545792342', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('5', '3', '4', '9', '20181225095746975048006806088', '9', '9', '21', '0.02', '0.00', '10.00', '0.00', '0', '1545703656', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('6', '3', '4', '6', '20181224182633571001288537126', '6', '11', '19', '0.02', '0.00', '10.00', '0.00', '0', '1545703687', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('7', '3', '4', '11', '20181225104329495410039864814', '11', '8', '22', '0.02', '0.00', '10.00', '0.00', '0', '1545706605', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('8', '3', '4', '12', '20181225111202509850119817794', '12', '8', '22', '0.02', '0.00', '10.00', '0.00', '0', '1545708022', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('9', '3', '4', '10', '20181225100917100101148975214', '10', '8', '22', '0.02', '0.00', '10.00', '0.00', '0', '1545708823', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('10', '3', '4', '15', '20181225114444999950718379329', '15', '11', '18', '0.02', '0.00', '10.00', '0.00', '0', '1545709550', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('11', '3', '4', '25', '20181225142636999710963464721', '25', '11', '19', '0.02', '0.00', '10.00', '0.00', '0', '1545719224', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('12', '3', '4', '26', '20181225143510101524067231322', '26', '11', '18', '0.02', '0.00', '10.00', '0.00', '0', '1545721802', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('13', '3', '4', '20', '20181225120652995398333107220', '20', '11', '18', '0.02', '0.00', '10.00', '0.00', '0', '1545721898', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('14', '3', '4', '33', '20181225151317100100663220192', '33', '11', '19', '0.02', '0.00', '10.00', '0.00', '0', '1545722015', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('15', '3', '4', '24', '20181225131026501004652642017', '24', '11', '19', '0.02', '0.00', '10.00', '0.00', '0', '1545722112', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('16', '3', '4', '27', '20181225144306975048616924664', '27', '11', '18', '0.02', '0.00', '10.00', '0.00', '0', '1545722247', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('17', '3', '4', '21', '20181225121455102545363935718', '21', '11', '19', '0.02', '0.00', '10.00', '0.00', '0', '1545722473', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('18', '3', '4', '30', '20181225145420995098669939526', '30', '10', '23', '0.02', '0.00', '10.00', '0.00', '0', '1545722924', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('19', '3', '4', '31', '20181225145834975550077286485', '31', '11', '18', '0.02', '0.00', '10.00', '0.00', '0', '1545723180', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('20', '3', '4', '22', '20181225122855555099860202144', '22', '9', '21', '0.02', '0.00', '10.00', '0.00', '0', '1545723207', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('21', '3', '4', '23', '20181225125249495255423378410', '23', '10', '23', '0.02', '0.00', '10.00', '0.00', '0', '1545724639', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('22', '3', '10', '36', '20181227163226975110293764391', '36', '11', '18', '0.02', '0.00', '10.00', '0.00', '2', '1545899563', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('23', '3', '10', '37', '20181227163917535699416879519', '37', '10', '23', '0.02', '0.00', '10.00', '0.00', '2', '1545899983', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('24', '3', '10', '38', '20181227165721494954166112109', '38', '11', '18', '0.02', '0.00', '10.00', '0.00', '0', '1545901074', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('25', '3', '4', '40', '20181228175445534853281947923', '40', '11', '19', '0.02', '0.00', '10.00', '0.00', '0', '1545990899', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('26', '3', '4', '41', '20181228184005534910223759900', '41', '11', '19', '0.02', '0.00', '10.00', '0.00', '0', '1545993622', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('27', '3', '4', '42', '20181228184210501024133410700', '42', '11', '19', '0.02', '0.00', '10.00', '0.00', '0', '1545993746', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('28', '3', '4', '43', '20181229095605535755091943774', '43', '11', '19', '0.02', '0.00', '10.00', '0.00', '2', '1546048626', '0', '1', '1', '0');
INSERT INTO `wja_store_commission` VALUES ('29', '3', '4', '44', '20181229100233579855109535557', '44', '11', '19', '0.02', '0.00', '10.00', '0.00', '1', '1546048967', '1546502333', '1', '1', '0');

-- ----------------------------
-- Table structure for wja_store_dealer
-- ----------------------------
DROP TABLE IF EXISTS `wja_store_dealer`;
CREATE TABLE `wja_store_dealer` (
  `store_id` int(10) unsigned NOT NULL COMMENT '商户ID',
  `ostore_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '渠道商/零售商ID',
  `sample_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '已采购样品金额',
  PRIMARY KEY (`store_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='零售商/零售商数据表';

-- ----------------------------
-- Records of wja_store_dealer
-- ----------------------------
INSERT INTO `wja_store_dealer` VALUES ('4', '3', '0.00');
INSERT INTO `wja_store_dealer` VALUES ('7', '3', '3000.00');
INSERT INTO `wja_store_dealer` VALUES ('9', '3', '0.00');
INSERT INTO `wja_store_dealer` VALUES ('10', '3', '0.00');
INSERT INTO `wja_store_dealer` VALUES ('14', '13', '0.00');
INSERT INTO `wja_store_dealer` VALUES ('16', '3', '1520.00');

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
INSERT INTO `wja_store_finance` VALUES ('5', '0.03', '0.00', '0.10', '0.13');
INSERT INTO `wja_store_finance` VALUES ('6', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('7', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('8', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('9', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('10', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('11', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('12', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('13', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('14', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('15', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('16', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('17', '0.00', '0.00', '0.00', '0.00');
INSERT INTO `wja_store_finance` VALUES ('18', '0.00', '0.00', '0.00', '0.00');

-- ----------------------------
-- Table structure for wja_store_servicer
-- ----------------------------
DROP TABLE IF EXISTS `wja_store_servicer`;
CREATE TABLE `wja_store_servicer` (
  `store_id` int(10) unsigned NOT NULL COMMENT '商户ID',
  PRIMARY KEY (`store_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='服务商数据表';

-- ----------------------------
-- Records of wja_store_servicer
-- ----------------------------
INSERT INTO `wja_store_servicer` VALUES ('5');
INSERT INTO `wja_store_servicer` VALUES ('8');
INSERT INTO `wja_store_servicer` VALUES ('11');
INSERT INTO `wja_store_servicer` VALUES ('12');
INSERT INTO `wja_store_servicer` VALUES ('15');

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
  `return_ratio` float(5,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '绩效考核百分比',
  `income_amount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '收益金额(实际得到安装费金额)',
  `income_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '收益状态(0待结算 1已结算 2已退还)',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '交易时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '到账时间',
  `sort_order` int(1) unsigned NOT NULL DEFAULT '1',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(0禁用 1启用)',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`log_id`),
  KEY `store_id` (`store_id`)
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COMMENT='服务商安装费数据表';

-- ----------------------------
-- Records of wja_store_service_income
-- ----------------------------
INSERT INTO `wja_store_service_income` VALUES ('1', '5', '1', '20181221161936651053', '1', '20181221161445531015571266774', '1', '11', '19', '0.01', '1', '5.00', '0.00', '0.01', '1', '1545380494', '1545380514', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('2', '5', '2', '20181221162204256530', '1', '20181221161445531015571266774', '1', '11', '19', '0.01', '0', '0.00', '0.00', '0.00', '0', '1545380612', '1545380612', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('3', '5', '3', '20181221175000623647', '2', '20181221174711102100020789604', '3', '11', '19', '0.01', '5', '5.00', '0.00', '0.01', '1', '1545461237', '1545792666', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('4', '5', '5', '20181224091842663853', '1', '20181224091740525252047510697', '5', '10', '23', '0.01', '3', '5.00', '0.00', '0.01', '1', '1545614412', '1545614448', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('5', '5', '6', '20181224092100901428', '7', '20181224091740525252047510697', '5', '10', '23', '0.01', '0', '0.00', '0.00', '0.00', '0', '1545623545', '1545623545', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('6', '5', '7', '20181225143000839998', '1', '20181225142636999710963464721', '25', '11', '19', '0.01', '0', '0.00', '0.00', '0.00', '0', '1545719545', '1545719545', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('7', '5', '8', '20181225143905865384', '1', '20181225142636999710963464721', '25', '11', '19', '0.01', '0', '0.00', '0.00', '0.00', '0', '1545720090', '1545720090', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('8', '5', '9', '20181225144722850558', '1', '20181225144523519950259485886', '29', '11', '19', '0.01', '0', '0.00', '0.00', '0.00', '0', '1545720542', '1545720542', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('9', '5', '10', '20181225144924647302', '1', '20181225144523519950259485886', '29', '11', '19', '0.01', '0', '0.00', '0.00', '0.00', '0', '1545721028', '1545721028', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('10', '5', '18', '20181228155336248806', '11', '', '0', '10', '0', '0.00', '0', '0.00', '0.00', '0.00', '0', '1545985635', '1545985635', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('11', '5', '24', '20181228175552540108', '1', '20181228175445534853281947923', '40', '11', '19', '0.01', '0', '0.00', '0.00', '0.00', '0', '1545991869', '1545991869', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('12', '5', '25', '20181228181259724322', '1', '20181228175445534853281947923', '40', '11', '19', '0.01', '0', '0.00', '0.00', '0.00', '0', '1545992021', '1545992021', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('13', '5', '30', '20181229100318281360', '1', '20181229100233579855109535557', '44', '11', '19', '0.01', '0', '0.00', '0.00', '0.00', '0', '1546049211', '1546049211', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('14', '5', '31', '20181229100825841208', '1', '20181229100233579855109535557', '44', '11', '19', '0.01', '0', '0.00', '0.00', '0.00', '0', '1546049607', '1546049607', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('15', '5', '17', '20181228154711230760', '11', '', '0', '8', '0', '0.00', '0', '0.00', '0.00', '0.00', '0', '1546053952', '1546053952', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('16', '5', '20', '20181228171726082147', '11', '', '0', '8', '0', '0.00', '0', '0.00', '0.00', '0.00', '0', '1546054222', '1546054222', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('17', '5', '21', '20181228171936928524', '11', '', '0', '10', '0', '0.00', '0', '0.00', '0.00', '0.00', '0', '1546063325', '1546063325', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('18', '5', '29', '20181229091242611061', '11', '', '0', '11', '0', '0.00', '0', '0.00', '0.00', '0.00', '0', '1546066327', '1546066327', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('19', '5', '26', '20181228181423913524', '1', '', '0', '8', '0', '0.00', '0', '0.00', '0.00', '0.00', '0', '1546068173', '1546068173', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('20', '5', '32', '20181229152023523293', '12', '', '0', '8', '0', '0.00', '0', '0.00', '0.00', '0.00', '0', '1546069215', '1546069215', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('21', '5', '33', '20181229153810861377', '12', '', '0', '10', '0', '0.00', '0', '0.00', '0.00', '0.00', '0', '1546069219', '1546069219', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('22', '5', '35', '20181229154728084640', '12', '', '0', '8', '0', '0.00', '0', '0.00', '0.00', '0.00', '0', '1546069695', '1546069695', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('23', '5', '36', '20181229160148037404', '12', '', '0', '8', '0', '0.00', '0', '0.00', '0.00', '0.00', '0', '1546070585', '1546070585', '1', '1', '0');
INSERT INTO `wja_store_service_income` VALUES ('24', '5', '37', '20181229160432889813', '12', '', '0', '10', '0', '0.00', '0', '0.00', '0.00', '0.00', '0', '1546070724', '1546070724', '1', '1', '0');

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
  `factory_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '厂商ID(账户所属厂商）',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '关联商户ID',
  `is_admin` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否是管理员账号',
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
  `pwd_modify` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否必须修改密码',
  PRIMARY KEY (`user_id`) USING BTREE,
  KEY `username` (`username`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='前台会员表';

-- ----------------------------
-- Records of wja_user
-- ----------------------------
INSERT INTO `wja_user` VALUES ('1', '1', '0', '0', '1', '0', '0', 'admin', 'f02b3bb7b40a43c0c364f23d36e4aa52', '', '管理员', '13587458745', '', '0.00', '', '', '1', '1', '1542683553', '1546480053', '1546480053', '0', '0');
INSERT INTO `wja_user` VALUES ('2', '2', '1', '1', '1', '1', '0', 'wanjiaan', '45e10aab779eb35fe020503ae1f63272', '万佳安', '万佳安', '13458745748', '', '0.00', '', '', '1', '1', '1543223533', '1546504802', '1546504802', '0', '0');
INSERT INTO `wja_user` VALUES ('3', '2', '2', '2', '1', '1', '0', 'ceshi', '3de54ec60cfd102a6f0e6a7211a5be1c', '', '', '', '', '0.00', '', '', '1', '1', '1543288394', '1544428622', '1544428622', '0', '0');
INSERT INTO `wja_user` VALUES ('4', '3', '1', '3', '1', '2', '0', 'qudao', '3b3a4cd3d66c22faf7a679e0d0d8a68c', '小月', '刘越', '13569856520', '', '0.00', '', '', '1', '1', '1543302686', '1546502118', '1546502117', '0', '0');
INSERT INTO `wja_user` VALUES ('5', '4', '1', '4', '1', '3', '0', 'lingshou', '951f07795fa3475e6ee613c9fef60a6c', '', '', '', '', '0.00', '', '', '1', '1', '1544092030', '1546073224', '1546073224', '0', '0');
INSERT INTO `wja_user` VALUES ('6', '5', '1', '5', '1', '4', '0', 'fuwu0', '67e6a2175c5e5f6da8e03b3982858577', '', '', '', '', '0.00', '', '', '1', '1', '1544501785', '1546503143', '1546503143', '0', '0');
INSERT INTO `wja_user` VALUES ('7', '0', '1', '0', '0', '0', '0', '', '', '', '钢铁侠', '18565854698', '', '0.00', '', '0', '1', '1', '1545380133', '1546070300', '1546070300', '0', '0');
INSERT INTO `wja_user` VALUES ('8', '0', '1', '0', '0', '0', '0', '', '', '', 'John', '03714906176', '', '0.00', '', '0', '1', '1', '1545382316', '1545892121', '1545892121', '0', '0');
INSERT INTO `wja_user` VALUES ('9', '0', '1', '0', '0', '0', '0', '', '', '', '小君', '03760170785', '', '0.00', '', '0', '1', '1', '1545391721', '1545391721', '0', '0', '0');
INSERT INTO `wja_user` VALUES ('10', '0', '1', '0', '0', '0', '0', '', '', '', '', '18319019601', '', '0.00', '', '0', '1', '1', '1545393579', '1545985282', '1545465440', '0', '1');
INSERT INTO `wja_user` VALUES ('11', '0', '1', '0', '0', '0', '0', '', '', '', 'bonnie', '13163770899', '', '0.00', '', '0', '1', '1', '1545393945', '1545809465', '1545809465', '0', '0');
INSERT INTO `wja_user` VALUES ('12', '0', '1', '0', '0', '0', '0', '', '', '', '金宏业', '17620489746', '', '0.00', '', '0', '1', '1', '1545394314', '1545474604', '1545474604', '0', '0');
INSERT INTO `wja_user` VALUES ('13', '0', '1', '0', '0', '0', '0', '', '', '', '', '18210733321', '', '0.00', '', '0', '1', '1', '1545453509', '1545458007', '1545458007', '0', '0');
INSERT INTO `wja_user` VALUES ('14', '0', '1', '0', '0', '0', '0', '', '', '', '', '13530673378', '', '0.00', '', '0', '1', '1', '1545453567', '1545453567', '0', '0', '0');
INSERT INTO `wja_user` VALUES ('15', '0', '1', '0', '0', '0', '0', '', '', '', '', '17503011958', '', '0.00', '', '0', '1', '1', '1545454043', '1545808073', '1545808073', '0', '0');
INSERT INTO `wja_user` VALUES ('16', '0', '1', '0', '0', '0', '0', '', '', '', '', '15361478744', '', '0.00', '', '0', '1', '1', '1545458032', '1545458032', '0', '0', '0');
INSERT INTO `wja_user` VALUES ('17', '0', '1', '0', '0', '0', '0', '', '', '', '', '13632799596', '', '0.00', '', '0', '1', '1', '1545460025', '1545460025', '0', '0', '0');
INSERT INTO `wja_user` VALUES ('18', '0', '1', '0', '0', '0', '0', '', '', '', '许明', '15815515135', '', '0.00', '', '0', '1', '1', '1545474394', '1545633692', '1545633692', '0', '0');
INSERT INTO `wja_user` VALUES ('19', '0', '1', '0', '0', '0', '0', '', '', '', '孟德', '15118815476', '', '0.00', '', '0', '1', '1', '1545614837', '1546068386', '1546068386', '0', '0');
INSERT INTO `wja_user` VALUES ('20', '0', '1', '0', '0', '0', '0', '', '', '', '张', '13823562155', '', '0.00', '', '0', '1', '1', '1545633825', '1545633825', '0', '0', '0');
INSERT INTO `wja_user` VALUES ('26', '5', '1', '5', '0', '11', '0', 'yunyin', '898239b7ac566b5deb88a4ad5aaeb0b9', '', '', '15188578675', '', '0.00', '', '', '1', '1', '1546051972', '1546052043', '1546051988', '1', '0');
INSERT INTO `wja_user` VALUES ('21', '0', '1', '0', '0', '0', '0', '', '', '', '', '03714906176', '', '0.00', '', '0', '1', '1', '1545898430', '1545900066', '1545900066', '0', '0');
INSERT INTO `wja_user` VALUES ('22', '4', '1', '10', '1', '3', '0', 'wja_lingshou', 'f62df18cf9f77c1ddd315da773e0a18b', '7589870766', '7589870766', '13760170785', '', '0.00', '', '', '1', '1', '1545899156', '1545987809', '1545987663', '0', '0');
INSERT INTO `wja_user` VALUES ('23', '0', '1', '0', '0', '0', '0', '', '', '', 'John001', '13714906176', '', '0.00', '', '0', '1', '1', '1545900742', '1546075039', '1546075039', '0', '0');
INSERT INTO `wja_user` VALUES ('24', '0', '1', '0', '0', '0', '0', '', '', '', '', '13359237168', '', '0.00', '', '0', '1', '1', '1545991727', '1545991727', '0', '0', '0');
INSERT INTO `wja_user` VALUES ('25', '0', '1', '0', '0', '0', '0', '', '', '', '', '18903769208', '', '0.00', '', '0', '1', '1', '1545991972', '1546068241', '1546068241', '0', '0');
INSERT INTO `wja_user` VALUES ('27', '2', '1', '1', '0', '8', '0', 'changshangYY', '4b2180f2f68aaf34fdd8ae19e384eb82', '', '', '18888888888', '', '0.00', '', '', '1', '1', '1546055454', '1546055509', '1546055467', '1', '0');
INSERT INTO `wja_user` VALUES ('28', '5', '1', '5', '0', '13', '0', 'caiwu', '4b2180f2f68aaf34fdd8ae19e384eb82', '', '', '18888888888', '', '0.00', '', '', '1', '1', '1546066037', '1546066084', '1546066051', '1', '0');
INSERT INTO `wja_user` VALUES ('29', '0', '1', '0', '1', '0', '0', '13698569856', '8d6bdd2fb7434b9fd3ac15e174ff6f12', '', '', '13698569856', '', '0.00', '', '', '1', '1', '1546075693', '1546075693', '0', '0', '0');
INSERT INTO `wja_user` VALUES ('30', '3', '1', '18', '1', '2', '0', 'admin', 'f62df18cf9f77c1ddd315da773e0a18b', '', '', '13587458962', '', '0.00', '', '', '1', '1', '1546497078', '1546497098', '0', '1', '0');

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
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='会员收货地址';

-- ----------------------------
-- Records of wja_user_address
-- ----------------------------
INSERT INTO `wja_user_address` VALUES ('1', '23', 'John', '13714906176', '1969', '广东省 深圳市 宝安区', '德赛大厦', '1', '1', '1545914524', '1545915351', '1');
INSERT INTO `wja_user_address` VALUES ('2', '23', '123', '13714906176', '4', '北京市 北京市 东城区', '；啊啊啦啦', '0', '1', '1545914598', '1545915511', '1');
INSERT INTO `wja_user_address` VALUES ('3', '23', '坎坎坷坷', '13714854856', '222', '山西省 太原市 小店区', '啦啦啦', '0', '1', '1545914655', '1545914655', '0');
INSERT INTO `wja_user_address` VALUES ('4', '23', '哦哦哦', '13714906176', '469', '辽宁省 沈阳市 和平区', '去去去去去去', '0', '1', '1545963116', '1546047798', '0');
INSERT INTO `wja_user_address` VALUES ('5', '23', '哦哦哦', '13965845862', '353', '内蒙古自治区 呼和浩特市 新城区', '去去去去去去', '0', '1', '1545963165', '1545967929', '0');
INSERT INTO `wja_user_address` VALUES ('9', '23', 'dsad', '13845215336', '4', '北京市 北京市 东城区', 'dasdas', '1', '1', '1546047798', '1546047798', '0');
INSERT INTO `wja_user_address` VALUES ('10', '23', 'LLL', '13985485758', '4', '北京市 北京市 东城区', 'dsadas', '0', '1', '1546048169', '1546048169', '0');

-- ----------------------------
-- Table structure for wja_user_admin
-- ----------------------------
DROP TABLE IF EXISTS `wja_user_admin`;
CREATE TABLE `wja_user_admin` (
  `admin_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `factory_id` int(10) unsigned NOT NULL DEFAULT '0',
  `admin_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '账户类型(1平台管理账号 2厂商管理账号 3渠道商 4服务商 5 零售商)',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '关联商户ID',
  `is_admin` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否是管理员账号',
  `group_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '管理员分组',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0',
  `last_login_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`admin_id`),
  KEY `user_id` (`user_id`),
  KEY `factory_id` (`factory_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of wja_user_admin
-- ----------------------------

-- ----------------------------
-- Table structure for wja_user_data
-- ----------------------------
DROP TABLE IF EXISTS `wja_user_data`;
CREATE TABLE `wja_user_data` (
  `udata_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `factory_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '厂商ID(账户所属厂商）',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '关联user表ID',
  `openid` varchar(255) NOT NULL DEFAULT '' COMMENT '第三方账号对应平台唯一标识',
  `third_type` varchar(25) NOT NULL DEFAULT '' COMMENT '第三方账号类型(wechat_applet微信小程序 wechat微信公众账号)',
  `user_type` varchar(50) NOT NULL DEFAULT '' COMMENT '客户端类型(installer工程师 user客户端)',
  `appid` varchar(255) NOT NULL DEFAULT '' COMMENT '应用appid',
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
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='会员第三方账号表';

-- ----------------------------
-- Records of wja_user_data
-- ----------------------------
INSERT INTO `wja_user_data` VALUES ('1', '1', '0', 'UapWWTevQW3Q1N39ml2NMHmqjRCSVC', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5IFQcoCbsSAV_Ev8ozvW52s', '', '', '0', '', '1545379999', '1545379999', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('2', '1', '7', 'uAtCN58Q7n88J0X2OZM3VSaV7FBPcy', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5CYQhZxKWgWDkLAcMKozzPI', '', '', '0', '', '1545380042', '1545380133', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('3', '1', '8', '9GO96pZbIjtdYULBAu4jbQKXCdcNMl', 'wechat_applet', 'installer', 'wx06b088dbc933d613', '_ozO5o5Dpcrcmq0fBgYpUmJDftl0M', '', '', '0', '', '1545380184', '1545382316', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('4', '1', '19', 'DtOnXc3nrxe0DmceExnF8k6Ams0mYY', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5GMeyco56yLdvyPI21bIPp0', '', '', '0', '', '1545380352', '1545614837', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('5', '1', '0', 'UuMX8EecWkDiPnwmo8NS2NfI1fjX7r', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5Fx5mlEiqaO8fq4qnWyARFI', '', '', '0', '', '1545386953', '1545386953', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('6', '1', '9', '7ICpYvlPt9JPv0e8yZ44HrPMUbT0zI', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5F0XQTBGBHhS76lzlI5E8Bg', '', '', '0', '', '1545391622', '1545391721', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('7', '1', '10', 'QgNaql3nzob4sUfRyNcxxtV0hr5gTA', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5DefFnfH_hzwF8gR3v4VHHA', '', '', '0', '', '1545393550', '1545393579', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('8', '1', '11', 'nsRoO7ic0rhKv6VZIMlBzk5hLBCDXd', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5FbuzmSPsYckg7z64Uwozys', '', '', '0', '', '1545393916', '1545393945', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('9', '1', '12', 'nyFWQJGVYImNfwR0dZnDPVRWIgwWkb', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5Oxl2glo_YccVwxn5UGsMHY', '', '', '0', '', '1545394275', '1545394314', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('10', '1', '16', 'qcp5mWcm6kxVSj2E3SD4ARgVwHiVv2', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5KRfPiMAUKG8eZosYm2ntuI', '', '', '0', '', '1545453392', '1545458032', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('11', '1', '15', 'r1mI7IvZLob3ZKIelAtDB6kZQ65RYf', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5CyjvknJsUHu0eY0OhWlDkY', '', '', '0', '', '1545453483', '1545454043', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('12', '1', '13', '37fhhYhkC1EGXNKw1Yv8H9fjcAw5hb', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5FrP0UrhYnHOHPEeJnHZZho', '', '', '0', '', '1545453488', '1545453509', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('13', '1', '14', '7M9FOeVzfhXqAT1KGlYjyiNVpEGen6', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5Gk_oPEQK3rm6s0Sv1wxytA', '', '', '0', '', '1545453541', '1545453567', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('14', '1', '0', 'RoGf0Judl1ij46Qb811VvRBC9frOuE', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5MmpFwFqti7805MQ0DdZgUQ', '', '', '0', '', '1545453554', '1545453554', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('15', '1', '17', 'DIG3aAz3FsDr2DRBDlhe3wKWCAw2Mk', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5BDnElxxAWWrjAKs9Dx3whs', '', '', '0', '', '1545453678', '1545460025', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('16', '1', '0', 'GhOVmqk7ggXi5lkCEf4xzVwF3vVA5U', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5Df7MS7kk33ZDoeKelSUG0I', '', '', '0', '', '1545469870', '1545469870', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('17', '1', '18', 'WUt0RF2dIwltRBeZwXuPoyW2nhaoPb', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5KDs7cgq3z5YTmkaQDZhPgM', '', '', '0', '', '1545474380', '1545474394', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('18', '1', '0', 'dg0XYFtz4vWtfDdoXCPwo30Fh1LyBM', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5G_37vDpt0RoPNYM4PIOlxc', '', '', '0', '', '1545476761', '1545476761', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('19', '1', '0', 'CncUfQmTBY6voZH8AaRDK1C1qfC3Di', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5BO2giafpKbpzhSLkuro2Yw', '', '', '0', '', '1545584650', '1545584650', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('20', '1', '0', 'jCbjPyRd4zfCEz4Qz1mE7sXfYa4CWQ', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5DgD4n9lTHKI3UXM61n9gqE', '', '', '0', '', '1545588866', '1545588866', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('21', '1', '0', '6ZiT7xjmJsTUhEzr56D3ILYGBFomXZ', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5CnaEp2Te5pvx9-9b-iUbfE', '', '', '0', '', '1545591344', '1545591344', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('22', '1', '0', 'jswW6poCxjHMmSEe8t1kDfgvjUKXQH', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5BWmSnlyqMZO1hFrpyGVRCc', '', '', '0', '', '1545592076', '1545592076', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('23', '1', '20', 'TLTqXnpBpmiGNK09Rvi7tEH3hkt9AZ', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5J4MRwIPfgP5p3wpnJUzLzE', '', '', '0', '', '1545633790', '1545633825', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('24', '1', '0', '9IfrkfySEfVujkEmmShzWRSFEHdzaU', 'wechat_applet', 'user', 'wxf0b833c0aa297da9', '_oP69Z5OHDi1BM_3lJPKQ1ptdvDXo', '', '', '0', '', '1545885196', '1545885196', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('25', '1', '21', 'WPT9NW7YPwi4N5bGVJbyCkj36iq8Cx', 'wechat_applet', 'user', 'wxf0b833c0aa297da9', '_oP69Z5OHDi1BM_3lJPKQ1ptdvDXo', '', '', '0', '', '1545898018', '1545898430', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('26', '1', '23', 'WIOCGOvksVI5FIFPXm7ZviXY4G6nt6', 'wechat_applet', 'user', 'wxf0b833c0aa297da9', 'oP69Z5OHDi1BM_3lJPKQ1ptdvDXo', '', '', '0', '', '1545900453', '1545900742', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('27', '1', '23', 'WmS2yGsmLPCHgOQN08kxcDrd0eUMoP', 'wechat_applet', 'installer', 'wx06b088dbc933d613', 'ozO5o5Dpcrcmq0fBgYpUmJDftl0M', '', '', '0', '', '1545984323', '1545985010', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('28', '1', '25', '9unAG9EkBybKsjiNeJ8pF29DRQUzGa', 'wechat_applet', 'user', 'wxf0b833c0aa297da9', 'oP69Z5O-2mBeLlvj05qraQVUPTmw', '', '', '0', '', '1545991446', '1545991972', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('29', '1', '24', 'YngWlWcEmDsdI5BbVjORG2YgsnCdEv', 'wechat_applet', 'user', 'wxf0b833c0aa297da9', 'oP69Z5KDwB1ZO4GJuvEzhpQg0H9I', '', '', '0', '', '1545991704', '1545991727', '1', '0', '');
INSERT INTO `wja_user_data` VALUES ('30', '1', '7', 'YNmBOI90CNVBMGiVRndIwma0v5bwnY', 'wechat_applet', 'user', 'wxf0b833c0aa297da9', 'oP69Z5Kx1cl6nIOWxLDsUEvUxsW0', '', '', '0', '', '1546068710', '1546069012', '1', '0', '');

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
  `group_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '1 admin下角色 2 factory下角色 ',
  `store_type` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商户类型',
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
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='用户分组表';

-- ----------------------------
-- Records of wja_user_group
-- ----------------------------
INSERT INTO `wja_user_group` VALUES ('1', '2', '1', '0', '厂商', '1', '1', '10', '0', '1535715012', '1545293430', '[{\"id\":5,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"\"},{\"id\":6,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"home\"},{\"id\":124,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"profile\"},{\"id\":125,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"password\"},{\"id\":7,\"module\":\"factory\",\"controller\":\"\",\"action\":\"\"},{\"id\":83,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"index\"},{\"id\":114,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"detail\"},{\"id\":84,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"add\"},{\"id\":85,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"edit\"},{\"id\":86,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"publish\"},{\"id\":87,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"del\"},{\"id\":9,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"index\"},{\"id\":96,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"add\"},{\"id\":97,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"edit\"},{\"id\":98,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"del\"},{\"id\":10,\"module\":\"factory\",\"controller\":\"system\",\"action\":\"factory\"},{\"id\":117,\"module\":\"factory\",\"controller\":\"payment\",\"action\":\"index\"},{\"id\":118,\"module\":\"factory\",\"controller\":\"payment\",\"action\":\"config\"},{\"id\":119,\"module\":\"factory\",\"controller\":\"payment\",\"action\":\"del\"},{\"id\":12,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"\"},{\"id\":13,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"index\"},{\"id\":18,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"add\"},{\"id\":19,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"edit\"},{\"id\":20,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"del\"},{\"id\":21,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"spec\"},{\"id\":22,\"module\":\"factory\",\"controller\":\"gcate\",\"action\":\"index\"},{\"id\":23,\"module\":\"factory\",\"controller\":\"gcate\",\"action\":\"add\"},{\"id\":24,\"module\":\"factory\",\"controller\":\"gcate\",\"action\":\"edit\"},{\"id\":25,\"module\":\"factory\",\"controller\":\"gcate\",\"action\":\"del\"},{\"id\":55,\"module\":\"factory\",\"controller\":\"gspec\",\"action\":\"index\"},{\"id\":56,\"module\":\"factory\",\"controller\":\"gspec\",\"action\":\"add\"},{\"id\":57,\"module\":\"factory\",\"controller\":\"gspec\",\"action\":\"edit\"},{\"id\":58,\"module\":\"factory\",\"controller\":\"gspec\",\"action\":\"del\"},{\"id\":14,\"module\":\"factory\",\"controller\":\"merchant\",\"action\":\"\"},{\"id\":35,\"module\":\"factory\",\"controller\":\"channel\",\"action\":\"index\"},{\"id\":36,\"module\":\"factory\",\"controller\":\"channel\",\"action\":\"add\"},{\"id\":37,\"module\":\"factory\",\"controller\":\"channel\",\"action\":\"edit\"},{\"id\":127,\"module\":\"factory\",\"controller\":\"channel\",\"action\":\"detail\"},{\"id\":38,\"module\":\"factory\",\"controller\":\"channel\",\"action\":\"del\"},{\"id\":79,\"module\":\"factory\",\"controller\":\"channel\",\"action\":\"manager\"},{\"id\":121,\"module\":\"factory\",\"controller\":\"channel\",\"action\":\"resetpwd\"},{\"id\":39,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"index\"},{\"id\":40,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"add\"},{\"id\":41,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"edit\"},{\"id\":128,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"detail\"},{\"id\":42,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"del\"},{\"id\":80,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"manager\"},{\"id\":122,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"resetpwd\"},{\"id\":43,\"module\":\"factory\",\"controller\":\"servicer\",\"action\":\"index\"},{\"id\":44,\"module\":\"factory\",\"controller\":\"servicer\",\"action\":\"add\"},{\"id\":45,\"module\":\"factory\",\"controller\":\"servicer\",\"action\":\"edit\"},{\"id\":129,\"module\":\"factory\",\"controller\":\"servicer\",\"action\":\"detail\"},{\"id\":46,\"module\":\"factory\",\"controller\":\"servicer\",\"action\":\"del\"},{\"id\":81,\"module\":\"factory\",\"controller\":\"servicer\",\"action\":\"manager\"},{\"id\":123,\"module\":\"factory\",\"controller\":\"servicer\",\"action\":\"resetpwd\"},{\"id\":131,\"module\":\"factory\",\"controller\":\"store\",\"action\":\"detail\"},{\"id\":132,\"module\":\"factory\",\"controller\":\"store\",\"action\":\"check\"},{\"id\":133,\"module\":\"factory\",\"controller\":\"storeaction\",\"action\":\"index\"},{\"id\":134,\"module\":\"factory\",\"controller\":\"storeaction\",\"action\":\"detail\"},{\"id\":135,\"module\":\"factory\",\"controller\":\"storeaction\",\"action\":\"check\"},{\"id\":15,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"\"},{\"id\":59,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"index\"},{\"id\":94,\"module\":\"factory\",\"controller\":\"security\",\"action\":\"index\"},{\"id\":95,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"finance\"},{\"id\":99,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"check\"},{\"id\":16,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"\"},{\"id\":47,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"index\"},{\"id\":100,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"check\"},{\"id\":115,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"detail\"},{\"id\":17,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"\"},{\"id\":51,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"index\"},{\"id\":136,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"lists\"},{\"id\":52,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"add\"},{\"id\":53,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"edit\"},{\"id\":54,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"del\"},{\"id\":101,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"dispatch\"},{\"id\":102,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"detail\"},{\"id\":103,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"cancel\"},{\"id\":116,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"assess\"},{\"id\":70,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"\"},{\"id\":71,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"index\"},{\"id\":72,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"detail\"},{\"id\":73,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"pay\"},{\"id\":74,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"cancel\"},{\"id\":76,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"delivery\"},{\"id\":77,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"deliverylogs\"},{\"id\":78,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"finish\"},{\"id\":106,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"seller\"},{\"id\":107,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"detail\"},{\"id\":108,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"check\"},{\"id\":111,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"cancel\"},{\"id\":113,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"refund\"},{\"id\":137,\"module\":\"factory\",\"controller\":\"site\",\"action\":\"\"},{\"id\":144,\"module\":\"factory\",\"controller\":\"site\",\"action\":\"index\"},{\"id\":138,\"module\":\"factory\",\"controller\":\"site\",\"action\":\"setting\"},{\"id\":140,\"module\":\"factory\",\"controller\":\"site\",\"action\":\"menu\"},{\"id\":148,\"module\":\"factory\",\"controller\":\"site\",\"action\":\"nav\"},{\"id\":149,\"module\":\"factory\",\"controller\":\"site\",\"action\":\"add_menu\"},{\"id\":152,\"module\":\"factory\",\"controller\":\"site\",\"action\":\"del_menu\"},{\"id\":139,\"module\":\"factory\",\"controller\":\"article\",\"action\":\"index\"},{\"id\":141,\"module\":\"factory\",\"controller\":\"article\",\"action\":\"add\"},{\"id\":142,\"module\":\"factory\",\"controller\":\"article\",\"action\":\"del\"},{\"id\":143,\"module\":\"factory\",\"controller\":\"article\",\"action\":\"publish\"},{\"id\":147,\"module\":\"factory\",\"controller\":\"site\",\"action\":\"page\"},{\"id\":150,\"module\":\"factory\",\"controller\":\"site\",\"action\":\"add_page\"},{\"id\":151,\"module\":\"factory\",\"controller\":\"site\",\"action\":\"del_page\"},{\"id\":145,\"module\":\"factory\",\"controller\":\"site\",\"action\":\"banner\"},{\"id\":146,\"module\":\"factory\",\"controller\":\"site\",\"action\":\"del\"}]');
INSERT INTO `wja_user_group` VALUES ('2', '2', '2', '0', '渠道商', '1', '1', '30', '0', '1535715012', '1545293476', '[{\"id\":5,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"\"},{\"id\":6,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"home\"},{\"id\":124,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"profile\"},{\"id\":125,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"password\"},{\"id\":7,\"module\":\"factory\",\"controller\":\"\",\"action\":\"\"},{\"id\":83,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"index\"},{\"id\":114,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"detail\"},{\"id\":9,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"index\"},{\"id\":96,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"add\"},{\"id\":97,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"edit\"},{\"id\":98,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"del\"},{\"id\":14,\"module\":\"factory\",\"controller\":\"merchant\",\"action\":\"\"},{\"id\":39,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"index\"},{\"id\":40,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"add\"},{\"id\":41,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"edit\"},{\"id\":128,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"detail\"},{\"id\":42,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"del\"},{\"id\":122,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"resetpwd\"},{\"id\":133,\"module\":\"factory\",\"controller\":\"storeaction\",\"action\":\"index\"},{\"id\":134,\"module\":\"factory\",\"controller\":\"storeaction\",\"action\":\"detail\"},{\"id\":15,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"\"},{\"id\":59,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"index\"},{\"id\":88,\"module\":\"factory\",\"controller\":\"commission\",\"action\":\"index\"},{\"id\":92,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"setting\"},{\"id\":93,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"apply\"},{\"id\":17,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"\"},{\"id\":51,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"index\"},{\"id\":52,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"add\"},{\"id\":102,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"detail\"},{\"id\":103,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"cancel\"},{\"id\":60,\"module\":\"factory\",\"controller\":\"purchase\",\"action\":\"\"},{\"id\":61,\"module\":\"factory\",\"controller\":\"purchase\",\"action\":\"index\"},{\"id\":62,\"module\":\"factory\",\"controller\":\"purchase\",\"action\":\"detail\"},{\"id\":63,\"module\":\"factory\",\"controller\":\"purchase\",\"action\":\"confirm\"},{\"id\":64,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"index\"},{\"id\":69,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"pay\"},{\"id\":65,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"detail\"},{\"id\":66,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"cancel\"},{\"id\":67,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"deliverylogs\"},{\"id\":68,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"finish\"},{\"id\":104,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"return\"},{\"id\":82,\"module\":\"factory\",\"controller\":\"suborder\",\"action\":\"index\"},{\"id\":90,\"module\":\"factory\",\"controller\":\"suborder\",\"action\":\"detail\"},{\"id\":105,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"index\"},{\"id\":109,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"detail\"},{\"id\":110,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"cancel\"},{\"id\":112,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"delivery\"}]');
INSERT INTO `wja_user_group` VALUES ('3', '2', '3', '0', '零售商', '1', '1', '40', '0', '1535715012', '1545293514', '[{\"id\":5,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"\"},{\"id\":6,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"home\"},{\"id\":124,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"profile\"},{\"id\":125,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"password\"},{\"id\":7,\"module\":\"factory\",\"controller\":\"\",\"action\":\"\"},{\"id\":83,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"index\"},{\"id\":114,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"detail\"},{\"id\":9,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"index\"},{\"id\":96,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"add\"},{\"id\":97,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"edit\"},{\"id\":98,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"del\"},{\"id\":17,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"\"},{\"id\":51,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"index\"},{\"id\":52,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"add\"},{\"id\":102,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"detail\"},{\"id\":103,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"cancel\"},{\"id\":60,\"module\":\"factory\",\"controller\":\"purchase\",\"action\":\"\"},{\"id\":61,\"module\":\"factory\",\"controller\":\"purchase\",\"action\":\"index\"},{\"id\":62,\"module\":\"factory\",\"controller\":\"purchase\",\"action\":\"detail\"},{\"id\":63,\"module\":\"factory\",\"controller\":\"purchase\",\"action\":\"confirm\"},{\"id\":64,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"index\"},{\"id\":69,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"pay\"},{\"id\":65,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"detail\"},{\"id\":66,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"cancel\"},{\"id\":67,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"deliverylogs\"},{\"id\":68,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"finish\"},{\"id\":104,\"module\":\"factory\",\"controller\":\"myorder\",\"action\":\"return\"},{\"id\":105,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"index\"},{\"id\":109,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"detail\"},{\"id\":110,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"cancel\"},{\"id\":112,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"delivery\"}]');
INSERT INTO `wja_user_group` VALUES ('4', '2', '4', '0', '服务商', '1', '1', '20', '0', '1535715012', '1545293451', '[{\"id\":5,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"\"},{\"id\":6,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"home\"},{\"id\":124,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"profile\"},{\"id\":125,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"password\"},{\"id\":7,\"module\":\"factory\",\"controller\":\"\",\"action\":\"\"},{\"id\":83,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"index\"},{\"id\":114,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"detail\"},{\"id\":9,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"index\"},{\"id\":96,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"add\"},{\"id\":97,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"edit\"},{\"id\":98,\"module\":\"factory\",\"controller\":\"user\",\"action\":\"del\"},{\"id\":126,\"module\":\"factory\",\"controller\":\"system\",\"action\":\"wxacode\"},{\"id\":15,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"\"},{\"id\":59,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"index\"},{\"id\":88,\"module\":\"factory\",\"controller\":\"commission\",\"action\":\"index\"},{\"id\":92,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"setting\"},{\"id\":93,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"apply\"},{\"id\":16,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"\"},{\"id\":47,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"index\"},{\"id\":49,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"edit\"},{\"id\":50,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"del\"},{\"id\":100,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"check\"},{\"id\":115,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"detail\"},{\"id\":17,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"\"},{\"id\":51,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"index\"},{\"id\":136,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"lists\"},{\"id\":52,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"add\"},{\"id\":53,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"edit\"},{\"id\":54,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"del\"},{\"id\":101,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"dispatch\"},{\"id\":102,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"detail\"},{\"id\":103,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"cancel\"}]');
INSERT INTO `wja_user_group` VALUES ('5', '1', '0', '0', '财务', '0', '1', '100', '0', '1535715012', '1545293616', '');
INSERT INTO `wja_user_group` VALUES ('6', '1', '0', '0', '运营', '0', '1', '110', '0', '1535715012', '1545293622', '');
INSERT INTO `wja_user_group` VALUES ('7', '1', '0', '0', '客服', '0', '1', '120', '0', '1535715012', '1545293629', '');
INSERT INTO `wja_user_group` VALUES ('8', '2', '1', '0', '厂商-运营', '0', '1', '11', '0', '1545289947', '1545293550', '[{\"id\":5,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"\"},{\"id\":124,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"profile\"},{\"id\":125,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"password\"},{\"id\":7,\"module\":\"factory\",\"controller\":\"\",\"action\":\"\"},{\"id\":114,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"detail\"},{\"id\":83,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"index\"},{\"id\":84,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"add\"},{\"id\":85,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"edit\"},{\"id\":86,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"publish\"},{\"id\":87,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"del\"},{\"id\":12,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"\"},{\"id\":13,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"index\"},{\"id\":18,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"add\"},{\"id\":19,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"edit\"},{\"id\":20,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"del\"},{\"id\":21,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"spec\"},{\"id\":22,\"module\":\"factory\",\"controller\":\"gcate\",\"action\":\"index\"},{\"id\":23,\"module\":\"factory\",\"controller\":\"gcate\",\"action\":\"add\"},{\"id\":24,\"module\":\"factory\",\"controller\":\"gcate\",\"action\":\"edit\"},{\"id\":25,\"module\":\"factory\",\"controller\":\"gcate\",\"action\":\"del\"},{\"id\":55,\"module\":\"factory\",\"controller\":\"gspec\",\"action\":\"index\"},{\"id\":56,\"module\":\"factory\",\"controller\":\"gspec\",\"action\":\"add\"},{\"id\":57,\"module\":\"factory\",\"controller\":\"gspec\",\"action\":\"edit\"},{\"id\":58,\"module\":\"factory\",\"controller\":\"gspec\",\"action\":\"del\"},{\"id\":16,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"\"},{\"id\":47,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"index\"},{\"id\":48,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"add\"},{\"id\":49,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"edit\"},{\"id\":50,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"del\"},{\"id\":100,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"check\"},{\"id\":115,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"detail\"},{\"id\":17,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"\"},{\"id\":51,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"index\"},{\"id\":102,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"detail\"},{\"id\":103,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"cancel\"},{\"id\":70,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"\"},{\"id\":71,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"index\"},{\"id\":72,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"detail\"},{\"id\":106,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"seller\"},{\"id\":108,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"check\"},{\"id\":107,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"detail\"}]');
INSERT INTO `wja_user_group` VALUES ('9', '2', '1', '0', '厂商-客服', '0', '1', '12', '0', '1545293674', '1545293699', '[{\"id\":5,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"\"},{\"id\":124,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"profile\"},{\"id\":125,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"password\"},{\"id\":7,\"module\":\"factory\",\"controller\":\"\",\"action\":\"\"},{\"id\":114,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"detail\"},{\"id\":12,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"\"},{\"id\":13,\"module\":\"factory\",\"controller\":\"goods\",\"action\":\"index\"},{\"id\":14,\"module\":\"factory\",\"controller\":\"merchant\",\"action\":\"\"},{\"id\":35,\"module\":\"factory\",\"controller\":\"channel\",\"action\":\"index\"},{\"id\":121,\"module\":\"factory\",\"controller\":\"channel\",\"action\":\"resetpwd\"},{\"id\":39,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"index\"},{\"id\":122,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"resetpwd\"},{\"id\":43,\"module\":\"factory\",\"controller\":\"servicer\",\"action\":\"index\"},{\"id\":123,\"module\":\"factory\",\"controller\":\"servicer\",\"action\":\"resetpwd\"},{\"id\":16,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"\"},{\"id\":47,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"index\"},{\"id\":115,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"detail\"},{\"id\":17,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"\"},{\"id\":51,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"index\"},{\"id\":102,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"detail\"},{\"id\":103,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"cancel\"},{\"id\":116,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"assess\"},{\"id\":70,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"\"},{\"id\":71,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"index\"},{\"id\":72,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"detail\"},{\"id\":106,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"seller\"},{\"id\":107,\"module\":\"factory\",\"controller\":\"service\",\"action\":\"detail\"}]');
INSERT INTO `wja_user_group` VALUES ('10', '2', '1', '0', '厂商-财务', '0', '1', '13', '0', '1545293689', '1545293689', '[{\"id\":5,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"\"},{\"id\":124,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"profile\"},{\"id\":125,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"password\"},{\"id\":7,\"module\":\"factory\",\"controller\":\"\",\"action\":\"\"},{\"id\":114,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"detail\"},{\"id\":14,\"module\":\"factory\",\"controller\":\"merchant\",\"action\":\"\"},{\"id\":35,\"module\":\"factory\",\"controller\":\"channel\",\"action\":\"index\"},{\"id\":39,\"module\":\"factory\",\"controller\":\"dealer\",\"action\":\"index\"},{\"id\":43,\"module\":\"factory\",\"controller\":\"servicer\",\"action\":\"index\"},{\"id\":15,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"\"},{\"id\":59,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"index\"},{\"id\":94,\"module\":\"factory\",\"controller\":\"security\",\"action\":\"index\"},{\"id\":95,\"module\":\"factory\",\"controller\":\"order\",\"action\":\"finance\"},{\"id\":99,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"check\"}]');
INSERT INTO `wja_user_group` VALUES ('11', '2', '4', '0', '服务商-运营', '0', '1', '21', '0', '1545293744', '1545293744', '[{\"id\":5,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"\"},{\"id\":124,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"profile\"},{\"id\":125,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"password\"},{\"id\":7,\"module\":\"factory\",\"controller\":\"\",\"action\":\"\"},{\"id\":114,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"detail\"},{\"id\":16,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"\"},{\"id\":47,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"index\"},{\"id\":48,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"add\"},{\"id\":49,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"edit\"},{\"id\":50,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"del\"},{\"id\":115,\"module\":\"factory\",\"controller\":\"installer\",\"action\":\"detail\"},{\"id\":17,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"\"},{\"id\":51,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"index\"},{\"id\":101,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"dispatch\"},{\"id\":102,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"detail\"},{\"id\":103,\"module\":\"factory\",\"controller\":\"workorder\",\"action\":\"cancel\"}]');
INSERT INTO `wja_user_group` VALUES ('12', '2', '4', '0', '服务商-客服', '0', '1', '22', '1', '1545293765', '1545307536', '');
INSERT INTO `wja_user_group` VALUES ('13', '2', '4', '0', '服务商-财务', '0', '1', '23', '0', '1545293778', '1545293778', '[{\"id\":5,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"\"},{\"id\":124,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"profile\"},{\"id\":125,\"module\":\"factory\",\"controller\":\"index\",\"action\":\"password\"},{\"id\":7,\"module\":\"factory\",\"controller\":\"\",\"action\":\"\"},{\"id\":114,\"module\":\"factory\",\"controller\":\"bulletin\",\"action\":\"detail\"},{\"id\":15,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"\"},{\"id\":59,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"index\"},{\"id\":88,\"module\":\"factory\",\"controller\":\"commission\",\"action\":\"index\"},{\"id\":92,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"setting\"},{\"id\":93,\"module\":\"factory\",\"controller\":\"finance\",\"action\":\"apply\"}]');

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
  `score` float(4,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '工程师综合得分',
  `admin_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '管理员操作记录',
  PRIMARY KEY (`installer_id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='售后工程师数据表';

-- ----------------------------
-- Records of wja_user_installer
-- ----------------------------
INSERT INTO `wja_user_installer` VALUES ('1', '34707500', '7', '1', '5', '钢铁侠', '0', '18565854698', '', 'http://pimvhcf3v.bkt.clouddn.com/api_idcard20181221161625_tmp_16b47d93b3354c28be054d1c99e1e8e54b76fe18fa812041.jpg', 'http://pimvhcf3v.bkt.clouddn.com/api_idcard20181221161629_tmp_498974df4bfb1c4ade8516d55ce3d79ea3d09452bab4d0e9.jpg', '1', '1', '1545380194', '1546068197', '0', '', '', '12', '413023', '1', '3.25', '');
INSERT INTO `wja_user_installer` VALUES ('2', '79839209', '8', '1', '5', 'John', '0', '13714906176', '', 'http://pimvhcf3v.bkt.clouddn.com/api_idcard20181221174135_tmp_22dfe0c995e4bedc0ae08d10b6c4751adbbf0f394c866d26.jpg', 'http://pimvhcf3v.bkt.clouddn.com/api_idcard20181221174147_tmp_41298be45cd3648199a9e51adc114da278b65837dd95b4c5.jpg', '1', '1', '1545385320', '1545792666', '0', '', '', '1', '备案号44092132545', '1', '5.00', '');
INSERT INTO `wja_user_installer` VALUES ('3', '29879034', '9', '1', '5', '小君', '0', '13760170785', '', 'http://pimvhcf3v.bkt.clouddn.com/api_idcard20181221192938_tmp_cbdd6c137b52524360aa869f351e482d9d6166654d96cbb9.jpg', 'http://pimvhcf3v.bkt.clouddn.com/api_idcard20181221192944_tmp_f28ecf8549c743b1cf613031b057e12811ffca778865cce7.jpg', '1', '1', '1545391788', '1545391799', '0', '', '', '0', '123456', '1', '0.00', '');
INSERT INTO `wja_user_installer` VALUES ('4', '32430351', '11', '1', '5', 'bonnie', '0', '13163770899', '', 'http://pimvhcf3v.bkt.clouddn.com/api_idcard20181221200643_tmp_cb55fded87db0191a09a73d2d64116dcb6b6fb63f2f60804.jpg', 'http://pimvhcf3v.bkt.clouddn.com/api_idcard20181221200652_tmp_977cf3fbe67d50afa350d196457e82ee85f0fbf764138216.jpg', '1', '1', '1545394016', '1546066534', '0', '', '', '0', '2202', '1', '0.00', '');
INSERT INTO `wja_user_installer` VALUES ('5', '48061442', '12', '1', '5', '金宏业', '0', '17620489746', '', 'http://pimvhcf3v.bkt.clouddn.com/api_idcard20181221201232_tmp_3cfee3b077009c7aa900ab00402cadd9.jpg', 'http://pimvhcf3v.bkt.clouddn.com/api_idcard20181221201248_tmp_60079ce2443242e1c0c52176f2d3992f.jpg', '1', '1', '1545394422', '1545394766', '0', '', '', '0', '123456', '1', '0.00', '');
INSERT INTO `wja_user_installer` VALUES ('6', '16530286', '19', '1', '5', '郭坤鹏', '0', '15118815476', '', 'http://pimvhcf3v.bkt.clouddn.com/api_idcard20181224092821_tmp_da60b8bdce08de0d94a9ef32e3963720ebad6815e17a1fc2.jpg', 'http://pimvhcf3v.bkt.clouddn.com/api_idcard20181224092832_tmp_663ef16386eeda55fff7d0cbfd633ca751cfdd1eba6e12a2.jpg', '1', '1', '1545614915', '1545718916', '1', '', '', '0', '1010101004', '1', '0.00', '');
INSERT INTO `wja_user_installer` VALUES ('7', '37840938', '18', '1', '5', '许明', '0', '15815515135', '', 'http://img.zxjsj.zhidekan.me/api_idcard20181224115101_tmp_a052b5657318bc0ec790bb0e9fe17fdc.jpg', 'http://img.zxjsj.zhidekan.me/api_idcard20181224115111_tmp_6ff090180ceb8b8e7b83349b519dd21a.jpg', '1', '1', '1545623473', '1545623485', '0', '', '', '1', '', '1', '0.00', '');
INSERT INTO `wja_user_installer` VALUES ('8', '33041335', '20', '1', '5', '张', '0', '13823562155', '', 'http://img.zxjsj.zhidekan.me/api_idcard20181224144430_tmp_fe26c9bd1087b3549c082ff27f853e87.jpg', 'http://img.zxjsj.zhidekan.me/api_idcard20181224144437_tmp_2b4aca7d54065aaf60d78ee293744e79.jpg', '1', '1', '1545633879', '1545633879', '0', '', '', '0', '111', '-3', '0.00', '');
INSERT INTO `wja_user_installer` VALUES ('9', '09170830', '19', '1', '5', '郭坤鹏', '0', '15118815476', '', 'http://img.zxjsj.zhidekan.me/api_idcard20181225142238_tmp_cc646b67d1c6269a6b76cead367eb5340fda9f3e3972ac86.jpg', 'http://img.zxjsj.zhidekan.me/api_idcard20181225142245_tmp_649a0e562992b69f5f07aa2fa07b41edc48c2d9a1d284772.jpg', '1', '1', '1545719008', '1546050022', '1', '', '', '0', '123456', '1', '0.00', '');
INSERT INTO `wja_user_installer` VALUES ('10', '43130329', '23', '1', '5', 'John', '0', '13714906176', '', 'http://img.zxjsj.zhidekan.me/api_idcard20181228161717_wx06b088dbc933d613.o6zAJszlz6qiRFZVQ_cJgToWLKbE.ahXjEC293MWi5830128093f94e27a03f24b8ea29bc05.png', 'http://img.zxjsj.zhidekan.me/api_idcard20181228161727_wx06b088dbc933d613.o6zAJszlz6qiRFZVQ_cJgToWLKbE.0QnkcOlwqRll931803610bbcbbf010fd9afa85fb6677.png', '1', '1', '1545985057', '1545985078', '1', '', '', '0', '备案001', '-3', '0.00', '');
INSERT INTO `wja_user_installer` VALUES ('11', '27076741', '23', '1', '5', 'John001', '0', '13714906176', '', 'http://img.zxjsj.zhidekan.me/api_idcard20181228161845_wx06b088dbc933d613.o6zAJszlz6qiRFZVQ_cJgToWLKbE.Mod1j0irfWkHf886b2b53c78839a70074fd86afefe67.png', 'http://img.zxjsj.zhidekan.me/api_idcard20181228161848_wx06b088dbc933d613.o6zAJszlz6qiRFZVQ_cJgToWLKbE.ARr8YI6YObGd931803610bbcbbf010fd9afa85fb6677.png', '1', '1', '1545985130', '1546066364', '0', '', '', '5', '备案', '1', '2.88', '');
INSERT INTO `wja_user_installer` VALUES ('12', '64088460', '19', '1', '5', '孟德', '0', '15118815476', '', 'http://img.zxjsj.zhidekan.me/api_idcard20181229102146_tmp_6de0634cca7c87a5f5a89f2e9fe2dcdd8d5e2636fa3652be.jpg', 'http://img.zxjsj.zhidekan.me/api_idcard20181229102152_tmp_5772276f2bcec178f4569012cec5355f53975f432de7fbe8.jpg', '1', '1', '1546050114', '1546069711', '0', '', '', '5', '110', '1', '3.00', '');

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
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Records of wja_user_installer_score
-- ----------------------------
INSERT INTO `wja_user_installer_score` VALUES ('1', '1', '1', '3.00', '1545380514', '1546068197');
INSERT INTO `wja_user_installer_score` VALUES ('2', '1', '2', '3.50', '1545380514', '1546068197');
INSERT INTO `wja_user_installer_score` VALUES ('3', '2', '1', '5.00', '1545792666', '1545792666');
INSERT INTO `wja_user_installer_score` VALUES ('4', '2', '2', '5.00', '1545792666', '1545792666');
INSERT INTO `wja_user_installer_score` VALUES ('5', '11', '1', '2.31', '1546053815', '1546066364');
INSERT INTO `wja_user_installer_score` VALUES ('6', '11', '2', '3.44', '1546053815', '1546066364');
INSERT INTO `wja_user_installer_score` VALUES ('7', '12', '1', '4.00', '1546069245', '1546069711');
INSERT INTO `wja_user_installer_score` VALUES ('8', '12', '2', '2.00', '1546069245', '1546069711');

-- ----------------------------
-- Table structure for wja_web_article
-- ----------------------------
DROP TABLE IF EXISTS `wja_web_article`;
CREATE TABLE `wja_web_article` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `store_id` int(10) unsigned NOT NULL COMMENT '商户编号',
  `menu_id` int(11) DEFAULT NULL COMMENT '导航ID',
  `is_top` tinyint(2) DEFAULT NULL COMMENT '0正常，1置顶（首页显示）',
  `title` varchar(255) DEFAULT NULL COMMENT '标题',
  `summary` varchar(255) DEFAULT NULL COMMENT '简介',
  `content` text COMMENT '内容',
  `cover_img` varchar(255) DEFAULT NULL COMMENT '封面图片',
  `add_time` int(10) unsigned DEFAULT NULL COMMENT '添加时间',
  `update_time` int(10) unsigned DEFAULT NULL COMMENT '更新时间',
  `status` tinyint(2) DEFAULT '0' COMMENT '状态：0未发布,1已发布',
  `is_del` tinyint(2) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `store_id` (`store_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of wja_web_article
-- ----------------------------
INSERT INTO `wja_web_article` VALUES ('1', '1', '0', null, 'aaas', 'AASAS', '		                  	<h2>\r\n	88asasds\r\n</h2>		                  ', 'http://img.zxjsj.zhidekan.me/20181226181311_1.png', '1545817152', '1545821858', '0', '1');
INSERT INTO `wja_web_article` VALUES ('2', '1', '0', null, 'aassad', 'assasssasssasd88as8s88s8sss', '<h2>\r\n	asdsadsdas 8888aasss\r\n</h2>', 'http://img.zxjsj.zhidekan.me/20181226190148.png', '1545822111', '1545898589', '1', '1');
INSERT INTO `wja_web_article` VALUES ('3', '1', '0', null, 'aassa', 'asassa', 'assasdsadasas', 'http://img.zxjsj.zhidekan.me/20181226190304_1.png', '1545822191', '1545825119', '0', '1');
INSERT INTO `wja_web_article` VALUES ('4', '1', '0', null, 'asas', 'Asas', 'sasdassa', '', '1545824769', '1545825080', '0', '1');
INSERT INTO `wja_web_article` VALUES ('5', '1', '0', null, 'ass', 'AASsass', 'asassa', '', '1545824778', '1545825086', '0', '1');
INSERT INTO `wja_web_article` VALUES ('6', '1', '0', null, '茜茜大哥大', '基本原则柜橱 枯', '苛在基本原则基本原则工柜橱 苛在茜茜在 森苛基本原则苛要苛', 'http://img.zxjsj.zhidekan.me/20181227100453_1.png', '1545876300', '1546503129', '0', '1');
INSERT INTO `wja_web_article` VALUES ('7', '1', '0', '7', '66工基本原则苛', '苛苛', 'asdasdasdasdasasdasdasdasdsd', '', '1546072177', '1546509227', '1', '1');
INSERT INTO `wja_web_article` VALUES ('8', '0', null, null, null, null, 'qd asd as asd asd asd as as&nbsp;', null, '1546072271', '1546415353', '0', '1');
INSERT INTO `wja_web_article` VALUES ('9', '0', null, null, null, null, '<p>\r\n	公司动态公司动态公司动态公司动\r\n</p>\r\n<p>\r\n	态公司动态公司动态公司动态公司动态\r\n</p>', null, '1546072408', '1546415348', '0', '1');
INSERT INTO `wja_web_article` VALUES ('10', '0', null, null, null, null, '<p>\r\n	渠道服务\r\n</p>\r\n<p>\r\n	<br />\r\n</p>\r\n<p>\r\n	渠道服务\r\n</p>\r\n<p>\r\n	<br />\r\n</p>\r\n<p>\r\n	渠道服务\r\n</p>\r\n<p>\r\n	<br />\r\n</p>\r\n<p>\r\n	渠道服务\r\n</p>', null, '1546072487', '1546393935', '0', '1');
INSERT INTO `wja_web_article` VALUES ('11', '1', '0', '1', '苛苛苛基本原则', '苛苛基本原则基本原则苛苛工林', '		                  	基本原则基本原则苛		                  ', 'http://img.zxjsj.zhidekan.me/20190103153618.png', '1546500985', '1546503152', '0', '0');

-- ----------------------------
-- Table structure for wja_web_banner
-- ----------------------------
DROP TABLE IF EXISTS `wja_web_banner`;
CREATE TABLE `wja_web_banner` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `img_url` varchar(255) NOT NULL COMMENT '图片路径',
  `link_url` varchar(255) NOT NULL COMMENT '图片链接地址',
  `type` tinyint(2) NOT NULL COMMENT '0轮播导航，1图片导航',
  `sort` int(255) DEFAULT '0' COMMENT '排序，正序',
  `group_id` int(255) DEFAULT '0' COMMENT '分给排序',
  `add_time` int(10) unsigned DEFAULT NULL COMMENT '添加时间',
  `update_time` int(10) unsigned DEFAULT NULL COMMENT '更新时间',
  `is_del` tinyint(2) DEFAULT '0' COMMENT '0正常，1已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of wja_web_banner
-- ----------------------------
INSERT INTO `wja_web_banner` VALUES ('7', 'http://img.zxjsj.zhidekan.me/20181227163550_3.png', 'www.abcdefg.com', '0', '0', '0', '1545899763', '1545990547', '0');
INSERT INTO `wja_web_banner` VALUES ('8', 'http://img.zxjsj.zhidekan.me/20181227163803_3.png', 'www.baaa.com', '0', '0', '0', '1545899888', '1545899888', '0');
INSERT INTO `wja_web_banner` VALUES ('14', 'http://img.zxjsj.zhidekan.me/20181228142114_1.png', 'www.33333.com', '1', '14', '1', '1545978101', '1545994356', '1');
INSERT INTO `wja_web_banner` VALUES ('15', 'http://img.zxjsj.zhidekan.me/20181228142121_1.png', 'www.222222.com', '1', '15', '1', '1545978101', '1545991116', '0');
INSERT INTO `wja_web_banner` VALUES ('27', 'http://img.zxjsj.zhidekan.me/20181229171402_4.png', 'www.alibaba.com', '0', '27', '0', '1545986250', '1546074861', '1');
INSERT INTO `wja_web_banner` VALUES ('28', 'http://img.zxjsj.zhidekan.me/20181228163725_logo.jpg', 'www.qq.com', '1', '28', '10', '1545986250', '1545986250', '0');
INSERT INTO `wja_web_banner` VALUES ('29', 'http://img.zxjsj.zhidekan.me/20181229090145_4.png', 'www.baidu.com', '1', '29', '11', '1546045332', '1546045332', '0');
INSERT INTO `wja_web_banner` VALUES ('30', 'http://img.zxjsj.zhidekan.me/20181229090151_4.png', 'www.qq.com', '1', '30', '11', '1546045332', '1546045332', '0');
INSERT INTO `wja_web_banner` VALUES ('31', 'http://img.zxjsj.zhidekan.me/20181229090156_4.png', 'www.taobao.com', '1', '31', '11', '1546045332', '1546045332', '0');
INSERT INTO `wja_web_banner` VALUES ('32', 'http://img.zxjsj.zhidekan.me/20181229090201_4.png', 'www.jd.com', '1', '32', '11', '1546045332', '1546052482', '1');
INSERT INTO `wja_web_banner` VALUES ('33', 'http://img.zxjsj.zhidekan.me/20181229110140_4.png', 'www.baidu.com', '1', '33', '12', '1546052527', '1546052527', '0');
INSERT INTO `wja_web_banner` VALUES ('34', 'http://img.zxjsj.zhidekan.me/20181229110146_4.png', 'www.qq.com', '1', '34', '12', '1546052527', '1546052527', '0');
INSERT INTO `wja_web_banner` VALUES ('35', 'http://img.zxjsj.zhidekan.me/20181229110153_4.png', 'www.taobao.com', '1', '35', '12', '1546052527', '1546052527', '0');
INSERT INTO `wja_web_banner` VALUES ('36', 'http://img.zxjsj.zhidekan.me/20181229110159_4.png', 'www.jd.com', '1', '36', '12', '1546052527', '1546052527', '0');

-- ----------------------------
-- Table structure for wja_web_banner_group
-- ----------------------------
DROP TABLE IF EXISTS `wja_web_banner_group`;
CREATE TABLE `wja_web_banner_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `add_time` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of wja_web_banner_group
-- ----------------------------
INSERT INTO `wja_web_banner_group` VALUES ('1', '1545978101');
INSERT INTO `wja_web_banner_group` VALUES ('2', '1545982995');
INSERT INTO `wja_web_banner_group` VALUES ('3', '1545983223');
INSERT INTO `wja_web_banner_group` VALUES ('4', '1545983849');
INSERT INTO `wja_web_banner_group` VALUES ('5', '1545983909');
INSERT INTO `wja_web_banner_group` VALUES ('6', '1545983993');
INSERT INTO `wja_web_banner_group` VALUES ('7', '1545984622');
INSERT INTO `wja_web_banner_group` VALUES ('8', '1545984640');
INSERT INTO `wja_web_banner_group` VALUES ('9', '1545985200');
INSERT INTO `wja_web_banner_group` VALUES ('10', '1545986250');
INSERT INTO `wja_web_banner_group` VALUES ('11', '1546045332');
INSERT INTO `wja_web_banner_group` VALUES ('12', '1546052527');

-- ----------------------------
-- Table structure for wja_web_config
-- ----------------------------
DROP TABLE IF EXISTS `wja_web_config`;
CREATE TABLE `wja_web_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(255) NOT NULL COMMENT '厂商ID',
  `name` varchar(255) DEFAULT NULL COMMENT '配置名',
  `key` varchar(255) DEFAULT NULL COMMENT '配置key',
  `value` varchar(1024) DEFAULT NULL COMMENT '配置value',
  `status` tinyint(255) DEFAULT '1' COMMENT '是否启用',
  `add_time` int(255) DEFAULT NULL COMMENT '添加时间',
  `update_time` int(11) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`,`store_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of wja_web_config
-- ----------------------------
INSERT INTO `wja_web_config` VALUES ('3', '1', '基本配置', 'setting', '{\"logo\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/20181226161522_logo.jpg\",\"copyright\":\"Copyright©2014-2018 深圳市智享科技有限公司  版权所有\",\"icp\":\"粤ICP备12019339号-2\",\"hot_line\":\"400-566-1686\",\"address\":\"深圳市南山区XXXXX\",\"login_bg\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/20181226161011_1.png\",\"qrcode\":\"http:\\/\\/img.zxjsj.zhidekan.me\\/20181226161500_3.png\"}', '1', '1545811818', '1545812125');

-- ----------------------------
-- Table structure for wja_web_menu
-- ----------------------------
DROP TABLE IF EXISTS `wja_web_menu`;
CREATE TABLE `wja_web_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '0顶部导航，1底部导航',
  `page_type` tinyint(2) DEFAULT '0' COMMENT '0单页，1链接',
  `store_id` int(11) NOT NULL COMMENT '商户ID',
  `page_id` int(11) NOT NULL COMMENT '页面ID',
  `parent_id` int(10) unsigned DEFAULT '0' COMMENT '上级ID',
  `url` varchar(255) DEFAULT NULL COMMENT '链接地址',
  `sort` int(11) DEFAULT '0',
  `name` varchar(255) NOT NULL COMMENT '网站菜单名',
  `add_time` int(255) unsigned DEFAULT NULL,
  `update_time` int(10) unsigned DEFAULT NULL,
  `is_del` tinyint(255) DEFAULT '0' COMMENT '是否删除，0正常，1已删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `menu_sort_id` (`store_id`) USING BTREE,
  KEY `menu_page_id` (`page_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of wja_web_menu
-- ----------------------------
INSERT INTO `wja_web_menu` VALUES ('1', '0', '1', '1', '0', '0', '', '1', '首页', '1546508211', '1546508211', '0');
INSERT INTO `wja_web_menu` VALUES ('2', '0', '1', '1', '0', '0', '', '2', '公司动态', '1546508211', '1546508211', '0');
INSERT INTO `wja_web_menu` VALUES ('3', '0', '1', '1', '0', '0', '', '3', '渠道入驻', '1546508211', '1546508211', '0');
INSERT INTO `wja_web_menu` VALUES ('4', '0', '1', '1', '0', '0', '', '4', '零售网点', '1546508211', '1546508211', '0');

-- ----------------------------
-- Table structure for wja_web_page
-- ----------------------------
DROP TABLE IF EXISTS `wja_web_page`;
CREATE TABLE `wja_web_page` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL COMMENT '单页标题',
  `store_id` int(11) DEFAULT '0' COMMENT '商户ID',
  `type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '0链接，1单页',
  `content` text COMMENT '单页内容',
  `url` varchar(255) DEFAULT NULL COMMENT '链接',
  `add_time` int(10) unsigned DEFAULT NULL COMMENT '添加时间',
  `update_time` int(11) DEFAULT NULL COMMENT '更新时间',
  `is_del` tinyint(2) DEFAULT '0' COMMENT '0正常，1已删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `sample_store_id` (`store_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='单页';

-- ----------------------------
-- Records of wja_web_page
-- ----------------------------
INSERT INTO `wja_web_page` VALUES ('1', '零售网点', '1', '0', '		                  			                  ', 'www.baidu.com', '1546079178', '1546400537', '0');
INSERT INTO `wja_web_page` VALUES ('2', '联系我们', '1', '1', '苛达芬奇 苛苛苛', null, '1546079275', '1546400608', '0');
INSERT INTO `wja_web_page` VALUES ('3', '66666666', '1', '1', '', 'www.q88q.com', '1546079575', '1546393400', '1');
INSERT INTO `wja_web_page` VALUES ('4', '99999', '1', '0', 'sadasd5a5sd5asd5sad5sd5sd5sd5sd', 'www.baidu.com', '1546082254', '1546082291', '1');
INSERT INTO `wja_web_page` VALUES ('5', '测试链接', '1', '0', null, 'www.baidu.com', '1546391509', '1546400620', '0');
INSERT INTO `wja_web_page` VALUES ('6', '渠道服务', '1', '1', '基本原则基本原则基本原则基本原则苛苛', 'www.baidu.com', '1546392442', '1546400578', '0');
INSERT INTO `wja_web_page` VALUES ('7', '关于我们', '1', '0', '基本原则基本原则基本原则', 'www.baidu.com', '1546392502', '1546412373', '1');
INSERT INTO `wja_web_page` VALUES ('8', '行业动态', '1', '0', null, 'www.baidu.com', '1546397609', '1546400476', '0');
INSERT INTO `wja_web_page` VALUES ('9', '渠道新闻', '1', '0', null, 'www.baidu.com', '1546397795', '1546400503', '0');

-- ----------------------------
-- Table structure for wja_work_order
-- ----------------------------
DROP TABLE IF EXISTS `wja_work_order`;
CREATE TABLE `wja_work_order` (
  `worder_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '工单自增长ID',
  `worder_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '工单编号',
  `work_order_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '工单类型(1安装工单 2故障报修)',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '维修工单对应的安装工单',
  `factory_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '厂商ID',
  `store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '工单服务商ID',
  `post_user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '工单提交用户ID',
  `post_store_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '提交工单商户ID',
  `order_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '安装工单关联订单编号',
  `osku_id` int(10) unsigned NOT NULL DEFAULT '0',
  `ossub_id` int(10) unsigned NOT NULL DEFAULT '0',
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
  `work_order_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态(-1 已取消 0待分派 1待接单 2待上门 3服务中 4服务完成)',
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
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`worder_id`) USING BTREE,
  KEY `worder_sn` (`worder_sn`),
  KEY `factory_id` (`factory_id`),
  KEY `store_id` (`store_id`)
) ENGINE=MyISAM AUTO_INCREMENT=38 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='工单数据表';

-- ----------------------------
-- Records of wja_work_order
-- ----------------------------
INSERT INTO `wja_work_order` VALUES ('1', '20181221161936651053', '1', '0', '1', '5', '5', '4', '20181221161445531015571266774', '1', '1', '11', '19', '0', '1', '钢铁侠', '18565854698', '1965', '广东省 深圳市', '二道口子右拐', '1545386400', '', '', '1', '4', '1545380376', '1545380469', '0', '1545380486', '1545380490', '1545380494', '1545380494', '0', '0.01', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('2', '20181221162204256530', '2', '1', '1', '5', '2', '1', '20181221161445531015571266774', '1', '1', '11', '19', '0', '1', '钢铁侠', '18565854698', '1965', '广东省 深圳市', '二道口子右拐', '1545386400', '', '坏了', '1', '4', '1545380524', '1545380555', '0', '1545380605', '1545380608', '1545380612', '1545380612', '0', '0.01', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('3', '20181221175000623647', '1', '0', '1', '5', '5', '4', '20181221174711102100020789604', '3', '3', '11', '19', '0', '2', '曾大腿', '13958458755', '1965', '广东省 深圳市', '德赛科技大厦', '1545901200', 'http://pimvhcf3v.bkt.clouddn.com/20181221174810.png', '', '1', '4', '1545385800', '1545385833', '0', '1545389879', '1545437850', '1545461237', '1545461237', '0', '0.01', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('4', '20181221175359887186', '1', '0', '1', '5', '5', '4', '20181221174955515197060400288', '4', '4', '11', '18', '0', '0', '赵云', '15698786754', '1965', '广东省 深圳市', '南山区大冲商务中心', '1545472320', '', '', '1', '-1', '1545386039', '1545386119', '1545702133', '0', '0', '0', '1545702133', '0', '0.01', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('5', '20181224091842663853', '1', '0', '1', '5', '5', '4', '20181224091740525252047510697', '5', '5', '10', '23', '0', '1', '蜘蛛侠', '18565854698', '1965', '广东省 深圳市', '二道口子右拐', '1545616800', '', '', '1', '4', '1545614322', '1545614381', '0', '1545614404', '1545614408', '1545614412', '1545614412', '0', '0.01', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('6', '20181224092100901428', '2', '5', '1', '5', '2', '1', '20181224091740525252047510697', '5', '5', '10', '23', '0', '7', '蜘蛛侠', '18565854698', '1965', '广东省 深圳市', '二道口子右拐', '1545616800', '', '坏了', '1', '4', '1545614460', '1545623523', '0', '1545623539', '1545623542', '1545623545', '1545623545', '0', '0.01', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('7', '20181225143000839998', '1', '0', '1', '5', '5', '4', '20181225142636999710963464721', '25', '27', '11', '19', '0', '1', '蜘蛛侠', '18565854698', '1965', '广东省 深圳市', '二道口子', '1545721200', '', '', '1', '4', '1545719400', '1545719519', '0', '1545719539', '1545719542', '1545719545', '1545719545', '0', '0.01', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('8', '20181225143905865384', '2', '7', '1', '5', '2', '1', '20181225142636999710963464721', '25', '27', '11', '19', '0', '1', '蜘蛛侠', '18565854698', '1965', '广东省 深圳市', '二道口子', '1545721200', '', '坏了', '1', '4', '1545719945', '1545719991', '0', '1545720012', '1545720028', '1545720090', '1545720090', '0', '0.01', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('9', '20181225144722850558', '1', '0', '1', '5', '4', '3', '20181225144523519950259485886', '29', '31', '11', '19', '0', '1', '蜘蛛侠', '18565854698', '1965', '广东省 深圳市', '二道口子', '1545721200', '', '', '1', '4', '1545720442', '1545720499', '0', '1545720536', '1545720539', '1545720542', '1545720542', '0', '0.01', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('10', '20181225144924647302', '2', '9', '1', '5', '2', '1', '20181225144523519950259485886', '29', '31', '11', '19', '0', '1', '蜘蛛侠', '18565854698', '1965', '广东省 深圳市', '二道口子', '1545721200', '', '坏了', '1', '4', '1545720564', '1545720572', '0', '1545721021', '1545721024', '1545721028', '1545721028', '0', '0.01', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('11', '20181228143954319892', '2', '0', '1', '5', '23', '0', '', '0', '0', '8', '0', '23', '0', 'John', '13714906176', '1966', '广东省 深圳市 罗湖区', 'asdasdasd', '1545926400', '', '', '1', '-1', '1545979194', '0', '1545982214', '0', '0', '0', '1545982214', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('12', '20181228144125886407', '2', '0', '1', '5', '23', '0', '', '0', '0', '11', '0', '23', '0', 'Pkiud', '15245875956', '1966', '广东省 深圳市 罗湖区', 'ewwwww', '1545926520', '', '这是维修说明', '1', '-1', '1545979285', '0', '1545990566', '0', '0', '0', '1545990566', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('13', '20181228144440289402', '2', '0', '1', '5', '23', '0', '', '0', '0', '9', '0', '23', '2', '曾大大大', '15425754854', '1966', '广东省 深圳市 罗湖区', '德赛德赛德赛大大大啥', '1609084800', 'http://img.zxjsj.zhidekan.me/api_idcard20181228144304_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.VAoh7mcN4VHQf886b2b53c78839a70074fd86afefe67.png,http://img.zxjsj.zhidekan.me/api_idcard20181228144309_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.sjLnWmnV4rOA70757369d999833ae5058022b6c713e9.png,http://img.zxjsj.zhidekan.me/api_idcard20181228144312_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.sH4001ty7Gbnc632573c2d087a4be218e2d64b107fc7.png', '', '1', '-1', '1545979480', '1545982390', '1545985175', '0', '0', '0', '1545985175', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('14', '20181228153702864305', '2', '0', '1', '5', '23', '0', '', '0', '0', '11', '0', '23', '11', '老黄', '13845754582', '1966', '广东省 深圳市 罗湖区', '高新园666', '1609084800', 'http://img.zxjsj.zhidekan.me/api_idcard20181228153656_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.Kju7hT37oUot9625ec3dbf8ad1868896abe693cb23cf.png,http://img.zxjsj.zhidekan.me/api_idcard20181228153700_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.81D813WTjWpI9458aad2032e2da5880f50305e64a561.png', '牛牛牛牛牛牛牛牛牛牛牛牛牛牛牛牛牛牛', '1', '-1', '1545982622', '1545985327', '1545985424', '1545985381', '0', '0', '1545985424', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('15', '20181228153721691411', '2', '0', '1', '5', '23', '0', '', '0', '0', '11', '0', '23', '0', '老黄', '13845754582', '1966', '广东省 深圳市 罗湖区', '高新园666', '1609084800', 'http://img.zxjsj.zhidekan.me/api_idcard20181228153656_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.Kju7hT37oUot9625ec3dbf8ad1868896abe693cb23cf.png,http://img.zxjsj.zhidekan.me/api_idcard20181228153700_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.81D813WTjWpI9458aad2032e2da5880f50305e64a561.png', '牛牛牛牛牛牛牛牛牛牛牛牛牛牛牛牛牛牛', '1', '-1', '1545982641', '0', '1545983988', '0', '0', '0', '1545983988', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('16', '20181228154258515323', '2', '0', '1', '5', '23', '0', '', '0', '0', '8', '0', '23', '0', 'John', '13685478548', '1967', '广东省 深圳市 福田区', 'dddddd', '1545933660', 'http://img.zxjsj.zhidekan.me/api_idcard20181228154246_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.Hz5AE2q5ruPb517ce3716134615ba05feee6ff1d2c9b.png,http://img.zxjsj.zhidekan.me/api_idcard20181228154249_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.OgxSP5qnbydJ2afb76b2847aaffb662b0e5b478f40a2.png,http://img.zxjsj.zhidekan.me/api_idcard20181228154252_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.pizbSg1Otu8Pf886b2b53c78839a70074fd86afefe67.png', 'dadsadasd', '1', '-1', '1545982978', '0', '1545984007', '0', '0', '0', '1545984007', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('17', '20181228154711230760', '2', '0', '1', '5', '23', '0', '', '0', '0', '8', '0', '23', '11', 'John', '13845215452', '1966', '广东省 深圳市 罗湖区', 'dasdas', '1640631600', '', '', '1', '4', '1545983231', '1545985316', '0', '1545988925', '1545989141', '1546053952', '1546053952', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('18', '20181228155336248806', '2', '0', '1', '5', '23', '0', '', '0', '0', '10', '0', '23', '11', 'John', '13854596586', '1968', '广东省 深圳市 南山区', 'dddd', '1577466060', '', '', '1', '4', '1545983616', '1545985191', '0', '1545985205', '1545985386', '1545985635', '1545985635', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('19', '20181228155820776778', '2', '0', '1', '5', '23', '0', '', '0', '0', '10', '0', '23', '0', 'john', '13542121524', '1966', '广东省 深圳市 罗湖区', 'dddd', '1545926400', '', '', '1', '-1', '1545983900', '0', '1545984016', '0', '0', '0', '1545984016', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('20', '20181228171726082147', '2', '0', '1', '5', '23', '0', '', '0', '0', '8', '0', '23', '11', '黄老板', '13854524512', '1966', '广东省 深圳市 罗湖区', '大大大', '1577462460', 'http://img.zxjsj.zhidekan.me/api_idcard20181228171721_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.mIpIwdnrfBIu9625ec3dbf8ad1868896abe693cb23cf.png,http://img.zxjsj.zhidekan.me/api_idcard20181228171724_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.3EKU6r52nshsfb6320c65a8d369777b4139362cf4596.png', '\n羚羊峡谷是世界上著名的狭缝型峡谷之一，也是著名的摄影景点，位于美国亚利桑纳州北方，最靠近的城市为佩吉市，属于纳瓦荷原住民保护区。羚羊峡谷在地形上分为两个独立的部分，', '1', '4', '1545988646', '1545988815', '0', '1545989121', '1546054209', '1546054222', '1546054222', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('21', '20181228171936928524', '2', '0', '1', '5', '23', '0', '', '0', '0', '10', '0', '23', '11', '啦啦啦', '13965254578', '1967', '广东省 深圳市 福田区', '上羚羊峡谷与下羚羊峡谷', '1543341600', 'http://img.zxjsj.zhidekan.me/api_idcard20181228171909_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.rnFovQz0dOt5517ce3716134615ba05feee6ff1d2c9b.png', '2018年8月11日 - 当我第一次开始在美国西南部的公路旅行中参观羚羊峡谷时,在亚利桑那州的一个条纹和明亮的橙色纳瓦霍砂岩峡谷...', '1', '4', '1545988776', '1545988809', '0', '1546063282', '1546063289', '1546063325', '1546063325', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('22', '20181228174444402059', '2', '0', '1', '5', '23', '0', '', '0', '0', '8', '0', '23', '11', 'ooo', '19854587854', '1969', '广东省 深圳市 宝安区', '德赛大大点啥', '1640620800', 'http://img.zxjsj.zhidekan.me/api_idcard20181228174439_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.x3NufaP9PG58f886b2b53c78839a70074fd86afefe67.png,http://img.zxjsj.zhidekan.me/api_idcard20181228174443_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.31UxCFLkbx3H9458aad2032e2da5880f50305e64a561.png', '啦啦啦这是谁', '1', '3', '1545990284', '1546066766', '0', '1546066797', '1546066805', '0', '1546066805', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('23', '20181228174859562645', '2', '0', '1', '5', '23', '0', '', '0', '0', '9', '0', '23', '0', '啪啪啪', '13845457854', '1968', '广东省 深圳市 南山区', '管道工', '1546099200', 'http://img.zxjsj.zhidekan.me/api_idcard20181228174858_wxf0b833c0aa297da9.o6zAJszlz6qiRFZVQ_cJgToWLKbE.EDx7CMRuBU6V517ce3716134615ba05feee6ff1d2c9b.png', '的点点滴滴', '1', '0', '1545990539', '0', '0', '0', '0', '0', '1545990539', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('24', '20181228175552540108', '1', '0', '1', '5', '5', '4', '20181228175445534853281947923', '40', '42', '11', '19', '0', '1', '蜘蛛侠', '18565854698', '1965', '广东省 深圳市', '二道口子', '1545994800', '', '', '1', '4', '1545990952', '1545991815', '0', '1545991863', '1545991866', '1545991869', '1545991869', '0', '0.01', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('25', '20181228181259724322', '2', '24', '1', '5', '2', '1', '20181228175445534853281947923', '40', '42', '11', '19', '0', '1', '蜘蛛侠', '18565854698', '1965', '广东省 深圳市', '二道口子', '1545998400', '', '坏了', '1', '4', '1545991979', '1545992007', '0', '1545992015', '1545992018', '1545992021', '1545992021', '0', '0.01', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('26', '20181228181423913524', '2', '0', '1', '5', '25', '0', '', '0', '0', '8', '0', '25', '1', '刘畅', '18903769208', '1968', '广东省 深圳市 南山区', '我也不知道这是哪', '1546078380', '', '', '1', '4', '1545992063', '1546068114', '0', '1546068128', '1546068144', '1546068173', '1546068173', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('27', '20181228184056972461', '1', '0', '1', '5', '5', '4', '20181228184005534910223759900', '41', '43', '11', '19', '0', '0', 'zhuzh', '18888888888', '1965', '广东省 深圳市', '二道口子', '1546002000', '', '', '1', '0', '1545993656', '0', '0', '0', '0', '0', '1545993656', '0', '0.01', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('28', '20181228184337471804', '1', '0', '1', '5', '5', '4', '20181228184210501024133410700', '42', '44', '11', '19', '0', '11', '蜘蛛', '18888888888', '1965', '广东省 深圳市', '二道口子', '1546002000', '', '', '1', '1', '1545993817', '1546066694', '0', '0', '0', '0', '1546066694', '0', '0.01', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('29', '20181229091242611061', '2', '0', '1', '5', '23', '0', '', '0', '0', '11', '0', '23', '11', 'ZENG', '13714906176', '1968', '广东省 深圳市 南山区', '德赛大厦', '1546045980', 'http://img.zxjsj.zhidekan.me/api_idcard20181229090754_tmp_3f4af389bd4691fa2ba982b6067a98387976f518d71be770.jpg', '', '1', '4', '1546045962', '1546066276', '0', '1546066287', '1546066305', '1546066327', '1546066327', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('30', '20181229100318281360', '1', '0', '1', '5', '5', '4', '20181229100233579855109535557', '44', '46', '11', '19', '0', '1', 'zhi', '18888888888', '1965', '广东省 深圳市', '二道口子', '1546056000', '', '', '1', '4', '1546048998', '1546049182', '0', '1546049201', '1546049205', '1546049211', '1546049211', '0', '0.01', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('31', '20181229100825841208', '2', '30', '1', '5', '2', '1', '20181229100233579855109535557', '44', '46', '11', '19', '0', '1', 'zhi', '18888888888', '1965', '广东省 深圳市', '二道口子', '1546052400', '', '...', '1', '4', '1546049305', '1546049432', '0', '1546049600', '1546049604', '1546049607', '1546049607', '0', '0.01', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('32', '20181229152023523293', '2', '0', '1', '5', '25', '0', '', '0', '0', '8', '0', '25', '12', '刘畅', '18903769208', '1968', '广东省 深圳市 南山区', '我不知道', '1546077600', '', '', '1', '4', '1546068023', '1546068488', '0', '1546068564', '1546068569', '1546069215', '1546069215', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('33', '20181229153810861377', '2', '0', '1', '5', '7', '0', '', '0', '0', '10', '0', '7', '12', '菩提祖师', '18888888888', '1968', '广东省 深圳市 南山区', '犄角旮旯', '1546070400', '', '', '1', '4', '1546069090', '1546069104', '0', '1546069136', '1546069196', '1546069219', '1546069219', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('34', '20181229154339504688', '2', '0', '1', '5', '7', '0', '', '0', '0', '8', '0', '7', '12', '菩提祖师', '18888888888', '1968', '广东省 深圳市 南山区', '犄角旮旯', '1546069620', '', '', '1', '-1', '1546069419', '1546069432', '1546069555', '1546069535', '0', '0', '1546069555', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('35', '20181229154728084640', '2', '0', '1', '5', '7', '0', '', '0', '0', '8', '0', '7', '12', '菩提祖师', '18888888888', '1968', '广东省 深圳市 南山区', '犄角旮旯', '1546069860', '', '', '1', '4', '1546069648', '1546069662', '0', '1546069675', '1546069680', '1546069695', '1546069695', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('36', '20181229160148037404', '2', '0', '1', '5', '7', '0', '', '0', '0', '8', '0', '7', '12', '菩提祖师', '15188578675', '1968', '广东省 深圳市 南山区', '犄角旮旯', '1546070820', '', '', '1', '4', '1546070508', '1546070557', '0', '1546070567', '1546070571', '1546070585', '1546070585', '0', '0.00', '0.00', '1');
INSERT INTO `wja_work_order` VALUES ('37', '20181229160432889813', '2', '0', '1', '5', '7', '0', '', '0', '0', '10', '0', '7', '12', '菩提祖师', '15188578675', '1968', '广东省 深圳市 南山区', '犄角旮旯', '1546070940', '', '', '1', '4', '1546070672', '1546070686', '0', '1546070706', '1546070720', '1546070724', '1546070724', '0', '0.00', '0.00', '1');

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
) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='工单评价数据表';

-- ----------------------------
-- Records of wja_work_order_assess
-- ----------------------------
INSERT INTO `wja_work_order_assess` VALUES ('1', '1', '20181221161936651053', '1', '2', 'wanjiaan', '1', '', '1545380514', '0');
INSERT INTO `wja_work_order_assess` VALUES ('2', '2', '20181221162204256530', '1', '2', 'wanjiaan', '1', '', '1545380627', '0');
INSERT INTO `wja_work_order_assess` VALUES ('3', '5', '20181224091842663853', '1', '2', 'wanjiaan', '1', '', '1545614448', '0');
INSERT INTO `wja_work_order_assess` VALUES ('4', '5', '20181224091842663853', '1', '2', 'wanjiaan', '2', '', '1545616541', '0');
INSERT INTO `wja_work_order_assess` VALUES ('5', '3', '20181221175000623647', '2', '0', '系统', '1', '默认好评', '1545792666', '0');
INSERT INTO `wja_work_order_assess` VALUES ('6', '18', '20181228155336248806', '11', '23', '系统', '1', '', '1546053815', '0');
INSERT INTO `wja_work_order_assess` VALUES ('7', '17', '20181228154711230760', '11', '23', '系统', '1', '哈哈哈9999966666', '1546054019', '0');
INSERT INTO `wja_work_order_assess` VALUES ('8', '20', '20181228171726082147', '11', '23', '系统', '1', '', '1546054527', '0');
INSERT INTO `wja_work_order_assess` VALUES ('9', '17', '20181228154711230760', '11', '23', '系统', '2', '', '1546062774', '0');
INSERT INTO `wja_work_order_assess` VALUES ('10', '18', '20181228155336248806', '11', '23', '系统', '2', '', '1546063085', '0');
INSERT INTO `wja_work_order_assess` VALUES ('11', '31', '20181229100825841208', '1', '2', 'wanjiaan', '1', '', '1546064033', '0');
INSERT INTO `wja_work_order_assess` VALUES ('12', '21', '20181228171936928524', '11', '23', '系统', '1', 'zhengahi=dweqweqweqwe', '1546065297', '0');
INSERT INTO `wja_work_order_assess` VALUES ('13', '21', '20181228171936928524', '11', '23', '系统', '2', 'dddddd', '1546065318', '0');
INSERT INTO `wja_work_order_assess` VALUES ('14', '20', '20181228171726082147', '11', '23', '系统', '2', '我啦啦啦啦啦啦啦啦啦啦啦啦啦', '1546065441', '0');
INSERT INTO `wja_work_order_assess` VALUES ('15', '29', '20181229091242611061', '11', '23', '系统', '1', '', '1546066364', '0');
INSERT INTO `wja_work_order_assess` VALUES ('16', '26', '20181228181423913524', '1', '25', '系统', '1', '服务不好', '1546068197', '0');
INSERT INTO `wja_work_order_assess` VALUES ('17', '26', '20181228181423913524', '1', '25', '系统', '2', '师傅已经跑了', '1546068212', '0');
INSERT INTO `wja_work_order_assess` VALUES ('18', '33', '20181229153810861377', '12', '7', '系统', '1', '师傅没来', '1546069245', '0');
INSERT INTO `wja_work_order_assess` VALUES ('19', '33', '20181229153810861377', '12', '7', '系统', '2', '没来', '1546069256', '0');
INSERT INTO `wja_work_order_assess` VALUES ('20', '35', '20181229154728084640', '12', '7', '系统', '1', '不会修', '1546069711', '0');
INSERT INTO `wja_work_order_assess` VALUES ('21', '35', '20181229154728084640', '12', '7', '系统', '2', '不会修', '1546069720', '0');

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
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

-- ----------------------------
-- Records of wja_work_order_assess_log
-- ----------------------------
INSERT INTO `wja_work_order_assess_log` VALUES ('1', '1', '1', '1', '5.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('2', '1', '1', '2', '5.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('3', '2', '1', '1', '5.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('4', '2', '1', '2', '5.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('5', '3', '1', '1', '5.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('6', '3', '1', '2', '5.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('7', '5', '2', '1', '5.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('8', '5', '2', '2', '5.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('9', '6', '11', '1', '3.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('10', '6', '11', '2', '4.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('11', '7', '11', '1', '2.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('12', '7', '11', '2', '3.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('13', '8', '11', '1', '2.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('14', '8', '11', '2', '2.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('15', '11', '1', '1', '5.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('16', '11', '1', '2', '5.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('17', '12', '11', '1', '3.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('18', '12', '11', '2', '5.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('19', '15', '11', '1', '2.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('20', '15', '11', '2', '3.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('21', '16', '1', '1', '1.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('22', '16', '1', '2', '2.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('23', '18', '12', '1', '3.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('24', '18', '12', '2', '3.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('25', '20', '12', '1', '5.00');
INSERT INTO `wja_work_order_assess_log` VALUES ('26', '20', '12', '2', '1.00');

-- ----------------------------
-- Table structure for wja_work_order_installer_record
-- ----------------------------
DROP TABLE IF EXISTS `wja_work_order_installer_record`;
CREATE TABLE `wja_work_order_installer_record` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `worder_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单ID',
  `worder_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '订单号',
  `installer_id` int(10) NOT NULL COMMENT '工程师ID',
  `action` varchar(255) NOT NULL DEFAULT '' COMMENT '操作方法',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态(-1 已取消 0已拒绝 1正常 2分派转移)',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`log_id`),
  KEY `worder_id` (`worder_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_work_order_installer_record
-- ----------------------------
INSERT INTO `wja_work_order_installer_record` VALUES ('1', '4', '20181221175359887186', '1', 'refuse', '1545386244', '1545386257', '1', '1');
INSERT INTO `wja_work_order_installer_record` VALUES ('2', '4', '20181221175359887186', '1', 'refuse', '1545386257', '1545386257', '1', '0');
INSERT INTO `wja_work_order_installer_record` VALUES ('3', '6', '20181224092100901428', '1', 'dispatch_other', '1545614933', '1545614933', '2', '0');
INSERT INTO `wja_work_order_installer_record` VALUES ('4', '6', '20181224092100901428', '6', 'dispatch_other', '1545623523', '1545623523', '2', '0');
INSERT INTO `wja_work_order_installer_record` VALUES ('5', '32', '20181229152023523293', '1', 'refuse', '1546068386', '1546068386', '1', '0');
INSERT INTO `wja_work_order_installer_record` VALUES ('6', '32', '20181229152023523293', '12', 'refuse', '1546068473', '1546068488', '1', '1');
INSERT INTO `wja_work_order_installer_record` VALUES ('7', '36', '20181229160148037404', '12', 'refuse', '1546070528', '1546070543', '1', '1');
INSERT INTO `wja_work_order_installer_record` VALUES ('8', '36', '20181229160148037404', '12', 'refuse', '1546070550', '1546070557', '1', '1');

-- ----------------------------
-- Table structure for wja_work_order_log
-- ----------------------------
DROP TABLE IF EXISTS `wja_work_order_log`;
CREATE TABLE `wja_work_order_log` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单日志ID',
  `worder_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单ID',
  `worder_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '订单号',
  `installer_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '工程师ID',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作用户ID',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '用户昵称',
  `action` varchar(50) NOT NULL DEFAULT '' COMMENT '操作类型',
  `msg` varchar(500) NOT NULL DEFAULT '' COMMENT '操作信息',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '日志记录时间',
  PRIMARY KEY (`log_id`) USING BTREE,
  KEY `worder_id` (`worder_id`) USING BTREE,
  KEY `worder_sn` (`worder_sn`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=187 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='工单日志数据表';

-- ----------------------------
-- Records of wja_work_order_log
-- ----------------------------
INSERT INTO `wja_work_order_log` VALUES ('1', '1', '20181221161936651053', '0', '5', 'lingshou', '创建工单', '', '1545380376');
INSERT INTO `wja_work_order_log` VALUES ('2', '1', '20181221161936651053', '1', '6', 'fuwu0', '分派工程师', '工程师姓名:钢铁侠<br>工程师电话:18565854698', '1545380469');
INSERT INTO `wja_work_order_log` VALUES ('3', '1', '20181221161936651053', '1', '7', '', '工程师接单', '', '1545380486');
INSERT INTO `wja_work_order_log` VALUES ('4', '1', '20181221161936651053', '1', '7', '', '工程师签到,服务开始', '', '1545380490');
INSERT INTO `wja_work_order_log` VALUES ('5', '1', '20181221161936651053', '1', '7', '', '确认完成', '', '1545380494');
INSERT INTO `wja_work_order_log` VALUES ('6', '1', '20181221161936651053', '0', '2', 'wanjiaan', '首次评价', '', '1545380514');
INSERT INTO `wja_work_order_log` VALUES ('7', '2', '20181221162204256530', '0', '2', 'wanjiaan', '创建工单', '', '1545380524');
INSERT INTO `wja_work_order_log` VALUES ('8', '2', '20181221162204256530', '1', '6', 'fuwu0', '分派工程师', '工程师姓名:钢铁侠<br>工程师电话:18565854698', '1545380555');
INSERT INTO `wja_work_order_log` VALUES ('9', '2', '20181221162204256530', '1', '7', '', '工程师接单', '', '1545380605');
INSERT INTO `wja_work_order_log` VALUES ('10', '2', '20181221162204256530', '1', '7', '', '工程师签到,服务开始', '', '1545380608');
INSERT INTO `wja_work_order_log` VALUES ('11', '2', '20181221162204256530', '1', '7', '', '确认完成', '', '1545380612');
INSERT INTO `wja_work_order_log` VALUES ('12', '2', '20181221162204256530', '0', '2', 'wanjiaan', '首次评价', '', '1545380627');
INSERT INTO `wja_work_order_log` VALUES ('13', '3', '20181221175000623647', '0', '5', 'lingshou', '创建工单', '', '1545385800');
INSERT INTO `wja_work_order_log` VALUES ('14', '3', '20181221175000623647', '2', '6', 'fuwu0', '分派工程师', '工程师姓名:John<br>工程师电话:13714906176', '1545385833');
INSERT INTO `wja_work_order_log` VALUES ('15', '4', '20181221175359887186', '0', '5', 'lingshou', '创建工单', '', '1545386039');
INSERT INTO `wja_work_order_log` VALUES ('16', '4', '20181221175359887186', '1', '6', 'fuwu0', '分派工程师', '工程师姓名:钢铁侠<br>工程师电话:18565854698', '1545386119');
INSERT INTO `wja_work_order_log` VALUES ('17', '4', '20181221175359887186', '1', '7', '', '工程师拒绝接单', '我没时间', '1545386244');
INSERT INTO `wja_work_order_log` VALUES ('18', '4', '20181221175359887186', '1', '7', '', '工程师拒绝接单', '我没时间', '1545386257');
INSERT INTO `wja_work_order_log` VALUES ('19', '3', '20181221175000623647', '2', '8', '', '工程师接单', '', '1545389879');
INSERT INTO `wja_work_order_log` VALUES ('20', '3', '20181221175000623647', '2', '8', '', '工程师签到,服务开始', '', '1545437850');
INSERT INTO `wja_work_order_log` VALUES ('21', '3', '20181221175000623647', '2', '8', '', '确认完成', '', '1545461237');
INSERT INTO `wja_work_order_log` VALUES ('22', '5', '20181224091842663853', '0', '5', 'lingshou', '创建工单', '', '1545614322');
INSERT INTO `wja_work_order_log` VALUES ('23', '5', '20181224091842663853', '1', '6', 'fuwu0', '分派工程师', '工程师姓名:钢铁侠<br>工程师电话:18565854698', '1545614381');
INSERT INTO `wja_work_order_log` VALUES ('24', '5', '20181224091842663853', '1', '7', '', '工程师接单', '', '1545614404');
INSERT INTO `wja_work_order_log` VALUES ('25', '5', '20181224091842663853', '1', '7', '', '工程师签到,服务开始', '', '1545614408');
INSERT INTO `wja_work_order_log` VALUES ('26', '5', '20181224091842663853', '1', '7', '', '确认完成', '', '1545614412');
INSERT INTO `wja_work_order_log` VALUES ('27', '5', '20181224091842663853', '0', '2', 'wanjiaan', '首次评价', '', '1545614448');
INSERT INTO `wja_work_order_log` VALUES ('28', '6', '20181224092100901428', '0', '2', 'wanjiaan', '创建工单', '', '1545614460');
INSERT INTO `wja_work_order_log` VALUES ('29', '6', '20181224092100901428', '1', '6', 'fuwu0', '分派工程师', '工程师姓名:钢铁侠<br>工程师电话:18565854698', '1545614518');
INSERT INTO `wja_work_order_log` VALUES ('30', '6', '20181224092100901428', '6', '6', 'fuwu0', '重新分派工程师', '工程师姓名:郭坤鹏<br>工程师电话:15118815476', '1545614933');
INSERT INTO `wja_work_order_log` VALUES ('31', '6', '20181224092100901428', '6', '19', '', '工程师接单', '', '1545615031');
INSERT INTO `wja_work_order_log` VALUES ('32', '5', '20181224091842663853', '0', '2', 'wanjiaan', '首次评价', '', '1545616541');
INSERT INTO `wja_work_order_log` VALUES ('33', '6', '20181224092100901428', '7', '6', 'fuwu0', '重新分派工程师', '工程师姓名:许明<br>工程师电话:15815515135', '1545623523');
INSERT INTO `wja_work_order_log` VALUES ('34', '6', '20181224092100901428', '7', '18', '', '工程师接单', '', '1545623539');
INSERT INTO `wja_work_order_log` VALUES ('35', '6', '20181224092100901428', '7', '18', '', '工程师签到,服务开始', '', '1545623542');
INSERT INTO `wja_work_order_log` VALUES ('36', '6', '20181224092100901428', '7', '18', '', '确认完成', '', '1545623545');
INSERT INTO `wja_work_order_log` VALUES ('37', '4', '20181221175359887186', '0', '5', 'lingshou', '取消工单', '', '1545702133');
INSERT INTO `wja_work_order_log` VALUES ('38', '7', '20181225143000839998', '0', '5', 'lingshou', '创建工单', '', '1545719400');
INSERT INTO `wja_work_order_log` VALUES ('39', '7', '20181225143000839998', '1', '6', 'fuwu0', '分派工程师', '工程师姓名:钢铁侠<br>工程师电话:18565854698', '1545719519');
INSERT INTO `wja_work_order_log` VALUES ('40', '7', '20181225143000839998', '1', '7', '', '工程师接单', '', '1545719539');
INSERT INTO `wja_work_order_log` VALUES ('41', '7', '20181225143000839998', '1', '7', '', '工程师签到,服务开始', '', '1545719542');
INSERT INTO `wja_work_order_log` VALUES ('42', '7', '20181225143000839998', '1', '7', '', '确认完成', '', '1545719545');
INSERT INTO `wja_work_order_log` VALUES ('43', '8', '20181225143905865384', '0', '2', 'wanjiaan', '创建工单', '', '1545719945');
INSERT INTO `wja_work_order_log` VALUES ('44', '8', '20181225143905865384', '1', '6', 'fuwu0', '分派工程师', '工程师姓名:钢铁侠<br>工程师电话:18565854698', '1545719991');
INSERT INTO `wja_work_order_log` VALUES ('45', '8', '20181225143905865384', '1', '7', '', '工程师接单', '', '1545720012');
INSERT INTO `wja_work_order_log` VALUES ('46', '8', '20181225143905865384', '1', '7', '', '工程师签到,服务开始', '', '1545720028');
INSERT INTO `wja_work_order_log` VALUES ('47', '8', '20181225143905865384', '1', '7', '', '确认完成', '', '1545720090');
INSERT INTO `wja_work_order_log` VALUES ('48', '9', '20181225144722850558', '0', '4', '刘越', '创建工单', '', '1545720442');
INSERT INTO `wja_work_order_log` VALUES ('49', '9', '20181225144722850558', '1', '6', 'fuwu0', '分派工程师', '工程师姓名:钢铁侠<br>工程师电话:18565854698', '1545720499');
INSERT INTO `wja_work_order_log` VALUES ('50', '9', '20181225144722850558', '1', '7', '', '工程师接单', '', '1545720536');
INSERT INTO `wja_work_order_log` VALUES ('51', '9', '20181225144722850558', '1', '7', '', '工程师签到,服务开始', '', '1545720539');
INSERT INTO `wja_work_order_log` VALUES ('52', '9', '20181225144722850558', '1', '7', '', '确认完成', '', '1545720542');
INSERT INTO `wja_work_order_log` VALUES ('53', '10', '20181225144924647302', '0', '2', 'wanjiaan', '创建工单', '', '1545720564');
INSERT INTO `wja_work_order_log` VALUES ('54', '10', '20181225144924647302', '1', '6', 'fuwu0', '分派工程师', '工程师姓名:钢铁侠<br>工程师电话:18565854698', '1545720572');
INSERT INTO `wja_work_order_log` VALUES ('55', '10', '20181225144924647302', '1', '7', '', '工程师接单', '', '1545721021');
INSERT INTO `wja_work_order_log` VALUES ('56', '10', '20181225144924647302', '1', '7', '', '工程师签到,服务开始', '', '1545721024');
INSERT INTO `wja_work_order_log` VALUES ('57', '10', '20181225144924647302', '1', '7', '', '确认完成', '', '1545721028');
INSERT INTO `wja_work_order_log` VALUES ('58', '3', '20181221175000623647', '0', '0', '系统', '首次评价', '默认好评', '1545792666');
INSERT INTO `wja_work_order_log` VALUES ('59', '11', '20181228143954319892', '0', '23', '', '创建工单', '', '1545979194');
INSERT INTO `wja_work_order_log` VALUES ('60', '12', '20181228144125886407', '0', '23', '', '创建工单', '', '1545979285');
INSERT INTO `wja_work_order_log` VALUES ('61', '13', '20181228144440289402', '0', '23', '', '创建工单', '', '1545979480');
INSERT INTO `wja_work_order_log` VALUES ('62', '11', '20181228143954319892', '0', '23', '', '取消工单', '不需要安装了', '1545982214');
INSERT INTO `wja_work_order_log` VALUES ('63', '13', '20181228144440289402', '2', '6', 'fuwu0', '分派工程师', '工程师姓名:John<br>工程师电话:13714906176', '1545982390');
INSERT INTO `wja_work_order_log` VALUES ('64', '14', '20181228153702864305', '0', '23', '', '创建工单', '', '1545982622');
INSERT INTO `wja_work_order_log` VALUES ('65', '15', '20181228153721691411', '0', '23', '', '创建工单', '', '1545982641');
INSERT INTO `wja_work_order_log` VALUES ('66', '16', '20181228154258515323', '0', '23', '', '创建工单', '', '1545982978');
INSERT INTO `wja_work_order_log` VALUES ('67', '17', '20181228154711230760', '0', '23', '', '创建工单', '', '1545983231');
INSERT INTO `wja_work_order_log` VALUES ('68', '18', '20181228155336248806', '0', '23', '', '创建工单', '', '1545983616');
INSERT INTO `wja_work_order_log` VALUES ('69', '19', '20181228155820776778', '0', '23', '', '创建工单', '', '1545983900');
INSERT INTO `wja_work_order_log` VALUES ('70', '15', '20181228153721691411', '0', '23', '', '取消工单', '改为其他时间', '1545983988');
INSERT INTO `wja_work_order_log` VALUES ('71', '16', '20181228154258515323', '0', '23', '', '取消工单', '其他', '1545984007');
INSERT INTO `wja_work_order_log` VALUES ('72', '19', '20181228155820776778', '0', '23', '', '取消工单', '不需要安装了', '1545984016');
INSERT INTO `wja_work_order_log` VALUES ('73', '13', '20181228144440289402', '0', '23', '', '取消工单', '不需要安装了', '1545985175');
INSERT INTO `wja_work_order_log` VALUES ('74', '18', '20181228155336248806', '11', '6', 'fuwu0', '分派工程师', '工程师姓名:John001<br>工程师电话:13714906176', '1545985191');
INSERT INTO `wja_work_order_log` VALUES ('75', '18', '20181228155336248806', '11', '23', '', '工程师接单', '', '1545985205');
INSERT INTO `wja_work_order_log` VALUES ('76', '17', '20181228154711230760', '11', '6', 'fuwu0', '分派工程师', '工程师姓名:John001<br>工程师电话:13714906176', '1545985316');
INSERT INTO `wja_work_order_log` VALUES ('77', '14', '20181228153702864305', '11', '6', 'fuwu0', '分派工程师', '工程师姓名:John001<br>工程师电话:13714906176', '1545985327');
INSERT INTO `wja_work_order_log` VALUES ('78', '14', '20181228153702864305', '11', '23', '', '工程师接单', '', '1545985381');
INSERT INTO `wja_work_order_log` VALUES ('79', '18', '20181228155336248806', '11', '23', '', '工程师签到,服务开始', '', '1545985386');
INSERT INTO `wja_work_order_log` VALUES ('80', '14', '20181228153702864305', '0', '23', '', '取消工单', '其他', '1545985424');
INSERT INTO `wja_work_order_log` VALUES ('81', '18', '20181228155336248806', '11', '23', '', '确认完成', '', '1545985635');
INSERT INTO `wja_work_order_log` VALUES ('82', '20', '20181228171726082147', '0', '23', 'John001', '创建工单', '', '1545988646');
INSERT INTO `wja_work_order_log` VALUES ('83', '21', '20181228171936928524', '0', '23', 'John001', '创建工单', '', '1545988776');
INSERT INTO `wja_work_order_log` VALUES ('84', '21', '20181228171936928524', '11', '6', 'fuwu0', '分派工程师', '工程师姓名:John001<br>工程师电话:13714906176', '1545988809');
INSERT INTO `wja_work_order_log` VALUES ('85', '20', '20181228171726082147', '11', '6', 'fuwu0', '分派工程师', '工程师姓名:John001<br>工程师电话:13714906176', '1545988815');
INSERT INTO `wja_work_order_log` VALUES ('86', '17', '20181228154711230760', '11', '23', '', '工程师接单', '', '1545988925');
INSERT INTO `wja_work_order_log` VALUES ('87', '20', '20181228171726082147', '11', '23', '', '工程师接单', '', '1545989121');
INSERT INTO `wja_work_order_log` VALUES ('88', '17', '20181228154711230760', '11', '23', '', '工程师签到,服务开始', '', '1545989141');
INSERT INTO `wja_work_order_log` VALUES ('89', '22', '20181228174444402059', '0', '23', 'John001', '创建工单', '', '1545990284');
INSERT INTO `wja_work_order_log` VALUES ('90', '23', '20181228174859562645', '0', '23', 'John001', '创建工单', '', '1545990539');
INSERT INTO `wja_work_order_log` VALUES ('91', '12', '20181228144125886407', '0', '23', '', '取消工单', '改为其他时间', '1545990566');
INSERT INTO `wja_work_order_log` VALUES ('92', '24', '20181228175552540108', '0', '5', 'lingshou', '创建工单', '', '1545990952');
INSERT INTO `wja_work_order_log` VALUES ('93', '24', '20181228175552540108', '1', '6', 'fuwu0', '分派工程师', '工程师姓名:钢铁侠<br>工程师电话:18565854698', '1545991815');
INSERT INTO `wja_work_order_log` VALUES ('94', '24', '20181228175552540108', '1', '7', '', '工程师接单', '', '1545991863');
INSERT INTO `wja_work_order_log` VALUES ('95', '24', '20181228175552540108', '1', '7', '', '工程师签到,服务开始', '', '1545991866');
INSERT INTO `wja_work_order_log` VALUES ('96', '24', '20181228175552540108', '1', '7', '', '确认完成', '', '1545991869');
INSERT INTO `wja_work_order_log` VALUES ('97', '25', '20181228181259724322', '0', '2', 'wanjiaan', '创建工单', '', '1545991979');
INSERT INTO `wja_work_order_log` VALUES ('98', '25', '20181228181259724322', '1', '6', 'fuwu0', '分派工程师', '工程师姓名:钢铁侠<br>工程师电话:18565854698', '1545992007');
INSERT INTO `wja_work_order_log` VALUES ('99', '25', '20181228181259724322', '1', '7', '', '工程师接单', '', '1545992015');
INSERT INTO `wja_work_order_log` VALUES ('100', '25', '20181228181259724322', '1', '7', '', '工程师签到,服务开始', '', '1545992018');
INSERT INTO `wja_work_order_log` VALUES ('101', '25', '20181228181259724322', '1', '7', '', '确认完成', '', '1545992021');
INSERT INTO `wja_work_order_log` VALUES ('102', '26', '20181228181423913524', '0', '25', '', '创建工单', '', '1545992063');
INSERT INTO `wja_work_order_log` VALUES ('103', '27', '20181228184056972461', '0', '5', 'lingshou', '创建工单', '', '1545993656');
INSERT INTO `wja_work_order_log` VALUES ('104', '28', '20181228184337471804', '0', '5', 'lingshou', '创建工单', '', '1545993817');
INSERT INTO `wja_work_order_log` VALUES ('105', '29', '20181229091242611061', '0', '23', 'John001', '创建工单', '', '1546045962');
INSERT INTO `wja_work_order_log` VALUES ('106', '30', '20181229100318281360', '0', '5', 'lingshou', '创建工单', '', '1546048998');
INSERT INTO `wja_work_order_log` VALUES ('107', '30', '20181229100318281360', '1', '6', 'fuwu0', '分派工程师', '工程师姓名:钢铁侠<br>工程师电话:18565854698', '1546049182');
INSERT INTO `wja_work_order_log` VALUES ('108', '30', '20181229100318281360', '1', '7', '', '工程师接单', '', '1546049201');
INSERT INTO `wja_work_order_log` VALUES ('109', '30', '20181229100318281360', '1', '7', '', '工程师签到,服务开始', '', '1546049205');
INSERT INTO `wja_work_order_log` VALUES ('110', '30', '20181229100318281360', '1', '7', '', '确认完成', '', '1546049211');
INSERT INTO `wja_work_order_log` VALUES ('111', '31', '20181229100825841208', '0', '2', 'wanjiaan', '创建工单', '', '1546049305');
INSERT INTO `wja_work_order_log` VALUES ('112', '31', '20181229100825841208', '1', '6', 'fuwu0', '分派工程师', '工程师姓名:钢铁侠<br>工程师电话:18565854698', '1546049432');
INSERT INTO `wja_work_order_log` VALUES ('113', '31', '20181229100825841208', '1', '7', '', '工程师接单', '', '1546049600');
INSERT INTO `wja_work_order_log` VALUES ('114', '31', '20181229100825841208', '1', '7', '', '工程师签到,服务开始', '', '1546049604');
INSERT INTO `wja_work_order_log` VALUES ('115', '31', '20181229100825841208', '1', '7', '', '确认完成', '', '1546049607');
INSERT INTO `wja_work_order_log` VALUES ('116', '18', '20181228155336248806', '0', '23', '', '首次评价', '', '1546053815');
INSERT INTO `wja_work_order_log` VALUES ('117', '17', '20181228154711230760', '11', '23', '', '确认完成', '', '1546053952');
INSERT INTO `wja_work_order_log` VALUES ('118', '17', '20181228154711230760', '0', '23', '', '首次评价', '哈哈哈9999966666', '1546054019');
INSERT INTO `wja_work_order_log` VALUES ('119', '20', '20181228171726082147', '11', '23', '', '工程师签到,服务开始', '', '1546054209');
INSERT INTO `wja_work_order_log` VALUES ('120', '20', '20181228171726082147', '11', '23', '', '确认完成', '', '1546054222');
INSERT INTO `wja_work_order_log` VALUES ('121', '20', '20181228171726082147', '0', '23', '', '首次评价', '', '1546054527');
INSERT INTO `wja_work_order_log` VALUES ('122', '17', '20181228154711230760', '0', '23', '', '首次评价', '', '1546062774');
INSERT INTO `wja_work_order_log` VALUES ('123', '18', '20181228155336248806', '0', '23', '', '首次评价', '', '1546063085');
INSERT INTO `wja_work_order_log` VALUES ('124', '21', '20181228171936928524', '11', '23', '', '工程师接单', '', '1546063282');
INSERT INTO `wja_work_order_log` VALUES ('125', '21', '20181228171936928524', '11', '23', '', '工程师签到,服务开始', '', '1546063289');
INSERT INTO `wja_work_order_log` VALUES ('126', '21', '20181228171936928524', '11', '23', '', '确认完成', '', '1546063325');
INSERT INTO `wja_work_order_log` VALUES ('127', '31', '20181229100825841208', '0', '2', 'wanjiaan', '首次评价', '', '1546064033');
INSERT INTO `wja_work_order_log` VALUES ('128', '21', '20181228171936928524', '0', '23', '', '首次评价', 'zhengahi=dweqweqweqwe', '1546065297');
INSERT INTO `wja_work_order_log` VALUES ('129', '21', '20181228171936928524', '0', '23', '', '首次评价', 'dddddd', '1546065318');
INSERT INTO `wja_work_order_log` VALUES ('130', '20', '20181228171726082147', '0', '23', '', '首次评价', '我啦啦啦啦啦啦啦啦啦啦啦啦啦', '1546065441');
INSERT INTO `wja_work_order_log` VALUES ('131', '29', '20181229091242611061', '11', '6', 'fuwu0', '分派工程师', '工程师姓名:John001<br>工程师电话:13714906176', '1546066276');
INSERT INTO `wja_work_order_log` VALUES ('132', '29', '20181229091242611061', '11', '23', '', '工程师接单', '', '1546066287');
INSERT INTO `wja_work_order_log` VALUES ('133', '29', '20181229091242611061', '11', '23', '', '工程师签到,服务开始', '', '1546066305');
INSERT INTO `wja_work_order_log` VALUES ('134', '29', '20181229091242611061', '11', '23', '', '确认完成', '', '1546066327');
INSERT INTO `wja_work_order_log` VALUES ('135', '29', '20181229091242611061', '0', '23', '', '首次评价', '', '1546066364');
INSERT INTO `wja_work_order_log` VALUES ('136', '28', '20181228184337471804', '11', '6', 'fuwu0', '分派工程师', '工程师姓名:John001<br>工程师电话:13714906176', '1546066694');
INSERT INTO `wja_work_order_log` VALUES ('137', '22', '20181228174444402059', '11', '6', 'fuwu0', '分派工程师', '工程师姓名:John001<br>工程师电话:13714906176', '1546066766');
INSERT INTO `wja_work_order_log` VALUES ('138', '22', '20181228174444402059', '11', '23', '', '工程师接单', '', '1546066797');
INSERT INTO `wja_work_order_log` VALUES ('139', '22', '20181228174444402059', '11', '23', '', '工程师签到,服务开始', '', '1546066805');
INSERT INTO `wja_work_order_log` VALUES ('140', '32', '20181229152023523293', '0', '25', '', '创建工单', '', '1546068023');
INSERT INTO `wja_work_order_log` VALUES ('141', '26', '20181228181423913524', '1', '6', 'fuwu0', '分派工程师', '工程师姓名:钢铁侠<br>工程师电话:18565854698', '1546068114');
INSERT INTO `wja_work_order_log` VALUES ('142', '26', '20181228181423913524', '1', '7', '', '工程师接单', '', '1546068128');
INSERT INTO `wja_work_order_log` VALUES ('143', '26', '20181228181423913524', '1', '7', '', '工程师签到,服务开始', '', '1546068144');
INSERT INTO `wja_work_order_log` VALUES ('144', '26', '20181228181423913524', '1', '7', '', '确认完成', '', '1546068173');
INSERT INTO `wja_work_order_log` VALUES ('145', '26', '20181228181423913524', '0', '25', '', '首次评价', '服务不好', '1546068197');
INSERT INTO `wja_work_order_log` VALUES ('146', '26', '20181228181423913524', '0', '25', '', '首次评价', '师傅已经跑了', '1546068212');
INSERT INTO `wja_work_order_log` VALUES ('147', '32', '20181229152023523293', '1', '6', 'fuwu0', '分派工程师', '工程师姓名:钢铁侠<br>工程师电话:18565854698', '1546068378');
INSERT INTO `wja_work_order_log` VALUES ('148', '32', '20181229152023523293', '1', '7', '', '工程师拒绝接单', '我没时间', '1546068386');
INSERT INTO `wja_work_order_log` VALUES ('149', '32', '20181229152023523293', '12', '6', 'fuwu0', '分派工程师', '工程师姓名:孟德<br>工程师电话:15118815476', '1546068394');
INSERT INTO `wja_work_order_log` VALUES ('150', '32', '20181229152023523293', '12', '19', '', '工程师拒绝接单', '我没时间', '1546068473');
INSERT INTO `wja_work_order_log` VALUES ('151', '32', '20181229152023523293', '12', '6', 'fuwu0', '分派工程师', '工程师姓名:孟德<br>工程师电话:15118815476', '1546068488');
INSERT INTO `wja_work_order_log` VALUES ('152', '32', '20181229152023523293', '12', '19', '', '工程师接单', '', '1546068564');
INSERT INTO `wja_work_order_log` VALUES ('153', '32', '20181229152023523293', '12', '19', '', '工程师签到,服务开始', '', '1546068569');
INSERT INTO `wja_work_order_log` VALUES ('154', '33', '20181229153810861377', '0', '7', '钢铁侠', '创建工单', '', '1546069090');
INSERT INTO `wja_work_order_log` VALUES ('155', '33', '20181229153810861377', '12', '6', 'fuwu0', '分派工程师', '工程师姓名:孟德<br>工程师电话:15118815476', '1546069104');
INSERT INTO `wja_work_order_log` VALUES ('156', '33', '20181229153810861377', '12', '19', '', '工程师接单', '', '1546069136');
INSERT INTO `wja_work_order_log` VALUES ('157', '33', '20181229153810861377', '12', '19', '', '工程师签到,服务开始', '', '1546069196');
INSERT INTO `wja_work_order_log` VALUES ('158', '32', '20181229152023523293', '12', '19', '', '确认完成', '', '1546069215');
INSERT INTO `wja_work_order_log` VALUES ('159', '33', '20181229153810861377', '12', '19', '', '确认完成', '', '1546069219');
INSERT INTO `wja_work_order_log` VALUES ('160', '33', '20181229153810861377', '0', '7', '', '首次评价', '师傅没来', '1546069245');
INSERT INTO `wja_work_order_log` VALUES ('161', '33', '20181229153810861377', '0', '7', '', '首次评价', '没来', '1546069256');
INSERT INTO `wja_work_order_log` VALUES ('162', '34', '20181229154339504688', '0', '7', '钢铁侠', '创建工单', '', '1546069419');
INSERT INTO `wja_work_order_log` VALUES ('163', '34', '20181229154339504688', '12', '6', 'fuwu0', '分派工程师', '工程师姓名:孟德<br>工程师电话:15118815476', '1546069432');
INSERT INTO `wja_work_order_log` VALUES ('164', '34', '20181229154339504688', '12', '19', '', '工程师接单', '', '1546069535');
INSERT INTO `wja_work_order_log` VALUES ('165', '34', '20181229154339504688', '0', '7', '', '取消工单', '不需要安装了', '1546069555');
INSERT INTO `wja_work_order_log` VALUES ('166', '35', '20181229154728084640', '0', '7', '钢铁侠', '创建工单', '', '1546069648');
INSERT INTO `wja_work_order_log` VALUES ('167', '35', '20181229154728084640', '12', '6', 'fuwu0', '分派工程师', '工程师姓名:孟德<br>工程师电话:15118815476', '1546069662');
INSERT INTO `wja_work_order_log` VALUES ('168', '35', '20181229154728084640', '12', '19', '', '工程师接单', '', '1546069675');
INSERT INTO `wja_work_order_log` VALUES ('169', '35', '20181229154728084640', '12', '19', '', '工程师签到,服务开始', '', '1546069680');
INSERT INTO `wja_work_order_log` VALUES ('170', '35', '20181229154728084640', '12', '19', '', '确认完成', '', '1546069695');
INSERT INTO `wja_work_order_log` VALUES ('171', '35', '20181229154728084640', '0', '7', '', '首次评价', '不会修', '1546069711');
INSERT INTO `wja_work_order_log` VALUES ('172', '35', '20181229154728084640', '0', '7', '', '首次评价', '不会修', '1546069720');
INSERT INTO `wja_work_order_log` VALUES ('173', '36', '20181229160148037404', '0', '7', '钢铁侠', '创建工单', '', '1546070508');
INSERT INTO `wja_work_order_log` VALUES ('174', '36', '20181229160148037404', '12', '6', 'fuwu0', '分派工程师', '工程师姓名:孟德<br>工程师电话:15118815476', '1546070519');
INSERT INTO `wja_work_order_log` VALUES ('175', '36', '20181229160148037404', '12', '19', '', '工程师拒绝接单', '其他', '1546070528');
INSERT INTO `wja_work_order_log` VALUES ('176', '36', '20181229160148037404', '12', '6', 'fuwu0', '分派工程师', '工程师姓名:孟德<br>工程师电话:15118815476', '1546070543');
INSERT INTO `wja_work_order_log` VALUES ('177', '36', '20181229160148037404', '12', '19', '', '工程师拒绝接单', '我没时间', '1546070550');
INSERT INTO `wja_work_order_log` VALUES ('178', '36', '20181229160148037404', '12', '6', 'fuwu0', '分派工程师', '工程师姓名:孟德<br>工程师电话:15118815476', '1546070557');
INSERT INTO `wja_work_order_log` VALUES ('179', '36', '20181229160148037404', '12', '19', '', '工程师接单', '', '1546070567');
INSERT INTO `wja_work_order_log` VALUES ('180', '36', '20181229160148037404', '12', '19', '', '工程师签到,服务开始', '', '1546070571');
INSERT INTO `wja_work_order_log` VALUES ('181', '36', '20181229160148037404', '12', '19', '', '确认完成', '', '1546070585');
INSERT INTO `wja_work_order_log` VALUES ('182', '37', '20181229160432889813', '0', '7', '钢铁侠', '创建工单', '', '1546070672');
INSERT INTO `wja_work_order_log` VALUES ('183', '37', '20181229160432889813', '12', '6', 'fuwu0', '分派工程师', '工程师姓名:孟德<br>工程师电话:15118815476', '1546070686');
INSERT INTO `wja_work_order_log` VALUES ('184', '37', '20181229160432889813', '12', '19', '', '工程师接单', '', '1546070706');
INSERT INTO `wja_work_order_log` VALUES ('185', '37', '20181229160432889813', '12', '19', '', '工程师签到,服务开始', '', '1546070720');
INSERT INTO `wja_work_order_log` VALUES ('186', '37', '20181229160432889813', '12', '19', '', '确认完成', '', '1546070724');

-- ----------------------------
-- Table structure for wja_work_order_user_record
-- ----------------------------
DROP TABLE IF EXISTS `wja_work_order_user_record`;
CREATE TABLE `wja_work_order_user_record` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `worder_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '订单ID',
  `worder_sn` varchar(255) NOT NULL DEFAULT '' COMMENT '订单号',
  `user_id` int(10) NOT NULL COMMENT '工程师ID',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`log_id`),
  KEY `worder_id` (`worder_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of wja_work_order_user_record
-- ----------------------------
