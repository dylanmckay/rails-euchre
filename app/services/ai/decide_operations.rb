module AI
  class DecideOperations

    def initialize(game, game_state)
      @game = game
      @game_state = game_state
    end

    def call
      if last_operation && last_operation.play_card?
        #make an operation based on the computer's decision
        ai_operations
      else
        []
      end
    end

    private

    def player_operation?(operation)
      operation.player_id == @game.players.first.id
    end

    def last_operation
      @game.operations.last
    end

    def ai_operations
      if player_operation?(last_operation)
        create_ai_operation_set
      else
        []
      end
    end

    def create_ai_operation_set
      @game.players[1..-1].map do |ai|
        create_ai_operation(ai)
      end
    end

    def create_ai_operation(player)
      player_state = @game_state.find_player(player.id)
      card = AI::DecidePlay.new(player_state, @game_state).call

      player.operations.create!(
        operation_type: "play_card",
        suit: card.suit,
        rank: card.rank
      )
    end
  end
end
