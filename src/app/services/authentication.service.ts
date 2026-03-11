import { Injectable } from '@angular/core';
import Keycloak, { KeycloakProfile } from 'keycloak-js';
import { BehaviorSubject } from 'rxjs';
import xenonDevConfig from '../config/xenon-dev-config';
import { HttpClient } from '@angular/common/http';
import Swal from 'sweetalert2';

@Injectable({
  providedIn: 'root',
})
export class AuthenticationService {
  // Keycloak instance (provided by `provideKeycloak` in AppModule)
  constructor(
    private readonly keycloak: Keycloak,
    private httpClient: HttpClient,
  ) {
    void this.init();
  }

  // null = not yet checked, true/false = known state
  private readonly _isLoggedIn$ = new BehaviorSubject<boolean | null>(null);
  public readonly isLoggedIn$ = this._isLoggedIn$.asObservable();

  private readonly _userProfile$ = new BehaviorSubject<KeycloakProfile | null>(
    null,
  );
  public readonly userProfile$ = this._userProfile$.asObservable();

  // constructor is defined above to inject Keycloak instance

  // explicit initializer — can be called from APP_INITIALIZER if needed
  public async init(): Promise<void> {
    try {
      await this._isLoggedInCheck();
      if (this._isLoggedIn$.value) {
        this.refreshUserProfile();
      }
    } catch (err) {
      // log / handle init error and set a deterministic state
      console.error('Auth init error', err);
      this._isLoggedIn$.next(false);
      this._userProfile$.next(null);
    }
  }

  public async login(): Promise<void> {
    try {
      await this.keycloak.login();
      await this._isLoggedInCheck();
      if (this._isLoggedIn$.value) {
        await this.refreshUserProfile();
      }
    } catch (err) {
      console.error('Login failed', err);
      // leave state consistent or set to false
      await this._isLoggedInCheck();
    }
  }

  public async logout(): Promise<void> {
    try {
      await this.keycloak.logout();
    } catch (err) {
      console.error('Logout failed', err);
    } finally {
      await this._isLoggedInCheck();
      this._userProfile$.next(null);
    }
  }

  private async _isLoggedInCheck(): Promise<void> {
    try {
      const isLogged = !!this.keycloak.authenticated;
      this._isLoggedIn$.next(isLogged);
    } catch (err) {
      console.error('isLoggedIn check failed', err);
      this._isLoggedIn$.next(false);
    }
  }

  async refreshUserProfile(): Promise<void> {
    // Refresh the user profile after update
    try {
      const profile = await this.keycloak.loadUserProfile();
      this._userProfile$.next(profile);
    } catch (err) {
      console.error('Failed to refresh user profile', err);
      this._userProfile$.next(null);
    }
  }

  public async updateUserProfile(
    updatedData: UserRepresentation,
  ): Promise<number | void> {
    try {
      const token = this.keycloak.token;
      const kc: any = this.keycloak as any;
      const userId =
        (kc.tokenParsed && kc.tokenParsed.sub) || (kc.subject ?? '');
      const response = await fetch(
        `${kc.authServerUrl}/admin/realms/${kc.realm}/users/${userId}`,
        {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${token}`,
          },
          body: JSON.stringify(updatedData),
        },
      );
      switch (response.status) {
        case 200:
          console.log(`User Profile ${userId} updated successfully.`);
          await this.refreshUserProfile();
          break;
        case 204:
          console.log(
            `request empty - no changes made to User Profile ${userId}.`,
          );
          await this.refreshUserProfile();
          break;
        case 400:
          console.error('Invalid user profile data');
          break;
        case 403:
          console.error(
            'Access denied - you do not have permission to update user profile',
          );
          break;
        case 404:
          console.error('User not found');
          break;
        case 409:
          console.error('Conflict - user profile update failed');
          break;
        case 500:
          console.error('Server error - please try again later');
          break;
        default:
          console.error(
            'Failed to update user profile with status:',
            response.status,
          );
      }
      return response.status;
    } catch (err) {
      console.error('Frontend failed to update user profile', err);
    }
  }

  async deleteAccount(userId: string): Promise<void> {
    const kc: any = this.keycloak as any;
    const url = `${kc.authServerUrl}/admin/realms/${kc.realm}/users/${userId}`;
    const response = await fetch(url, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.keycloak.token}`,
      },
    });
    if (!response.ok) {
      return Promise.reject(
        new Error(`Failed to delete account with status: ${response.status}`),
      );
    }
    return Promise.resolve();
  }

  /**
   * This only for when you want to send another verification email
   * @param userID - the ID of the user to send the verification email to.   
   */
  async reverifiyEmail(userID: string): Promise<void> {
    const kc: any = this.keycloak as any;
    const url = `${kc.authServerUrl}/admin/realms/${kc.realm}/users/${userID}/execute-actions-email`;
    await fetch(url, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.keycloak.token}`,
      },
      body: JSON.stringify(['VERIFY_EMAIL']),
    }).then(async (response) => {
      if (response.ok) {
        await Swal.fire({
          icon: 'success',
          title: 'Verification Email Sent',
          text: 'A new verification email has been sent to your email address.',
        });
      }
    }).catch(async (err) => {
      console.error('Failed to send verification email', err);
      await Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'Failed to send verification email. Please try again later.',
      });
    });
  }
}

interface UserRepresentation {
  username?: string;
  email?: string;
  firstName?: string;
  lastName?: string;
  emailVerified?: boolean | undefined;
}
