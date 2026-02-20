package com.xenon_dev.backend_server_website.DAO;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.xenon_dev.backend_server_website.DTO.Leader_Board_DTO;
import com.xenon_dev.backend_server_website.entity.Player_Profile;


@RepositoryRestResource
public interface Player_ProfileRepo extends JpaRepository<Player_Profile, Long> {

    @Query(value = "SELECT USERNAME, wins, losses, pot " +
                   "FROM accounts_with_player_profiles_view " +
                   "ORDER BY pot DESC, wins DESC",
           countQuery = "SELECT COUNT(*) FROM accounts_with_player_profiles_view",
           nativeQuery = true)
    Page<Object[]> getAccountsWithPlayerProfiles(Pageable pageable);

}
