import { APP_INITIALIZER, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {
  BrowserModule,
  provideClientHydration,
} from '@angular/platform-browser';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { routes } from './app-routing.module';
import { SweetAlert2Module } from '@sweetalert2/ngx-sweetalert2';
import { AppComponent } from './app.component';
import { LandingComponent } from './components/landing/landing.component';
import { SiteInfoComponent } from './components/site-info/site-info.component';
import { BlackJackHelpComponent } from './components/black-jack-help/black-jack-help.component';
import { BlackJackGameComponent } from './components/black-jack-game/black-jack-game.component';
import { NoDoubleClickDirective } from './directives/no-double-click.directive';
import {
  HTTP_INTERCEPTORS,
  HttpClientModule,
  provideHttpClient,
  withInterceptorsFromDi,
} from '@angular/common/http';
import { AuthInterceptorService } from './services/auth-interceptor.service';
import { AuthenticationService } from './services/authentication.service';
import { config } from 'rxjs';
import {
  KeycloakAngularModule,
  KeycloakAuthGuard,
  KeycloakBearerInterceptor,
  KeycloakService,
} from 'keycloak-angular';
import xenonDevConfig from './config/xenon-dev-config';
import { AccountProfileComponent } from './components/account-profile/account-profile.component';

export function initializeKeycloak(keycloak: KeycloakService) {
  return () =>
    keycloak
      .init({
        config: {
          url: 'http://localhost:8080', // Base Keycloak URL
          realm: xenonDevConfig.keycloak.local.realm,
          clientId: xenonDevConfig.keycloak.local.clientId,
        },
        initOptions: {
          onLoad: 'check-sso',
          silentCheckSsoRedirectUri:
            window.location.origin + '/assets/silent-check-sso.html',
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
      })
      .catch((error: unknown) => {
        console.log('sessionStorage keys', Object.keys(sessionStorage));
        console.log('localStorage keys', Object.keys(localStorage));
        console.log(
          'nonce-like keys',
          Object.keys(sessionStorage).filter((k) =>
            /nonce|state|keycloak|kc/i.test(k)
          )
        );
        console.error('Error initializing Keycloak:', error);
        return false; // Prevent app from crashing on init error
      });
}

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
    HttpClientModule,
    /*SweetAlert2Module.forRoot(),*/
    ReactiveFormsModule,
    KeycloakAngularModule,
  ],
  providers: [
    //provideClientHydration(),
    provideHttpClient(withInterceptorsFromDi()),
    {
      provide: APP_INITIALIZER,
      useFactory: initializeKeycloak,
      multi: true,
      deps: [KeycloakService],
    },
    {
      provide: HTTP_INTERCEPTORS,
      useClass: KeycloakBearerInterceptor,
      multi: true,
    },
  ],
  bootstrap: [AppComponent],
})
export class AppModule { }
