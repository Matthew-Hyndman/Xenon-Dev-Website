import { Component, OnDestroy, OnInit } from '@angular/core';
import { AwsLoginService, AwsUserProfile } from '../../services/aws-login.service';
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
  protected user: AwsUserProfile | null = null;
  protected editMode: boolean = false;
  protected userForm: FormGroup;

  isUserEmailVerified = false;

  private readonly destroy$ = new Subject<void>();

  playerProfile: PlayerProfile | null = null;

  constructor(
    private authService: AwsLoginService,
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

  setUserFormFromAwsProfile(userRep: {
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
              this.user.userId,
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

  async save() {
    if (this.userForm.invalid) {
      this.userForm.markAllAsTouched();
      return;
    } else {
      const hasEmailChanged =
        this.userForm.get('email')?.value !== this.user?.email;
      /**
       * only for telling if and when the verification email should be sent.
       */
      let shouldSendVerificationEmail = false;
      const userRep = {
        username: this.userForm.get('username')?.value,
        email: this.userForm.get('email')?.value,
        firstName: this.userForm.get('firstName')?.value,
        lastName: this.userForm.get('lastName')?.value,
        emailVerified: !hasEmailChanged,
      };

      // check if email is changed
      if (hasEmailChanged) {
        await Swal.fire({
          title: 'Email Change Detected',
          text:
            'Changing your email will require you to verify the ' +
            'new email address. Do you want to proceed?',
          icon: 'warning',
          showCancelButton: true,
          confirmButtonText: 'Yes, proceed',
          cancelButtonText: 'No, keep current email',
        }).then(async (result) => {
          if (result.isConfirmed) {
            shouldSendVerificationEmail = true;
            this.isUserEmailVerified = false;
          } else {
            // Revert email change in form
            this.revertEmail();
            userRep.email = this.user?.email;
            userRep.emailVerified = this.user?.emailVerified ?? false;
          }
        });
      }

      await this.authService.updateUserProfile({
        email: userRep.email,
        givenName: userRep.firstName,
        familyName: userRep.lastName,
      });

      this.setUserFormFromAwsProfile(userRep);
      this.toggleEditMode();

      if (shouldSendVerificationEmail) {
        await this.authService.sendEmailVerificationCode();
      }
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
        const profileId = this.playerProfile?.player_id;
        this.playerProfileService
          .resetPlayerProfile(profileId!)
          .then(() => {
            this.playerProfile = {
              player_id: profileId!,
              pot: 3000,
              wins: 0,
              losses: 0,
            };
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
        await this.authService.deleteAccount().catch(async () => {
          await Swal.fire(
            'Error!',
            'There was an error deleting your account.',
            'error',
          );
        });
        await this.authService.logout();
      }
    });
  }

  /**
   * This only for when you want to send another verification email without
   * changing the email in the form. If the email is changed, the `save()`
   * function will handle re-verification.
   */
  reverifyEmail() {
    void this.authService.sendEmailVerificationCode();
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }
}
