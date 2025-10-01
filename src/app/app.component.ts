import {
  APP_INITIALIZER,
  Component,
  HostListener,
  inject,
  OnInit,
} from '@angular/core';
import { RouterOutlet } from '@angular/router';
//import { TodosComponent } from './todos/todos.component';
import { Amplify } from 'aws-amplify';
import outputs from '../../amplify_outputs.json';
import {
  AmplifyAuthenticatorModule,
  AuthenticatorService,
} from '@aws-amplify/ui-angular';
import { MiniNavMenuComponent } from './components/mini-nav-menu/mini-nav-menu.component';
import { NavLinks } from './common/nav-links';
import { LinkObj } from './common/link-obj';
import { routes } from './app-routing.module';
import { LandingComponent } from './components/landing/landing.component';
import { a } from '@aws-amplify/backend';
import { auth } from '../../amplify/auth/resource';
import { AuthenticationService } from './services/authentication.service';
import { KeycloakAngularModule, KeycloakService } from 'keycloak-angular';
import { KeycloakProfile } from 'keycloak-js';
import { AppModule } from './app.module';
import xenonDevConfig from './config/xenon-dev-config';

Amplify.configure(outputs);

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.css',
})
export class AppComponent {
  title = 'Xenon-Dev';
  links!: LinkObj[];

  protected shouldShowMobileNav: boolean = false;
  protected isLoggedInToSession: boolean = false;

  constructor(
    private navLinks: NavLinks,
    private authService: AuthenticationService
  ) {
    this.links = this.navLinks.links;
    this.isLoggedInCheck();
  }

  toggleMobileNav() {
    this.shouldShowMobileNav = !this.shouldShowMobileNav;
  }

  setShouldShowMobileNavToFalse() {
    this.shouldShowMobileNav = false;
  }

  @HostListener('document:scroll', ['$event'])
  onDocumentMousewheelEvent(event: any) {
    if (this.shouldShowMobileNav) {
      this.shouldShowMobileNav = false;
    }
  }

  login() {
    this.authService.login();
  }

  logout() {
    this.authService.logout();
  }

  isLoggedInCheck() {
    try{
    this.authService.isLoggedIn$.subscribe((result) => {
      this.isLoggedInToSession = result ?? false;
    });
  } catch(error){
    console.error('Could not read if session is created: ', error)
  }
  
    
  }
}
