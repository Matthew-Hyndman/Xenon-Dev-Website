package com.xenon_dev.backend_server_website.DAO;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.xenon_dev.backend_server_website.DTO.Player_ProfileDTO;
import com.xenon_dev.backend_server_website.entity.Player_Profile;


@RepositoryRestResource
public interface Player_ProfileRepo extends JpaRepository<Player_Profile, Long> {

    @Query(name = "getAccountsWithPlayerProfiles", nativeQuery = true)
    Optional<List<Player_ProfileDTO>> getAccountsWithPlayerProfiles();

}
