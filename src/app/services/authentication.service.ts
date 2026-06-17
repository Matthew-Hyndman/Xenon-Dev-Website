import { Injectable, inject } from '@angular/core';
import Keycloak from 'keycloak-js';
import { KeycloakProfile } from 'keycloak-js';
import { BehaviorSubject, Subscription, fromEvent, merge } from 'rxjs';
import xenonDevConfig from '../config/xenon-dev-config';
import { HttpClient } from '@angular/common/http';
import Swal from 'sweetalert2';

@Injectable({
  providedIn: 'root',
})
export class AuthenticationService {
  private static readonly IDLE_WARNING_AFTER_MS = 3 * 60 * 1000;
  private static readonly IDLE_LOGOUT_AFTER_MS = 5 * 60 * 1000;

  // For testing purposes, set the idle warning and logout times to 10 seconds and 20 seconds respectively
  //private static readonly IDLE_WARNING_AFTER_MS = 10000;
  //private static readonly IDLE_LOGOUT_AFTER_MS = 20000;

  private readonly keycloak = inject(Keycloak);

  // Keycloak instance (provided by `provideKeycloak` in AppModule)
  constructor(private httpClient: HttpClient) {
    this.isLoggedIn$.subscribe((isLoggedIn) => {
      if (isLoggedIn) {
        this.startIdleMonitor();
      } else {
        this.stopIdleMonitor();
      }
    });

    void this.init();
  }

  // null = not yet checked, true/false = known state
  private readonly _isLoggedIn$ = new BehaviorSubject<boolean | null>(null);
  public readonly isLoggedIn$ = this._isLoggedIn$.asObservable();

  private readonly _userProfile$ = new BehaviorSubject<KeycloakProfile | null>(
    null,
  );
  public readonly userProfile$ = this._userProfile$.asObservable();

  private activitySub: Subscription | null = null;
  private idleWarningTimeoutId: ReturnType<typeof setTimeout> | null = null;
  private idleLogoutTimeoutId: ReturnType<typeof setTimeout> | null = null;
  private warningCountdownIntervalId: ReturnType<typeof setInterval> | null =
    null;
  private idleWarningIsVisible = false;

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
      await this.keycloak.login(); //login method does not seem to be reconised
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

  private startIdleMonitor(): void {
    if (typeof document === 'undefined') {
      return;
    }

    if (!this.activitySub) {
      /* merge and fromEvent is deprecated in RxJS 7, 
      consider using fromEventPattern or other 
      alternatives */
      this.activitySub = merge(
        fromEvent(document, 'keydown'),
        fromEvent(document, 'touchstart'),
        fromEvent(document, 'scroll'),
        fromEvent(document.body.children, 'mousemove'),
        fromEvent(document.body.children, 'click'),
      ).subscribe(() => {
        this.handleUserActivity();
      });
    }

    this.resetIdleTimers();
  }

  private stopIdleMonitor(): void {
    this.activitySub?.unsubscribe();
    this.activitySub = null;

    this.clearIdleTimeouts();
    this.clearWarningCountdown();
    this.idleWarningIsVisible = false;

    if (Swal.isVisible()) {
      Swal.close();
    }
  }

  private handleUserActivity(): void {
    if (!this._isLoggedIn$.value) {
      return;
    }

    if (this.idleWarningIsVisible && Swal.isVisible()) {
      Swal.close();
      this.idleWarningIsVisible = false;
    }

    this.resetIdleTimers();
  }

  private resetIdleTimers(): void {
    this.clearIdleTimeouts();

    this.idleWarningTimeoutId = setTimeout(() => {
      void this.showIdleWarning();
    }, AuthenticationService.IDLE_WARNING_AFTER_MS);

    this.idleLogoutTimeoutId = setTimeout(() => {
      void this.logoutDueToInactivity();
    }, AuthenticationService.IDLE_LOGOUT_AFTER_MS);
  }

  private clearIdleTimeouts(): void {
    if (this.idleWarningTimeoutId) {
      clearTimeout(this.idleWarningTimeoutId);
      this.idleWarningTimeoutId = null;
    }

    if (this.idleLogoutTimeoutId) {
      clearTimeout(this.idleLogoutTimeoutId);
      this.idleLogoutTimeoutId = null;
    }
  }

  private clearWarningCountdown(): void {
    if (this.warningCountdownIntervalId) {
      clearInterval(this.warningCountdownIntervalId);
      this.warningCountdownIntervalId = null;
    }
  }

  private async showIdleWarning(): Promise<void> {
    if (!this._isLoggedIn$.value || this.idleWarningIsVisible) {
      return;
    }

    this.idleWarningIsVisible = true;
    let remainingSeconds =
      (AuthenticationService.IDLE_LOGOUT_AFTER_MS -
        AuthenticationService.IDLE_WARNING_AFTER_MS) /
      1000;

    const result = await Swal.fire({
      icon: 'warning',
      title: 'Still there?',
      html: `You have been idle for a while. You will be signed out in <b><span id="idle-countdown">${remainingSeconds}</span>s</b>.`,
      showCancelButton: true,
      confirmButtonText: 'Stay signed in',
      cancelButtonText: 'Sign out now',
      allowOutsideClick: false,
      allowEscapeKey: false,
      didOpen: () => {
        this.warningCountdownIntervalId = setInterval(() => {
          remainingSeconds = Math.max(remainingSeconds - 1, 0);
          const countdownElement = document.getElementById('idle-countdown');
          if (countdownElement) {
            countdownElement.textContent = String(remainingSeconds);
          }
        }, 1000);
      },
      willClose: () => {
        this.clearWarningCountdown();
      },
    });

    this.idleWarningIsVisible = false;

    if (!this._isLoggedIn$.value) {
      return;
    }

    if (result.isConfirmed) {
      this.resetIdleTimers();
      return;
    }

    if (result.dismiss === Swal.DismissReason.cancel) {
      await this.logout();
    }
  }

  private async logoutDueToInactivity(): Promise<void> {
    if (!this._isLoggedIn$.value) {
      return;
    }

    if (Swal.isVisible()) {
      Swal.close();
    }
    await this.logout();
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
  async sendReverificationEmail(userID: string): Promise<void> {
    const kc: any = this.keycloak as any;
    const url = `${kc.authServerUrl}/admin/realms/${kc.realm}/users/${userID}/execute-actions-email`;
    await fetch(url, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.keycloak.token}`,
      },
      body: JSON.stringify(['VERIFY_EMAIL']),
    })
      .then(async (response) => {
        if (response.ok) {
          await Swal.fire({
            icon: 'success',
            title: 'Verification Email Sent',
            text: 'A new verification email has been sent to your email address.',
          });
        } else {
          console.error(
            'Failed to send verification email with status:',
            response.status,
          );
          await Swal.fire({
            icon: 'error',
            title: 'Error',
            text:
              'Failed to send verification email. Please try again later.\nStatus: ' +
              response.status,
          });
        }
      })
      .catch(async (err) => {
        console.error('Failed to send verification email', err);
        await Swal.fire({
          icon: 'error',
          title: 'Error',
          text:
            'Failed to send verification email. Please try again later.\nError: ' +
            err.message,
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
