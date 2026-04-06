import { RouterModule, Routes } from '@angular/router';
import { LandingComponent } from './components/landing/landing.component';
import { BlackJackGameComponent } from './components/black-jack-game/black-jack-game.component';
import { BlackJackHelpComponent } from './components/black-jack-help/black-jack-help.component';
import { SiteInfoComponent } from './components/site-info/site-info.component';
import { NgModule } from '@angular/core';

import { AccountProfileComponent } from './components/account-profile/account-profile.component';
import { keycloakGuard } from './guards/keycloak.guard';
import {blackJackHelpAuthenticationGuard } from './guards/black-jack-help-authentication.guard';
import { blackJackHelpDisclaimerCheckedGuard } from './guards/black-jack-help-disclaimer-checked.guard';
import { LeaderboardComponent } from './components/leaderboard/leaderboard.component';
import { BlogComponent } from './components/blog/blog.component';

export const routes: Routes = [
  { path: 'black-jack-game', component: BlackJackGameComponent, canActivate: [blackJackHelpDisclaimerCheckedGuard] },
  { path: 'black-jack-help', component: BlackJackHelpComponent, canActivate: [blackJackHelpAuthenticationGuard] },
  { path: 'black-jack-leaderboard', component: LeaderboardComponent, canActivate: [
    keycloakGuard, 
    blackJackHelpAuthenticationGuard,
    blackJackHelpDisclaimerCheckedGuard
  ] },
  { path: 'site-info', component: SiteInfoComponent },
  { path: 'landing', component: LandingComponent },
  { path: 'blog', component: BlogComponent },
  { path: 'user-profile', component: AccountProfileComponent, canActivate: [keycloakGuard] },
  { path: '**', redirectTo: '/landing', pathMatch: 'full' },
  { path: '', redirectTo: '/landing', pathMatch: 'full' },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }