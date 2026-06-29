package com.saascrm.mapper;

import com.saascrm.pojo.entity.tenant;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface tenantMapper {

    int insert(tenant tenant);

    int update(tenant tenant);

    tenant selectById(@Param("id") Long id);

    tenant selectByName(@Param("tenantName") String tenantName);

    List<tenant> selectAll();

    int softDelete(@Param("id") Long id);
}
