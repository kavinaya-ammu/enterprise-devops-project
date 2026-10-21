package com.enterprise.wms;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class ApiController {
    private final List<Map<String, Object>> customers = List.of(
        Map.of("id", "CUST001", "name", "Northwind Distribution", "status", "ACTIVE"),
        Map.of("id", "CUST002", "name", "Contoso Warehousing", "status", "ACTIVE"),
        Map.of("id", "CUST003", "name", "Fabrikam Logistics", "status", "ONBOARDING"));
    private final List<Map<String, Object>> inventory = List.of(
        Map.of("sku", "SKU-1001", "warehouse", "CHN-01", "available", 240),
        Map.of("sku", "SKU-1002", "warehouse", "BLR-02", "available", 87),
        Map.of("sku", "SKU-1003", "warehouse", "HYD-01", "available", 0));

    @GetMapping("/info") public Map<String, Object> info() {
        return Map.of("service", "enterprise-wms", "version", "1.0.0", "timestamp", Instant.now().toString());
    }
    @GetMapping("/customers") public List<Map<String, Object>> customers() { return customers; }
    @GetMapping("/customers/{id}") public Map<String, Object> customer(@PathVariable String id) {
        return customers.stream().filter(c -> id.equals(c.get("id"))).findFirst()
            .orElseThrow(() -> new ResourceNotFoundException("Customer not found: " + id));
    }
    @GetMapping("/inventory") public List<Map<String, Object>> inventory() { return inventory; }
    @GetMapping("/inventory/{sku}") public Map<String, Object> stock(@PathVariable String sku) {
        return inventory.stream().filter(i -> sku.equals(i.get("sku"))).findFirst()
            .orElseThrow(() -> new ResourceNotFoundException("SKU not found: " + sku));
    }
}
