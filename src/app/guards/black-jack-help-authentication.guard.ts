import { inject } from '@angular/core';
import { CanActivateFn } from '@angular/router';
import { firstValueFrom, filter } from 'rxjs';
import { PlayerProfileService } from '../services/player-profile.service';
import { AwsLoginService } from '../services/aws-login.service';

export const blackJackHelpAuthenticationGuard: CanActivateFn = async (route, state) => {
  const authService = inject(AwsLoginService);
  const playerProfileService = inject(PlayerProfileService);

  try {
    const isLoggedIn = await firstValueFrom(
      authService.isLoggedIn$.pipe(filter((value): value is boolean => value !== null)),
    );

    if (!isLoggedIn) {
      return true;
    }

    const userProfile = await firstValueFrom(
      authService.userProfile$.pipe(filter((u) => u !== null)),
    );

    const hasPlayerProfile = await playerProfileService.checkPlayerProfileExists(userProfile.userId);
    if (!hasPlayerProfile) {
      console.log('User does not have a player profile');
    }

    return true;
  } catch (error) {
    console.error('Guard error:', error);
    return false;
  }
};
