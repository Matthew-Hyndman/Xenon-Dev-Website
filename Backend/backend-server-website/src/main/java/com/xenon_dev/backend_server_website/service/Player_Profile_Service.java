package com.xenon_dev.backend_server_website.service;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.xenon_dev.backend_server_website.DTO.Player_ProfileDTO;
import com.xenon_dev.backend_server_website.entity.Player_Profile;

public interface Player_Profile_Service {
    
    //Player Profile Views
    Page<Player_ProfileDTO> getAccountsWithPlayerProfiles_view(Pageable pageable);

    //Player Profile Crud Operations

    Player_Profile createPlayerProfile(Player_Profile player_profile);

    Optional<Player_Profile> getPlayerProfileById(Long id);

    Player_Profile updatePlayerProfile(Long id, Player_Profile player_profile);

    void deletePlayerProfile(Long id);

    List<Player_Profile> getAllPlayerProfiles();
}
