import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import {
  signIn,
  signOut,
  signUp,
  confirmSignUp,
  getCurrentUser,
  fetchUserAttributes,
  updateUserAttributes,
  deleteUser,
  resendSignUpCode,
  sendUserAttributeVerificationCode,
  resetPassword,
  confirmResetPassword,
  fetchAuthSession,
  AuthUser,
  FetchUserAttributesOutput,
} from 'aws-amplify/auth';
import { Hub } from 'aws-amplify/utils';

export interface AwsUserProfile {
  userId: string;
  email: string;
  emailVerified: boolean;
  username?: string;
  firstName?: string;
  lastName?: string;
  attributes: FetchUserAttributesOutput;
}

@Injectable({
  providedIn: 'root',
})
export class AwsLoginService {
  private readonly _isLoggedIn$ = new BehaviorSubject<boolean | null>(null);
  public readonly isLoggedIn$ = this._isLoggedIn$.asObservable();

  private readonly _userProfile$ = new BehaviorSubject<AwsUserProfile | null>(null);
  public readonly userProfile$ = this._userProfile$.asObservable();

  constructor() {
    this.listenToAuthEvents();
    void this.checkCurrentUser();
  }

  /** Listen to Amplify Hub auth events to keep state in sync */
  private listenToAuthEvents(): void {
    Hub.listen('auth', async ({ payload }) => {
      switch (payload.event) {
        case 'signedIn':
          await this.refreshSession();
          break;
        case 'signedOut':
          this._isLoggedIn$.next(false);
          this._userProfile$.next(null);
          break;
        case 'tokenRefresh':
          await this.refreshSession();
          break;
        case 'tokenRefresh_failure':
          this._isLoggedIn$.next(false);
          this._userProfile$.next(null);
          break;
      }
    });
  }

  /** Check if a user is already signed in on startup */
  private async checkCurrentUser(): Promise<void> {
    try {
      await getCurrentUser();
      await this.refreshSession();
    } catch {
      this._isLoggedIn$.next(false);
      this._userProfile$.next(null);
    }
  }

  /** Refresh the logged-in state and user profile */
  private async refreshSession(): Promise<void> {
    try {
      const user: AuthUser = await getCurrentUser();
      const attributes = await fetchUserAttributes();
      const profile: AwsUserProfile = {
        userId: user.userId,
        email: attributes.email ?? '',
        emailVerified: attributes.email_verified === 'true',
        username: attributes.preferred_username ?? user.username,
        firstName: attributes.given_name,
        lastName: attributes.family_name,
        attributes,
      };
      this._isLoggedIn$.next(true);
      this._userProfile$.next(profile);
    } catch {
      this._isLoggedIn$.next(false);
      this._userProfile$.next(null);
    }
  }

  /** Sign in with email and password */
  async login(email: string, password: string): Promise<{ isSignedIn: boolean; nextStep?: string }> {
    const result = await signIn({ username: email, password });
    if (result.isSignedIn) {
      await this.refreshSession();
    }
    return {
      isSignedIn: result.isSignedIn,
      nextStep: result.nextStep?.signInStep,
    };
  }

  /** Sign out the current user */
  async logout(): Promise<void> {
    await signOut();
    this._isLoggedIn$.next(false);
    this._userProfile$.next(null);
  }

  /** Register a new user with email and password */
  async register(
    email: string,
    password: string,
    givenName?: string,
    familyName?: string,
  ): Promise<{ isSignUpComplete: boolean; nextStep?: string }> {
    const userAttributes: Record<string, string> = { email };
    if (givenName) userAttributes['given_name'] = givenName;
    if (familyName) userAttributes['family_name'] = familyName;

    const result = await signUp({
      username: email,
      password,
      options: { userAttributes },
    });
    return {
      isSignUpComplete: result.isSignUpComplete,
      nextStep: result.nextStep?.signUpStep,
    };
  }

  /** Confirm sign-up with the verification code sent to the user's email */
  async confirmRegistration(email: string, confirmationCode: string): Promise<boolean> {
    const result = await confirmSignUp({ username: email, confirmationCode });
    return result.isSignUpComplete;
  }

  /** Resend the sign-up confirmation code */
  async resendConfirmationCode(email: string): Promise<void> {
    await resendSignUpCode({ username: email });
  }

  /** Send verification code for a user attribute (for existing signed-in users). */
  async sendEmailVerificationCode(): Promise<void> {
    await sendUserAttributeVerificationCode({ userAttributeKey: 'email' });
  }

  /** Initiate a password reset flow */
  async forgotPassword(email: string): Promise<void> {
    await resetPassword({ username: email });
  }

  /** Confirm the new password with the reset code */
  async confirmForgotPassword(email: string, code: string, newPassword: string): Promise<void> {
    await confirmResetPassword({ username: email, confirmationCode: code, newPassword });
  }

  /** Update user profile attributes */
  async updateUserProfile(attributes: {
    givenName?: string;
    familyName?: string;
    email?: string;
  }): Promise<void> {
    const userAttributes: Record<string, string> = {};
    if (attributes.givenName !== undefined) userAttributes['given_name'] = attributes.givenName;
    if (attributes.familyName !== undefined) userAttributes['family_name'] = attributes.familyName;
    if (attributes.email !== undefined) userAttributes['email'] = attributes.email;

    await updateUserAttributes({ userAttributes });
    await this.refreshSession();
  }

  /** Get the current user profile snapshot (non-observable) */
  getUserProfile(): AwsUserProfile | null {
    return this._userProfile$.value;
  }

  /** Delete the current user's account */
  async deleteAccount(): Promise<void> {
    await deleteUser();
    this._isLoggedIn$.next(false);
    this._userProfile$.next(null);
  }

  /** Force-refresh the user profile from Cognito */
  async refreshUserProfile(): Promise<void> {
    await this.refreshSession();
  }

  /** Return current access token for backend API calls. */
  async getAccessToken(): Promise<string | null> {
    const session = await fetchAuthSession();
    return session.tokens?.accessToken?.toString() ?? null;
  }
}
