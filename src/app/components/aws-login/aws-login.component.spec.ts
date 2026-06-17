import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AwsLoginComponent } from './aws-login.component';

describe('AwsLoginComponent', () => {
  let component: AwsLoginComponent;
  let fixture: ComponentFixture<AwsLoginComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [AwsLoginComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(AwsLoginComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
