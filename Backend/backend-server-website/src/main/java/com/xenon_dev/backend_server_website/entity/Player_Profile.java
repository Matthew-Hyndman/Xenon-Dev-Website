package com.xenon_dev.backend_server_website.entity;

import org.hibernate.annotations.ColumnDefault;

import com.xenon_dev.backend_server_website.DTO.Player_ProfileDTO;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;


@Entity
@Table(name = "player_profile")
@Getter
@Setter
@SqlResultSetMapping(
    name = "PlayerProfileMapping",
    classes = @ConstructorResult(
        targetClass = Player_ProfileDTO.class,
        columns = {
            @ColumnResult(name = "USERNAME", type = String.class),
            @ColumnResult(name = "wins", type = Integer.class),
            @ColumnResult(name = "losses", type = Integer.class),
            @ColumnResult(name = "pot", type = Integer.class)
        }
    )
)
@NamedNativeQuery(
    name = "getAccountsWithPlayerProfiles",
    query = "SELECT * FROM accounts_with_player_profiles_view",
    resultSetMapping = "PlayerProfileMapping"
)
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
