class AdvanceGame
  def initialize(game)
    @game = game
    @game_state = CreateGameState.new(@game).call
  end

  def call
    if !@game_state.round_in_progress?
      DealCards.new(@game, game_state: @game_state).call
    end

    while whose_turn_next.ai?
      advance
    end
  end

  private

  def advance
    if @game_state.round_in_progress?
      puts "deciding"
      decide_ai_operation
    else
      puts "restarting"
      restart_round
    end
  end

  def decide_ai_operation
    ai = whose_turn_next

    AI::DecideOperations.new(@game, @game_state, ai).call
    @game.operations(reload: true)
  end

  def restart_round
    DealCards.new(@game, game_state: @game_state).call
  end

  def whose_turn_next
    NextPlayer.new(@game_state, @game).call
  end
end
