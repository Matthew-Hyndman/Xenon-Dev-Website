import { inject, Injectable, PLATFORM_ID } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class BlckJackGameService {

  setDealerTimerToggle(value: boolean){
    localStorage.setItem('dealerTimerToggle', String(value));
  }

  getDealerTimerToggle(): boolean{
    return this.getDealerTimerToggleDirect() != typeof null && this.getDealerTimerToggleDirect() == 'true';
  }

  getDealerTimerToggleDirect(): string | null{
    return localStorage.getItem('dealerTimerToggle');
  }

  constructor() { }
}
