package com.saascrm.pojo.dto.requestDto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class tenantRequestDto {

    private Long id;

    @NotBlank(message = "租户名称不能为空")
    private String tenantName;

    @NotBlank(message = "密码不能为空")
    private String password;

    private Integer status;
}
