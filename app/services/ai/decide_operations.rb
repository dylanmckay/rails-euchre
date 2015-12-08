module AI
  class DecideOperations

    def initialize(game, game_state)
      @game = game
      @game_state = game_state
    end

    def call
      ai_players.map { |ai| decide_operation(ai) }
    end

    private

    def ai_players
      @game.players[1..-1]
    end

    def decide_operation(ai)
      ai_state = @game_state.find_player(ai.id)
      card = AI::DecidePlay.new(ai_state, @game_state).call

      ai.operations.create!(
        operation_type: "play_card",
        suit: card.suit,
        rank: card.rank
      )
    end
  end
end
