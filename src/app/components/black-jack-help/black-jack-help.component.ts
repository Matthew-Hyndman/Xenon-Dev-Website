import { Component, OnDestroy, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { BlackJackHelpService } from '../../services/black-jack-help.service';
import { BlackJackGameService } from '../../services/black-jack-game.service';
import { AuthenticationService } from '../../services/authentication.service';
import { KeycloakProfile } from 'keycloak-js';
import { Observable, Subject, takeUntil } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import xenonDevConfig from '../../config/xenon-dev-config';
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

  constructor(
    private router: Router,
    private blackJackHelpService: BlackJackHelpService,
    private formBuilder: FormBuilder,
    private authService: AuthenticationService,
    private blackJackGameService: BlackJackGameService,
    private playerProfileService: PlayerProfileService,
    private httpClient: HttpClient
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

    this.getUserProfile().then(() => {    
      this.blackJackGameService.getPlayerProfileAndPopulateGameData(this.userProfile!);      
    }).catch((error) => {
      console.error('Error retrieving user profile:', error);
    });

  }

  //add this to the srevice class and use it in a gaurd for this component
  async getUserProfile(): Promise<void> {
    this.authService.userProfile$
    .pipe(takeUntil(this.destroy$))
    .subscribe(profile => {
      if(profile) {
        this.userProfile = profile
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

  // how are we going to handle user profile creation here? 
  // how to check if user profile was created successfully?
  /*createPlayerProfile(): Boolean {
    let ok = false
    this.playerProfileService.createPlayerProfile(this.userProfile!.id! )
    /*
    this.httpClient.post<PlayerProfileResponse>(
      `${xenonDevConfig.SpringAPIServer.local.url}/api/player/createPlayer/${this.userProfile?.id}`, 
      null
    ).subscribe((response) => {
      if (response) {
        console.log('Player profile created successfully');
        ok = true;
      } else {
        console.error('Failed to create player profile', response);
      }
    });    
        
    return ok;
  }*/

  async onContinue() {
    if (
      this.blackJackHelpService.isHasUserAgreedToDisclaimerTrue() &&
      this.disclaimer?.value
    ) {
      if (this.userProfile !== null) {
        if ((await !!this.playerProfileService
          .getPlayerProfile(this.userProfile.id!))) {
            await this.playerProfileService.createPlayerProfile(this.userProfile.id!);
        }
        this.router.navigate(['black-jack-game']);
      } else {
        alert('There was an error creating your player profile. Please try again later.');
      }

    } else {
      this.showErrorMessage = true;
    }
  }
}

interface PlayerProfileResponse {
  _embedded: {
    player_id: number,
    losses: number,
    pot: number,
    wins: number
  };
}