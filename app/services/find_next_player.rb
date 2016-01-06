class FindNextPlayer
  def initialize(game_state)
    @game_state = game_state
  end

  def call
    case @game_state.current_phase
    when :trump_selection then next_player_to_select_trump
    when :discard then @game_state.dealer
    else next_player_to_play_card
    end
  end

  private

  def next_player_to_play_card
    if @game_state.start_of_round?
      left_of_dealer
    elsif @game_state.start_of_trick?
      last_winner = winner_of_last_trick

      last_winner || left_of_dealer
    else
      left_of_last_player
    end
  end

  def next_player_to_select_trump
    if @game_state.trump_state.selection_operations.empty?
      left_of_dealer
    else
      left_of_last_player
    end
  end

  def winner_of_last_trick
    @game_state.trick_winners.last
  end

  def left_of_last_player
    @game_state.player_left_of(@game_state.last_player)
  end

  def left_of_dealer
    @game_state.player_left_of(@game_state.dealer)
  end
end
