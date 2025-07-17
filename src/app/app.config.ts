import { ApplicationConfig } from '@angular/core';
import { provideRouter } from '@angular/router';

import { routes } from './app-routing.module';

import OktaAuth from '@okta/okta-auth-js';
import xenonDevConfig from '../app/config/xenon-dev-config';
import { OktaAuthOptions } from '@okta/okta-auth-js';
import { OKTA_CONFIG } from '@okta/okta-angular';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { AuthInterceptorService } from './services/auth-interceptor.service';



const oktaConfig: OktaAuthOptions = xenonDevConfig.oidc;

const oktaAuth = new OktaAuth(oktaConfig);

export const appConfig: ApplicationConfig = {
  providers: [provideRouter(routes),
    {provide: OKTA_CONFIG, useValue: {oktaAuth}},
    {provide: HTTP_INTERCEPTORS, useClass: AuthInterceptorService, multi: true}
  ]
};
