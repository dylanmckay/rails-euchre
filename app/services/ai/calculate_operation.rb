module AI
  class CalculateOperation
    DECIDE_TRUMP_REPONSE_SYMBOLS = [
      :pass_trump,
      :deal_card,
      :draw_trump
    ]

    CALCULATE_PLAY_SYMBOLS = [
      :play_card,
      :discard_card
    ]

    DISCARD_WORST_CARD_SYMBOLS = [
      :accept_trump
    ]

    def initialize(game, game_state, ai_player)
      @ai_state = ai_player
      @ai = ai_player.player
      @game = game
      @game_state = game_state
    end

    def call
      raise 'cannot decide an AI operation if the AI has no cards' if @ai_state.hand.empty?

      if DECIDE_TRUMP_REPONSE_SYMBOLS.include?(last_operation_type)
        decide_trump_response
      elsif CALCULATE_PLAY_SYMBOLS.include?(last_operation_type)
        calculate_card_to_play
      elsif DISCARD_WORST_CARD_SYMBOLS.include?(last_operation_type)
        discard_worst_card
      end
    end

    private

    def last_operation_type
      @game.operations.last.type
    end

    def calculate_card_to_play
      card_to_play = AI::CalculateCardToPlay.new(@game_state, @ai_state).call
      @ai.operations.play_card.create!(card: card_to_play)
    end

    def discard_worst_card
      sorted_hand = SortStack.new(@game_state, @ai_state.hand).call
      worst_card = sorted_hand.last
      @ai.operations.discard_card.create!(card: worst_card)
    end

    def decide_trump_response
      case AI::DecideTrumpResponse.new(@game_state, @ai_state).call
      when :accept then @ai.operations.accept_trump.create!
      when :pass then @ai.operations.pass_trump.create!
      end
    end
  end
end
