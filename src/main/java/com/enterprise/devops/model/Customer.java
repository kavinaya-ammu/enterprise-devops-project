package com.enterprise.devops.model;

import java.time.LocalDateTime;

public record Customer(
        long id,
        String customerCode,
        String customerName,
        String email,
        String status,
        LocalDateTime createdAt
) {
}
