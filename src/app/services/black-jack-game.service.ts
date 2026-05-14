import { inject, Injectable, PLATFORM_ID } from '@angular/core';
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
  
}