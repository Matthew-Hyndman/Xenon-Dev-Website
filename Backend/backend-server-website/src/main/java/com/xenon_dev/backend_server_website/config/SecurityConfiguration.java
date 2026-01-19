package com.xenon_dev.backend_server_website.config;

import java.util.Arrays;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;

import com.xenon_dev.backend_server_website.config.custom_filters.checkKeycloakTokenFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(securedEnabled = true)
public class SecurityConfiguration {
    
    @Value("${allowed.origins}")
    private String[] theAllowedOrigins;

    @Bean
    SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.authorizeHttpRequests(requests ->
                requests
                        .anyRequest().authenticated()
        );                
        
        CorsConfiguration corsConfig = new CorsConfiguration();
        corsConfig.setAllowedOrigins(Arrays.asList(theAllowedOrigins)); 
        corsConfig.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "PATCH"));
        corsConfig.setAllowedHeaders(Arrays.asList("Authorization", "Content-Type"));
        corsConfig.setAllowCredentials(true);
        
        http.addFilter(new checkKeycloakTokenFilter());

        http.cors(cors -> cors.configurationSource(request -> corsConfig));
        http.csrf(AbstractHttpConfigurer::disable);
        http.oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt -> jwt.jwtAuthenticationConverter(jwtAuthenticationConverter())));
        
        return http.build();
    }

    /**
     * Configures JWT authentication converter to extract authorities from Keycloak token
     */
    @Bean
    public JwtAuthenticationConverter jwtAuthenticationConverter() {
        JwtGrantedAuthoritiesConverter authoritiesConverter = new JwtGrantedAuthoritiesConverter();
        authoritiesConverter.setAuthoritiesClaimName("roles");
        authoritiesConverter.setAuthorityPrefix("ROLE_");

        JwtAuthenticationConverter jwtAuthenticationConverter = new JwtAuthenticationConverter();
        jwtAuthenticationConverter.setJwtGrantedAuthoritiesConverter(authoritiesConverter);
        return jwtAuthenticationConverter;
    }   
}


