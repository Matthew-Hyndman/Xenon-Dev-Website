package com.xenon_dev.backend_server_website.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xenon_dev.backend_server_website.DAO.UserRepo;
import com.xenon_dev.backend_server_website.entity.Player_Profile;
import com.xenon_dev.backend_server_website.entity.User;

@Service
public class User_Service_Impl implements User_Service {



    @Autowired
    private UserRepo userRepo;

    /*@Override
    public User createUser(User user) {
       return userRepo.save(user);
    }*/

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
}
