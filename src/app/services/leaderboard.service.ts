import { inject, Injectable } from '@angular/core';
import { Observable, from } from 'rxjs';
import { generateClient } from 'aws-amplify/api';
import { Schema } from '../../../amplify/data/resource';


const client = generateClient<Schema>();

@Injectable({
  providedIn: 'root'
})
export class LeaderboardService {

  /**
   * DynamoDB uses cursor-based pagination via nextToken.
   * We cache the nextToken returned at the end of each page so that
   * sequential navigation (1→2→3…) and backward navigation work
   * without re-scanning the table.
   * Key: page number that the token LEADS TO (e.g. token at index 2 unlocks page 2).
   */
  private readonly pageTokenCache = new Map<number, string | undefined>([[1, undefined]]);

  getLeaderboard(page: number, pageSize: number): Observable<LeaderboardResponse> {
    return from(this.fetchPage(page, pageSize));
  }

  private async fetchPage(page: number, pageSize: number): Promise<LeaderboardResponse> {
    // Ensure we have the token for this page, fetching intermediate pages if needed.
    await this.buildTokenChain(page, pageSize);

    const nextToken = this.pageTokenCache.get(page);
    const result = await client.models.PlayerProfile.list({
      
      limit: pageSize,
      nextToken,
    });

    // Cache the token that unlocks the NEXT page.
    if (result.nextToken) {
      this.pageTokenCache.set(page + 1, result.nextToken);
    }

    const content = result.data.map(profile => ({
      wins: profile.wins ?? 0,
      losses: profile.losses ?? 0,
      pot: profile.pot ?? 3000,
      username: profile.username,
    })).sort((a, b) => b.pot - a.pot); // Lazy Sort by pot descending

    return {
      content,
      totalElements: content.length,
      hasNextPage: !!result.nextToken,
    };
  }

  /**
   * Sequentially fetches intermediate pages to populate the token cache
   * up to the requested page. This handles cases where the user jumps
   * ahead without visiting the preceding pages.
   */
  private async buildTokenChain(targetPage: number, pageSize: number): Promise<void> {
    for (let p = 1; p < targetPage; p++) {
      if (this.pageTokenCache.has(p + 1)) {
        continue; // token for the next page already known
      }
      const token = this.pageTokenCache.get(p);
      const result = await client.models.PlayerProfile.list({ limit: pageSize, nextToken: token });
      if (!result.nextToken) {
        // No further pages exist; cache undefined so callers get an empty page.
        this.pageTokenCache.set(p + 1, undefined);
      } else {
        this.pageTokenCache.set(p + 1, result.nextToken);
      }
    }
  }

  /** Call this when the page size changes so cached tokens are no longer valid. */
  resetPagination(): void {
    this.pageTokenCache.clear();
    this.pageTokenCache.set(1, undefined);
  }

}

export interface LeaderboardResponse {
  content: {
    wins: number;
    losses: number;
    pot: number;
    username: string;
  }[];
  totalElements: number;
  hasNextPage: boolean;
}


