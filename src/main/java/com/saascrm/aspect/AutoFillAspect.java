package com.saascrm.aspect;

import com.saascrm.pojo.entity.BaseEntity;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Aspect
@Component
@Order(0)
public class AutoFillAspect {

    private static final Long SYSTEM_USER_ID = 1L;

    @Pointcut("execution(* com.saascrm.mapper.*.insert(..))")
    public void insertPointcut() {}

    @Pointcut("execution(* com.saascrm.mapper.*.update(..))")
    public void updatePointcut() {}

    @Before("insertPointcut()")
    public void beforeInsert(JoinPoint joinPoint) {
        for (Object arg : joinPoint.getArgs()) {
            if (arg instanceof BaseEntity entity) {
                LocalDateTime now = LocalDateTime.now();
                entity.setCreatedAt(now);
                entity.setUpdatedAt(now);
                entity.setCreatedBy(SYSTEM_USER_ID);
                entity.setUpdatedBy(SYSTEM_USER_ID);
                entity.setIsDeleted(0);
            }
        }
    }

    @Before("updatePointcut()")
    public void beforeUpdate(JoinPoint joinPoint) {
        for (Object arg : joinPoint.getArgs()) {
            if (arg instanceof BaseEntity entity) {
                entity.setUpdatedAt(LocalDateTime.now());
                entity.setUpdatedBy(SYSTEM_USER_ID);
            }
        }
    }
}
