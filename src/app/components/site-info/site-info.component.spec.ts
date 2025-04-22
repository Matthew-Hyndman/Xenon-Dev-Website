import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SiteInfoComponent } from './site-info.component';

describe('SiteInfoComponent', () => {
  let component: SiteInfoComponent;
  let fixture: ComponentFixture<SiteInfoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SiteInfoComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(SiteInfoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
