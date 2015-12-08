class AdvanceGame
  def initialize(game)
    @game = game
  end

  def call
    game_state = CreateGameState.new(@game).call
    AI::DecideOperations.new(@game, game_state).call
  end
end
