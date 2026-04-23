import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import xenonDevConfig from '../config/xenon-dev-config';
import { Observable, from } from 'rxjs';
import { switchMap } from 'rxjs/operators';
import { AwsLoginService } from './aws-login.service';

@Injectable({
  providedIn: 'root'
})
export class LeaderboardService {
  
  private readonly httpClient = inject(HttpClient);
  private readonly awsLoginService = inject(AwsLoginService);

  getLeaderboard(page: number, pageSize: number): Observable<LeaderboardResponse> {
    const url = `${xenonDevConfig.SpringAPIServer.url}/api/player/leaderboard?page=${page - 1}&size=${pageSize}`;

    return from(this.awsLoginService.getAccessToken()).pipe(
      switchMap((token) => {
        if (!token) {
          throw new Error('No authenticated Cognito session is available.');
        }

        return this.httpClient.get<LeaderboardResponse>(url, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
      }),
    );
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
}

