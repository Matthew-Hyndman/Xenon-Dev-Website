package com.xenon_dev.backend_server_website.controllers;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.xenon_dev.backend_server_website.DTO.Leader_Board_DTO;
import com.xenon_dev.backend_server_website.entity.Player_Profile;
import com.xenon_dev.backend_server_website.entity.User;
import com.xenon_dev.backend_server_website.service.Player_Profile_Service_Impl;
import com.xenon_dev.backend_server_website.service.User_Service_Impl;


@RestController
@RequestMapping("/api/player")
//@PreAuthorize("hasRole('ROLE_User') or hasRole('ROLE_Admin')")
public class Player_Profile_Controller {

    private User_Service_Impl user_Service_Impl;

    @Autowired
    private Player_Profile_Service_Impl playerService;

    // private User_Service userService;

    @Autowired
    public void UserController(User_Service_Impl user_Service_Impl) {
        this.user_Service_Impl = user_Service_Impl;
    }

    @GetMapping("leaderboard")
    public ResponseEntity<Page<Leader_Board_DTO>> getleaderboard(
        @RequestParam(defaultValue="0") int page, 
        @RequestParam(defaultValue="10") int size
    ) {
        Pageable pageable = PageRequest.of(page, size);
        return ResponseEntity.ok(playerService.getAccountsWithPlayerProfiles_view(pageable));
        /*playerService.getAccountsWithPlayerProfiles_view(pageable)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.NOT_FOUND).build());*/
                
    }
    

    @GetMapping("getAllPlayers")
    public ResponseEntity<List<Player_Profile>> getAllPlayers() {
        List<Player_Profile> players = playerService.getAllPlayerProfiles();
        return ResponseEntity.ok(players);
    }

    @GetMapping("getPlayerDetails/{userId}")
    public ResponseEntity<Player_Profile> getPlayerDetails(@PathVariable String userId) {
        return user_Service_Impl.getPlayerProfileByUserId(userId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.NOT_FOUND).build());
    }

    @PostMapping("createPlayer/{user_id}")
    public ResponseEntity<Player_Profile> createPlayer(@PathVariable String user_id,
            @RequestBody Player_Profile thePlayerProfile) {
        try {
            // ensure user exists
            User theUser = user_Service_Impl.getUserById(user_id)
                    .orElseThrow(() -> new RuntimeException("User not found with id: " + user_id));

            Player_Profile thePlayer = playerService.createPlayerProfile(thePlayerProfile);

            theUser.setPlayer_profile(thePlayer);
            user_Service_Impl.saveUser(theUser);

            return ResponseEntity.ok(thePlayer);

        } catch (RuntimeException e) {
            System.err.println(e.toString());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }

    }

    @PatchMapping("updatePlayer/{id}")
    public ResponseEntity<Player_Profile> updatePlayer_Profile(
            @PathVariable Long id,
            @RequestBody Player_Profile player) {
        try {
            return ResponseEntity.ok(playerService.updatePlayerProfile(id, player));
        } catch (RuntimeException e) {
            System.err.println(e.toString());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    @PutMapping("resetPlayer/{id}")
    public ResponseEntity<Player_Profile> resetPlayer(@PathVariable Long id) {
        Player_Profile player = playerService.getPlayerProfileById(id)
                .orElseThrow(() -> new RuntimeException("Player not found with id: " + id));

        // Reset player profile to default values
        player.setPot(3000);
        player.setWins(0);
        player.setLosses(0);

        try {
            return ResponseEntity.ok(playerService.updatePlayerProfile(id, player));
        } catch (RuntimeException e) {
            System.err.println(e.toString());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }
}
