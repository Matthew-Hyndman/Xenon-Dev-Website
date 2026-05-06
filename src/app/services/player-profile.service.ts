import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {
  BehaviorSubject,
  Observable,
  catchError,
  of,
  firstValueFrom
} from 'rxjs';
import { tap } from 'rxjs/operators';
import xenonDevConfig from '../config/xenon-dev-config';
import { AwsLoginService } from './aws-login.service';
import { generateClient } from 'aws-amplify/data';
import { updateUserAttributes } from 'aws-amplify/auth';
import { Schema } from '../../../amplify/data/resource';
import { a } from '@aws-amplify/backend';

export interface PlayerProfile {
  player_id?: string;
  losses?: number;
  pot?: number;
  wins?: number;
}

const client = generateClient<Schema>();

@Injectable({
  providedIn: 'root'
})
export class PlayerProfileService {
  private readonly httpClient = inject(HttpClient);
  private readonly awsLoginService = inject(AwsLoginService);
  private readonly playerProfileCache = new Map<string, PlayerProfile>();
  private readonly profileChecked$ = new BehaviorSubject<Map<string, boolean>>(
    new Map()
  );

  private readonly _playerProfile$ = new BehaviorSubject<PlayerProfile | null>(
    null
  );
  public readonly playerProfile$ = this._playerProfile$.asObservable();

  /**
   * Check if a player profile exists for a given user ID
   * Uses caching to avoid repeated API calls
   */
  async checkPlayerProfileExists(userId: string): Promise<boolean> {
    // Check cache first
    const cache = this.profileChecked$.value;
    /*if (cache.has(userId)) {
      return cache.get(userId) || false;
    }*/

    const playerId = this.awsLoginService.getUserProfile()?.attributes['custom:player_id'] as string;

    try {
      const profile = await this.getPlayerProfile(userId, playerId);
      const exists = profile !== null;

      // Update cache
      cache.set(playerId, exists);
      this.profileChecked$.next(cache);

      if (exists) {
        // Update player profile observable
        this._playerProfile$.next(profile);
      }

      return exists;
    } catch (error) {
      // Profile doesn't exist
      cache.set(playerId, false);
      this.profileChecked$.next(cache);
      return false;
    }
  }

  /**
   * Retrieve player profile by user ID
   * Returns null if profile doesn't exist (404 error)
   */
  async getPlayerProfile(userId: string, playerId: string): Promise<PlayerProfile | null> {
    // Check in-memory cache first
    /*if (this.playerProfileCache.has(userId)) {
      return this.playerProfileCache.get(userId)!;
    }*/
    let profile: PlayerProfile | null = null;
    await client.models.PlayerProfile.get({ player_id: playerId }).then(
      response => {
        if (response?.data) {
        console.log(`retrived`, response);                
        profile = {
          player_id: response?.data?.player_id,
          losses: response?.data?.losses as number,
          pot: response?.data?.pot as number,
          wins: response?.data?.wins as number
        };
      } else {
        console.log(`No playerprofile found`);
      }
      }
    );
    if (profile) {
      // Cache the result
      this.playerProfileCache.set(userId, profile);
    }

    return profile;
  }

  /**
   * Create a new player profile
   */
  async createPlayerProfile(userId: string) {
    const playerProfile: PlayerProfile = {
      pot: 3000,
      wins: 0,
      losses: 0
    };

    const player_Profile_id: string = crypto.randomUUID(); // Generate a unique ID for the player profile

    const userAttributes: Record<string, string> = {};
    userAttributes['custom:player_id'] = player_Profile_id;
    await updateUserAttributes({ userAttributes });

    client.models.PlayerProfile.create({
      player_id: player_Profile_id,
      ...playerProfile
    }).then(() => {
      // Invalidate cache after creation
      this.playerProfileCache.delete(userId);
      const cache = this.profileChecked$.value;
      cache.delete(userId);
      this.profileChecked$.next(cache);
      this.playerProfileCache.set(userId, playerProfile);
      this._playerProfile$.next(playerProfile);
    });
  }

  /**
   * reset player profile to default values
   */
  async resetPlayerProfile(player_id: string) {
    const playerProfile: PlayerProfile = {      
      pot: 3000,
      wins: 0,
      losses: 0
    };

    client.models.PlayerProfile.update({
      player_id,
      ...playerProfile
    })
      .then(updatedProfile => {
        console.log('Player profile reset successfully:', updatedProfile);
        // Invalidate cache after reset
        this.playerProfileCache.delete(player_id);
        const cache = this.profileChecked$.value;
        cache.delete(player_id);
        this.profileChecked$.next(cache);
        playerProfile.player_id = player_id; // Ensure player_id is set in the profile
        this.playerProfileCache.set(player_id, playerProfile);
        this._playerProfile$.next(playerProfile);
      })
      .catch(error => {
        console.error('Error resetting player profile:', error);
      });
  }

  /**
   * Delete player profile by Player ID
   */
  async deletePlayerProfile(player_id: string) {
    client.models.PlayerProfile.delete({ player_id }).then(() => {
      this.awsLoginService.deletePlayerProfileRealtion();
      // Clear player profile cache on deletion
      this.clearCache(player_id);
      this._playerProfile$.next(null);
    });
  }

  /**
   * Clear cache for a specific user or all users
   */
  clearCache(userId?: string): void {
    if (userId) {
      this.playerProfileCache.delete(userId);
      const cache = this.profileChecked$.value;
      cache.delete(userId);
      this.profileChecked$.next(cache);
    } else {
      this.playerProfileCache.clear();
      this.profileChecked$.next(new Map());
    }
  }

  async updatePlayerProfile(profile_id: string, thePlayerProfile: PlayerProfile) {
    
    client.models.PlayerProfile.update({
      player_id: profile_id,
      ...thePlayerProfile
    })
    .then(() => console.log('Player profile updated successfully'))
    .catch(error => console.error('Error updating player profile:', error));        
  }

  /**
   * Get cache status observable
   */
  getProfileCheckedStatus$(): Observable<Map<string, boolean>> {
    return this.profileChecked$.asObservable();
  }

  private async getRequiredAccessToken(): Promise<string> {
    const token = await this.awsLoginService.getAccessToken();
    if (!token) {
      throw new Error('No authenticated Cognito session is available.');
    }
    return token;
  }
}
