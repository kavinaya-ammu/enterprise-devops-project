package com.enterprise.devops;

import com.enterprise.devops.handler.CustomerHandler;
import com.enterprise.devops.repository.CustomerRepository;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.net.InetSocketAddress;

public class Application {

    private static final int PORT = 8085;

    public static void main(String[] args) throws IOException {

        CustomerRepository customerRepository =
                new CustomerRepository();

        HttpServer server = HttpServer.create(
                new InetSocketAddress("0.0.0.0", PORT),
                0
        );

        server.createContext(
                "/",
                exchange -> {

                    String response =
                            "Enterprise DevOps Application is Running";

                    byte[] responseBytes =
                            response.getBytes();

                    exchange.sendResponseHeaders(
                            200,
                            responseBytes.length
                    );

                    try (var outputStream =
                                 exchange.getResponseBody()) {
                        outputStream.write(responseBytes);
                    }
                }
        );

        server.createContext(
                "/health",
                exchange -> {

                    String response = "{\"status\":\"UP\"}";

                    byte[] responseBytes =
                            response.getBytes();

                    exchange.getResponseHeaders()
                            .set(
                                    "Content-Type",
                                    "application/json"
                            );

                    exchange.sendResponseHeaders(
                            200,
                            responseBytes.length
                    );

                    try (var outputStream =
                                 exchange.getResponseBody()) {
                        outputStream.write(responseBytes);
                    }
                }
        );

        server.createContext(
                "/api/customers",
                new CustomerHandler(customerRepository)
        );

        server.start();

        System.out.println(
                "Enterprise DevOps Application Started on port "
                        + PORT
        );

        System.out.println(
                "Health endpoint: http://localhost:"
                        + PORT + "/health"
        );

        System.out.println(
                "Customer endpoint: http://localhost:"
                        + PORT + "/api/customers"
        );
    }
}
