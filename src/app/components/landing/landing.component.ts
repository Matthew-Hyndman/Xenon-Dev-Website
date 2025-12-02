import { Component, OnInit, inject } from '@angular/core';
import { BlackJackHelpService } from '../../services/black-jack-help.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';


@Component({
    selector: 'app-landing',
    //imports: [HttpClientModule],
    templateUrl: './landing.component.html',
    styleUrl: './landing.component.css',
    standalone: false
})
export class LandingComponent implements OnInit {
  private httpClient = inject(HttpClient)
  
  blckJackGameRoute: string = '';
  headers = new HttpHeaders({});
  catFact: any;
  showCatFact = false

  constructor(
    private blackJackHelpService: BlackJackHelpService,    
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
