import { TestBed } from '@angular/core/testing';
import { CanActivateFn } from '@angular/router';

import { blackJackHelpAuthenticationGuard } from './black-jack-help-authentication.guard';

describe('blackJackHelpAuthenticationGuard', () => {
  const executeGuard: CanActivateFn = (...guardParameters) => 
      TestBed.runInInjectionContext(() => blackJackHelpAuthenticationGuard(...guardParameters));

  beforeEach(() => {
    TestBed.configureTestingModule({});
  });

  it('should be created', () => {
    expect(executeGuard).toBeTruthy();
  });
});
