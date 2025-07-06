import { Card } from './card';
import { Hand } from './hand';

fdescribe('Hand', () => {
  
  //declare hand
    var hand = new Hand('test');

    //create cards data
    const suites = ['Clubs', 'Dim', 'Hearts', 'Spades'];
    const values = [
      { name: '2', value: 2 },
      { name: '3', value: 3 },
      { name: '4', value: 4 },
      { name: '5', value: 5 },
      { name: '6', value: 6 },
      { name: '7', value: 7 },
      { name: '8', value: 8 },
      { name: '9', value: 9 },
      { name: '10', value: 10 },
      { name: 'Jack', value: 10 },
      { name: 'Queen', value: 10 },
      { name: 'King', value: 10 },
      { name: 'Ace', value: 11 },
    ];

  it('should create an instance', () => {
    expect(new Hand('', 0, [], 0)).toBeTruthy();
  });

  it('should change hand value [Ace,7,8]', () => {
    
    const test_cards = [
      //Ace Dim
      new Card(
        values[12].name,
        suites[1],
        values[12].value,
        'n/a',
      ),
      //Hearts 7
      new Card(
        values[5].name,
        suites[2],
        values[5].value,
        'n/a',
      ),
      //Clubs 8
      new Card(
        values[6].name,
        suites[0],
        values[6].value,
        'n/a',
      )
    ];

    //reseting hand
    hand.emptyHand();

    //add cards to hand
    test_cards.forEach((card) => hand.addCard(card));


    //expect hand value is accurate
    const expectedValue = 16;
    if(hand.handValue === expectedValue){
      expect(hand.handValue).toEqual(expectedValue);
    } else {
      fail(`expected: ${expectedValue} got ${hand.handValue}`);
      console.log(`expected: ${expectedValue} got ${hand.handValue} {\n${hand.toString()}\n}`);
    }
  });

  it('should change hand value [2,4,Ace,8]', () => {
    
    const test_cards = [
      //Clubs 2
      new Card(
        values[0].name,
        suites[0],
        values[0].value,
        'n/a',
      ),
      //Dim 4
      new Card(
        values[2].name,
        suites[1],
        values[2].value,
        'n/a',
      ),
      //Spades Ace
      new Card(
        values[12].name,
        suites[3],
        values[12].value,
        'n/a',
      ),
      //Clubs 8
      new Card(
        values[6].name,
        suites[0],
        values[6].value,
        'n/a',
      )
    ];

    //reseting hand
    hand.emptyHand();

    //add cards to hand
    test_cards.forEach((card) => hand.addCard(card));


    //expect hand value is accurate
    const expectedValue = 15;
    if(hand.handValue === expectedValue){
      expect(hand.handValue).toEqual(expectedValue);
    } else {
      fail(`expected: ${expectedValue} got ${hand.handValue}`);
      console.log(`expected: ${expectedValue} got ${hand.handValue} {\n${hand.toString()}\n}`);
    }
  });

    it('should change hand value [Ace,Ace,8]', () => {
    
    const test_cards = [
      //Ace Dim
      new Card(
        values[12].name,
        suites[1],
        values[12].value,
        'n/a',
      ),
      //Ace Spades
      new Card(
        values[12].name,
        suites[3],
        values[12].value,
        'n/a',
      ),
      //Clubs 8
      new Card(
        values[6].name,
        suites[0],
        values[6].value,
        'n/a',
      )
    ];

    //reseting hand
    hand.emptyHand();

    //add cards to hand
    test_cards.forEach((card) => hand.addCard(card));


    //expect hand value is accurate
    const expectedValue = 20;
    if(hand.handValue === expectedValue){
      expect(hand.handValue).toEqual(expectedValue);
    } else {
      fail(`expected: ${expectedValue} got ${hand.handValue}`);
      console.log(`expected: ${expectedValue} got ${hand.handValue} {\n${hand.toString()}\n}`);
    }
  });

    it('should change hand value [Ace,Ace,8,King]', () => {
    
    const test_cards = [
      //Ace Dim
      new Card(
        values[12].name,
        suites[1],
        values[12].value,
        'n/a',
      ),
      //Ace Spades
      new Card(
        values[12].name,
        suites[3],
        values[12].value,
        'n/a',
      ),
      //Clubs 8
      new Card(
        values[6].name,
        suites[0],
        values[6].value,
        'n/a',
      ),
      new Card(
        values[11].name,
        suites[2],
        values[11].value,
        'n/a',
      )
    ];

    //reseting hand
    hand.emptyHand();

    //add cards to hand
    test_cards.forEach((card) => hand.addCard(card));


    //expect hand value is accurate
    const expectedValue = 20;
    if(hand.handValue === expectedValue){
      expect(hand.handValue).toEqual(expectedValue);
    } else {
      fail(`expected: ${expectedValue} got ${hand.handValue}`);
      console.log(`expected: ${expectedValue} got ${hand.handValue} {\n${hand.toString()}\n}`);
    }
  });

    it('should change hand value [Queen,King,Ace]', () => {
    
    const test_cards = [
      //Ace Dim
      new Card(
        values[10].name,
        suites[1],
        values[10].value,
        'n/a',
      ),
      //Hearts 7
      new Card(
        values[11].name,
        suites[2],
        values[11].value,
        'n/a',
      ),
      //Clubs 8
      new Card(
        values[12].name,
        suites[0],
        values[12].value,
        'n/a',
      )
    ];

    //reseting hand
    hand.emptyHand();

    //add cards to hand
    test_cards.forEach((card) => hand.addCard(card));


    //expect hand value is accurate
    const expectedValue = 21;
    if(hand.handValue === expectedValue){
      expect(hand.handValue).toEqual(expectedValue);
    } else {
      fail(`expected: ${expectedValue} got ${hand.handValue}`);
      console.log(`expected: ${expectedValue} got ${hand.handValue} {\n${hand.toString()}\n}`);
    }
  });

  it('should go bust [Queen,King,Ace,8]', () => {
    
    const test_cards = [
      //Ace Dim
      new Card(
        values[10].name,
        suites[1],
        values[10].value,
        'n/a',
      ),
      //Hearts 7
      new Card(
        values[11].name,
        suites[2],
        values[11].value,
        'n/a',
      ),
      //Clubs 8
      new Card(
        values[12].name,
        suites[0],
        values[12].value,
        'n/a',
      ),
      new Card(
        values[6].name,
        suites[0],
        values[6].value,
        'n/a',
      ),
    ];

    //reseting hand
    hand.emptyHand();

    //add cards to hand
    test_cards.forEach((card) => hand.addCard(card));


    //expect hand value is accurate
    const expectedValue = 29;
    if(hand.handValue === expectedValue){
      expect(hand.handValue).toEqual(expectedValue);
    } else {
      fail(`expected: ${expectedValue} got ${hand.handValue}`);
      console.log(`expected: ${expectedValue} got ${hand.handValue} {\n${hand.toString()}\n}`);
    }
  });

});
