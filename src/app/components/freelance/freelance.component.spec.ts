import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FreelanceComponent } from './freelance.component';

describe('FreelanceComponent', () => {
  let component: FreelanceComponent;
  let fixture: ComponentFixture<FreelanceComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [FreelanceComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(FreelanceComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
