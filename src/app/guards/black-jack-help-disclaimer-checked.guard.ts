import { CanActivateFn, Router } from '@angular/router';
import { inject } from '@angular/core';
import { BlackJackHelpService } from '../services/black-jack-help.service';

export const blackJackHelpDisclaimerCheckedGuard: CanActivateFn = (route, state) => {
  const blackJackHelpService = inject(BlackJackHelpService);
  const router = inject(Router);
  blackJackHelpService.checkSessionStorage();
      // Check if user has agreed to disclaimer and disclaimer value is not null
  if (blackJackHelpService.isHasUserAgreedToDisclaimerNotNull() && 
      blackJackHelpService.isHasUserAgreedToDisclaimerTrue()) {
    return true;
  }
  router.navigate(['black-jack-help']);
  return false;
};
