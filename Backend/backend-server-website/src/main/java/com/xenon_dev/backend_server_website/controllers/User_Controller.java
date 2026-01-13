package com.xenon_dev.backend_server_website.controllers;

import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import com.xenon_dev.backend_server_website.entity.Player_Profile;
import com.xenon_dev.backend_server_website.entity.User;
import com.xenon_dev.backend_server_website.service.User_Service_Impl;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;




@RestController
@RequestMapping("/api/user")
public class User_Controller  {
    
    @Autowired
    private User_Service_Impl userService;

    

@GetMapping("getPlayerDetails/{id}")
    public ResponseEntity<Player_Profile> getPlayerDetailsWithId(@PathVariable String id) {
        Optional<Player_Profile> player = userService.getPlayerProfileByUserId(id);
        return player.map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.NO_CONTENT).build());

    }
}
