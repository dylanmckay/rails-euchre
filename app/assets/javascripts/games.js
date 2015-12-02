
function play_card(game, player, suit, rank) {

  $.ajax({
    type: "POST",
    url: "/games/" + game + "/players/" + player + "/operations",
    data: {
      operation: {
        operation_type: "play_card",
        suit: suit,
        rank: rank,
      },
    },
  });
}
