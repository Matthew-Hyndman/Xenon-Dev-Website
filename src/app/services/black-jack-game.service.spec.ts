import { TestBed } from '@angular/core/testing';

import { BlackJackGameService } from './black-jack-game.service';

describe('BlckJackGameService', () => {
  let service: BlackJackGameService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(BlackJackGameService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
