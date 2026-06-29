-- ==========================================
-- 1. 租户表 (sys_tenant)
-- ==========================================
CREATE TABLE sys_tenant (
  id BIGINT NOT NULL,
  tenant_name VARCHAR(100) NOT NULL,
  password VARCHAR(100) NOT NULL DEFAULT '',
  status SMALLINT NOT NULL DEFAULT 1,
  created_by BIGINT DEFAULT NULL,
  updated_by BIGINT DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_deleted SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
);

COMMENT ON TABLE sys_tenant IS '租户表';
COMMENT ON COLUMN sys_tenant.id IS '租户ID (雪花算法)';
COMMENT ON COLUMN sys_tenant.tenant_name IS '租户名称/公司名称';
COMMENT ON COLUMN sys_tenant.password IS '租户登录密码(BCrypt加密)';
COMMENT ON COLUMN sys_tenant.status IS '状态: 0-禁用, 1-正常';
COMMENT ON COLUMN sys_tenant.created_by IS '创建人';
COMMENT ON COLUMN sys_tenant.updated_by IS '更新人';
COMMENT ON COLUMN sys_tenant.created_at IS '创建时间';
COMMENT ON COLUMN sys_tenant.updated_at IS '更新时间';
COMMENT ON COLUMN sys_tenant.is_deleted IS '逻辑删除: 0-未删, 1-已删';

-- ==========================================
-- 2. 用户表 (sys_user)
-- ==========================================
CREATE TABLE sys_user (
  id BIGINT NOT NULL,
  tenant_id BIGINT NOT NULL,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(100) NOT NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'SALES',
  status SMALLINT NOT NULL DEFAULT 1,
  created_by BIGINT DEFAULT NULL,
  updated_by BIGINT DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_deleted SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
);

CREATE INDEX idx_tenant_username ON sys_user (tenant_id, username);

COMMENT ON TABLE sys_user IS '用户/销售表';
COMMENT ON COLUMN sys_user.id IS '用户ID';
COMMENT ON COLUMN sys_user.tenant_id IS '所属租户ID';
COMMENT ON COLUMN sys_user.username IS '用户名/登录名';
COMMENT ON COLUMN sys_user.password IS '密码(BCrypt加密)';
COMMENT ON COLUMN sys_user.role IS '角色: ADMIN-管理员, SALES-销售';
COMMENT ON COLUMN sys_user.status IS '状态: 0-禁用, 1-正常';

-- ==========================================
-- 3. 客户表 (crm_customer)
-- ==========================================
CREATE TABLE crm_customer (
  id BIGINT NOT NULL,
  tenant_id BIGINT NOT NULL,
  customer_name VARCHAR(100) NOT NULL,
  industry VARCHAR(50) DEFAULT NULL,
  company_size VARCHAR(50) DEFAULT NULL,
  level VARCHAR(20) DEFAULT NULL,
  status VARCHAR(20) DEFAULT NULL,
  city VARCHAR(50) DEFAULT NULL,
  owner_user_id BIGINT NOT NULL,
  created_by BIGINT DEFAULT NULL,
  updated_by BIGINT DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_deleted SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
);

CREATE INDEX idx_customer_tenant_owner ON crm_customer (tenant_id, owner_user_id);
CREATE INDEX idx_customer_tenant_name ON crm_customer (tenant_id, customer_name);

COMMENT ON TABLE crm_customer IS '客户表';
COMMENT ON COLUMN crm_customer.id IS '客户ID';
COMMENT ON COLUMN crm_customer.tenant_id IS '所属租户ID';
COMMENT ON COLUMN crm_customer.customer_name IS '客户/公司名称';
COMMENT ON COLUMN crm_customer.industry IS '所属行业';
COMMENT ON COLUMN crm_customer.company_size IS '公司规模(如:50-200人)';
COMMENT ON COLUMN crm_customer.level IS '客户等级(如:A, B, C)';
COMMENT ON COLUMN crm_customer.status IS '客户状态(如:潜在, 意向, 成交)';
COMMENT ON COLUMN crm_customer.city IS '所在城市';
COMMENT ON COLUMN crm_customer.owner_user_id IS '负责人ID';

-- ==========================================
-- 4. 联系人表 (crm_contact)
-- ==========================================
CREATE TABLE crm_contact (
  id BIGINT NOT NULL,
  tenant_id BIGINT NOT NULL,
  customer_id BIGINT NOT NULL,
  name VARCHAR(50) NOT NULL,
  position VARCHAR(50) DEFAULT NULL,
  phone VARCHAR(20) DEFAULT NULL,
  email VARCHAR(100) DEFAULT NULL,
  created_by BIGINT DEFAULT NULL,
  updated_by BIGINT DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_deleted SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
);

