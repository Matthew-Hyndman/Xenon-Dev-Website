import { Component, Inject, OnInit } from '@angular/core';
import { OKTA_AUTH, OktaAuthStateService } from '@okta/okta-angular';
import OktaAuth from '@okta/okta-auth-js';
import OktaSignIn from '@okta/okta-signin-widget';
import xenonDevConfig from '../../config/xenon-dev-config';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css',
})
export class LoginComponent implements OnInit {
  oktaSignin: any;

  constructor(
    private oktaAuthService: OktaAuthStateService,
    @Inject(OKTA_AUTH) private oktaAuth: OktaAuth
  ) {
    this.oktaSignin = new OktaSignIn({
      logo: 'assets/images/logo-title.png',
      baseUrl: xenonDevConfig.oidc.issuer.split('/oauth2')[0],
      redirectUri: xenonDevConfig.oidc.redirectUri,
      useClassicEngine: true,
      authPrams: {
        pkce: true,
        issuer: xenonDevConfig.oidc.issuer,
        scopes: xenonDevConfig.oidc.scopes,
      },
    });
  }

  ngOnInit(): void {
    this.oktaSignin.remove();

    this.oktaSignin.renderEl(
      {
        el: '#okta-sign-in-widget',
      },
      (response: any) => {
        if (response.status === 'SUCCESS') {
          this.oktaAuth.signInWithRedirect();
        }
      },
      (error: any) => {
        throw error;
      }
    );
  }
}
