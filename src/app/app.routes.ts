import { Routes } from '@angular/router';
import { LandingComponent } from './components/landing/landing.component';

export const routes: Routes = [
  /*
    {path:'black-jack-game', component:BlackJackGameComponent},
  {path:'black-jack-help', component:BlackJackHelpComponent},
  {path:'site-info', component:SiteInfoComponent},
  */
  {path:'landing', component: LandingComponent},
  {path:'**', redirectTo:'/landing', pathMatch: 'full'},
  {path:'', redirectTo:'/landing', pathMatch: 'full'} 
];
