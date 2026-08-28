package com.enterprise.devops;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class Application {

    public static void main(String[] args) throws IOException {

        int port = 8080;

        HttpServer server = HttpServer.create(
                new InetSocketAddress("0.0.0.0", port),
                0
        );

        server.createContext("/", Application::handleRequest);

        server.start();

        System.out.println(
                "Enterprise DevOps Application Started on port " + port
        );
    }

    private static void handleRequest(HttpExchange exchange) throws IOException {

        String response = "Enterprise DevOps Application is Running";

        exchange.sendResponseHeaders(200, response.length());

        try (OutputStream outputStream = exchange.getResponseBody()) {
            outputStream.write(response.getBytes());
        }
    }
}
