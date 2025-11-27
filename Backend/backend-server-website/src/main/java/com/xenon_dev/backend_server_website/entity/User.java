package com.xenon_dev.backend_server_website.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "user_entity")
@Getter
@Setter
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", length = 36)
    private String id;    

    @Column(name = "EMAIL_CONSTRAINT")
    private String email;

    @Column(name = "EMAIL_VERIFIED")
    private Boolean emailVerified;

    @Column(name = "ENABLED")
    private Boolean enabled;

    @Column(name = "FEDERATION_LINK")
    private String federationLink;

    @Column(name = "FIRST_NAME")
    private String firstName;

    @Column(name = "LAST_NAME")
    private String lastName;

    @Column(name = "REALM_ID")
    private String realmId;

    @Column(name = "USERNAME")
    private String username;

    @Column(name = "CREATED_TIMESTAMP")
    private Long createdTimestamp;

    @Column(name = "SERVICE_ACCOUNT_CLIENT_LINK")
    private String serviceAccountClientLink;

    @Column(name = "NOT_BEFORE")
    private Long notBefore;

    @OneToOne(cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "PLAYER_PROFILE_ID", referencedColumnName = "player_id")
    private Player_Profile player_profile;
}
