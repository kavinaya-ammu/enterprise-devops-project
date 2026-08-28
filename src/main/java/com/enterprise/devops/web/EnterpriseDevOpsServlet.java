package com.enterprise.devops.web;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class EnterpriseDevOpsServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        response.setContentType("text/plain");

        response.getWriter().println(
                "Enterprise DevOps Application is Running on JBoss EAP"
        );
    }
}
