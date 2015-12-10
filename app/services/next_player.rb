class NextPlayer
  def initialize(game_state,game)
    @game_state = game_state
    @game = game
  end

  def call
    if in_card_play_stage
      next_player_play_card
    else
      next_player_trump_select
    end
  end

  private

  def next_player_play_card
    if end_of_trick?
      winner_of_last_trick
    elsif trick_in_progress?
      left_of_last_player
    else
      left_of_dealer
    end
  end

  def in_card_play_stage
    last_operation_type == :play_card || last_operation_type == :deal_card
  end

  def next_player_trump_select
    if last_operation_type == :pass_trump
      left_of_last_player
    else
      left_of_dealer
    end
  end

  def winner_of_last_trick
    @game.operations.last(4).sort { |x,y| compare_operation_cards(x, y) }.first.player
  end

  def compare_operation_cards(op_a, op_b)
    CompareCards.new(@game_state, op_a.card, op_b.card).call
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
    index_of(last_operation.player.id)
  end

  def index_of(player_id)
    @game_state.player_index(player_id)
  end

  #FIXME maybe in game_state instead?
  def end_of_trick?
    (@game_state.pile.length == 0) && last_operation_type == :play_card
  end

  def last_operation
    @game.operations.last
  end

  def last_operation_type
    last_operation.type
  end
end
