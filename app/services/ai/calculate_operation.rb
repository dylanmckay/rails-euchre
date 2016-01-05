module AI
  class CalculateOperation

    DECIDE_TRUMP_SYMBOLS = [
      :pass_trump,
      :deal_card,
      :draw_trump
    ]

    DECIDE_PLAY_SYMBOLS = [
      :play_card,
      :discard_card
    ]

    DISCARD_WORST_CARD_SYMBOLS =[
      :accept_trump
    ]

    def initialize(game, game_state, ai_player)
      @ai_state = ai_player
      @ai = ai_player.player
      @game = game
      @game_state = game_state
    end

    def call
      # decide_operation.tap do |operation|
      #   ApplyOperation.new(@game_state, operation).call
      # end
      decide_operation
    end

    private

    def decide_operation
      if @ai_state.hand.empty?
        raise Exception, 'cannot decide an AI operation if the AI has no cards'
      end
      if DECIDE_TRUMP_SYMBOLS.include? last_operation
        decide_trump
      elsif DECIDE_PLAY_SYMBOLS.include? last_operation
        decide_play
      elsif DISCARD_WORST_CARD_SYMBOLS.include? last_operation
        discard_worst_card
      end
    end

    def last_operation
      @game.operations.last.type
    end

    def decide_play
      card = AI::CalculateCardToPlay.new(@game_state, @ai_state).call
      return if @ai_state.hand.empty?
      @ai.operations.play_card.create!(card.to_h)
    end

    def discard_worst_card
      sorted_hand = SortStack.new(@game_state, @ai_state.hand).call
      worst_card = sorted_hand.last
      @ai.operations.discard_card.create!(worst_card.to_h)
    end

    def decide_trump
      case AI::DecideTrump.new(@game_state, @ai_state).call
      when :accept then @ai.operations.accept_trump.create!
      when :pass then @ai.operations.pass_trump.create!
      end
    end
  end
end
