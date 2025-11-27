package com.xenon_dev.backend_server_website.DAO;

import java.util.Optional;

//import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.xenon_dev.backend_server_website.entity.Player_Profile;
import com.xenon_dev.backend_server_website.entity.User;


@RepositoryRestResource
public interface UserRepo extends JpaRepository<User, String> {
    
    //Optional<Player_Profile> findPlayerProfileById(String user_id);

    //User findByEmail(String theEmail);
    
    @Query("SELECT u.player_profile FROM User u WHERE u.id = :id")
    Optional<Player_Profile> findPlayerProfileByUserId(@Param("id") String id);

}
