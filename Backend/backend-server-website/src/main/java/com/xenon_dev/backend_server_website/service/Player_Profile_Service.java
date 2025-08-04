package com.xenon_dev.backend_server_website.service;

import java.util.List;
import java.util.Optional;

import com.xenon_dev.backend_server_website.entity.Player_Profile;

public interface Player_Profile_Service {
    
    //Player Profile Crud Operations

    void createPlayerProfile(Player_Profile player_profile);

    Optional<Player_Profile> getPlayerProfileById(Long id);

    void updatePlayerProfile(Player_Profile player_profile);

    void deletePlayerProfile(Long id);

    List<Player_Profile> getAllPlayerProfiles();
}
