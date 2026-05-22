import { Component, HostListener } from '@angular/core';
//import { TodosComponent } from './todos/todos.component';
import { NavLinks } from './common/nav-links';
import { LinkObj } from './common/link-obj';
import { AwsLoginService } from './services/aws-login.service';
import { Router } from '@angular/router';
import { Hub } from 'aws-amplify/utils';

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
    private router: Router,
    private navLinks: NavLinks,
    private awsLoginService: AwsLoginService
  ) {
    this.links = this.navLinks.links;
    this.isLoggedInCheck();

    Hub.listen('auth', ({ payload }) => {
      if (payload.event === 'signedIn') {
        this.router.navigate(['/landing']);
      }
    });
  }

  toggleLoggedInLinks() {
    this.loggedInNavLinksEnabled = !this.loggedInNavLinksEnabled;
    this.setLoggedInLinksEnabled(this.loggedInNavLinksEnabled);
  }

  private setLoggedInLinksEnabled(isLoggedIn: boolean) {
    this.navLinks.links.forEach(link => {
      if (link.name === 'Profile' || link.name === 'Logout') {
        link.enable = isLoggedIn;
      } else if (link.name === 'Login') {
        link.enable = !isLoggedIn;
      }
    });
    this.loggedInNavLinksEnabled = isLoggedIn;
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

  async login() {
    await this.router.navigate(['/aws-login']);
  }

  async logout() {
    await this.awsLoginService.logout();
    await this.router.navigate(['/landing']);
  }

  isLoggedInCheck() {
    try {
      this.awsLoginService.isLoggedIn$.subscribe(result => {
        this.isLoggedInToSession = result ?? false;
        this.setLoggedInLinksEnabled(this.isLoggedInToSession);
      });
    } catch (error) {
      console.error('Could not read if session is created: ', error);
    }
  }

  /**
   * This method should ONLY be used in HTML click events.
   * Sets the mobile navigation link click behavior.
   */
  setMobileNavLinkClick(link: LinkObj) {
    switch (link.name) {
      case 'Login':
        this.login();
        break;
      case 'Logout':
        this.logout();
        break;
      default:
        this.router.navigate([link.path]);
        this.setShouldShowMobileNavToFalse();
    }
  }
}
