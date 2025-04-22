import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { BlackJackHelpService } from '../../services/black-jack-help.service';

@Component({
  selector: 'app-black-jack-help',
  standalone: true,
  imports: [],
  templateUrl: './black-jack-help.component.html',
  styleUrl: './black-jack-help.component.css'
})
export class BlackJackHelpComponent implements OnInit {
  showErrorMessage = false;

  blackJackHelpFromGroup!: FormGroup;

  constructor(
    private router: Router,
    private blackJackHelpService: BlackJackHelpService,
    private formBuilder: FormBuilder
  ) {}

  ngOnInit(): void {
    this.blackJackHelpFromGroup = this.formBuilder.group({
      blackJackHelpChildFromGroup: this.formBuilder.group({
        disclaimer: new FormControl(false, [Validators.requiredTrue])
      }),
    });
  }

  get disclaimer() {
    return this.blackJackHelpFromGroup.get('blackJackHelpChildFromGroup.disclaimer');
  }

  setIsAgreedToTermsAndConditions(event: any) {
    let accepted = event.target.checked;
    this.blackJackHelpFromGroup.setValue({blackJackHelpChildFromGroup: {disclaimer: accepted }});
    this.blackJackHelpService.setHasUserAgreedToDisclamer(accepted);
  }

  onContinue() {
    if (
      this.blackJackHelpService.isHasUserAgreedToDisclaimerTrue() &&
      this.disclaimer?.value
    ) {
      this.router.navigate(['black-jack-game']);
    } else {
      this.showErrorMessage = true;
    }
  }
}
