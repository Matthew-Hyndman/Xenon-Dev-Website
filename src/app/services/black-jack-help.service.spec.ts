import { TestBed } from '@angular/core/testing';

import { BlackJackHelpService } from './black-jack-help.service';

describe('BlackJackHelpService', () => {
  let service: BlackJackHelpService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(BlackJackHelpService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
