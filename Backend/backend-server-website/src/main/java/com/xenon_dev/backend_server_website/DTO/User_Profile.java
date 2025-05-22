package com.xenon_dev.backend_server_website.DTO;

import lombok.Data;

import com.xenon_dev.backend_server_website.entity.User;
import com.xenon_dev.backend_server_website.entity.Player_Profile;

@Data
public class User_Profile {
    private User user;
    private Player_Profile player_Profile;
}
