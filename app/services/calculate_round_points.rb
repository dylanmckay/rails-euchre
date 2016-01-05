class CalculateRoundPoints
  def initialize(game_state)
    @game_state = game_state
  end

  def call
    @game_state.players.map do |player_state|
      player_state_points(player_state)
    end
  end

  private

  def player_state_points(player_state)
    standard_points(player_state) + bonus_points(player_state)
  end

  def standard_points(player_state)
    if player_won_trick_with_march?(player_state)
      2
    elsif player_won_trick?(player_state)
      1
    else
      0
    end
  end

  def bonus_points(player_state)
    euchred_other_player_state?(player_state) ? 2 : 0
  end

  def euchred_other_player_state?(player_state)
    !player_state_picked_trump?(player_state) && player_won_trick?(player_state)
  end

  def player_won_trick?(player_state)
    won_trick_count_for_player(player_state) >= winning_trick_amount
  end

  def player_won_trick_with_march?(player_state)
    won_trick_count_for_player(player_state) == winning_trick_march_amount
  end

  def player_state_picked_trump?(player_state_state)
    player_state_state.player == @game_state.trump_state.trump_selector
  end

  def winning_trick_amount
    Config::TRICK_WON_AMOUNT
  end

  def winning_trick_march_amount
    Config::HAND_CARD_COUNT
  end

  def won_trick_count_for_player(player_state)
    player_state.scored_cards.length / @game_state.players.length
  end
end
