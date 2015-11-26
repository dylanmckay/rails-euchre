
class ApplyAction
  def initialize(game)
    @game = game
  end

  def call(action)

    player = @game.find_player(action.player_id)

    if action.deal_card?
      player.hand << action.card
    elsif action.pass_trump?
      # this doesn't change the game state
    elsif action.accept_trump? || action.pick_trump?

      @game.trump_suit = action.suit
    elsif action.play_card?

      card = player.hand.delete(action.card)
      @game.pile << card
    else
      fail 'unknown action'
    end
  end
end

