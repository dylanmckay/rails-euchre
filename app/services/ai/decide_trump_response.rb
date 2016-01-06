module AI
  class DecideTrumpResponse
    HAND_VALUE_SELECTION_THRESHOLD = 249

    def initialize(game_state, ai_state)
      @game_state = game_state
      @ai_state = ai_state
    end

    def call
      if should_accept_trump?
        :accept
      else
        :pass
      end
    end

    private

    def should_accept_trump?
      calculate_hand_value > HAND_VALUE_SELECTION_THRESHOLD
    end

    def calculate_hand_value
      @ai_state.hand.inject(0) do |sum, card|
        sum + CalculateCardValue.new(@game_state, card).call
      end
    end
  end
end
