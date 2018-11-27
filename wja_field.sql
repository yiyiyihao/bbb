/*
 Navicat MySQL Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50723
 Source Host           : localhost:3306
 Source Schema         : wanjiaan

 Target Server Type    : MySQL
 Target Server Version : 50723
 File Encoding         : 65001

 Date: 27/11/2018 16:24:03
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for wja_field
-- ----------------------------
DROP TABLE IF EXISTS `wja_field`;
CREATE TABLE `wja_field`  (
  `field_id` int(10) NOT NULL AUTO_INCREMENT,
  `model_id` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '对应model表主键',
  `field` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对应数据字段',
  `title` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '显示标题',
  `notemsg` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '字段文字描述',
  `type` tinyint(1) UNSIGNED NULL DEFAULT 1 COMMENT '数据类型 1 文本 2 文本域 3 单选 4 复选 5 选择菜单 6 图片上传 7 编辑器',
  `type_extend` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '相同数据类似的扩展类型,如数字/货币/邮箱/URL/日期/内容去重 等格式验证，(去重考虑基本去重和严格去重，基本去重指比方说厂商下的信息 基本去重，严格去重指平台内相对数据严格去重)',
  `datatype` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '字段验证规则',
  `nullmsg` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '非空字段显示的空内容提醒',
  `errormsg` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '验证错误提醒',
  `size` tinyint(1) UNSIGNED NULL DEFAULT NULL COMMENT '字段长度（text/textarea类型有效）',
  `default` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '默认值配置（json格式）',
  `value` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '字段可用参数配置（json格式）',
  `variable` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来自control赋值的变量名称',
  `sort_order` tinyint(1) UNSIGNED NULL DEFAULT 255,
  `status` tinyint(1) UNSIGNED NULL DEFAULT 1,
  `is_del` tinyint(1) UNSIGNED NULL DEFAULT 0,
  `add_time` int(13) UNSIGNED NULL DEFAULT NULL,
  `update_time` int(13) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`field_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wja_field
-- ----------------------------
INSERT INTO `wja_field` VALUES (1, '1', 'parent_id', '上级节点', '顶级节点请留空,其它上级节点请慎重选择', 5, 'select', '', '', '', 0, '==顶级节点==', '', 'rulelist', 255, 1, 0, 1543287116, 1543287116);
INSERT INTO `wja_field` VALUES (2, '1', 'title', '权限名称', '请填写权限节点名称', 1, 'text', '*', '权限节点名称不能为空', '权限节点名称填写错误', 20, '', '', '', 255, 1, 0, 1543287314, 1543287314);
INSERT INTO `wja_field` VALUES (3, '1', 'module', '权限模块', '请填写权限节点操作module,留空默认admin', 1, 'text', '', '', '', 20, '', '', '', 255, 1, 0, 1543287496, 1543287496);
INSERT INTO `wja_field` VALUES (4, '1', 'controller', '权限控制器', '请填写权限节点操作控制器', 1, 'text', '', '', '', 20, '', '', '', 255, 1, 0, 1543287550, 1543287550);
INSERT INTO `wja_field` VALUES (5, '1', 'action', '权限操作', '请填写权限节点操作行为', 1, 'text', '', '', '', 20, '', '', '', 255, 1, 0, 1543287598, 1543287598);
INSERT INTO `wja_field` VALUES (6, '1', 'icon', '菜单图标', '请填写图标名称class 示例：icon-home，请填写home', 1, 'text', '', '', '', 20, '', '', '', 255, 1, 0, 1543287666, 1543287666);
INSERT INTO `wja_field` VALUES (7, '1', 'status', '节点状态', '', 3, '', '', '', '', 0, '1', '可用|1\r\n禁用|0', '', 255, 1, 0, 1543287841, 1543287841);
INSERT INTO `wja_field` VALUES (8, '1', 'authopen', '权限状态', '', 3, '', '', '', '', 0, '1', '开启|1\r\n关闭|0', '', 255, 1, 0, 1543287919, 1543287919);
INSERT INTO `wja_field` VALUES (9, '1', 'menustatus', '显示状态', '', 3, '', '', '', '', 0, '1', '开启|1\r\n关闭|0', '', 255, 1, 0, 1543287968, 1543287968);
INSERT INTO `wja_field` VALUES (10, '1', 'sort_order', '排序', '', 1, 'text', '', '', '', 20, '255', '', '', 255, 1, 0, 1543288003, 1543288003);

-- ----------------------------
-- Table structure for wja_model
-- ----------------------------
DROP TABLE IF EXISTS `wja_model`;
CREATE TABLE `wja_model`  (
  `model_id` int(10) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `name` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '数据表名称',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '数据表描述',
  `status` tinyint(1) UNSIGNED NULL DEFAULT 1,
  `is_del` tinyint(1) UNSIGNED NULL DEFAULT 0,
  `sort_order` tinyint(1) UNSIGNED NULL DEFAULT NULL,
  `add_time` int(13) UNSIGNED NULL DEFAULT NULL,
  `update_time` int(13) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`model_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wja_model
-- ----------------------------
INSERT INTO `wja_model` VALUES (1, '权限管理', 'auth_rule', '', 1, 0, NULL, 1543225261, 1543225261);

SET FOREIGN_KEY_CHECKS = 1;
