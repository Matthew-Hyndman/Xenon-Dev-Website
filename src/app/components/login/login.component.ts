import { APP_INITIALIZER, Component, inject, OnInit } from '@angular/core';

import { AuthenticationService } from '../../services/authentication.service';
import { Router } from '@angular/router';
import { KeycloakService } from 'keycloak-angular';
import xenonDevConfig from '../../config/xenon-dev-config';
import { KeycloakProfile } from 'keycloak-js';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrl: './login.component.css',
})
export class LoginComponent implements OnInit {

  private readonly keycloak = inject(KeycloakService);

  public isLoggedIn = false;


  public userProfile: KeycloakProfile | null = null;


  constructor(private authService: AuthenticationService, private router: Router) { 
    //initializeKeycloak(this.keycloak);
    
    //if (!this.authService.isLoggedIn()) {      
      //this.authService.init();
    //}
    //this.router.navigate(['landing']);
  }

  public async ngOnInit() {
    await this.keycloak.login();
    /*this.isLoggedIn = await this.keycloak.isLoggedIn();

    if (this.isLoggedIn) {
      this.userProfile = await this.keycloak.loadUserProfile();
    }*/
  }

}

