package com.xenon_dev.backend_server_website.service;

import java.util.List;
import java.util.Optional;

import com.xenon_dev.backend_server_website.entity.User;

public interface User_Service {
   
    //User Crud Operations

    User createUser(User user);

    Optional<User> getUserById(Long id);

    User updateUser(Long id, User user);

    void deleteUser(Long id);

    List<User> getAllUsers();

}
