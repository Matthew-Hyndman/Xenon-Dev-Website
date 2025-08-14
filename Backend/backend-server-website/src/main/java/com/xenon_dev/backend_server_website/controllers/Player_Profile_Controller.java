package com.xenon_dev.backend_server_website.controllers;

import com.xenon_dev.backend_server_website.entity.Player_Profile;
import com.xenon_dev.backend_server_website.entity.User;
import com.xenon_dev.backend_server_website.service.Player_Profile_Service_Impl;
import com.xenon_dev.backend_server_website.service.User_Service_Impl;

import java.util.List;
import java.util.Optional;
import java.util.function.Supplier;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/player")
public class Player_Profile_Controller {

    @Autowired
    private Player_Profile_Service_Impl playerService;

    @Autowired
    private User_Service_Impl userService;

    @GetMapping("getAllPlayers")
    public ResponseEntity<List<Player_Profile>> getAllPlayers() {
        List<Player_Profile> players = playerService.getAllPlayerProfiles();
        return ResponseEntity.ok(players);
    }

    @GetMapping("getPlayerDetails/{id}")
    public ResponseEntity<Player_Profile> getPlayerDetailsWithId(@PathVariable Long id) {
        Optional<Player_Profile> player = playerService.getPlayerProfileById(id);
        return player.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());

    }

    // why are am I creating a player profile with a request body? they all start
    // the same lol
    @PostMapping("createPlayer/{user_id}")
    public ResponseEntity<User> createPlayer(@PathVariable Long user_id) {

        // Create a new Player_Profile with default values
        Player_Profile player = new Player_Profile();
        player.setPot(3000);
        player.setWins(0);
        player.setLosses(0);

        try {
            // ensure user exists
            User theUser = userService.getUserById(user_id)
                    .orElseThrow(() -> new RuntimeException("User not found with id: " + user_id));

            Player_Profile thePlayer = playerService.createPlayerProfile(player);

            theUser.setPlayer_profile(thePlayer);
            userService.saveUser(theUser);
            return ResponseEntity.ok(theUser);

        } catch (RuntimeException e) {
            System.err.println(e.toString());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }

    @PatchMapping("updatePlayer/{id}")
    public ResponseEntity<Player_Profile> updatePlayer_Profile(@PathVariable Long id,
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
