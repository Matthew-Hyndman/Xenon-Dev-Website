import { Component, inject, OnDestroy, OnInit } from '@angular/core';

import { Deck } from './game-objects/deck';
import { Hand } from '../../common/hand';
import { Router } from '@angular/router';
import { BlackJackHelpService } from '../../services/black-jack-help.service';
import { BlackJackGameService } from '../../services/black-jack-game.service';
import { Card } from '../../common/card';

import Swal from 'sweetalert2';
import { AuthenticationService } from '../../services/authentication.service';
import { Subject } from 'rxjs';
import {
  PlayerProfile,
  PlayerProfileService,
} from '../../services/player-profile.service';
import { HttpClient } from '@angular/common/http';
import xenonDevConfig from '../../config/xenon-dev-config';
import Keycloak from 'keycloak-js';

const MAX_HAND_VALUE = 21;

@Component({
  selector: 'app-black-jack-game',
  templateUrl: './black-jack-game.component.html',
  styleUrl: './black-jack-game.component.css',
  standalone: false,
})
export class BlackJackGameComponent implements OnInit, OnDestroy {
  deck!: Deck;
  dealerHand!: Hand;
  playerHand!: Hand;

  totalPickedCards: number = 0;

  useBettingSystem = true;

  useDealerCardRevealDelay = false;

  isFirstGame = true;

  isDoublingDown = false;

  handThatWentBust!: Hand;

  pot: number = 0;
  bet: number = 0;

  private playerProfile: PlayerProfile | null = null;

  private readonly destroy$ = new Subject<void>();

  private readonly keycloak = inject(Keycloak);

  isLoggedIn: boolean | null = false;

