package com.xenon_dev.backend_server_website.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.reactive.function.client.WebClient;

public class Keycloak_Service_Impl implements Keycloak_Service {

    @Autowired
    private WebClient.Builder webClientBuilder;

    @Value("${keycloak.domain.local.url}")
    private String keycloackLocalURL;

    @Override
    public boolean validateToken(String theToken) {
        return webClientBuilder
                .build()
                .get()
                .uri(keycloackLocalURL + "/realms/Xenon-Dev-DEV-ENV/protocol/openid-connect/token/introspect")
                .header("Authorization", "Bearer " + theToken)
                .retrieve()
                .bodyToMono(Boolean.class)
                .block();
    }
    
}
