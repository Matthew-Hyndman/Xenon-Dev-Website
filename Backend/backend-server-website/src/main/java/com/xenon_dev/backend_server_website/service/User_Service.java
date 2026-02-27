package com.xenon_dev.backend_server_website.service;

import java.util.List;
import java.util.Optional;

import com.xenon_dev.backend_server_website.entity.Player_Profile;
import com.xenon_dev.backend_server_website.entity.User;

public interface User_Service {

    Optional<User> getUserById(String id);

    Optional<Player_Profile> getPlayerProfileByUserId(String id);

    List<User> getAllUsers();

    void deleteUserById(String id);

}
