
package com.enterprise.devops.handler;

import com.enterprise.devops.model.Customer;
import com.enterprise.devops.repository.CustomerRepository;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.List;

public class CustomerHandler implements HttpHandler {

    private final CustomerRepository customerRepository;

    public CustomerHandler(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {

        try {
            // Validate HTTP method
            if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {

                sendResponse(
                        exchange,
                        405,
                        "{\"error\":\"Method Not Allowed\"}"
                );

                return;
            }

            // Retrieve customers from database
            List<Customer> customers = customerRepository.findAll();

            // Convert customer list to JSON
            String json = toJson(customers);

            // Send successful response
            sendResponse(exchange, 200, json);

        } catch (IllegalStateException e) {

            System.err.println(
                    "Database configuration error: " + e.getMessage()
            );

            sendResponse(
                    exchange,
                    503,
                    "{\"error\":\"Database configuration unavailable\"}"
            );

        } catch (SQLException e) {

            System.err.println(
                    "Database error while retrieving customers: "
                            + e.getMessage()
            );

            sendResponse(
                    exchange,
                    503,
                    "{\"error\":\"Database service unavailable\"}"
            );

        } catch (Exception e) {

            System.err.println(
                    "Unexpected customer API error: " + e.getMessage()
            );

            e.printStackTrace();

            sendResponse(
                    exchange,
                    500,
                    "{\"error\":\"Internal Server Error\"}"
            );

        } finally {

            exchange.close();
        }
    }

    // Convert customer list into JSON
    private String toJson(List<Customer> customers) {

        StringBuilder json = new StringBuilder("[\n");

        for (int i = 0; i < customers.size(); i++) {

            Customer customer = customers.get(i);

            json.append("  {")
                    .append("\"id\":").append(customer.id()).append(",")
                    .append("\"customerCode\":\"")
                    .append(escape(customer.customerCode())).append("\",")
                    .append("\"customerName\":\"")
                    .append(escape(customer.customerName())).append("\",")
                    .append("\"email\":\"")
                    .append(escape(customer.email())).append("\",")
                    .append("\"status\":\"")
                    .append(escape(customer.status())).append("\",")
                    .append("\"createdAt\":\"")
                    .append(customer.createdAt())
                    .append("\"")
                    .append("}");

            if (i < customers.size() - 1) {
                json.append(",");
            }

            json.append("\n");
        }

        json.append("]");

        return json.toString();
    }

    // Escape special JSON characters
    private String escape(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    // Send HTTP response
    private void sendResponse(
            HttpExchange exchange,
            int statusCode,
            String response
    ) throws IOException {

        exchange.getResponseHeaders()
                .set("Content-Type", "application/json; charset=UTF-8");

        exchange.setAttribute("response-status", statusCode);

        byte[] responseBytes =
                response.getBytes(StandardCharsets.UTF_8);

        exchange.sendResponseHeaders(
                statusCode,
                responseBytes.length
        );

        try (var outputStream = exchange.getResponseBody()) {

            outputStream.write(responseBytes);
        }
    }
}

