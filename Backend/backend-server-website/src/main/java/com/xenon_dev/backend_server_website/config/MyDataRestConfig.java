package com.xenon_dev.backend_server_website.config;

//import jakarta.persistence.EntityManager;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.rest.webmvc.config.RepositoryRestConfigurer;


@Configuration
public class MyDataRestConfig implements RepositoryRestConfigurer {

    @Value("${allowed.origins}")
    private String[] theAllowedOrigins;

    /*private EntityManager entityManager;

    public MyDataRestConfig(EntityManager theEntityManager){
        entityManager = theEntityManager;
    }*/

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
