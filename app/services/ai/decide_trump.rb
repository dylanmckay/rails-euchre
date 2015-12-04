module AI
  class DecideTrump
    HAND_VALUE_SELECTION_THRESHOLD = 400
    
    def initialize(game_state, player, trump_suit)
      @game_state = game_state
      @player = player
      @trump_suit = trump_suit
    end

    def call
      hand_value > HAND_VALUE_SELECTION_THRESHOLD
    end

    def hand_value
      @player.hand.inject do |sum,card|
        sum += CalculateCardValue.new(@game_state, card).call
      end
    end
  end
end
