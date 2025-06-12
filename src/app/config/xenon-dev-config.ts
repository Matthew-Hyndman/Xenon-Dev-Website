export default {
    oidc:{
        clientId: '0oap2h5p84zmYRuLe5d7',
        issuer: 'https://dev-16855930.okta.com/oauth2/default',
        redirectUri: 
            'http://localhost:4200/login/callback'
            //, 'https://www.xenon-dev.com/login/callbck' use this in production
        ,
        scopes: ['openid', 'profile', 'email']
    }
}
