
function Card(suit, rank) {
  this.suit = suit;
  this.rank = rank;

  this.getHTMLId = function() {
    return this.suit + "_" + this.rank;
  };

  this.getElement = function() {
    return $( "#" + this.getHTMLId() );
  };

  return this;
}

function removeNode(node) {
  node.remove();
}

function getPileElement() {
  $( "#pile ");
}

function removeCardFromHand(card) {
  removeNode(card.getElement());
}

function addCardToPile(card) {
  pile.innerHTML = pile.innerHTML + getSymbolForCard(card);
}

function getSymbolForCard(card) {
  switch (card.suit) {
  case "spades":
    switch (card.rank) {
      case 1: return "🂡";
      case 2: return "🂢";
      case 3: return "🂣";
      case 4: return "🂤";
      case 5: return "🂥";
      case 6: return "🂦";
      case 7: return "🂧";
      case 8: return "🂨";
      case 9: return "🂩";
      case 10: return "🂪";
      case 11: return "🂫";
      case 12: return "🂭";
      case 13: return "🂮";
    }
    break;
  case "hearts":
    switch (card.rank) {
      case 1: return "🂱";
      case 2: return "🂲";
      case 3: return "🂳";
      case 4: return "🂴";
      case 5: return "🂵";
      case 6: return "🂶";
      case 7: return "🂷";
      case 8: return "🂸";
      case 9: return "🂹";
      case 10: return "🂺";
      case 11:return "🂻";
      case 12:return "🂽";
      case 13:return "🂾";
    }
    break;
  case "diamonds":
    switch (card.rank) {
      case 1: return "🃁";
      case 2: return "🃂";
      case 3: return "🃃";
      case 4: return "🃄";
      case 5: return "🃅";
      case 6: return "🃆";
      case 7: return "🃇";
      case 8: return "🃈";
      case 9: return "🃉";
      case 10: return "🃊";
      case 11:return "🃋";
      case 12:return "🃍";
      case 13:return "🃎";
    }
    break;
  case "clubs":
    switch (card.rank) {
      case 1: return "🃑";
      case 2: return "🃒";
      case 3: return "🃓";
      case 4: return "🃔";
      case 5: return "🃕";
      case 6: return "🃖";
      case 7: return "🃗";
      case 8: return "🃘";
      case 9: return "🃙";
      case 10: return "🃚";
      case 11:return "🃛";
      case 12:return "🃝";
      case 13:return "🃞";
    }
  }
}

function play_card(game, player, suit, rank) {
  card = Card(suit, rank);

  $.ajax({
    type: "POST",
    url: "/games/" + game + "/players/" + player + "/operations",
    data: {
      operation: {
        operation_type: "play_card",
        player_id: player,
        suit: suit,
        rank: rank,
      },
    },
  });

  removeCardFromHand(card);
  addCardToPile(card);
}

