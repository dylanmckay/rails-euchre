
function play_card(game, player, suit, rank) {
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
  location.reload();
}
