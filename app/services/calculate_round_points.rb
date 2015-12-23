
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
    player_picked_trump?(player) && tricks_won(player) >= winning_trick_amount
  end

  def player_picked_trump?(player)
    player.player == @game_state.trump_state.trump_selector
  end

  def winning_trick_amount
    (Config::HAND_CARD_COUNT/2.0).ceil
  end

  def tricks_won(player)
    @game_state.won_trick_count_for_player(player)
  end

  def standard_points(player)
    if tricks_won(player) == Config::HAND_CARD_COUNT
        2
    elsif tricks_won(player) >= 3
      1
    else
      0
    end
  end
end
