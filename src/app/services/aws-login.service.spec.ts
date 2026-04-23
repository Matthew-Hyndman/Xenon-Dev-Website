import { TestBed } from '@angular/core/testing';

import { AwsLoginService } from './aws-login.service';

describe('AwsLoginService', () => {
  let service: AwsLoginService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(AwsLoginService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
