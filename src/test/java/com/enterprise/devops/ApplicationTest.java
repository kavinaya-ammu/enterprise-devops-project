package com.enterprise.devops;

import com.enterprise.devops.handler.CustomerHandler;
import com.enterprise.devops.model.Customer;
import com.enterprise.devops.repository.CustomerRepository;
import com.sun.net.httpserver.HttpServer;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;

import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class ApplicationTest {
    private HttpServer server;

    private URI start(CustomerRepository repository) throws Exception {
        server = HttpServer.create(new InetSocketAddress("127.0.0.1", 0), 0);
        server.createContext("/api/customers", new CustomerHandler(repository));
        server.start();
        return URI.create("http://127.0.0.1:"
                + server.getAddress().getPort() + "/api/customers");
    }

    private HttpResponse<String> request(URI uri, String method)
            throws Exception {
        var request = HttpRequest.newBuilder(uri)
                .method(method, HttpRequest.BodyPublishers.noBody())
                .build();
        return HttpClient.newHttpClient()
                .send(request, HttpResponse.BodyHandlers.ofString());
    }

    @AfterEach
    void stopServer() {
        if (server != null) {
            server.stop(0);
        }
    }

    @Test
    void getReturnsCustomerJson() throws Exception {
        var customer = new Customer(1, "C\"1", "Acme\nLabs", "a@example.com",
                "ACTIVE", LocalDateTime.of(2026, 9, 26, 14, 52, 1));
        var repository = new CustomerRepository() {
            @Override
            public List<Customer> findAll() {
                return List.of(customer);
            }
        };

        var response = request(start(repository), "GET");

        assertEquals(200, response.statusCode());
        assertTrue(response.headers().firstValue("Content-Type")
                .orElse("").startsWith("application/json"));
        assertTrue(response.body().contains("\"customerCode\":\"C\\\"1\""));
        assertTrue(response.body().contains("\"customerName\":\"Acme\\nLabs\""));
        assertTrue(response.body().contains("\"id\":1"));
    }

    @Test
    void nonGetMethodReturns405() throws Exception {
        var repository = new CustomerRepository() {
            @Override
            public List<Customer> findAll() {
                fail("Repository should not be queried for POST");
                return List.of();
            }
        };

        var response = request(start(repository), "POST");

        assertEquals(405, response.statusCode());
        assertTrue(response.body().contains("Method Not Allowed"));
    }

    @Test
    void databaseConfigurationFailureReturns503() throws Exception {
        var repository = failingRepository(
                new IllegalStateException("missing configuration"));

        var response = request(start(repository), "GET");

        assertEquals(503, response.statusCode());
        assertTrue(response.body().contains("Database configuration unavailable"));
    }

    @Test
    void sqlFailureReturns503() throws Exception {
        var repository = failingRepository(new SQLException("database down"));

        var response = request(start(repository), "GET");

        assertEquals(503, response.statusCode());
        assertTrue(response.body().contains("Database service unavailable"));
    }

    @Test
    void unexpectedFailureReturns500() throws Exception {
        var repository = failingRepository(new RuntimeException("unexpected"));

        var response = request(start(repository), "GET");

        assertEquals(500, response.statusCode());
        assertTrue(response.body().contains("Internal Server Error"));
    }

    private CustomerRepository failingRepository(Exception failure) {
        return new CustomerRepository() {
            @Override
            public List<Customer> findAll() throws SQLException {
                if (failure instanceof SQLException e) {
                    throw e;
                }
                if (failure instanceof RuntimeException e) {
                    throw e;
                }
                throw new AssertionError(failure);
            }
        };
    }
}
