export default {
  keycloak: {
    local: {
      url: 'http://localhost:8080',  // Must include full Keycloak URL
      realm: 'Xenon-Dev-DEV-ENV',
      clientId: 'xenon-dev-oauth2-client-dev-env-id'
    }
  },
  SpringAPIServer: {
    local: {
      url: 'http://localhost:8443'  // Must include full Spring API Server URL
    }
  }
};
