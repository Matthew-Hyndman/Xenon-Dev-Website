import { APP_INITIALIZER, ApplicationConfig, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {
  BrowserModule,
  provideClientHydration,
} from '@angular/platform-browser';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RouterModule, RouterOutlet } from '@angular/router';
import { AppRoutingModule, routes } from './app-routing.module';
import { SweetAlert2Module } from '@sweetalert2/ngx-sweetalert2';
import { AppComponent } from './app.component';
import { LandingComponent } from './components/landing/landing.component';
import { SiteInfoComponent } from './components/site-info/site-info.component';
import { BlackJackHelpComponent } from './components/black-jack-help/black-jack-help.component';
import { BlackJackGameComponent } from './components/black-jack-game/black-jack-game.component';
import { NoDoubleClickDirective } from './directives/no-double-click.directive';
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { AuthInterceptorService } from './services/auth-interceptor.service';
import {  
  customBearerTokenInterceptor,
  CUSTOM_BEARER_TOKEN_INTERCEPTOR_CONFIG,
  provideKeycloak,
  ProvideKeycloakOptions,
} from 'keycloak-angular';
import xenonDevConfig from './config/xenon-dev-config';
import { AccountProfileComponent } from './components/account-profile/account-profile.component';

@NgModule({
  declarations: [
    AppComponent,
    LandingComponent,
    SiteInfoComponent,
    BlackJackHelpComponent,
    BlackJackGameComponent,
    NoDoubleClickDirective,
    AccountProfileComponent,
  ],
  imports: [
    CommonModule,
    BrowserModule,
    FormsModule,
    ReactiveFormsModule,
    //KeycloakAngularModule,
    AppRoutingModule
  ],
  providers: [    
    // Register the HttpClient and the new functional Keycloak interceptor
    provideHttpClient(withInterceptors([customBearerTokenInterceptor])),
    // Configure the custom interceptor to skip adding the bearer for static assets / silent-check file
    {
      provide: CUSTOM_BEARER_TOKEN_INTERCEPTOR_CONFIG,
      useValue: [
        {
          shouldAddToken: async (req: Request, next: any, keycloak: any) => {
            const url = req.url ?? '';
            // exclude static assets and the silent check file
            if (url.includes('/assets') || url.includes('silent-check-sso.html')) {
              return false;
            }
            return true;
          },
        },
      ],
    },
    provideKeycloak({
      config: {
        url: 'http://localhost:8080',
        realm: xenonDevConfig.keycloak.local.realm,
        clientId: xenonDevConfig.keycloak.local.clientId,
      },
      initOptions: {
        onLoad: 'check-sso',
        silentCheckSsoRedirectUri: window.location.origin + '/assets/silent-check-sso.html',
        pkceMethod: 'S256',
        flow: 'standard',
        enableLogging: true,
        checkLoginIframe: false,
        responseMode: 'fragment',
        redirectUri: window.location.origin + '/landing',
        useNonce: false,
      },
      loadUserProfileAtStartUp: false,
      bearerExcludedUrls: ['/assets', '/silent-check-sso.html'],
    } as ProvideKeycloakOptions),
  ],
  bootstrap: [AppComponent],
})
export class AppModule { }
