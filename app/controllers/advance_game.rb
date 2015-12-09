class AdvanceGame
  def initialize(game)
    @game = game
    @game_state = CreateGameState.new(@game).call
  end

  def call
    while !is_user?(ply = NextPlayer.new(@game_state,@game).call)
      AI::DecideOperations.new(@game, @game_state, ply).call
      @game_state = CreateGameState.new(@game).call
    end
  end

  private

  def is_user?(player)
    @game_state.players[0].id == player.id
  end
end
