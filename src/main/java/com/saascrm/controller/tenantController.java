package com.saascrm.controller;

import com.saascrm.Result.Result;
import com.saascrm.annotation.Log;
import com.saascrm.converter.TenantConverter;
import com.saascrm.pojo.dto.requestDto.tenantRequestDto;
import com.saascrm.pojo.dto.responseDto.tenantResponseDto;
import com.saascrm.pojo.entity.tenant;
import com.saascrm.service.tenantService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/tenant")
@Tag(name = "租户管理", description = "租户相关接口")
public class tenantController {
    @Autowired
    tenantService tenantService;
    @Log
    @PostMapping("/add")
    public Result<tenantResponseDto> addTenant(@RequestBody tenantRequestDto tenantRequestDto) {
        tenantService.addTenant(tenantRequestDto);
        return Result.success();
    }
}
