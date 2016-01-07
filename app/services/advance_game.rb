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
    discard_player_hands

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

  #TODO merge these with a transaction because of multiple things
  def discard_player_hands
   discards = @game_state.players.flat_map do |player|
     player.hand.map do |card|
       player.player.operations.discard_card.create!(card: card)
     end
   end

   discards.each do |op|
     ApplyOperation.new(@game_state, op).call
   end
 end
end
