import { Component, OnDestroy } from '@angular/core';
import { AuthenticationService } from '../../services/authentication.service';
import { KeycloakProfile } from 'keycloak-js';
import {
  FormGroup,
  FormBuilder,
  Validators,
  FormControl,
} from '@angular/forms';
import { Subject, takeUntil } from 'rxjs';

@Component({
  selector: 'app-account-profile',
  templateUrl: './account-profile.component.html',
  styleUrl: './account-profile.component.css',
  standalone: false
})
export class AccountProfileComponent implements OnDestroy {
  protected user: KeycloakProfile | null = null;
  protected editMode: boolean = false;
  protected profileForm: FormGroup;

  private readonly destroy$ = new Subject<void>();

  constructor(
    private authService: AuthenticationService,
    private formBuilder: FormBuilder
  ) {
    this.profileForm = this.formBuilder.group({
      username: this.createFormControl('', [Validators.required]),
      email: this.createFormControl('', [
        Validators.required,
        Validators.email,
      ]),
      firstName: this.createFormControl('', [Validators.required]),
      lastName: this.createFormControl('', [Validators.required]),
    });

    this.getUserDetails();
  }

  setUserFormKeycloakProfile(userRep: {username?: string; email?: string; firstName?: string; lastName?: string}) {
    if (this.user) {
      this.user.username = userRep.username ?? '[username retrieval failed]';
      this.profileForm.get('username')?.setValue(userRep.username ?? '[username retrieval failed]');

      this.user.email = userRep.email ?? '[email retrieval failed]';
      this.profileForm.get('email')?.setValue(userRep.email ?? '[email retrieval failed]');

      this.user.firstName = userRep.firstName ?? '[firstName retrieval failed]';
      this.profileForm.get('firstName')?.setValue(userRep.firstName ?? '[firstName retrieval failed]');

      this.user.lastName = userRep.lastName ?? '[lastName retrieval failed]';
      this.profileForm.get('lastName')?.setValue(userRep.lastName ?? '[lastName retrieval failed]');
    }
  }

  createFormControl(value: any, validators: Validators): FormControl {
    return new FormControl(value, validators);
  }

  toggleEditMode() {
    this.editMode = !this.editMode;
    this.profileForm.markAsPristine();
  }

  getUserDetails() {
    this.authService.userProfile$
      .pipe(takeUntil(this.destroy$))
      .subscribe((user) => {
        this.user = user;
        // patch the form with incoming values
        this.profileForm.patchValue({
          username: user?.username ?? '',
          email: user?.email ?? '',
          firstName: user?.firstName ?? '',
          lastName: user?.lastName ?? '',
        });
      });
  }

  save() {
    if (this.profileForm.invalid) {
      this.profileForm.markAllAsTouched();
      return;
    } else {
      const userRep = {
        username: this.profileForm.get('username')?.value,
        email: this.profileForm.get('email')?.value,
        firstName: this.profileForm.get('firstName')?.value,
        lastName: this.profileForm.get('lastName')?.value,
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
      this.profileForm.patchValue({
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
      this.profileForm.get('username')?.setValue(this.user.username);
    }
  }

  revertEmail() {
    if (this.user) {
      this.profileForm.get('email')?.setValue(this.user.email);
    }
  }

  revertFirstname() {
    if (this.user) {
      this.profileForm.get('firstName')?.setValue(this.user.firstName);
    }
  }

  revertLastname() {
    if (this.user) {
      this.profileForm.get('lastName')?.setValue(this.user.lastName);
    }
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }
}
