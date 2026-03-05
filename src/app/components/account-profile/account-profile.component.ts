import { Component, OnDestroy, OnInit } from '@angular/core';
import { AuthenticationService } from '../../services/authentication.service';
import { KeycloakProfile } from 'keycloak-js';
import {
  FormGroup,
  FormBuilder,
  Validators,
  FormControl,
} from '@angular/forms';
import { Subject, takeUntil } from 'rxjs';
import Swal from 'sweetalert2';
import {
  PlayerProfile,
  PlayerProfileService,
} from '../../services/player-profile.service';

@Component({
  selector: 'app-account-profile',
  templateUrl: './account-profile.component.html',
  styleUrl: './account-profile.component.css',
  standalone: false,
})
export class AccountProfileComponent implements OnDestroy, OnInit {
  protected user: KeycloakProfile | null = null;
  protected editMode: boolean = false;
  protected userForm: FormGroup;

  isUserEmailVerified = false;

  private readonly destroy$ = new Subject<void>();

  playerProfile: PlayerProfile | null = null;

  constructor(
    private authService: AuthenticationService,
    private playerProfileService: PlayerProfileService,
    private formBuilder: FormBuilder,
  ) {
    // Initialize the form group with form controls and validators
    this.userForm = this.formBuilder.group({
      username: this.createFormControl('', [Validators.required]),
      email: this.createFormControl('', [
        Validators.required,
        Validators.email,
      ]),
      firstName: this.createFormControl('', [Validators.required]),
      lastName: this.createFormControl('', [Validators.required]),
    });
  }

  async ngOnInit(): Promise<void> {
    //get user details and patch form values
    this.getUserDetails();
  }

  setUserFormKeycloakProfile(userRep: {
    username?: string;
    email?: string;
    firstName?: string;
    lastName?: string;
  }) {
    if (this.user) {
      this.user.username = userRep.username ?? '[username retrieval failed]';
      this.userForm
        .get('username')
        ?.setValue(userRep.username ?? '[username retrieval failed]');

      this.user.email = userRep.email ?? '[email retrieval failed]';
      this.userForm
        .get('email')
        ?.setValue(userRep.email ?? '[email retrieval failed]');

      this.user.firstName = userRep.firstName ?? '[firstName retrieval failed]';
      this.userForm
        .get('firstName')
        ?.setValue(userRep.firstName ?? '[firstName retrieval failed]');

      this.user.lastName = userRep.lastName ?? '[lastName retrieval failed]';
      this.userForm
        .get('lastName')
        ?.setValue(userRep.lastName ?? '[lastName retrieval failed]');
    }
  }

  createFormControl(value: any, validators: Validators): FormControl {
    return new FormControl(value, validators);
  }

  toggleEditMode() {
    this.editMode = !this.editMode;
    this.userForm.markAsPristine();
  }

  async getUserDetails(): Promise<void> {
    this.authService.userProfile$
      .pipe(takeUntil(this.destroy$))
      .subscribe(async (user) => {
        this.user = user;

        // set email verification status
        this.isUserEmailVerified = user?.emailVerified ?? false;

        // patch the form with incoming values
        this.userForm.patchValue({
          username: user?.username ?? '',
          email: user?.email ?? '',
          firstName: user?.firstName ?? '',
          lastName: user?.lastName ?? '',
        });

        if (this.user) {
          // Subscribe to player profile updates
          const profileExists =
            await this.playerProfileService.checkPlayerProfileExists(
              this.user!.id!,
            );
          if (profileExists) {
            this.playerProfileService.playerProfile$
              .pipe(takeUntil(this.destroy$))
              .subscribe((profile) => {
                this.playerProfile = profile;
              });
          }
        }
      });
  }

