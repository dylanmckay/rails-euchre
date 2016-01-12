module AI
  class CalculateCardToPlay
    def initialize(game_state, ai_state)
      @ai_state  = ai_state
      @game_state = game_state
    end

    def call
      if play_best_card?
        best_card_in_hand
      elsif hand_contains_any_leading_suit?
        worst_leading_card_in_hand
      else
        worst_card_in_hand
      end
    end

    private

    def play_best_card?
      @game_state.pile.empty? ||
        hand_contains_better_leading_suit? ||
        hand_contains_better_trump_without_leading?
    end

    def hand_contains_better_leading_suit?
      if hand_contains_any_leading_suit?
        card_is_better_than_pile?(best_leading_card_in_hand)
      else
        false
      end
    end

    def card_is_better_than_pile?(card)
      card == SortStack.new(@game_state, @game_state.pile.cards + [card]).call.first
    end

    def hand_contains_better_trump_without_leading?
      @game_state.trump?(best_card_in_hand) && !hand_contains_any_leading_suit?
    end

    def hand_contains_any_leading_suit?
      @ai_state.hand.any? { |card| card.suit == leading_suit }
    end

    def leading_suit
      @game_state.pile.cards.first.suit
    end

    def best_card_in_hand
      SortStack.new(@game_state, @ai_state.hand).call.first
    end

    def best_leading_card_in_hand
      SortStack.new(@game_state, leading_cards_in_hand).call.first
    end

    def leading_cards_in_hand
      @ai_state.hand.select { |card| card.suit == leading_suit }
    end

    def worst_leading_card_in_hand
      SortStack.new(@game_state, leading_cards_in_hand).call.last
    end

    def worst_card_in_hand
      SortStack.new(@game_state, @ai_state.hand).call.last
    end
  end
end
