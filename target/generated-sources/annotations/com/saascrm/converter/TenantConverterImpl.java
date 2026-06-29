package com.saascrm.converter;

import com.saascrm.pojo.dto.requestDto.tenantRequestDto;
import com.saascrm.pojo.entity.tenant;
import javax.annotation.processing.Generated;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-06-29T17:46:23+0800",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 21.0.11 (Microsoft)"
)
public class TenantConverterImpl implements TenantConverter {

    @Override
    public tenant toEntity(tenantRequestDto dto) {
        if ( dto == null ) {
            return null;
        }

        tenant tenant = new tenant();

        tenant.setId( dto.getId() );
        tenant.setTenantName( dto.getTenantName() );
        tenant.setPassword( dto.getPassword() );
        tenant.setStatus( dto.getStatus() );

        return tenant;
    }
}
