package com.xenon_dev.backend_server_website.service;

import java.util.Map;

public interface Keycloak_Service {
    
    boolean validateToken(Map<String, String> theHeaders);

}
