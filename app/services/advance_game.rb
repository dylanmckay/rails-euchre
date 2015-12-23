class AdvanceGame
  def initialize(game)
    @game = game
    @game_state = CreateGameState.new(@game).call
  end

  def call
    while find_next_player.player.user.ai?
      restart_round if @game_state.start_of_round?  || all_passed_trump?
      @game.operations(reload: true)
      decide_ai_operation
    end
    restart_round if @game_state.start_of_round? || all_passed_trump?
  end

  private

  def decide_ai_operation
    AI::DecideOperation.new(@game, @game_state, find_next_player).call
  end

  def all_passed_trump?
    @game.operations.last(@game.players.size).all?(&:pass_trump?)
  end

  def restart_round
    discard_player_hands
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
    @game_state.dealer.player
  end

  def discard_player_hands
    puts "DISCARDING CARDS FROM PLAYER"
    @game_state.players.each do |player|
      player.hand.each do |card|
        player.player.operations.discard_card.create!(suit: card.suit, rank: card.rank)
      end
    end
  end
end
