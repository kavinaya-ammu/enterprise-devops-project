package com.enterprise.devops.config;

public final class DatabaseConfig {

    private DatabaseConfig() {
    }

    public static String getUrl() {
        return System.getenv().getOrDefault(
                "DB_URL",
                "jdbc:postgresql://localhost:5432/enterprise_db"
        );
    }

    public static String getUser() {
        return System.getenv().getOrDefault(
                "DB_USER",
                "enterprise_user"
        );
    }

    public static String getPassword() {
        String password = System.getenv("DB_PASSWORD");

        if (password == null || password.isBlank()) {
            throw new IllegalStateException(
                    "DB_PASSWORD environment variable is not set"
            );
        }

        return password;
    }
}
