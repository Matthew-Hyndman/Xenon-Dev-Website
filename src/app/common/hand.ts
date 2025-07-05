import { Card } from './card';

export class Hand {
  constructor(
    public handName: string,
    public handValue: number = 0,
    public cards: Card[] = [],
    public wins: number = 0
  ) {}


  private MAX_HAND_VALUE = 21;

  addCard(theCard: Card) {
    if (this.willCardMakeHadGoBust(theCard.value) && !this.isAce(theCard)) {
      this.cards.forEach((card) => {
        if (this.isAce(card)) {
          card.value = 1;
          this.handValue -= 10;
          return;
        }
      });
                this.addHandValue(theCard.value);

    } else if (theCard.value == 11 && this.willCardMakeHadGoBust(theCard.value)) {
      this.handValue += 1;
      theCard.value = 1;
    } else {
      this.addHandValue(theCard.value);
    }

    this.cards.push(theCard);
  }

  private willCardMakeHadGoBust(theCardValue: number): boolean{
    return this.handValue + theCardValue > this.MAX_HAND_VALUE;
  }

  isAce(theCard: Card): boolean {
    return theCard.face === 'Ace' && theCard.value === 11;
  }

  addHandValue(theValue: number) {
    this.handValue += theValue;
  }

  emptyHand() {
    this.cards = [];
    this.handValue = 0;
  }

  hasCardValue(cardValue: number): boolean {
    return this.cards.find((card) => card.value == cardValue) != null;
  }

  hasCardFace(cardFace: string): boolean {
    return this.cards.find((card) => card.face == cardFace) != null;
  }

  toString(): string {
    if (this.cards.length === 0) {
      return `\nname: ${this.handName}, \nhandValue: ${this.handValue}, \nHand: Empty, \nWins: ${this.wins}`;
    } else {
      let cardStr = '';
      this.cards.forEach((card, index) => cardStr += `\n${index}:[${card.toString()}]`)
      return (  
        `\nname: ${this.handName}, \nhandValue: ${this.handValue}, \nHand:` +
        cardStr +
        '\nWins: ' + this.wins
      );
    }
  }
}