CREATE INDEX idx_contact_tenant_customer ON crm_contact (tenant_id, customer_id);

COMMENT ON TABLE crm_contact IS '联系人表';
COMMENT ON COLUMN crm_contact.id IS '联系人ID';
COMMENT ON COLUMN crm_contact.tenant_id IS '所属租户ID';
COMMENT ON COLUMN crm_contact.customer_id IS '所属客户ID';
COMMENT ON COLUMN crm_contact.name IS '姓名';
COMMENT ON COLUMN crm_contact.position IS '职位';
COMMENT ON COLUMN crm_contact.phone IS '电话';
COMMENT ON COLUMN crm_contact.email IS '邮箱';

-- ==========================================
-- 5. 商机表 (crm_opportunity)
-- ==========================================
CREATE TABLE crm_opportunity (
  id BIGINT NOT NULL,
  tenant_id BIGINT NOT NULL,
  customer_id BIGINT NOT NULL,
  owner_user_id BIGINT NOT NULL,
  product_name VARCHAR(100) NOT NULL,
  amount DECIMAL(15,2) DEFAULT 0.00,
  stage VARCHAR(20) NOT NULL,
  probability INT DEFAULT 0,
  expected_close_date DATE DEFAULT NULL,
  created_by BIGINT DEFAULT NULL,
  updated_by BIGINT DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_deleted SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
);

CREATE INDEX idx_opp_tenant_customer ON crm_opportunity (tenant_id, customer_id);
CREATE INDEX idx_opp_tenant_owner ON crm_opportunity (tenant_id, owner_user_id);

COMMENT ON TABLE crm_opportunity IS '商机表';
COMMENT ON COLUMN crm_opportunity.id IS '商机ID';
COMMENT ON COLUMN crm_opportunity.tenant_id IS '所属租户ID';
COMMENT ON COLUMN crm_opportunity.customer_id IS '所属客户ID';
COMMENT ON COLUMN crm_opportunity.owner_user_id IS '负责人ID';
COMMENT ON COLUMN crm_opportunity.product_name IS '意向产品名称';
COMMENT ON COLUMN crm_opportunity.amount IS '预计金额';
COMMENT ON COLUMN crm_opportunity.stage IS '销售阶段(如:沟通, 报价, 合同, 赢单, 输单)';
COMMENT ON COLUMN crm_opportunity.probability IS '成交概率(0-100)';
COMMENT ON COLUMN crm_opportunity.expected_close_date IS '预计成交日期';

-- ==========================================
-- 6. 跟进记录表 (crm_follow_record)
-- ==========================================
CREATE TABLE crm_follow_record (
  id BIGINT NOT NULL,
  tenant_id BIGINT NOT NULL,
  opportunity_id BIGINT NOT NULL,
  content TEXT NOT NULL,
  follow_type VARCHAR(20) NOT NULL,
  follow_time TIMESTAMP NOT NULL,
  created_by BIGINT NOT NULL,
  updated_by BIGINT DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_deleted SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
);

CREATE INDEX idx_follow_tenant_opp ON crm_follow_record (tenant_id, opportunity_id);

COMMENT ON TABLE crm_follow_record IS '跟进记录表';
COMMENT ON COLUMN crm_follow_record.id IS '跟进ID';
COMMENT ON COLUMN crm_follow_record.tenant_id IS '所属租户ID';
COMMENT ON COLUMN crm_follow_record.opportunity_id IS '所属商机ID';
COMMENT ON COLUMN crm_follow_record.content IS '跟进内容';
COMMENT ON COLUMN crm_follow_record.follow_type IS '跟进方式(如:电话, 拜访, 微信)';
COMMENT ON COLUMN crm_follow_record.follow_time IS '跟进时间';
COMMENT ON COLUMN crm_follow_record.created_by IS '填写人ID';

-- ==========================================
-- updated_at 自动更新触发器
-- ==========================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_sys_tenant_updated_at
    BEFORE UPDATE ON sys_tenant
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_sys_user_updated_at
    BEFORE UPDATE ON sys_user
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_crm_customer_updated_at
    BEFORE UPDATE ON crm_customer
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_crm_contact_updated_at
    BEFORE UPDATE ON crm_contact
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_crm_opportunity_updated_at
    BEFORE UPDATE ON crm_opportunity
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_crm_follow_record_updated_at
    BEFORE UPDATE ON crm_follow_record
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
