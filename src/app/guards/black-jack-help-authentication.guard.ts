import { inject } from '@angular/core';
import { CanActivateFn } from '@angular/router';
import { firstValueFrom, take, skipWhile } from 'rxjs';
import { AuthenticationService } from '../services/authentication.service';
import { PlayerProfileService } from '../services/player-profile.service';

export const blackJackHelpAuthenticationGuard: CanActivateFn = async (route, state) => {
  const authService = inject(AuthenticationService);
  const playerProfileService = inject(PlayerProfileService);

  try {
    // Check if user is logged in
    const isLoggedIn = await firstValueFrom(
      authService.isLoggedIn$.pipe(take(1))
    );

    if (!isLoggedIn) {      
      console.log('user is not logged in');
    } else {

    // Get user profile
    const userProfile = await firstValueFrom(
      authService.userProfile$.pipe(skipWhile(u => u == null), take(1))
    );

    // Check if player profile exists
    const hasPlayerProfile = await playerProfileService.checkPlayerProfileExists(
      userProfile!.id!
    );
    if (!hasPlayerProfile) {
      console.log('User does not have a player profile');      
    }
  }    
    return true;
  } catch (error) {
    console.error('Guard error:', error);
    return false;
  }
};
