package com.xenon_dev.backend_server_website.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xenon_dev.backend_server_website.DAO.Player_ProfileRepo;
import com.xenon_dev.backend_server_website.DTO.Player_ProfileDTO;
import com.xenon_dev.backend_server_website.entity.Player_Profile;

@Service
public class Player_Profile_Service_Impl  implements Player_Profile_Service {
    
    //Player Profile Views
    @Override
    public Optional<List<Player_ProfileDTO>> getAccountsWithPlayerProfiles_view(){
        return playerProfileRepo.getAccountsWithPlayerProfiles();
    }

    //Player Profile Crud Operations

    @Autowired
    private Player_ProfileRepo playerProfileRepo;

    @Override
    public Player_Profile createPlayerProfile(Player_Profile player_profile) {
        return playerProfileRepo.save(player_profile);
    }

    @Override
    public Optional<Player_Profile> getPlayerProfileById(Long id) {
        return playerProfileRepo.findById(id);
    }

    @Override
    public Player_Profile updatePlayerProfile(Long id, Player_Profile player_profile) {
        Player_Profile thePlayer_Profile = playerProfileRepo.findById(id).orElseThrow(() -> 
            new RuntimeException("Player Profile not found with id: " + id)
        );

        thePlayer_Profile.setWins(player_profile.getWins());
        thePlayer_Profile.setLosses(player_profile.getLosses());
        thePlayer_Profile.setPot(player_profile.getPot());

        return playerProfileRepo.save(thePlayer_Profile);
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
