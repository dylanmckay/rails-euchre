
class ApplyAction
  def initialize(game)
    @game = game
  end

  def call(action)
    if action.pass_trump?
      # this doesn't change the game state
    elsif action.accept_trump? || action.pick_trump?

      @game.trump_suit = action.suit
    elsif action.play_card?
      player = @game.find_player(action.player_id)

      card = player.hand.remove(action.card)
      @game.pile << card
    else
      fail 'unknown action'
    end
  end
end

