class AdvanceGame
  def initialize(game)
    @game = game
    @game_state = CreateGameState.new(@game).call
  end

  def call
    while find_next_player.ai?
      restart_round if @game_state.start_of_round?

      decide_ai_operation
      @game.operations(reload: true)
    end
    restart_round if @game_state.start_of_round?
  end

  private

  def decide_ai_operation

    ai = find_next_player
    @game.operations(reload: true)
    AI::DecideOperations.new(@game, @game_state, ai).call
  end

  def restart_round
    # @game_state.deck.refresh.shuffle
    puts "refresing deck then dealing"
    @game_state.deck.refresh
    @game_state.deck.shuffle
    DealCards.new(@game, game_state: @game_state, deck:@game_state.deck).call
    @game_state.trump_state.restart_selection
    @game.operations(reload: true)
  end

  def find_next_player
    p = NextPlayer.new(@game_state).call
    fail if !p
    p
  end
end
