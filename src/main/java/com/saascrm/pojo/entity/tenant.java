package com.saascrm.pojo.entity;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class tenant extends BaseEntity {

    private Long id;
    private String tenantName;
    private String password;
    private Integer status;
}