  save() {
    if (this.userForm.invalid) {
      this.userForm.markAllAsTouched();
      return;
    } else {
      const userRep = {
        username: this.userForm.get('username')?.value,
        email: this.userForm.get('email')?.value,
        firstName: this.userForm.get('firstName')?.value,
        lastName: this.userForm.get('lastName')?.value,
      };
      const updateResult = this.authService.updateUserProfile(userRep);
      updateResult.then((status) => {
        if (status === 200 || status === 204) {
          this.setUserFormKeycloakProfile(userRep);
          this.toggleEditMode();
        } else {
          if (typeof status !== undefined) {
            alert(`Failed to update profile. response status: ${status}`);
          } else {
            alert('Failed to update profile due to unknown error.');
          }
        }
      });
    }
  }

  revert() {
    if (this.user) {
      this.userForm.patchValue({
        username: this.user.username ?? '',
        email: this.user.email ?? '',
        firstName: this.user.firstName ?? '',
        lastName: this.user.lastName ?? '',
      });
    }
    this.toggleEditMode();
  }

  revertUsername() {
    if (this.user) {
      this.userForm.get('username')?.setValue(this.user.username);
    }
  }

  revertEmail() {
    if (this.user) {
      this.userForm.get('email')?.setValue(this.user.email);
    }
  }

  revertFirstname() {
    if (this.user) {
      this.userForm.get('firstName')?.setValue(this.user.firstName);
    }
  }

  revertLastname() {
    if (this.user) {
      this.userForm.get('lastName')?.setValue(this.user.lastName);
    }
  }

  resetPlayerProfile() {
    Swal.fire({
      title: 'Are you sure?',
      text: 'This will reset your player profile, including wins, losses, and pot. This action cannot be undone.',
      icon: 'warning',
      allowOutsideClick: false,
      draggable: true,
      showCancelButton: true,
      confirmButtonText: 'Yes, reset it!',
      cancelButtonText: 'No, keep it',
    }).then((result) => {
      if (result.isConfirmed) {
        // Call the service to reset the player profile
        this.playerProfileService
          .resetPlayerProfile(this.playerProfile!.player_id!)
          .then(() => {
            Swal.fire(
              'Reset!',
              'Your player profile has been reset.',
              'success',
            );
          })
          .catch(() => {
            Swal.fire(
              'Error!',
              'There was an error resetting your player profile.',
              'error',
            );
          });
      }
    });
  }

  deletePlayerProfile() {
    Swal.fire({
      title: 'Are you sure?',
      text:
        'This will delete your player profile (this action will ' +
        'remove all records of your game activity and your account for ' +
        'this website will remain active). This action cannot be undone.',
      icon: 'warning',
      allowOutsideClick: false,
      draggable: true,
      showCancelButton: true,
      confirmButtonText: 'Yes, delete it!',
      cancelButtonText: 'No, keep it',
    }).then((result) => {
      if (result.isConfirmed) {
        // Call the service to delete the player profile
        this.playerProfileService
          .deletePlayerProfile(this.playerProfile!.player_id!)
          .then(async () => {
            await Swal.fire(
              'Deleted!',
              'Your player profile has been deleted.',
              'success',
            );
            this.playerProfile = null;
          })
          .catch(async () => {
            await Swal.fire(
              'Error!',
              'There was an error deleting your player profile.',
              'error',
            );
          });
      }
    });
  }

  deleteAccount() {
    // add input text to confirm deletion for extra safety
    Swal.fire({
      title: 'Are you sure?',
      text:
        'This will delete your account and all associated data,' +
        ' including your player profile. This action ' +
        'cannot be undone.',
      icon: 'warning',
      allowOutsideClick: false,
      draggable: true,      
      showCancelButton: true,
      confirmButtonText: 'Yes, delete it!',
      cancelButtonText: 'No, keep it',      
      input: 'text',
      inputPlaceholder: 'Type "DELETE" to confirm',      
      inputValidator: (value) => {
        if (value !== 'DELETE') {  
          return 'You need to type "DELETE" to confirm';
        } else {          
          return null;
        }                    
      },
    }).then(async (result) => {
      if (result.isConfirmed) {
        // Call the service to delete the account
        await this.authService.deleteAccount(this.user!.id!).catch(async () => {
          await Swal.fire(
            'Error!',
            'There was an error deleting your account.',
            'error',
          );
        });
        this.authService.logout();
      }
    });
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }
}
