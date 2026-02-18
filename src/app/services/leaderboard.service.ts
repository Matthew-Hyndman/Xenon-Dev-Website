import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import Keycloak from 'keycloak-js';
import xenonDevConfig from '../config/xenon-dev-config';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class LeaderboardService {
  
  private readonly httpClient = inject(HttpClient);
  private readonly keycloak = inject(Keycloak);

  getLeaderboard(): Observable<LeaderboardResponse[]> {
    const url = `${xenonDevConfig.SpringAPIServer.local.url}/api/player/leaderboard`;

    this.ensureIsTokenValid();
    const token = this.keycloak.token;

    return this.httpClient.get<LeaderboardResponse[]>(url, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
  }

  async ensureIsTokenValid(): Promise<void> {
    await this.keycloak.updateToken(30);
  }

}

export interface LeaderboardResponse {
  wins: number;
  losses: number;
  pot: number;
  username: string;
}

