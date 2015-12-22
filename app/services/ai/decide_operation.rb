module AI
  class DecideOperation

    def initialize(game, game_state, ai_player)
      @ai_state = ai_player
      @ai = ai_player.player
      @game = game
      @game_state = game_state
    end

    def call
      op = decide_operation
      ApplyOperation.new(@game_state, op).call
      op
    end

    private

    def decide_operation
      if @ai_state.hand.empty?
        raise Exception, 'cannot decide an AI operation if the AI has no cards'
      end

      case @game.operations.last.type
      when :pass_trump then decide_trump
      when :deal_card then decide_trump
      when :draw_trump then decide_trump
      when :accept_trump then discard_worst_card #fail "accept_trump is ALWAYS followed by discard_card, nothing else"
      else decide_play
      end
    end

    def decide_play
      card = AI::DecidePlay.new(@game_state, @ai_state).call
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
