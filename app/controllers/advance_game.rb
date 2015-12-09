class AdvanceGame
  def initialize(game)
    @game = game
    @game_state = CreateGameState.new(@game).call
  end

  def call
    while !is_user?(ply = next_player)
      puts "NEXT PLAYER IS #{ply.name}"
      AI::DecideOperations.new(@game, @game_state, ply).call
      @game_state = CreateGameState.new(@game).call
      puts "Applying action"
    end

  end

  private

  def next_player
    if last_operation_type == :play_card || last_operation_type == :deal_card
      next_player_play_card
    else
      next_player_trump_select
    end
  end

  def next_player_play_card
    if end_of_trick?
      winner_of_last_trick
    elsif trick_in_progress?
      left_of_last_player
    else
      left_of_dealer
    end
  end

  def next_player_trump_select
    if last_operation_type == :pass_trump
      left_of_last_player
    else
      left_of_dealer
    end
  end

  def is_user?(player)
    @game_state.players[0].id == player.id
  end

  def winner_of_last_trick
    @game.operations.last(4).sort { |x,y| compare_operation_cards(x, y) }.first.player
  end

  def compare_operation_cards(op_a, op_b)
    CompareCards.new(@game_state, Card.new(op_a.suit, op_a.rank), Card.new(op_b.suit, op_b.rank)).call
  end

  def trick_in_progress?
    !@game_state.pile.empty?
  end

  def left_of_last_player
    @game.players[(index_of_last_player + 1) % @game.players.size]
  end

  def left_of_dealer
    @game.players[(index_of(@game_state.dealer.id) + 1) % @game.players.size]
  end

  def index_of_last_player
    index_of(@game.operations.last.player.id)
  end

  def index_of(player_id)
    @game_state.player_index(player_id)
  end

  #FIXME maybe in game_state instead?
  def end_of_trick?
    puts "SIZE OF GAME PILE = #{@game_state.pile.length}"
    (@game_state.pile.length == 0) && @game.operations.last.type == :play_card
  end

  def last_operation_type
    @game.operations.last.type
  end

end
