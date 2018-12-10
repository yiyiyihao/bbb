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

 Date: 07/12/2018 10:59:53
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for wja_form_field
-- ----------------------------
DROP TABLE IF EXISTS `wja_form_field`;
CREATE TABLE `wja_form_field`  (
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
) ENGINE = MyISAM AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wja_form_field
-- ----------------------------
INSERT INTO `wja_form_field` VALUES (1, '1', 'parent_id', '上级节点', '顶级节点请留空,其它上级节点请慎重选择', 5, 'select', '', '', '', 0, '==顶级节点==', '', 'rulelist', 255, 1, 0, 1543287116, 1543287116);
INSERT INTO `wja_form_field` VALUES (2, '1', 'title', '权限名称', '请填写权限节点名称', 1, 'text', '*', '权限节点名称不能为空', '权限节点名称填写错误', 20, '', '', '', 255, 1, 0, 1543287314, 1543287314);
INSERT INTO `wja_form_field` VALUES (3, '1', 'module', '权限模块', '请填写权限节点操作module,留空默认admin', 1, 'text', '', '', '', 20, '', '', '', 255, 1, 0, 1543287496, 1543287496);
INSERT INTO `wja_form_field` VALUES (4, '1', 'controller', '权限控制器', '请填写权限节点操作控制器', 1, 'text', '', '', '', 20, '', '', '', 255, 1, 0, 1543287550, 1543287550);
INSERT INTO `wja_form_field` VALUES (5, '1', 'action', '权限操作', '请填写权限节点操作行为', 1, 'text', '', '', '', 20, '', '', '', 255, 1, 0, 1543287598, 1543287598);
INSERT INTO `wja_form_field` VALUES (6, '1', 'icon', '菜单图标', '请填写图标名称class 示例：icon-home，请填写home', 1, 'text', '', '', '', 20, '', '', '', 255, 1, 0, 1543287666, 1543287666);
INSERT INTO `wja_form_field` VALUES (7, '1', 'status', '节点状态', '', 3, '', '', '', '', 0, '1', '可用|1\r\n禁用|0', '', 255, 1, 0, 1543287841, 1543287841);
INSERT INTO `wja_form_field` VALUES (8, '1', 'authopen', '权限状态', '', 3, '', '', '', '', 0, '1', '开启|1\r\n关闭|0', '', 255, 1, 0, 1543287919, 1543287919);
INSERT INTO `wja_form_field` VALUES (9, '1', 'menustatus', '显示状态', '', 3, '', '', '', '', 0, '1', '开启|1\r\n关闭|0', '', 255, 1, 0, 1543287968, 1543287968);
INSERT INTO `wja_form_field` VALUES (10, '1', 'sort_order', '排序', '', 1, 'text', '', '', '', 20, '255', '', '', 255, 1, 0, 1543288003, 1543288003);
INSERT INTO `wja_form_field` VALUES (12, '3', 'name', '角色名称', '角色名称请不要填写特殊字符', 1, 'text', '*', '角色名称不能为空', '角色名称填写错误', 40, '', '', '', 10, 1, 0, 1544097814, 1544097814);
INSERT INTO `wja_form_field` VALUES (13, '3', 'group_type', '角色分组', '平台角色请选择平台角色,其它角色请选择厂商角色', 3, 'select', '*', '', '', 0, '1', '平台角色|1\r\n厂商角色|2', '', 20, 1, 0, 1544097959, 1544097991);
INSERT INTO `wja_form_field` VALUES (14, '3', 'status', '角色状态', '禁用后角色将不可用', 3, '', '', '', '', 0, '1', '可用|1\r\n禁用|0', '', 30, 1, 0, 1544098196, 1544098196);
INSERT INTO `wja_form_field` VALUES (15, '3', 'sort_order', '排序', '', 1, 'text', '', '', '', 20, '255', '', '', 40, 1, 0, 1544098239, 1544098239);

