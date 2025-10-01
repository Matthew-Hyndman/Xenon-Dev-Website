import { inject } from '@angular/core';
import { Router } from '@angular/router';
import { AuthenticationService } from './authentication.service';

export const keycloakGuard = async (): Promise<boolean> => {
  /*const authService = inject(AuthenticationService);
  const router = inject(Router);
  const isAuthenticated = authService.authenticated;
  if (!isAuthenticated) {
    router.navigate(['/login']); // Redirect to the login page
    return false;
  }*/
  return true;
};