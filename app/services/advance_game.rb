class AdvanceGame
  def initialize(game)
    @game = game
    @game_state = CreateGameState.new(@game).call
  end

  def call
    while whose_turn_next.ai?
      restart_round if @game_state.start_of_round?

      decide_ai_operation
    end
  end

  private

  def decide_ai_operation
    ai = whose_turn_next

    AI::DecideOperations.new(@game, @game_state, ai).call
    @game.operations(reload: true)
  end

  def restart_round
    DealCards.new(@game, game_state: @game_state).call
    @game.operations(reload: true)
  end

  def whose_turn_next
    p = NextPlayer.new(@game_state).call
    fail if !p
    p
  end
end
