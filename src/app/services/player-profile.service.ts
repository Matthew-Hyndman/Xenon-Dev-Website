import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable, catchError, of } from 'rxjs';
import { map, tap } from 'rxjs/operators';
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
      const profileObvervable = await this.getPlayerProfile(userId);
      const exists = !!profileObvervable;

      if (exists) {
        // Update cache
        cache.set(userId, exists);
        this.profileChecked$.next(cache);
        // Update player profile observable
        profileObvervable.subscribe((profile) => {
          this._playerProfile$.next(profile);
        });
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
   */
  getPlayerProfile(userId: string): Observable<PlayerProfile> {
    // Check in-memory cache first
    if (this.playerProfileCache.has(userId)) {
      return new Observable((observer) => {
        observer.next(this.playerProfileCache.get(userId)!);
        observer.complete();
      });
    }

    return this.httpClient
      .get<PlayerProfile>(
        `${xenonDevConfig.SpringAPIServer.local.url}/api/player/getPlayerDetails/${userId}`,
      )
      .pipe(
        tap((profile) => {
          console.log('Fetched player profile:', profile);
        }),
        map((profile) => {
          // Cache the result
          this.playerProfileCache.set(userId, profile);
          return profile;
        }),
        catchError((error) => {
          console.error('Error fetching player profile:', error);
          return of(null as any);
        }),
      );
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

  /**
   * Get cache status observable
   */
  getProfileCheckedStatus$(): Observable<Map<string, boolean>> {
    return this.profileChecked$.asObservable();
  }
}
