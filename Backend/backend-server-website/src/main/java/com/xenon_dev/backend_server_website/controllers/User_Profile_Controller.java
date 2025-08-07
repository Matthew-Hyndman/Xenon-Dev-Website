package com.xenon_dev.backend_server_website.controllers;

import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import com.xenon_dev.backend_server_website.entity.User;
import com.xenon_dev.backend_server_website.service.User_Service_Impl;

import jakarta.validation.Valid;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PutMapping;




@RestController
@RequestMapping("/api/user_profile")
public class User_Profile_Controller  {
    
    @Autowired
    private User_Service_Impl userService;

@GetMapping("getAllUsers")
public ResponseEntity<List<User>> getAllUsers() {
    List<User> users = userService.getAllUsers();
    return ResponseEntity.ok(users);
}

@GetMapping("getUserDetails/{id}")
public ResponseEntity<User> getUserDetailsWithId(@PathVariable Long id) {
    Optional<User> user = userService.getUserById(id);
    return  user.map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());

}

@PostMapping("createUser")
public ResponseEntity<User> createUser(@Valid @RequestBody User user) {

    try {
        User theUser = userService.createUser(user);
        return ResponseEntity.ok(theUser);
    } catch (Exception e) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
    }
}

@PutMapping("updateUser/{id}")
public ResponseEntity<User> putMethodName(@PathVariable Long id, @RequestBody User user) {
    try {
        return ResponseEntity.ok(userService.updateUser(id , user));
    } catch (RuntimeException e) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }
}

@DeleteMapping("deleteUser/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        try {
            userService.deleteUser(id);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    /*@GetMapping("getUserByEmail/{email}")
    public ResponseEntity<User> getUserByEmail(@PathVariable String email) {
        
    }*/
}
