import { inject } from '@angular/core';
import { Router } from '@angular/router';
import { firstValueFrom, filter } from 'rxjs';
import { AwsLoginService } from '../services/aws-login.service';

export const keycloakGuard = async (): Promise<boolean> => {
  const awsLoginService = inject(AwsLoginService);
  const router = inject(Router);

  const isLoggedIn = await firstValueFrom(
    awsLoginService.isLoggedIn$.pipe(filter((value): value is boolean => value !== null)),
  );

  if (!isLoggedIn) {
    await router.navigate(['/aws-login']);
    return false;
  }

  return true;
};
