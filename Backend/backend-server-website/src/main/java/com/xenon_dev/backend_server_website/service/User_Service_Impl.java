package com.xenon_dev.backend_server_website.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.xenon_dev.backend_server_website.DAO.UserRepo;
import com.xenon_dev.backend_server_website.entity.Player_Profile;
import com.xenon_dev.backend_server_website.entity.User;

@Service
public class User_Service_Impl implements User_Service {    

    @Autowired
    private UserRepo userRepo;

    @Value("${keycloak.realm}")
    private String keycloakRealm;

    @Value("${keycloak.uri}")
    private String keycloakUri;

    private RestTemplate restTemplate = new RestTemplate();

    @Override
    public Optional<User> getUserById(String id) {
        return Optional.ofNullable(userRepo.findById(id).orElseThrow(() -> 
            new RuntimeException("User not found with id: " + id)
        ));
    }

    @Override
    public List<User> getAllUsers() {
        return userRepo.findAll();
    }

    public User saveUser(User user) {
        return userRepo.save(user);
    }

    @Override
    public Optional<Player_Profile> getPlayerProfileByUserId(String id) {
        return userRepo.findPlayerProfileByUserId(id);        
    }

      @Override
    public void deleteUserById(String id) {
        String url = keycloakUri + "/admin/realms/" + keycloakRealm + "/users/" + id;
        // Implement the logic to send a DELETE request to the Keycloak server using the constructed URL
        restTemplate.delete(url);
    }


}
