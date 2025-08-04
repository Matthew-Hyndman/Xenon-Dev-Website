package com.xenon_dev.backend_server_website.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xenon_dev.backend_server_website.DAO.UserRepo;
import com.xenon_dev.backend_server_website.entity.User;

@Service
public class User_Service_Impl implements User_Service {


    //User Crud Operations

    @Autowired
    private UserRepo userRepo;

    @Override
    public User createUser(User user) {
       return userRepo.save(user);
    }

    @Override
    public Optional<User> getUserById(Long id) {
        return Optional.ofNullable(userRepo.findById(id).orElseThrow(() -> 
            new RuntimeException("User not found with id: " + id)
        ));
    }

    @Override
    public User updateUser(Long id, User user) {
        User theUser = userRepo.findById(id).orElseThrow(() -> 
            new RuntimeException("User not found with id: " + id)
        );
        theUser.setName(user.getName());
        theUser.setEmail(user.getEmail());
        // Update other fields as necessary
        return userRepo.save(theUser);
    }
    

    @Override
    public void deleteUser(Long id) {
        userRepo.deleteById(id);
    }

    @Override
    public List<User> getAllUsers() {
        return userRepo.findAll();
    }


}
