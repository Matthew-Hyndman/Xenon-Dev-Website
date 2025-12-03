import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { AppComponent } from './app/app.component';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import { AppModule } from './app/app.module';
/*
import { Amplify } from 'aws-amplify';
import outputs from '../amplify_outputs.json';
*/
/*bootstrapApplication(AppComponent, appConfig)
  .catch((err) => console.error(err));*/

platformBrowserDynamic().bootstrapModule(AppModule, {
  ngZoneEventCoalescing: true
})
  .catch(err => console.error(err));

  
  
  // refresh the Amplify configuration at runtime
  //Amplify.configure({});
  //Amplify.configure(outputs);