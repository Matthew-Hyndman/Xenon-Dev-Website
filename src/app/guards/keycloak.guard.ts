import { inject } from '@angular/core';
import { AuthenticationService } from '../services/authentication.service';

export const keycloakGuard = async (): Promise<void> => {
  const authService = inject(AuthenticationService);
  let isAuthenticated : boolean | null = null;
  authService.isLoggedIn$.subscribe((loggedIn) => {
    isAuthenticated = loggedIn;
  });
  if (!isAuthenticated) {
    authService.login();    
  }
};
