class AdvanceGame
  def initialize(game)
    @game = game
    @game_state = CreateGameState.new(@game).call
  end

  def call
    while !is_user?(ply = NextPlayer.new(@game_state, @game).call)
      puts "PLAYING TURN FOR #{ply.name}"
      AI::DecideOperations.new(@game, @game_state, ply).call
      @game_state = CreateGameState.new(@game).call
      @game.operations(reload: true)
    end
    puts "END OF LOOP"
  end

  private

  def is_user?(player)
    @game.main_player == player
  end
end
