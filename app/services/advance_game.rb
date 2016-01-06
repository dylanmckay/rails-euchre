class AdvanceGame
  def initialize(game)
    @game = game
    @game_state = CreateGameState.new(@game).call
  end

  def call
    while find_next_player.player.user.ai?
      restart_round if @game_state.end_of_round? || all_passed_trump?
      @game.operations(reload: true)
      ApplyOperation.new(@game_state, decide_ai_operation).call
    end

    restart_round if @game_state.end_of_round? || all_passed_trump?
  end

  private

  def decide_ai_operation
    AI::CalculateOperation.new(@game, @game_state, find_next_player).call
  end

  def all_passed_trump?
    @game.operations.last(@game.players.size).all?(&:pass_trump?)
  end

  def restart_round
    @game_state.deck.refresh.shuffle!
    DealCards.new(@game, game_state: @game_state, deck: @game_state.deck).call

    new_trump_card = @game_state.trump_state.pop_new_trump_card
    dealer.operations.draw_trump.create!(card: new_trump_card)
    @game.operations(reload: true)
  end

  def find_next_player
     FindNextPlayer.new(@game_state).call
  end

  def dealer
    @game_state.dealer.player
  end
end
