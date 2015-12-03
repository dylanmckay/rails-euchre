
class GenerateTurn
  def initialize(player_state, game_state)
    @player_state  = player_state
    @game_state = game_state
  end

  def call
    if @game_state.pile.empty? || hand_contains_better_leading_suit? || hand_contains_better_trump_without_leading?
      best_card_in_hand
    elsif hand_contains_any_leading_suit?
      worst_leading_card_in_hand
    else
      worst_card_in_hand
    end
  end

  private

  def hand_contains_better_leading_suit?
    if hand_contains_any_leading_suit?
      best_leading = best_leading_card_in_hand
      best_leading == SortStack.new(@game_state, @game_state.pile.cards + [best_leading]).call.first
    else
      false
    end
  end

  def hand_contains_better_trump_without_leading?
    @game_state.is_trump?(best_card_in_hand) && !hand_contains_any_leading_suit?
  end

  def hand_contains_any_leading_suit?
    @player_state.hand.any? { |card| card.suit == leading_suit }
  end

  def leading_suit
    @game_state.pile.cards.first.suit
  end

  def best_card_in_hand
    SortStack.new(@game_state, @player_state.hand).call.first
  end

  def best_leading_card_in_hand
    SortStack.new(@game_state, leading_cards_in_hand).call.first
  end

  def leading_cards_in_hand
    @player_state.hand.select{ |card| card.suit == leading_suit }
  end

  def worst_leading_card_in_hand
    SortStack.new(@game_state, leading_cards_in_hand).call.last
  end

  def worst_card_in_hand
    SortStack.new(@game_state, @player_state.hand).call.last
  end
end
