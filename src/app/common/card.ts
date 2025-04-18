export class Card {
    constructor(
        public face: string,
        public suit: string,
        public value: number,
        public imageUrl: string
    ){}

    toString(): string{
        try{
        return `${this.face}, ${this.suit}, ${this.value}, ${this.imageUrl}`;
        } catch {

            let messageBuilder = ['[error in Card.toString()]: '];

            //face
            if (this.face == undefined) {
                messageBuilder.push('face is undefined');
            } else {
                messageBuilder.push(this.face);
            }

            //suit
            if (this.suit == undefined) {
                messageBuilder.push('suit is undefined');
            } else {
                messageBuilder.push(this.suit);
            }

            //value
            if (this.value == undefined) {
                messageBuilder.push('value is undefined');
            } else {
                messageBuilder.push(String(this.value));
            }

            //imageUrl
            if (this.imageUrl == undefined) {
                messageBuilder.push('imageUrl is undefined');
            } else {
                messageBuilder.push(this.face);
            }

            if (messageBuilder.length === 0) {
                return 'error';
            } else {
                return String(messageBuilder.forEach(obj => obj + ','));
            }
        }
    }
}
