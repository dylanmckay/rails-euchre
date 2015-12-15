class AdvanceGame
  def initialize(game)
    @game = game
    @game_state = CreateGameState.new(@game).call
  end

  def call
    while find_next_player.ai?
      restart_round if @game_state.start_of_round?
      @game.operations(reload: true)
      decide_ai_operation
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

    @game.operations(reload: true)
    dealer.operations.draw_trump.create!(new_trump_card.to_h)
  end

  def find_next_player
     NextPlayer.new(@game_state).call
  end

  def dealer
    @game.players.find(@game_state.dealer.id)
  end
end
