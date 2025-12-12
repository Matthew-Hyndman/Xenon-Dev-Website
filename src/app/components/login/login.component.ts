import { Component, OnInit } from '@angular/core';

import { AuthenticationService } from '../../services/authentication.service';
import { Router } from '@angular/router';
import xenonDevConfig from '../../config/xenon-dev-config';
import { KeycloakProfile } from 'keycloak-js';
import { ProvideKeycloakOptions, provideKeycloak } from 'keycloak-angular';


@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrl: './login.component.css',
})
export class LoginComponent implements OnInit {

  //private readonly app = inject(AppModule);

  public isLoggedIn = false;


  public userProfile: KeycloakProfile | null = null;


  constructor(private authService: AuthenticationService, 
              private router: Router,
            ) { 
    
  }

  public async ngOnInit() {
    
  }

  

}

