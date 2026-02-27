import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable, catchError, of, firstValueFrom } from 'rxjs';
import { map, tap, throwIfEmpty } from 'rxjs/operators';
import xenonDevConfig from '../config/xenon-dev-config';
import Keycloak from 'keycloak-js';

export interface PlayerProfile {
  player_id?: number;
  losses?: number;
  pot?: number;
  wins?: number;
}

@Injectable({
  providedIn: 'root',
})
export class PlayerProfileService {
  private readonly httpClient = inject(HttpClient);
  private readonly keycloak = inject(Keycloak);
  private readonly playerProfileCache = new Map<string, PlayerProfile>();
  private readonly profileChecked$ = new BehaviorSubject<Map<string, boolean>>(
    new Map(),
  );

  private readonly _playerProfile$ = new BehaviorSubject<PlayerProfile | null>(null);
  public readonly playerProfile$ = this._playerProfile$.asObservable();

  /**
   * Check if a player profile exists for a given user ID
   * Uses caching to avoid repeated API calls
   */
  async checkPlayerProfileExists(userId: string): Promise<boolean> {
    // Check cache first
    const cache = this.profileChecked$.value;
    if (cache.has(userId)) {
      return cache.get(userId) || false;
    }

    try {
      const profile = await this.getPlayerProfile(userId);
      const exists = profile !== null;

      // Update cache
      cache.set(userId, exists);
      this.profileChecked$.next(cache);
      
      if (exists) {
        // Update player profile observable
        this._playerProfile$.next(profile);
      }

      return exists;
    } catch (error) {
      // Profile doesn't exist
      cache.set(userId, false);
      this.profileChecked$.next(cache);
      return false;
    }
  }

  /**
   * Retrieve player profile by user ID
   * Returns null if profile doesn't exist (404 error)
   */
  async getPlayerProfile(userId: string): Promise<PlayerProfile | null> {
    // Check in-memory cache first
    if (this.playerProfileCache.has(userId)) {
      return this.playerProfileCache.get(userId)!;
    }

    await this.keycloak.updateToken(30); // Ensure token is fresh
    const token = this.keycloak.token;

    const profile = await firstValueFrom(
      this.httpClient
        .get<PlayerProfile>(
          `${xenonDevConfig.SpringAPIServer.local.url}/api/player/getPlayerDetails/${userId}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          },
        )
        .pipe(
          tap((result) => {
            console.log('Fetched player profile:', result);
          }),
          catchError((error) => {
            if (error.status === 404) {
              console.info('Player profile not found for user');
              return of(null);
            } else {
              console.error('Error fetching player profile:', error);
              throw error;
            }
          }),
        ),
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
      losses: 0,
    };

    const token = this.keycloak.token;

    return this.httpClient
      .post<PlayerProfile>(
        `${xenonDevConfig.SpringAPIServer.local.url}/api/player/createPlayer/${userId}`,
        playerProfile,
        {
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${token}`,
          },
        },
        /*
        might have to send spesified method, headers, and body here
        like in authentication service        
        */
      )
      .pipe(
        tap((response) => {
          // Invalidate cache after creation
          this.playerProfileCache.delete(userId);
          const cache = this.profileChecked$.value;
          cache.delete(userId);
          this.profileChecked$.next(cache);
          this.playerProfileCache.set(userId, response);
          this._playerProfile$.next(response);
        }),
        catchError((error) => {
          console.error('Error creating player profile:', error);
          throw error;
        }),
      )
      .subscribe();
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

    async updatePlayerProfile(profile_id: number, thePlayerProfile: PlayerProfile) {
      await this.keycloak.updateToken(30); // Ensure token is fresh
      const token = this.keycloak.token;
      this.httpClient
        .patch(
          `${xenonDevConfig.SpringAPIServer.local.url}/api/player/updatePlayer/${profile_id}`,
          thePlayerProfile,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          },
        )
        .subscribe({
          next: (response) => {
            console.log('Player profile updated successfully:', response);
          },
          error: (error) => {
            console.error('Error updating player profile:', error);
          },
        });
    }

  /**
   * Get cache status observable
   */
  getProfileCheckedStatus$(): Observable<Map<string, boolean>> {
    return this.profileChecked$.asObservable();
  }
}
