package com.saascrm.service.Impl;

import com.saascrm.converter.TenantConverter;
import com.saascrm.mapper.tenantMapper;
import com.saascrm.pojo.dto.requestDto.tenantRequestDto;
import com.saascrm.pojo.entity.tenant;
import com.saascrm.service.tenantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class tenantServiceImpl implements tenantService {

    @Autowired
    private tenantMapper tenantMapper;
    @Override
    public void addTenant(tenantRequestDto tenantRequestDto) {
        tenant tenant = TenantConverter.INSTANCE.toEntity(tenantRequestDto);
        tenantMapper.insert(tenant);
    }
}
