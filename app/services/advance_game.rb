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
    AI::DecideOperation.new(@game, @game_state, find_next_player).call
  end

  def restart_round
    @game_state.deck.refresh.shuffle

    DealCards.new(@game, game_state: @game_state, deck:@game_state.deck).call

    new_trump_card = @game_state.trump_state.pop_new_trump_card
    dealer.operations.create!(
      operation_type: "draw_trump",
      suit: new_trump_card.suit,
      rank: new_trump_card.rank
    )
    @game.operations(reload: true)
  end

  def find_next_player
    NextPlayer.new(@game_state).call
  end

  def dealer
    @game.players.find(@game_state.dealer.id)
  end
end
