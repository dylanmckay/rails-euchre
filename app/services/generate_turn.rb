
class GenerateTurn
  def initialize(player_state, game_state)
    @player_state  = player_state
    @game_state = game_state
  end

  def call
    if @game_state.pile.empty? || hand_contains_better_card_than_pile?
      best_card_in_hand
    else
      worst_card_in_hand
    end
  end

  private

  def best_card_in_hand
    @game_state.best_card_in_stack(@player_state.hand)
  end

  def hand_contains_better_card_than_pile?
    hand_card = best_card_in_hand
    @game_state.highest_scoring_card(hand_card, @game_state.best_card_in_pile) == hand_card
  end

  def worst_card_in_hand
    @game_state.worst_card_in_stack(@player_state.hand)
  end
end
