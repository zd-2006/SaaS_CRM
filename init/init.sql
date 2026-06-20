-- 创建数据库
CREATE DATABASE IF NOT EXISTS saas_crm DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE saas_crm;

-- ==========================================
-- 1. 租户表 (sys_tenant)
-- 唯一不需要 tenant_id 的表，因为它是租户本身
-- ==========================================
CREATE TABLE `sys_tenant` (
  `id` bigint NOT NULL COMMENT '租户ID (雪花算法)',
  `tenant_name` varchar(100) NOT NULL COMMENT '租户名称/公司名称',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态: 0-禁用, 1-正常',
  `created_by` bigint DEFAULT NULL COMMENT '创建人',
  `updated_by` bigint DEFAULT NULL COMMENT '更新人',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除: 0-未删, 1-已删',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='租户表';

-- ==========================================
-- 2. 用户表 (sys_user)
-- 员工、销售人员
-- ==========================================
CREATE TABLE `sys_user` (
  `id` bigint NOT NULL COMMENT '用户ID',
  `tenant_id` bigint NOT NULL COMMENT '所属租户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名/登录名',
  `password` varchar(100) NOT NULL COMMENT '密码(BCrypt加密)',
  `role` varchar(20) NOT NULL DEFAULT 'SALES' COMMENT '角色: ADMIN-管理员, SALES-销售',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态: 0-禁用, 1-正常',
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_tenant_username` (`tenant_id`,`username`) -- 索引优化：登录时带上tenant_id查询更快
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户/销售表';

-- ==========================================
-- 3. 客户表 (crm_customer)
-- 公司级别的客户
-- ==========================================
CREATE TABLE `crm_customer` (
  `id` bigint NOT NULL COMMENT '客户ID',
  `tenant_id` bigint NOT NULL COMMENT '所属租户ID',
  `customer_name` varchar(100) NOT NULL COMMENT '客户/公司名称',
  `industry` varchar(50) DEFAULT NULL COMMENT '所属行业',
  `company_size` varchar(50) DEFAULT NULL COMMENT '公司规模(如:50-200人)',
  `level` varchar(20) DEFAULT NULL COMMENT '客户等级(如:A, B, C)',
  `status` varchar(20) DEFAULT NULL COMMENT '客户状态(如:潜在, 意向, 成交)',
  `city` varchar(50) DEFAULT NULL COMMENT '所在城市',
  `owner_user_id` bigint NOT NULL COMMENT '负责人ID (关系R3: 谁在管这个客户)',
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_tenant_owner` (`tenant_id`,`owner_user_id`), -- 索引：销售查自己的客户极快
  KEY `idx_tenant_name` (`tenant_id`,`customer_name`)   -- 索引：按名字模糊/精确搜索
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='客户表';

-- ==========================================
-- 4. 联系人表 (crm_contact)
-- 客户公司里的人
-- ==========================================
CREATE TABLE `crm_contact` (
  `id` bigint NOT NULL COMMENT '联系人ID',
  `tenant_id` bigint NOT NULL COMMENT '所属租户ID',
  `customer_id` bigint NOT NULL COMMENT '所属客户ID (关系R4)',
  `name` varchar(50) NOT NULL COMMENT '姓名',
  `position` varchar(50) DEFAULT NULL COMMENT '职位',
  `phone` varchar(20) DEFAULT NULL COMMENT '电话',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_tenant_customer` (`tenant_id`,`customer_id`) -- 索引：打开客户详情时查联系人极快
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='联系人表';

-- ==========================================
-- 5. 商机表 (crm_opportunity)
-- 正在跟进的一笔生意
-- ==========================================
CREATE TABLE `crm_opportunity` (
  `id` bigint NOT NULL COMMENT '商机ID',
  `tenant_id` bigint NOT NULL COMMENT '所属租户ID',
  `customer_id` bigint NOT NULL COMMENT '所属客户ID (关系R5)',
  `owner_user_id` bigint NOT NULL COMMENT '负责人ID (关系R6)',
  `product_name` varchar(100) NOT NULL COMMENT '意向产品名称',
  `amount` decimal(15,2) DEFAULT '0.00' COMMENT '预计金额',
  `stage` varchar(20) NOT NULL COMMENT '销售阶段(如:沟通, 报价, 合同, 赢单, 输单)',
  `probability` int DEFAULT '0' COMMENT '成交概率(0-100)',
  `expected_close_date` date DEFAULT NULL COMMENT '预计成交日期',
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_tenant_customer` (`tenant_id`,`customer_id`),
  KEY `idx_tenant_owner` (`tenant_id`,`owner_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商机表';

-- ==========================================
-- 6. 跟进记录表 (crm_follow_record)
-- 每天打电话、拜访的记录
-- ==========================================
CREATE TABLE `crm_follow_record` (
  `id` bigint NOT NULL COMMENT '跟进ID',
  `tenant_id` bigint NOT NULL COMMENT '所属租户ID',
  `opportunity_id` bigint NOT NULL COMMENT '所属商机ID (关系R7)',
  `content` text NOT NULL COMMENT '跟进内容',
  `follow_type` varchar(20) NOT NULL COMMENT '跟进方式(如:电话, 拜访, 微信)',
  `follow_time` datetime NOT NULL COMMENT '跟进时间',
  `created_by` bigint NOT NULL COMMENT '填写人ID (关系R8: 谁写的这条记录)',
  `updated_by` bigint DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_tenant_opportunity` (`tenant_id`,`opportunity_id`) -- 索引：打开商机详情加载跟进记录
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='跟进记录表';