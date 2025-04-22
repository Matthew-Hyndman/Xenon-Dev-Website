import { Card } from "../../../common/card";

export class Deck {
    public theDeck: Card[] = [];

    public placeHolderCard: Card = new Card('n/a', 'n/a', 0, 'public/assets/images/cards/Default_Deck/EmptySpace.jpg');
    public cardFaceDown: Card = new Card('n/a', 'n/a', 0, 'public/assets/images/cards/Default_Deck/FaceDown.jpg');

    public deckSize;

    constructor(){
       this.initDeck();
       this.deckSize = this.theDeck.length
    }

    private initDeck(){
        const suites = ['Clubs', 'Dim', 'Hearts', 'Spades'];
        const values = [
            {name:'2', value:2},
            {name:'3', value:3},
            {name:'4', value:4},
            {name:'5', value:5},
            {name:'6', value:6},
            {name:'7', value:7},
            {name:'8', value:8},
            {name:'9', value:9},
            {name:'10', value:10},
            {name:'Jack', value:10},
            {name:'Queen', value:10},
            {name:'King', value:10},
            {name:'Ace', value:11}
        ];
        suites.forEach(suite => 
            values.forEach(valueObj => 
                this.theDeck.push(
                    new Card(
                        valueObj.name, 
                        suite, 
                        valueObj.value, 
                        `assets\\images\\cards\\Default_Deck\\${suite}${valueObj.name}.jpg`)
                    )
                )
        );

    }

    public shuffle(){
        //the code below is creating a card that is undefined, prevent this from happening
        for(let i = this.deckSize-1; i > 0; i--){
            const randomIndex = Math.floor(Math.random() * (i)/*((i+1) - 0 + 1) + 0*/);
            [this.theDeck[i], this.theDeck[randomIndex]] = [this.theDeck[randomIndex], this.theDeck[i]];            
        }
    }

}
