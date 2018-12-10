/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50721
Source Host           : localhost:3306
Source Database       : wanjiaan

Target Server Type    : MYSQL
Target Server Version : 50721
File Encoding         : 65001

Date: 2018-12-10 10:07:33
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
) ENGINE=MyISAM AUTO_INCREMENT=104 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='权限节点';

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
INSERT INTO `wja_auth_rule` VALUES ('75', '1', 'factory', 'order', 'updateprice', '调整订单金额', '', '70', '1', '14', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('76', '1', 'factory', 'order', 'delivery', '订单商品发货', '', '70', '1', '15', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('77', '1', 'factory', 'order', 'deliverylogs', '查看发货物流', '', '70', '1', '16', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('78', '1', 'factory', 'order', 'finish', '确认完成', '', '70', '1', '17', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('79', '1', 'factory', 'channel', 'manager', '渠道商管理员设置', '', '14', '1', '14', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('80', '1', 'factory', 'dealer', 'manager', '零售商管理员设置', '', '14', '1', '24', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('81', '1', 'factory', 'servicer', 'manager', '服务商管理员设置', '', '14', '1', '34', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('82', '1', 'factory', 'suborder', 'index', '零售商订单', '', '60', '1', '30', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('83', '1', 'factory', 'message', 'index', '系统消息管理', '', '7', '1', '10', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('84', '1', 'factory', 'message', 'add', '新增系统消息', '', '7', '1', '11', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('85', '1', 'factory', 'message', 'edit', '编辑系统消息', '', '7', '1', '12', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('86', '1', 'factory', 'message', 'publish', '发布系统消息', '', '7', '1', '13', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('87', '1', 'factory', 'message', 'del', '删除系统消息', '', '7', '1', '14', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('88', '1', 'factory', 'commission', 'index', '收益明细', '', '15', '1', '20', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('89', '1', 'admin', 'assess', 'index', '评价系统配置', '', '33', '1', '20', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('90', '1', 'factory', 'suborder', 'detail', '零售商订单查看', '', '60', '1', '40', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('91', '1', 'admin', 'system', 'default', '默认数据配置', '', '33', '1', '30', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('92', '1', 'factory', 'finance', 'setting', '提现设置', '', '15', '1', '30', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('93', '1', 'factory', 'finance', 'apply', '申请提现', '', '15', '1', '60', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('94', '1', 'factory', 'finance', 'securitys', '保证金列表', '', '15', '1', '40', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('95', '1', 'factory', 'order', 'finance', '财务订单', '', '15', '1', '50', '1', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('96', '1', 'factory', 'user', 'add', '新增账户', '', '7', '1', '50', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('97', '1', 'factory', 'user', 'edit', '编辑账户', '', '7', '1', '50', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('98', '1', 'factory', 'user', 'del', '删除账户', '', '7', '1', '50', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('99', '1', 'factory', 'finance', 'check', '提现审核', '', '15', '1', '60', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('100', '1', 'factory', 'installer', 'check', '审核', '', '16', '1', '60', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('101', '1', 'factory', 'worder', 'dispatch', '分派工单', '', '17', '1', '14', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('102', '1', 'factory', 'worder', 'detail', '工单详情', '', '17', '1', '15', '0', '1', '1543974007', '1543974007', '0');
INSERT INTO `wja_auth_rule` VALUES ('103', '1', 'factory', 'worder', 'cancel', '取消工单', '', '17', '1', '16', '0', '1', '1543974007', '1543974007', '0');

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
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

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
) ENGINE=MyISAM AUTO_INCREMENT=78 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

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
INSERT INTO `wja_form_table` VALUES ('43', '8', 'phone', '联系电话', '150', '1', null, '', '40', '1', '0', '0', '0', '1544148200', '1544257170');
INSERT INTO `wja_form_table` VALUES ('44', '8', 'username', '管理员账号', '100', '1', null, '', '90', '1', '0', '0', '0', '1544148223', '1544148223');
INSERT INTO `wja_form_table` VALUES ('45', '9', '', '编号', '60', '3', null, '', '10', '1', '0', '0', '0', '1544148337', '1544148337');
INSERT INTO `wja_form_table` VALUES ('46', '9', 'name', '零售商名称', '*', '1', null, '', '20', '1', '0', '0', '0', '1544148370', '1544148370');
INSERT INTO `wja_form_table` VALUES ('47', '9', 'cname', '所属渠道', '*', '1', null, '', '30', '1', '0', '0', '0', '1544148442', '1544148442');
INSERT INTO `wja_form_table` VALUES ('48', '8', 'sname', '所属厂商', '*', '1', null, '', '15', '1', '0', '0', '0', '1544148510', '1544148510');
INSERT INTO `wja_form_table` VALUES ('49', '9', 'sname', '所属厂商', '*', '1', null, '', '25', '1', '0', '0', '0', '1544148663', '1544148663');
INSERT INTO `wja_form_table` VALUES ('50', '9', 'user_name', '联系人姓名', '100', '1', null, '', '50', '1', '0', '0', '0', '1544148759', '1544148759');
INSERT INTO `wja_form_table` VALUES ('51', '9', 'phone', '联系电话', '150', '1', null, '', '60', '1', '0', '0', '0', '1544148785', '1544148785');
INSERT INTO `wja_form_table` VALUES ('52', '9', 'username', '管理员账号', '100', '1', null, '', '70', '1', '0', '0', '0', '1544148823', '1544148823');
INSERT INTO `wja_form_table` VALUES ('53', '10', '', '编号', '60', '3', null, '', '10', '1', '0', '0', '0', '1544148997', '1544148997');
INSERT INTO `wja_form_table` VALUES ('54', '10', 'name', '服务商名称', '*', '1', null, '', '20', '1', '0', '0', '0', '1544149017', '1544149017');
INSERT INTO `wja_form_table` VALUES ('55', '10', 'sname', '所属厂商', '*', '1', null, '', '30', '1', '0', '0', '0', '1544149033', '1544149033');
INSERT INTO `wja_form_table` VALUES ('56', '10', 'user_name', '联系人姓名', '100', '1', null, '', '40', '1', '0', '0', '0', '1544149061', '1544149061');
INSERT INTO `wja_form_table` VALUES ('57', '10', 'phone', '联系电话', '150', '1', null, '', '50', '1', '0', '0', '0', '1544149082', '1544149082');
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
