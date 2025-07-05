import { TestBed } from '@angular/core/testing';

import { BlckJackGameService } from './blck-jack-game.service';

describe('BlckJackGameService', () => {
  let service: BlckJackGameService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(BlckJackGameService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
