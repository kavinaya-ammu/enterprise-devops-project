package com.enterprise.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/")
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        response.getWriter().println("""
            <!DOCTYPE html>
            <html>
            <head>
                <title>Enterprise Admin Application</title>
            </head>
            <body>
                <h1>Enterprise Admin Application</h1>
                <p>WebLogic Enterprise Application</p>
                <p>Application Status: RUNNING</p>
                <p>Database: PostgreSQL - Planned</p>
                <p>Authentication: Planned</p>
            </body>
            </html>
            """);
    }
}
