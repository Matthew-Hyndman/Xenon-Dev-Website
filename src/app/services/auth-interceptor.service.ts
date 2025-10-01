import { HTTP_INTERCEPTORS, HttpEvent, HttpHandler, HttpInterceptor, HttpRequest } from '@angular/common/http';
import { Inject, Injectable, OnInit } from '@angular/core';
import { from, lastValueFrom, Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import Keycloak from 'keycloak-js';
import xenonDevConfig from '../config/xenon-dev-config';
import { Authorization } from 'aws-cdk-lib/aws-events';
import { AuthenticationService } from './authentication.service';

@Injectable({
  providedIn: 'root',
})
export class AuthInterceptorService /*implements HttpInterceptor*/{

  constructor(private authService: AuthenticationService) { }

  /*intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    return from(this.handleAccess(request, next))
  }

  private async handleAccess(request: HttpRequest<any>, next: HttpHandler): Promise<HttpEvent<any>> {
    const theEndPoint = environment.localKeycloakURL + '/account';
    const securedEndpoints = [theEndPoint];
    
    if(securedEndpoints.some(url => request.urlWithParams.includes(url))){
      try {
        // Check if token refresh is needed
        if (this.authService.isTokenExpired()) {
          this.authService.updateToken(5);
        }
        
        const accessToken = this.authService.getToken();
        request = request.clone({
          setHeaders: {
            Authorization: 'Bearer ' + accessToken
          }
        });
      } catch (error) {
        console.error('Token refresh failed:', error);
        this.authService.logout();
      }
    }

    return await lastValueFrom(next.handle(request));
  }*/
}
