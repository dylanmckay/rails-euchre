class FinishTrick
  def initialize(game_state)
    @game_state = game_state
  end

  def call
    winner = @game_state.trick_leader
    winner.scored_cards += @game_state.pile.cards
    @game_state.pile.clear
    @game_state.trick_winners << winner

    FinishRound.new(@game_state).call if every_player_has_no_cards?
  end

  private

  def every_player_has_no_cards?
    @game_state.players.map(&:hand).all?(&:empty?)
  end
end