-- ----------------------------
-- Table structure for wja_form_model
-- ----------------------------
DROP TABLE IF EXISTS `wja_form_model`;
CREATE TABLE `wja_form_model`  (
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
) ENGINE = MyISAM AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wja_form_model
-- ----------------------------
INSERT INTO `wja_form_model` VALUES (1, '权限管理', 'auth_rule', '', 1, 0, NULL, 1543225261, 1543225261);
INSERT INTO `wja_form_model` VALUES (2, '厂商管理', 'store_factory', '', 1, 0, NULL, 1544069639, 1544069639);
INSERT INTO `wja_form_model` VALUES (3, '角色管理', 'user_group', '', 1, 0, NULL, 1544096207, 1544096207);
INSERT INTO `wja_form_model` VALUES (4, '用户管理', 'user', '', 1, 0, NULL, 1544098575, 1544098575);
INSERT INTO `wja_form_model` VALUES (5, '商品管理', 'goods', '', 1, 0, NULL, 1544099050, 1544099050);
INSERT INTO `wja_form_model` VALUES (6, '商品分类', 'goods_cate', '', 1, 0, NULL, 1544146973, 1544146973);
INSERT INTO `wja_form_model` VALUES (7, '商品规格', 'goods_spec', '', 1, 0, NULL, 1544147492, 1544147492);
INSERT INTO `wja_form_model` VALUES (8, '渠道管理', 'store_channel', '', 1, 0, NULL, 1544147751, 1544147751);
INSERT INTO `wja_form_model` VALUES (9, '零售商管理', 'store_dealer', '', 1, 0, NULL, 1544148310, 1544148310);
INSERT INTO `wja_form_model` VALUES (10, '服务商管理', 'store_servicer', '', 1, 0, NULL, 1544148899, 1544148899);
INSERT INTO `wja_form_model` VALUES (11, '安装员管理', 'user_installer', '', 1, 0, NULL, 1544149645, 1544149645);
INSERT INTO `wja_form_model` VALUES (12, '返佣明细表', 'commission', '', 1, 0, NULL, 1544100306, 1544100306);

