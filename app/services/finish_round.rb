class FinishRound
  def initialize(game_state)
    @game_state = game_state
  end

  def call
    @game_state.round_winners << @game_state.round_leader

    player_points = CalculateRoundPoints.new(@game_state).call

    @game_state.players.zip(player_points) do |player, points|
      player.total_score += points
      player.scored_cards.clear
    end

    @game_state.trick_winners.clear

    assign_next_dealer
  end

  private

  def assign_next_dealer
    index = current_dealer_index

    # get the next player, wrapping the index back to the start
    next_index = (index+1) % @game_state.players.length

    @game_state.dealer = @game_state.players[next_index]
  end

  def current_dealer_index
    @game_state.players.find_index do |player|
      player == @game_state.dealer
    end
  end
end
