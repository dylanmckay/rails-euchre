class CalculateRoundPoints
  TRICK_WON_AMOUNT = (Player::INITIAL_CARD_COUNT/2.0).ceil
  MARCH_POINTS = 2
  TRICK_WON_POINTS = 1
  EUCHRED_BONUS_POINTS = 2

  def initialize(game_state)
    @game_state = game_state
  end

  def call
    @game_state.players.map do |player|
      player_points(player)
    end
  end

  private

  def player_points(player)
    standard_points(player) + bonus_points(player)
  end

  def standard_points(player)
    if player_won_trick_with_march?(player)
      MARCH_POINTS
    elsif player_won_trick?(player)
      TRICK_WON_POINTS
    else
      0
    end
  end

  def bonus_points(player)
    euchred_other_player?(player) ? EUCHRED_BONUS_POINTS : 0
  end

  def euchred_other_player?(player)
    !player_picked_trump?(player) && player_won_trick?(player)
  end

  def player_won_trick?(player)
    won_trick_count_for_player(player) >= TRICK_WON_AMOUNT
  end

  def player_won_trick_with_march?(player)
    won_trick_count_for_player(player) == winning_trick_march_amount
  end

  def player_picked_trump?(player)
    player.model == @game_state.trump_state.trump_chooser
  end

  def winning_trick_march_amount
    Player::INITIAL_CARD_COUNT
  end

  def won_trick_count_for_player(player)
    player.scored_cards.length / @game_state.players.length
  end
end
