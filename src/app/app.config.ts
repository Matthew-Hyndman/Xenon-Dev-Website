import { APP_INITIALIZER, ApplicationConfig } from '@angular/core';
import { provideRouter } from '@angular/router';

import { routes } from './app-routing.module';

import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { AuthInterceptorService } from './services/auth-interceptor.service';
import {
  customBearerTokenInterceptor,
  CUSTOM_BEARER_TOKEN_INTERCEPTOR_CONFIG,
} from 'keycloak-angular';
//import { initializeKeycloak } from './app.module';
import { KeycloakConfig } from 'keycloak-js';

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    provideHttpClient(withInterceptors([customBearerTokenInterceptor])),
    {
      provide: CUSTOM_BEARER_TOKEN_INTERCEPTOR_CONFIG,
      useValue: [
        {
          shouldAddToken: async (req : Request, next : any, keycloak : KeycloakConfig) => {
            const url = req.url ?? '';
            if (url.includes('/assets') || url.includes('silent-check-sso.html')) {
              return false;
            }
            return true;
          },
        },
      ],
    },    
  ],
};
