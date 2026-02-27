import { inject } from '@angular/core';
import { AuthenticationService } from '../services/authentication.service';

export const keycloakGuard = async (): Promise<void> => {
  const authService = inject(AuthenticationService);
  const isAuthenticated = authService.isLoggedIn$;
  if (!isAuthenticated) {
    authService.login();    
  }
};
