import { TestBed } from '@angular/core/testing';
import { CanActivateFn } from '@angular/router';

import { blackJackHelpGuard } from './black-jack-help.guard';

describe('blackJackHelpGuard', () => {
  const executeGuard: CanActivateFn = (...guardParameters) => 
      TestBed.runInInjectionContext(() => blackJackHelpGuard(...guardParameters));

  beforeEach(() => {
    TestBed.configureTestingModule({});
  });

  it('should be created', () => {
    expect(executeGuard).toBeTruthy();
  });
});
