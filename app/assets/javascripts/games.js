
function play_card(game, player, suit, rank) {
  alert("Player ID: " + player + " played " + rank + " of " + suit);

  args = "?action_type=play_card&suit=" + suit + "&rank=" + rank;

  window.location = "/games/" + game + "/players/" + player + "/actions/create" + args;
}
