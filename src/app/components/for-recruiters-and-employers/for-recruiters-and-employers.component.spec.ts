import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ForRecruitersAndEmployersComponent } from './for-recruiters-and-employers.component';

describe('ForRecruitersAndEmployersComponent', () => {
  let component: ForRecruitersAndEmployersComponent;
  let fixture: ComponentFixture<ForRecruitersAndEmployersComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ForRecruitersAndEmployersComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ForRecruitersAndEmployersComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
