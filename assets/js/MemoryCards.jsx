class MemoryCards {
  constructor() {
    this.cards = [];
    this.letters = ["A", "A", "B", "B", "C", "C", "D", "D", "E", "E", "F", "F", "G", "G", "H", "H"];
  }

  // Shuffle cards
  shuffle(arr) {
    let i, j, x;
    for (i = arr.length - 1; i > 0; i--) {
      j = Math.floor(Math.random() * (i + 1));
      x = arr[i];
      arr[i] = arr[j];
      arr[j] = x;
    }
    return arr;
  }

  // Generates array of cards
  genCards() {
    this.cards = [];
    for(let i = 0; i < this.letters.length; i++) {
      let card = {
	id: i,
	letter: this.letters[i],
	showFace: false,
	matched: false
      };
      this.cards.push(card)
    }
    this.shuffle(this.cards)
  }

  // Toggle card's showFace
  toggleCard(id, showFace) {
    this.getCard(id).showFace = showFace;
  }

  // Toggle card's matched
  setMatched(id, matched) {
    this.getCard(id).matched = matched;
  }

  // Returns the card with the given id
  getCard(id) {
    for(let i = 0; i < this.cards.length; i++) {
      if(this.cards[i].id === id) {
	return this.cards[i];
      }
    };
  }

  // Returns true if the cards' letters match, false otherwise
  matchCards(card1, card2) {
    if(card1.letter === card2.letter) {
      return true;
    } else {
      return false;
    }
  }
}

export default MemoryCards;
