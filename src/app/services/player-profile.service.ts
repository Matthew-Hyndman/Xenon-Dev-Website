import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable, catchError, of } from 'rxjs';
import { map } from 'rxjs/operators';
import xenonDevConfig from '../config/xenon-dev-config';

export interface PlayerProfile {
  _embedded: {
    player_id: number;
    losses: number;
    pot: number;
    wins: number;
  };
}

@Injectable({
  providedIn: 'root',
})
export class PlayerProfileService {
  private readonly httpClient = inject(HttpClient);
  private readonly playerProfileCache = new Map<string, PlayerProfile>();
  private readonly profileChecked$ = new BehaviorSubject<Map<string, boolean>>(
    new Map()
  );

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
      const exists = !!profile;
      
      // Update cache
      cache.set(userId, exists);
      this.profileChecked$.next(cache);
      
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
      return new Observable(observer => {
        observer.next(this.playerProfileCache.get(userId)!);
        observer.complete();
      });
    }

    return this.httpClient
      .get<PlayerProfile>(
        `${xenonDevConfig.SpringAPIServer.local.url}/api/player/getPlayerDetails/${userId}`
      )
      .pipe(
        map(profile => {
          // Cache the result
          this.playerProfileCache.set(userId, profile);
          return profile;
        }),
        catchError(error => {
          console.error('Error fetching player profile:', error);
          return of(null as any);
        })
      );
  }

  /**
   * Create a new player profile
   */
  createPlayerProfile(userId: string): Observable<PlayerProfile> {
    return this.httpClient
      .post<PlayerProfile>(
        `${xenonDevConfig.SpringAPIServer.local.url}/api/player/createPlayer/${userId}`,
        null
      )
      .pipe(
        map(profile => {
          // Invalidate cache after creation
          this.playerProfileCache.delete(userId);
          const cache = this.profileChecked$.value;
          cache.delete(userId);
          this.profileChecked$.next(cache);
          return profile;
        }),
        catchError(error => {
          console.error('Error creating player profile:', error);
          throw error;
        })
      );
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