  constructor(
    private authenticationService: AuthenticationService,
    private blackJackGameService: BlackJackGameService,
    private playerProfileService: PlayerProfileService,
    private http: HttpClient,
  ) {}

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }

  ngOnInit(): void {
    this.populatePlayerProfileIfExists();

    this.useDealerCardRevealDelay =
      this.blackJackGameService.getDealerTimerToggle();

    this.startNewGame();
  }

  async startNewGame() {
    this.deck = new Deck();
    this.deck.shuffle();

    if (this.pot <= 0) {
      this.pot = 3000;
    }

    if (this.isFirstGame) {
      
      if (!this.isLoggedIn) {
        this.playerHand = new Hand('Player');
        this.dealerHand = new Hand('Dealer');
      }
      this.isFirstGame = false;
    } else {
      this.playerProfileService.updatePlayerProfile(
        this.playerProfile!.player_id!, 
        this.playerProfile!
      );
      this.dealerHand.emptyHand();
      this.playerHand.emptyHand();
    }

    if (this.useBettingSystem) {
      this.bet = 0;
      const default_Bet_amount = this.roundValue(this.pot / 2);
      await Swal.fire({
        title: 'How many tokens are you betting',
        allowOutsideClick: false,
        draggable: true,
        html: `
    <input
      type="number"
      value="${default_Bet_amount}"
      step="1"
      class="swal2-input"
      id="range-value">`,
        input: 'range',
        inputValue: default_Bet_amount,
        inputAttributes: {
          min: '0',
          max: String(this.pot),
          step: '1',
        },
        didOpen: () => {
          const inputRange = Swal.getInput()!;
          const inputNumber = Swal.getPopup()!.querySelector(
            '#range-value',
          ) as HTMLInputElement;

          Swal.getPopup()!.querySelector('output')!.style.display = 'none';
          inputRange.style.width = '100%';
          inputRange.max = String(this.pot);
          inputRange.value = String(default_Bet_amount);
          this.bet = default_Bet_amount;

          inputRange.addEventListener('input', () => {
            inputNumber.value = inputRange.value;
            this.bet = Number(inputNumber.value);
          });

          inputNumber.addEventListener('change', () => {
            inputRange.value = inputNumber.value;
            this.bet = Number(inputNumber.value);
          });
        },
        confirmButtonText: 'Place Bet',
        showCancelButton: true,
        cancelButtonText: 'I am not betting',
      }).then((result) => {
        this.useBettingSystem = result.isConfirmed;
        console.log(`useBettingSystem: [${this.useBettingSystem}]`);
        if (result.isConfirmed) {
          this.pot -= this.bet;
        }
      });
    }

    this.totalPickedCards = 0;

    //pick one card for the dealer
    this.addToHand(this.dealerHand);

    //pick on card for the player
    this.addToHand(this.playerHand);
  }

  addToHand(theHand: Hand) {
    const newCard = this.pickCard();
    try {
      theHand.addCard(newCard);
      console.log(
        `${theHand.handName} picked: [${newCard.suit}][${newCard.value}][${newCard.imageUrl}]`,
      );
    } catch (error) {
      const errorFound = `${theHand.handName} Data:\nthe new Card [${String(
        newCard.toString(),
      )}], \nHand Data:\n ${String(
        theHand.toString(),
      )}\nerror message:\n${error}`;
      console.log(errorFound);
      Swal.fire({
        title: 'Error',
        icon: 'error',
        text: errorFound,
      });
    }
  }

  pickCard(): Card {
    const theCard = this.deck.theDeck[this.totalPickedCards];
    this.totalPickedCards += 1;
    return theCard;
  }

  playerPickCard() {
    this.addToHand(this.playerHand);
    if (this.playerHand.handValue > MAX_HAND_VALUE) {
      this.Bust(this.playerHand);
    }
  }

  hasScoreExceededMaxValue(theScore: number): boolean {
    return theScore > MAX_HAND_VALUE;
  }

  async sleep(milsec: number) {
    return new Promise((resolve) => setTimeout(resolve, milsec));
  }

  async stay() {
    const playerScore = this.playerHand.handValue;
    let dealerScore = this.dealerHand.handValue;
    do {
      this.addToHand(this.dealerHand);
      dealerScore = this.dealerHand.handValue;
      if (this.useDealerCardRevealDelay) {
        await this.sleep(1250);
      }
      if (this.hasScoreExceededMaxValue(dealerScore)) {
        this.Bust(this.dealerHand);
        return;
      }
    } while (!this.isDealerScoreMoreThanPlayerScore());

    if (dealerScore === playerScore) {
      //a draw between the player and the dealer

      await Swal.fire({
        title: 'Draw!',
        text: `you scored: ${this.playerHand.handValue} | dealer scored: ${this.dealerHand.handValue}`,
        draggable: true,
        didClose: () => {},
      });
      if (this.useBettingSystem) {
        this.pot += this.bet;
      }
      this.startNewGame();
    } else if (this.isDealerScoreMoreThanPlayerScore()) {
      //player loses
      this.Bust(this.playerHand);
    } else {
      //player wins
      this.Bust(this.dealerHand);
    }
  }

  isDealerScoreMoreThanPlayerScore(): boolean {
    return this.dealerHand.handValue > this.playerHand.handValue;
  }

  isHandBlackJack(theHand: Hand): boolean {
    return theHand.hasCardFace('Ace') && theHand.hasCardValue(10);
  }

  async Bust(theHand: Hand) {
    if (theHand.handName === 'Dealer') {
      this.playerHand.wins += 1;
      if (this.isLoggedIn){
        this.playerProfile!.wins! += 1;
      }
      let winType = '';

      if (this.isHandBlackJack(this.playerHand)) {
        winType = 'Black Jack!!!';
      } else {
        winType = 'You Win!!!';
      }

      await Swal.fire({
        title: winType,
        text: `you scored: ${this.playerHand.handValue} | dealer scored: ${this.dealerHand.handValue}`,
        imageUrl: 'assets/images/trophy.png',
        draggable: true,
        didClose: () => {},
      });
      if (this.useBettingSystem) {
        let payout: number = 0;
        let payOutMultiplyer: number = this.isHandBlackJack(this.playerHand)
          ? 1.5
          : 2;
        this.isDoublingDown
          ? (payout = 2 * (payOutMultiplyer * this.bet))
          : (payout = payOutMultiplyer * this.bet);

        payout = this.roundValue(payout);

        this.pot += payout;
      }
    } else {
      if (this.isLoggedIn){
        this.playerProfile!.losses! += 1;
      }
      this.dealerHand.wins += 1;
      let lossType = '';

      if (this.isDealerScoreMoreThanPlayerScore()) {
        lossType = 'You Lost';
      } else {
        lossType = 'Bust!';
      }

      await Swal.fire({
        title: lossType,
        text: `you scored: ${this.playerHand.handValue} | dealer scored: ${this.dealerHand.handValue}`,
        icon: 'error',
        draggable: true,
        didClose: () => {},
      });
      if (this.isDoublingDown) {
        this.pot -= this.bet;
      }
    }
    this.handThatWentBust = theHand;
    if (this.isLoggedIn){
      this.playerProfile!.pot! = this.pot;
    }
    this.startNewGame();
  }

  isBettingEnabled(event: any) {
    this.useBettingSystem = event.target.checked;
    this.startNewGame();
  }

  isDealerCardDelayEnabled(event: any) {
    this.useDealerCardRevealDelay = event.target.checked;
    this.blackJackGameService.setDealerTimerToggle(event.target.checked);
  }

  doubleDown() {
    this.isDoublingDown = true;
    this.playerPickCard();
    if (this.playerHand.handValue <= MAX_HAND_VALUE) {
      this.stay();
    }
    this.isDoublingDown = false;
  }

  roundValue(value: number) {
    if (value % 2) {
      value = Math.round(value);
    }

    return value;
  }

  populatePlayerProfileIfExists() {
    this.authenticationService.isLoggedIn$.subscribe((isLoggedIn) => {
      if (isLoggedIn) {
        this.isLoggedIn = isLoggedIn;
        
        this.authenticationService.userProfile$.subscribe((userProfile) => {
          this.playerHand = new Hand(userProfile?.username ?? 'Player');
          this.dealerHand = new Hand('Dealer');
        });

        // get the player profile from the service
        this.playerProfileService.playerProfile$.subscribe((profile) => {
          this.playerProfile = profile;
          this.pot = profile?.pot ?? 3000;
          this.playerHand.wins = profile?.wins ?? 0;
          this.dealerHand.wins = profile?.losses ?? 0;
        });
      }
    });
  }
}
