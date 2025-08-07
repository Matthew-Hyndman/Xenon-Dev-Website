package com.xenon_dev.backend_server_website.config;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import jakarta.persistence.EntityManager;
import jakarta.persistence.metamodel.EntityType;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.rest.core.config.RepositoryRestConfiguration;
import org.springframework.data.rest.webmvc.config.RepositoryRestConfigurer;
import org.springframework.http.HttpMethod;
import org.springframework.web.servlet.config.annotation.CorsRegistry;

import com.xenon_dev.backend_server_website.entity.Player_Profile;
import com.xenon_dev.backend_server_website.entity.User;


@Configuration
public class MyDataRestConfig implements RepositoryRestConfigurer {

    @Value("${allowed.origins}")
    private String[] theAllowedOrigins;

    private EntityManager entityManager;

    public MyDataRestConfig(EntityManager theEntityManager){
        entityManager = theEntityManager;
    }

    /*/
    @Override
    public void configureRepositoryRestConfiguration(RepositoryRestConfiguration config, CorsRegistry cors) {
        RepositoryRestConfigurer.super.configureRepositoryRestConfiguration(config, cors);

        HttpMethod[] theUnsupportedActions = {HttpMethod.POST, HttpMethod.PUT,
                                              HttpMethod.DELETE, HttpMethod.PATCH};

        disableHttpMethods(User.class, config, theUnsupportedActions);

        disableHttpMethods(Player_Profile.class, config, theUnsupportedActions);

        //call an internal helper method
        exposeIds(config);

        cors.addMapping(config.getBasePath() + "/**").allowedOrigins(theAllowedOrigins);

    }

    private void disableHttpMethods(Class theClass, RepositoryRestConfiguration config, HttpMethod[] theUnsupportedActions){
        config.getExposureConfiguration()
                .forDomainType(theClass)
                .withItemExposure((metdata, httpMethods) -> httpMethods.disable(theUnsupportedActions))
                .withCollectionExposure((metdata, httpMethods) -> httpMethods.disable(theUnsupportedActions));
    }


    private void exposeIds(RepositoryRestConfiguration config) {
        Set<EntityType<?>> entities = entityManager.getMetamodel().getEntities();

        List<Class> entityClasses = new ArrayList<>();

        for (EntityType entityType : entities){
            entityClasses.add(entityType.getJavaType());
        }

        Class[] domainTypes = entityClasses.toArray(new Class[0]);
        config.exposeIdsFor(domainTypes);
    }
        */

}
