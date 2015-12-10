module AI
  # TODO: Remove the plural as we only decide a single operation
  class DecideOperations

    def initialize(game, game_state, ai_player)
      @ai = ai_player
      @game = game
      @game_state = game_state
    end

    def call
      op = decide_operation(@ai)
      ApplyOperation.new(@game_state, op).call
      op
    end

    private

    def decide_operation(ai)
      ai_state = @game_state.find_player(ai.id)

      if ai_state.hand.empty?
        raise Exception, 'cannot decide an AI operation if the AI has no cards'
      end

      case @game.operations.last.type
      when :play_card then decide_play(ai, ai_state)
      when :pass_trump then decide_trump(ai, ai_state)
      when :accept_trump then decide_play(ai, ai_state)
      when :deal_card then decide_play(ai, ai_state)
      end
    end

    def decide_play(ai, ai_state)
      card = AI::DecidePlay.new(@game_state, ai_state).call
      return if ai_state.hand.empty?
      ai.operations.play_card.create!(card.to_h)
    end

    def decide_trump(ai, ai_state)
      case AI::DecideTrump.new(@game_state, ai_state).call
      when :accept then ai.operations.accept_trump.create!
      when :pass then ai.operations.pass_trump.create!
      end
    end
  end
end
