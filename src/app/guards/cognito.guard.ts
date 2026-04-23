import { inject } from '@angular/core';
import { Router } from '@angular/router';
import { AwsLoginService } from '../services/aws-login.service';
import { firstValueFrom, filter } from 'rxjs';

/**
 * Route guard that redirects unauthenticated users to the AWS login page.
 * Replace `keycloakGuard` with this guard in routes that should require Cognito auth.
 */
export const cognitoGuard = async (): Promise<boolean> => {
  const awsLoginService = inject(AwsLoginService);
  const router = inject(Router);

  // Wait until the auth state is determined (non-null)
  const isLoggedIn = await firstValueFrom(
    awsLoginService.isLoggedIn$.pipe(filter((v): v is boolean => v !== null)),
  );

  if (!isLoggedIn) {
    router.navigate(['/aws-login']);
    return false;
  }

  return true;
};
