package com.xenon_dev.backend_server_website.DAO;

//import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;


import com.xenon_dev.backend_server_website.entity.User;


@RepositoryRestResource
public interface UserRepo extends JpaRepository<User, Long> {
    
    User findByEmail(String theEmail);

}
