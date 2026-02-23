import { CanActivateFn, Router } from '@angular/router';
import { inject } from '@angular/core';
import { BlackJackHelpService } from '../services/black-jack-help.service';

export const blackJackHelpDisclaimerCheckedGuard: CanActivateFn = (route, state) => {
  const blackJackHelpService = inject(BlackJackHelpService);
  const router = inject(Router);
  blackJackHelpService.checkSessionStorage();
  return blackJackHelpService.isHasUserAgreedToDisclaimerTrue() ?? router.navigate(['black-jack-help']);
};
