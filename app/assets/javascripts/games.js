
function play_card(game, player, suit, rank) {

  $.ajax({
    type: "POST",
    url: "/games/" + game + "/players/" + player + "/actions",
    data: {
      action: {
        action_type: "play_card",
        suit: suit,
        rank: rank,
      },
    },
  });
}
