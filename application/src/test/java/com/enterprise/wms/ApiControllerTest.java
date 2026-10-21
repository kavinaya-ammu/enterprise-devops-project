package com.enterprise.wms;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest @AutoConfigureMockMvc
class ApiControllerTest {
    @Autowired MockMvc mvc;
    @Test void healthEndpointIsAvailable() throws Exception { mvc.perform(get("/actuator/health")).andExpect(status().isOk()).andExpect(jsonPath("$.status").value("UP")); }
    @Test void customersEndpointReturnsSeededCustomers() throws Exception { mvc.perform(get("/api/customers")).andExpect(status().isOk()).andExpect(jsonPath("$[0].id").value("CUST001")).andExpect(jsonPath("$[2].id").value("CUST003")); }
    @Test void inventoryEndpointReturnsStock() throws Exception { mvc.perform(get("/api/inventory/SKU-1001")).andExpect(status().isOk()).andExpect(jsonPath("$.available").value(240)); }
    @Test void missingCustomerReturns404() throws Exception { mvc.perform(get("/api/customers/UNKNOWN")).andExpect(status().isNotFound()); }
}
