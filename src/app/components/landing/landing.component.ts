import { Component, OnInit, inject } from '@angular/core';
import { BlackJackHelpService } from '../../services/black-jack-help.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { AuthenticationService } from '../../services/authentication.service';
import { firstValueFrom } from 'rxjs';

@Component({
  selector: 'app-landing',
  templateUrl: './landing.component.html',
  styleUrl: './landing.component.css',
  standalone: false,
})
export class LandingComponent implements OnInit {
  private httpClient = inject(HttpClient);
  protected isLoggedInToSession: boolean = false;
  protected userName: string = '';

  blckJackGameRoute: string = '';
  headers = new HttpHeaders({});
  catFact: any;
  showCatFact = false;

  constructor(
    private blackJackHelpService: BlackJackHelpService,
    private authService: AuthenticationService,
  ) {}

  ngOnInit(): void {
    this.isLoggedInCheck();

    if (this.isLoggedInToSession) {
      this.getUserFullName();
    }

    if (this.blackJackHelpService.isHasUserAgreedToDisclaimerNotNull()) {
      if (this.blackJackHelpService.isHasUserAgreedToDisclaimerTrue()) {
        this.blckJackGameRoute = '/black-jack-game';
      }
    } else {
      this.blckJackGameRoute = '/black-jack-help';
    }
  }

  async getCatFact() {
    await firstValueFrom(
      this.httpClient.get<any>(`https://catfact.ninja/fact`, {
        headers: this.headers,
      }),
    )
      .then((response) => {
        this.catFact = response;
        this.showCatFact = true;
      })
      .catch((error) => {
        console.error('Error fetching cat fact: ', error);
      });
  }

  isLoggedInCheck() {
    try {
      this.authService.isLoggedIn$.subscribe((result) => {
        this.isLoggedInToSession = result ?? false;
      });
    } catch (error) {
      console.error('Could not read if session is created: ', error);
    }
  }

  getUserFullName() {
    try {
      this.authService.userProfile$.subscribe((user) => {
        this.userName = user?.firstName ?? '';
        if (typeof user?.lastName !== undefined) {
          this.userName += ' ' + user?.lastName;
        }
      });
    } catch (error) {
      console.error('error retriving userName: ', error);
    }
  }

  login() {
    this.authService.login();
  }
}
