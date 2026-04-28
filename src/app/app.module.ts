import { NgModule } from '@angular/core';
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
import { provideHttpClient } from '@angular/common/http';
//import xenonDevConfig from './config/xenon-dev-config';
import { AccountProfileComponent } from './components/account-profile/account-profile.component';
import { LeaderboardComponent } from './components/leaderboard/leaderboard.component';
import { NgbModule, NgbPaginationModule } from '@ng-bootstrap/ng-bootstrap';
import { BlogComponent } from './components/blog/blog.component';
import { AwsLoginComponent } from './components/aws-login/aws-login.component';

import { AmplifyAuthenticatorModule } from '@aws-amplify/ui-angular';


@NgModule({
  declarations: [
    AppComponent,
    LandingComponent,
    SiteInfoComponent,
    BlackJackHelpComponent,
    BlackJackGameComponent,
    NoDoubleClickDirective,
    AccountProfileComponent,
    LeaderboardComponent,
    BlogComponent,
    AwsLoginComponent,
  ],
  imports: [
    CommonModule,
    BrowserModule,
    FormsModule,
    ReactiveFormsModule,
    //KeycloakAngularModule,
    AppRoutingModule,
    NgbModule,
    NgbPaginationModule,
    AmplifyAuthenticatorModule,
    RouterModule.forRoot(routes, { anchorScrolling: 'enabled', scrollPositionRestoration: 'enabled'}), 
  ],
  providers: [    
    provideHttpClient(),
  ],
  bootstrap: [AppComponent],
})
export class AppModule { }
