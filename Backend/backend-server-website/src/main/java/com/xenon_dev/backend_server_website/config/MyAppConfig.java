package com.xenon_dev.backend_server_website.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import org.springframework.lang.NonNull;

@Configuration
public class MyAppConfig implements WebMvcConfigurer {
    
    @Value("${allowed.orignins}")
    private String[] theAllowedOrigins;

    @Value("${spring.data.rest.base-path}")
    private String basePath;

    @Override
    public void addCorsMappings(@NonNull CorsRegistry cors) {
        cors.addMapping( basePath + "/**" ).allowedOrigins(theAllowedOrigins);
    }
}
