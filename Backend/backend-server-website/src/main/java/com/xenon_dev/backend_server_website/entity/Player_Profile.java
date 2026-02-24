package com.xenon_dev.backend_server_website.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;


@Entity
@Table(name = "player_profile")
@Getter
@Setter
public class Player_Profile {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)  
    @Column(name = "player_id")
    private Long player_id;

    @Column(name = "pot")
    private int pot;

    @Column(name = "wins")
    private int wins;

    @Column(name = "losses")
    private int losses;

}
