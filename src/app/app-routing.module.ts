import { RouterModule, Routes } from '@angular/router';
import { LandingComponent } from './components/landing/landing.component';
import { BlackJackGameComponent } from './components/black-jack-game/black-jack-game.component';
import { BlackJackHelpComponent } from './components/black-jack-help/black-jack-help.component';
import { SiteInfoComponent } from './components/site-info/site-info.component';
import { NgModule } from '@angular/core';

import { LoginComponent } from './components/login/login.component';
import { AccountProfileComponent } from './components/account-profile/account-profile.component';
import { keycloakGuard } from './services/keycloak.guard';
import {blackJackHelpAuthenticationGuard } from './guards/black-jack-help-authentication.guard';
import { blackJackHelpDisclaimerCheckedGuard } from './guards/black-jack-help-disclaimer-checked.guard';

export const routes: Routes = [
  //{ path: 'login', component: LoginComponent, canActivate: [keycloakGuard] },
  { path: 'black-jack-game', component: BlackJackGameComponent },
  { path: 'black-jack-help', component: BlackJackHelpComponent, canActivate: [
    blackJackHelpAuthenticationGuard, 
    blackJackHelpDisclaimerCheckedGuard
  ] },
  { path: 'site-info', component: SiteInfoComponent },
  { path: 'landing', component: LandingComponent },
  { path: 'user-profile', component: AccountProfileComponent, canActivate: [keycloakGuard] },
  { path: '**', redirectTo: '/landing', pathMatch: 'full' },
  { path: '', redirectTo: '/landing', pathMatch: 'full' },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }