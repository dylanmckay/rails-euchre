class GenerateTurn
  def initialize(player_state, game_state)
    @player  = player_state
    @game = game_state
  end

  def card_to_play
    if @game.pile.empty?

      best_card_in_hand
    else
      if hand_contains_better_card_than_pile?
        return best_card_in_hand
      else
        return worst_card_in_hand
      end
    end
  end

  private

  def best_card_in_hand
    @game.best_card(@player.hand)
  end

  def hand_contains_better_card_than_pile?
    hand_card = best_card_in_hand
    @game.highest_scoring_card(hand_card, best_card_in_pile) == hand_card
  end

  def best_card_in_pile
    @game.best_card
  end

  def worst_card_in_hand
    @game.worst_card(@player.hand)
  end
end
