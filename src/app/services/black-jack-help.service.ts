import { isPlatformBrowser } from '@angular/common';
import { inject, Injectable, OnInit, PLATFORM_ID } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class BlackJackHelpService implements OnInit {
  private readonly platformId = inject(PLATFORM_ID);

  storage: Storage|null = null;

  constructor() {}

  ngOnInit(): void {
    this.checkSessionStorage()
  }

  private checkSessionStorage(){
    if(typeof sessionStorage !== null){
      this.storage = sessionStorage;
    }
  }

  setHasUserAgreedToDisclamer(accepted: boolean) {

    if (this.storage == null) {
      this.checkSessionStorage()
    }
    
    this.storage?.setItem(
      'hasUserAgreedToDisclaimer',
      String(accepted)
    );
  }

  isHasUserAgreedToDisclaimerTrue(): boolean {
    if (isPlatformBrowser(this.platformId)) {
      return this.storage?.getItem('hasUserAgreedToDisclaimer') == 'true';
    }

    return false;
  }

  isHasUserAgreedToDisclaimerNull(): boolean {
    if (isPlatformBrowser(this.platformId)) {
      return this.storage?.getItem('hasUserAgreedToDisclaimer') != null;
    }

    return false;
  }
}
