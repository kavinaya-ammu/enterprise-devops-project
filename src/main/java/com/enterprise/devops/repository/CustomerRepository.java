package com.enterprise.devops.repository;

import com.enterprise.devops.config.DatabaseConfig;
import com.enterprise.devops.model.Customer;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CustomerRepository {

    private static final String FIND_ALL_SQL = """
            SELECT id,
                   customer_code,
                   customer_name,
                   email,
                   status,
                   created_at
            FROM enterprise.customers
            ORDER BY id
            """;

    public List<Customer> findAll() throws SQLException {

        List<Customer> customers = new ArrayList<>();

        try (
                Connection connection = DriverManager.getConnection(
                        DatabaseConfig.getUrl(),
                        DatabaseConfig.getUser(),
                        DatabaseConfig.getPassword()
                );

                PreparedStatement statement =
                        connection.prepareStatement(FIND_ALL_SQL);

                ResultSet resultSet = statement.executeQuery()
        ) {

            while (resultSet.next()) {

                Customer customer = new Customer(
                        resultSet.getLong("id"),
                        resultSet.getString("customer_code"),
                        resultSet.getString("customer_name"),
                        resultSet.getString("email"),
                        resultSet.getString("status"),
                        resultSet.getTimestamp("created_at")
                                .toLocalDateTime()
                );

                customers.add(customer);
            }
        }

        return customers;
    }
}
