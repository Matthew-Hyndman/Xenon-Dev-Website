import {
  Component,
  HostListener,
} from '@angular/core';
//import { TodosComponent } from './todos/todos.component';
//import outputs from '../../amplify_outputs.json';
import { NavLinks } from './common/nav-links';
import { LinkObj } from './common/link-obj';
//import { a } from '@aws-amplify/backend';
import { AuthenticationService } from './services/authentication.service';

//Amplify.configure(outputs);

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.css',
  standalone: false
  //imports: [RouterOutlet, /*TodosComponent, AmplifyAuthenticatorModule,*/ MiniNavMenuComponent],
})
export class AppComponent {
  title = 'Xenon-Dev';
  links!: LinkObj[];

  protected shouldShowMobileNav: boolean = false;
  protected isLoggedInToSession: boolean = false;

  private loggedInNavLinksEnabled: boolean = false;

  constructor(
    private navLinks: NavLinks,
    private authService: AuthenticationService
  ) {
    this.links = this.navLinks.links;
    this.isLoggedInCheck();

    // Enable profile and logout links if logged in
    if (this.isLoggedInToSession) {
     this.toggleLoggedInLinks(); 
    }
}

  toggleLoggedInLinks() {
    this.navLinks.links.filter((link) => {
        if (link.name === 'Profile' || link.name === 'Logout') {
          link.enable = !this.loggedInNavLinksEnabled;
        } else if (link.name === 'Login') {
          link.enable = this.loggedInNavLinksEnabled;
        }
  });
    this.loggedInNavLinksEnabled = !this.loggedInNavLinksEnabled;
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
