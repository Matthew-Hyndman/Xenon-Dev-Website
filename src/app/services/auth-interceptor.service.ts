import { HttpEvent, HttpHandler, HttpInterceptor, HttpRequest } from '@angular/common/http';
import { Inject, Injectable } from '@angular/core';
import { OKTA_AUTH } from '@okta/okta-angular';
import { from, lastValueFrom, Observable } from 'rxjs';
import OktaAuth from '@okta/okta-auth-js';
import { environment } from '../../environments/environment';
import { Authorization } from 'aws-cdk-lib/aws-events';

@Injectable({
  providedIn: 'root'
})
export class AuthInterceptorService implements HttpInterceptor{

  constructor(@Inject(OKTA_AUTH) private oktaAuth: OktaAuth) { }

  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    return from(this.handleAccess(request, next));
  }

  private async handleAccess(request: HttpRequest<any>, next: HttpHandler): Promise<HttpEvent<any>> {
    const theEndPoint = environment.xenonDevApiURL + '/profile';
    const securedEndpoints = [theEndPoint];

    if(securedEndpoints.some(url => request.urlWithParams.includes(url))){
      const accessToken = this.oktaAuth.getAccessToken();

      request = request.clone({
        setHeaders:{
          Authorization: 'Bearer ' + accessToken
        }
      });

    }

    return await lastValueFrom(next.handle(request));
  }
}
