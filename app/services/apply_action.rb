
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

      @game.trump_suit = action.suit.to_sym
    elsif action.play_card?

      @game.pile << player.hand.delete(action.card)

      finish_round if every_player_has_played?
    else
      fail 'unknown action'
    end
  end

  private

  def finish_round
    winner = @game.round_winner

    winner.scored_cards += @game.pile
    @game.pile.clear
  end

  def every_player_has_played?
    @game.pile.length == @game.players.length
  end
end

