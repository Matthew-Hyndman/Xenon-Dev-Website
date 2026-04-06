import { Component, OnDestroy, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { BlackJackHelpService } from '../../services/black-jack-help.service';
import { BlackJackGameService } from '../../services/black-jack-game.service';
import { AuthenticationService } from '../../services/authentication.service';
import { KeycloakProfile } from 'keycloak-js';
import { Subject, takeUntil } from 'rxjs';
import { PlayerProfileService } from '../../services/player-profile.service';

@Component({
    selector: 'app-black-jack-help',
    templateUrl: './black-jack-help.component.html',
    styleUrl: './black-jack-help.component.css',
    standalone: false
})
export class BlackJackHelpComponent implements OnInit, OnDestroy {
  showErrorMessage = false;

  blackJackHelpFromGroup!: FormGroup;

  private readonly destroy$ = new Subject<void>();

  userProfile: KeycloakProfile | null = null;

  isLoggedIn: boolean | null = null;

  constructor(
    private router: Router,
    private blackJackHelpService: BlackJackHelpService,
    private formBuilder: FormBuilder,
    private authService: AuthenticationService,
    private playerProfileService: PlayerProfileService,
  ) {}

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }

  ngOnInit(): void {
    this.blackJackHelpFromGroup = this.formBuilder.group({
      blackJackHelpChildFromGroup: this.formBuilder.group({
        disclaimer: new FormControl(false, [Validators.requiredTrue])
      }),
    });

    this.getUserProfile();

  }

  //add this to the srevice class and use it in a gaurd for this component
  async getUserProfile(): Promise<void> {
    this.authService.userProfile$
    .pipe(takeUntil(this.destroy$))
    .subscribe(profile => {
      if(profile) {
        this.userProfile = profile;
        this.isLoggedIn = true;
      } else {
        this.isLoggedIn = false;
      }
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

  login() {
    this.authService.login();
  }

  async onContinue() {
    if (
      this.blackJackHelpService.isHasUserAgreedToDisclaimerTrue() &&
      this.disclaimer?.value
    ) {

      if (!this.isLoggedIn) {
        this.router.navigate(['black-jack-game']);
        return;
      } else {        
        if (!(await this.playerProfileService.checkPlayerProfileExists(this.userProfile!.id!))) {
            await this.playerProfileService.createPlayerProfile(this.userProfile!.id!);
        }
        this.router.navigate(['black-jack-game']);
        return;
      }

    } else {
      this.showErrorMessage = true;
    }
  }
}