import { TestBed } from '@angular/core/testing';
import { CanActivateFn } from '@angular/router';

import { blackJackHelpDisclaimerCheckedGuard } from './black-jack-help-disclaimer-checked.guard';

describe('blackJackHelpDisclaimerCheckedGuard', () => {
  const executeGuard: CanActivateFn = (...guardParameters) => 
      TestBed.runInInjectionContext(() => blackJackHelpDisclaimerCheckedGuard(...guardParameters));

  beforeEach(() => {
    TestBed.configureTestingModule({});
  });

  it('should be created', () => {
    expect(executeGuard).toBeTruthy();
  });
});
