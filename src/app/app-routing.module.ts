import { RouterModule, Routes, Router } from '@angular/router';
import { LandingComponent } from './components/landing/landing.component';
import { BlackJackGameComponent } from './components/black-jack-game/black-jack-game.component';
import { BlackJackHelpComponent } from './components/black-jack-help/black-jack-help.component';
import { SiteInfoComponent } from './components/site-info/site-info.component';
import { NgModule } from '@angular/core';

import { Injector } from '@angular/core';
import { LoginComponent } from './components/login/login.component';
import { AccountProfileComponent } from './components/account-profile/account-profile.component';
import { keycloakGuard } from './services/keycloak.guard';

/*function sendToLoginPage(oktaAuth: OktaAuth, injector: Injector){
  const router = injector.get(Router);
  router.navigate(['/login']);
}*/

export const routes: Routes = [

  //{path: 'login/callback', component: OktaCallbackComponent},
  {path: 'login', component: LoginComponent, /*canActivate: [keycloakGuard]*/},
  //{path: 'profile/:id', component: AccountProfileComponent, canActivate: [OktaAuthGuard], data: {onAuthRequired: sendToLoginPage}},

  { path: 'black-jack-game', component: BlackJackGameComponent },
  { path: 'black-jack-help', component: BlackJackHelpComponent },
  { path: 'site-info', component: SiteInfoComponent },
  { path: 'landing', component: LandingComponent },
  { path: '**', redirectTo: '/landing', pathMatch: 'full' },
  { path: '', redirectTo: '/landing', pathMatch: 'full' },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }