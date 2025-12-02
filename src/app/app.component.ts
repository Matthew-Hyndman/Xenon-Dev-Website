import { Component, HostListener } from '@angular/core';
import { RouterOutlet } from '@angular/router';
//import { TodosComponent } from './todos/todos.component';
import { Amplify } from 'aws-amplify';
//import outputs from '../../amplify_outputs.json';
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

//Amplify.configure(outputs);

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrl: './app.component.css',
    standalone: false
})
export class AppComponent {
  shouldShowMobileNav: boolean = false;

  title = 'Xenon-Dev';
  links!: LinkObj[];

  constructor(private navLinks: NavLinks) {
    this.links = this.navLinks.links;
  }

  toggleMobileNav() {
    this.shouldShowMobileNav = !this.shouldShowMobileNav;
  }

  setShouldShowMobileNavToFalse(){
    this.shouldShowMobileNav = false;
  }

  @HostListener('document:scroll', ['$event'])
    onDocumentMousewheelEvent(event: any){
      if (this.shouldShowMobileNav) {
        this.shouldShowMobileNav = false;
      }
    }

  /*title = 'amplify-angular-template';

  constructor(public authenticator: AuthenticatorService) {
    Amplify.configure(outputs);
  }*/
}
