package com.xenon_dev.backend_server_website.controllers;

import org.springframework.web.bind.annotation.RestController;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;

import com.xenon_dev.backend_server_website.service.User_Service_Impl;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;




@RestController
@RequestMapping("/api/user")
@PreAuthorize("hasRole('User') or hasRole('Admin')")
public class User_Controller  {
    
    @Autowired
    private User_Service_Impl userService;

    @DeleteMapping("delete/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable String id) {
        userService.deleteUserById(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

}
