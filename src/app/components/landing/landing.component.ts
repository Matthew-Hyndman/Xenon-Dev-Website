import { Component, OnInit } from '@angular/core';
import { BlackJackHelpService } from '../../services/black-jack-help.service';
import { HttpClient, HttpClientModule, HttpHeaders } from '@angular/common/http';


@Component({
  selector: 'app-landing',
  standalone: true,
  imports: [HttpClientModule],
  templateUrl: './landing.component.html',
  styleUrl: './landing.component.css'
})
export class LandingComponent implements OnInit {

  blckJackGameRoute: string = '';
  headers = new HttpHeaders({});
  catFact: any;
  showCatFact = false

  constructor(
    private blackJackHelpService: BlackJackHelpService,
    private httpClient: HttpClient
  ) {}

  ngOnInit(): void {
    if (this.blackJackHelpService.isHasUserAgreedToDisclaimerNull()) {
      if (this.blackJackHelpService.isHasUserAgreedToDisclaimerTrue()) {
        this.blckJackGameRoute = "/black-jack-game";   
      }
    } else {
      this.blckJackGameRoute = "/black-jack-help";
    }
  }

  getCatFact(){
    this.httpClient.get<any>(`https://catfact.ninja/fact`, {
      headers: this.headers
    }).subscribe(data => {
      this.catFact = data
    });

    this.showCatFact = true;
  }

}
