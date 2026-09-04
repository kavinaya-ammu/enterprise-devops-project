package com.devops.admin;

import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class App {

    public static void main(String[] args) throws IOException {

        int port = Integer.parseInt(
    System.getenv().getOrDefault("PORT", "8081")
     );

        HttpServer server = HttpServer.create(
                new InetSocketAddress("0.0.0.0", port), 0);

        server.createContext("/", exchange -> {

            String response =
                    "DevOps Admin Demo Application is Running\n";

            exchange.sendResponseHeaders(200, response.length());

            try (OutputStream output = exchange.getResponseBody()) {
                output.write(response.getBytes());
            }
        });

        server.start();

        System.out.println(
                "DevOps Admin Demo Application started on port " + port);
    }
}
