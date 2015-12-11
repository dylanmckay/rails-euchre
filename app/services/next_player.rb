class NextPlayer
  def initialize(game_state)
    @game_state = game_state
  end

  def call
    if selecting_trump?
      next_player_to_select_trump
    else
      next_player_to_play_card
    end
  end

  private

  def next_player_to_play_card
    if @game_state.end_of_trick?
      winner_of_last_trick
    elsif @game_state.trick_in_progress?
      left_of_last_player
    else
      left_of_dealer
    end
  end

  def selecting_trump?
    @game_state.trump_suit.nil?
  end

  def next_player_to_select_trump
    if @game_state.trump_state.selection_operations.last == :pass
      left_of_last_player
    else
      left_of_dealer
    end
  end

  def winner_of_last_trick
    @game_state.trick_winners.last
  end

  def left_of_player(player)
    @game_state.player_left_of(player)
  end

  def left_of_last_player
    left_of_player(@game_state.last_player)
  end

  def left_of_dealer
    left_of_player(@game_state.dealer)
  end
end
