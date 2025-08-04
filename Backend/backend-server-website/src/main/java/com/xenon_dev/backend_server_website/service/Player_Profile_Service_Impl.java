package com.xenon_dev.backend_server_website.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;

import com.xenon_dev.backend_server_website.DAO.Player_ProfileRepo;
import com.xenon_dev.backend_server_website.entity.Player_Profile;

public class Player_Profile_Service_Impl  implements Player_Profile_Service {
    
    //Player Profile Crud Operations

    @Autowired
    private Player_ProfileRepo playerProfileRepo;

    @Override
    public void createPlayerProfile(Player_Profile player_profile) {
        playerProfileRepo.save(player_profile);
    }

    @Override
    public Optional<Player_Profile> getPlayerProfileById(Long id) {
        return playerProfileRepo.findById(id);
    }

    @Override
    public void updatePlayerProfile(Player_Profile player_profile) {
        playerProfileRepo.save(player_profile);
    }

    @Override
    public void deletePlayerProfile(Long id) {
        playerProfileRepo.deleteById(id);
    }

    @Override
    public List<Player_Profile> getAllPlayerProfiles() {
        return playerProfileRepo.findAll();
    }

    
}
