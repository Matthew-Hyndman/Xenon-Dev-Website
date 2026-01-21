package com.xenon_dev.backend_server_website.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.client.MultipartBodyBuilder;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.BodyInserter;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

@Service
public class Keycloak_Service_Impl implements Keycloak_Service {

    @Autowired
    private WebClient.Builder webClientBuilder;

    @Value("${keycloak.domain.local.url}")
    private String keycloackLocalURL;

    @Override
    public boolean validateToken(Map<String, String> theHeaders) {
        try {
        //request context
        MultipartBodyBuilder builder = new MultipartBodyBuilder();
        builder.part("client_id", theHeaders.get("client_id"));
        builder.part("client_secret", theHeaders.get("client_secret"));
            
        boolean response = webClientBuilder
                .build()
                .post()
                .uri(keycloackLocalURL + "/realms/Xenon-Dev-DEV-ENV/protocol/openid-connect/token/introspect")
                .header("Authorization", theHeaders.get("Authorization"))
                .body(BodyInserters.fromMultipartData(builder.build()))
                .retrieve()
                .bodyToMono(Boolean.class)
                .block();
                return response;
        } catch (WebClientResponseException e) {
            System.out.println("Token valiation failed: " + e.getMessage());
            return false;
        }
    }
    
}
