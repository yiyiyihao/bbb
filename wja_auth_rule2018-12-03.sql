/*
 Navicat MySQL Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50723
 Source Host           : localhost:3306
 Source Schema         : wanjiaan_temp

 Target Server Type    : MySQL
 Target Server Version : 50723
 File Encoding         : 65001

 Date: 03/12/2018 11:53:07
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for wja_auth_rule
-- ----------------------------
DROP TABLE IF EXISTS `wja_auth_rule`;
CREATE TABLE `wja_auth_rule`  (
  `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '权限节点类型 1 管理员操作节点配置 2 厂商操作节点配置 3 渠道商操作节点配置 4 服务商操作节点配置 5 经销商操作节点配置',
  `module` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'module节点',
  `controller` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'controller节点',
  `action` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'action节点',
  `title` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '节点名称',
  `icon` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '样式',
  `parent_id` int(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父栏目ID',
  `authopen` tinyint(2) NOT NULL DEFAULT 1 COMMENT '开启权限验证',
  `sort_order` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `menustatus` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1,
  `add_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '添加时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '修改时间',
  `is_del` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '权限节点' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wja_auth_rule
-- ----------------------------
INSERT INTO `wja_auth_rule` VALUES (1, 1, 'admin', '', '', '平台操作权限', '', 0, 1, 10, 1, 1, 1543802558, 1543802578, 0);
INSERT INTO `wja_auth_rule` VALUES (2, 1, 'factory', '', '', '厂商管理权限', '', 0, 1, 20, 1, 1, 1543802607, 1543802617, 0);
INSERT INTO `wja_auth_rule` VALUES (3, 1, 'admin', 'index', '', '后台登录', 'home', 1, 1, 10, 1, 1, 1543802677, 1543802727, 0);
INSERT INTO `wja_auth_rule` VALUES (4, 1, 'admin', 'index', 'home', '后台首页', '', 3, 1, 20, 1, 1, 1543802716, 1543802716, 0);
INSERT INTO `wja_auth_rule` VALUES (5, 1, 'factory', 'index', '', '后台登录', 'home', 2, 1, 20, 1, 1, 1543804363, 1543804415, 0);
INSERT INTO `wja_auth_rule` VALUES (6, 1, 'factory', 'index', 'home', '后台首页', '', 5, 1, 30, 1, 1, 1543804391, 1543804399, 0);
INSERT INTO `wja_auth_rule` VALUES (7, 1, 'factory', '', '', '系统配置', 'setting', 2, 1, 30, 1, 1, 1543807532, 1543807615, 0);
INSERT INTO `wja_auth_rule` VALUES (8, 1, 'factory', 'system', 'grant', '权限配置', '', 7, 1, 10, 1, 1, 1543807604, 1543807604, 0);
INSERT INTO `wja_auth_rule` VALUES (9, 1, 'factory', 'user', 'index', '账户管理', '', 7, 1, 20, 1, 1, 1543807654, 1543807654, 0);
INSERT INTO `wja_auth_rule` VALUES (10, 1, 'factory', 'system', 'factory', '参数配置', '', 7, 1, 30, 1, 1, 1543807714, 1543807714, 0);
INSERT INTO `wja_auth_rule` VALUES (11, 1, 'factory', 'system', 'servicer', '服务商配置', '', 7, 1, 40, 1, 1, 1543807754, 1543807754, 0);
INSERT INTO `wja_auth_rule` VALUES (12, 1, 'factory', 'goods', '', '产品管理', 'tips', 2, 1, 40, 1, 1, 1543808011, 1543808011, 0);
INSERT INTO `wja_auth_rule` VALUES (13, 1, 'factory', 'goods', 'index', '产品列表', '', 12, 1, 10, 1, 1, 1543808047, 1543808047, 0);
INSERT INTO `wja_auth_rule` VALUES (14, 1, 'factory', 'merchant', '', '商户管理', 'user-setting', 2, 1, 50, 1, 1, 1543808090, 1543808157, 0);
INSERT INTO `wja_auth_rule` VALUES (15, 1, 'finance', '', '', '财务管理', 'ticket-list', 2, 1, 60, 1, 1, 1543808132, 1543808132, 0);

SET FOREIGN_KEY_CHECKS = 1;
