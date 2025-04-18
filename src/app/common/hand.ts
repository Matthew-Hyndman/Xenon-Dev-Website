import { Card } from "./card";

export class Hand {
    constructor(
        public handName: string,
        public handValue: number = 0,
        public cards: Card[] = [],
        public wins: number = 0
    ){}

    addCard(theCard: Card){
        if(theCard.value == 11 && (this.handValue + theCard.value) > 21){
            this.handValue += 1;
        } else {
            this.handValue += theCard.value;
        }

        this.cards.push(theCard);
    }

    emptyHand(){
        this.cards = [];
        this.handValue = 0;
    }

    hasCardValue(cardValue: number): boolean {
        return this.cards.find(card => card.value == cardValue) != null;
    }

    hasCardFace(cardFace: string): boolean {
        return this.cards.find(card => card.face == cardFace) != null;
    }

   

    toString(): string{
        let cardsStr = '';
        if(this.cards.length === 0){
            return `${this.handName}, ${this.handValue}, Hand: Empty, ${this.wins}`;
        } else {
            return `${this.handName}, ${this.handValue}, \nHand:` + String(this.cards.forEach(card => '[' + card.toString() + ']\n')) + this.wins;
        }
    }
}
