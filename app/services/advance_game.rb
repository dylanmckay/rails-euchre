class AdvanceGame
  def initialize(game)
    @game = game
    @game_state = CreateGameState.new(@game).call
  end

  def call
    @game.with_lock do
      while find_next_player.player.user.ai?
        restart_round if @game_state.end_of_round? || all_passed_trump?
        
        @game.operations(reload: true)
        ApplyOperation.new(@game_state, decide_ai_operation).call
      end
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
    @game.with_lock do
      discard_player_hands

      @game_state.deck.refresh.shuffle!
      DealCards.new(@game, game_state: @game_state, deck: @game_state.deck).call

      new_trump_card = @game_state.trump_state.pop_new_trump_card
      dealer.operations.draw_trump.create!(card: new_trump_card)
    end

    @game.operations(reload: true)
  end

  def find_next_player
    FindNextPlayer.new(@game_state).call
  end

  def dealer
    @game_state.dealer.player
  end

  def discard_player_hands
   @game_state.players.each do |player|
     player.hand.each do |card|
       operation = player.player.operations.discard_card.create!(card: card)
       ApplyOperation.new(@game_state, operation).call
     end
   end
 end
end
