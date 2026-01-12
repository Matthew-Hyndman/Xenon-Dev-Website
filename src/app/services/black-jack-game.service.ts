import { inject, Injectable, PLATFORM_ID } from '@angular/core';
import { KeycloakProfile } from 'keycloak-js';
import { Hand } from '../common/hand';
import xenonDevConfig from '../config/xenon-dev-config';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class BlackJackGameService {

  protected player_id: number = 0;
  protected player_losses: number = 0;
  protected player_pot: number = 0;

  constructor(private httpClient: HttpClient) { }

  setDealerTimerToggle(value: boolean){
    localStorage.setItem('dealerTimerToggle', String(value));
  }

  getDealerTimerToggle(): boolean{
    return this.getDealerTimerToggleDirect() != typeof null && this.getDealerTimerToggleDirect() == 'true';
  }

  getDealerTimerToggleDirect(): string | null{
    return localStorage.getItem('dealerTimerToggle');
  }

  getPlayerProfileAndPopulateGameData(theUser: KeycloakProfile): Hand | void {
    const url = `${xenonDevConfig.SpringAPIServer.local.url}/api/user/getPlayerDetails/${theUser.id}`;
    this.httpClient.get<PlayerProfileResponse>(url).subscribe({
      next: (response) => {
        if (response !== null) {
        this.player_id = response.playerId;
        this.player_losses = response.losses;
        this.player_pot = response.pot;

        const playerHand: Hand = new Hand(
          theUser.username || '',
          0,
          [],
          response.wins
        );
        return playerHand;
      } else {
        console.info('Player profile does not exist for user:', theUser.username);
        return null;
      }
      },
      error: (error) => {        
        alert('Error fetching player profile: ' + error);
        return null;
      }
    });
  }
}

interface PlayerProfileResponse {
    playerId: number,
    losses: number,
    pot: number,
    wins: number;
}