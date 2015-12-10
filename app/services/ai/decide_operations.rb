module AI
  class DecideOperations

    def initialize(game, game_state, ai_player)
      @ai = ai_player
      @game = game
      @game_state = game_state
    end

    def call
      # dealer_index = @game_state.player_index(@game_state.dealer.id)
      # @game.players[dealer_index+1..-1].each { |ai| decide_operation(ai) }
      decide_operation(@ai)
    end

    private

    def decide_operation(ai)
      ai_state = @game_state.find_player(ai.id)

      case @game.operations.last.type
      when :play_card then decide_play(ai, ai_state)
      when :pass_trump then decide_trump(ai, ai_state)
      when :accept_trump then decide_play(ai, ai_state)
      when :deal_card then decide_play(ai, ai_state)
      else
        puts "SOMETHING IS ODD #{@game.operations.last.type}"
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
