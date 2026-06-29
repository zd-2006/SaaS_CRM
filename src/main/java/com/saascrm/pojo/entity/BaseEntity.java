package com.saascrm.pojo.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public abstract class BaseEntity {

    private Long createdBy;
    private Long updatedBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Integer isDeleted;
}
