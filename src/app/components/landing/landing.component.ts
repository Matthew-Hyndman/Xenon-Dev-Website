import { Component, OnInit } from '@angular/core';
import { BlackJackHelpService } from '../../services/black-jack-help.service';
import {
  HttpClient,
  HttpClientModule,
  HttpHeaders,
} from '@angular/common/http';
import { AuthenticationService } from '../../services/authentication.service';

@Component({
  selector: 'app-landing',
  //imports: [HttpClientModule],
  templateUrl: './landing.component.html',
  styleUrl: './landing.component.css',
})
export class LandingComponent implements OnInit {
  protected isLoggedInToSession: boolean = false;
  protected userName: string = '';

  blckJackGameRoute: string = '';
  headers = new HttpHeaders({});
  catFact: any;
  showCatFact = false;

  constructor(
    private blackJackHelpService: BlackJackHelpService,
    private httpClient: HttpClient,
    private authService: AuthenticationService
  ) {}

  ngOnInit(): void {
    this.isLoggedInCheck();

    if(this.isLoggedInToSession){
      this.getUserFullName();
    }

    if (this.blackJackHelpService.isHasUserAgreedToDisclaimerNull()) {
      if (this.blackJackHelpService.isHasUserAgreedToDisclaimerTrue()) {
        this.blckJackGameRoute = '/black-jack-game';
      }
    } else {
      this.blckJackGameRoute = '/black-jack-help';
    }
  }

  getCatFact() {
    this.httpClient
      .get<any>(`https://catfact.ninja/fact`, {
        headers: this.headers,
      })
      .subscribe((data) => {
        this.catFact = data;
      });

    this.showCatFact = true;
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

  getUserFullName(){
    try{
      this.authService.userProfile$.subscribe((user) => {
        this.userName = user?.firstName ?? '';
        if (typeof(user?.lastName) !== undefined) {
          this.userName += ' ' + user?.lastName
        }
      });
    } catch (error) {
      console.error('error retriving userName: ', error)
    }
  }

}
