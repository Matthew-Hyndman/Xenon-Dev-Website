import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { routes } from './app.routes';
import { SweetAlert2Module } from '@sweetalert2/ngx-sweetalert2';




@NgModule({
  declarations: [

  ],
  imports: [
    //CommonModule,
    BrowserModule,
    FormsModule,
    RouterModule.forRoot(routes),
    /*SweetAlert2Module.forRoot(),
    ReactiveFormsModule*/
  ],
})
export class AppModule { }
