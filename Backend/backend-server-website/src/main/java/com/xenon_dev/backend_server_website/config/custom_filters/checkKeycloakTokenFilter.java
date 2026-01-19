package com.xenon_dev.backend_server_website.config.custom_filters;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import com.xenon_dev.backend_server_website.service.Keycloak_Service_Impl;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class checkKeycloakTokenFilter implements Filter {

    @Autowired
    private Keycloak_Service_Impl keycloakService;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String token = httpRequest.getHeader("Authorization");

        if (token == null || !token.startsWith("Bearer ")) {
            httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            httpResponse.addHeader("A message for you",
                    "Naughty, naughty, you are trying to access an endpoint via illegitimate means :P");
        } else if (!keycloakService.validateToken(token)) {
            httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        } else {
            chain.doFilter(request, response);
        }
    }

}
