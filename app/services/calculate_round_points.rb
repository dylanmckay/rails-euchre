
class CalculateRoundPoints
  def initialize(game_state)
    @game_state = game_state
  end

  def call
    @game_state.players.map do |player|
      player_points(player)
    end
  end

  def player_points(player)
    standard_points(player) + bonus_points(player)
  end

  def bonus_points(player)
    if euchred_other_player?(player)
      2
    else
      0
    end
  end

  def euchred_other_player?(player)
    !player_picked_trump?(player) && won_trick_count_for_player(player) >= winning_trick_amount
  end

  def player_picked_trump?(player)
    player.player == @game_state.trump_state.trump_selector
  end

  def winning_trick_amount
    (Config::HAND_CARD_COUNT/2.0).ceil
  end

  def winning_trick_march_amount
    Config::HAND_CARD_COUNT
  end

  def standard_points(player)
    if won_trick_count_for_player(player) == winning_trick_march_amount
        2
    elsif won_trick_count_for_player(player) >= winning_trick_amount
      1
    else
      0
    end
  end

  def won_trick_count_for_player(player)
    player.scored_cards.length / @game_state.players.length
  end
end
