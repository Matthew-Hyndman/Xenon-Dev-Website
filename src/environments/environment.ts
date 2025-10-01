import xenonDevConfig from '../app/config/xenon-dev-config';

export const environment = {
    production: false,

    //local URL Dev
    xenonDevApiURL: 'http://localhost:8443',
    localKeycloakURL: `http://localhost:8080/realms/${xenonDevConfig.keycloak.local.realm}`,

    //AWS URL Dev

    //AWS URL Production
    //xenonDevApiURL: 'https://xenon-dev.com'
}