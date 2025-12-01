import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { BrowserModule, provideClientHydration } from '@angular/platform-browser';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { routes } from './app-routing.module';
import { SweetAlert2Module } from '@sweetalert2/ngx-sweetalert2';
import { AppComponent } from './app.component';
import { LandingComponent } from './components/landing/landing.component';
import { SiteInfoComponent } from './components/site-info/site-info.component';
import { BlackJackHelpComponent } from './components/black-jack-help/black-jack-help.component';
import { BlackJackGameComponent } from './components/black-jack-game/black-jack-game.component';
import { NoDoubleClickDirective } from './directives/no-double-click.directive';
import { provideHttpClient, withInterceptorsFromDi } from '@angular/common/http';





@NgModule({ declarations: [
        AppComponent,
        LandingComponent,
        SiteInfoComponent,
        BlackJackHelpComponent,
        BlackJackGameComponent,
        NoDoubleClickDirective
    ],
    bootstrap: [AppComponent], imports: [CommonModule,
        BrowserModule,
        FormsModule,
        RouterModule.forRoot(routes),
        /*SweetAlert2Module.forRoot(),*/
        ReactiveFormsModule], providers: [
        provideClientHydration(),
        provideHttpClient(withInterceptorsFromDi())
    ] })
export class AppModule { }
