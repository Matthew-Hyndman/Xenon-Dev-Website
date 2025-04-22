import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BlackJackHelpComponent } from './black-jack-help.component';

describe('BlackJackHelpComponent', () => {
  let component: BlackJackHelpComponent;
  let fixture: ComponentFixture<BlackJackHelpComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [BlackJackHelpComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(BlackJackHelpComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
