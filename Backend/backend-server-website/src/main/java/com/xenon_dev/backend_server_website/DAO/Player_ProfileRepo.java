package com.xenon_dev.backend_server_website.DAO;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.xenon_dev.backend_server_website.DTO.Player_ProfileDTO;
import com.xenon_dev.backend_server_website.entity.Player_Profile;


@RepositoryRestResource
public interface Player_ProfileRepo extends JpaRepository<Player_Profile, Long> {

    @Query(name = "getAccountsWithPlayerProfiles", nativeQuery = true)
    Page<Player_ProfileDTO> getAccountsWithPlayerProfiles(Pageable pageable);

}
