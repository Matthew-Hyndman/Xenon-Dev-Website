import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
//import { TodosComponent } from './todos/todos.component';
import { Amplify } from 'aws-amplify';
import outputs from '../../amplify_outputs.json';
import { AmplifyAuthenticatorModule, AuthenticatorService } from '@aws-amplify/ui-angular';
import { MiniNavMenuComponent } from "./components/mini-nav-menu/mini-nav-menu.component";
import { NavLinks } from './common/nav-links';
import { LinkObj } from './common/link-obj';
import { routes } from './app.routes';
import { LandingComponent } from './components/landing/landing.component';

Amplify.configure(outputs);

@Component({
  selector: 'app-root',
  standalone: true,
  templateUrl: './app.component.html',
  styleUrl: './app.component.css',
  imports: [RouterOutlet, /*TodosComponent, AmplifyAuthenticatorModule,*/ MiniNavMenuComponent],
  
})
export class AppComponent {
  title = 'Xenon-Dev';
  links!: LinkObj[];

  constructor (private navLinks: NavLinks){
    this.links = this.navLinks.links;
  }

  
  /*title = 'amplify-angular-template';

  constructor(public authenticator: AuthenticatorService) {
    Amplify.configure(outputs);
  }*/

}