-- ----------------------------
-- Table structure for wja_form_table
-- ----------------------------
DROP TABLE IF EXISTS `wja_form_table`;
CREATE TABLE `wja_form_table`  (
  `table_id` int(10) NOT NULL AUTO_INCREMENT,
  `model_id` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '对应model表主键',
  `field` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对应数据字段',
  `title` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '显示标题',
  `width` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '显示宽度',
  `type` tinyint(1) UNSIGNED NULL DEFAULT 1 COMMENT '数据类型 1 文本 2 图标 3 单选 4 状态值 5 操作列表',
  `value` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '字段可用参数配置',
  `function` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '字符需函数处理的函数名称',
  `sort_order` tinyint(1) UNSIGNED NULL DEFAULT 255,
  `status` tinyint(1) UNSIGNED NULL DEFAULT 1,
  `is_edit` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否支持点击编辑',
  `is_sort` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否支持键值排序',
  `is_del` tinyint(1) UNSIGNED NULL DEFAULT 0,
  `add_time` int(13) UNSIGNED NULL DEFAULT NULL,
  `update_time` int(13) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 74 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wja_form_table
-- ----------------------------
INSERT INTO `wja_form_table` VALUES (1, '1', '', '编号', '60', 3, '', '', 10, 1, 0, 0, 0, 1544012686, 1544013483);
INSERT INTO `wja_form_table` VALUES (2, '1', 'icon', '图标', '50', 4, 'icon', '', 20, 1, 0, 0, 0, 1544012981, 1544013469);
INSERT INTO `wja_form_table` VALUES (3, '1', 'cname', '节点名称', '*', 1, NULL, '', 30, 1, 0, 0, 0, 1544061627, 1544061627);
INSERT INTO `wja_form_table` VALUES (4, '1', 'module', '权限归属', '100', 1, NULL, '', 40, 1, 0, 0, 0, 1544061680, 1544061680);
INSERT INTO `wja_form_table` VALUES (5, '1', 'href', '操作地址', '*', 1, NULL, '', 50, 1, 0, 0, 0, 1544061750, 1544061750);
INSERT INTO `wja_form_table` VALUES (6, '1', 'authopen', '是否验证权限', '120', 2, NULL, 'openorclose', 60, 1, 0, 0, 0, 1544061814, 1544061814);
INSERT INTO `wja_form_table` VALUES (7, '1', 'menustatus', '是否显示菜单', '120', 2, NULL, 'openorclose', 70, 1, 0, 0, 0, 1544061917, 1544061917);
INSERT INTO `wja_form_table` VALUES (8, '2', '', '编号', '60', 3, NULL, '', 10, 1, 0, 0, 0, 1544069675, 1544069675);
INSERT INTO `wja_form_table` VALUES (9, '2', 'name', '厂商名称', '*', 1, NULL, '', 20, 1, 0, 0, 0, 1544069902, 1544069902);
INSERT INTO `wja_form_table` VALUES (10, '2', 'user_name', '联系人姓名', '100', 1, NULL, '', 30, 1, 0, 0, 0, 1544070008, 1544070041);
INSERT INTO `wja_form_table` VALUES (11, '2', 'mobile', '联系电话', '160', 1, NULL, '', 40, 1, 0, 0, 0, 1544070033, 1544070033);
INSERT INTO `wja_form_table` VALUES (12, '2', 'username', '管理员账号', '120', 1, NULL, '', 50, 1, 0, 0, 0, 1544070079, 1544070079);
INSERT INTO `wja_form_table` VALUES (13, '3', '', '编号', '60', 3, NULL, '', 10, 1, 0, 0, 0, 1544096236, 1544096236);
INSERT INTO `wja_form_table` VALUES (14, '3', 'group_type', '角色分组', '150', 2, NULL, 'groupname', 20, 1, 0, 0, 0, 1544096342, 1544096342);
INSERT INTO `wja_form_table` VALUES (15, '3', 'name', '角色名称', '*', 1, NULL, '', 30, 1, 0, 0, 0, 1544096365, 1544096365);
INSERT INTO `wja_form_table` VALUES (16, '4', '', '编号', '60', 3, NULL, '', 10, 1, 0, 0, 0, 1544098612, 1544098612);
INSERT INTO `wja_form_table` VALUES (17, '4', 'sname', '所属商户', '100', 1, NULL, '', 20, 1, 0, 0, 0, 1544098638, 1544098638);
INSERT INTO `wja_form_table` VALUES (18, '4', 'gname', '角色名称', '*', 1, NULL, '', 30, 1, 0, 0, 0, 1544098666, 1544098666);
INSERT INTO `wja_form_table` VALUES (19, '4', 'username', '登录用户名', '*', 1, NULL, '', 40, 1, 0, 0, 0, 1544098711, 1544098711);
INSERT INTO `wja_form_table` VALUES (20, '4', 'phone', '联系电话', '120', 1, NULL, '', 50, 1, 0, 0, 0, 1544098739, 1544098739);
INSERT INTO `wja_form_table` VALUES (21, '5', '', '编号', '60', 3, NULL, '', 10, 1, 0, 0, 0, 1544099072, 1544099072);
INSERT INTO `wja_form_table` VALUES (22, '5', 'sname', '厂商名称', '*', 1, NULL, '', 20, 1, 0, 0, 0, 1544099112, 1544099112);
INSERT INTO `wja_form_table` VALUES (23, '5', 'cate_name', '产品分类', '100', 1, NULL, '', 30, 1, 0, 0, 0, 1544099141, 1544099141);
INSERT INTO `wja_form_table` VALUES (24, '5', 'name', '产品名称', '*', 1, NULL, '', 40, 1, 0, 0, 0, 1544099174, 1544099174);
INSERT INTO `wja_form_table` VALUES (25, '5', 'goods_type', '产品类型', '100', 2, NULL, 'goodstype', 50, 1, 0, 0, 0, 1544099237, 1544099237);
INSERT INTO `wja_form_table` VALUES (26, '5', 'thumb', '产品图片', '100', 5, NULL, '', 60, 1, 0, 0, 0, 1544099277, 1544099277);
INSERT INTO `wja_form_table` VALUES (27, '5', 'goods_sn', '产品货号', '100', 1, NULL, '', 70, 1, 0, 0, 0, 1544099311, 1544099311);
INSERT INTO `wja_form_table` VALUES (28, '5', 'min_price', '产品价格', '100', 1, NULL, '', 80, 1, 0, 0, 0, 1544099348, 1544099348);
INSERT INTO `wja_form_table` VALUES (29, '5', 'goods_stock', '产品库存', '100', 1, NULL, '', 90, 1, 0, 0, 0, 1544099396, 1544099396);
INSERT INTO `wja_form_table` VALUES (30, '6', '', '编号', '60', 3, NULL, '', 10, 1, 0, 0, 0, 1544147221, 1544147221);
INSERT INTO `wja_form_table` VALUES (31, '6', 'sname', '厂商名称', '*', 1, NULL, '', 20, 1, 0, 0, 0, 1544147262, 1544147262);
INSERT INTO `wja_form_table` VALUES (32, '6', 'name', '分类名称', '*', 1, NULL, '', 30, 1, 0, 0, 0, 1544147341, 1544147341);
INSERT INTO `wja_form_table` VALUES (33, '7', '', '编号', '60', 3, NULL, '', 10, 1, 0, 0, 0, 1544147514, 1544147514);
INSERT INTO `wja_form_table` VALUES (34, '7', 'sname', '厂商名称', '*', 1, NULL, '', 20, 1, 0, 0, 0, 1544147539, 1544147539);
INSERT INTO `wja_form_table` VALUES (35, '7', 'name', '规格名称', '100', 1, NULL, '', 30, 1, 0, 0, 0, 1544147583, 1544147660);
INSERT INTO `wja_form_table` VALUES (36, '7', 'value', '规格属性', '*', 1, NULL, '', 40, 1, 0, 0, 0, 1544147605, 1544147605);
INSERT INTO `wja_form_table` VALUES (37, '8', '', '编号', '60', 3, NULL, '', 10, 1, 0, 0, 0, 1544147775, 1544147775);
INSERT INTO `wja_form_table` VALUES (38, '8', 'region_name', '负责区域', '*', 1, NULL, '', 50, 1, 0, 0, 0, 1544147856, 1544148085);
INSERT INTO `wja_form_table` VALUES (39, '8', 'security_money', '保证金金额', '100', 1, NULL, '', 60, 1, 0, 0, 0, 1544147888, 1544148090);
INSERT INTO `wja_form_table` VALUES (40, '2', 'domain', '二级域名', '100', 1, NULL, '', 15, 1, 0, 0, 0, 1544147968, 1544147968);
INSERT INTO `wja_form_table` VALUES (41, '8', 'name', '渠道名称', '*', 1, NULL, '', 20, 1, 0, 0, 0, 1544148133, 1544148133);
INSERT INTO `wja_form_table` VALUES (42, '8', 'user_name', '联系人姓名', '100', 1, NULL, '', 70, 1, 0, 0, 0, 1544148175, 1544148175);
INSERT INTO `wja_form_table` VALUES (43, '8', 'phone', '联系电话', '150', 1, NULL, '', 80, 1, 0, 0, 0, 1544148200, 1544148269);
INSERT INTO `wja_form_table` VALUES (44, '8', 'username', '管理员账号', '100', 1, NULL, '', 90, 1, 0, 0, 0, 1544148223, 1544148223);
INSERT INTO `wja_form_table` VALUES (45, '9', '', '编号', '60', 3, NULL, '', 10, 1, 0, 0, 0, 1544148337, 1544148337);
INSERT INTO `wja_form_table` VALUES (46, '9', 'name', '零售商名称', '*', 1, NULL, '', 20, 1, 0, 0, 0, 1544148370, 1544148370);
INSERT INTO `wja_form_table` VALUES (47, '9', 'cname', '所属渠道', '*', 1, NULL, '', 30, 1, 0, 0, 0, 1544148442, 1544148442);
INSERT INTO `wja_form_table` VALUES (48, '8', 'sname', '所属厂商', '*', 1, NULL, '', 15, 1, 0, 0, 0, 1544148510, 1544148510);
INSERT INTO `wja_form_table` VALUES (49, '9', 'sname', '所属厂商', '*', 1, NULL, '', 25, 1, 0, 0, 0, 1544148663, 1544148663);
INSERT INTO `wja_form_table` VALUES (50, '9', 'user_name', '联系人姓名', '100', 1, NULL, '', 50, 1, 0, 0, 0, 1544148759, 1544148759);
INSERT INTO `wja_form_table` VALUES (51, '9', 'phone', '联系电话', '150', 1, NULL, '', 60, 1, 0, 0, 0, 1544148785, 1544148785);
INSERT INTO `wja_form_table` VALUES (52, '9', 'username', '管理员账号', '100', 1, NULL, '', 70, 1, 0, 0, 0, 1544148823, 1544148823);
INSERT INTO `wja_form_table` VALUES (53, '10', '', '编号', '60', 3, NULL, '', 10, 1, 0, 0, 0, 1544148997, 1544148997);
INSERT INTO `wja_form_table` VALUES (54, '10', 'name', '服务商名称', '*', 1, NULL, '', 20, 1, 0, 0, 0, 1544149017, 1544149017);
INSERT INTO `wja_form_table` VALUES (55, '10', 'sname', '所属厂商', '*', 1, NULL, '', 30, 1, 0, 0, 0, 1544149033, 1544149033);
INSERT INTO `wja_form_table` VALUES (56, '10', 'user_name', '联系人姓名', '100', 1, NULL, '', 40, 1, 0, 0, 0, 1544149061, 1544149061);
INSERT INTO `wja_form_table` VALUES (57, '10', 'phone', '联系电话', '150', 1, NULL, '', 50, 1, 0, 0, 0, 1544149082, 1544149082);
INSERT INTO `wja_form_table` VALUES (58, '10', 'username', '管理员账号', '100', 1, NULL, '', 60, 1, 0, 0, 0, 1544149108, 1544149108);
INSERT INTO `wja_form_table` VALUES (59, '11', '', '编号', '60', 3, NULL, '', 10, 1, 0, 0, 0, 1544149679, 1544149679);
INSERT INTO `wja_form_table` VALUES (60, '11', 'fname', '所属厂商', '*', 1, NULL, '', 20, 1, 0, 0, 0, 1544149723, 1544149723);
INSERT INTO `wja_form_table` VALUES (61, '11', 'sname', '所属服务商', '*', 1, NULL, '', 30, 1, 0, 0, 0, 1544149748, 1544149748);
INSERT INTO `wja_form_table` VALUES (62, '11', 'region_name', '服务区域', '*', 1, NULL, '', 40, 1, 0, 0, 0, 1544150166, 1544150166);
INSERT INTO `wja_form_table` VALUES (63, '11', 'realname', '真实姓名', '100', 1, NULL, '', 50, 1, 0, 0, 0, 1544150207, 1544150241);
INSERT INTO `wja_form_table` VALUES (64, '11', 'phone', '联系电话', '150', 1, NULL, '', 70, 1, 0, 0, 0, 1544150234, 1544150234);
INSERT INTO `wja_form_table` VALUES (65, '11', 'udata_id', '绑定小程序', '100', 2, NULL, 'yorn', 80, 1, 0, 0, 0, 1544150592, 1544150600);
INSERT INTO `wja_form_table` VALUES (66, '12', '', '编号', '60', 3, NULL, '', 10, 1, 0, 0, 0, 1544100500, 1544100500);
INSERT INTO `wja_form_table` VALUES (67, '12', 'order_sn', '订单编号', '*', 1, NULL, '', 20, 1, 0, 0, 0, 1544100538, 1544100538);
INSERT INTO `wja_form_table` VALUES (68, '12', 'gname', '商品名称', '*', 1, NULL, '', 20, 1, 0, 0, 0, 1544100572, 1544100572);
INSERT INTO `wja_form_table` VALUES (69, '12', 'sname', '零售商名称', '*', 1, NULL, '', 30, 1, 0, 0, 0, 1544100592, 1544101029);
INSERT INTO `wja_form_table` VALUES (70, '12', 'order_amount', '订单金额', '80', 1, NULL, '', 40, 1, 0, 0, 0, 1544100610, 1544100610);
INSERT INTO `wja_form_table` VALUES (71, '12', 'commission_ratio', '佣金百分比', '100', 1, NULL, '', 50, 1, 0, 0, 0, 1544100633, 1544100633);
INSERT INTO `wja_form_table` VALUES (72, '12', 'income_amount', '佣金金额', '80', 1, NULL, '', 60, 1, 0, 0, 0, 1544100654, 1544100654);
INSERT INTO `wja_form_table` VALUES (73, '12', 'add_time', '交易时间', '120', 2, NULL, 'date', 70, 1, 0, 0, 0, 1544100679, 1544100679);

SET FOREIGN_KEY_CHECKS = 1;
