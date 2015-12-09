module AI
  class DecideOperations

    def initialize(game, game_state)
      @game = game
      @game_state = game_state
    end

    def call
      @game.ai_players.map { |ai| decide_operation(ai) }
    end

    private

    def decide_operation(ai)
      ai_state = @game_state.find_player(ai.id)

      case @game.operations.last.type
      when :play_card then decide_play(ai, ai_state)
      when :pass_trump then decide_trump(ai, ai_state)
      end
    end

    def decide_play(ai, ai_state)
      card = AI::DecidePlay.new(@game_state, ai_state).call

      ai.operations.play_card!(card)
    end

    def decide_trump(ai, ai_state)
      case AI::DecideTrump.new(@game_state, ai_state)
      when :accept then ai.operations.accept_trump!
      when :pass then ai.operations.pass_trump!
      end
    end
  end
end
